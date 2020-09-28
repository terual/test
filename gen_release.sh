#!/bin/sh

# Procedure:
# 1. Make updates to repo
# 2. Run script and make changes to repo.xml, bump version in install.xml and repo.xml
# 3. Commit changes, bump tag and upload zip to release

if ! command -v xmlstarlet &> /dev/null
then
    echo "xmlstarlet could not be found"
    exit
fi

# Get new version
VERSION="$1"
if [ -z "$VERSION" ]
  then
    echo "No version supplied as argument"
fi

ORIGIN=`git config --get remote.origin.url`
PROJECT=`basename -s .git $ORIGIN`
ZIPBALL="$PROJECT-$VERSION.zip"
URL="https://github.com/terual/$PROJECT/releases/download/$VERSION/$ZIPBALL"

zip -r "$ZIPBALL" . -x ".git/*" ".github/*" "*.xml"
SHA=`sha1sum "$ZIPBALL"`

xmlstarlet edit --update "//extensions/plugins/plugin/sha" --value "$SHA" repo.xml > repo.xml
xmlstarlet edit --update "//extensions/plugins/plugin/url" --value "$URL" repo.xml > repo.xml
xmlstarlet edit --update "//extensions//plugins/plugin/@version" --value "$VERSION" repo.xml > repo.xml
