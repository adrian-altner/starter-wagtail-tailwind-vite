.PHONY: help dev dev-all venv install test lint fmt clean

help:
	@echo "Available targets:"
	@echo "  make dev     - run the Django development server"
	@echo "  make dev-all - run Django and Vite dev servers together (honcho)"
	@echo "  make venv    - create a local virtual environment in .venv/"
	@echo "  make install - install dependencies from requirements.txt"
	@echo "  make test    - run the test suite (pytest)"
	@echo "  make lint    - run lint checks (ruff)"
	@echo "  make fmt     - run code formatting (black)"
	@echo "  make clean - remove build artifacts (configure me)"

dev:
	@python3 manage.py runserver

dev-all:
	@honcho start

venv:
	@python3 -m venv .venv
	@echo "Virtual environment created at .venv/"

install:
	@python3 -m pip install --upgrade pip
	@python3 -m pip install -r requirements.txt

test:
	@python3 -m pytest

lint:
	@python3 -m ruff check .

fmt:
	@python3 -m black .

clean:
	@echo "No clean command configured yet. Define cleanup rules as needed."
