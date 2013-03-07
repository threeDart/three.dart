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

class DirectionalLight extends ShadowCaster {
  Vector3 position;
  Object3D target;
  num intensity, distance;

  num shadowCameraLeft, shadowCameraRight, shadowCameraTop, shadowCameraBottom;

  bool shadowCascade;

  Vector3 shadowCascadeOffset;
  num shadowCascadeCount;

  List shadowCascadeBias,
      shadowCascadeWidth,
      shadowCascadeHeight,
      shadowCascadeNearZ,
      shadowCascadeFarZ,
      shadowCascadeArray;

  DirectionalLight( num hex, [this.intensity = 1, this.distance = 0]) : super( hex ) {

    position = new Vector3( 0, 1, 0 );
    target = new Object3D();

    shadowCameraLeft = -500;
    shadowCameraRight = 500;
    shadowCameraTop = 500;
    shadowCameraBottom = -500;

    //

    shadowCascade = false;

    shadowCascadeOffset = new Vector3( 0, 0, -1000 );
    shadowCascadeCount = 2;

    shadowCascadeBias = [ 0, 0, 0 ];
    shadowCascadeWidth = [ 512, 512, 512 ];
    shadowCascadeHeight = [ 512, 512, 512 ];

    shadowCascadeNearZ = [ -1.000, 0.990, 0.998 ];
    shadowCascadeFarZ  = [  0.990, 0.998, 1.000 ];

    shadowCascadeArray = [];

  }
}
