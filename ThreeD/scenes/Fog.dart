/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Fog 
{
  Color _color;
  num _near;
  num _far;
  
  Fog( num hex, num near, num far ) 
  {
    _color = new Color( hex );

    _near = ( near !== null ) ? near : 1;
    _far = ( far !== null ) ? far : 1000;
  }
}
