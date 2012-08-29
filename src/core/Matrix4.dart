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
  num n11, n12, n13, n14, 
      n21, n22, n23, n24, 
      n31, n32, n33, n34, 
      n41, n42, n43, n44;
  
  //TODO: Fix "Expected Constant Expression" problem
  // Axis Vectors, X, Y, Z
  static Vector3 __v1; //= new Vector3();
  static Vector3 __v2; //= new Vector3();
  static Vector3 __v3; //= new Vector3();

  // Rotation, Scale
  static Matrix4 __m1; //= new Matrix4();
  static Matrix4 __m2; //= new Matrix4();
  
  get m33() {  return _m33;  }

  Matrix4( [num this.n11 = 1, num this.n12 = 0, num this.n13 = 0, num this.n14 = 0, 
            num this.n21 = 0, num this.n22 = 1, num this.n23 = 0, num this.n24 = 0, 
            num this.n31 = 0, num this.n32 = 0, num this.n33 = 1, num this.n34 = 0, 
            num this.n41 = 0, num this.n42 = 0, num this.n43 = 0, num this.n44 = 1] ) 
  {    
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
  
  Matrix4.createMatrices( [num this.n11 = 1, num this.n12 = 0, num this.n13 = 0, num this.n14 = 0, 
                           num this.n21 = 0, num this.n22 = 1, num this.n23 = 0, num this.n24 = 0, 
                           num this.n31 = 0, num this.n32 = 0, num this.n33 = 1, num this.n34 = 0, 
                           num this.n41 = 0, num this.n42 = 0, num this.n43 = 0, num this.n44 = 1] ) 
  {
    //TODO: need to make this List length 16?
    _flat = new List();//( 16 );
    // Equivalent of super-constructor?
    _m33 = new Matrix3();
    
    //TODO: initialise static vars.. Ok here?
//    if (__v1 == null)   __v1 = new Vector3();
//    if (__v2 == null)   __v2 = new Vector3();
//    if (__v3 == null)   __v3 = new Vector3();

    // Rotation, Scale
    //__m1 = new Matrix4.createMatrices();
    //__m2 = new Matrix4.createMatrices();
  }
  
  // "set" changed to "setM" as "set" is reserved
  Matrix4 setValues( num m11, num m12, num m13, num m14, 
                     num m21, num m22, num m23, num m24, 
                     num m31, num m32, num m33, num m34, 
                     num m41, num m42, num m43, num m44 ) 
  {
    this.n11 = n11; this.n12 = n12; this.n13 = n13; this.n14 = n14;
    this.n21 = n21; this.n22 = n22; this.n23 = n23; this.n24 = n24;
    this.n31 = n31; this.n32 = n32; this.n33 = n33; this.n34 = n34;
    this.n41 = n41; this.n42 = n42; this.n43 = n43; this.n44 = n44;

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
  
      n11 = x.x; n12 = y.x; n13 = z.x;
      n21 = x.y; n22 = y.y; n23 = z.y;
      n31 = x.z; n32 = y.z; n33 = z.z;
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

    n11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
    n12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
    n13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
    n14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

    n21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
    n22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
    n23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
    n24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

    n31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
    n32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
    n33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
    n34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

    n41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
    n42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
    n43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
    n44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
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

    r[ 0 ] = n11; r[ 1 ] = n21; r[ 2 ] = n31; r[ 3 ] = n41;
    r[ 4 ] = n12; r[ 5 ] = n22; r[ 6 ] = n32; r[ 7 ] = n42;
    r[ 8 ]  = n13; r[ 9 ]  = n23; r[ 10 ] = n33; r[ 11 ] = n43;
    r[ 12 ] = n14; r[ 13 ] = n24; r[ 14 ] = n34; r[ 15 ] = n44;

    return this;
  }

  Matrix4 multiplyScalar( num s ) 
  {
    n11 *= s; n12 *= s; n13 *= s; n14 *= s;
    n21 *= s; n22 *= s; n23 *= s; n24 *= s;
    n31 *= s; n32 *= s; n33 *= s; n34 *= s;
    n41 *= s; n42 *= s; n43 *= s; n44 *= s;

    return this;
  }

  multiplyVector3Array( a ) {

    var tmp = Matrix4.__v1;

    int il = a.length;
    
    for ( var i = 0; i < il; i += 3 ) {

      tmp.x = a[ i ];
      tmp.y = a[ i + 1 ];
      tmp.z = a[ i + 2 ];

      multiplyVector3( tmp );

      a[ i ]     = tmp.x;
      a[ i + 1 ] = tmp.y;
      a[ i + 2 ] = tmp.z;

    }

    return a;

  }
  
  multiplyVector3( IVector3 v ) 
  {
    num vx = v.x, vy = v.y, vz = v.z,
    d = 1 / ( n41 * vx + n42 * vy + n43 * vz + n44 );

    v.x = ( n11 * vx + n12 * vy + n13 * vz + n14 ) * d;
    v.y = ( n21 * vx + n22 * vy + n23 * vz + n24 ) * d;
    v.z = ( n31 * vx + n32 * vy + n33 * vz + n34 ) * d;

    return v;
  }

  // TODO: Vector4?
  Vector4 multiplyVector4( Vector4 v ) 
  {
    num vx = v.x, vy = v.y, vz = v.z, vw = v.w;

    v.x = n11 * vx + n12 * vy + n13 * vz + n14 * vw;
    v.y = n21 * vx + n22 * vy + n23 * vz + n24 * vw;
    v.z = n31 * vx + n32 * vy + n33 * vz + n34 * vw;
    v.w = n41 * vx + n42 * vy + n43 * vz + n44 * vw;

    return v;
  }

  Vector3 rotateAxis( Vector3 v ) 
  {
    num vx = v.x, vy = v.y, vz = v.z;

    v.x = vx * n11 + vy * n12 + vz * n13;
    v.y = vx * n21 + vy * n22 + vz * n23;
    v.z = vx * n31 + vy * n32 + vz * n33;

    v.normalize();

    return v;
  }

  Vector4 crossVector( Vector4 a )
  {
    Vector4 v = new Vector4();

    v.x = n11 * a.x + n12 * a.y + n13 * a.z + n14 * a.w;
    v.y = n21 * a.x + n22 * a.y + n23 * a.z + n24 * a.w;
    v.z = n31 * a.x + n32 * a.y + n33 * a.z + n34 * a.w;

    v.w = ( a.w != null ) ? n41 * a.x + n42 * a.y + n43 * a.z + n44 * a.w : 1;

    return v;
  }

  num determinant() 
  {
    num m11 = n11, m12 = n12, m13 = n13, m14 = n14,
    m21 = n21, m22 = n22, m23 = n23, m24 = n24,
    m31 = n31, m32 = n32, m33 = n33, m34 = n34,
    m41 = n41, m42 = n42, m43 = n43, m44 = n44;

    //TODO: make this more efficient
    //( based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm )
    return (
      m14 * m23 * m32 * m41-
      m13 * m24 * m32 * m41-
      m14 * m22 * m33 * m41+
      m12 * m24 * m33 * m41+

      m13 * m22 * m34 * m41-
      m12 * m23 * m34 * m41-
      m14 * m23 * m31 * m42+
      m13 * m24 * m31 * m42+

      m14 * m21 * m33 * m42-
      m11 * m24 * m33 * m42-
      m13 * m21 * m34 * m42+
      m11 * m23 * m34 * m42+

      m14 * m22 * m31 * m43-
      m12 * m24 * m31 * m43-
      m14 * m21 * m32 * m43+
      m11 * m24 * m32 * m43+

      m12 * m21 * m34 * m43-
      m11 * m22 * m34 * m43-
      m13 * m22 * m31 * m44+
      m12 * m23 * m31 * m44+

      m13 * m21 * m32 * m44-
      m11 * m23 * m32 * m44-
      m12 * m21 * m33 * m44+
      m11 * m22 * m33 * m44
    );

  }

  Matrix4 transpose() 
  {
    num tmp;

    tmp = n21; n21 = n12; n12 = tmp;
    tmp = n31; n31 = n13; n13 = tmp;
    tmp = n32; n32 = n23; n23 = tmp;

    tmp = n41; n41 = n14; n14 = tmp;
    tmp = n42; n42 = n24; n24 = tmp;
    tmp = n43; n43 = n34; n34 = tmp;

    return this;
  }

  Matrix4 clone() 
  {
    Matrix4 m = new Matrix4();

    m.n11 = n11; m.n12 = n12; m.n13 = n13; m.n14 = n14;
    m.n21 = n21; m.n22 = n22; m.n23 = n23; m.n24 = n24;
    m.n31 = n31; m.n32 = n32; m.n33 = n33; m.n34 = n34;
    m.n41 = n41; m.n42 = n42; m.n43 = n43; m.n44 = n44;

    return m;
  }

  List flatten() 
  {
    _flat[ 0 ] = n11; _flat[ 1 ] = n21; _flat[ 2 ] = n31; _flat[ 3 ] = n41;
    _flat[ 4 ] = n12; _flat[ 5 ] = n22; _flat[ 6 ] = n32; _flat[ 7 ] = n42;
    _flat[ 8 ]  = n13; _flat[ 9 ]  = n23; _flat[ 10 ] = n33; _flat[ 11 ] = n43;
    _flat[ 12 ] = n14; _flat[ 13 ] = n24; _flat[ 14 ] = n34; _flat[ 15 ] = n44;

    return _flat;
  }

  // TODO: Array == List?
  List flattenToArray( List flat ) 
  {
    flat[ 0 ] = n11; flat[ 1 ] = n21; flat[ 2 ] = n31; flat[ 3 ] = n41;
    flat[ 4 ] = n12; flat[ 5 ] = n22; flat[ 6 ] = n32; flat[ 7 ] = n42;
    flat[ 8 ]  = n13; flat[ 9 ]  = n23; flat[ 10 ] = n33; flat[ 11 ] = n43;
    flat[ 12 ] = n14; flat[ 13 ] = n24; flat[ 14 ] = n34; flat[ 15 ] = n44;

    return flat;
  }

  // TODO - Use Float32Array for storage
  get elements() {
    Float32Array array = new Float32Array(16);
    flattenToArray(array);
    return array;
  }
  
  List flattenToArrayOffset( List flat, int offset ) 
  {
    flat[ offset ] = n11;
    flat[ offset + 1 ] = n21;
    flat[ offset + 2 ] = n31;
    flat[ offset + 3 ] = n41;

    flat[ offset + 4 ] = n12;
    flat[ offset + 5 ] = n22;
    flat[ offset + 6 ] = n32;
    flat[ offset + 7 ] = n42;

    flat[ offset + 8 ]  = n13;
    flat[ offset + 9 ]  = n23;
    flat[ offset + 10 ] = n33;
    flat[ offset + 11 ] = n43;

    flat[ offset + 12 ] = n14;
    flat[ offset + 13 ] = n24;
    flat[ offset + 14 ] = n34;
    flat[ offset + 15 ] = n44;

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
    n14 = v.x;
    n24 = v.y;
    n34 = v.z;

    return this;
  }

  Vector3 getPosition() 
  {
    return __v1.setValues( n14, n24, n34 );
  }

  Vector3 getColumnX() 
  {
    return __v1.setValues( n11, n21, n31 );
  }

  Vector3 getColumnY() 
  {
    return __v1.setValues( n12, n22, n32 );
  }

  Vector3 getColumnZ() 
  {
    return __v1.setValues( n13, n23, n33 );
  }

  Matrix4 getInverse( Matrix4 m ) 
  {
    // based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm

    num _n11 = m.n11, _n12 = m.n12, _n13 = m.n13, _n14 = m.n14,
    _n21 = m.n21, _n22 = m.n22, _n23 = m.n23, _n24 = m.n24,
    _n31 = m.n31, _n32 = m.n32, _n33 = m.n33, _n34 = m.n34,
    _n41 = m.n41, _n42 = m.n42, _n43 = m.n43, _n44 = m.n44;

    n11 = _n23*_n34*_n42 - _n24*_n33*_n42 + _n24*_n32*_n43 - _n22*_n34*_n43 - _n23*_n32*_n44 + _n22*_n33*_n44;
    n12 = _n14*_n33*_n42 - _n13*_n34*_n42 - _n14*_n32*_n43 + _n12*_n34*_n43 + _n13*_n32*_n44 - _n12*_n33*_n44;
    n13 = _n13*_n24*_n42 - _n14*_n23*_n42 + _n14*_n22*_n43 - _n12*_n24*_n43 - _n13*_n22*_n44 + _n12*_n23*_n44;
    n14 = _n14*_n23*_n32 - _n13*_n24*_n32 - _n14*_n22*_n33 + _n12*_n24*_n33 + _n13*_n22*_n34 - _n12*_n23*_n34;
    n21 = _n24*_n33*_n41 - _n23*_n34*_n41 - _n24*_n31*_n43 + _n21*_n34*_n43 + _n23*_n31*_n44 - _n21*_n33*_n44;
    n22 = _n13*_n34*_n41 - _n14*_n33*_n41 + _n14*_n31*_n43 - _n11*_n34*_n43 - _n13*_n31*_n44 + _n11*_n33*_n44;
    n23 = _n14*_n23*_n41 - _n13*_n24*_n41 - _n14*_n21*_n43 + _n11*_n24*_n43 + _n13*_n21*_n44 - _n11*_n23*_n44;
    n24 = _n13*_n24*_n31 - _n14*_n23*_n31 + _n14*_n21*_n33 - _n11*_n24*_n33 - _n13*_n21*_n34 + _n11*_n23*_n34;
    n31 = _n22*_n34*_n41 - _n24*_n32*_n41 + _n24*_n31*_n42 - _n21*_n34*_n42 - _n22*_n31*_n44 + _n21*_n32*_n44;
    n32 = _n14*_n32*_n41 - _n12*_n34*_n41 - _n14*_n31*_n42 + _n11*_n34*_n42 + _n12*_n31*_n44 - _n11*_n32*_n44;
    n33 = _n12*_n24*_n41 - _n14*_n22*_n41 + _n14*_n21*_n42 - _n11*_n24*_n42 - _n12*_n21*_n44 + _n11*_n22*_n44;
    n34 = _n14*_n22*_n31 - _n12*_n24*_n31 - _n14*_n21*_n32 + _n11*_n24*_n32 + _n12*_n21*_n34 - _n11*_n22*_n34;
    n41 = _n23*_n32*_n41 - _n22*_n33*_n41 - _n23*_n31*_n42 + _n21*_n33*_n42 + _n22*_n31*_n43 - _n21*_n32*_n43;
    n42 = _n12*_n33*_n41 - _n13*_n32*_n41 + _n13*_n31*_n42 - _n11*_n33*_n42 - _n12*_n31*_n43 + _n11*_n32*_n43;
    n43 = _n13*_n22*_n41 - _n12*_n23*_n41 - _n13*_n21*_n42 + _n11*_n23*_n42 + _n12*_n21*_n43 - _n11*_n22*_n43;
    n44 = _n12*_n23*_n31 - _n13*_n22*_n31 + _n13*_n21*_n32 - _n11*_n23*_n32 - _n12*_n21*_n33 + _n11*_n22*_n33;
    multiplyScalar( 1 / m.determinant() );
    return this;
  }

  Matrix4 setRotationFromEuler( Vector3 v, [String order = 'XYZ'] ) 
  {
    num x = v.x, y = v.y, z = v.z,
    a = Math.cos( x ), b = Math.sin( x ),
    c = Math.cos( y ), d = Math.sin( y ),
    e = Math.cos( z ), f = Math.sin( z );

    switch ( order ) 
    {
      case 'YXZ':

        num ce = c * e, cf = c * f, de = d * e, df = d * f;

        n11 = ce + df * b;
        n12 = de * b - cf;
        n13 = a * d;

        n21 = a * f;
        n22 = a * e;
        n23 = - b;

        n31 = cf * b - de;
        n32 = df + ce * b;
        n33 = a * c;
        break;

      case 'ZXY':

        num ce = c * e, cf = c * f, de = d * e, df = d * f;

        n11 = ce - df * b;
        n12 = - a * f;
        n13 = de + cf * b;

        n21 = cf + de * b;
        n22 = a * e;
        n23 = df - ce * b;

        n31 = - a * d;
        n32 = b;
        n33 = a * c;
        break;

      case 'ZYX':

        num ae = a * e, af = a * f, be = b * e, bf = b * f;

        n11 = c * e;
        n12 = be * d - af;
        n13 = ae * d + bf;

        n21 = c * f;
        n22 = bf * d + ae;
        n23 = af * d - be;

        n31 = - d;
        n32 = b * c;
        n33 = a * c;
        break;

      case 'YZX':

        num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

        n11 = c * e;
        n12 = bd - ac * f;
        n13 = bc * f + ad;

        n21 = f;
        n22 = a * e;
        n23 = - b * e;

        n31 = - d * e;
        n32 = ad * f + bc;
        n33 = ac - bd * f;
        break;

      case 'XZY':

        num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

        n11 = c * e;
        n12 = - f;
        n13 = d * e;

        n21 = ac * f + bd;
        n22 = a * e;
        n23 = ad * f - bc;

        n31 = bc * f - ad;
        n32 = b * e;
        n33 = bd * f + ac;
        break;

      default: // 'XYZ'

        num ae = a * e, af = a * f, be = b * e, bf = b * f;

        n11 = c * e;
        n12 = - c * f;
        n13 = d;

        n21 = af + be * d;
        n22 = ae - bf * d;
        n23 = - b * c;

        n31 = bf - ae * d;
        n32 = be + af * d;
        n33 = a * c;
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

    n11 = 1 - ( yy + zz );
    n12 = xy - wz;
    n13 = xz + wy;

    n21 = xy + wz;
    n22 = 1 - ( xx + zz );
    n23 = yz - wx;

    n31 = xz - wy;
    n32 = yz + wx;
    n33 = 1 - ( xx + yy );

    return this;
  }

  Matrix4 scale( Vector3 v ) 
  {
    num x = v.x, y = v.y, z = v.z;

    n11 *= x; n12 *= y; n13 *= z;
    n21 *= x; n22 *= y; n23 *= z;
    n31 *= x; n32 *= y; n33 *= z;
    n41 *= x; n42 *= y; n43 *= z;

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

    x.setValues( n11, n21, n31 );
    y.setValues( n12, n22, n32 );
    z.setValues( n13, n23, n33 );

    translation = ( translation is Vector3 ) ? translation : new Vector3();
    rotation = ( rotation is Quaternion ) ? rotation : new Quaternion();
    s = ( s is Vector3 ) ? s : new Vector3();

    s.x = x.length();
    s.y = y.length();
    s.z = z.length();

    translation.x = n14;
    translation.y = n24;
    translation.z = n34;

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
    n14 = m.n14;
    n24 = m.n24;
    n34 = m.n34;

    return this;
  }

  Matrix4 extractRotation( Matrix4 m ) 
  {
    Vector3 vector = __v1;

    num scaleX = 1 / vector.setValues( m.n11, m.n21, m.n31 ).length();
    num scaleY = 1 / vector.setValues( m.n12, m.n22, m.n32 ).length();
    num scaleZ = 1 / vector.setValues( m.n13, m.n23, m.n33 ).length();

    n11 = m.n11 * scaleX;
    n21 = m.n21 * scaleX;
    n31 = m.n31 * scaleX;

    n12 = m.n12 * scaleY;
    n22 = m.n22 * scaleY;
    n32 = m.n32 * scaleY;

    n13 = m.n13 * scaleZ;
    n23 = m.n23 * scaleZ;
    n33 = m.n33 * scaleZ;

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

      m11 = n11,
      m21 = n21,
      m31 = n31,
      m41 = n41,
      m12 = n12,
      m22 = n22,
      m32 = n32,
      m42 = n42,
      m13 = n13,
      m23 = n23,
      m33 = n33,
      m43 = n43,
      m14 = n14,
      m24 = n24,
      m34 = n34,
      m44 = n44;

    n11 = r11 * m11 + r21 * m12 + r31 * m13;
    n21 = r11 * m21 + r21 * m22 + r31 * m23;
    n31 = r11 * m31 + r21 * m32 + r31 * m33;
    n41 = r11 * m41 + r21 * m42 + r31 * m43;

    n12 = r12 * m11 + r22 * m12 + r32 * m13;
    n22 = r12 * m21 + r22 * m22 + r32 * m23;
    n32 = r12 * m31 + r22 * m32 + r32 * m33;
    n42 = r12 * m41 + r22 * m42 + r32 * m43;

    n13 = r13 * m11 + r23 * m12 + r33 * m13;
    n23 = r13 * m21 + r23 * m22 + r33 * m23;
    n33 = r13 * m31 + r23 * m32 + r33 * m33;
    n43 = r13 * m41 + r23 * m42 + r33 * m43;

    return this;
  }

  Matrix4 rotateX( num angle ) 
  {
    num m12 = n12,
      m22 = n22,
      m32 = n32,
      m42 = n42,
      m13 = n13,
      m23 = n23,
      m33 = n33,
      m43 = n43,
      c = Math.cos(angle),
      s = Math.sin(angle);

    n12 = c * m12 + s * m13;
    n22 = c * m22 + s * m23;
    n32 = c * m32 + s * m33;
    n42 = c * m42 + s * m43;

    n13 = c * m13 - s * m12;
    n23 = c * m23 - s * m22;
    n33 = c * m33 - s * m32;
    n43 = c * m43 - s * m42;

    return this;
  }

  Matrix4 rotateY( num angle ) 
  {
    num m11 = n11,
      m21 = n21,
      m31 = n31,
      m41 = n41,
      m13 = n13,
      m23 = n23,
      m33 = n33,
      m43 = n43,
      c = Math.cos(angle),
      s = Math.sin(angle);

    n11 = c * m11 - s * m13;
    n21 = c * m21 - s * m23;
    n31 = c * m31 - s * m33;
    n41 = c * m41 - s * m43;

    n13 = c * m13 + s * m11;
    n23 = c * m23 + s * m21;
    n33 = c * m33 + s * m31;
    n43 = c * m43 + s * m41;

    return this;
  }

  Matrix4 rotateZ( num angle ) 
  {
    num m11 = n11,
      m21 = n21,
      m31 = n31,
      m41 = n41,
      m12 = n12,
      m22 = n22,
      m32 = n32,
      m42 = n42,
      c = Math.cos(angle),
      s = Math.sin(angle);

    n11 = c * m11 + s * m12;
    n21 = c * m21 + s * m22;
    n31 = c * m31 + s * m32;
    n41 = c * m41 + s * m42;

    n12 = c * m12 - s * m11;
    n22 = c * m22 - s * m21;
    n32 = c * m32 - s * m31;
    n42 = c * m42 - s * m41;

    return this;
  }

  Matrix4 translate( Vector3 v ) 
  {
    num x = v.x, y = v.y, z = v.z;

    n14 = n11 * x + n12 * y + n13 * z + n14;
    n24 = n21 * x + n22 * y + n23 * z + n24;
    n34 = n31 * x + n32 * y + n33 * z + n34;
    n44 = n41 * x + n42 * y + n43 * z + n44;

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
