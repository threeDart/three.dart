part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Ray {
  Vector3 origin,
          direction;
  num near,
      far;

  final num precision;

  Ray( [this.origin, this.direction, this.near = 0, this.far = double.INFINITY] )
      : precision = 0.0001 {

    if (this.origin == null) this.origin = new Vector3.zero();
    if (this.direction == null) this.direction = new Vector3.zero();

      }

  double _distanceFromIntersection( Vector3 origin, Vector3 direction, Vector3 position ) {
    Vector3 v0 = position - origin;
    double dot = v0.dot(direction);

    Vector3 intersect = origin + direction.scaled(dot);
    double distance = position.absoluteError(intersect);

    return distance;
  }

  //http://www.blackpawn.com/texts/pointinpoly/default.html
  bool _pointInFace3( Vector3 p, Vector3 a, Vector3 b, Vector3 c ) {
    num dot00, dot01, dot02, dot11, dot12, invDenom, u, v;

    Vector3 v0 = c - a;
    Vector3 v1 = b - a;
    Vector3 v2 = p - a;

    dot00 = v0.dot( v0 );
    dot01 = v0.dot( v1 );
    dot02 = v0.dot( v2 );
    dot11 = v1.dot( v1 );
    dot12 = v1.dot( v2 );

    invDenom = 1 / ( dot00 * dot11 - dot01 * dot01 );
    u = ( dot11 * dot02 - dot01 * dot12 ) * invDenom;
    v = ( dot00 * dot12 - dot01 * dot02 ) * invDenom;

    return ( u >= 0 ) && ( v >= 0 ) && ( u + v < 1 );
  }

  List<Intersect> intersectObject( Object3D object, {bool recursive: false} ) {
    List<Vector3> abcd = new List.generate(4, (_) => new Vector3.zero());

    Vector3 originCopy = new Vector3.zero();
    Vector3 directionCopy = new Vector3.zero();

    Vector3 vector = new Vector3.zero();
    Vector3 normal = new Vector3.zero();
    Vector3 intersectPoint = new Vector3.zero();

    Intersect intersect;
    List intersects = [];
    int l = object.children.length;

    if ( recursive ) {
      object.children.forEach((child) {
        intersects.addAll(intersectObject( child ));
      });
    }

    if ( object is Particle ) {
      num distance = _distanceFromIntersection( origin, direction, object.matrixWorld.getTranslation() );

      if ( distance > object.scale.x ) {
        return [];
      }

      intersect = new Intersect(
          distance: distance,
          point: object.position,
          face: null,
          object: object);


      intersects.add( intersect );

    } else if ( object is Mesh ) {
      Mesh mesh = object;
      // Checking boundingSphere
      num distance = _distanceFromIntersection( origin, direction, object.matrixWorld.getTranslation() );
      Vector3 scale = Frustum.__v1.setValues( object.matrixWorld.getColumn(0).length, object.matrixWorld.getColumn(1).length, object.matrixWorld.getColumn(2).length );

      if ( distance > mesh.geometry.boundingSphere.radius * Math.max( scale.x, Math.max( scale.y, scale.z ) ) ) {
        return intersects;
      }

      // Checking faces

      int f;

      Face face;
      num dot, scalar;
      Geometry geometry = mesh.geometry;
      List vertices = geometry.vertices;
      Matrix4 objMatrix;
      Material material;

      List<Material> geometryMaterials = object.geometry.materials;
      bool isFaceMaterial = object.material is MeshFaceMaterial;
      int side = object.material.side;


      extractRotation(object.matrixRotationWorld, object.matrixWorld);

      int fl = geometry.faces.length;

      for (var f = 0; f < fl; f++) {

        face = geometry.faces[f];

        material = isFaceMaterial == true ? geometryMaterials[ face.materialIndex ] : object.material;
        if ( material == null ) continue;

        side = material.side;

        originCopy.setFrom( origin );
        directionCopy.setFrom( direction );

        objMatrix = object.matrixWorld;

        // determine if ray intersects the plane of the face
        // note: this works regardless of the direction of the face normal

        vector.setFrom(face.centroid);
        vector.applyProjection(objMatrix).sub(originCopy);
        normal.setFrom(face.normal);
        normal.applyProjection(object.matrixRotationWorld);
        dot = directionCopy.dot(normal);

        // bail if ray and plane are parallel
        if ( dot.abs() < 0.0001 ) continue;

        // calc distance to plane

        scalar = normal.dot( vector ) / dot;

        // if negative distance, then plane is behind ray

        if ( scalar < 0 ) continue;

        if ( side == DoubleSide || ( side == FrontSide ? dot < 0 : dot > 0 ) ) {

          intersectPoint = originCopy + directionCopy.scale(scalar);

          abcd = face.indices.map((idx) => vertices[idx].clone().applyProjection(objMatrix)).toList();

          var pointInFace;

          // TODO - Make this work a face of arbitrary size
          if ( face.size == 3) {

            pointInFace =  _pointInFace3( intersectPoint, abcd[0], abcd[1], abcd[2] );

          } else if ( face.size == 4 ) {

            pointInFace =
                _pointInFace3( intersectPoint, abcd[0], abcd[1], abcd[3]) ||
                _pointInFace3( intersectPoint, abcd[1], abcd[2], abcd[3] );

          }

          if ( pointInFace  ) {
            intersect = new Intersect(
                distance: originCopy.absoluteError( intersectPoint ),
                point: intersectPoint.clone(),
                face: face,
                object: object
            );

            intersects.add( intersect );
          }
        }
      }
    }

    return intersects;
  }

  List<Intersect> intersectObjects( List<Object3D> objects ) {
    int l = objects.length;
    List<Intersect> intersects = [];

    objects.forEach((o) => intersects.addAll(intersectObject(o)));

    intersects.sort( ( a, b ) => a.distance.compareTo(b.distance) );

    return intersects;
  }

}

class Intersect {
  num distance;
  Vector3 point;
  Face face;
  Object3D object;

  Intersect({this.distance, this.point, this.face, this.object});
}



