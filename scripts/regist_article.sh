#!/bin/bash
set -ex

if [[ `hostname` == *mac* ]]; then
    shopt -s expand_aliases
    alias sed='gsed'
fi

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR/../

SRC_TAGS_DIR_NAME=tags

ARTICLE_PATH=$1
TAGS=${@:2}

ARTICLE_NAME=`head -n 1 $ARTICLE_PATH | sed -e 's/# //'`
ARTICLE_DATE=`basename $ARTICLE_PATH | sed -r 's/^([^_]*)\_.*$/\1/'`
ARTICLE_PATH=`echo $ARTICLE_PATH | sed -e 's/src\///'`
ARTICLE_MD_LINK="- [$ARTICLE_NAME ($ARTICLE_DATE)]($ARTICLE_PATH)"

ALL_CATEGORY_LINE=`cat ./src/SUMMARY.md | grep -n "\- \[all\](./all.md)" | awk -F ':' '{print $1}'`
sed -i "${ALL_CATEGORY_LINE}a \    ${ARTICLE_MD_LINK}" ./src/SUMMARY.md


echo $ARTICLE_MD_LINK >> ./src/all.md

for tag in $TAGS
do
    echo "- [$ARTICLE_NAME ($ARTICLE_DATE)](.$ARTICLE_PATH)" >> ./src/$SRC_TAGS_DIR_NAME/$tag.md
done
