/*
 * @author mrdoob / http://mrdoob.com/
 * 
 * based on r70
 */

part of three;

/**
 *  A class for generating cylinder geometries
 *  
 *     var geometry = new CylinderGeometry(5.0, 5.0, 20, 32);
 *     var material = new MeshBasicMaterial(color: 0xffff00);
 *     var cylinder = new Mesh(geometry, material);
 *     scene.add(cylinder);
 */
class CylinderGeometry extends Geometry {
  String type = 'CylinderGeometry';

  /// Creates a new cylinder geometry.
  CylinderGeometry([double radiusTop = 20.0,
                    double radiusBottom = 20.0,
                    double height = 100.0,
                    int radialSegments = 8,
                    int heightSegments = 1,
                    bool openEnded = false,
                    double thetaStart = 0.0,
                    double thetaLength = 2 * Math.PI]) : super() {

    double heightHalf = height / 2;
    
    List<List<int>> vertices = [];
    List<List<Vector2>> uvs = [];

    for (var y = 0; y <= heightSegments; y++) {
      var verticesRow = [];
      var uvsRow = [];

      double v = y / heightSegments;
      var radius = v * (radiusBottom - radiusTop) + radiusTop;

      for (var x = 0; x <= radialSegments; x++) {
        double u = x / radialSegments;
        
        var vertex = new Vector3.zero()
          ..x = radius * Math.sin(u * thetaLength + thetaStart)
          ..y = -v * height + heightHalf
          ..z = radius * Math.cos(u * thetaLength + thetaStart);
              
        this.vertices.add(vertex);
        
        verticesRow.add(this.vertices.length - 1);
        uvsRow.add(new Vector2(u, 1 - v));
      }

      vertices.add(verticesRow);
      uvs.add(uvsRow);
    }

    var tanTheta = (radiusBottom - radiusTop) / height;
    var na, nb;

    for (var x = 0; x < radialSegments; x++) {
      if (radiusTop != 0) {
        na = this.vertices[vertices[0][x]].clone();
        nb = this.vertices[vertices[0][x + 1]].clone();
      } else {
        na = this.vertices[vertices[1][x]].clone();
        nb = this.vertices[vertices[1][x + 1]].clone();
      }

      na.y = Math.sqrt(na.x * na.x + na.z * na.z) * tanTheta;
      na.normalize();
      nb.y = Math.sqrt(nb.x * nb.x + nb.z * nb.z) * tanTheta;
      nb.normalize();

      for (var y = 0; y < heightSegments; y++) {
        var v1 = vertices[y][x];
        var v2 = vertices[y + 1][x];
        var v3 = vertices[y + 1][x + 1];
        var v4 = vertices[y][x + 1];
        
        var n1 = na.clone();
        var n2 = na.clone();
        var n3 = nb.clone();
        var n4 = nb.clone();

        var uv1 = uvs[y][x].clone();
        var uv2 = uvs[y + 1][x].clone();
        var uv3 = uvs[y + 1][x + 1].clone();
        var uv4 = uvs[y][x + 1].clone();

        faces.add(new Face3(v1, v2, v4, [n1, n2, n4]));
        faceVertexUvs[0].add([uv1, uv2, uv4]);

        faces.add(new Face3(v2, v3, v4, [n2.clone(), n3, n4.clone()]));
        faceVertexUvs[0].add([uv2.clone(), uv3, uv4.clone()]);
      }
    }

    // top cap
    if (!openEnded && radiusTop > 0) {
      this.vertices.add(new Vector3(0.0, heightHalf, 0.0));
      
      for (var x = 0; x < radialSegments; x++) {
        var v1 = vertices[0][x];
        var v2 = vertices[0][x + 1];
        var v3 = this.vertices.length - 1;
        
        var n1 = new Vector3(0.0, 1.0, 0.0);
        var n2 = new Vector3(0.0, 1.0, 0.0);
        var n3 = new Vector3(0.0, 1.0, 0.0);

        var uv1 = uvs[0][x].clone();
        var uv2 = uvs[0][x + 1].clone();
        var uv3 = new Vector2(uv2.x, 0.0);

        this.faces.add(new Face3(v1, v2, v3, [n1, n2, n3]));
        this.faceVertexUvs[0].add([uv1, uv2, uv3]);
      }
    }

    // bottom cap
    if (!openEnded && radiusBottom > 0) {
      this.vertices.add(new Vector3(0.0, -heightHalf, 0.0));

      for (var x = 0; x < radialSegments; x++) {
        var v1 = vertices[heightSegments][x + 1];
        var v2 = vertices[heightSegments][x];
        var v3 = this.vertices.length - 1;
        
        var n1 = new Vector3(0.0, -1.0, 0.0);
        var n2 = new Vector3(0.0, -1.0, 0.0);
        var n3 = new Vector3(0.0, -1.0, 0.0);

        var uv1 = uvs[heightSegments][x + 1].clone();
        var uv2 = uvs[heightSegments][x].clone();
        var uv3 = new Vector2(uv2.x, 1.0);

        faces.add(new Face3(v1, v2, v3, [n1, n2, n3]));
        faceVertexUvs[0].add([uv1, uv2, uv3]);
      }
    }

    computeFaceNormals();
  }
}
