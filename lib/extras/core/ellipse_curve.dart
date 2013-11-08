part of three;

class EllipseCurve extends Curve2D {
  num aX, aY;
  num xRadius, yRadius;
  num aStartAngle, aEndAngle;
  bool aClockwise;

  EllipseCurve(this.aX, this.aY, this.xRadius, this.yRadius,
               this.aStartAngle, this.aEndAngle,
               this.aClockwise) : super();

  Vector2 getPoint( t ) {

    var deltaAngle = aEndAngle - aStartAngle;

    if ( !aClockwise ) {
      t = 1 - t;
    }

    var angle = aStartAngle + t * deltaAngle;

    var tx = aX + xRadius * Math.cos( angle );
    var ty = aY + yRadius * Math.sin( angle );

    return new Vector2( tx, ty );

  }
}
