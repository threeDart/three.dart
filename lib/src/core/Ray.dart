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

  Vector3 _v0, _v1, _v2;

  final num precision;

  Ray( [this.origin, this.direction, this.near = 0, this.far = double.INFINITY] )
      : _v0 = new Vector3(),
        _v1 = new Vector3(),
        _v2 = new Vector3(),
        precision = 0.0001 {

    if (this.origin == null) this.origin = new Vector3();
    if (this.direction == null) this.direction = new Vector3();

      }

  num _distanceFromIntersection( Vector3 origin, Vector3 direction, Vector3 position ) {
    var v0 = _v0, v1 = _v1, v2 = _v2;

    var dot, intersect, distance;
    v0.sub( position, origin );
    dot = v0.dot( direction );

    intersect = v1.add( origin, v2.copy( direction ).multiplyScalar( dot ) );
    distance = position.distanceTo( intersect );

    return distance;
  }

  //http://www.blackpawn.com/texts/pointinpoly/default.html
  bool _pointInFace3( Vector3 p, Vector3 a, Vector3 b, Vector3 c ) {
    var v0 = _v0, v1 = _v1, v2 = _v2;

    num dot00, dot01, dot02, dot11, dot12, invDenom, u, v;

    v0.sub( c, a );
    v1.sub( b, a );
    v2.sub( p, a );

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
    Vector3 a = new Vector3();
    Vector3 b = new Vector3();
    Vector3 c = new Vector3();
    Vector3 d = new Vector3();

    Vector3 originCopy = new Vector3();
    Vector3 directionCopy = new Vector3();

    Vector3 vector = new Vector3();
    Vector3 normal = new Vector3();
    Vector3 intersectPoint = new Vector3();

    Intersect intersect;
    List intersects = [];
    int l = object.children.length;

    if ( recursive ) {
      object.children.forEach((child) {
        intersects.addAll(intersectObject( child ));
      });
    }

    if ( object is Particle ) {
      num distance = _distanceFromIntersection( origin, direction, object.matrixWorld.getPosition() );

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
      num distance = _distanceFromIntersection( origin, direction, object.matrixWorld.getPosition() );
      Vector3 scale = Frustum.__v1.setValues( object.matrixWorld.getColumnX().length(), object.matrixWorld.getColumnY().length(), object.matrixWorld.getColumnZ().length() );

      if ( distance > mesh.geometry.boundingSphere.radius * Math.max( scale.x, Math.max( scale.y, scale.z ) ) ) {
        return intersects;
      }

      // Checking faces

      int f;

      IFace3 face;
      num dot, scalar;
      Geometry geometry = mesh.geometry;
      List vertices = geometry.vertices;
      Matrix4 objMatrix;
      Material material;

      List<Material> geometryMaterials = object.geometry.materials;
      bool isFaceMaterial = object.material is MeshFaceMaterial;
      int side = object.material.side;


      object.matrixRotationWorld.extractRotation( object.matrixWorld );

      int fl = geometry.faces.length;

      for (var f = 0; f < fl; f++) {

        face = geometry.faces[f];

        material = isFaceMaterial == true ? geometryMaterials[ face.materialIndex ] : object.material;
        if ( material == null ) continue;

        side = material.side;

        originCopy.copy( origin );
        directionCopy.copy( direction );

        objMatrix = object.matrixWorld;

        // determine if ray intersects the plane of the face
        // note: this works regardless of the direction of the face normal

        vector = objMatrix.multiplyVector3( vector.copy( face.centroid ) ).subSelf( originCopy );
        normal = object.matrixRotationWorld.multiplyVector3( normal.copy( face.normal ) );
        dot = directionCopy.dot( normal );

        // bail if ray and plane are parallel
        if ( dot.abs() < 0.0001 ) continue;

        // calc distance to plane

        scalar = normal.dot( vector ) / dot;

        // if negative distance, then plane is behind ray

        if ( scalar < 0 ) continue;

        if ( side == DoubleSide || ( side == FrontSide ? dot < 0 : dot > 0 ) ) {

          intersectPoint.add( originCopy, directionCopy.multiplyScalar( scalar ) );

          if ( face is Face3 ) {

            a = objMatrix.multiplyVector3( a.copy( vertices[ face.a ] ) );
            b = objMatrix.multiplyVector3( b.copy( vertices[ face.b ] ) );
            c = objMatrix.multiplyVector3( c.copy( vertices[ face.c ] ) );

            if ( _pointInFace3( intersectPoint, a, b, c ) ) {
              intersect = new Intersect(
                distance: originCopy.distanceTo( intersectPoint ),
                point: intersectPoint.clone(),
                face: face,
                object: object
              );

              intersects.add( intersect );

            }

          } else if ( face is Face4 ) {
            Face4 face4 = face;
            a = objMatrix.multiplyVector3( a.copy( vertices[ face4.a ] ) );
            b = objMatrix.multiplyVector3( b.copy( vertices[ face4.b ] ) );
            c = objMatrix.multiplyVector3( c.copy( vertices[ face4.c ] ) );
            d = objMatrix.multiplyVector3( d.copy( vertices[ face4.d ] ) );

            if ( _pointInFace3( intersectPoint, a, b, d ) || _pointInFace3( intersectPoint, b, c, d ) )
            {
              intersect = new Intersect(
                  distance: originCopy.distanceTo( intersectPoint ),
                  point: intersectPoint.clone(),
                  face: face,
                  object: object
              );

              intersects.add( intersect );
            }
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
  IFace3 face;
  Object3D object;

  Intersect({this.distance, this.point, this.face, this.object});
}



