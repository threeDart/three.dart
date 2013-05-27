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

Matrix4 makeFrustum( double left, double right, double bottom, double top, double near, double far ) {
  double x = 2 * near / ( right - left );
  double y = 2 * near / ( top - bottom );

  double a = ( right + left ) / ( right - left );
  double b = ( top + bottom ) / ( top - bottom );
  double c = - ( far + near ) / ( far - near );
  double d = - 2 * far * near / ( far - near );

  return new Matrix4(x, 0.0, 0.0, 0.0,
                     0.0, y, 0.0, 0.0,
                     a, b, c, -1.0,
                     0.0, 0.0, d, 0.0);
}

Matrix4 makePerspective( double fov, double aspect, double near, double far ) {

  double ymax = near * Math.tan( fov * Math.PI / 360 );
  double ymin = - ymax;
  double xmin = ymin * aspect;
  double xmax = ymax * aspect;

  return makeFrustum( xmin, xmax, ymin, ymax, near, far );
}

Matrix4 makeOrthographic( double left, double right, double top, double bottom, double near, double far ) {
  double w = right - left;
  double h = top - bottom;
  double p = far - near;

  double x = ( right + left ) / w;
  double y = ( top + bottom ) / h;
  double z = ( far + near ) / p;

  return new Matrix4(2.0 / w, 0.0, 0.0, 0.0,
                     0.0, 2.0 / h, 0.0, 0.0,
                     0.0, 0.0, -2.0 / p, 0.0,
                     -x, -y, -z, 1.0);
}

Matrix4 makeLookAt( Vector3 eye, Vector3 center, Vector3 up ) {
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

  return new Matrix4(x.x, x.y, x.z, 0.0,
                     y.x, y.y, y.z, 0.0,
                     z.x, z.y, z.z, 0.0,
                     0.0, 0.0, 0.0, 1.0);
}

Matrix4 calcRotationFromEuler( Vector3 v, [String order = 'XYZ'] ) {
  Matrix4 te = new Matrix4.zero();
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

  return te;
}


Matrix4 calcRotationFromQuaternion( Quaternion q ) {
  Matrix4 te = new Matrix4.zero();

  num x = q.x, y = q.y, z = q.z, w = q.w,
      x2 = x + x, y2 = y + y, z2 = z + z,
      xx = x * x2, xy = x * y2, xz = x * z2,
      yy = y * y2, yz = y * z2, zz = z * z2,
      wx = w * x2, wy = w * y2, wz = w * z2;

  te[0] = 1.0 - ( yy + zz );
  te[4] = xy - wz;
  te[8] = xz + wy;

  te[1] = xy + wz;
  te[5] = 1.0 - ( xx + zz );
  te[9] = yz - wx;

  te[2] = xz - wy;
  te[6] = yz + wx;
  te[10] = 1.0 - ( xx + yy );

  return te;
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

Matrix4 extractRotation( Matrix4 m ) {

  Matrix4 rotation = new Matrix4.identity();

  Vector3 vector = new Vector3.zero();

  var scaleX = 1.0 / vector.setValues ( m[0], m[1], m[2] ).length;
  var scaleY = 1.0 / vector.setValues( m[4], m[5], m[6] ).length;
  var scaleZ = 1.0 / vector.setValues( m[8], m[9], m[10] ).length;

  rotation[0] = m[0] * scaleX;
  rotation[1] = m[1] * scaleX;
  rotation[2] = m[2] * scaleX;

  rotation[4] = m[4] * scaleY;
  rotation[5] = m[5] * scaleY;
  rotation[6] = m[6] * scaleY;

  rotation[8] = m[8] * scaleZ;
  rotation[9] = m[9] * scaleZ;
  rotation[10] = m[10] * scaleZ;

  return rotation;
}

// TODO Find a suitable replacement in vector_math ( "transform3" ?)
void multiplyVector3(Matrix4 te, Vector3 v ) {
  var vx = v.x, vy = v.y, vz = v.z;
  var d = 1.0 / ( te[3] * vx + te[7] * vy + te[11] * vz + te[15] );

  v[0] = ( te[0] * vx + te[4] * vy + te[8] * vz + te[12] ) * d;
  v[1] = ( te[1] * vx + te[5] * vy + te[9] * vz + te[13] ) * d;
  v[2] = ( te[2] * vx + te[6] * vy + te[10] * vz + te[14] ) * d;
}



