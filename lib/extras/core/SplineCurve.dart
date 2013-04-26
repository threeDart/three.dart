part of three;

class SplineCurve extends Curve2D {
  List<Vector2> points;

  SplineCurve( [this.points = null] ) {
    if (points == null) points = [];
  }

  getPoint( t ) {

    var v = new Vector2();
    var c = new List(4);
    var point, intPoint, weight;
    point = ( points.length - 1 ) * t;

    intPoint = point.floor().toInt();
    weight = point - intPoint;

    c[ 0 ] = intPoint == 0 ? intPoint : intPoint - 1;
    c[ 1 ] = intPoint;
    c[ 2 ] = intPoint  > points.length - 2 ? points.length -1 : intPoint + 1;
    c[ 3 ] = intPoint  > points.length - 3 ? points.length -1 : intPoint + 2;

    v.x = CurveUtils.interpolate( points[ c[ 0 ] ].x, points[ c[ 1 ] ].x, points[ c[ 2 ] ].x, points[ c[ 3 ] ].x, weight );
    v.y = CurveUtils.interpolate( points[ c[ 0 ] ].y, points[ c[ 1 ] ].y, points[ c[ 2 ] ].y, points[ c[ 3 ] ].y, weight );

    return v;

  }
}
