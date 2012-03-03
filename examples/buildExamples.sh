#!/usr/bin/env bash

MINFROG=~/dart_bleeding/dart/frog/minfrog
for htmlFile in `find . -type f -name "*.html"`
do
    htmlDirectory=${htmlFile%/*}
    htmlFileName=${htmlFile##*/}
    name=`echo "$htmlFileName" | cut -d'.' -f1;`
    echo "RUNNING: $MINFROG --compile-only --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart"
    $MINFROG --compile-only --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart
    #rm -rf out
done;