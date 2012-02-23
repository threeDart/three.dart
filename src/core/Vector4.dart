/**
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author philogb / http://blog.thejit.org/
 * @author mikael emtinger / http://gomo.se/
 * @author egraether / http://egraether.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Vector4 implements IVector4
{
  num _x;
  num _y;
  num _z;
  num _w;
  
  num get x() {  return _x;  }
  set x( num value ) {  _x = value;  }
  num get y() {  return _y;  }
  set y( num value ) {  _y = value;  }
  num get z() {  return _z;  }
  set z( num value ) {  _z = value;  }
  num get w() {  return _w;  }
  set w( num value ) {  _w = value;  }
  
  Vector4( [num this._x = 0, num this._y = 0, num this._z = 0, num this._w = 1] ) 
  {
//    _x = ( x !== null ) ? x : 0;
//    _y = ( y !== null ) ? y : 0;
//    _z = ( z !== null ) ? z : 0;
//    _w = ( w !== null ) ? w : 1;
  }

  setValues( num x, num y, num z, num w ) 
  {
    _x = x;
    _y = y;
    _z = z;
    _w = w;

    return this;
  }
  
  //TODO: Interface IVector3 has been introduced here due to line 216 in Projector.dart:
  // _vertex.positionScreen.copy( _vertex.positionWorld );
  // ..where a Vector4 is instructed to copy a Vector3. Obviously this doesn't cause any issues in JS,
  // but as the Vector classes are currently unrelated, causes an issue in Dart.
  // Interfaces have been used to avoid introducing issues with any existing "if (Vector4/3/2)" logic.
  // Inheritance should probably eventually be used instead, and such logic should be checked to cascade (e.g. 4, then 3, then 2).
  copy( IVector3 v ) 
  {
    _x = v.x;
    _y = v.y;
    _z = v.z;
    
    if ( v is IVector4 ) {
     Vector4 v4 = v;
     //_w = ( v4.w !== null ) ? v4.w : 1;
     _w = v4.w;
    } else {
      _w = 1;
    }
  }

  Vector4 clone() 
  {
    return new Vector4( _x, _y, _z, _w );
  }


  Vector4 add( Vector4 v1, Vector4 v2 ) 
  {
    _x = v1.x + v2.x;
    _y = v1.y + v2.y;
    _z = v1.z + v2.z;
    _w = v1.w + v2.w;

    return this;
  }

  Vector4 addSelf(Vector4 v ) 
  {
    _x += v.x;
    _y += v.y;
    _z += v.z;
    _w += v.w;

    return this;
  }

  Vector4 sub( Vector4 v1, Vector4 v2 ) 
  {
    _x = v1.x - v2.x;
    _y = v1.y - v2.y;
    _z = v1.z - v2.z;
    _w = v1.w - v2.w;

    return this;
  }

  Vector4 subSelf( Vector4 v )
  {
    _x -= v.x;
    _y -= v.y;
    _z -= v.z;
    _w -= v.w;

    return this;
  }

  Vector4 multiplyScalar( num s ) 
  {
    _x *= s;
    _y *= s;
    _z *= s;
    _w *= s;

    return this;
  }

  Vector4 divideScalar( num s ) 
  {
    if ( s !== null ) {
      _x /= s;
      _y /= s;
      _z /= s;
      _w /= s;
    } else {
      _x = 0;
      _y = 0;
      _z = 0;
      _w = 1;
    }

    return this;
  }

  Vector4 negate()
  {
    return multiplyScalar( -1 );
  }

  num dot( Vector4 v )
  {
    return _x * v.x + _y * v.y + _z * v.z + _w * v.w;
  }

  num lengthSq()
  {
    return dot( this );
  }

  num length()
  {
    return Math.sqrt( lengthSq() );
  }

  Vector4 normalize()
  {
    return divideScalar( length() );
  }

  Vector4 setLength( l )
  {
    return normalize().multiplyScalar( l );
  }

  Vector4 lerpSelf( Vector4 v, num alpha ) 
  {
    _x += ( v.x - _x ) * alpha;
    _y += ( v.y - _y ) * alpha;
    _z += ( v.z - _z ) * alpha;
    _w += ( v.w - _w ) * alpha;

    return this;

  }
}
