#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR/../
YAML=`cat ./nagilog.yml`
 
_INIT_SUMMARY() {
    echo "# Summary" >> ./src/SUMMARY.md
    echo "" >> ./src/SUMMARY.md
    echo "- [whoami](./whoami.md)" >> ./src/SUMMARY.md
    echo "" >> ./src/SUMMARY.md
    # echo "- [tag]()" >> ./src/SUMMARY.md
    # echo "" >> ./src/SUMMARY.md
}


_PUSH_TAG_TO_SUMMARY() {
    echo "    - [$1]($2)" >> ./src/SUMMARY.md
}


# init gen file
echo "" > ./src/all.md
sed -i -e '1,1d' ./src/all.md
echo "" > ./src/SUMMARY.md
sed -i -e '1,1d' ./src/SUMMARY.md
_INIT_SUMMARY

# all
ALL_PATHS=(`echo "$YAML" | yq '.Articles | sort_by(.date) | reverse | .[].path' | tr '\n' ' '`)
for ARTICLE_PATH in ${ALL_PATHS[@]}
do
    ARTICLE_YAML=`echo "$YAML" | yq '.Articles[] | select(.path == "'$ARTICLE_PATH'")'`

    ARTICLE_DATE=`echo "$ARTICLE_YAML" | yq '.date'`
    ARTICLE_TITLE=`echo "$ARTICLE_YAML" | yq -r '.title'`
    echo "- [$ARTICLE_TITLE ($ARTICLE_DATE)]($ARTICLE_PATH)" >> ./src/all.md
done


# tags
TAGS=`echo "$YAML" | yq '.Tags | to_entries'`
TAGS_LENGTH=`echo "$TAGS" | yq '. | length'`

echo "- [tag]()" >> ./src/SUMMARY.md
for TAG_INDEX in $(seq 0 $(($TAGS_LENGTH-1)))
do
    TAG_NAME=`echo "$TAGS" | yq '.['$TAG_INDEX'] | .key'`
    TAG_PATH=`echo "$TAGS" | yq '.['$TAG_INDEX'] | .value'`

    # SUMMARY PAGE
    _PUSH_TAG_TO_SUMMARY $TAG_NAME $TAG_PATH

    # TAG PAGE
    cd ./src
    TAG_ARTICLES=`echo "$YAML" | yq '.Articles | sort_by(.date) | reverse | .[] | select(.tags[] | contains("'$TAG_NAME'")) | [.]'`
    TAG_ARTICLES_LENGTH=`echo "$TAG_ARTICLES" | yq '. | length'`

    echo "# $TAG_NAME" > $TAG_PATH
    for TAG_ARTICLES_INDEX in $(seq 0 $(($TAG_ARTICLES_LENGTH-1)))
    do
        ARTICLE_YAML=`echo "$TAG_ARTICLES" | yq '.['$TAG_ARTICLES_INDEX']'`
        ARTICLE_DATE=`echo "$ARTICLE_YAML" | yq '.date'`
        ARTICLE_TITLE=`echo "$ARTICLE_YAML" | yq -r '.title'`
        echo "- [$ARTICLE_TITLE ($ARTICLE_DATE)]($ARTICLE_PATH)" >> $TAG_PATH
    done
    cd ../
done


# all
echo "" >> ./src/SUMMARY.md
echo "- [all](./all.md)" >> ./src/SUMMARY.md
IFS=$'\n'
for line in `cat ./src/all.md | head -n 10`
do
    echo "    "$line >> ./src/SUMMARY.md
done
