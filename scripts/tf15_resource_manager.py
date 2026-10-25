#!/usr/bin/env python3
"""Prepare this branch for OCI Resource Manager Terraform 1.5.7.

prepare: pin required_version and move cross-variable validation into check blocks.
sync: rebuild examples/resource-manager from each module's basic example.
"""

from __future__ import annotations

import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERSION = '>= 1.5.0, < 1.6.0'
OLD_VERSION = '>= 1.14.2'
PROVIDER = '~> 9.11'

PRIMITIVE_TYPES = {
    "string",
    "number",
    "bool",
    "list(string)",
    "set(string)",
    "list(number)",
    "map(string)",
}


def modules() -> list[Path]:
    found = []
    for path in sorted(ROOT.glob("*/main.tf")):
        if path.parent.name.startswith("."):
            continue
        found.append(path.parent)
    return found


def balanced_end(text: str, open_brace: int) -> int:
    depth = 0
    for i in range(open_brace, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return i + 1
    raise ValueError("unbalanced braces")


def top_blocks(text: str, keyword: str) -> list[tuple[str, int, int, int, str]]:
    pattern = re.compile(rf'(?m)^{keyword}\s+"([^"]+)"\s*\{{')
    blocks = []
    for match in pattern.finditer(text):
        end = balanced_end(text, match.end() - 1)
        body_start = match.end()
        blocks.append((match.group(1), match.start(), end, body_start, text[body_start : end - 1]))
    return blocks


def inner_blocks(body: str, keyword: str, base: int) -> list[tuple[int, int, str]]:
    pattern = re.compile(rf"(?m)^[ \t]*{keyword}\s*\{{")
    found = []
    for match in pattern.finditer(body):
        rel_end = balanced_end(body, match.end() - 1)
        found.append((base + match.start(), base + rel_end, body[match.end() : rel_end - 1]))
    return found


def referenced_vars(expr: str) -> set[str]:
    return set(re.findall(r"\bvar\.([A-Za-z0-9_]+)", expr))


def parse_validation(body: str) -> tuple[str, str]:
    match = re.search(
        r"condition\s*=\s*(.*?)\n\s*error_message\s*=\s*(\"(?:\\.|[^\"\\])*\"|'(?:\\.|[^'\\])*')",
        body,
        re.S,
    )
    if not match:
        raise ValueError(f"unparsed validation:\n{body}")
    condition = match.group(1).strip()
    raw = match.group(2)
    if raw[0] == '"':
        message = json.loads(raw)
    else:
        message = raw[1:-1].replace("\\'", "'")
    return condition, message


def prepare() -> None:
    replaced = 0
    for path in ROOT.rglob("*.tf"):
        if ".terraform" in path.parts:
            continue
        text = path.read_text()
        updated = text.replace(
            f'required_version = "{OLD_VERSION}"',
            f'required_version = "{VERSION}"',
        )
        if updated != text:
            path.write_text(updated)
            replaced += 1
    print(f"required_version updated in {replaced} files")

    moved = 0
    for path in ROOT.rglob("*.tf"):
        if ".terraform" in path.parts or "resource-manager" in path.parts:
            continue
        text = path.read_text()
        removals: list[tuple[int, int]] = []
        checks: list[str] = []
        seen: dict[str, int] = {}
        for name, _start, _end, body_start, body in top_blocks(text, "variable"):
            for abs_start, abs_end, val_body in inner_blocks(body, "validation", body_start):
                others = referenced_vars(val_body) - {name}
                if not others:
                    continue
                condition, message = parse_validation(val_body)
                line_start = text.rfind("\n", 0, abs_start) + 1
                removals.append((line_start, abs_end))
                seen[name] = seen.get(name, 0) + 1
                suffix = "" if seen[name] == 1 else f"_{seen[name]}"
                check_name = f"{name}_related_inputs{suffix}"
                checks.append(
                    "\n".join(
                        [
                            f'check "{check_name}" {{',
                            "  assert {",
                            f"    condition     = {condition}",
                            f"    error_message = {json.dumps(message)}",
                            "  }",
                            "}",
                            "",
                        ]
                    )
                )
                moved += 1
        if not removals:
            continue
        for start, end in sorted(removals, reverse=True):
            text = text[:start] + text[end:]
        text = text.rstrip() + "\n\n" + "\n".join(checks)
        path.write_text(text)
        print(f"moved {len(checks)} check(s) in {path.relative_to(ROOT)}")
    print(f"cross-variable validations moved: {moved}")


def strip_terraform_block(text: str) -> str:
    match = re.search(r"(?m)^terraform\s*\{", text)
    if not match:
        return text
    end = balanced_end(text, match.end() - 1)
    return (text[: match.start()] + text[end:]).lstrip("\n")


def read_type(body: str) -> str:
    match = re.search(r"\btype\s*=\s*", body)
    if not match:
        return "string"
    i = match.end()
    while i < len(body) and body[i].isspace():
        i += 1
    start = i
    depth = 0
    while i < len(body):
        char = body[i]
        if char in "({[":
            depth += 1
        elif char in ")}]":
            if depth == 0:
                break
            depth -= 1
        elif char == "\n" and depth == 0:
            break
        elif char == "#" and depth == 0:
            break
        i += 1
    return re.sub(r"\s+", " ", body[start:i].strip())


def read_description(body: str) -> str:
    match = re.search(r'\bdescription\s*=\s*("(?:\\.|[^"\\])*")', body)
    if not match:
        return ""
    return json.loads(match.group(1))


def has_default(body: str) -> bool:
    return re.search(r"(?m)^[ \t]*default\s*=", body) is not None


def simple_default(body: str):
    match = re.search(r"(?m)^[ \t]*default\s*=\s*([^\n#]+)", body)
    if not match:
        return None
    raw = match.group(1).strip()
    if raw in {"[]", "{}", "null", "true", "false"}:
        return json.loads(raw.replace("true", "true").replace("false", "false").replace("null", "null"))
    if re.fullmatch(r"-?\d+(\.\d+)?", raw):
        return json.loads(raw)
    if raw.startswith('"') and raw.endswith('"'):
        return json.loads(raw)
    return None


def schema_for_variable(name: str, body: str) -> dict | None:
    tf_type = read_type(body).replace(" ", "")
    description = read_description(body)
    entry: dict = {"title": name.replace("_", " "), "description": description or name}
    sensitive = bool(re.search(r"(?m)^[ \t]*sensitive\s*=\s*true", body)) or "password" in name
    if name in {"compartment_ocid", "compartment_id"}:
        entry["type"] = "oci:identity:compartment:id"
    elif name == "region":
        entry["type"] = "oci:identity:region:name"
    elif sensitive and tf_type == "string":
        entry["type"] = "password"
    elif tf_type == "string":
        entry["type"] = "string"
    elif tf_type == "number":
        entry["type"] = "number"
    elif tf_type == "bool":
        entry["type"] = "boolean"
    elif tf_type in {"list(string)", "set(string)"}:
        entry["type"] = "array"
        entry["items"] = {"type": "string"}
    elif tf_type == "list(number)":
        entry["type"] = "array"
        entry["items"] = {"type": "number"}
    elif tf_type == "map(string)":
        entry["type"] = "map"
    else:
        return None
    if has_default(body):
        entry["required"] = False
        default = simple_default(body)
        if default is not None:
            entry["default"] = default
    else:
        entry["required"] = True
    return entry


def yaml_quote(value) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if value is None:
        return "null"
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return str(value)
    if isinstance(value, list):
        if not value:
            return "[]"
        return json.dumps(value)
    if isinstance(value, dict):
        if not value:
            return "{}"
        return json.dumps(value)
    return json.dumps(str(value))


def dump_schema(data: dict) -> str:
    lines = [
        f"title: {yaml_quote(data['title'])}",
        f"description: {yaml_quote(data['description'])}",
        "schemaVersion: 1.1.0",
        'version: "1.0.0"',
        "locale: en",
        "variableGroups:",
    ]
    for group in data["variableGroups"]:
        lines.append(f"  - title: {yaml_quote(group['title'])}")
        lines.append("    variables:")
        for name in group["variables"]:
            lines.append(f"      - {name}")
    lines.append("variables:")
    for name, spec in data["variables"].items():
        lines.append(f"  {name}:")
        lines.append(f"    type: {spec['type']}")
        lines.append(f"    title: {yaml_quote(spec['title'])}")
        lines.append(f"    description: {yaml_quote(spec['description'])}")
        lines.append(f"    required: {yaml_quote(spec['required'])}")
        if "default" in spec:
            lines.append(f"    default: {yaml_quote(spec['default'])}")
        if "items" in spec:
            lines.append("    items:")
            lines.append(f"      type: {spec['items']['type']}")
    lines.append("outputs:")
    for name, spec in data["outputs"].items():
        lines.append(f"  {name}:")
        lines.append(f"    type: {spec['type']}")
        lines.append(f"    title: {yaml_quote(spec['title'])}")
    lines.append("")
    return "\n".join(lines)


def output_specs(text: str) -> dict[str, dict]:
    specs = {}
    for name, _s, _e, _body_start, body in top_blocks(text, "output"):
        if name.endswith("_ids"):
            kind = "csv"
        elif name.endswith("_id") or name.endswith("_ocid"):
            kind = "ocid"
        else:
            kind = "string"
        description = read_description(body) or name.replace("_", " ")
        specs[name] = {"type": kind, "title": description}
    return specs


def vendor_modules(example_dir: Path, main_text: str, dest: Path) -> str:
    pattern = re.compile(r'source\s*=\s*"(\.\./[^"]*)"')

    def replacer(match: re.Match) -> str:
        relative = match.group(1)
        source = (example_dir / relative).resolve()
        if not (source / "main.tf").is_file() and not list(source.glob("*.tf")):
            raise SystemExit(f"module source not found: {relative} from {example_dir}")
        target = dest / "modules" / source.name
        target.mkdir(parents=True, exist_ok=True)
        for tf in source.glob("*.tf"):
            shutil.copy2(tf, target / tf.name)
        return f'source = "./modules/{source.name}"'

    return pattern.sub(replacer, main_text)


def ensure_readme_pointer(module_dir: Path) -> None:
    readme = module_dir / "README.md"
    if not readme.is_file():
        return
    text = readme.read_text()
    marker = "## Resource Manager"
    section = (
        "## Resource Manager\n\n"
        "`examples/resource-manager` is a stack for OCI Resource Manager on Terraform 1.5.x. "
        "Zip that directory (do not include `.terraform`) and upload it as a stack. "
        "Choose Terraform 1.5.x. Resource Manager fills the tenancy and region. "
        "Set the compartment and the remaining required fields, then plan and apply.\n\n"
    )
    if marker in text:
        return
    token = "<!-- BEGIN_TF_DOCS -->"
    if token in text:
        text = text.replace(token, section + token, 1)
    else:
        text = text.rstrip() + "\n\n" + section
    readme.write_text(text)


def sync() -> None:
    for module_dir in modules():
        example = module_dir / "examples" / "basic"
        if not (example / "main.tf").is_file():
            example = module_dir / "examples" / "complete"
        if not (example / "main.tf").is_file():
            raise SystemExit(f"no example for {module_dir.name}")
        dest = module_dir / "examples" / "resource-manager"
        if dest.exists():
            shutil.rmtree(dest)
        dest.mkdir(parents=True)
        (dest / "modules").mkdir()

        main = strip_terraform_block((example / "main.tf").read_text())
        main = vendor_modules(example, main, dest)
        main = main.replace("var.compartment_id", "var.compartment_ocid")
        (dest / "main.tf").write_text(main)

        variables = ""
        if (example / "variables.tf").is_file():
            variables = (example / "variables.tf").read_text()
            variables = variables.replace('variable "compartment_id"', 'variable "compartment_ocid"')
            variables = variables.replace("var.compartment_id", "var.compartment_ocid")
        if 'variable "region"' not in variables:
            variables += (
                '\nvariable "region" {\n'
                "  type        = string\n"
                '  description = "OCI region. Resource Manager fills this when the stack is created."\n'
                "}\n"
            )
        if 'variable "tenancy_ocid"' not in variables and "var.tenancy_ocid" in main:
            variables += (
                '\nvariable "tenancy_ocid" {\n'
                "  type        = string\n"
                '  description = "Tenancy OCID. Resource Manager fills this when the stack is created."\n'
                "}\n"
            )
        (dest / "variables.tf").write_text(variables)

        if (example / "outputs.tf").is_file():
            outputs = (example / "outputs.tf").read_text().replace("var.compartment_id", "var.compartment_ocid")
            (dest / "outputs.tf").write_text(outputs)
        else:
            (dest / "outputs.tf").write_text("")

        (dest / "versions.tf").write_text(
            "\n".join(
                [
                    "terraform {",
                    f'  required_version = "{VERSION}"',
                    "  required_providers {",
                    "    oci = {",
                    '      source  = "oracle/oci"',
                    f'      version = "{PROVIDER}"',
                    "    }",
                    "  }",
                    "}",
                    "",
                ]
            )
        )
        (dest / "provider.tf").write_text(
            "\n".join(
                [
                    'provider "oci" {',
                    "  region = var.region",
                    "}",
                    "",
                ]
            )
        )

        schema_vars = {}
        for name, _s, _e, _body_start, body in top_blocks((dest / "variables.tf").read_text(), "variable"):
            spec = schema_for_variable(name, body)
            if spec:
                schema_vars[name] = spec
        identity = [name for name in ("region", "tenancy_ocid", "compartment_ocid") if name in schema_vars]
        parameters = [name for name in schema_vars if name not in identity]
        groups = []
        if identity:
            groups.append({"title": "Identity", "variables": identity})
        if parameters:
            groups.append({"title": "Parameters", "variables": parameters})
        title = module_dir.name.replace("-", " ")
        schema = {
            "title": f"{title} stack",
            "description": (
                f"Creates {module_dir.name} with the basic example defaults. "
                "Upload this directory as an OCI Resource Manager stack on Terraform 1.5.x."
            ),
            "variableGroups": groups,
            "variables": schema_vars,
            "outputs": output_specs((dest / "outputs.tf").read_text()),
        }
        (dest / "schema.yaml").write_text(dump_schema(schema))
        (dest / "README.md").write_text(
            "\n".join(
                [
                    f"# {module_dir.name} on OCI Resource Manager",
                    "",
                    "This directory is a stack you can upload as-is. The module source is vendored under `modules/`.",
                    "",
                    "1. Zip this directory. Leave out any `.terraform` directory.",
                    "2. In Resource Manager, create a stack from the zip and select Terraform **1.5.x**.",
                    "3. Resource Manager fills `tenancy_ocid` and `region`. Set `compartment_ocid` and the other required fields.",
                    "4. Run Plan, then Apply.",
                    "",
                    "Change parameters in the stack form. Edit Terraform only when you need a value the form does not show.",
                    "Regenerate this directory with `python3 scripts/tf15_resource_manager.py sync` after the module changes.",
                    "",
                ]
            )
        )
        ensure_readme_pointer(module_dir)
        print(f"synced {module_dir.name}")


def main() -> None:
    import sys

    command = sys.argv[1] if len(sys.argv) > 1 else "all"
    if command in {"all", "prepare"}:
        prepare()
    if command in {"all", "sync"}:
        sync()


if __name__ == "__main__":
    main()
