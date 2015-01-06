part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class Fog {
  Color color;
  double near;
  double far;
  String name = '';

  Fog(Color color, [this.near = 1.0, this.far = 1000.0]) {
    this.color = color.clone();
  }

  Fog clone() => new Fog(color, near, far);
}
