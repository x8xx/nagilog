server:
	mdbook serve -n 0.0.0.0 -p 3000

build:
	./scripts/regist_article.sh

deploy:
	mdbook build
	mv ./x8xx.github.io/.git ./.git.bak 
	rm -rf ./x8xx.github.io/
	mv ./book/ ./x8xx.github.io/
	mv ./.git.bak ./x8xx.github.io/.git
	echo "commit x8xx.github.io"
	cd ./x8xx.github.io && \
	git add . && \
	git commit -m ":book: update" && \
	git push origin master
	echo "commit nagilog"
	git add .
	git commit -m ":book: update"
	git push origin master

syntax:
	cat ./nagilog.yml | yq > /dev/null

.PHONY: server build deploy syntax
