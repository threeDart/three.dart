part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// Abstract base class for lights.
class Light extends Object3D {
  /// Color of the light.
  Color color;

  /// This creates a light with color.
  Light(num hex)
      : color = new Color(hex),
        super();
}
