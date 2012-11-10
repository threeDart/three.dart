part of three;

class LineCurve extends Curve2D {

  Vector2 v1, v2;

  LineCurve( this.v1, this.v2 ) : super();

  Vector2 getPoint( t ) {
    var point = v2.clone().subSelf(v1);
    point.multiplyScalar( t ).addSelf( v1 );
    return point;
  }

  // Line curve is linear, so we can overwrite default getPointAt
  Vector2 getPointAt( u ) => getPoint( u );

  Vector2 getTangent( t ) => v2.clone().subSelf(v1).normalize();

}
