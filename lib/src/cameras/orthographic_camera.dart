part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author greggman / http://games.greggman.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// Camera with orthographic projection.
class OrthographicCamera extends Camera {

  /// Camera frustum left plane.
  double left;
  /// Camera frustum right plane.
  double right;
  /// Camera frustum top plane.
  double top;
  /// Camera frustum bottom plane.
  double bottom;

  OrthographicCamera( this.left, this.right, this.top, this.bottom,
            [near = 0.1, far = 2000.0] ) : super(near, far) {
    updateProjectionMatrix();
  }

  /// Updates the camera projection matrix.
  ///
  /// Must be called after change of parameters.
  void updateProjectionMatrix() {
    setOrthographicMatrix( projectionMatrix, left, right, bottom, top, near, far);
  }
}