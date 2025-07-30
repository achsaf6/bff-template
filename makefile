
PHONY: init update dev local test

init:
	@read -p "Enter project title: " title; \
	sed -i '' 's/name = "bff-template"/name = "'$$title'"/' pyproject.toml

	@echo Creating frontend
	mkdir -p frontend
	cd frontend && npx create-react-app . && npm run build
	@echo frontend Complete

	@echo Creating backend
	poetry install --no-root

	@echo "Set your python interpreter to be: \033[33m$$(poetry env info --path)\033[0m"
	@echo "you can run everything using the make local command"
	
update:
	git add .
	git commit -m 'Update'
	git push

dev:
	cd frontend && npm start & \
	poetry run uvicorn main:app --reload

local:
	# cd frontend && npm run build
	cd backend && \
	poetry run uvicorn main:app --reload

test:
	@echo "Define here whatever you want"
