part of three;

class ShadowCaster extends Light {
  /// If set to true light will cast dynamic shadows.
  ///
  /// Warning: This is expensive and requires tweaking to get shadows looking right.
  bool castShadow;
  /// If set to true light will only cast shadow but not contribute any
  /// lighting (as if intensity was 0 but cheaper to compute).
  bool onlyShadow;

  /// Perspective shadow camera frustum near parameter.
  num shadowCameraNear;
  /// Perspective shadow camera frustum far parameter.
  num shadowCameraFar;
  /// Perspective shadow camera frustum field of view parameter.
  num shadowCameraFov;

  /// Show debug shadow camera frustum.
  bool shadowCameraVisible;

  /// Shadow map bias.
  num shadowBias;
  /// Darkness of shadow casted by this light (from 0 to 1).
  num shadowDarkness;

  /// Shadow map texture width in pixels.
  num shadowMapWidth;
  /// Shadow map texture height in pixels.
  num shadowMapHeight;

  var shadowMap;
  var shadowMapSize;
  var shadowCamera;
  var shadowMatrix;

  var cameraHelper;

  ShadowCaster(num hex) :
    castShadow = false,
    onlyShadow = false,

    shadowCameraNear = 50.0,
    shadowCameraFar = 5000.0,
    shadowCameraFov = 50.0,

    shadowCameraVisible = false,

    shadowBias = 0.0,
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

