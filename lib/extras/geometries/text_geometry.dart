part of three;

class TextGeometry extends ExtrudeGeometry {
  factory TextGeometry( text, [ height = 50, // height <=> amount,
                                bend = false,

                                // ExtrudeGeometry parameters
                                bevelThickness = 10,
                                bevelSize = 8,
                                bevelSegments = 3,
                                bevelEnabled = false,


                                curveSegments = 12,
                                steps = 1,
                                bendPath,
                                extrudePath,
                                material,
                                extrudeMaterial,

                                // FontUtils.generateShapes parameters
                                size = 100,
                                font = "helvetiker",
                                weight = "normal",
                                style = "normal"
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
