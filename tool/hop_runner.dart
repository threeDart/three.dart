library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main() {
  //
  // Assert were being called from the proper location.
  //
  _assertKnownPath();

  //
  // Analyzer
  //
  addTask('analyze_lib', createDartAnalyzerTask(['lib/three.dart',
                                                 'lib/extras/controls/firstpersoncontrols.dart',
                                                 'lib/extras/controls/trackball.dart',
                                                 'lib/extras/core/curve_utils.dart',
                                                 'lib/extras/core/shape_utils.dart',
                                                 'lib/extras/font_utils.dart',
                                                 'lib/extras/geometry_utils.dart',
                                                 'lib/extras/image_utils.dart',
                                                 'lib/extras/image_utils.dart',
                                                 'lib/extras/scene_utils.dart',
                                                 'lib/extras/shader_utils.dart',
                                                 'lib/extras/tween.dart',
                                                 'lib/src/core/ThreeMath.dart']));

  //
  // Doc generation
  //
  addTask('docs', createDartDocTask(_getLibs));

  //
  // Hop away!
  //
  runHop();
}

void _assertKnownPath() {
  // since there is no way to determine the path of 'this' file
  // assume that Directory.current() is the root of the project.
  // So check for existance of /bin/hop_runner.dart
  final thisFile = new File('tool/hop_runner.dart');
  assert(thisFile.existsSync());
}

Future<List<String>> _getLibs() {
  return new Directory('lib').list()
      .where((FileSystemEntity fse) => fse is File)
      .map((File file) => file.path)
      .toList();
}
