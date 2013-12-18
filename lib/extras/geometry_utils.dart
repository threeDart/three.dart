library GeometryUtils;

import "package:three/three.dart";
import 'package:vector_math/vector_math.dart';

// TODO(nelsonsilva) - Add remaining functions

/// Merge two geometries or geometry and geometry from object (using object's transform)
merge( geometry, mesh_OR_geometry /* mesh | geometry */, [int materialIndexOffset = 0] ) {

  Matrix4 matrix, normalMatrix;
  var geometry1 = geometry,
      vertexOffset = geometry1.vertices.length,
      uvPosition = geometry1.faceVertexUvs[ 0 ].length,
      geometry2 = (mesh_OR_geometry is Mesh) ? mesh_OR_geometry.geometry : mesh_OR_geometry,
      vertices1 = geometry1.vertices,
      vertices2 = geometry2.vertices,
      faces1 = geometry1.faces,
      faces2 = geometry2.faces,
      uvs1 = geometry1.faceVertexUvs[ 0 ],
      uvs2 = geometry2.faceVertexUvs[ 0 ];

  if ( mesh_OR_geometry is Mesh ) {

    if (mesh_OR_geometry.matrixAutoUpdate)
      mesh_OR_geometry.updateMatrix();

    matrix = mesh_OR_geometry.matrix;

    // getNormalMatrix => matrix.invert.transpose
    normalMatrix = new Matrix4.copy(matrix)
    ..invert()
    ..transpose();

  }

  // vertices

  vertices2.forEach((vertex) {
    var vertexCopy = vertex.clone();

    if ( matrix != null ) matrix.transform3(vertexCopy);

    vertices1.add( vertexCopy );
  });

  // faces

  faces2.forEach((face) {

    var faceCopy, normal, color,
        faceVertexNormals = face.vertexNormals,
        faceVertexColors = face.vertexColors;

    if ( face.size == 3 ) {

      faceCopy = new Face3( face.a + vertexOffset, face.b + vertexOffset, face.c + vertexOffset );

    } else if ( face.size == 4 ) {

      faceCopy = new Face4( face.a + vertexOffset, face.b + vertexOffset, face.c + vertexOffset, face.d + vertexOffset );

    }

    faceCopy.normal.setFrom( face.normal );

    if ( normalMatrix != null) {

      normalMatrix.transform3(faceCopy.normal).normalize();

    }

    faceVertexNormals.forEach((faceVertexNormal) {

      normal = faceVertexNormal.clone();

      if ( normalMatrix != null ) {

        normalMatrix.transform3(normal).normalize();

      }

      faceCopy.vertexNormals.add( normal );

    });

    faceCopy.color.copy( face.color );

    faceVertexColors.forEach((color) {
      faceCopy.vertexColors.add( color.clone() );
    });

    faceCopy.materialIndex =  materialIndexOffset;

    // TODO - Check if face.materialIndex should be initialized to zero
    if (face.materialIndex != null) {
      faceCopy.materialIndex += face.materialIndex;
    }

    faceCopy.centroid.setFrom( face.centroid );

    if ( matrix != null ) {

      matrix.transform3(faceCopy.centroid);

    }

    faces1.add( faceCopy );

  });

  // uvs

  uvs2.forEach((uv) {

    var uvCopy = uv.map((u) => new UV().copy(u)).toList();

    uvs1.add( uvCopy );

  });

}

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

triangleArea ( Vector3 vectorA, Vector3 vectorB, Vector3 vectorC ) {

  var tmp = (vectorB - vectorA).cross( vectorC - vectorA );

  return 0.5 * tmp.length;
}

// Center geometry so that 0,0,0 is in center of bounding box

center ( Geometry geometry ) {
  geometry.computeBoundingBox();
  
  var bb = geometry.boundingBox;
  
  var offset = (bb.min + bb.max) * -0.5;
  
  geometry.applyMatrix( new Matrix4.translation(offset) );
  geometry.computeBoundingBox();
  
  return offset;
}

