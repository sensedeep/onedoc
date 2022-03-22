
run:
	mkdocs serve

build:
	mkdocs build

promote: build
	mkdocs gh-deploy
