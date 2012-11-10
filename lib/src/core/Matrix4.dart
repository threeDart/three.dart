part of three;

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

class Matrix4 {
  Float32Array elements;


  Matrix4( [num n11 = 1, num n12 = 0, num n13 = 0, num n14 = 0,
            num n21 = 0, num n22 = 1, num n23 = 0, num n24 = 0,
            num n31 = 0, num n32 = 0, num n33 = 1, num n34 = 0,
            num n41 = 0, num n42 = 0, num n43 = 0, num n44 = 1] )
      : elements = new Float32Array(16) {

    setValues(n11, n12, n13, n14,
              n21, n22, n23, n24,
              n31, n32, n33, n34,
              n41, n42, n43, n44);
  }


  // "set" changed to "setM" as "set" is reserved
  Matrix4 setValues( num n11, num n12, num n13, num n14,
                     num n21, num n22, num n23, num n24,
                     num n31, num n32, num n33, num n34,
                     num n41, num n42, num n43, num n44 ) {
    var te = this.elements;

    te[0] = n11; te[4] = n12; te[8] = n13; te[12] = n14;
    te[1] = n21; te[5] = n22; te[9] = n23; te[13] = n24;
    te[2] = n31; te[6] = n32; te[10] = n33; te[14] = n34;
    te[3] = n41; te[7] = n42; te[11] = n43; te[15] = n44;

    return this;
  }

  Matrix4 identity() {
    setValues(
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1
    );

    return this;
  }

  Matrix4 copy( Matrix4 m ) {
    var me = m.elements;

    setValues(

      me[0], me[4], me[8], me[12],
      me[1], me[5], me[9], me[13],
      me[2], me[6], me[10], me[14],
      me[3], me[7], me[11], me[15]

    );

    return this;
  }


  Matrix4 lookAt( Vector3 eye, Vector3 center, Vector3 up ) {
    var te = elements;

    Vector3 x = __v1,
            y = __v2,
            z = __v3;

    z.sub( eye, center ).normalize();

    if ( z.length() == 0 ) {
      z.z = 1;
    }

    x.cross( up, z ).normalize();

    if ( x.length() == 0 ) {
      z.x += 0.0001;
      x.cross( up, z ).normalize();
    }

    y.cross( z, x ).normalize();

    te[0] = x.x; te[4] = y.x; te[8] = z.x;
    te[1] = x.y; te[5] = y.y; te[9] = z.y;
    te[2] = x.z; te[6] = y.z; te[10] = z.z;

    return this;
  }

  Matrix4 multiply( Matrix4 a, Matrix4 b ) {
    var ae = a.elements;
    var be = b.elements;
    var te = elements;

    var a11 = ae[0], a12 = ae[4], a13 = ae[8], a14 = ae[12];
    var a21 = ae[1], a22 = ae[5], a23 = ae[9], a24 = ae[13];
    var a31 = ae[2], a32 = ae[6], a33 = ae[10], a34 = ae[14];
    var a41 = ae[3], a42 = ae[7], a43 = ae[11], a44 = ae[15];

    var b11 = be[0], b12 = be[4], b13 = be[8], b14 = be[12];
    var b21 = be[1], b22 = be[5], b23 = be[9], b24 = be[13];
    var b31 = be[2], b32 = be[6], b33 = be[10], b34 = be[14];
    var b41 = be[3], b42 = be[7], b43 = be[11], b44 = be[15];

    te[0] = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
    te[4] = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
    te[8] = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
    te[12] = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

    te[1] = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
    te[5] = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
    te[9] = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
    te[13] = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

    te[2] = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
    te[6] = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
    te[10] = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
    te[14] = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

    te[3] = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
    te[7] = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
    te[11] = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
    te[15] = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;

    return this;
  }

  Matrix4 multiplySelf( Matrix4 m ) => multiply( this, m );

  Matrix4 multiplyToArray( Matrix4 a, Matrix4 b, List r ) {

    var te = elements;

    multiply( a, b );

    r[ 0 ] = te[0]; r[ 1 ] = te[1]; r[ 2 ] = te[2]; r[ 3 ] = te[3];
    r[ 4 ] = te[4]; r[ 5 ] = te[5]; r[ 6 ] = te[6]; r[ 7 ] = te[7];
    r[ 8 ]  = te[8]; r[ 9 ]  = te[9]; r[ 10 ] = te[10]; r[ 11 ] = te[11];
    r[ 12 ] = te[12]; r[ 13 ] = te[13]; r[ 14 ] = te[14]; r[ 15 ] = te[15];

    return this;
  }

  Matrix4 multiplyScalar( num s ) {
    var te = elements;

    te[0] *= s; te[4] *= s; te[8] *= s; te[12] *= s;
    te[1] *= s; te[5] *= s; te[9] *= s; te[13] *= s;
    te[2] *= s; te[6] *= s; te[10] *= s; te[14] *= s;
    te[3] *= s; te[7] *= s; te[11] *= s; te[15] *= s;

    return this;
  }

  multiplyVector3( IVector3 v ) {
    var te = elements;

    var vx = v.x, vy = v.y, vz = v.z;
    var d = 1 / ( te[3] * vx + te[7] * vy + te[11] * vz + te[15] );

    v.x = ( te[0] * vx + te[4] * vy + te[8] * vz + te[12] ) * d;
    v.y = ( te[1] * vx + te[5] * vy + te[9] * vz + te[13] ) * d;
    v.z = ( te[2] * vx + te[6] * vy + te[10] * vz + te[14] ) * d;

    return v;
  }

  Vector4 multiplyVector4( Vector4 v ) {
    var te = elements;
    var vx = v.x, vy = v.y, vz = v.z, vw = v.w;

    v.x = te[0] * vx + te[4] * vy + te[8] * vz + te[12] * vw;
    v.y = te[1] * vx + te[5] * vy + te[9] * vz + te[13] * vw;
    v.z = te[2] * vx + te[6] * vy + te[10] * vz + te[14] * vw;
    v.w = te[3] * vx + te[7] * vy + te[11] * vz + te[15] * vw;

    return v;
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

  Vector3 rotateAxis( Vector3 v ) {
    var te = elements;
    var vx = v.x, vy = v.y, vz = v.z;

    v.x = vx * te[0] + vy * te[4] + vz * te[8];
    v.y = vx * te[1] + vy * te[5] + vz * te[9];
    v.z = vx * te[2] + vy * te[6] + vz * te[10];

    v.normalize();

    return v;
  }

  Vector4 crossVector( Vector4 a ) {

    var te = this.elements;
    Vector4 v = new Vector4();

    v.x = te[0] * a.x + te[4] * a.y + te[8] * a.z + te[12] * a.w;
    v.y = te[1] * a.x + te[5] * a.y + te[9] * a.z + te[13] * a.w;
    v.z = te[2] * a.x + te[6] * a.y + te[10] * a.z + te[14] * a.w;

    v.w = (a.w != null) ? te[3] * a.x + te[7] * a.y + te[11] * a.z + te[15] * a.w : 1;

    return v;
  }

  num determinant() {
    var te = elements;

    var n11 = te[0], n12 = te[4], n13 = te[8], n14 = te[12];
    var n21 = te[1], n22 = te[5], n23 = te[9], n24 = te[13];
    var n31 = te[2], n32 = te[6], n33 = te[10], n34 = te[14];
    var n41 = te[3], n42 = te[7], n43 = te[11], n44 = te[15];

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

  Matrix4 transpose() {
    var te = elements;
    var tmp;

    tmp = te[1]; te[1] = te[4]; te[4] = tmp;
    tmp = te[2]; te[2] = te[8]; te[8] = tmp;
    tmp = te[6]; te[6] = te[9]; te[9] = tmp;

    tmp = te[3]; te[3] = te[12]; te[12] = tmp;
    tmp = te[7]; te[7] = te[13]; te[13] = tmp;
    tmp = te[11]; te[11] = te[14]; te[14] = tmp;

    return this;
  }

  List flattenToArray( List flat ) {
    var te = elements;

    flat[ 0 ] = te[0]; flat[ 1 ] = te[1]; flat[ 2 ] = te[2]; flat[ 3 ] = te[3];
    flat[ 4 ] = te[4]; flat[ 5 ] = te[5]; flat[ 6 ] = te[6]; flat[ 7 ] = te[7];
    flat[ 8 ]  = te[8]; flat[ 9 ]  = te[9]; flat[ 10 ] = te[10]; flat[ 11 ] = te[11];
    flat[ 12 ] = te[12]; flat[ 13 ] = te[13]; flat[ 14 ] = te[14]; flat[ 15 ] = te[15];

    return flat;
  }

  List flattenToArrayOffset( List flat, int offset ) {
    var te = elements;

    flat[ offset ] = te[0];
    flat[ offset + 1 ] = te[1];
    flat[ offset + 2 ] = te[2];
    flat[ offset + 3 ] = te[3];

    flat[ offset + 4 ] = te[4];
    flat[ offset + 5 ] = te[5];
    flat[ offset + 6 ] = te[6];
    flat[ offset + 7 ] = te[7];

    flat[ offset + 8 ]  = te[8];
    flat[ offset + 9 ]  = te[9];
    flat[ offset + 10 ] = te[10];
    flat[ offset + 11 ] = te[11];

    flat[ offset + 12 ] = te[12];
    flat[ offset + 13 ] = te[13];
    flat[ offset + 14 ] = te[14];
    flat[ offset + 15 ] = te[15];

    return flat;
  }

  Vector3 getPosition() => __v1.setValues( elements[12], elements[13], elements[14] );

  Matrix4 setPosition( Vector3 v ) {
    var te = elements;

    te[12] = v.x;
    te[13] = v.y;
    te[14] = v.z;

    return this;
  }

  Vector3 getColumnX() => __v1.setValues( elements[0], elements[1], elements[2] );

  Vector3 getColumnY() => __v1.setValues( elements[4], elements[5], elements[6] );

  Vector3 getColumnZ() => __v1.setValues( elements[8], elements[9], elements[10] );

  Matrix4 getInverse( Matrix4 m ) {
    // based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm
    var te = elements;
    var me = m.elements;

    num n11 = me[0], n12 = me[4], n13 = me[8], n14 = me[12],
        n21 = me[1], n22 = me[5], n23 = me[9], n24 = me[13],
        n31 = me[2], n32 = me[6], n33 = me[10], n34 = me[14],
        n41 = me[3], n42 = me[7], n43 = me[11], n44 = me[15];

    te[0] = n23*n34*n42 - n24*n33*n42 + n24*n32*n43 - n22*n34*n43 - n23*n32*n44 + n22*n33*n44;
    te[4] = n14*n33*n42 - n13*n34*n42 - n14*n32*n43 + n12*n34*n43 + n13*n32*n44 - n12*n33*n44;
    te[8] = n13*n24*n42 - n14*n23*n42 + n14*n22*n43 - n12*n24*n43 - n13*n22*n44 + n12*n23*n44;
    te[12] = n14*n23*n32 - n13*n24*n32 - n14*n22*n33 + n12*n24*n33 + n13*n22*n34 - n12*n23*n34;
    te[1] = n24*n33*n41 - n23*n34*n41 - n24*n31*n43 + n21*n34*n43 + n23*n31*n44 - n21*n33*n44;
    te[5] = n13*n34*n41 - n14*n33*n41 + n14*n31*n43 - n11*n34*n43 - n13*n31*n44 + n11*n33*n44;
    te[9] = n14*n23*n41 - n13*n24*n41 - n14*n21*n43 + n11*n24*n43 + n13*n21*n44 - n11*n23*n44;
    te[13] = n13*n24*n31 - n14*n23*n31 + n14*n21*n33 - n11*n24*n33 - n13*n21*n34 + n11*n23*n34;
    te[2] = n22*n34*n41 - n24*n32*n41 + n24*n31*n42 - n21*n34*n42 - n22*n31*n44 + n21*n32*n44;
    te[6] = n14*n32*n41 - n12*n34*n41 - n14*n31*n42 + n11*n34*n42 + n12*n31*n44 - n11*n32*n44;
    te[10] = n12*n24*n41 - n14*n22*n41 + n14*n21*n42 - n11*n24*n42 - n12*n21*n44 + n11*n22*n44;
    te[14] = n14*n22*n31 - n12*n24*n31 - n14*n21*n32 + n11*n24*n32 + n12*n21*n34 - n11*n22*n34;
    te[3] = n23*n32*n41 - n22*n33*n41 - n23*n31*n42 + n21*n33*n42 + n22*n31*n43 - n21*n32*n43;
    te[7] = n12*n33*n41 - n13*n32*n41 + n13*n31*n42 - n11*n33*n42 - n12*n31*n43 + n11*n32*n43;
    te[11] = n13*n22*n41 - n12*n23*n41 - n13*n21*n42 + n11*n23*n42 + n12*n21*n43 - n11*n22*n43;
    te[15] = n12*n23*n31 - n13*n22*n31 + n13*n21*n32 - n11*n23*n32 - n12*n21*n33 + n11*n22*n33;
    this.multiplyScalar( 1 / m.determinant() );
    return this;
  }

  Matrix4 setRotationFromEuler( Vector3 v, [String order = 'XYZ'] ) {
    var te = elements;
    num x = v.x, y = v.y, z = v.z,
    a = Math.cos( x ), b = Math.sin( x ),
    c = Math.cos( y ), d = Math.sin( y ),
    e = Math.cos( z ), f = Math.sin( z );

    switch ( order ) {
      case 'YXZ':

        num ce = c * e, cf = c * f, de = d * e, df = d * f;

        te[0] = ce + df * b;
        te[4] = de * b - cf;
        te[8] = a * d;

        te[1] = a * f;
        te[5] = a * e;
        te[9] = - b;

        te[2] = cf * b - de;
        te[6] = df + ce * b;
        te[10] = a * c;
        break;

      case 'ZXY':

        num ce = c * e, cf = c * f, de = d * e, df = d * f;

        te[0] = ce - df * b;
        te[4] = - a * f;
        te[8] = de + cf * b;

        te[1] = cf + de * b;
        te[5] = a * e;
        te[9] = df - ce * b;

        te[2] = - a * d;
        te[6] = b;
        te[10] = a * c;
        break;

      case 'ZYX':

        num ae = a * e, af = a * f, be = b * e, bf = b * f;

        te[0] = c * e;
        te[4] = be * d - af;
        te[8] = ae * d + bf;

        te[1] = c * f;
        te[5] = bf * d + ae;
        te[9] = af * d - be;

        te[2] = - d;
        te[6] = b * c;
        te[10] = a * c;
        break;

      case 'YZX':

        num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

        te[0] = c * e;
        te[4] = bd - ac * f;
        te[8] = bc * f + ad;

        te[1] = f;
        te[5] = a * e;
        te[9] = - b * e;

        te[2] = - d * e;
        te[6] = ad * f + bc;
        te[10] = ac - bd * f;
        break;

      case 'XZY':

        num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

        te[0] = c * e;
        te[4] = - f;
        te[8] = d * e;

        te[1] = ac * f + bd;
        te[5] = a * e;
        te[9] = ad * f - bc;

        te[2] = bc * f - ad;
        te[6] = b * e;
        te[10] = bd * f + ac;
        break;

      default: // 'XYZ'

        num ae = a * e, af = a * f, be = b * e, bf = b * f;

        te[0] = c * e;
        te[4] = - c * f;
        te[8] = d;

        te[1] = af + be * d;
        te[5] = ae - bf * d;
        te[9] = - b * c;

        te[2] = bf - ae * d;
        te[6] = be + af * d;
        te[10] = a * c;
        break;

    }

    return this;
  }


  Matrix4 setRotationFromQuaternion( Quaternion q ) {
    var te = this.elements;

    num x = q.x, y = q.y, z = q.z, w = q.w,
    x2 = x + x, y2 = y + y, z2 = z + z,
    xx = x * x2, xy = x * y2, xz = x * z2,
    yy = y * y2, yz = y * z2, zz = z * z2,
    wx = w * x2, wy = w * y2, wz = w * z2;

    te[0] = 1 - ( yy + zz );
    te[4] = xy - wz;
    te[8] = xz + wy;

    te[1] = xy + wz;
    te[5] = 1 - ( xx + zz );
    te[9] = yz - wx;

    te[2] = xz - wy;
    te[6] = yz + wx;
    te[10] = 1 - ( xx + yy );

    return this;
  }

  Matrix4 compose( Vector3 translation, Quaternion rotation, Vector3 s ) {

    var te = elements;

    Matrix4 mRotation = __m1;
    Matrix4 mScale = __m2;

    mRotation.identity();
    mRotation.setRotationFromQuaternion( rotation );

    mScale.makeScale( s.x, s.y, s.z );

    multiply( mRotation, mScale );

    te[12] = translation.x;
    te[13] = translation.y;
    te[14] = translation.z;

    return this;
  }

  List decompose( Vector3 translation, Quaternion rotation, Vector3 scale ) {

    var te = elements;

    // grab the axis vectors
    Vector3 x = __v1;
    Vector3 y = __v2;
    Vector3 z = __v3;

    x.setValues( te[0], te[1], te[2] );
    y.setValues( te[4], te[5], te[6] );
    z.setValues( te[8], te[9], te[10] );

    translation = ( translation is Vector3 ) ? translation : new Vector3();
    rotation = ( rotation is Quaternion ) ? rotation : new Quaternion();
    scale = ( scale is Vector3 ) ? scale : new Vector3();

    scale.x = x.length();
    scale.y = y.length();
    scale.z = z.length();

    translation.x = te[12];
    translation.y = te[13];
    translation.z = te[14];

    // scale the rotation part
    Matrix4 matrix = __m1;

    matrix.copy( this );

    matrix.elements[0] /= scale.x;
    matrix.elements[1] /= scale.x;
    matrix.elements[2] /= scale.x;

    matrix.elements[4] /= scale.y;
    matrix.elements[5] /= scale.y;
    matrix.elements[6] /= scale.y;

    matrix.elements[8] /= scale.z;
    matrix.elements[9] /= scale.z;
    matrix.elements[10] /= scale.z;

    rotation.setFromRotationMatrix( matrix );

    return [ translation, rotation, scale ];
  }

  Matrix4 extractPosition( Matrix4 m ) {
    var te = elements;
    var me = m.elements;

    te[12] = me[12];
    te[13] = me[13];
    te[14] = me[14];

    return this;
  }

  Matrix4 extractRotation( Matrix4 m ) {

    var te = elements;
    var me = m.elements;

    Vector3 vector = __v1;

    var scaleX = 1 / vector.setValues( me[0], me[1], me[2] ).length();
    var scaleY = 1 / vector.setValues( me[4], me[5], me[6] ).length();
    var scaleZ = 1 / vector.setValues( me[8], me[9], me[10] ).length();

    te[0] = me[0] * scaleX;
    te[1] = me[1] * scaleX;
    te[2] = me[2] * scaleX;

    te[4] = me[4] * scaleY;
    te[5] = me[5] * scaleY;
    te[6] = me[6] * scaleY;

    te[8] = me[8] * scaleZ;
    te[9] = me[9] * scaleZ;
    te[10] = me[10] * scaleZ;

    return this;
  }

  Matrix4 translate( Vector3 v ) {
    var te = elements;
    var x = v.x, y = v.y, z = v.z;

    te[12] = te[0] * x + te[4] * y + te[8] * z + te[12];
    te[13] = te[1] * x + te[5] * y + te[9] * z + te[13];
    te[14] = te[2] * x + te[6] * y + te[10] * z + te[14];
    te[15] = te[3] * x + te[7] * y + te[11] * z + te[15];

    return this;
  }

  Matrix4 rotateX( num angle ) {
    var te = elements;
    var m12 = te[4];
    var m22 = te[5];
    var m32 = te[6];
    var m42 = te[7];
    var m13 = te[8];
    var m23 = te[9];
    var m33 = te[10];
    var m43 = te[11];
    var c = Math.cos( angle );
    var s = Math.sin( angle );

    te[4] = c * m12 + s * m13;
    te[5] = c * m22 + s * m23;
    te[6] = c * m32 + s * m33;
    te[7] = c * m42 + s * m43;

    te[8] = c * m13 - s * m12;
    te[9] = c * m23 - s * m22;
    te[10] = c * m33 - s * m32;
    te[11] = c * m43 - s * m42;

    return this;
  }

  Matrix4 rotateY( num angle ) {
    var te = elements;
    var m11 = te[0];
    var m21 = te[1];
    var m31 = te[2];
    var m41 = te[3];
    var m13 = te[8];
    var m23 = te[9];
    var m33 = te[10];
    var m43 = te[11];
    var c = Math.cos( angle );
    var s = Math.sin( angle );

    te[0] = c * m11 - s * m13;
    te[1] = c * m21 - s * m23;
    te[2] = c * m31 - s * m33;
    te[3] = c * m41 - s * m43;

    te[8] = c * m13 + s * m11;
    te[9] = c * m23 + s * m21;
    te[10] = c * m33 + s * m31;
    te[11] = c * m43 + s * m41;

    return this;
  }

  Matrix4 rotateZ( num angle ) {
    var te = elements;
    var m11 = te[0];
    var m21 = te[1];
    var m31 = te[2];
    var m41 = te[3];
    var m12 = te[4];
    var m22 = te[5];
    var m32 = te[6];
    var m42 = te[7];
    var c = Math.cos( angle );
    var s = Math.sin( angle );

    te[0] = c * m11 + s * m12;
    te[1] = c * m21 + s * m22;
    te[2] = c * m31 + s * m32;
    te[3] = c * m41 + s * m42;

    te[4] = c * m12 - s * m11;
    te[5] = c * m22 - s * m21;
    te[6] = c * m32 - s * m31;
    te[7] = c * m42 - s * m41;

    return this;
  }

  Matrix4 rotateByAxis( Vector3 axis, num angle ) {
    var te = elements;

    // optimize by checking axis
    if ( axis.x == 1 && axis.y == 0 && axis.z == 0 ) {
      return rotateX( angle );
    } else if ( axis.x == 0 && axis.y == 1 && axis.z == 0 ) {
      return rotateY( angle );
    } else if ( axis.x == 0 && axis.y == 0 && axis.z == 1 ) {
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
      r33 = zz + (1 - zz) * c;

    var m11 = te[0], m21 = te[1], m31 = te[2], m41 = te[3];
    var m12 = te[4], m22 = te[5], m32 = te[6], m42 = te[7];
    var m13 = te[8], m23 = te[9], m33 = te[10], m43 = te[11];
    var m14 = te[12], m24 = te[13], m34 = te[14], m44 = te[15];

    te[0] = r11 * m11 + r21 * m12 + r31 * m13;
    te[1] = r11 * m21 + r21 * m22 + r31 * m23;
    te[2] = r11 * m31 + r21 * m32 + r31 * m33;
    te[3] = r11 * m41 + r21 * m42 + r31 * m43;

    te[4] = r12 * m11 + r22 * m12 + r32 * m13;
    te[5] = r12 * m21 + r22 * m22 + r32 * m23;
    te[6] = r12 * m31 + r22 * m32 + r32 * m33;
    te[7] = r12 * m41 + r22 * m42 + r32 * m43;

    te[8] = r13 * m11 + r23 * m12 + r33 * m13;
    te[9] = r13 * m21 + r23 * m22 + r33 * m23;
    te[10] = r13 * m31 + r23 * m32 + r33 * m33;
    te[11] = r13 * m41 + r23 * m42 + r33 * m43;


    return this;
  }

  Matrix4 scale( Vector3 v ) {

    var te = elements;
    num x = v.x, y = v.y, z = v.z;

    te[0] *= x; te[4] *= y; te[8] *= z;
    te[1] *= x; te[5] *= y; te[9] *= z;
    te[2] *= x; te[6] *= y; te[10] *= z;
    te[3] *= x; te[7] *= y; te[11] *= z;

    return this;
  }

  double getMaxScaleOnAxis() {

    var te = elements;

    var scaleXSq =  te[0] * te[0] + te[1] * te[1] + te[2] * te[2];
    var scaleYSq =  te[4] * te[4] + te[5] * te[5] + te[6] * te[6];
    var scaleZSq =  te[8] * te[8] + te[9] * te[9] + te[10] * te[10];

    return Math.sqrt( Math.max( scaleXSq, Math.max( scaleYSq, scaleZSq ) ) );

  }

  Matrix4 makeTranslation( num x, num y, num z ) {
    setValues(
      1, 0, 0, x,
      0, 1, 0, y,
      0, 0, 1, z,
      0, 0, 0, 1
    );

    return this;
  }

  Matrix4 makeRotationX( num theta ) {
    num c = Math.cos( theta ), s = Math.sin( theta );

    setValues(
      1, 0,  0, 0,
      0, c, -s, 0,
      0, s,  c, 0,
      0, 0,  0, 1
    );

    return this;
  }

  Matrix4 makeRotationY( num theta ) {
    num c = Math.cos( theta ), s = Math.sin( theta );

    setValues(
       c, 0, s, 0,
       0, 1, 0, 0,
      -s, 0, c, 0,
       0, 0, 0, 1
    );

    return this;
  }

  Matrix4 makeRotationZ( num theta ) {
    num c = Math.cos( theta ), s = Math.sin( theta );

    setValues(
      c, -s, 0, 0,
      s,  c, 0, 0,
      0,  0, 1, 0,
      0,  0, 0, 1
    );

    return this;
  }

  Matrix4 makeRotationAxis( Vector3 axis, num angle ) {
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

  Matrix4 makeScale( num x, num y, num z ) {
    setValues(
      x, 0, 0, 0,
      0, y, 0, 0,
      0, 0, z, 0,
      0, 0, 0, 1
    );

    return this;
  }

  Matrix4 makeFrustum( num left, num right, num bottom, num top, num near, num far ) {
    var te = elements;

    num x, y, a, b, c, d;

    x = 2 * near / ( right - left );
    y = 2 * near / ( top - bottom );

    a = ( right + left ) / ( right - left );
    b = ( top + bottom ) / ( top - bottom );
    c = - ( far + near ) / ( far - near );
    d = - 2 * far * near / ( far - near );

    te[0] = x;  te[4] = 0;  te[8] = a;   te[12] = 0;
    te[1] = 0;  te[5] = y;  te[9] = b;   te[13] = 0;
    te[2] = 0;  te[6] = 0;  te[10] = c;   te[14] = d;
    te[3] = 0;  te[7] = 0;  te[11] = - 1; te[15] = 0;

    return this;
  }

  Matrix4 makePerspective( num fov, num aspect, num near, num far ) {
    num ymax, ymin, xmin, xmax;

    ymax = near * Math.tan( fov * Math.PI / 360 );
    ymin = - ymax;
    xmin = ymin * aspect;
    xmax = ymax * aspect;

    return makeFrustum( xmin, xmax, ymin, ymax, near, far );
  }

  Matrix4 makeOrthographic( num left, num right, num top, num bottom, num near, num far ) {
    var te = elements;

    num x, y, z, w, h, p;

    w = right - left;
    h = top - bottom;
    p = far - near;

    x = ( right + left ) / w;
    y = ( top + bottom ) / h;
    z = ( far + near ) / p;

    te[0] = 2 / w; te[4] = 0;     te[8] = 0;      te[12] = -x;
    te[1] = 0;     te[5] = 2 / h; te[9] = 0;      te[13] = -y;
    te[2] = 0;     te[6] = 0;     te[10] = -2 / p; te[14] = -z;
    te[3] = 0;     te[7] = 0;     te[11] = 0;      te[15] = 1;

    return this;
  }

  Matrix4 clone() {
    var te = elements;

    return new Matrix4(

      te[0], te[4], te[8], te[12],
      te[1], te[5], te[9], te[13],
      te[2], te[6], te[10], te[14],
      te[3], te[7], te[11], te[15]

    );
  }

  //TODO: Fix "Expected Constant Expression" problem

  // Axis Vectors, X, Y, Z
  static Vector3 ___v1;
  static Vector3 ___v2;
  static Vector3 ___v3;

  // Rotation, Scale
  static Matrix4 ___m1;
  static Matrix4 ___m2;

  static Vector3 get __v1 {
    if (___v1 == null) {
      ___v1 = new Vector3();
    }
    return ___v1;
  }

  static Vector3 get __v2 {
    if (___v2 == null) {
      ___v2 = new Vector3();
    }
    return ___v2;
  }

  static Vector3 get __v3 {
    if (___v3 == null) {
      ___v3 = new Vector3();
    }
    return ___v3;
  }

  static Matrix4 get __m1 {
    if (___m1 == null) {
      ___m1 = new Matrix4();
    }
    return ___m1;
  }

  static Matrix4 get __m2 {
    if (___m2 == null) {
      ___m2 = new Matrix4();
    }
    return ___m2;
  }
}
