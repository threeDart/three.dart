/*
 * @author WestLangley / https://github.com/WestLangley
 * @author zz85 / https://github.com/zz85
 * @author miningold / https://github.com/miningold
 *
 * Modified from the TorusKnotGeometry by @oosmoxiecode
 * 
 * based on r63
 */

part of three;

class TubeGeometry extends Geometry {
  List<Vector3> tangents;
  List<Vector3> normals;
  List<Vector3> binormals;
  
  List<List> grid = [];
  
  TubeGeometry(Curve path, 
              [int segments = 64, 
               double radius = 1.0, 
               int radialSegments = 8, 
               bool closed = false]) : super() {
    var numpoints = segments + 1;

    var frames = new TubeGeometryFrenetFrames(path, segments, closed);

    tangents = frames.tangents;
    normals = frames.normals;
    binormals = frames.binormals;
    
    for (var i = 0; i < numpoints; i++) {
      grid.add(new List(radialSegments));

      var u = i / (numpoints - 1);

      var pos = path.getPointAt(u);

      var normal = normals[i];
      var binormal = binormals[i];

      for (var j = 0; j < radialSegments; j++) {
        var v = j / radialSegments * 2 * Math.PI;

        var cx = -radius * Math.cos(v);
        var cy = radius * Math.sin(v);

        var pos2 = new Vector3.copy(pos);
        pos2.x += cx * normal.x + cy * binormal.x;
        pos2.y += cx * normal.y + cy * binormal.y;
        pos2.z += cx * normal.z + cy * binormal.z;

        grid[i][j] = _vert(pos2.x, pos2.y, pos2.z);
      }
    }


    // construct the mesh
    for (var i = 0; i < segments; i++) {
      for (var j = 0; j < radialSegments; j++) {
        var ip = closed ? (i + 1) % segments : i + 1;
        var jp = (j + 1) % radialSegments;

        var a = grid[i][j]; 
        var b = grid[ip][j];
        var c = grid[ip][jp];
        var d = grid[i][jp];

        var uva = new Vector2(i / segments, j / radialSegments);
        var uvb = new Vector2((i + 1) / segments, j / radialSegments);
        var uvc = new Vector2((i + 1) / segments, (j + 1) / radialSegments);
        var uvd = new Vector2(i / segments, (j + 1) / radialSegments);

        faces.add(new Face3(a, b, d));
        faceVertexUvs[0].add([uva, uvb, uvd]);

        faces.add(new Face3(b, c, d));
        faceVertexUvs[0].add([uvb.clone(), uvc, uvd.clone()]);
      }
    }

    computeFaceNormals();
    computeVertexNormals();
  }

  _vert(x, y, z) { 
    vertices.add(new Vector3(x, y, z));
    return vertices.length - 1;
  }
}

class TubeGeometryFrenetFrames {
  List<Vector3> tangents;
  List<Vector3> normals;
  List<Vector3> binormals;
  
  int nSegments;
  
  TubeGeometryFrenetFrames(path, int segments, bool closed) {
    var EPSILON = 0.0000000001;
    
    var numpoints = segments + 1;

    normals = new List(numpoints);
    binormals = new List(numpoints);

    // compute the tangent vectors for each segment on the path
    tangents = new List.generate(numpoints, (i) => path.getTangentAt(i / (numpoints - 1))..normalize());

    _initialNormal3() {
      normals[0] = new Vector3.zero();
      binormals[0] = new Vector3.zero();
      var smallest = double.MAX_FINITE;
      var tx = tangents[0].x.abs();
      var ty = tangents[0].y.abs();
      var tz = tangents[0].z.abs();
      var normal = new Vector3.zero();
      
      if (tx <= smallest) { normal = new Vector3(1.0, 0.0, 0.0); smallest = tx; }
      if (ty <= smallest) { normal = new Vector3(0.0, 1.0, 0.0); smallest = ty; }
      if (tz <= smallest) { normal = new Vector3(0.0, 0.0, 1.0); }

      var vec = tangents[0].cross(normal).normalize();

      normals[0] = tangents[0].cross(vec);
      binormals[0] = tangents[0].cross(normals[0]);
    }

    _initialNormal3();

    // compute the slowly-varying normal and binormal vectors for each segment on the path
    for (var i = 1; i < numpoints; i++) {
      normals[i] = normals[i - 1].clone();
      binormals[i] = binormals[i - 1].clone();

      Vector3 vec = tangents[i - 1].cross(tangents[i]);

      if (vec.length > EPSILON) {
        vec.normalize();

        var theta = Math.acos(tangents[i - 1].dot(tangents[i]));

        normals[i].applyProjection(new Matrix4.identity().rotate(vec, theta));
      }

      binormals[i] = tangents[i].cross(normals[i]);
    }

    // if the curve is closed, postprocess the vectors so the first and last normal vectors are the same
    if (closed) {
      var theta = Math.acos(normals[0].dot(normals[numpoints - 1]));
      theta /= (numpoints - 1);

      if (tangents[0].dot(normals[0].cross(normals[numpoints - 1])) > 0) {
        theta = -theta;
      }

      for (var i = 1; i < numpoints; i++) {
        normals[i].applyProjection(new Matrix4.identity().rotate(tangents[i], theta * i));
        binormals[i] = tangents[i].cross(normals[i]);
      }
    }
  }
}