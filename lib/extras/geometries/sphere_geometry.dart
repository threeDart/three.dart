/*
 * @author mrdoob / http://mrdoob.com/
 * 
 * based on r66
 */

part of three;

/**
 *  A class for generating sphere geometries.
 *  
 *     var geometry = new SphereGeometry(5.0, 32, 32);
 *     var material = new MeshBasicMaterial(color: 0xffff00);
 *     var sphere = new Mesh(geometry, material);
 *     scene.add(sphere);
 */
class SphereGeometry extends Geometry {
  /// Creates a new sphere geometry.
  SphereGeometry([double radius = 50.0,
                  int widthSegments,
                  int heightSegments,
                  double phiStart = 0.0,
                  double phiLength = Math.PI * 2.0,
                  double thetaStart = 0.0,
                  double thetaLength = Math.PI]) {
    widthSegments = widthSegments != null ? Math.max(3, widthSegments) : 8; 
    heightSegments = heightSegments != null ? Math.max(2, heightSegments) : 6;
                
    List<List<int>> _vertices = [];
    List<List<Vector2>> uvs = [];

    for (var y = 0; y <= heightSegments; y++) {
      List<int> verticesRow = [];
      List<Vector2> uvsRow = [];

      for (var x = 0; x <= widthSegments; x++) {
        var u = x / widthSegments;
        var v = y / heightSegments;

        var vertex = new Vector3.zero()
          ..x = -radius * Math.cos(phiStart + u * phiLength) * Math.sin(thetaStart + v * thetaLength)
          ..y = radius * Math.cos(thetaStart + v * thetaLength)
          ..z = radius * Math.sin(phiStart + u * phiLength) * Math.sin(thetaStart + v * thetaLength);

        vertices.add(vertex);

        verticesRow.add(vertices.length - 1);
        uvsRow.add(new Vector2(u, 1 - v));
      }

      _vertices.add(verticesRow);
      uvs.add(uvsRow);
    }

    for (var y = 0; y < heightSegments; y++) {
      for (var x = 0; x < widthSegments; x++) {
        var v1 = _vertices[y][x + 1];
        var v2 = _vertices[y][x];
        var v3 = _vertices[y + 1][x];
        var v4 = _vertices[y + 1][x + 1];

        var n1 = vertices[v1].clone().normalize();
        var n2 = vertices[v2].clone().normalize();
        var n3 = vertices[v3].clone().normalize();
        var n4 = vertices[v4].clone().normalize();

        var uv1 = uvs[y    ][x + 1].clone();
        var uv2 = uvs[y    ][x    ].clone();
        var uv3 = uvs[y + 1][x    ].clone();
        var uv4 = uvs[y + 1][x + 1].clone();

        if (vertices[v1].y.abs() == radius) {
          uv1.x = (uv1.x + uv2.x) / 2;
          faces.add(new Face3(v1, v3, v4, [n1, n3, n4]));
          faceVertexUvs[0].add([uv1, uv3, uv4]);
        } else if (vertices[v3].y.abs() == radius) {
          uv3.x = (uv3.x + uv4.x) / 2;
          faces.add(new Face3(v1, v2, v3, [n1, n2, n3]));
          faceVertexUvs[0].add([uv1, uv2, uv3]);
        } else {
          faces.add(new Face3(v1, v2, v4, [n1, n2, n4]));
          faceVertexUvs[0].add([uv1, uv2, uv4]);

          faces.add(new Face3(v2, v3, v4, [n2.clone(), n3, n4.clone()]));
          faceVertexUvs[0].add([uv2.clone(), uv3, uv4.clone()]);
        }
      }
    }

    computeFaceNormals();

    boundingSphere = new BoundingSphere(radius: radius);
  }
}
