part of three;

/**************************************************************
 *  Spline 3D curve
 **************************************************************/
class SplineCurve3 extends Curve3D {

  List<Vector3> points;

  SplineCurve3( [this.points] ) : super() {
    if (points == null) points = [];
  }

  Vector3 getPoint( t ) {

    var v = new Vector3();
    var c = new List<int>(4);
    var point = ( points.length - 1 ) * t,
        intPoint = point.floor().toInt(),
        weight = point - intPoint;

    c[ 0 ] = intPoint == 0 ? intPoint : intPoint - 1;
    c[ 1 ] = intPoint;
    c[ 2 ] = intPoint  > points.length - 2 ? points.length - 1 : intPoint + 1;
    c[ 3 ] = intPoint  > points.length - 3 ? points.length - 1 : intPoint + 2;

    var pt0 = points[ c[0] ],
      pt1 = points[ c[1] ],
      pt2 = points[ c[2] ],
      pt3 = points[ c[3] ];

    v.x = CurveUtils.interpolate(pt0.x, pt1.x, pt2.x, pt3.x, weight);
    v.y = CurveUtils.interpolate(pt0.y, pt1.y, pt2.y, pt3.y, weight);
    v.z = CurveUtils.interpolate(pt0.z, pt1.z, pt2.z, pt3.z, weight);

    return v;

  }

 }
