#!/bin/sh
if [ -z "$DART_SDK" ]; then
    echo "Please set your DART_SDK env variable before running this script"
    exit 1
fi

DART2JS=$DART_SDK/bin/dart2js
for htmlFile in `find $PWD/example -type f -name "*.html"`
do
    htmlDirectory=${htmlFile%/*}
    htmlFileName=${htmlFile##*/}
    name=`echo "$htmlFileName" | cut -d'.' -f1;`
    echo "RUNNING: $DART2JS --verbose --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart"
    $DART2JS --verbose --out=$htmlDirectory/$name.dart.js $htmlDirectory/$name.dart
    #rm -rf out
done;
