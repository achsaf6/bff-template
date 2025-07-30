
PHONY: init update dev local 

init:
	@echo Creating frontend
	mkdir -p frontend
	cd frontend && npx create-react-app .
	@echo frontend Complete

	@echo Creating backend
	@read -p "Enter project title: " title; \
	sed -i '' 's/name = "endless"/name = "'$$title'"/' pyproject.toml
	poetry install --no-root
	
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

