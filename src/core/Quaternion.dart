/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Quaternion 
{
  num x;
  num y;
  num z;
  num w;
  
//  get x() {  return _x;  }
//  set x( num value ) {  _x = value;  }
//  get y() {  return _y;  }
//  set y( num value ) {  _y = value;  }
//  get z() {  return _z;  }
//  set z( num value ) {  _z = value;  }
//  get w() {  return _w;  }
//  set w( num value ) {  _w = value;  }
  
  Quaternion( [num this.x=0, num this.y=0, num this.z=0, num this.w=1] ) 
  {
    
  }

  Quaternion setValues( num newX, num newY, num newZ, num newW ) 
  {
    this.x = newX;
    this.y = newY;
    this.z = newZ;
    this.w = newW;

    return this;
  }

  Quaternion copy( Vector4 q ) 
  {
    this.x = q.x;
    this.y = q.y;
    this.z = q.z;
    this.w = q.w;

    return this;
  }

  Quaternion setFromEuler( Vector3 vec3 ) 
  {
    num c = Math.PI / 360, // 0.5 * Math.PI / 360, // 0.5 is an optimization
    _x = vec3.x * c,
    _y = vec3.y * c,
    _z = vec3.z * c,

    c1 = Math.cos( _y  ),
    s1 = Math.sin( _y  ),
    c2 = Math.cos( -_z ),
    s2 = Math.sin( -_z ),
    c3 = Math.cos( _x  ),
    s3 = Math.sin( _x  ),

    c1c2 = c1 * c2,
    s1s2 = s1 * s2;

    this.w = c1c2 * c3  - s1s2 * s3;
    this.x = c1c2 * s3  + s1s2 * c3;
    this.y = s1 * c2 * c3 + c1 * s2 * s3;
    this.z = c1 * s2 * c3 - s1 * c2 * s3;

    return this;
  }

  Quaternion setFromAxisAngle( Vector3 axis, num angle ) 
  {
    // from http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToQuaternion/index.htm
    // axis have to be normalized

    num halfAngle = angle / 2,
      s = Math.sin( halfAngle );

    this.x = axis.x * s;
    this.y = axis.y * s;
    this.z = axis.z * s;
    this.w = Math.cos( halfAngle );

    return this;
  }

  Quaternion setFromRotationMatrix( Matrix4 m ) 
  {
    num absQ = Math.pow(m.determinant(), 1.0 / 3.0);
    this.w = Math.sqrt( Math.max( 0, absQ + m.n11 + m.n22 + m.n33 ) ) / 2;
    this.x = Math.sqrt( Math.max( 0, absQ + m.n11 - m.n22 - m.n33 ) ) / 2;
    this.y = Math.sqrt( Math.max( 0, absQ - m.n11 + m.n22 - m.n33 ) ) / 2;
    this.z = Math.sqrt( Math.max( 0, absQ - m.n11 - m.n22 + m.n33 ) ) / 2;
    this.x = copySign( x, ( m.n32 - m.n23 ) );
    this.y = copySign( y, ( m.n13 - m.n31 ) );
    this.z = copySign( z, ( m.n21 - m.n12 ) );
    normalize();
    return this;
  }
  
  // Adapted from: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
  copySign(num a, num b) {
    return b < 0 ? -a.abs() : a.abs();
  }

  Quaternion calculateW() 
  {
    this.w = - Math.sqrt( ( 1.0 - x * x - y * y - z * z ).abs() );

    return this;
  }

  Quaternion inverse() 
  {
    this.x *= -1;
    this.y *= -1;
    this.z *= -1;

    return this;
  }

  double length() 
  {
    return Math.sqrt( x * x + y * y + z * z + w * w );
  }

  Quaternion normalize()
  {
    num l = Math.sqrt( x * x + y * y + z * z + w * w );

    if ( l === 0 ) {
      this.x = 0;
      this.y = 0;
      this.z = 0;
      this.w = 0;
    } else {
      l = 1 / l;

      this.x = x * l;
      this.y = y * l;
      this.z = z * l;
      this.w = w * l;
    }

    return this;
  }

  Quaternion multiplySelf( Vector4 quat2 ) 
  {
    num qax = x,  qay = y,  qaz = z,  qaw = w,
    qbx = quat2.x, qby = quat2.y, qbz = quat2.z, qbw = quat2.w;

    this.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
    this.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
    this.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
    this.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

    return this;
  }

  Quaternion multiply( Vector4 q1, Vector4 q2 ) 
  {
    // from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm

    this.x =  q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x;
    this.y = -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y;
    this.z =  q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z;
    this.w = -q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w;

    return this;
  }

  Vector3 multiplyVector3( Vector3 vec, Vector3 dest ) 
  {
    if( dest != null ) { dest = vec; }

    num _x    = vec.x,  _y  = vec.y,  _z  = vec.z,
      qx   = x, qy = y, qz = z, qw = w;

    // calculate quat * vec

    num ix =  qw * _x + qy * _z - qz * _y,
      iy =  qw * _y + qz * _x - qx * _z,
      iz =  qw * _z + qx * _y - qy * _x,
      iw = -qx * _x - qy * _y - qz * _z;

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
