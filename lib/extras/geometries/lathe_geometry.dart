/*
 * @author astrodud / http://astrodud.isgreat.org/
 * @author zz85 / https://github.com/zz85
 * @author bhouston / http://exocortex.com
 * 
 * based on r66
 */

part of three;

/// Class for generating meshes with axial symmetry. Possible uses include donuts, 
/// pipes, vases etc. The lathe rotate around the Z axis.
class LatheGeometry extends Geometry {
  /// Creates a new lathe geometry based on the following parameters:
  /// 
  /// * [points]: List of [Vector3]. Since this rotates around Z axis, the y-values can be set to 0
  /// * [segments]: The number of circumference segments to generate.
  /// * [phiStart]: The starting angle in radians. 
  /// * [phiLength]: The radian (0 to 2PI) range of the lathed section 2PI is a closed lathe, less than 2PI is a portion.
  LatheGeometry(List<Vector3> points, [int segments = 12, double phiStart = 0.0, double phiLength = 2 * Math.PI]) : super() {
    var inversePointLength = 1.0 / (points.length - 1);
    var inverseSegments = 1.0 / segments;
    
    for (var i = 0; i <= segments; i++) {
      var phi = phiStart + i * inverseSegments * phiLength;

      var c = Math.cos(phi),
          s = Math.sin(phi);
      
      points.forEach((pt) => vertices.add(new Vector3(c * pt.x - s * pt.y, s * pt.x + c * pt.y, pt.z)));
    }

    var np = points.length;

    for (var i = 0; i < segments; i++) {
      for ( var j = 0; j < points.length - 1; j++ ) {
        var base = j + np * i;
        var a = base;
        var b = base + np;
        var c = base + 1 + np;
        var d = base + 1;

        var u0 = i * inverseSegments;
        var v0 = j * inversePointLength;
        var u1 = u0 + inverseSegments;
        var v1 = v0 + inversePointLength;

        faces.add(new Face3(a, b, d));
        faceVertexUvs[0].add([new Vector2(u0, v0), new Vector2(u1, v0), new Vector2(u0, v1)]);

        faces.add(new Face3(b, c, d));
        faceVertexUvs[0].add([new Vector2(u1, v0), new Vector2(u1, v1), new Vector2(u0, v1)]);
      }
    }

    mergeVertices();
    computeFaceNormals();
    computeVertexNormals();
  }
}