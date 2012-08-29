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
  Object3D target;
  num intensity, distance;
  bool _castShadow, onlyShadow;
  num _shadowCameraLeft, _shadowCameraRight, _shadowCameraTop, _shadowCameraBottom;
  bool _shadowCameraVisible;
  num _shadowBias, _shadowDarkness, _shadowMapWidth, _shadowMapHeight;
  Texture _shadowMap;
  num _shadowMapSize;
  Camera _shadowCamera;
  Matrix4 _shadowMatrix;
  
  DirectionalLight( num hex, [this.intensity = 1, this.distance = 0]) : super( hex )
  {
    //THREE.Light.call( this, hex );

    _position = new Vector3( 0, 1, 0 );
    target = new Object3D();

    _castShadow = false;
    onlyShadow = false;

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
