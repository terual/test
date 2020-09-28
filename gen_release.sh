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
echo "Creating release for '$PROJECT' with version '$VERSION'"

ZIPBALL="$PROJECT-$VERSION.zip"
URL="https://github.com/terual/$PROJECT/releases/download/$VERSION/$ZIPBALL"

# First update version in install.xml
xmlstarlet ed --inplace --update "//extension/version" --value "$VERSION" install.xml

# Then zip plugin and update repo.xml
zip -r "$ZIPBALL" . -x ".git/*" ".github/*" ".gitignore" "repo.xml" "*.zip" "*.sh" &> /dev/null
SHA=`sha1sum "$ZIPBALL" | awk '{ print $1 }'`
xmlstarlet ed --inplace --update "//extensions/plugins/plugin/sha" --value "$SHA" repo.xml
xmlstarlet ed --inplace --update "//extensions/plugins/plugin/url" --value "$URL" repo.xml
xmlstarlet ed --inplace --update "//extensions/plugins/plugin/@version" --value "$VERSION" repo.xml

# Todo after running script
echo "To do: commit and push changes, create tag with version $VERSION and upload $ZIPBALL to release"
