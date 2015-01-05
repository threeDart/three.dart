part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 * @author Nelson Silva
 *
 * rev: r56
 */

/// Affects objects using MeshLambertMaterial or MeshPhongMaterial.
class DirectionalLight extends ShadowCaster {

  Vector3 position;
  /// Target used for shadow camera orientation.
  Object3D target;
  /// Light's intensity (default: 1.0)
  num intensity;
  num distance;

  /// Orthographic shadow camera frustum parameter (default: -500)
  num shadowCameraLeft;
  /// Orthographic shadow camera frustum parameter (default: 500)
  num shadowCameraRight;
  /// Orthographic shadow camera frustum parameter (default: 500)
  num shadowCameraTop;
  /// Orthographic shadow camera frustum parameter (default: -500)
  num shadowCameraBottom;

  bool shadowCascade;

  Vector3 shadowCascadeOffset;
  num shadowCascadeCount;

  List<num> shadowCascadeBias,
      shadowCascadeWidth,
      shadowCascadeHeight,
      shadowCascadeNearZ,
      shadowCascadeFarZ,
      shadowCascadeArray;

  /// Creates a light that shines from a specific direction not from a specific position.
  ///
  /// This light will behave as though it is infinitely far away and the rays
  /// produced from it are all parallel.
  /// The best analogy would be a light source that acts like the sun: the sun
  /// is so far away that all sunlight hitting objects comes from the same angle.
  DirectionalLight( num hex, [this.intensity = 1, this.distance = 0]) : super( hex ) {

    position = new Vector3( 0.0, 1.0, 0.0 );
    target = new Object3D();

    shadowCameraLeft = -500;
    shadowCameraRight = 500;
    shadowCameraTop = 500;
    shadowCameraBottom = -500;

    //

    shadowCascade = false;

    shadowCascadeOffset = new Vector3( 0.0, 0.0, -1000.0 );
    shadowCascadeCount = 2;

    shadowCascadeBias = [ 0, 0, 0 ];
    shadowCascadeWidth = [ 512, 512, 512 ];
    shadowCascadeHeight = [ 512, 512, 512 ];

    shadowCascadeNearZ = [ -1.000, 0.990, 0.998 ];
    shadowCascadeFarZ  = [  0.990, 0.998, 1.000 ];

    shadowCascadeArray = [];

  }
}
