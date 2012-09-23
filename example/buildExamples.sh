#!/usr/bin/env bash

MINFROG=/Applications/dart/dart-sdk/bin/dart2js
for htmlFile in `find . -type f -name "*.html"`
do
    htmlDirectory=${htmlFile%/*}
    htmlFileName=${htmlFile##*/}
    name=`echo "$htmlFileName" | cut -d'.' -f1;`
    echo "RUNNING: $MINFROG --verbose --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart"
    $MINFROG --verbose --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart
    #rm -rf out
done;
