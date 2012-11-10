part of three;

class OctahedronGeometry extends PolyhedronGeometry {
  factory OctahedronGeometry( radius, detail ) {
    var vertices = [
                    [ 1, 0, 0 ], [ -1, 0, 0 ], [ 0, 1, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ], [ 0, 0, -1 ]
                    ];

    var faces = [
                 [ 0, 2, 4 ], [ 0, 4, 3 ], [ 0, 3, 5 ], [ 0, 5, 2 ], [ 1, 2, 5 ], [ 1, 5, 3 ], [ 1, 3, 4 ], [ 1, 4, 2 ]
                 ];

    return new OctahedronGeometry._internal(vertices, faces, radius, detail);
  }

  OctahedronGeometry._internal(vertices, faces, radius, details) : super(vertices, faces, radius, details);
}
