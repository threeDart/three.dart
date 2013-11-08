part of three;

class TetrahedronGeometry extends PolyhedronGeometry {
  factory TetrahedronGeometry( radius, detail ) {
    var vertices = [
                    [ 1,  1,  1 ], [ -1, -1, 1 ], [ -1, 1, -1 ], [ 1, -1, -1 ]
                    ];

    var faces = [
                 [ 2, 1, 0 ], [ 0, 3, 2 ], [ 1, 3, 0 ], [ 2, 3, 1 ]
                 ];

    return new TetrahedronGeometry._internal(vertices, faces, radius, detail);
  }

  TetrahedronGeometry._internal(vertices, faces, radius, details) : super(vertices, faces, radius, details);

}
