part of three;

class LineCurve3 extends Curve3D {

  var v1, v2;

  LineCurve3(this.v1, this.v2) : super();

  Vector3 getPoint( t ) {

    var r = new Vector3();

    r.sub( v2, v1 ); // diff
    r.multiplyScalar( t );
    r.addSelf( v1 );

    return r;

  }
}
