.PHONY: help fmt fmt-check validate lint security docs clean init plan apply list-modules list-examples install-tools

# Default target
.DEFAULT_GOAL := help

# Variables
TERRAFORM_VERSION ?= 1.14.2
TF_VERSION_FILE := .terraform-version

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fmt: ## Format all Terraform files
	@echo "Formatting all Terraform files..."
	@find . -type f -name "*.tf" -not -path "*/.terraform/*" -exec terraform fmt -recursive {} \;

fmt-check: ## Check if files are formatted
	@echo "Checking Terraform formatting..."
	@terraform fmt -check -recursive
	@if [ $$? -ne 0 ]; then \
		echo "Error: Some files are not formatted. Run 'make fmt' to fix."; \
		exit 1; \
	fi

validate: ## Validate all modules and examples
	@echo "Validating all modules and examples..."
	@for dir in $$(find modules -type d -name "*.tf" -o -type d | grep -E "(modules|examples)" | sort -u); do \
		if [ -f "$$dir/main.tf" ] || [ -f "$$dir/*.tf" ]; then \
			echo "Validating $$dir..."; \
			cd $$dir && terraform init -backend=false > /dev/null 2>&1 && terraform validate || exit 1; \
			cd - > /dev/null; \
		fi; \
	done

validate-modules: ## Validate all modules
	@echo "Validating all modules..."
	@for dir in */; do \
		if [ -d "$$dir" ] && [ -f "$$dir/main.tf" ]; then \
			echo "Validating $$dir..."; \
			cd $$dir && terraform init -backend=false > /dev/null 2>&1 && terraform validate || exit 1; \
			cd - > /dev/null; \
		fi; \
	done

validate-examples: ## Validate all examples
	@echo "Validating all examples..."
	@for dir in $$(find . -type d -path "*/examples/*" -o -path "*/example/*"); do \
		if [ -f "$$dir/*.tf" ]; then \
			echo "Validating $$dir..."; \
			cd $$dir && terraform init -backend=false > /dev/null 2>&1 && terraform validate || exit 1; \
			cd - > /dev/null; \
		fi; \
	done

lint: ## Run tflint on all modules
	@echo "Running tflint..."
	@if command -v tflint > /dev/null; then \
		if [ -f .tflint.hcl ]; then \
			tflint --config .tflint.hcl --recursive; \
		else \
			tflint --recursive; \
		fi; \
	else \
		echo "tflint not installed. Run 'make install-tflint' to install."; \
		exit 1; \
	fi

lint-init: ## Initialize tflint plugins
	@echo "Initializing tflint plugins..."
	@if command -v tflint > /dev/null; then \
		tflint --init; \
	else \
		echo "tflint not installed. Run 'make install-tflint' to install."; \
		exit 1; \
	fi

lint-module: ## Lint a specific module (usage: make lint-module MODULE=vcn)
	@if [ -z "$(MODULE)" ]; then \
		echo "Error: MODULE variable is required. Usage: make lint-module MODULE=vcn"; \
		exit 1; \
	fi
	@if command -v tflint > /dev/null; then \
		if [ -f .tflint.hcl ]; then \
			tflint --config .tflint.hcl $(MODULE); \
		else \
			tflint $(MODULE); \
		fi; \
	else \
		echo "tflint not installed. Run 'make install-tflint' to install."; \
		exit 1; \
	fi

security: ## Run security scans (tfsec and checkov)
	@echo "Running security scans..."
	@if command -v tfsec > /dev/null; then \
		if [ -f .tfsec.yml ]; then \
			tfsec --config-file .tfsec.yml .; \
		else \
			tfsec .; \
		fi; \
	else \
		echo "tfsec not installed. Run 'make install-tfsec' to install."; \
		exit 1; \
	fi
	@if command -v checkov > /dev/null; then \
		checkov -d .; \
	else \
		echo "checkov not installed. Run 'make install-checkov' to install."; \
	fi

tfsec: ## Run tfsec security scanner only
	@echo "Running tfsec..."
	@if command -v tfsec > /dev/null; then \
		if [ -f .tfsec.yml ]; then \
			tfsec --config-file .tfsec.yml .; \
		else \
			tfsec .; \
		fi; \
	else \
		echo "tfsec not installed. Run 'make install-tfsec' to install."; \
		exit 1; \
	fi

checkov: ## Run checkov security scanner only
	@echo "Running checkov..."
	@if command -v checkov > /dev/null; then \
		checkov -d .; \
	else \
		echo "checkov not installed. Run 'make install-checkov' to install."; \
		exit 1; \
	fi

docs: ## Generate documentation for all modules
	@echo "Generating documentation..."
	@if command -v terraform-docs > /dev/null; then \
		for dir in */; do \
			if [ -d "$$dir" ] && [ -f "$$dir/main.tf" ]; then \
				echo "Generating docs for $$dir..."; \
				if [ -f .terraform-docs.yml ]; then \
					terraform-docs --config .terraform-docs.yml $$dir || true; \
				else \
					terraform-docs markdown table $$dir > $$dir/README.md || true; \
				fi; \
			fi; \
		done; \
	else \
		echo "terraform-docs not installed. Run 'make install-terraform-docs' to install."; \
		exit 1; \
	fi

docs-module: ## Generate docs for a specific module (usage: make docs-module MODULE=vcn)
	@if [ -z "$(MODULE)" ]; then \
		echo "Error: MODULE variable is required. Usage: make docs-module MODULE=vcn"; \
		exit 1; \
	fi
	@if command -v terraform-docs > /dev/null; then \
		if [ -f .terraform-docs.yml ]; then \
			terraform-docs --config .terraform-docs.yml $(MODULE); \
		else \
			terraform-docs markdown table $(MODULE) > $(MODULE)/README.md; \
		fi; \
	else \
		echo "terraform-docs not installed. Run 'make install-terraform-docs' to install."; \
		exit 1; \
	fi

init: ## Initialize Terraform in current directory
	terraform init

plan: ## Run terraform plan
	terraform plan

apply: ## Run terraform apply (with confirmation)
	terraform apply

list-modules: ## List all modules
	@echo "Available modules:"
	@ls -d */ 2>/dev/null | grep -v "^\.terraform" | sed 's|/||' | while read dir; do [ -f "$$dir/main.tf" ] && echo "$$dir"; done || echo "No modules found"

list-examples: ## List all examples
	@echo "Available examples:"
	@find . -type d -path "*/examples/*" -o -path "*/example/*" | sort || echo "No examples found"

clean: ## Clean all Terraform files (.terraform, .tfstate, etc.)
	@echo "Cleaning Terraform files..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.tfstate" -delete 2>/dev/null || true
	@find . -type f -name "*.tfstate.*" -delete 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -type f -name "crash.log" -delete 2>/dev/null || true
	@find . -type f -name "crash.*.log" -delete 2>/dev/null || true

install-tools: ## Install all recommended tools
	@echo "Installing recommended tools..."
	@make install-terraform-docs
	@make install-tflint
	@make install-tfsec
	@make install-checkov

install-terraform-docs: ## Install terraform-docs
	@if command -v terraform-docs > /dev/null; then \
		echo "terraform-docs already installed"; \
	else \
		echo "Installing terraform-docs..."; \
		if [ "$$(uname)" = "Darwin" ]; then \
			brew install terraform-docs; \
		else \
			echo "Please install terraform-docs manually: https://terraform-docs.io/user-guide/installation/"; \
		fi; \
	fi

install-tflint: ## Install tflint
	@if command -v tflint > /dev/null; then \
		echo "tflint already installed"; \
	else \
		echo "Installing tflint..."; \
		if [ "$$(uname)" = "Darwin" ]; then \
			brew install tflint; \
		else \
			echo "Please install tflint manually: https://github.com/terraform-linters/tflint"; \
		fi; \
	fi

install-tfsec: ## Install tfsec
	@if command -v tfsec > /dev/null; then \
		echo "tfsec already installed"; \
	else \
		echo "Installing tfsec..."; \
		if [ "$$(uname)" = "Darwin" ]; then \
			brew install tfsec; \
		else \
			echo "Please install tfsec manually: https://aquasecurity.github.io/tfsec/latest/getting-started/installation/"; \
		fi; \
	fi

install-checkov: ## Install checkov
	@if command -v checkov > /dev/null; then \
		echo "checkov already installed"; \
	else \
		echo "Installing checkov..."; \
		pip3 install checkov || echo "Please install checkov manually: pip install checkov"; \
	fi

check-versions: ## Check tool versions
	@echo "Tool versions:"
	@terraform version 2>/dev/null || echo "Terraform: not installed"
	@tflint --version 2>/dev/null || echo "tflint: not installed"
	@tfsec --version 2>/dev/null || echo "tfsec: not installed"
	@checkov --version 2>/dev/null || echo "checkov: not installed"
	@terraform-docs --version 2>/dev/null || echo "terraform-docs: not installed"

pre-commit: fmt-check validate-modules lint ## Run pre-commit checks

ci: fmt-check validate lint security ## Run full CI checks
