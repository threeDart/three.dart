/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Quaternion 
{
  num _x;
  num _y;
  num _z;
  num _w;
  
  get x() {  return _x;  }
  set x( num value ) {  _x = value;  }
  get y() {  return _y;  }
  set y( num value ) {  _y = value;  }
  get z() {  return _z;  }
  set z( num value ) {  _z = value;  }
  get w() {  return _w;  }
  set w( num value ) {  _w = value;  }
  
  Quaternion( [num x, num y, num z, num w] ) 
  {
    setValues(
      ( x !== null ) ? x : 0,
      ( y !== null ) ? y : 0,
      ( z !== null ) ? z : 0,
      ( w !== null ) ? w : 1,
    );
  }

  Quaternion setValues( x, y, z, w ) 
  {
    _x = x;
    _y = y;
    _z = z;
    _w = w;

    return this;
  }

  Quaternion copy( Vector4 q ) 
  {
    _x = q.x;
    _y = q.y;
    _z = q.z;
    _w = q.w;

    return this;
  }

  Quaternion setFromEuler( Vector3 vec3 ) 
  {
    num c = Math.PI / 360, // 0.5 * Math.PI / 360, // 0.5 is an optimization
    x = vec3.x * c,
    y = vec3.y * c,
    z = vec3.z * c,

    c1 = Math.cos( y  ),
    s1 = Math.sin( y  ),
    c2 = Math.cos( -z ),
    s2 = Math.sin( -z ),
    c3 = Math.cos( x  ),
    s3 = Math.sin( x  ),

    c1c2 = c1 * c2,
    s1s2 = s1 * s2;

    _w = c1c2 * c3  - s1s2 * s3;
    _x = c1c2 * s3  + s1s2 * c3;
    _y = s1 * c2 * c3 + c1 * s2 * s3;
    _z = c1 * s2 * c3 - s1 * c2 * s3;

    return this;
  }

  Quaternion setFromAxisAngle( Vector3 axis, num angle ) 
  {
    // from http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToQuaternion/index.htm
    // axis have to be normalized

    num halfAngle = angle / 2,
      s = Math.sin( halfAngle );

    _x = axis.x * s;
    _y = axis.y * s;
    _z = axis.z * s;
    _w = Math.cos( halfAngle );

    return this;
  }

  Quaternion setFromRotationMatrix( Matrix4 m ) 
  {
    num absQ = Math.pow(m.determinant(), 1.0 / 3.0);
    _w = Math.sqrt( Math.max( 0, absQ + m.n11 + m.n22 + m.n33 ) ) / 2;
    _x = Math.sqrt( Math.max( 0, absQ + m.n11 - m.n22 - m.n33 ) ) / 2;
    _y = Math.sqrt( Math.max( 0, absQ - m.n11 + m.n22 - m.n33 ) ) / 2;
    _z = Math.sqrt( Math.max( 0, absQ - m.n11 - m.n22 + m.n33 ) ) / 2;
    _x = copySign( _x, ( m.n32 - m.n23 ) );
    _y = copySign( _y, ( m.n13 - m.n31 ) );
    _z = copySign( _z, ( m.n21 - m.n12 ) );
    normalize();
    return this;
  }
  
  // Adapted from: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
  copySign(num a, num b) {
    return b < 0 ? -a.abs() : a.abs();
  }

  Quaternion calculateW() 
  {
    _w = - Math.sqrt( ( 1.0 - _x * _x - _y * _y - _z * _z ).abs() );

    return this;
  }

  Quaternion inverse() 
  {
    _x *= -1;
    _y *= -1;
    _z *= -1;

    return this;
  }

  double length() 
  {
    return Math.sqrt( _x * _x + _y * _y + _z * _z + _w * _w );
  }

  Quaternion normalize()
  {
    num l = Math.sqrt( _x * _x + _y * _y + _z * _z + _w * _w );

    if ( l === 0 ) {
      _x = 0;
      _y = 0;
      _z = 0;
      _w = 0;
    } else {
      l = 1 / l;

      _x = _x * l;
      _y = _y * l;
      _z = _z * l;
      _w = _w * l;
    }

    return this;
  }

  Quaternion multiplySelf( Vector4 quat2 ) 
  {
    num qax = _x,  qay = _y,  qaz = _z,  qaw = _w,
    qbx = quat2.x, qby = quat2.y, qbz = quat2.z, qbw = quat2.w;

    _x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
    _y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
    _z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
    _w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

    return this;
  }

  Quaternion multiply( Vector4 q1, Vector4 q2 ) 
  {
    // from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm

    _x =  q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x;
    _y = -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y;
    _z =  q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z;
    _w = -q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w;

    return this;
  }

  Vector3 multiplyVector3( Vector3 vec, Vector3 dest ) 
  {
    if( dest != null ) { dest = vec; }

    num x    = vec.x,  y  = vec.y,  z  = vec.z,
      qx   = _x, qy = _y, qz = _z, qw = _w;

    // calculate quat * vec

    num ix =  qw * x + qy * z - qz * y,
      iy =  qw * y + qz * x - qx * z,
      iz =  qw * z + qx * y - qy * x,
      iw = -qx * x - qy * y - qz * z;

    // calculate result * inverse quat

    dest.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
    dest.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
    dest.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;

    return dest;
  }

  static Vector4 slerp( Vector4 qa, Vector4 qb, Vector4 qm, num t ) 
  {
    // http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/

    num cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    if (cosHalfTheta < 0) {
      qm.w = -qb.w; qm.x = -qb.x; qm.y = -qb.y; qm.z = -qb.z;
      cosHalfTheta = -cosHalfTheta;
    } else {
      qm.copy(qb);
    }
    
    if ( cosHalfTheta.abs() >= 1.0 ) 
    {
      qm.w = qa.w; qm.x = qa.x; qm.y = qa.y; qm.z = qa.z;
      return qm;
    }

    num halfTheta = Math.acos( cosHalfTheta ),
    sinHalfTheta = Math.sqrt( 1.0 - cosHalfTheta * cosHalfTheta );
 
    if ( sinHalfTheta.abs() < 0.001 ) 
    {
      qm.w = 0.5 * ( qa.w + qb.w );
      qm.x = 0.5 * ( qa.x + qb.x );
      qm.y = 0.5 * ( qa.y + qb.y );
      qm.z = 0.5 * ( qa.z + qb.z );

      return qm;
    }

    num ratioA = Math.sin( ( 1 - t ) * halfTheta ) / sinHalfTheta,
    ratioB = Math.sin( t * halfTheta ) / sinHalfTheta;

    qm.w = ( qa.w * ratioA + qm.w * ratioB );
    qm.x = ( qa.x * ratioA + qm.x * ratioB );
    qm.y = ( qa.y * ratioA + qm.y * ratioB );
    qm.z = ( qa.z * ratioA + qm.z * ratioB );

    return qm;
  }
}
