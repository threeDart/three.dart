part of three;

class ClosedSplineCurve3 extends Curve3D {

  List<Vector3> points;

  ClosedSplineCurve3( [this.points] ) : super() {
    if (points == null) points = [];
  }

  Vector3 getPoint( t ) {

    var v = new Vector3.zero();
    var c = [];
    var point,
        intPoint,
        weight;

    point = ( points.length - 0 ) * t;
    // This needs to be from 0-length +1

    intPoint = point.floor();
    weight = point - intPoint;

    intPoint += intPoint > 0 ? 0 : ( ( intPoint.abs() / points.length ).floor() + 1 ) * points.length;
    c[ 0 ] = ( intPoint - 1 ) % points.length;
    c[ 1 ] = ( intPoint ) % points.length;
    c[ 2 ] = ( intPoint + 1 ) % points.length;
    c[ 3 ] = ( intPoint + 2 ) % points.length;

    v.x = CurveUtils.interpolate( points[ c[ 0 ] ].x, points[ c[ 1 ] ].x, points[ c[ 2 ] ].x, points[ c[ 3 ] ].x, weight );
    v.y = CurveUtils.interpolate( points[ c[ 0 ] ].y, points[ c[ 1 ] ].y, points[ c[ 2 ] ].y, points[ c[ 3 ] ].y, weight );
    v.z = CurveUtils.interpolate( points[ c[ 0 ] ].z, points[ c[ 1 ] ].z, points[ c[ 2 ] ].z, points[ c[ 3 ] ].z, weight );

    return v;

  }
}
