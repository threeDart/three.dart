part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author greggman / http://games.greggman.com/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class PerspectiveCamera extends Camera {

  double fov;
  double aspect;

  double _fullWidth;
  double _fullHeight;
  double _x;
  double _y;
  double _width;
  double _height;


  PerspectiveCamera( [this.fov = 50.0, this.aspect = 1.0, near = 0.1, far = 2000.0] )
    : super(near, far){

    updateProjectionMatrix();
  }

  /**
   * Uses Focal Length (in mm) to estimate and set FOV
   * 35mm (fullframe) camera is used if frame size is not specified;
   * Formula based on http://www.bobatkins.com/photography/technical/field_of_view.html
   */

  void setLens( double focalLength, double frameSize ) {
    frameSize = frameSize != null ? frameSize : 43.25; // 36x24mm

    fov = 2.0 * Math.atan( frameSize / ( focalLength * 2.0 ) );
    fov = 180.0 / Math.PI * fov;

    updateProjectionMatrix();
  }


  /**
   * Sets an offset in a larger frustum. This is useful for multi-window or
   * multi-monitor/multi-machine setups.
   *
   * For example, if you have 3x2 monitors and each monitor is 1920x1080 and
   * the monitors are in grid like this
   *
   *   +---+---+---+
   *   | A | B | C |
   *   +---+---+---+
   *   | D | E | F |
   *   +---+---+---+
   *
   * then for each monitor you would call it like this
   *
   *   var w = 1920;
   *   var h = 1080;
   *   var fullWidth = w * 3;
   *   var fullHeight = h * 2;
   *
   *   --A--
   *   camera.setOffset( fullWidth, fullHeight, w * 0, h * 0, w, h );
   *   --B--
   *   camera.setOffset( fullWidth, fullHeight, w * 1, h * 0, w, h );
   *   --C--
   *   camera.setOffset( fullWidth, fullHeight, w * 2, h * 0, w, h );
   *   --D--
   *   camera.setOffset( fullWidth, fullHeight, w * 0, h * 1, w, h );
   *   --E--
   *   camera.setOffset( fullWidth, fullHeight, w * 1, h * 1, w, h );
   *   --F--
   *   camera.setOffset( fullWidth, fullHeight, w * 2, h * 1, w, h );
   *
   *   Note there is no reason monitors have to be the same size or in a grid.
   */

  void setViewOffset( double fullWidth, double fullHeight, double x, double y, double width, double height ) {
    _fullWidth = fullWidth;
    _fullHeight = fullHeight;
    _x = x;
    _y = y;
    _width = width;
    _height = height;

    updateProjectionMatrix();
  }


  void updateProjectionMatrix() {
    if ( _fullWidth != null ) {
      double aspect = _fullWidth / _fullHeight;
      double top = Math.tan( fov * Math.PI / 360.0 ) * near;
      double bottom = -top;
      double left = aspect * bottom;
      double right = aspect * top;
      double width = ( right - left ).abs();
      double height = ( top - bottom ).abs();

      setFrustumMatrix(projectionMatrix,
        left + _x * width / _fullWidth,
        left + ( _x + width ) * width / _fullWidth,
        top - ( _y + height ) * height / _fullHeight,
        top - _y * height / _fullHeight,
        near,
        far );
    } else {
      projectionMatrix = makePerspectiveMatrix(fov * (Math.PI / 180), aspect, near, far);
    }
  }
}
