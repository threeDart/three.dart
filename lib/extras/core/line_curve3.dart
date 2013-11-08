part of three;

class LineCurve3 extends Curve3D {

  var v1, v2;

  LineCurve3(this.v1, this.v2) : super();

  Vector3 getPoint( double t ) {

    Vector3 r = v2 - v1; // diff
    r.scale( t );
    r.add( v1 );

    return r;

  }
}
