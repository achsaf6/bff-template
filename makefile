PHONY: init update front back local test fake

init:
	chmod +x init.sh
	./init.sh

	chmod +x init.sh
	./init.sh

update:
	git add .
	git commit --amend --no-edit
	git push

front:
	npm start

back:
front:
	npm start

back:
	poetry run uvicorn main:app --reload

local:
	# cd frontend && npm run build
	cd backend && \
	poetry run uvicorn main:app --reload

test:
	@echo "Define here whatever you want"
