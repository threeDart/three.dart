#!/bin/bash

set -e

#####
# Unit Tests

# Disabled unit tests for now just doing type analysis
#echo "DumpRenderTree test/test_runner_headless.html"
#results=`DumpRenderTree test/test_runner_headless.html 2>&1`

#echo "$results" | grep CONSOLE

#echo $results | grep 'unittest-suite-success' >/dev/null

#echo $results | grep -v 'Exception: Some tests failed.' >/dev/null

#####
# Type Analysis

echo
echo "dart_analyzer lib/*.dart"

results=`dart_analyzer lib/*.dart 2>&1`

echo "$results"

if [ -n "$results" ]; then
    exit 1
else
    echo "Passed analysis."
fi
