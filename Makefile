
run:
	(sleep 3 ; open http://localhost:8000) &
	mkdocs serve

build:
	mkdocs build

sync:
	git checkout gh-pages
	git pull
	git checkout main

promote: build
	mkdocs gh-deploy --ignore-version
