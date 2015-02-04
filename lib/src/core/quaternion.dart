part of three;

/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// Implementation of a [quaternion](http://en.wikipedia.org/wiki/Quaternion).
///
/// This is used for rotating things without encountering the dreaded
/// [gimbal lock](http://en.wikipedia.org/wiki/Gimbal_lock) issue, amongst other advantages.
class Quaternion implements IVector4 {
  /// x coordinate
  num x;
  /// y coordinate
  num y;
  /// z coordinate
  num z;
  /// w coordinate
  num w;

  Quaternion([num this.x = 0.0, num this.y = 0.0, num this.z = 0.0, num this.w = 1.0]);

  /// Sets values of this quaternion.
  Quaternion setValues(num newX, num newY, num newZ, num newW) {
    this.x = newX;
    this.y = newY;
    this.z = newZ;
    this.w = newW;

    return this;
  }

  /// Copies values of q to this quaternion.
  Quaternion copy(IVector4 q) {
    this.x = q.x;
    this.y = q.y;
    this.z = q.z;
    this.w = q.w;

    return this;
  }

  /// Sets this quaternion from rotation specified by Euler angle.
  Quaternion setFromEuler(Vector3 v, [String order = 'XYZ']) {
    // http://www.mathworks.com/matlabcentral/fileexchange/
    //  20696-function-to-convert-between-dcm-euler-angles-quaternions-and-euler-vectors/
    //  content/SpinCalc.m

    var c1 = Math.cos(v.x / 2.0);
    var c2 = Math.cos(v.y / 2.0);
    var c3 = Math.cos(v.z / 2.0);
    var s1 = Math.sin(v.x / 2.0);
    var s2 = Math.sin(v.y / 2.0);
    var s3 = Math.sin(v.z / 2.0);

    if (order == 'XYZ') {

      this.x = s1 * c2 * c3 + c1 * s2 * s3;
      this.y = c1 * s2 * c3 - s1 * c2 * s3;
      this.z = c1 * c2 * s3 + s1 * s2 * c3;
      this.w = c1 * c2 * c3 - s1 * s2 * s3;

    } else if (order == 'YXZ') {

      this.x = s1 * c2 * c3 + c1 * s2 * s3;
      this.y = c1 * s2 * c3 - s1 * c2 * s3;
      this.z = c1 * c2 * s3 - s1 * s2 * c3;
      this.w = c1 * c2 * c3 + s1 * s2 * s3;

    } else if (order == 'ZXY') {

      this.x = s1 * c2 * c3 - c1 * s2 * s3;
      this.y = c1 * s2 * c3 + s1 * c2 * s3;
      this.z = c1 * c2 * s3 + s1 * s2 * c3;
      this.w = c1 * c2 * c3 - s1 * s2 * s3;

    } else if (order == 'ZYX') {

      this.x = s1 * c2 * c3 - c1 * s2 * s3;
      this.y = c1 * s2 * c3 + s1 * c2 * s3;
      this.z = c1 * c2 * s3 - s1 * s2 * c3;
      this.w = c1 * c2 * c3 + s1 * s2 * s3;

    } else if (order == 'YZX') {

      this.x = s1 * c2 * c3 + c1 * s2 * s3;
      this.y = c1 * s2 * c3 + s1 * c2 * s3;
      this.z = c1 * c2 * s3 - s1 * s2 * c3;
      this.w = c1 * c2 * c3 - s1 * s2 * s3;

    } else if (order == 'XZY') {

      this.x = s1 * c2 * c3 - c1 * s2 * s3;
      this.y = c1 * s2 * c3 - s1 * c2 * s3;
      this.z = c1 * c2 * s3 + s1 * s2 * c3;
      this.w = c1 * c2 * c3 + s1 * s2 * s3;

    }

    return this;

  }

  /// Sets this quaternion from rotation specified by axis and angle.
  ///
  /// Adapted from http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToQuaternion/index.htm.
  /// Axis is asumed to be normalized, angle is in radians.
  Quaternion setFromAxisAngle(Vector3 axis, num angle) {
    num halfAngle = angle / 2.0;
    num s = Math.sin(halfAngle);

    this.x = axis.x * s;
    this.y = axis.y * s;
    this.z = axis.z * s;
    this.w = Math.cos(halfAngle);

    return this;
  }

  /// Sets this quaternion from rotation component of m.
  ///
  /// Adapted from http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm.
  Quaternion setFromRotationMatrix(Matrix4 m) {

    // http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm

    // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

    var te = m.elements,

        m11 = te[0],
        m12 = te[4],
        m13 = te[8],
        m21 = te[1],
        m22 = te[5],
        m23 = te[9],
        m31 = te[2],
        m32 = te[6],
        m33 = te[10],

        trace = m11 + m22 + m33,
        s;

    if (trace > 0) {

      s = 0.5 / Math.sqrt(trace + 1.0);

      this.w = 0.25 / s;
      this.x = (m32 - m23) * s;
      this.y = (m13 - m31) * s;
      this.z = (m21 - m12) * s;

    } else if (m11 > m22 && m11 > m33) {

      s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);

      this.w = (m32 - m23) / s;
      this.x = 0.25 * s;
      this.y = (m12 + m21) / s;
      this.z = (m13 + m31) / s;

    } else if (m22 > m33) {

      s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);

      this.w = (m13 - m31) / s;
      this.x = (m12 + m21) / s;
      this.y = 0.25 * s;
      this.z = (m23 + m32) / s;

    } else {

      s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);

      this.w = (m21 - m12) / s;
      this.x = (m13 + m31) / s;
      this.y = (m23 + m32) / s;
      this.z = 0.25 * s;

    }

    return this;
  }


  Quaternion calculateW() {
    this.w = -Math.sqrt((1.0 - x * x - y * y - z * z).abs());
    return this;
  }

  Quaternion inverse() {
    this.x *= -1;
    this.y *= -1;
    this.z *= -1;

    return this;
  }

  /// Computes length of this quaternion.
  double length() => Math.sqrt(x * x + y * y + z * z + w * w);

  /// Normalizes this quaternion.
  Quaternion normalize() {
    num l = Math.sqrt(x * x + y * y + z * z + w * w);

    if (l == 0) {
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

  /// Sets this quaternion to a x b
  ///
  /// Adapted from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm.
  Quaternion multiply(IVector4 q1, IVector4 q2) {
    // from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/code/index.htm

    this.x = q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x;
    this.y = -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y;
    this.z = q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z;
    this.w = -q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w;

    return this;
  }

  /// Multiplies this quaternion by b.
  Quaternion multiplySelf(IVector4 quat2) {
    num qax = x,
        qay = y,
        qaz = z,
        qaw = w,
        qbx = quat2.x,
        qby = quat2.y,
        qbz = quat2.z,
        qbw = quat2.w;

    this.x = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
    this.y = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
    this.z = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
    this.w = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

    return this;
  }

  /// Rotates vector by this quaternion into dest.
  /// If dest is not specified, result goes to vec.
  Vector3 multiplyVector3(Vector3 vec, {Vector3 dest: null}) {
    if (dest == null) {
      dest = vec;
    }

    num _x = vec.x,
        _y = vec.y,
        _z = vec.z,
        qx = x,
        qy = y,
        qz = z,
        qw = w;

    // calculate quat * vec

    num ix = qw * _x + qy * _z - qz * _y,
        iy = qw * _y + qz * _x - qx * _z,
        iz = qw * _z + qx * _y - qy * _x,
        iw = -qx * _x - qy * _y - qz * _z;

    // calculate result * inverse quat

    dest.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
    dest.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
    dest.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;

    return dest;
  }

  //https://bitbucket.org/sinbad/ogre/src/9db75e3ba05c/OgreMain/include/OgreVector3.h#cl-651
  Quaternion rotationBetween(IVector3 v1, IVector3 v2) {
    v1 = v1.clone().normalize();
    v2 = v2.clone().normalize();
    num dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;

    if (dot >= 1.0) {
      setValues(1, 0, 0, 0); //Identity;
      return this;
    }

    if (dot < (1e-10 - 1.0)) {
      Vector3 axis = new Vector3(1, 0, 0).crossSelf(v1);

      if (axis.isZero()) {
        axis.setValues(0, 1, 0);
        axis.crossSelf(v1);
      }
      axis.normalize();

      setFromAxisAngle(axis, Math.PI);
    } else {

      num s = Math.sqrt((1 + dot) * 2);
      num invs = 1 / s;
      Vector3 c = v1.clone().crossSelf(v2);

      x = c.x * invs;
      y = c.y * invs;
      z = c.z * invs;
      w = s * 0.5;

      normalize();
    }

    return this;
  }

  /// Handles the spherical linear interpolation between this quaternion's
  /// configuration and that of qb.
  ///
  /// t represents how close to the current (0) or target (1) rotation the result should be.
  Quaternion slerpSelf(Vector4 qb, num t) {

    // http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/

    var cosHalfTheta = w * qb.w + x * qb.x + y * qb.y + z * qb.z;

    if (cosHalfTheta < 0) {

      this.w = -qb.w;
      this.x = -qb.x;
      this.y = -qb.y;
      this.z = -qb.z;

      cosHalfTheta = -cosHalfTheta;

    } else {

      this.copy(qb);

    }

    if (cosHalfTheta >= 1.0) {

      this.w = w;
      this.x = x;
      this.y = y;
      this.z = z;

      return this;

    }

    var halfTheta = Math.acos(cosHalfTheta);
    var sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

    if (sinHalfTheta.abs() < 0.001) {

      this.w = 0.5 * (w + this.w);
      this.x = 0.5 * (x + this.x);
      this.y = 0.5 * (y + this.y);
      this.z = 0.5 * (z + this.z);

      return this;

    }

    var ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta,
        ratioB = Math.sin(t * halfTheta) / sinHalfTheta;

    this.w = (w * ratioA + this.w * ratioB);
    this.x = (x * ratioA + this.x * ratioB);
    this.y = (y * ratioA + this.y * ratioB);
    this.z = (z * ratioA + this.z * ratioB);

    return this;

  }

  /// Clones this quaternion.
  clone() => new Quaternion(this.x, this.y, this.z, this.w);

  /// Adapted from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/.
  static IVector4 slerp(IVector4 qa, IVector4 qb, IVector4 qm, num t) {
    // http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/

    num cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    if (cosHalfTheta < 0) {
      qm.w = -qb.w;
      qm.x = -qb.x;
      qm.y = -qb.y;
      qm.z = -qb.z;
      cosHalfTheta = -cosHalfTheta;
    } else {
      qm.copy(qb);
    }

    if (cosHalfTheta.abs() >= 1.0) {
      qm.w = qa.w;
      qm.x = qa.x;
      qm.y = qa.y;
      qm.z = qa.z;
      return qm;
    }

    num halfTheta = Math.acos(cosHalfTheta),
        sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

    if (sinHalfTheta.abs() < 0.001) {
      qm.w = 0.5 * (qa.w + qb.w);
      qm.x = 0.5 * (qa.x + qb.x);
      qm.y = 0.5 * (qa.y + qb.y);
      qm.z = 0.5 * (qa.z + qb.z);

      return qm;
    }

    num ratioA = Math.sin((1 - t) * halfTheta) / sinHalfTheta,
        ratioB = Math.sin(t * halfTheta) / sinHalfTheta;

    qm.w = (qa.w * ratioA + qm.w * ratioB);
    qm.x = (qa.x * ratioA + qm.x * ratioB);
    qm.y = (qa.y * ratioA + qm.y * ratioB);
    qm.z = (qa.z * ratioA + qm.z * ratioB);

    return qm;
  }
}
