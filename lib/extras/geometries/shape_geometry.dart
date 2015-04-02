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
  String type = 'ShapeGeometry';
  
  List<Shape> shapes;

  ShapeGeometry(shapes, {int curveSegments: 12, int material, ExtrudeGeometryWorldUVGenerator uvGenerator})
      : super() {

    if (shapes == null) {
      this.shapes = [];
      return;
    }
    
    this.shapes = shapes is! List ? [shapes] : shapes;

    addShapeList(this.shapes, curveSegments, material, uvGenerator);

    computeCentroids();
    computeFaceNormals();
  }

  void addShapeList(List<Shape> shapes, num curveSegments, int material, [ExtrudeGeometryWorldUVGenerator uvGenerator]) {
    var sl = shapes.length;

    for (var s = 0; s < sl; s++) {
      var shape = shapes[s];
      addShape(shape, curveSegments, material, uvGenerator);
    }
  }

  void addShape(Shape shape, num curveSegments, int material, [ExtrudeGeometryWorldUVGenerator uvGenerator]) {
    curveSegments = curveSegments != null ? curveSegments : 12;
    var uvgen = uvGenerator == null ? new ExtrudeGeometryWorldUVGenerator() : uvGenerator;

    //

    var shapesOffset = this.vertices.length;
    var shapePoints = shape.extractPoints(curveSegments);

    var vertices = shapePoints['shape'];
    var holes = shapePoints['holes'];

    var reverse = !ShapeUtils.isClockWise(vertices);

    if (reverse) {
      vertices = vertices.reversed.toList();

      // Maybe we should also check if holes are in the opposite direction, just to be safe...

      for (var i = 0, l = holes.length; i < l; i ++) {
        var hole = holes[i];

        if (ShapeUtils.isClockWise(hole)) {
          holes[i] = hole.reversed.toList();
        }
      }

      reverse = false;
    }

    var faces = ShapeUtils.triangulateShape(vertices, holes);

    // Vertices

    for (var i = 0, l = holes.length; i < l; i ++) {
      var hole = holes[i];
      vertices.addAll(hole);
    }

    //

    var vlen = vertices.length;
    var flen = faces.length;

    for (var i = 0; i < vlen; i ++) {
      var vert = vertices[i];

      this.vertices.add(new Vector3(vert.x, vert.y, 0.0));
    }

    for (var i = 0; i < flen; i ++) {
      var face = faces[i];
      
      var a = face[0] + shapesOffset;
      var b = face[1] + shapesOffset;
      var c = face[2] + shapesOffset;

      this.faces.add(new Face3(a, b, c, null, null, material));
      this.faceVertexUvs[0].add(uvgen.generateTopUV(this, a, b, c));
    }
  }
}

