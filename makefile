
PHONY: init update dev local 

init:
	@read -p "Enter project title: " title; \
	sed -i '' 's/name = "bff-template"/name = "'$$title'"/' pyproject.toml

	@echo Creating frontend
	mkdir -p frontend
	cd frontend && npx create-react-app . && npm run build
	@echo frontend Complete

	@echo Creating backend
	poetry install --no-root

	@echo "Starting backend in local mode..."
	make local
	@echo "Opening http://localhost:8000 in your default browser..."
	open http://localhost:8000
	
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

