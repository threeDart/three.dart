part of three;

class SpotLight extends ShadowCaster {

  Object3D target;

  double intensity, distance;
  double angle;
  num exponent;

  SpotLight( num hex, [this.intensity = 1.0, this.distance = 0.0, this.angle = Math.PI / 2, this.exponent = 10] ) : super( hex ) {
    //THREE.Light.call( this, hex );

    position = new Vector3( 0.0, 1.0, 0.0 );
    target = new Object3D();

    castShadow = false;
    onlyShadow = false;

    //

    shadowCameraNear = 50.0;
    shadowCameraFar = 5000.0;
    shadowCameraFov = 50.0;

    shadowCameraVisible = false;

    shadowBias = 0;
    shadowDarkness = 0.5;

    shadowMapWidth = 512;
    shadowMapHeight = 512;

    //

    shadowMap = null;
    shadowMapSize = null;
    shadowCamera = null;
    shadowMatrix = null;

  }
}