part of three;

class TextGeometry extends ExtrudeGeometry {
  factory TextGeometry( String text, [ int height = 50, // height <=> amount,
                                bool bend = false,

                                // ExtrudeGeometry parameters
                                int bevelThickness = 10,
                                int bevelSize = 8,
                                int bevelSegments = 3,
                                bool bevelEnabled = false,


                                int curveSegments = 12,
                                int steps = 1,
                                bendPath,
                                extrudePath,
                                int material,
                                int extrudeMaterial,

                                // FontUtils.generateShapes parameters
                                int size = 100,
                                String font = "helvetiker",
                                String weight = "normal",
                                String style = "normal"
                                ] ) {

    var textShapes = FontUtils.generateShapes( text, size, curveSegments, font, weight, style);

    var amount = height;
    var bendPath = null;

    if (bend) {
      var b = textShapes[ textShapes.length - 1 ].getBoundingBox();
      var max = b.maxX;

      bendPath = new QuadraticBezierCurve(
          new Vector2.zero(),
          new Vector2( max / 2, 120.0 ),
          new Vector2( max, 0.0 )
      );
    }

    return new TextGeometry._internal(  textShapes,
                                        amount,
                                        bevelThickness,
                                        bevelSize,
                                        bevelSegments,
                                        bevelEnabled,
                                        curveSegments,
                                        steps,
                                        bendPath,
                                        extrudePath,
                                        material,
                                        extrudeMaterial);
  }

  TextGeometry._internal( shapes,
                          amount,
                          bevelThickness,
                          bevelSize,
                          bevelSegments,
                          bevelEnabled,
                          curveSegments,
                          steps,
                          bendPath,
                          extrudePath,
                          material,
                          extrudeMaterial) : super( shapes,
                                                    amount: amount,
                                                    bevelThickness: bevelThickness,
                                                    bevelSize: bevelSize,
                                                    bevelSegments: bevelSegments,
                                                    bevelEnabled: bevelEnabled,
                                                    curveSegments: curveSegments,
                                                    steps: steps,
                                                    bendPath: bendPath,
                                                    extrudePath: extrudePath,
                                                    material: material,
                                                    extrudeMaterial: extrudeMaterial);
}
