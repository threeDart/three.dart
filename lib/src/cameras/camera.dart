part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Camera extends Object3D {
  Matrix4 matrixWorldInverse;
  Matrix4 projectionMatrix;
  Matrix4 projectionMatrixInverse;

  double near;
  double far;

  Camera(this.near, this.far)
    : matrixWorldInverse = new Matrix4.identity(),
      projectionMatrix = new Matrix4.identity(),
      projectionMatrixInverse = new Matrix4.identity(),
      super();

  void lookAt(Vector3 vector ) {
    // TODO: Add hierarchy support.

    makeLookAt(matrix, position, vector, up);

    if ( rotationAutoUpdate ) {
      rotation = calcEulerFromRotationMatrix( matrix, eulerOrder );
    }
  }
}
