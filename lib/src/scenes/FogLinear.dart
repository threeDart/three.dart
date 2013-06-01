part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class FogLinear implements Fog {
  Color color;
  double near;
  double far;
  FogLinear( num hex, [this.near = 1.0, this.far = 1000.0] ) : color = new Color( hex );
}
