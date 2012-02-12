/**
 * @author mr.doob / http://mrdoob.com/
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author philogb / http://blog.thejit.org/
 * @author jordi_ros / http://plattsoft.com
 * @author D1plo1d / http://github.com/D1plo1d
 * @author alteredq / http://alteredqualia.com/
 * @author mikael emtinger / http://gomo.se/
 * @author timknip / http://www.floorplanner.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Matrix4 
{
  List _flat;
  // TODO: Wraps up a Matrix3 class. Substitute for inheritance?
  Matrix3 _m33;
  num _n11, _n12, _n13, _n14, _n21, _n22, _n23, _n24, _n31, _n32, _n33, _n34, _n41, _n42, _n43, _n44;
  
  //TODO: Fix "Expected Constant Expression" problem
  // Axis Vectors, X, Y, Z
  static Vector3 __v1; //= new Vector3();
  static Vector3 __v2; //= new Vector3();
  static Vector3 __v3; //= new Vector3();

  // Rotation, Scale
  static Matrix4 __m1; //= new Matrix4();
  static Matrix4 __m2; //= new Matrix4();
  
  get m33() {  return _m33;  }
  
  get n11() {  return _n11;  }
  set n11(num value) {  _n11 = value;  }
  get n12() {  return _n12;  }
  set n12(num value) {  _n12 = value;  }
  get n13() {  return _n13;  }
  set n13(num value) {  _n13 = value;  }
  get n14() {  return _n14;  }
  set n14(num value) {  _n14 = value;  }
  get n21() {  return _n21;  }
  set n21(num value) {  _n21 = value;  }
  get n22() {  return _n22;  }
  set n22(num value) {  _n22 = value;  }
  get n23() {  return _n23;  }
  set n23(num value) {  _n23 = value;  }
  get n24() {  return _n24;  }
  set n24(num value) {  _n24 = value;  }
  get n31() {  return _n31;  }
  set n31(num value) {  _n31 = value;  }
  get n32() {  return _n32;  }
  set n32(num value) {  _n32 = value;  }
  get n33() {  return _n33;  }
  set n33(num value) {  _n33 = value;  }
  get n34() {  return _n34;  }
  set n34(num value) {  _n34 = value;  }
  get n41() {  return _n41;  }
  set n41(num value) {  _n41 = value;  }
  get n42() {  return _n42;  }
  set n42(num value) {  _n42 = value;  }
  get n43() {  return _n43;  }
  set n43(num value) {  _n43 = value;  }
  get n44() {  return _n44;  }
  set n44(num value) {  _n44 = value;  }
  
  Matrix4( [num n11, num n12, num n13, num n14, num n21, num n22, num n23, num n24, num n31, num n32, num n33, num n34, num n41, num n42, num n43, num n44] ) 
  {
    // to resolve "num is not assignable to bool" problem
    // Set to received matrix values or create Identity Matrix
    setValues(
      ( n11 !== null ) ? n11 : 1, ( n12 !== null ) ? n12 : 0, ( n13 !== null ) ? n13 : 0, ( n14 !== null ) ? n14 : 0,
      ( n21 !== null ) ? n21 : 0, ( n22 !== null ) ? n22 : 1, ( n23 !== null ) ? n23 : 0, ( n24 !== null ) ? n24 : 0,
      ( n31 !== null ) ? n31 : 0, ( n32 !== null ) ? n32 : 0, ( n33 !== null ) ? n33 : 1, ( n34 !== null ) ? n34 : 0,
      ( n41 !== null ) ? n41 : 0, ( n42 !== null ) ? n42 : 0, ( n43 !== null ) ? n43 : 0, ( n44 !== null ) ? n44 : 1
    );
    
    //TODO: need to make this List length 16?
    _flat = new List();//( 16 );
    // Equivalent of super-constructor?
    _m33 = new Matrix3();
    
    //TODO: initialise static vars.. Ok here?
    if (__v1 == null)   __v1 = new Vector3();
    if (__v2 == null)   __v2 = new Vector3();
    if (__v3 == null)   __v3 = new Vector3();

    //TODO: to alleviate static const problem. createMatrices() constructor introduced
    // to avoid infinite loop problem.
    // Rotation, Scale
      if (__m1 == null)   __m1 = new Matrix4.createMatrices();
      if (__m2 == null)   __m2 = new Matrix4.createMatrices();
  }
  
  Matrix4.createMatrices( [num n11, num n12, num n13, num n14, num n21, num n22, num n23, num n24, num n31, num n32, num n33, num n34, num n41, num n42, num n43, num n44] )
  {
    // to resolve "num is not assignable to bool" problem
    // Set to received matrix values or create Identity Matrix
    setValues(
      ( n11 !== null ) ? n11 : 1, ( n12 !== null ) ? n12 : 0, ( n13 !== null ) ? n13 : 0, ( n14 !== null ) ? n14 : 0,
      ( n21 !== null ) ? n21 : 0, ( n22 !== null ) ? n22 : 1, ( n23 !== null ) ? n23 : 0, ( n24 !== null ) ? n24 : 0,
      ( n31 !== null ) ? n31 : 0, ( n32 !== null ) ? n32 : 0, ( n33 !== null ) ? n33 : 1, ( n34 !== null ) ? n34 : 0,
      ( n41 !== null ) ? n41 : 0, ( n42 !== null ) ? n42 : 0, ( n43 !== null ) ? n43 : 0, ( n44 !== null ) ? n44 : 1
    );
    
    //TODO: need to make this List length 16?
    _flat = new List();//( 16 );
    // Equivalent of super-constructor?
    _m33 = new Matrix3();
    
    //TODO: initialise static vars.. Ok here?
    if (__v1 == null)   __v1 = new Vector3();
    if (__v2 == null)   __v2 = new Vector3();
    if (__v3 == null)   __v3 = new Vector3();

    // Rotation, Scale
    //__m1 = new Matrix4.createMatrices();
    //__m2 = new Matrix4.createMatrices();
  }
  
  // "set" changed to "setM" as "set" is reserved
  Matrix4 setValues( num n11, num n12, num n13, num n14, num n21, num n22, num n23, num n24, num n31, num n32, num n33, num n34, num n41, num n42, num n43, num n44 ) 
  {
    _n11 = n11; _n12 = n12; _n13 = n13; _n14 = n14;
    _n21 = n21; _n22 = n22; _n23 = n23; _n24 = n24;
    _n31 = n31; _n32 = n32; _n33 = n33; _n34 = n34;
    _n41 = n41; _n42 = n42; _n43 = n43; _n44 = n44;

    return this;
  }

  Matrix4 identity() 
  {
    setValues(
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1
    );

    return this;
  }

  Matrix4 copy( Matrix4 m ) 
  {
    setValues(
      m.n11, m.n12, m.n13, m.n14,
      m.n21, m.n22, m.n23, m.n24,
      m.n31, m.n32, m.n33, m.n34,
      m.n41, m.n42, m.n43, m.n44
    );

    return this;
  }

  // TODO: a good candidate for strict typing
  Matrix4 lookAt( Vector3 eye, Vector3 center, Vector3 up ) 
  {
    Vector3 x = __v1, y = __v2, z = __v3;

    z.sub( eye, center ).normalize();

    if ( z.length() === 0 ) {
      z.z = 1;
    }

    x.cross( up, z ).normalize();

    if ( x.length() === 0 ) {
      z.x += 0.0001;
      x.cross( up, z ).normalize();
    }

    y.cross( z, x ).normalize();

    _n11 = x.x; _n12 = y.x; _n13 = z.x;
    _n21 = x.y; _n22 = y.y; _n23 = z.y;
    _n31 = x.z; _n32 = y.z; _n33 = z.z;

    return this;
  }

  Matrix4 multiply( Matrix4 a, Matrix4 b ) 
  {
    num a11 = a.n11, a12 = a.n12, a13 = a.n13, a14 = a.n14,
    a21 = a.n21, a22 = a.n22, a23 = a.n23, a24 = a.n24,
    a31 = a.n31, a32 = a.n32, a33 = a.n33, a34 = a.n34,
    a41 = a.n41, a42 = a.n42, a43 = a.n43, a44 = a.n44,

    b11 = b.n11, b12 = b.n12, b13 = b.n13, b14 = b.n14,
    b21 = b.n21, b22 = b.n22, b23 = b.n23, b24 = b.n24,
    b31 = b.n31, b32 = b.n32, b33 = b.n33, b34 = b.n34,
    b41 = b.n41, b42 = b.n42, b43 = b.n43, b44 = b.n44;

    _n11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
    _n12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
    _n13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
    _n14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

    _n21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
    _n22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
    _n23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
    _n24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

    _n31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
    _n32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
    _n33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
    _n34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

    _n41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
    _n42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
    _n43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
    _n44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;

    return this;
  }

  Matrix4 multiplySelf( Matrix4 m )
  {
    return multiply( this, m );
  }

  // TODO: good example of typing
  Matrix4 multiplyToArray( Matrix4 a, Matrix4 b, List r )
  {
    multiply( a, b );

    r[ 0 ] = _n11; r[ 1 ] = _n21; r[ 2 ] = _n31; r[ 3 ] = _n41;
    r[ 4 ] = _n12; r[ 5 ] = _n22; r[ 6 ] = _n32; r[ 7 ] = _n42;
    r[ 8 ]  = _n13; r[ 9 ]  = _n23; r[ 10 ] = _n33; r[ 11 ] = _n43;
    r[ 12 ] = _n14; r[ 13 ] = _n24; r[ 14 ] = _n34; r[ 15 ] = _n44;

    return this;
  }

  Matrix4 multiplyScalar( num s ) 
  {
    _n11 *= s; _n12 *= s; _n13 *= s; _n14 *= s;
    _n21 *= s; _n22 *= s; _n23 *= s; _n24 *= s;
    _n31 *= s; _n32 *= s; _n33 *= s; _n34 *= s;
    _n41 *= s; _n42 *= s; _n43 *= s; _n44 *= s;

    return this;
  }

  Vector3 multiplyVector3( Vector3 v ) 
  {
    num vx = v.x, vy = v.y, vz = v.z,
    d = 1 / ( _n41 * vx + _n42 * vy + _n43 * vz + _n44 );

    v.x = ( _n11 * vx + _n12 * vy + _n13 * vz + _n14 ) * d;
    v.y = ( _n21 * vx + _n22 * vy + _n23 * vz + _n24 ) * d;
    v.z = ( _n31 * vx + _n32 * vy + _n33 * vz + _n34 ) * d;

    return v;
  }

  // TODO: Vector4?
  Vector4 multiplyVector4( Vector4 v ) 
  {
    num vx = v.x, vy = v.y, vz = v.z, vw = v.w;

    v.x = _n11 * vx + _n12 * vy + _n13 * vz + _n14 * vw;
    v.y = _n21 * vx + _n22 * vy + _n23 * vz + _n24 * vw;
    v.z = _n31 * vx + _n32 * vy + _n33 * vz + _n34 * vw;
    v.w = _n41 * vx + _n42 * vy + _n43 * vz + _n44 * vw;

    return v;
  }

  Vector3 rotateAxis( Vector3 v ) 
  {
    num vx = v.x, vy = v.y, vz = v.z;

    v.x = vx * _n11 + vy * _n12 + vz * _n13;
    v.y = vx * _n21 + vy * _n22 + vz * _n23;
    v.z = vx * _n31 + vy * _n32 + vz * _n33;

    v.normalize();

    return v;
  }

  Vector4 crossVector( Vector4 a )
  {
    Vector4 v = new Vector4();

    v.x = _n11 * a.x + _n12 * a.y + _n13 * a.z + _n14 * a.w;
    v.y = _n21 * a.x + _n22 * a.y + _n23 * a.z + _n24 * a.w;
    v.z = _n31 * a.x + _n32 * a.y + _n33 * a.z + _n34 * a.w;

    v.w = ( a.w != null ) ? _n41 * a.x + _n42 * a.y + _n43 * a.z + _n44 * a.w : 1;

    return v;
  }

  num determinant() 
  {
    num n11 = _n11, n12 = _n12, n13 = _n13, n14 = _n14,
    n21 = _n21, n22 = _n22, n23 = _n23, n24 = _n24,
    n31 = _n31, n32 = _n32, n33 = _n33, n34 = _n34,
    n41 = _n41, n42 = _n42, n43 = _n43, n44 = _n44;

    //TODO: make this more efficient
    //( based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm )
    return (
      n14 * n23 * n32 * n41-
      n13 * n24 * n32 * n41-
      n14 * n22 * n33 * n41+
      n12 * n24 * n33 * n41+

      n13 * n22 * n34 * n41-
      n12 * n23 * n34 * n41-
      n14 * n23 * n31 * n42+
      n13 * n24 * n31 * n42+

      n14 * n21 * n33 * n42-
      n11 * n24 * n33 * n42-
      n13 * n21 * n34 * n42+
      n11 * n23 * n34 * n42+

      n14 * n22 * n31 * n43-
      n12 * n24 * n31 * n43-
      n14 * n21 * n32 * n43+
      n11 * n24 * n32 * n43+

      n12 * n21 * n34 * n43-
      n11 * n22 * n34 * n43-
      n13 * n22 * n31 * n44+
      n12 * n23 * n31 * n44+

      n13 * n21 * n32 * n44-
      n11 * n23 * n32 * n44-
      n12 * n21 * n33 * n44+
      n11 * n22 * n33 * n44
    );

  }

  Matrix4 transpose() 
  {
    num tmp;

    tmp = _n21; _n21 = _n12; _n12 = tmp;
    tmp = _n31; _n31 = _n13; _n13 = tmp;
    tmp = _n32; _n32 = _n23; _n23 = tmp;

    tmp = _n41; _n41 = _n14; _n14 = tmp;
    tmp = _n42; _n42 = _n24; _n24 = tmp;
    tmp = _n43; _n43 = _n34; _n34 = tmp;

    return this;
  }

  Matrix4 clone() 
  {
    Matrix4 m = new Matrix4();

    m.n11 = _n11; m.n12 = _n12; m.n13 = _n13; m.n14 = _n14;
    m.n21 = _n21; m.n22 = _n22; m.n23 = _n23; m.n24 = _n24;
    m.n31 = _n31; m.n32 = _n32; m.n33 = _n33; m.n34 = _n34;
    m.n41 = _n41; m.n42 = _n42; m.n43 = _n43; m.n44 = _n44;

    return m;
  }

  List flatten() 
  {
    _flat[ 0 ] = _n11; _flat[ 1 ] = _n21; _flat[ 2 ] = _n31; _flat[ 3 ] = _n41;
    _flat[ 4 ] = _n12; _flat[ 5 ] = _n22; _flat[ 6 ] = _n32; _flat[ 7 ] = _n42;
    _flat[ 8 ]  = _n13; _flat[ 9 ]  = _n23; _flat[ 10 ] = _n33; _flat[ 11 ] = _n43;
    _flat[ 12 ] = _n14; _flat[ 13 ] = _n24; _flat[ 14 ] = _n34; _flat[ 15 ] = _n44;

    return _flat;
  }

  // TODO: Array == List?
  List flattenToArray( List flat ) 
  {
    flat[ 0 ] = _n11; flat[ 1 ] = _n21; flat[ 2 ] = _n31; flat[ 3 ] = _n41;
    flat[ 4 ] = _n12; flat[ 5 ] = _n22; flat[ 6 ] = _n32; flat[ 7 ] = _n42;
    flat[ 8 ]  = _n13; flat[ 9 ]  = _n23; flat[ 10 ] = _n33; flat[ 11 ] = _n43;
    flat[ 12 ] = _n14; flat[ 13 ] = _n24; flat[ 14 ] = _n34; flat[ 15 ] = _n44;

    return flat;
  }

  List flattenToArrayOffset( List flat, int offset ) 
  {
    flat[ offset ] = _n11;
    flat[ offset + 1 ] = _n21;
    flat[ offset + 2 ] = _n31;
    flat[ offset + 3 ] = _n41;

    flat[ offset + 4 ] = _n12;
    flat[ offset + 5 ] = _n22;
    flat[ offset + 6 ] = _n32;
    flat[ offset + 7 ] = _n42;

    flat[ offset + 8 ]  = _n13;
    flat[ offset + 9 ]  = _n23;
    flat[ offset + 10 ] = _n33;
    flat[ offset + 11 ] = _n43;

    flat[ offset + 12 ] = _n14;
    flat[ offset + 13 ] = _n24;
    flat[ offset + 14 ] = _n34;
    flat[ offset + 15 ] = _n44;

    return flat;
  }

  Matrix4 setTranslation( num x, num y, num z ) 
  {
    setValues(
      1, 0, 0, x,
      0, 1, 0, y,
      0, 0, 1, z,
      0, 0, 0, 1
    );

    return this;
  }

  Matrix4 setScale( num x, num y, num z ) 
  {
    setValues(
      x, 0, 0, 0,
      0, y, 0, 0,
      0, 0, z, 0,
      0, 0, 0, 1
    );

    return this;
  }

  Matrix4 setRotationX( num theta ) 
  {
    num c = Math.cos( theta ), s = Math.sin( theta );

    setValues(
      1, 0,  0, 0,
      0, c, -s, 0,
      0, s,  c, 0,
      0, 0,  0, 1
    );

    return this;
  }

  Matrix4 setRotationY( num theta ) 
  {
    num c = Math.cos( theta ), s = Math.sin( theta );

    setValues(
       c, 0, s, 0,
       0, 1, 0, 0,
      -s, 0, c, 0,
       0, 0, 0, 1
    );

    return this;
  }

  Matrix4 setRotationZ( num theta ) 
  {
    num c = Math.cos( theta ), s = Math.sin( theta );

    setValues(
      c, -s, 0, 0,
      s,  c, 0, 0,
      0,  0, 1, 0,
      0,  0, 0, 1
    );

    return this;
  }

  Matrix4 setRotationAxis( Vector3 axis, num angle ) 
  {
    // Based on http://www.gamedev.net/reference/articles/article1199.asp

    num c = Math.cos( angle ),
    s = Math.sin( angle ),
    t = 1 - c,
    x = axis.x, y = axis.y, z = axis.z,
    tx = t * x, ty = t * y;

    setValues(
      tx * x + c, tx * y - s * z, tx * z + s * y, 0,
      tx * y + s * z, ty * y + c, ty * z - s * x, 0,
      tx * z - s * y, ty * z + s * x, t * z * z + c, 0,
      0, 0, 0, 1
    );

     return this;
  }

  Matrix4 setPosition( Vector3 v ) 
  {
    _n14 = v.x;
    _n24 = v.y;
    _n34 = v.z;

    return this;
  }

  Vector3 getPosition() 
  {
    return __v1.setValues( _n14, _n24, _n34 );
  }

  Vector3 getColumnX() 
  {
    return __v1.setValues( _n11, _n21, _n31 );
  }

  Vector3 getColumnY() 
  {
    return __v1.setValues( _n12, _n22, _n32 );
  }

  Vector3 getColumnZ() 
  {
    return __v1.setValues( _n13, _n23, _n33 );
  }

  Matrix4 getInverse( Matrix4 m ) 
  {
    // based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm

    num n11 = m.n11, n12 = m.n12, n13 = m.n13, n14 = m.n14,
    n21 = m.n21, n22 = m.n22, n23 = m.n23, n24 = m.n24,
    n31 = m.n31, n32 = m.n32, n33 = m.n33, n34 = m.n34,
    n41 = m.n41, n42 = m.n42, n43 = m.n43, n44 = m.n44;

    _n11 = n23*n34*n42 - n24*n33*n42 + n24*n32*n43 - n22*n34*n43 - n23*n32*n44 + n22*n33*n44;
    _n12 = n14*n33*n42 - n13*n34*n42 - n14*n32*n43 + n12*n34*n43 + n13*n32*n44 - n12*n33*n44;
    _n13 = n13*n24*n42 - n14*n23*n42 + n14*n22*n43 - n12*n24*n43 - n13*n22*n44 + n12*n23*n44;
    _n14 = n14*n23*n32 - n13*n24*n32 - n14*n22*n33 + n12*n24*n33 + n13*n22*n34 - n12*n23*n34;
    _n21 = n24*n33*n41 - n23*n34*n41 - n24*n31*n43 + n21*n34*n43 + n23*n31*n44 - n21*n33*n44;
    _n22 = n13*n34*n41 - n14*n33*n41 + n14*n31*n43 - n11*n34*n43 - n13*n31*n44 + n11*n33*n44;
    _n23 = n14*n23*n41 - n13*n24*n41 - n14*n21*n43 + n11*n24*n43 + n13*n21*n44 - n11*n23*n44;
    _n24 = n13*n24*n31 - n14*n23*n31 + n14*n21*n33 - n11*n24*n33 - n13*n21*n34 + n11*n23*n34;
    _n31 = n22*n34*n41 - n24*n32*n41 + n24*n31*n42 - n21*n34*n42 - n22*n31*n44 + n21*n32*n44;
    _n32 = n14*n32*n41 - n12*n34*n41 - n14*n31*n42 + n11*n34*n42 + n12*n31*n44 - n11*n32*n44;
    _n33 = n12*n24*n41 - n14*n22*n41 + n14*n21*n42 - n11*n24*n42 - n12*n21*n44 + n11*n22*n44;
    _n34 = n14*n22*n31 - n12*n24*n31 - n14*n21*n32 + n11*n24*n32 + n12*n21*n34 - n11*n22*n34;
    _n41 = n23*n32*n41 - n22*n33*n41 - n23*n31*n42 + n21*n33*n42 + n22*n31*n43 - n21*n32*n43;
    _n42 = n12*n33*n41 - n13*n32*n41 + n13*n31*n42 - n11*n33*n42 - n12*n31*n43 + n11*n32*n43;
    _n43 = n13*n22*n41 - n12*n23*n41 - n13*n21*n42 + n11*n23*n42 + n12*n21*n43 - n11*n22*n43;
    _n44 = n12*n23*n31 - n13*n22*n31 + n13*n21*n32 - n11*n23*n32 - n12*n21*n33 + n11*n22*n33;
    multiplyScalar( 1 / m.determinant() );

    return this;
  }

  Matrix4 setRotationFromEuler( Vector3 v, String order ) 
  {
    num x = v.x, y = v.y, z = v.z,
    a = Math.cos( x ), b = Math.sin( x ),
    c = Math.cos( y ), d = Math.sin( y ),
    e = Math.cos( z ), f = Math.sin( z );

    switch ( order ) 
    {
      case 'YXZ':

        num ce = c * e, cf = c * f, de = d * e, df = d * f;

        _n11 = ce + df * b;
        _n12 = de * b - cf;
        _n13 = a * d;

        _n21 = a * f;
        _n22 = a * e;
        _n23 = - b;

        _n31 = cf * b - de;
        _n32 = df + ce * b;
        _n33 = a * c;
        break;

      case 'ZXY':

        num ce = c * e, cf = c * f, de = d * e, df = d * f;

        _n11 = ce - df * b;
        _n12 = - a * f;
        _n13 = de + cf * b;

        _n21 = cf + de * b;
        _n22 = a * e;
        _n23 = df - ce * b;

        _n31 = - a * d;
        _n32 = b;
        _n33 = a * c;
        break;

      case 'ZYX':

        num ae = a * e, af = a * f, be = b * e, bf = b * f;

        _n11 = c * e;
        _n12 = be * d - af;
        _n13 = ae * d + bf;

        _n21 = c * f;
        _n22 = bf * d + ae;
        _n23 = af * d - be;

        _n31 = - d;
        _n32 = b * c;
        _n33 = a * c;
        break;

      case 'YZX':

        num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

        _n11 = c * e;
        _n12 = bd - ac * f;
        _n13 = bc * f + ad;

        _n21 = f;
        _n22 = a * e;
        _n23 = - b * e;

        _n31 = - d * e;
        _n32 = ad * f + bc;
        _n33 = ac - bd * f;
        break;

      case 'XZY':

        num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

        _n11 = c * e;
        _n12 = - f;
        _n13 = d * e;

        _n21 = ac * f + bd;
        _n22 = a * e;
        _n23 = ad * f - bc;

        _n31 = bc * f - ad;
        _n32 = b * e;
        _n33 = bd * f + ac;
        break;

      default: // 'XYZ'

        num ae = a * e, af = a * f, be = b * e, bf = b * f;

        _n11 = c * e;
        _n12 = - c * f;
        _n13 = d;

        _n21 = af + be * d;
        _n22 = ae - bf * d;
        _n23 = - b * c;

        _n31 = bf - ae * d;
        _n32 = be + af * d;
        _n33 = a * c;
        break;

    }

    return this;
  }


  Matrix4 setRotationFromQuaternion( Quaternion q ) 
  {
    num x = q.x, y = q.y, z = q.z, w = q.w,
    x2 = x + x, y2 = y + y, z2 = z + z,
    xx = x * x2, xy = x * y2, xz = x * z2,
    yy = y * y2, yz = y * z2, zz = z * z2,
    wx = w * x2, wy = w * y2, wz = w * z2;

    _n11 = 1 - ( yy + zz );
    _n12 = xy - wz;
    _n13 = xz + wy;

    _n21 = xy + wz;
    _n22 = 1 - ( xx + zz );
    _n23 = yz - wx;

    _n31 = xz - wy;
    _n32 = yz + wx;
    _n33 = 1 - ( xx + yy );

    return this;
  }

  Matrix4 scale( Vector3 v ) 
  {
    num x = v.x, y = v.y, z = v.z;

    _n11 *= x; _n12 *= y; _n13 *= z;
    _n21 *= x; _n22 *= y; _n23 *= z;
    _n31 *= x; _n32 *= y; _n33 *= z;
    _n41 *= x; _n42 *= y; _n43 *= z;

    return this;
  }

  Matrix4 compose( Vector3 translation, Quaternion rotation, Vector3 s ) 
  {
    Matrix4 mRotation = __m1;
    Matrix4 mScale = __m2;

    mRotation.identity();
    mRotation.setRotationFromQuaternion( rotation );

    mScale.setScale( s.x, s.y, s.z );

    multiply( mRotation, mScale );

    n14 = translation.x;
    n24 = translation.y;
    n34 = translation.z;

    return this;
  }

  List decompose( Vector3 translation, Quaternion rotation, Vector3 s ) 
  {
    // grab the axis vectors
    Vector3 x = __v1;
    Vector3 y = __v2;
    Vector3 z = __v3;

    x.setValues( _n11, _n21, _n31 );
    y.setValues( _n12, _n22, _n32 );
    z.setValues( _n13, _n23, _n33 );

    // TODO: "instanceof" === "is"?
    translation = ( translation is Vector3 ) ? translation : new Vector3();
    rotation = ( rotation is Quaternion ) ? rotation : new Quaternion();
    s = ( s is Vector3 ) ? s : new Vector3();

    s.x = x.length();
    s.y = y.length();
    s.z = z.length();

    translation.x = _n14;
    translation.y = _n24;
    translation.z = _n34;

    // scale the rotation part
    Matrix4 matrix = __m1;

    matrix.copy( this );

    matrix.n11 /= s.x;
    matrix.n21 /= s.x;
    matrix.n31 /= s.x;

    matrix.n12 /= s.y;
    matrix.n22 /= s.y;
    matrix.n32 /= s.y;

    matrix.n13 /= s.z;
    matrix.n23 /= s.z;
    matrix.n33 /= s.z;

    rotation.setFromRotationMatrix( matrix );

    return [ translation, rotation, s ];
  }

  Matrix4 extractPosition( Matrix4 m ) 
  {
    _n14 = m.n14;
    _n24 = m.n24;
    _n34 = m.n34;

    return this;
  }

  Matrix4 extractRotation( Matrix4 m ) 
  {
    Vector3 vector = __v1;

    num scaleX = 1 / vector.setValues( m.n11, m.n21, m.n31 ).length();
    num scaleY = 1 / vector.setValues( m.n12, m.n22, m.n32 ).length();
    num scaleZ = 1 / vector.setValues( m.n13, m.n23, m.n33 ).length();

    _n11 = m.n11 * scaleX;
    _n21 = m.n21 * scaleX;
    _n31 = m.n31 * scaleX;

    _n12 = m.n12 * scaleY;
    _n22 = m.n22 * scaleY;
    _n32 = m.n32 * scaleY;

    _n13 = m.n13 * scaleZ;
    _n23 = m.n23 * scaleZ;
    _n33 = m.n33 * scaleZ;

    return this;
  }

  Matrix4 rotateByAxis( Vector3 axis, num angle ) 
  {
    // optimize by checking axis
    if ( axis.x === 1 && axis.y === 0 && axis.z === 0 ) {
      return rotateX( angle );
    } else if ( axis.x === 0 && axis.y === 1 && axis.z === 0 ) {
      return rotateY( angle );
    } else if ( axis.x === 0 && axis.y === 0 && axis.z === 1 ) {
      return rotateZ( angle );
    }

    num x = axis.x,
      y = axis.y,
      z = axis.z,
      n = Math.sqrt(x * x + y * y + z * z);

    x /= n;
    y /= n;
    z /= n;

    num xx = x * x,
      yy = y * y,
      zz = z * z,
      c = Math.cos(angle),
      s = Math.sin(angle),
      oneMinusCosine = 1 - c,
      xy = x * y * oneMinusCosine,
      xz = x * z * oneMinusCosine,
      yz = y * z * oneMinusCosine,
      xs = x * s,
      ys = y * s,
      zs = z * s,

      r11 = xx + (1 - xx) * c,
      r21 = xy + zs,
      r31 = xz - ys,
      r12 = xy - zs,
      r22 = yy + (1 - yy) * c,
      r32 = yz + xs,
      r13 = xz + ys,
      r23 = yz - xs,
      r33 = zz + (1 - zz) * c,

      m11 = _n11,
      m21 = _n21,
      m31 = _n31,
      m41 = _n41,
      m12 = _n12,
      m22 = _n22,
      m32 = _n32,
      m42 = _n42,
      m13 = _n13,
      m23 = _n23,
      m33 = _n33,
      m43 = _n43,
      m14 = _n14,
      m24 = _n24,
      m34 = _n34,
      m44 = _n44;

    _n11 = r11 * m11 + r21 * m12 + r31 * m13;
    _n21 = r11 * m21 + r21 * m22 + r31 * m23;
    _n31 = r11 * m31 + r21 * m32 + r31 * m33;
    _n41 = r11 * m41 + r21 * m42 + r31 * m43;

    _n12 = r12 * m11 + r22 * m12 + r32 * m13;
    _n22 = r12 * m21 + r22 * m22 + r32 * m23;
    _n32 = r12 * m31 + r22 * m32 + r32 * m33;
    _n42 = r12 * m41 + r22 * m42 + r32 * m43;

    _n13 = r13 * m11 + r23 * m12 + r33 * m13;
    _n23 = r13 * m21 + r23 * m22 + r33 * m23;
    _n33 = r13 * m31 + r23 * m32 + r33 * m33;
    _n43 = r13 * m41 + r23 * m42 + r33 * m43;

    return this;
  }

  Matrix4 rotateX( num angle ) 
  {
    num m12 = _n12,
      m22 = _n22,
      m32 = _n32,
      m42 = _n42,
      m13 = _n13,
      m23 = _n23,
      m33 = _n33,
      m43 = _n43,
      c = Math.cos(angle),
      s = Math.sin(angle);

    _n12 = c * m12 + s * m13;
    _n22 = c * m22 + s * m23;
    _n32 = c * m32 + s * m33;
    _n42 = c * m42 + s * m43;

    _n13 = c * m13 - s * m12;
    _n23 = c * m23 - s * m22;
    _n33 = c * m33 - s * m32;
    _n43 = c * m43 - s * m42;

    return this;
  }

  Matrix4 rotateY( num angle ) 
  {
    num m11 = _n11,
      m21 = _n21,
      m31 = _n31,
      m41 = _n41,
      m13 = _n13,
      m23 = _n23,
      m33 = _n33,
      m43 = _n43,
      c = Math.cos(angle),
      s = Math.sin(angle);

    _n11 = c * m11 - s * m13;
    _n21 = c * m21 - s * m23;
    _n31 = c * m31 - s * m33;
    _n41 = c * m41 - s * m43;

    _n13 = c * m13 + s * m11;
    _n23 = c * m23 + s * m21;
    _n33 = c * m33 + s * m31;
    _n43 = c * m43 + s * m41;

    return this;
  }

  Matrix4 rotateZ( num angle ) 
  {
    num m11 = _n11,
      m21 = _n21,
      m31 = _n31,
      m41 = _n41,
      m12 = _n12,
      m22 = _n22,
      m32 = _n32,
      m42 = _n42,
      c = Math.cos(angle),
      s = Math.sin(angle);

    _n11 = c * m11 + s * m12;
    _n21 = c * m21 + s * m22;
    _n31 = c * m31 + s * m32;
    _n41 = c * m41 + s * m42;

    _n12 = c * m12 - s * m11;
    _n22 = c * m22 - s * m21;
    _n32 = c * m32 - s * m31;
    _n42 = c * m42 - s * m41;

    return this;
  }

  Matrix4 translate( Vector3 v ) 
  {
    num x = v.x, y = v.y, z = v.z;

    _n14 = _n11 * x + _n12 * y + _n13 * z + _n14;
    _n24 = _n21 * x + _n22 * y + _n23 * z + _n24;
    _n34 = _n31 * x + _n32 * y + _n33 * z + _n34;
    _n44 = _n41 * x + _n42 * y + _n43 * z + _n44;

    return this;
  }

  // TODO: static from here down
  static Matrix3 makeInvert3x3( Matrix4 m1 )
  {
    // input:  THREE.Matrix4, output: THREE.Matrix3
    // ( based on http://code.google.com/p/webgl-mjs/ )

    Matrix3 m33 = m1.m33;
    List m33m = m33.m;
    num a11 =   m1.n33 * m1.n22 - m1.n32 * m1.n23,
    a21 = - m1.n33 * m1.n21 + m1.n31 * m1.n23,
    a31 =   m1.n32 * m1.n21 - m1.n31 * m1.n22,
    a12 = - m1.n33 * m1.n12 + m1.n32 * m1.n13,
    a22 =   m1.n33 * m1.n11 - m1.n31 * m1.n13,
    a32 = - m1.n32 * m1.n11 + m1.n31 * m1.n12,
    a13 =   m1.n23 * m1.n12 - m1.n22 * m1.n13,
    a23 = - m1.n23 * m1.n11 + m1.n21 * m1.n13,
    a33 =   m1.n22 * m1.n11 - m1.n21 * m1.n12,

    det = m1.n11 * a11 + m1.n21 * a12 + m1.n31 * a13,

    idet;

    // no inverse

    if ( det === 0 ) {
      return null;
    }

    idet = 1.0 / det;

    m33m[ 0 ] = idet * a11; m33m[ 1 ] = idet * a21; m33m[ 2 ] = idet * a31;
    m33m[ 3 ] = idet * a12; m33m[ 4 ] = idet * a22; m33m[ 5 ] = idet * a32;
    m33m[ 6 ] = idet * a13; m33m[ 7 ] = idet * a23; m33m[ 8 ] = idet * a33;

    return m33;
  }

  static Matrix4 makeFrustum( num left, num right, num bottom, num top, num near, num far ) 
  {
    num x, y, a, b, c, d;

    Matrix4 m = new Matrix4(1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1);

    x = 2 * near / ( right - left );
    y = 2 * near / ( top - bottom );

    a = ( right + left ) / ( right - left );
    b = ( top + bottom ) / ( top - bottom );
    c = - ( far + near ) / ( far - near );
    d = - 2 * far * near / ( far - near );

    m.n11 = x;  m.n12 = 0;  m.n13 = a;   m.n14 = 0;
    m.n21 = 0;  m.n22 = y;  m.n23 = b;   m.n24 = 0;
    m.n31 = 0;  m.n32 = 0;  m.n33 = c;   m.n34 = d;
    m.n41 = 0;  m.n42 = 0;  m.n43 = - 1; m.n44 = 0;

    return m;
  }

  static Matrix4 makePerspective( num fov, num aspect, num near, num far ) 
  {
    num ymax, ymin, xmin, xmax;

    ymax = near * Math.tan( fov * Math.PI / 360 );
    ymin = - ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;

    return makeFrustum( xmin, xmax, ymin, ymax, near, far );
  }

  static Matrix4 makeOrtho( num left, num right, num top, num bottom, num near, num far ) 
  {
    num x, y, z, w, h, p;

    Matrix4 m = new Matrix4(1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1);

    w = right - left;
    h = top - bottom;
    p = far - near;

    x = ( right + left ) / w;
    y = ( top + bottom ) / h;
    z = ( far + near ) / p;

    m.n11 = 2 / w; m.n12 = 0;     m.n13 = 0;      m.n14 = -x;
    m.n21 = 0;     m.n22 = 2 / h; m.n23 = 0;      m.n24 = -y;
    m.n31 = 0;     m.n32 = 0;     m.n33 = -2 / p; m.n34 = -z;
    m.n41 = 0;     m.n42 = 0;     m.n43 = 0;      m.n44 = 1;

    return m;
  }
}
