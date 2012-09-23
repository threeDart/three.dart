class IcosahedronGeometry extends PolyhedronGeometry {
  
  factory IcosahedronGeometry( radius, detail ) {
    var t = ( 1 + Math.sqrt( 5 ) ) / 2;
  
    var vertices = [
      [ -1,  t,  0 ], [  1, t, 0 ], [ -1, -t,  0 ], [  1, -t,  0 ],
      [  0, -1,  t ], [  0, 1, t ], [  0, -1, -t ], [  0,  1, -t ],
      [  t,  0, -1 ], [  t, 0, 1 ], [ -t,  0, -1 ], [ -t,  0,  1 ]
    ];
  
    var faces = [
      [ 0, 11,  5 ], [ 0,  5,  1 ], [  0,  1,  7 ], [  0,  7, 10 ], [  0, 10, 11 ],
      [ 1,  5,  9 ], [ 5, 11,  4 ], [ 11, 10,  2 ], [ 10,  7,  6 ], [  7,  1,  8 ],
      [ 3,  9,  4 ], [ 3,  4,  2 ], [  3,  2,  6 ], [  3,  6,  8 ], [  3,  8,  9 ],
      [ 4,  9,  5 ], [ 2,  4, 11 ], [  6,  2, 10 ], [  8,  6,  7 ], [  9,  8,  1 ]
    ];
    
    return new IcosahedronGeometry._internal(vertices, faces, radius, detail);
  }
  
  IcosahedronGeometry._internal(vertices, faces, radius, details) : super(vertices, faces, radius, details);
}
