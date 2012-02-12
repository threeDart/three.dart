/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/ 
 */

class Ray 
{
  Vector3 _origin;
  Vector3 _direction;
  
  Ray( Vector3 origin, Vector3 direction ) 
  {
    _origin = ( origin != null) ? origin : new Vector3();
    _direction = ( direction != null ) ? direction : new Vector3();
  }
  
  List intersectObject( Object3D object ) 
  {
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
    
    //TODO: not sure this is equivalent logic..
    for ( int i = 0; i < l; i ++ ) {
      //Array.prototype.push.apply( intersects, intersectObject( object.children[ i ] ) );
      intersects.addAll(intersectObject( object.children[ i ] ));
    }

    if ( object is Particle ) 
    {
      num distance = distanceFromIntersection( _origin, _direction, object.matrixWorld.getPosition() );

      if ( distance > object.scale.x ) {
        return [];
      }

      intersect = new Intersect( distance, object.position, null, object );
      
//      intersect = {
//        "distance": distance,
//        "point": object.position,
//        "face": null,
//        "object": object
//      };

      intersects.add( intersect );

    } else if ( object is Mesh ) {
      Mesh mesh = object;
      // Checking boundingSphere
      num distance = distanceFromIntersection( _origin, _direction, object.matrixWorld.getPosition() );
      Vector3 scale = Frustum.__v1.setValues( object.matrixWorld.getColumnX().length(), object.matrixWorld.getColumnY().length(), object.matrixWorld.getColumnZ().length() );

      if ( distance > mesh.geometry.boundingSphere['radius'] * Math.max( scale.x, Math.max( scale.y, scale.z ) ) ) {
        return intersects;
      }

      // Checking faces

      int f;
      
      IFace3 face; 
      num dot, scalar;
      Geometry geometry = mesh.geometry;
      List vertices = geometry.vertices;
      Matrix4 objMatrix;
      
      int fl = geometry.faces.length;

      object.matrixRotationWorld.extractRotation( object.matrixWorld );

      for ( f = 0; f < fl; f ++ ) {

        face = geometry.faces[ f ];

        originCopy.copy( _origin );
        directionCopy.copy( _direction );

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

        if ( object.doubleSided || ( object.flipSided ? dot > 0 : dot < 0 ) ) {

          intersectPoint.add( originCopy, directionCopy.multiplyScalar( scalar ) );

          if ( face is Face3 ) {

            a = objMatrix.multiplyVector3( a.copy( vertices[ face.a ].position ) );
            b = objMatrix.multiplyVector3( b.copy( vertices[ face.b ].position ) );
            c = objMatrix.multiplyVector3( c.copy( vertices[ face.c ].position ) );

            if ( pointInFace3( intersectPoint, a, b, c ) ) 
            {
              intersect = new Intersect( originCopy.distanceTo( intersectPoint ), intersectPoint.clone(), face, object );
              
//              intersect = {
//                "distance": originCopy.distanceTo( intersectPoint ),
//                "point": intersectPoint.clone(),
//                "face": face,
//                "object": object
//              };

              intersects.add( intersect );

            }

          } else if ( face is Face4 ) {
            Face4 face4 = face;
            a = objMatrix.multiplyVector3( a.copy( vertices[ face4.a ].position ) );
            b = objMatrix.multiplyVector3( b.copy( vertices[ face4.b ].position ) );
            c = objMatrix.multiplyVector3( c.copy( vertices[ face4.c ].position ) );
            d = objMatrix.multiplyVector3( d.copy( vertices[ face4.d ].position ) );

            if ( pointInFace3( intersectPoint, a, b, d ) || pointInFace3( intersectPoint, b, c, d ) ) 
            {
              intersect = new Intersect( originCopy.distanceTo( intersectPoint ), intersectPoint.clone(), face, object );
              
//              intersect = {
//                "distance": originCopy.distanceTo( intersectPoint ),
//                "point": intersectPoint.clone(),
//                "face": face,
//                "object": object
//              };

              intersects.add( intersect );
            }
          }
        }
      }
    }

    return intersects;
  } 
  
  List intersectScene( Scene scene ) {
    return intersectObjects( scene.children );
  }

  List intersectObjects( List objects )
  {
    int l = objects.length;
    List intersects = [];

    //TODO: not sure this is equivalent logic..
    for ( int i = 0; i < l; i ++ ) {
      //Array.prototype.push.apply( intersects, intersectObject( objects[ i ] ) );
      intersects.addAll(intersectObject( objects[ i ] ));
    }

    intersects.sort( function ( a, b ) { return a.distance - b.distance; } );

    return intersects;
  }

  num distanceFromIntersection( Vector3 origin, Vector3 direction, Vector3 position ) 
  {
    //TODO: Not sure if these are supposed to be declared in here...
    Vector3 v0 = new Vector3(), v1 = new Vector3(), v2 = new Vector3();
    
    var dot, intersect, distance;
    v0.sub( position, origin );
    dot = v0.dot( direction );

    intersect = v1.add( origin, v2.copy( direction ).multiplyScalar( dot ) );
    distance = position.distanceTo( intersect );

    return distance;
  }
  
  //http://www.blackpawn.com/texts/pointinpoly/default.html
  bool pointInFace3( Vector3 p, Vector3 a, Vector3 b, Vector3 c ) 
  {
    //TODO: Not sure if these are supposed to be declared in here...
    Vector3 v0 = new Vector3(), v1 = new Vector3(), v2 = new Vector3();
    
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
}

class Intersect 
{
  num distance;
  Vector3 intersectPoint;
  IFace3 face;
  Object3D object;
  
  Intersect(num d, Vector3 iPoint, IFace3 f, Object3D obj )
  {
    distance = d;
    intersectPoint = iPoint;
    face = f;
    object = obj;
  }
}



