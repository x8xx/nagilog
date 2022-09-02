#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR/../

ARTICLE_NAME=$1
ARTICLE_LINK=$2
TAGS=${@:3}

SRC_TAGS_DIR_NAME=tags

for tag in $TAGS
do
    echo "- [$ARTICLE_NAME]($ARTICLE_LINK)" >> ./src/$SRC_TAGS_DIR_NAME/$tag.md
done
