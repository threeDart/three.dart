/*
 * @author hughes
 * 
 * based on r70
 */

part of three;

/** 
 * CircleGeometry is a simple shape of Euclidean geometry. It is contructed 
 * from a number of triangular segments that are oriented around a central 
 * point and extend as far out as a given radius. It is built counter-clockwise 
 * from a start angle and a given central angle. It can also be used to create 
 * regular polygons, where the number of segments determines the number of sides.
 * 
 *     var material = new THREE.MeshBasicMaterial(color: 0x0000ff);
 *     
 *     var radius = 5, segments = 32;
 *     var circleGeometry = new CircleGeometry(radius, segments);        
 *     var circle = new Mesh(circleGeometry, material);
 *     scene.add(circle);
 */
class CircleGeometry extends Geometry {
  String type = 'CircleGeometry';
  
  /// Creates a new circle geometry.
  CircleGeometry([double radius = 50.0, 
                  int segments, 
                  double thetaStart = 0.0, 
                  double thetaLength =  Math.PI * 2]) {
    segments = segments != null ? Math.max(3, segments) : 8;
        
    List<Vector2> uvs = [];
    var center = new Vector3.zero();
    var centerUV = new Vector2(0.5, 0.5);

    vertices.add(center);
    uvs.add(centerUV);

    for (var i = 0; i <= segments; i++) {
      var vertex = new Vector3.zero();
      vertex.x = radius * Math.cos(thetaStart + i / segments * thetaLength);
      vertex.y = radius * Math.sin(thetaStart + i / segments * thetaLength);
      
      vertices.add(vertex);
      uvs.add(new Vector2((vertex.x / radius + 1) / 2, -(vertex.y / radius + 1) / 2 + 1));
    }
    
    var n = new Vector3(0.0, 0.0, 1.0);
    
    for (var i = 1; i <= segments; i++) {
      faces.add(new Face3(i, i + 1, 0, [n.clone(), n.clone(), n.clone()]));
      faceVertexUvs[0].add([uvs[i].clone(), uvs[i + 1].clone(), centerUV.clone()]);
    }

    computeFaceNormals();

    boundingSphere = new BoundingSphere(radius: radius);
  }
}
