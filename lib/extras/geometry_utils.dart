library GeometryUtils;

import "package:three/three.dart";

// TODO(nelsonsilva) - Add remaining functions
clone( Geometry geometry ) {

    var cloneGeo = new Geometry();

    var i, il;

    var vertices = geometry.vertices,
      faces = geometry.faces,
      uvs = geometry.faceVertexUvs[ 0 ];

    // materials

    if ( geometry.materials != null) {

      cloneGeo.materials = new List.from(geometry.materials);

    }

    // vertices
    cloneGeo.vertices = vertices.map((vertex) => vertex.clone()).toList();

    // faces
    cloneGeo.faces = faces.map((face) => face.clone()).toList();

    // uvs
    il = uvs.length;
    for ( i = 0; i < il; i ++ ) {

      var uv = uvs[ i ], uvCopy = [];

      var jl = uv.length;
      for ( var j = 0; j < jl; j ++ ) {

        uvCopy.add( new UV( uv[ j ].u, uv[ j ].v ) );

      }

      cloneGeo.faceVertexUvs[ 0 ].add( uvCopy );

    }

    return cloneGeo;

}

