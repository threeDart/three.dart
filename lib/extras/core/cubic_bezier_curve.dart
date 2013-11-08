part of three;

class CubicBezierCurve extends Curve2D {
  Vector2 v0, v1, v2, v3;

  CubicBezierCurve( this.v0, this.v1, this.v2, this.v3 ) : super();

  getPoint ( t ) {

    var tx, ty;

    tx = ShapeUtils.b3( t, v0.x, v1.x, v2.x, v3.x );
    ty = ShapeUtils.b3( t, v0.y, v1.y, v2.y, v3.y );

    return new Vector2( tx, ty );

  }

  getTangent( t ) {

    var tx, ty;

    tx = CurveUtils.tangentCubicBezier( t, v0.x, v1.x, v2.x, v3.x );
    ty = CurveUtils.tangentCubicBezier( t, v0.y, v1.y, v2.y, v3.y );

    return new Vector2( tx, ty ).normalize();

  }
}
