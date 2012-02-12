/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class DirectionalLight extends Light 
{
  Vector3 _position;
  Object3D _target;
  num _intensity, _distance;
  bool _castShadow, _onlyShadow;
  num _shadowCameraLeft, _shadowCameraRight, _shadowCameraTop, _shadowCameraBottom;
  bool _shadowCameraVisible;
  num _shadowBias, _shadowDarkness, _shadowMapWidth, _shadowMapHeight;
  Texture _shadowMap;
  num _shadowMapSize;
  Camera _shadowCamera;
  Matrix4 _shadowMatrix;
  
  num get intensity() {  return _intensity;  }
  
  DirectionalLight( num hex, num intensity, num distance ) : super( hex )
  {
    //THREE.Light.call( this, hex );

    _position = new Vector3( 0, 1, 0 );
    _target = new Object3D();

    _intensity = ( intensity !== null ) ? intensity : 1;
    _distance = ( distance !== null ) ? distance : 0;

    _castShadow = false;
    _onlyShadow = false;

    _shadowCameraLeft = -500;
    _shadowCameraRight = 500;
    _shadowCameraTop = 500;
    _shadowCameraBottom = -500;

    _shadowCameraVisible = false;

    _shadowBias = 0;
    _shadowDarkness = 0.5;

    _shadowMapWidth = 512;
    _shadowMapHeight = 512;

    _shadowMap = null;
    _shadowMapSize = null;
    _shadowCamera = null;
    _shadowMatrix = null;
  }
}
