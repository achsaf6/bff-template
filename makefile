.PHONY: init update front back local docker test target deploy clean status history 

init:
	uv run python -m manager init

update:
	git add .
	git commit --amend --no-edit
	git push -f

front:
	npm start

back:
	poetry run uvicorn backend.main:app --reload

local:
	cd frontend && npm run build
	poetry run uvicorn backend.main:app --reload

docker:
	@echo "Getting PORT from environment (defaults to 8000)..."
	@PORT=$${PORT:-8000}; \
	echo "Stopping any running Docker container on port $$PORT..."; \
	DOCKER_ID=$$(docker ps -q --filter "publish=$$PORT"); \
	if [ -n "$$DOCKER_ID" ]; then \
		docker stop $$DOCKER_ID; \
		docker rm $$DOCKER_ID; \
	fi; \
	docker build -t bff-template .; \
	echo "Exporting environment variables from .env file..."; \
	docker run --env-file .env -p $$PORT:$$PORT bff-template

deploy:
	@echo "Re-starting Colima in x86_64 mode with Rosetta if available..."
	-@colima stop >/dev/null 2>&1 || true
	-@colima start --arch x86_64 --vm-type vz --vz-rosetta >/dev/null 2>&1 || colima start --arch x86_64 >/dev/null 2>&1
	@echo "Using DOCKER_DEFAULT_PLATFORM=linux/amd64 for cross-arch build..."
	@DOCKER_DEFAULT_PLATFORM=linux/amd64 uv run python -m manager deploy $(ARGS)

clean:
	uv run python -m manager clean

status:
	uv run python -m manager status

history:
	uv run python -m manager history

test:
	@echo $(ARGS)