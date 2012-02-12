/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class PointLight extends Light
{
  Vector3 _position;
  num _intensity, _distance;
  
  num get intensity() {  return _intensity;  }
  num get distance() {  return _distance;  }
  
  PointLight( num hex, num intensity, num distance ) : super( hex )
  {
    //THREE.Light.call( this, hex );

    _position = new Vector3( 0, 0, 0 );
    _intensity = ( intensity !== null ) ? intensity : 1;
    _distance = ( distance !== null ) ? distance : 0;
  }
}
