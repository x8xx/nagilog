#!/bin/bash

set -xe

hugo
cd ./public
git add .
git commit -m ":book: nagilog"
git push origin master
cd ../
git add .
git commit -m ":book: nagilog"
git push origin master
