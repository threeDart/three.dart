#!/bin/sh
if [ -z "$DART_SDK" ]; then
    echo "Please set your DART_SDK env variable before running this script"
    exit 1
fi
$DART_SDK/bin/dartdoc --package-root=$PWD/packages --link-api --mode=static --exclude-lib=metadata \
        $PWD/lib/three.dart \
        $PWD/lib/extras/controls/first_person_controls.dart \
        $PWD/lib/extras/controls/trackball_controls.dart \
        $PWD/lib/extras/core/curve_utils.dart \
        $PWD/lib/extras/core/shape_utils.dart \
        $PWD/lib/extras/font_utils.dart \
        $PWD/lib/extras/geometry_utils.dart \
        $PWD/lib/extras/image_utils.dart \
        $PWD/lib/extras/image_utils.dart \
        $PWD/lib/extras/scene_utils.dart \
        $PWD/lib/extras/shader_utils.dart \
        $PWD/lib/extras/tween.dart \
        $PWD/lib/src/core/three_math.dart
