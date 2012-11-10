part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author philogb / http://blog.thejit.org/
 * @author egraether / http://egraether.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Vector2 implements IVector2 {
  num x;
  num y;

  Vector2( [this.x = 0, this.y = 0] );

  Vector2 setValues( num x, num y ) {
    this.x = x;
    this.y = y;

    return this;
  }

  Vector2 copy( Vector2 v ) {
    x = v.x;
    y = v.y;

    return this;
  }


  Vector2 add( Vector2 v1, Vector2 v2 ) {
    x = v1.x + v2.x;
    y = v1.y + v2.y;

    return this;
  }

  Vector2 addSelf( Vector2 v ) {
    x += v.x;
    y += v.y;

    return this;
  }

  Vector2 sub( Vector2 v1, Vector2 v2 ) {
    x = v1.x - v2.x;
    y = v1.y - v2.y;

    return this;
  }

  Vector2 subSelf( Vector2 v ) {
    x -= v.x;
    y -= v.y;

    return this;
  }

  Vector2 multiplyScalar( num s ) {
    x *= s;
    y *= s;

    return this;
  }

  Vector2 divideScalar ( num s ) {
    if ( s != null ) {
      x /= s;
      y /= s;
    } else {
      setValues( 0, 0 );
    }
    return this;
  }

  Vector2 negate() => multiplyScalar( -1 );

  num dot( Vector2 v ) => x * v.x + y * v.y;

  num lengthSq() => x * x + y * y;

  num length() => Math.sqrt( lengthSq() );

  normalize() => divideScalar( length() );

  num distanceTo( Vector2 v ) => Math.sqrt( distanceToSquared( v ) );

  num distanceToSquared( Vector2 v ) {
    num dx = x - v.x, dy = y - v.y;
    return dx * dx + dy * dy;
  }

  Vector2 setLength( num l ) => normalize().multiplyScalar( l );

  lerpSelf( Vector2 v, num alpha ) {

    x += ( v.x - x ) * alpha;
    y += ( v.y - y ) * alpha;

    return this;

  }

  bool equals( Vector2 v ) => ( ( v.x == x ) && ( v.y == y ) );

  bool isZero() => ( lengthSq() < 0.0001 /* almostZero */ );

  Vector2 clone() => new Vector2( x, y );

}
