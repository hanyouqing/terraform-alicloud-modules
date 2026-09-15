.PHONY: help fmt fmt-check validate validate-prep validate-modules validate-examples lint docs clean list-modules list-examples install-tools pre-commit ci

.DEFAULT_GOAL := help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fmt: ## Format all Terraform and Terragrunt HCL files
	@echo "Formatting all Terraform files..."
	@terraform fmt -recursive
	@if command -v terragrunt >/dev/null 2>&1; then \
		echo "Formatting Terragrunt HCL files..."; \
		terragrunt hclfmt --working-dir terragrunt; \
	else \
		echo "terragrunt not found; skipping terragrunt hclfmt."; \
	fi

fmt-check: ## Check Terraform and Terragrunt formatting
	@terraform fmt -check -recursive
	@if command -v terragrunt >/dev/null 2>&1; then \
		terragrunt hclfmt --check --working-dir terragrunt; \
	else \
		echo "terragrunt not found; skipping terragrunt hclfmt --check."; \
	fi

validate: validate-modules validate-examples ## Validate all modules and examples

validate-prep: ## Ensure plugin cache dir exists
	@mkdir -p "$$HOME/.terraform.d/plugin-cache"

validate-modules: validate-prep ## Validate all modules (top-level dirs with main.tf)
	@echo "Validating all modules..."
	@set -e; \
	for dir in */; do \
		dir=$${dir%/}; \
		[ "$$dir" = "_ref-oci" ] && continue; \
		[ -f "$$dir/main.tf" ] || continue; \
		echo "Validating $$dir..."; \
		(cd "$$dir" && terraform init -backend=false -input=false >/dev/null && terraform validate); \
	done

validate-examples: validate-prep ## Validate all configs under */examples/*
	@echo "Validating all examples..."
	@set -e; \
	for dir in $$(find . -type f -name '*.tf' -path '*/examples/*' \
		-not -path '*/.terraform/*' -not -path '*/_ref-oci/*' -not -path '*/.terragrunt-cache/*' 2>/dev/null | \
		sed 's|/[^/]*$$||' | sort -u); do \
		[ -n "$$dir" ] || continue; \
		echo "Validating $$dir..."; \
		(cd "$$dir" && terraform init -backend=false -input=false >/dev/null && terraform validate); \
	done

lint: ## Run tflint on all modules
	@if command -v tflint > /dev/null; then \
		if [ -f .tflint.hcl ]; then \
			tflint --config .tflint.hcl --recursive; \
		else \
			tflint --recursive; \
		fi; \
	else \
		echo "tflint not installed. Run 'make install-tflint'."; \
		exit 1; \
	fi

docs: ## Generate documentation for all modules
	@if command -v terraform-docs > /dev/null; then \
		for dir in */; do \
			[ "$$dir" = "_ref-oci/" ] && continue; \
			if [ -f "$$dir/main.tf" ]; then \
				echo "Generating docs for $$dir..."; \
				(cd "$$dir" && terraform-docs markdown --output-file README.md --output-mode inject --sort-by name .) || true; \
			fi; \
		done; \
	else \
		echo "terraform-docs not installed. Run 'make install-terraform-docs'."; \
		exit 1; \
	fi

list-modules: ## List all modules
	@echo "Available modules:"
	@ls -d */ 2>/dev/null | grep -vE '^(_ref-oci|terragrunt|docs|scripts)/$$' | sed 's|/||' | while read dir; do \
		[ -f "$$dir/main.tf" ] && echo "  $$dir"; \
	done

list-examples: ## List all examples
	@echo "Available examples:"
	@find . -type f -name '*.tf' -path '*/examples/*' -not -path '*/.terraform/*' -not -path '*/_ref-oci/*' 2>/dev/null | \
		sed 's|/[^/]*$$||' | sort -u | sed 's|^|  |'

clean: ## Clean Terraform / Terragrunt caches and local state
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.tfstate" -delete 2>/dev/null || true
	@find . -type f -name "*.tfstate.*" -delete 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true

install-tools: ## Install recommended tools (macOS brew)
	@$(MAKE) install-terraform-docs
	@$(MAKE) install-tflint

install-terraform-docs: ## Install terraform-docs
	@command -v terraform-docs >/dev/null && echo "terraform-docs already installed" || brew install terraform-docs

install-tflint: ## Install tflint
	@command -v tflint >/dev/null && echo "tflint already installed" || brew install tflint

pre-commit: fmt-check validate lint ## Run pre-commit checks

ci: fmt-check validate lint ## Run full CI checks

info: ## Show project information
	@echo "Terraform Alibaba Cloud Modules"
	@echo "================================"
	@echo "Modules: $$(make list-modules 2>/dev/null | grep -c '^  ' || true)"
	@echo "Examples: $$(make list-examples 2>/dev/null | grep -c '^  ' || true)"
	@terraform version 2>/dev/null | head -1 || echo "Terraform: not installed"
