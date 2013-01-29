#!/bin/sh
if [ -z "$DART_SDK" ]; then
    echo "Please set your DART_SDK env variable before running this script"
    exit 1
fi
$DART_SDK/bin/dart --heap_growth_rate=32 $DART_SDK/pkg/dartdoc/bin/dartdoc.dart --pkg=$PWD/packages --link-api --mode=static $PWD/lib/ThreeD.dart
