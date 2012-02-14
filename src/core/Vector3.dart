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

class Vector3 implements IVector3
{
  num _x;
  num _y;
  num _z;
  
  num get x() {  return _x;  }
  num get y() {  return _y;  }
  num get z() {  return _z;  }
  
  set x(num value) {  _x = value;  }
  set y(num value) {  _y = value;  }
  set z(num value) {  _z = value;  }
  
  Vector3( [num this._x=0, num this._y=0, num this._z=0] )
  {
    //_x = x != null ? _x = x : _x = 0;
    //_y = y != null ? _y = y : _y = 0;
    //_z = z != null ? _z = z : _z = 0;
  }
  
  // changed "set" to "setValues" as "set" is reserved.
  Vector3 setValues( num x, num y, num z ) 
  {
    _x = x;
    _y = y;
    _z = z;

    return this;
  }
  
  Vector3 setX( num x ) 
  {
    _x = x;

    return this;
  }
  
  Vector3 setY( num y ) 
  {
    _y = y;

    return this;
  }

  Vector3 setZ( num z )
  {
    _z = z;

    return this;
  }
  
  Vector3 copy( Vector3 v ) 
  {
    _x = v.x;
    _y = v.y;
    _z = v.z;

    return this;
  }

  Vector3 clone() 
  {
    return new Vector3( _x, _y, _z );
  }
  
  Vector3 add( Vector3 v1, Vector3 v2 ) 
  {
    _x = v1.x + v2.x;
    _y = v1.y + v2.y;
    _z = v1.z + v2.z;

    return this;
  }

  Vector3 addSelf( Vector3 v ) 
  {
    _x += v.x;
    _y += v.y;
    _z += v.z;

    return this;
  }

  Vector3 addScalar( num s ) 
  {
    _x += s;
    _y += s;
    _z += s;

    return this;
  }
  
  Vector3 sub( Vector3 v1, Vector3 v2 )
  {
    _x = v1.x - v2.x;
    _y = v1.y - v2.y;
    _z = v1.z - v2.z;

    return this;
  }

  Vector3 subSelf( Vector3 v )
  {
    _x -= v.x;
    _y -= v.y;
    _z -= v.z;

    return this;
  }

  Vector3 multiply( Vector3 a, Vector3 b ) 
  {
    _x = a.x * b.x;
    _y = a.y * b.y;
    _z = a.z * b.z;

    return this;
  }

  Vector3 multiplySelf( Vector3 v )
  {
    _x *= v.x;
    _y *= v.y;
    _z *= v.z;

    return this;
  }
  
  Vector3 multiplyScalar( num s ) 
  {
    _x *= s;
    _y *= s;
    _z *= s;

    return this;
  }

  Vector3 divideSelf( Vector3 v ) 
  {
    _x /= v.x;
    _y /= v.y;
    _z /= v.z;

    return this;
  }

  Vector3 divideScalar( num s ) 
  {
    if ( s !== null ) 
    {
      _x /= s;
      _y /= s;
      _z /= s;

    } else {
      _x = 0;
      _y = 0;
      _z = 0;
    }

    return this;
  }

  Vector3 negate() 
  {
    return multiplyScalar( -1 );
  }

  num dot( Vector3 v ) 
  {
    return _x * v.x + _y * v.y + _z * v.z;
  }

  num lengthSq() 
  {
    return _x * _x + _y * _y + _z * _z;
  }

  num length() 
  {
    return Math.sqrt( lengthSq() );
  }
  
  num lengthManhattan() 
  {
    // correct version
    // return Math.abs( this.x ) + Math.abs( this.y ) + Math.abs( this.z );
    
    return _x + _y + _z;
  }

  Vector3 normalize() 
  {
    return divideScalar( length() );
  }

  Vector3 setLength( l ) 
  {
    return normalize().multiplyScalar( l );
  }


  Vector3 cross( Vector3 a, Vector3 b )
  {
    _x = a.y * b.z - a.z * b.y;
    _y = a.z * b.x - a.x * b.z;
    _z = a.x * b.y - a.y * b.x;

    return this;
  }

  Vector3 crossSelf( Vector3 v ) 
  {
    num x2 = _x, y2 = _y, z2 = _z;

    _x = y2 * v.z - z2 * v.y;
    _y = z2 * v.x - x2 * v.z;
    _z = x2 * v.y - y2 * v.x;

    return this;
  }

  num distanceTo( Vector3 v ) 
  {
    return Math.sqrt( distanceToSquared( v ) );
  }

  num distanceToSquared( Vector3 v ) 
  {
    return new Vector3().sub( this, v ).lengthSq();
  }

  // uses Matrix class
  void setPositionFromMatrix( m )
  {
    _x = m.n14;
    _y = m.n24;
    _z = m.n34;
  }

  void setRotationFromMatrix( m ) 
  {
    num cosY = Math.cos( _y );

    _y = Math.asin( m.n13 );

    if ( cosY.abs() > 0.00001 ) 
    {
      _x = Math.atan2( - m.n23 / cosY, m.n33 / cosY );
      _z = Math.atan2( - m.n12 / cosY, m.n11 / cosY );

    } else {
      _x = 0;
      _z = Math.atan2( m.n21, m.n22 );
    }
  }

  bool isZero()
  {
    return ( lengthSq() < 0.0001 /* almostZero */ );
  }  
}
