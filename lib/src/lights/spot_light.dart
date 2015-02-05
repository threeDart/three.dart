part of three;

/// A point light that can cast shadow in one direction.
///
/// Affects objects using MeshLambertMaterial or MeshPhongMaterial.
class SpotLight extends ShadowCaster {
  /// Spotlight focus points at target.position.
  Object3D target;

  /// Light's intensity.
  double intensity;
  /// If non-zero, light will attenuate linearly from maximum intensity at
  /// light position down to zero at distance.
  double distance;
  /// Maximum extent of the spotlight, in radians, from its direction.
  /// Should be no more than Math.PI/2.
  double angle;
  /// Rapidity of the falloff of light from its target direction.
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