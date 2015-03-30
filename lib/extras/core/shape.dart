part of three;

/**
 * @author zz85 / http://www.lab4games.net/zz85/blog
 * Defines a 2d shape plane using paths.
 **/

// STEP 1 Create a path.
// STEP 2 Turn path into shape.
// STEP 3 ExtrudeGeometry takes in Shape/Shapes
// STEP 3a - Extract points from each shape, turn to vertices
// STEP 3b - Triangulate each shape, add faces.

class Shape extends Path {
  List<Path> holes = [];

  Shape([List<Vector2> points]) : super(points);

  /// Convenience method to return ExtrudeGeometry.
  ExtrudeGeometry extrude({int amount: 100, double bevelThickness: 6.0, double bevelSize, int bevelSegments: 3, bool bevelEnabled: true, int curveSegments: 12, 
    steps: 1, Curve extrudePath, int material, int extrudeMaterial}) {
    return new ExtrudeGeometry([this], amount: amount, bevelThickness: bevelThickness, bevelSize: bevelSize, bevelSegments: bevelSegments, bevelEnabled: bevelEnabled,
        curveSegments: curveSegments, steps: steps, extrudePath: extrudePath, material: material, extrudeMaterial: extrudeMaterial);
  }
  
  /// Convenience method to return ShapeGeometry.
  ShapeGeometry makeGeometry({int curveSegments: 12, int material, ExtrudeGeometryWorldUVGenerator uvGenerator}) =>
      new ShapeGeometry([this], curveSegments: curveSegments, material: material, uvGenerator: uvGenerator);

  /// Get points of holes.
  List<List<Vector2>> getPointsHoles(int divisions) =>
      new List.generate(holes.length, (i) => holes[i].getTransformedPoints(divisions));

  /// Get points of holes (spaced by regular distance).
  List<List<Vector2>> getSpacedPointsHoles(int divisions) =>
      new List.generate(holes.length, (i) => holes[i].getTransformedSpacedPoints(divisions));

  /// Get points of shape and holes (keypoints based on segments parameter).
  Map<String, dynamic> extractAllPoints(int divisions) =>
      {"shape": getTransformedPoints(divisions),
       "holes": getPointsHoles(divisions)};
       
  Map<String, dynamic> extractPoints([int divisions]) => 
      useSpacedPoints ? extractAllSpacedPoints(divisions) : extractAllPoints(divisions);

  /// Get points of shape and holes (spaced by regular distance).
  Map<String, dynamic> extractAllSpacedPoints([int divisions]) =>
      {"shape": getTransformedSpacedPoints(divisions),
       "holes": getSpacedPointsHoles(divisions)};
}