#!/bin/sh
DARTFMT="dartfmt -l 120 -w -t"

# lib/*.dart
$DARTFMT `find lib -name "*.dart" -maxdepth 1 -exec echo {} \;`

# lib/src : *.dart excluding web_gl_shaders.dart
$DARTFMT `find lib/src -name "web_gl_shaders.dart" -prune -o -name "*.dart" -exec echo {} \;`

# lib/extras: skip shaders to keep them readable
$DARTFMT `find lib/extras/* -type d -maxdepth 0 -not -path "lib/extras/shaders" -exec echo {} \;`

$DARTFMT example tool
