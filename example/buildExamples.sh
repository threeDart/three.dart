#!/usr/bin/env bash

MINFROG=/Application/dart/dart-sdk/bin/dart
for htmlFile in `find . -type f -name "*.html"`
do
    htmlDirectory=${htmlFile%/*}
    htmlFileName=${htmlFile##*/}
    name=`echo "$htmlFileName" | cut -d'.' -f1;`
    echo "RUNNING: $MINFROG --compile-only --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart"
    $MINFROG --compile-only --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart
    #rm -rf out
done;
