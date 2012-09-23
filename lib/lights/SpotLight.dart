class SpotLight extends Light {

  Object3D target;

  num intensity, distance;
  num angle;
  num exponent;
  
  bool onlyShadow;

  //

  num shadowCameraNear,
      shadowCameraFar,
      shadowCameraFov;

  bool shadowCameraVisible;

  num shadowBias;
  num shadowDarkness;

  num shadowMapWidth,
      shadowMapHeight;

  //
  var shadowMap;
  var shadowMapSize;
  var shadowCamera;
  var shadowMatrix;

  SpotLight( num hex, [this.intensity = 1, this.distance = 0, this.angle = Math.PI / 2, this.exponent = 10] ) : super( hex ) {
    //THREE.Light.call( this, hex );

    position = new Vector3( 0, 1, 0 );
    target = new Object3D();

    castShadow = false;
    onlyShadow = false;

    //

    shadowCameraNear = 50;
    shadowCameraFar = 5000;
    shadowCameraFov = 50;

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