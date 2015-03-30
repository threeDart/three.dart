/*
 * @author oosmoxiecode
 * based on http://code.google.com/p/away3d/source/browse/trunk/fp10/Away3D/src/away3d/primitives/TorusKnot.as?spec=svn2473&r=2473
 * 
 * based on r66
 */

part of three;

/** 
 * Class for generating torus knot geometries, the particular shape 
 * of which is defined by a pair of coprime integers, p and q. 
 * If p and q are not coprime, the result will be a torus link.
 * 
 *     var geometry = new TorusKnotGeometry(10.0, 3.0, 100, 16);
 *     var material = new MeshBasicMaterial(color: 0xffff00);
 *     var torusKnot = new Mesh(geometry, material);
 *     scene.add(torusKnot);
 * 
 */
class TorusKnotGeometry extends Geometry {
  List<List> _grid;
  
  /// Creates a new torus knot geometry.
  TorusKnotGeometry([double radius = 100.0,
                     double tube = 40.0,
                     int radialSegments = 64,
                     int tubularSegments = 8,
                     double p = 2.0,
                     double q = 3.0,
                     double heightScale = 1.0]) : super() {
    _grid = new List(radialSegments);

    for (var i = 0; i < radialSegments; i++) {
      _grid[i] = new List(tubularSegments);
      var u = i / radialSegments * 2 * p * Math.PI;
      var p1 = _getPos(u, q, p, radius, heightScale);
      var p2 = _getPos(u + 0.01, q, p, radius, heightScale);
      var tang = p2 - p1;
      var n = p2 + p1;

      var bitan = tang.cross(n).normalize();
      n = bitan.cross(tang).normalize();

      for (var j = 0; j < tubularSegments; j++) {
        var v = j / tubularSegments * 2 * Math.PI;
        var cx = -tube * Math.cos(v);
        var cy = tube * Math.sin(v);

        var pos = new Vector3.zero()
          ..x = p1.x + cx * n.x + cy * bitan.x
          ..y = p1.y + cx * n.y + cy * bitan.y
          ..z = p1.z + cx * n.z + cy * bitan.z;
        
        vertices.add(pos);
        _grid[i][j] = vertices.length - 1;
      }
    }

    for (var i = 0; i < radialSegments; ++ i) {
      for (var j = 0; j < tubularSegments; ++ j) {
        var ip = (i + 1) % radialSegments;
        var jp = (j + 1) % tubularSegments;

        var a = _grid[i][j];
        var b = _grid[ip][j];
        var c = _grid[ip][jp];
        var d = _grid[i][jp];

        var uva = new Vector2(i / radialSegments, j / tubularSegments);
        var uvb = new Vector2((i + 1) / radialSegments, j / tubularSegments);
        var uvc = new Vector2((i + 1) / radialSegments, (j + 1) / tubularSegments);
        var uvd = new Vector2(i / radialSegments, (j + 1) / tubularSegments);

        faces.add(new Face3(a, b, d));
        faceVertexUvs[0].add([uva, uvb, uvd]);

        faces.add(new Face3(b, c, d));
        faceVertexUvs[0].add([uvb.clone(), uvc, uvd.clone()]);
      }
    }
    
    computeFaceNormals();
    computeVertexNormals();  
  }
  
  Vector3 _getPos(double u, double in_q, double in_p, double radius, double heightScale) {
    var cu = Math.cos(u);
    var su = Math.sin(u);
    var quOverP = in_q / in_p * u;
    var cs = Math.cos(quOverP);

    var tx = radius * (2 + cs) * 0.5 * cu;
    var ty = radius * (2 + cs) * su * 0.5;
    var tz = heightScale * radius * Math.sin(quOverP) * 0.5;

    return new Vector3(tx, ty, tz);
  }
}
