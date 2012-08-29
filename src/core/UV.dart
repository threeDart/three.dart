/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class UV 
{
  num _u, _v;
  
  num get u() {  return _u;  }
  num get v() {  return _v;  }
  
  UV( [num u, num v] )
  {
    _u = ( u != null ) ? u : 0;
    _v = ( v != null ) ? v : 0;

  }

  UV setValues( num u, num v )
  {
    _u = u;
    _v = v;

    return this;
  }

  UV copy( UV uv ) 
  {
    _u = uv.u;
    _v = uv.v;

    return this;
  }

  UV clone() 
  {
    return new UV( _u, _v );
  }
}
