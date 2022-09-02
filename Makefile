server:
	mdbook serve -n 0.0.0.0 -p 3000

deploy:
	mdbook build
	\cp -rf ./book/* ./x8xx.github.io/
	echo "commit x8xx.github.io"
	cd ./x8xx.github.io && \
	git add . && \
	git commit -m ":book: update" && \
	git push origin master
	echo "commit nagilog"
	git add .
	git commit -m ":book: update"
	git push origin master

.PHONY: server deploy
