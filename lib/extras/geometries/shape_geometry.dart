part of three;

/**
 * @author jonobr1 / http://jonobr1.com
 *
 * Creates a one-sided polygonal geometry from a path shape. Similar to
 * ExtrudeGeometry.
 *
 * parameters = {
 *
 *  curveSegments: <int>, // number of points on the curves. NOT USED AT THE MOMENT.
 *
 *  material: <int> // material index for front and back faces
 *  uvGenerator: <Object> // object that provides UV generator functions
 *
 * }
 **/

class ShapeGeometry extends Geometry {

  List shapes;

  var shapebb;

  ShapeGeometry( this.shapes,
                  {
                    curveSegments: 12,
                    material,
                    ExtrudeGeometryWorldUVGenerator UVGenerator } ) : super() {

    if (shapes == null) {
      shapes = [];
      return;
    }

    shapebb = shapes.last.getBoundingBox();

    addShapeList( shapes,
      curveSegments, material, UVGenerator );

    computeCentroids();
    computeFaceNormals();

  }



  addShapeList(shapes, curveSegments, material, [ ExtrudeGeometryWorldUVGenerator UVGenerator = null ] ) {
    var sl = shapes.length;

    for ( var s = 0; s < sl; s ++ ) {
      var shape = shapes[ s ];
      addShape( shape, curveSegments, material, UVGenerator );
    }
  }

  addShape( Shape shape, curveSegments, material, [ ExtrudeGeometryWorldUVGenerator UVGenerator = null ] ) {

    // set UV generator
    var uvgen = (UVGenerator!= null) ? UVGenerator : new ExtrudeGeometryWorldUVGenerator();

    var i, hole, s;

    var shapesOffset = this.vertices.length;
    var shapePoints = shape.extractPoints( curveSegments );

    List vertices = shapePoints["shape"];
    List<List<Vector2>> holes = shapePoints["holes"];

    var reverse = !ShapeUtils.isClockWise( vertices );

    if ( reverse ) {

      vertices = vertices.reversed.toList();

      // Maybe we should also check if holes are in the opposite direction, just to be safe...

      for ( i = 0; i < holes.length; i++ ) {

        hole = holes[ i ];

        if ( ShapeUtils.isClockWise( hole ) ) {

          holes[ i ] = hole.reversed.toList();

        }

      }

      reverse = false;

    }

    var faces = ShapeUtils.triangulateShape( vertices, holes );

    // Vertices

    var contour = vertices;

    for ( i = 0; i < holes.length; i++ ) {

      hole = holes[ i ];

      vertices = new List.from(vertices);
      vertices.addAll( hole );

    }

    //

    var vert, vlen = vertices.length;
    var face, flen = faces.length;
    var cont, clen = contour.length;

    for ( i = 0; i < vlen; i++ ) {

      vert = vertices[ i ];

      this.vertices.add( new Vector3( (vert.x).toDouble(), (vert.y).toDouble(), 0.0 ) );

    }

    for ( i = 0; i < flen; i++ ) {

      face = faces[ i ];

      var a = face[ 0 ] + shapesOffset;
      var b = face[ 1 ] + shapesOffset;
      var c = face[ 2 ] + shapesOffset;

      this.faces.add( new Face3( a, b, c, null, null, material ) );
      faceVertexUvs[ 0 ].add( uvgen.generateBottomUV( this, shape, null, a, b, c ) );

    }
  }
}


