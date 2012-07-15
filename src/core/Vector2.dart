/**
 * @author mr.doob / http://mrdoob.com/
 * @author philogb / http://blog.thejit.org/
 * @author egraether / http://egraether.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Vector2 implements IVector2
{
  num _x;
  num _y;
  
  num get x() {  return _x;  }
  set x(num value) {  _x = value;  }
  
  num get y() {  return _y;  }
  set y(num value) {  _y = value;  }
  
  Vector2( [num x = 0, num y = 0] )
  {
    _x = (x != null) ? x : 0;
    _y = (y != null) ? y : 0;
  }
   
  Vector2 setValues( num x, num y )
  {
    _x = x;
    _y = y;

    return this;
  }

  Vector2 copy( Vector2 v ) 
  {
    _x = v.x;
    _y = v.y;

    return this;
  }

  Vector2 clone()
  {
    return new Vector2( _x, _y );
  }


  Vector2 add( Vector2 v1, Vector2 v2 )
  {
    _x = v1.x + v2.x;
    _y = v1.y + v2.y;

    return this;
  }

  Vector2 addSelf( Vector2 v )
  {
    _x += v.x;
    _y += v.y;

    return this;
  }

  Vector2 sub( Vector2 v1, Vector2 v2 ) 
  {
    _x = v1.x - v2.x;
    _y = v1.y - v2.y;

    return this;
  }

  Vector2 subSelf( Vector2 v )
  {
    _x -= v.x;
    _y -= v.y;

    return this;
  }

  Vector2 multiplyScalar( num s )
  {
    _x *= s;
    _y *= s;

    return this;
  }

  Vector2 divideScalar ( num s )
  {
    if ( s != null ) {
      _x /= s;
      _y /= s;

    } else {
      setValues( 0, 0 );
    }
    return this;
  }

  Vector2 negate() 
  {
    return multiplyScalar( -1 );
  }

  num dot( Vector2 v ) 
  {
    return _x * v.x + _y * v.y;
  }

  num lengthSq() 
  {
    return _x * _x + _y * _y;
  }

  num length()
  {
    return Math.sqrt( this.lengthSq() );
  }

  normalize()
  {
    return divideScalar( length() );
  }

  num distanceTo( Vector2 v )
  {
    return Math.sqrt( distanceToSquared( v ) );
  }

  num distanceToSquared( Vector2 v )
  {
    num dx = _x - v.x, dy = _y - v.y;
    return dx * dx + dy * dy;
  }

  Vector2 setLength( num l )
  {
    return normalize().multiplyScalar( l );
  }

  bool equals( Vector2 v )
  {
    return ( ( v.x === _x ) && ( v.y === _y ) );
  }
}
