library hop_runner;

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main() {
  //
  // Analyzer
  //
  addTask('analyze_lib', createAnalyzerTask(['lib/three.dart',
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
  // addTask('docs', createDartDocTask(_getLibs));

  //
  // Hop away!
  //
  runHop();
}
