.PHONY: help fmt fmt-check check test docs validate

help:
	@echo edge-agent-gitops engineering command surface
	@echo "  make fmt        Format Python harness sources"
	@echo "  make fmt-check  Verify formatting without changing files"
	@echo "  make check      Run formatting, linting and type checks"
	@echo "  make test       Run the unit-test suite"
	@echo "  make docs       Validate local documentation links"
	@echo "  make validate   Run every repository-local check"

fmt:
	uv run --locked ruff format .

fmt-check:
	uv run --locked ruff format --check .

check: fmt-check
	uv run --locked ruff check .
	uv run --locked ty check

test:
	uv run --locked python -m unittest discover -s tests -v

docs:
	uv run --locked python -m scripts.check_docs

validate: check test docs
