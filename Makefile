server:
	mdbook serve -n 0.0.0.0 -p 3000

deploy:
	mdbook build
	cp -r ./book/* ./x8xx.github.io/
	cd ./x8xx.github.io
	git add .
	git commit -m ":book: update"
	git push origin master

.PHONY: server build
