part of three;

class ShadowCaster extends Light {
  bool castShadow;
  bool onlyShadow;

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

  var cameraHelper;

  ShadowCaster(num hex) :
    castShadow = false,
    onlyShadow = false,

    //

    shadowCameraNear = 50,
    shadowCameraFar = 5000,
    shadowCameraFov = 50,

    shadowCameraVisible = false,

    shadowBias = 0,
    shadowDarkness = 0.5,

    shadowMapWidth = 512,
    shadowMapHeight = 512,

    //

    shadowMap = null,
    shadowMapSize = null,
    shadowCamera = null,
    shadowMatrix = null,
    super(hex);
}

