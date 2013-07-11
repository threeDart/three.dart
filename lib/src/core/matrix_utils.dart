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
 * @author anders forsell / http://aforsell.blogspot.com/
 */

Matrix4 makeLookAt(Matrix4 m, Vector3 eye, Vector3 center, Vector3 up ) {
  Vector3 z = (eye - center ).normalize();
  if ( z.length == 0.0 ) {
    z.z = 1.0;
  }

  Vector3 x = up.cross(z).normalize();
  if ( x.length == 0.0 ) {
    z.x = z.x + 0.0001;
    x = up.cross( z ).normalize();
  }

  Vector3 y = z.cross( x ).normalize();

  m.setValues(x.x, x.y, x.z, 0.0,
              y.x, y.y, y.z, 0.0,
              z.x, z.y, z.z, 0.0,
              0.0, 0.0, 0.0, 1.0);
  return m;
}

Matrix4 setRotationFromEuler( Matrix4 m, Vector3 v, [String order = 'XYZ'] ) {
  num x = v.x, y = v.y, z = v.z,
      a = Math.cos( x ), b = Math.sin( x ),
      c = Math.cos( y ), d = Math.sin( y ),
      e = Math.cos( z ), f = Math.sin( z );

  switch ( order ) {
    case 'YXZ':

      num ce = c * e, cf = c * f, de = d * e, df = d * f;

      m[0] = ce + df * b;
      m[4] = de * b - cf;
      m[8] = a * d;

      m[1] = a * f;
      m[5] = a * e;
      m[9] = - b;

      m[2] = cf * b - de;
      m[6] = df + ce * b;
      m[10] = a * c;
      break;

    case 'ZXY':

      num ce = c * e, cf = c * f, de = d * e, df = d * f;

      m[0] = ce - df * b;
      m[4] = - a * f;
      m[8] = de + cf * b;

      m[1] = cf + de * b;
      m[5] = a * e;
      m[9] = df - ce * b;

      m[2] = - a * d;
      m[6] = b;
      m[10] = a * c;
      break;

    case 'ZYX':

      num ae = a * e, af = a * f, be = b * e, bf = b * f;

      m[0] = c * e;
      m[4] = be * d - af;
      m[8] = ae * d + bf;

      m[1] = c * f;
      m[5] = bf * d + ae;
      m[9] = af * d - be;

      m[2] = - d;
      m[6] = b * c;
      m[10] = a * c;
      break;

    case 'YZX':

      num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

      m[0] = c * e;
      m[4] = bd - ac * f;
      m[8] = bc * f + ad;

      m[1] = f;
      m[5] = a * e;
      m[9] = - b * e;

      m[2] = - d * e;
      m[6] = ad * f + bc;
      m[10] = ac - bd * f;
      break;

    case 'XZY':

      num ac = a * c, ad = a * d, bc = b * c, bd = b * d;

      m[0] = c * e;
      m[4] = - f;
      m[8] = d * e;

      m[1] = ac * f + bd;
      m[5] = a * e;
      m[9] = ad * f - bc;

      m[2] = bc * f - ad;
      m[6] = b * e;
      m[10] = bd * f + ac;
      break;

    default: // 'XYZ'

      num ae = a * e, af = a * f, be = b * e, bf = b * f;

      m[0] = c * e;
      m[4] = - c * f;
      m[8] = d;

      m[1] = af + be * d;
      m[5] = ae - bf * d;
      m[9] = - b * c;

      m[2] = bf - ae * d;
      m[6] = be + af * d;
      m[10] = a * c;
      break;

  }

  return m;
}


Matrix4 setRotationFromQuaternion( Matrix4 m, Quaternion q ) {
  num x = q.x, y = q.y, z = q.z, w = q.w,
      x2 = x + x, y2 = y + y, z2 = z + z,
      xx = x * x2, xy = x * y2, xz = x * z2,
      yy = y * y2, yz = y * z2, zz = z * z2,
      wx = w * x2, wy = w * y2, wz = w * z2;

  m[0] = 1.0 - ( yy + zz );
  m[4] = xy - wz;
  m[8] = xz + wy;

  m[1] = xy + wz;
  m[5] = 1.0 - ( xx + zz );
  m[9] = yz - wx;

  m[2] = xz - wy;
  m[6] = yz + wx;
  m[10] = 1.0 - ( xx + yy );

  return m;
}

double calcMaxScaleOnAxis(Matrix4 te) {

  var scaleXSq =  te[0] * te[0] + te[1] * te[1] + te[2] * te[2];
  var scaleYSq =  te[4] * te[4] + te[5] * te[5] + te[6] * te[6];
  var scaleZSq =  te[8] * te[8] + te[9] * te[9] + te[10] * te[10];

  return Math.sqrt( Math.max( scaleXSq, Math.max( scaleYSq, scaleZSq ) ) );

}

// TODO check if this is available in vector_math library
Matrix3 calcInverse( Matrix4 m ) {

  // input: THREE.Matrix4
  // ( based on http://code.google.com/p/webgl-mjs/ )

  double a11 =   m[10] * m[5] - m[6] * m[9];
  double a21 = - m[10] * m[1] + m[2] * m[9];
  double a31 =   m[6]  * m[1] - m[2] * m[5];
  double a12 = - m[10] * m[4] + m[6] * m[8];
  double a22 =   m[10] * m[0] - m[2] * m[8];
  double a32 = - m[6]  * m[0] + m[2] * m[4];
  double a13 =   m[9]  * m[4] - m[5] * m[8];
  double a23 = - m[9]  * m[0] + m[1] * m[8];
  double a33 =   m[5]  * m[0] - m[1] * m[4];

  var det = m[0] * a11 + m[1] * a12 + m[2] * a13;

  // no inverse

  if ( det == 0 ) {

    print( "Matrix3.getInverse(): determinant == 0" );

  }

  var idet = 1.0 / det;

  return new Matrix3(idet * a11, idet * a21, idet * a31,
                     idet * a12, idet * a22, idet * a32,
                     idet * a13, idet * a23, idet * a33);
}

Matrix4 extractRotation( Matrix4 te, Matrix4 m ) {

  Vector3 vector = new Vector3.zero();

  var scaleX = 1.0 / vector.setValues ( m[0], m[1], m[2] ).length;
  var scaleY = 1.0 / vector.setValues( m[4], m[5], m[6] ).length;
  var scaleZ = 1.0 / vector.setValues( m[8], m[9], m[10] ).length;

  te[0] = m[0] * scaleX;
  te[1] = m[1] * scaleX;
  te[2] = m[2] * scaleX;

  te[4] = m[4] * scaleY;
  te[5] = m[5] * scaleY;
  te[6] = m[6] * scaleY;

  te[8] = m[8] * scaleZ;
  te[9] = m[9] * scaleZ;
  te[10] = m[10] * scaleZ;

  return te;
}

Vector3 getScaleFromMatrix(Matrix4 m) {
  double sx = new Vector3(m.storage[0], m.storage[1], m.storage[2]).length;
  double sy = new Vector3(m.storage[4], m.storage[5], m.storage[6]).length;
  double sz = new Vector3(m.storage[8], m.storage[9], m.storage[10]).length;
  return new Vector3(sx, sy, sz);
}

List decompose(Matrix4 m, Vector3 translation, Quaternion rotation, Vector3 scale ) {

  var te = m.storage;

  // grab the axis vectors
  Vector3 x = new Vector3( te[0], te[1], te[2] );
  Vector3 y = new Vector3( te[4], te[5], te[6] );
  Vector3 z = new Vector3( te[8], te[9], te[10] );

  translation = ( translation is Vector3 ) ? translation : new Vector3.zero();
  rotation = ( rotation is Quaternion ) ? rotation : new Quaternion.identity();
  scale = ( scale is Vector3 ) ? scale : new Vector3.zero();

  scale.x = x.length;
  scale.y = y.length;
  scale.z = z.length;

  translation.x = te[12];
  translation.y = te[13];
  translation.z = te[14];

  // scale the rotation part

  Matrix4 matrix = m.clone();

  matrix.storage[0] /= scale.x;
  matrix.storage[1] /= scale.x;
  matrix.storage[2] /= scale.x;

  matrix.storage[4] /= scale.y;
  matrix.storage[5] /= scale.y;
  matrix.storage[6] /= scale.y;

  matrix.storage[8] /= scale.z;
  matrix.storage[9] /= scale.z;
  matrix.storage[10] /= scale.z;

  setFromRotationMatrix( rotation, matrix );


  return [ translation, rotation, scale ];
}

Quaternion setFromRotationMatrix(Quaternion quaternion, Matrix4 m ) {

  // http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm

  // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
  quaternion = new Quaternion.identity();

  var te = m.storage,
      m11 = te[0], m12 = te[4], m13 = te[8],
      m21 = te[1], m22 = te[5], m23 = te[9],
      m31 = te[2], m32 = te[6], m33 = te[10],
      trace = m11 + m22 + m33,
      s;

  if( trace > 0 ) {

    s = 0.5 / Math.sqrt( trace + 1.0 );

    quaternion.w = 0.25 / s;
    quaternion.x = ( m32 - m23 ) * s;
    quaternion.y = ( m13 - m31 ) * s;
    quaternion.z = ( m21 - m12 ) * s;

  } else if ( m11 > m22 && m11 > m33 ) {

    s = 2.0 * Math.sqrt( 1.0 + m11 - m22 - m33 );

    quaternion.w = (m32 - m23 ) / s;
    quaternion.x = 0.25 * s;
    quaternion.y = (m12 + m21 ) / s;
    quaternion.z = (m13 + m31 ) / s;

  } else if (m22 > m33) {

    s = 2.0 * Math.sqrt( 1.0 + m22 - m11 - m33 );

    quaternion.w = (m13 - m31 ) / s;
    quaternion.x = (m12 + m21 ) / s;
    quaternion.y = 0.25 * s;
    quaternion.z = (m23 + m32 ) / s;

  } else {

    s = 2.0 * Math.sqrt( 1.0 + m33 - m11 - m22 );

    quaternion.w = ( m21 - m12 ) / s;
    quaternion.x = ( m13 + m31 ) / s;
    quaternion.y = ( m23 + m32 ) / s;
    quaternion.z = 0.25 * s;

  }

  return quaternion;
}

Matrix4 compose( Matrix4 matrix, Vector3 translation, Quaternion rotation, Vector3 s ) {

  var te = matrix.storage;

  Matrix4 mRotation = new Matrix4.identity();
  setRotationFromQuaternion( mRotation, rotation );

  Matrix4 mScale = new Matrix4.diagonal3Values(s.x, s.y, s.z);

  mRotation.multiply(mScale);

  te[12] = translation.x;
  te[13] = translation.y;
  te[14] = translation.z;

  return matrix;
}

Matrix4 makeRotationAxis( Matrix4 m, Vector3 axis, num angle ) {
  // Based on http://www.gamedev.net/reference/articles/article1199.asp

  num c = Math.cos( angle ),
      s = Math.sin( angle ),
      t = 1.0 - c,
      x = axis.x, y = axis.y, z = axis.z,
      tx = t * x, ty = t * y;

  m.setValues(
      tx * x + c, tx * y - s * z, tx * z + s * y, 0.0,
      tx * y + s * z, ty * y + c, ty * z - s * x, 0.0,
      tx * z - s * y, ty * z + s * x, t * z * z + c, 0.0,
      0.0, 0.0, 0.0, 1.0
    );

   return m;
}

multiplyVector3Array(Matrix4 m, List<double> a) {

  var v1 = new Vector3.zero();
  var il = a.length;

  for ( var i = 0; i < il; i += 3 ) {

    v1.x = a[ i ];
    v1.y = a[ i + 1 ];
    v1.z = a[ i + 2 ];

    v1.applyProjection( m );

    a[ i ]     = v1.x;
    a[ i + 1 ] = v1.y;
    a[ i + 2 ] = v1.z;

  }

  return a;
}
