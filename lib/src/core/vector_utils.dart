part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author kile / http://kile.stravaganza.org/
 * @author philogb / http://blog.thejit.org/
 * @author mikael emtinger / http://gomo.se/
 * @author egraether / http://egraether.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 * @author anders forsell / http://aforsell.blogspot.com
 *
 * (moved from three.js Vector3 to here since these are missing in vector_math's Vector3)
 */

Vector3 calcEulerFromRotationMatrix( Matrix4 m, [String order = 'XYZ'] ) {
  double x, y, z;

  // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

  // clamp, to handle numerical problems

  var clamp = ( x ) => Math.min( Math.max( x, -1 ), 1 );

  var m11 = m[0], m12 = m[4], m13 = m[8];
  var m21 = m[1], m22 = m[5], m23 = m[9];
  var m31 = m[2], m32 = m[6], m33 = m[10];

  if ( order == 'XYZ' ) {

    y = Math.asin( clamp( m13 ) );

    if (  m13.abs() < 0.99999 ) {

      x = Math.atan2( - m23, m33 );
      z = Math.atan2( - m12, m11 );

    } else {

      x = Math.atan2( m21, m22 );
      z = 0.0;

    }

  } else if ( order == 'YXZ' ) {

    x = Math.asin( - clamp( m23 ) );

    if ( m23.abs() < 0.99999 ) {

      y = Math.atan2( m13, m33 );
      z = Math.atan2( m21, m22 );

    } else {

      y = Math.atan2( - m31, m11 );
      z = 0.0;

    }

  } else if ( order == 'ZXY' ) {

    x = Math.asin( clamp( m32 ) );

    if ( m32.abs() < 0.99999 ) {

      y = Math.atan2( - m31, m33 );
      z = Math.atan2( - m12, m22 );

    } else {

      y = 0.0;
      z = Math.atan2( m13, m11 );

    }

  } else if ( order == 'ZYX' ) {

    y = Math.asin( - clamp( m31 ) );

    if (m31.abs() < 0.99999 ) {

      x = Math.atan2( m32, m33 );
      z = Math.atan2( m21, m11 );

    } else {

      x = 0.0;
      z = Math.atan2( - m12, m22 );

    }

  } else if ( order == 'YZX' ) {

    z = Math.asin( clamp( m21 ) );

    if ( m21.abs() < 0.99999 ) {

      x = Math.atan2( - m23, m22 );
      y = Math.atan2( - m31, m11 );

    } else {

      x = 0.0;
      y = Math.atan2( m31, m33 );

    }

  } else if ( order == 'XZY' ) {

    z = Math.asin( - clamp( m12 ) );

    if ( m12.abs() < 0.99999 ) {

      x = Math.atan2( m32, m22 );
      y = Math.atan2( m13, m11 );

    } else {

      x = Math.atan2( - m13, m33 );
      y = 0.0;

    }

  }

  return new Vector3(x, y, z);
}

Vector3 calcEulerFromQuaternion(Vector4 q, [String order = 'XYZ'] ) {
  double x, y, z;
  // q is assumed to be normalized

  // clamp, to handle numerical problems

  var clamp = ( x ) => Math.min( Math.max( x, -1 ), 1 );

  // http://www.mathworks.com/matlabcentral/fileexchange/20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/content/SpinCalc.m

  var sqx = q.x * q.x;
  var sqy = q.y * q.y;
  var sqz = q.z * q.z;
  var sqw = q.w * q.w;

  if ( order == 'XYZ' ) {

    x = Math.atan2( 2 * ( q.x * q.w - q.y * q.z ), ( sqw - sqx - sqy + sqz ) );
    y = Math.asin(  clamp( 2 * ( q.x * q.z + q.y * q.w ) ) );
    z = Math.atan2( 2 * ( q.z * q.w - q.x * q.y ), ( sqw + sqx - sqy - sqz ) );

  } else if ( order ==  'YXZ' ) {

    x = Math.asin(  clamp( 2 * ( q.x * q.w - q.y * q.z ) ) );
    y = Math.atan2( 2 * ( q.x * q.z + q.y * q.w ), ( sqw - sqx - sqy + sqz ) );
    z = Math.atan2( 2 * ( q.x * q.y + q.z * q.w ), ( sqw - sqx + sqy - sqz ) );

  } else if ( order == 'ZXY' ) {

    x = Math.asin(  clamp( 2 * ( q.x * q.w + q.y * q.z ) ) );
    y = Math.atan2( 2 * ( q.y * q.w - q.z * q.x ), ( sqw - sqx - sqy + sqz ) );
    z = Math.atan2( 2 * ( q.z * q.w - q.x * q.y ), ( sqw - sqx + sqy - sqz ) );

  } else if ( order == 'ZYX' ) {

    x = Math.atan2( 2 * ( q.x * q.w + q.z * q.y ), ( sqw - sqx - sqy + sqz ) );
    y = Math.asin(  clamp( 2 * ( q.y * q.w - q.x * q.z ) ) );
    z = Math.atan2( 2 * ( q.x * q.y + q.z * q.w ), ( sqw + sqx - sqy - sqz ) );

  } else if ( order == 'YZX' ) {

    x = Math.atan2( 2 * ( q.x * q.w - q.z * q.y ), ( sqw - sqx + sqy - sqz ) );
    y = Math.atan2( 2 * ( q.y * q.w - q.x * q.z ), ( sqw + sqx - sqy - sqz ) );
    z = Math.asin(  clamp( 2 * ( q.x * q.y + q.z * q.w ) ) );

  } else if ( order == 'XZY' ) {

    x = Math.atan2( 2 * ( q.x * q.w + q.y * q.z ), ( sqw - sqx + sqy - sqz ) );
    y = Math.atan2( 2 * ( q.x * q.z + q.y * q.w ), ( sqw + sqx - sqy - sqz ) );
    z = Math.asin(  clamp( 2 * ( q.z * q.w - q.x * q.y ) ) );

  }

  return new Vector3(x, y, z);
}

Vector4 lerp4(Vector4 start, Vector4 end, double percent) {
     return (start + (end - start).scale(percent));
}
