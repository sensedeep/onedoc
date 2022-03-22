
run:
	mkdocs serve

build:
	mkdocs build

sync:
	git checkout gh-pages
	git pull
	git checkout main

promote: build
	mkdocs gh-deploy
