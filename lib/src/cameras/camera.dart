part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// Abstract base class for cameras.
///
/// This class should always be inherited when you build a new camera.
class Camera extends Object3D {
  /// This is the inverse of matrixWorld. MatrixWorld contains the Matrix which has the world transform of the Camera.
  Matrix4 matrixWorldInverse;
  /// This is the matrix which contains the projection.
  Matrix4 projectionMatrix;
  Matrix4 projectionMatrixInverse;

  double near;
  double far;

  // WebGL
  Float32List _viewMatrixArray = new Float32List(16);
  Float32List _projectionMatrixArray = new Float32List(16);

  Camera(this.near, this.far)
      : matrixWorldInverse = new Matrix4.identity(),
        projectionMatrix = new Matrix4.identity(),
        projectionMatrixInverse = new Matrix4.identity(),
        super();

  /// This makes the camera look at the vector position in the global space as
  /// long as the parent of this camera is the scene or at position (0,0,0).
  void lookAt(Vector3 vector) {
    // TODO: Add hierarchy support.

    makeLookAt(matrix, position, vector, up);

    if (rotationAutoUpdate) {
      rotation = calcEulerFromRotationMatrix(matrix, eulerOrder);
    }
  }
}
