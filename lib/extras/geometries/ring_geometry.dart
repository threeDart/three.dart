/*
 * @author Kaleb Murphy
 * 
 * based on r66
 */

part of three;

/**
 * A class for generating a two-dimensional ring geometry.
 * 
 *     var geometry = new RingGeometry(1.0, 5.0, 32);
 *     var material = new MeshBasicMaterial(color: 0xffff00, side: DOUBLE_SIDE);
 *     var mesh = new Mesh(geometry, material);
 *     scene.add(mesh);
 */
class RingGeometry extends Geometry {
  RingGeometry([double innerRadius = 0.0, 
                double outerRadius = 50.0, 
                int thetaSegments, 
                int phiSegments, 
                double thetaStart = 0.0, 
                double thetaLength = Math.PI * 2]) : super() {
    thetaSegments = thetaSegments != null ? Math.max(3, thetaSegments) : 8;
    phiSegments = phiSegments != null ? Math.max(3, phiSegments) : 8;
    
    List<Vector2> uvs = [];
    double radius = innerRadius;
    double radiusStep = ((outerRadius - innerRadius) / phiSegments);

    for (var i = 0; i <= phiSegments; i++) { // concentric circles inside ring
      for (var o = 0; o <= thetaSegments; o++) { // number of segments per circle
        var vertex = new Vector3.zero();
        var segment = thetaStart + o / thetaSegments * thetaLength;

        vertex.x = radius * Math.cos(segment);
        vertex.y = radius * Math.sin(segment);

        vertices.add(vertex);
        uvs.add(new Vector2((vertex.x / outerRadius + 1) / 2, (vertex.y / outerRadius + 1) / 2));
      }

      radius += radiusStep;
    }

    for (var i = 0; i < phiSegments; i++) { // concentric circles inside ring
      var thetaSegment = i * thetaSegments;

      for (var o = 0; o <= thetaSegments; o++) { // number of segments per circle
        var segment = o + thetaSegment;

        var v1 = segment + i;
        var v2 = segment + thetaSegments + i;
        var v3 = segment + thetaSegments + 1 + i;

        faces.add(new Face3(v1, v2, v3, [new Vector3(0.0, -1.0, 0.0), new Vector3(0.0, -1.0, 0.0), new Vector3(0.0, -1.0, 0.0)]));
        faceVertexUvs[0].add([uvs[v1].clone(), uvs[v2].clone(), uvs[v3].clone()]);

        v1 = segment + i;
        v2 = segment + thetaSegments + 1 + i;
        v3 = segment + 1 + i;

        faces.add(new Face3(v1, v2, v3, [new Vector3(0.0, -1.0, 0.0), new Vector3(0.0, -1.0, 0.0), new Vector3(0.0, -1.0, 0.0)]));
        faceVertexUvs[0].add([uvs[v1].clone(), uvs[v2].clone(), uvs[v3].clone()]);
      }
    }
    
    computeFaceNormals();

    boundingSphere = new BoundingSphere(radius: radius);
  }
}