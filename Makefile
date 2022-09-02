server:
	mdbook serve -n 0.0.0.0 -p 3000

deploy:
	mdbook build
	cd ./book
	git add .
	git commit -m ":book: update"
	git push origin master

.PHONY: server build
