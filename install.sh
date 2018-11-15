#!/bin/sh

mkdir -p ~/Library/Application\ Support/com.fournova.Tower3/CompareTools

cp {CompareTools.plist,vscode.sh} ~/Library/Application\ Support/com.fournova.Tower3/CompareTools/

echo "=> Setup completed! Now restart Tower and go to Preferences -> Git Config -> Select 'Visual Studio Code' for both Diff tool and Merge tool."
