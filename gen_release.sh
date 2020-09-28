#!/bin/sh

// Procedure:
// 1. Make updates to repo
// 2. Run script and make changes to repo.xml, bump version in install.xml and repo.xml
// 3. Commit changes, bump tag and upload zip to release

// Get new version
VERSION="$1"
if [ -z "$VERSION" ]
  then
    echo "No argument supplied"
fi

zip -r "projectname-$VERSION.zip" . -x ".git/*" ".github/*" "*.xml"

SHA = `sha1sum "projectname-$VERSION.zip"`
xmlstarlet edit --update //repository/sha --value "$SHA" repo.xml
xmlstarlet edit --update //repository/version --value "$VERSION" repo.xml
xmlstarlet edit --update //repository/version --value "$VERSION" install.xml
