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
 */

class Vector3 implements IVector3 {
  num x;
  num y;
  num z;

  Vector3( [this.x = 0, this.y = 0, this.z = 0] );

  // changed "set" to "setValues" as "set" is reserved.
  Vector3 setValues( num x, num y, num z ) {
    this.x = x;
    this.y = y;
    this.z = z;

    return this;
  }

  Vector3 setX( num x ) {
    this.x = x;

    return this;
  }

  Vector3 setY( num y ) {
    this.y = y;

    return this;
  }

  Vector3 setZ( num z ) {
    this.z = z;

    return this;
  }

  Vector3 copy( Vector3 v ) {
    x = v.x;
    y = v.y;
    z = v.z;

    return this;
  }

  Vector3 add( IVector3 v1, IVector3 v2 ) {
    x = v1.x + v2.x;
    y = v1.y + v2.y;
    z = v1.z + v2.z;

    return this;
  }

  Vector3 addSelf( IVector3 v ) {
    x += v.x;
    y += v.y;
    z += v.z;

    return this;
  }

  Vector3 addScalar( num s ) {
    x += s;
    y += s;
    z += s;

    return this;
  }

  Vector3 sub( Vector3 v1, Vector3 v2 ) {
    x = v1.x - v2.x;
    y = v1.y - v2.y;
    z = v1.z - v2.z;

    return this;
  }

  Vector3 subSelf( Vector3 v ) {
    x -= v.x;
    y -= v.y;
    z -= v.z;

    return this;
  }

  Vector3 multiply( Vector3 a, Vector3 b ) {
    x = a.x * b.x;
    y = a.y * b.y;
    z = a.z * b.z;

    return this;
  }

  Vector3 multiplySelf( Vector3 v ) {
    x *= v.x;
    y *= v.y;
    z *= v.z;

    return this;
  }

  Vector3 multiplyScalar( num s ) {
    x *= s;
    y *= s;
    z *= s;

    return this;
  }

  Vector3 divideSelf( Vector3 v ) {
    x /= v.x;
    y /= v.y;
    z /= v.z;

    return this;
  }

  Vector3 divideScalar( num s ) {
    if ( s != 0 ) {
      x /= s;
      y /= s;
      z /= s;
    } else {
      x = 0;
      y = 0;
      z = 0;
    }

    return this;
  }

  Vector3 negate() => multiplyScalar( -1 );

  num dot( Vector3 v ) => x * v.x + y * v.y + z * v.z;

  // TODO - These should probably be getters

  num lengthSq() => x * x + y * y + z * z;

  num length() => Math.sqrt( lengthSq() );

  num lengthManhattan() =>  x.abs() + y.abs() + z.abs();


  Vector3 normalize() => divideScalar( length() );

  Vector3 setLength( l ) => normalize().multiplyScalar( l );

  lerpSelf( Vector3 v, num alpha ) {

    this.x += ( v.x - this.x ) * alpha;
    this.y += ( v.y - this.y ) * alpha;
    this.z += ( v.z - this.z ) * alpha;

    return this;

  }

  Vector3 cross( Vector3 a, Vector3 b ) {
    x = a.y * b.z - a.z * b.y;
    y = a.z * b.x - a.x * b.z;
    z = a.x * b.y - a.y * b.x;

    return this;
  }

  Vector3 crossSelf( Vector3 v ) {
    num x2 = x, y2 = y, z2 = z;

    x = y2 * v.z - z2 * v.y;
    y = z2 * v.x - x2 * v.z;
    z = x2 * v.y - y2 * v.x;

    return this;
  }

  num distanceTo( Vector3 v ) => Math.sqrt( distanceToSquared( v ) );

  num distanceToSquared( Vector3 v ) => new Vector3().sub( this, v ).lengthSq();

  Vector3 getPositionFromMatrix( m ) {

    this.x = m.elements[12];
    this.y = m.elements[13];
    this.z = m.elements[14];

    return this;

  }

  Vector3 setEulerFromRotationMatrix( m, [String order = 'XYZ'] ) {

    // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

    // clamp, to handle numerical problems

    var clamp = ( x ) => Math.min( Math.max( x, -1 ), 1 );

    var te = m.elements;
    var m11 = te[0], m12 = te[4], m13 = te[8];
    var m21 = te[1], m22 = te[5], m23 = te[9];
    var m31 = te[2], m32 = te[6], m33 = te[10];

    if ( order == 'XYZ' ) {

      this.y = Math.asin( clamp( m13 ) );

      if (  m13.abs() < 0.99999 ) {

        this.x = Math.atan2( - m23, m33 );
        this.z = Math.atan2( - m12, m11 );

      } else {

        this.x = Math.atan2( m21, m22 );
        this.z = 0;

      }

    } else if ( order == 'YXZ' ) {

      this.x = Math.asin( - clamp( m23 ) );

      if ( m23.abs() < 0.99999 ) {

        this.y = Math.atan2( m13, m33 );
        this.z = Math.atan2( m21, m22 );

      } else {

        this.y = Math.atan2( - m31, m11 );
        this.z = 0;

      }

    } else if ( order == 'ZXY' ) {

      this.x = Math.asin( clamp( m32 ) );

      if ( m32.abs() < 0.99999 ) {

        this.y = Math.atan2( - m31, m33 );
        this.z = Math.atan2( - m12, m22 );

      } else {

        this.y = 0;
        this.z = Math.atan2( m13, m11 );

      }

    } else if ( order == 'ZYX' ) {

      this.y = Math.asin( - clamp( m31 ) );

      if (m31.abs() < 0.99999 ) {

        this.x = Math.atan2( m32, m33 );
        this.z = Math.atan2( m21, m11 );

      } else {

        this.x = 0;
        this.z = Math.atan2( - m12, m22 );

      }

    } else if ( order == 'YZX' ) {

      this.z = Math.asin( clamp( m21 ) );

      if ( m21.abs() < 0.99999 ) {

        this.x = Math.atan2( - m23, m22 );
        this.y = Math.atan2( - m31, m11 );

      } else {

        this.x = 0;
        this.y = Math.atan2( m31, m33 );

      }

    } else if ( order == 'XZY' ) {

      this.z = Math.asin( - clamp( m12 ) );

      if ( m12.abs() < 0.99999 ) {

        this.x = Math.atan2( m32, m22 );
        this.y = Math.atan2( m13, m11 );

      } else {

        this.x = Math.atan2( - m13, m33 );
        this.y = 0;

      }

    }

    return this;

  }

  setEulerFromQuaternion( q, [String order = 'XYZ'] ) {

    // q is assumed to be normalized

    // clamp, to handle numerical problems

    var clamp = ( x ) => Math.min( Math.max( x, -1 ), 1 );

    // http://www.mathworks.com/matlabcentral/fileexchange/20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/content/SpinCalc.m

    var sqx = q.x * q.x;
    var sqy = q.y * q.y;
    var sqz = q.z * q.z;
    var sqw = q.w * q.w;

    if ( order == 'XYZ' ) {

      this.x = Math.atan2( 2 * ( q.x * q.w - q.y * q.z ), ( sqw - sqx - sqy + sqz ) );
      this.y = Math.asin(  clamp( 2 * ( q.x * q.z + q.y * q.w ) ) );
      this.z = Math.atan2( 2 * ( q.z * q.w - q.x * q.y ), ( sqw + sqx - sqy - sqz ) );

    } else if ( order ==  'YXZ' ) {

      this.x = Math.asin(  clamp( 2 * ( q.x * q.w - q.y * q.z ) ) );
      this.y = Math.atan2( 2 * ( q.x * q.z + q.y * q.w ), ( sqw - sqx - sqy + sqz ) );
      this.z = Math.atan2( 2 * ( q.x * q.y + q.z * q.w ), ( sqw - sqx + sqy - sqz ) );

    } else if ( order == 'ZXY' ) {

      this.x = Math.asin(  clamp( 2 * ( q.x * q.w + q.y * q.z ) ) );
      this.y = Math.atan2( 2 * ( q.y * q.w - q.z * q.x ), ( sqw - sqx - sqy + sqz ) );
      this.z = Math.atan2( 2 * ( q.z * q.w - q.x * q.y ), ( sqw - sqx + sqy - sqz ) );

    } else if ( order == 'ZYX' ) {

      this.x = Math.atan2( 2 * ( q.x * q.w + q.z * q.y ), ( sqw - sqx - sqy + sqz ) );
      this.y = Math.asin(  clamp( 2 * ( q.y * q.w - q.x * q.z ) ) );
      this.z = Math.atan2( 2 * ( q.x * q.y + q.z * q.w ), ( sqw + sqx - sqy - sqz ) );

    } else if ( order == 'YZX' ) {

      this.x = Math.atan2( 2 * ( q.x * q.w - q.z * q.y ), ( sqw - sqx + sqy - sqz ) );
      this.y = Math.atan2( 2 * ( q.y * q.w - q.x * q.z ), ( sqw + sqx - sqy - sqz ) );
      this.z = Math.asin(  clamp( 2 * ( q.x * q.y + q.z * q.w ) ) );

    } else if ( order == 'XZY' ) {

      this.x = Math.atan2( 2 * ( q.x * q.w + q.y * q.z ), ( sqw - sqx + sqy - sqz ) );
      this.y = Math.atan2( 2 * ( q.x * q.z + q.y * q.w ), ( sqw + sqx - sqy - sqz ) );
      this.z = Math.asin(  clamp( 2 * ( q.z * q.w - q.x * q.y ) ) );

    }

    return this;

  }


  Vector3 getScaleFromMatrix( m ) {

    var sx = this.setValues( m.elements[0], m.elements[1], m.elements[2] ).length();
    var sy = this.setValues( m.elements[4], m.elements[5], m.elements[6] ).length();
    var sz = this.setValues( m.elements[8], m.elements[9], m.elements[10] ).length();

    this.x = sx;
    this.y = sy;
    this.z = sz;

    return this;
  }

  bool equals( v ) {
    if (v == null) return false;
    return ( ( v.x == this.x ) && ( v.y == this.y ) && ( v.z == this.z ) );
  }

  bool isZero() => ( lengthSq() < 0.0001 /* almostZero */ );

  Vector3 clone() => new Vector3( x, y, z );

  toString() => "($x, $y, $z)";
}
