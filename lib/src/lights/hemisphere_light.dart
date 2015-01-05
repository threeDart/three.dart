part of three;

/// A light source positioned directly above the scene.
class HemisphereLight extends Light {
  Vector3 _position;
  /// Light's intensity.
  num intensity;
  /// Light's ground color.
  Color groundColor;

  HemisphereLight( num skyColorHex, num groundColorHex, {this.intensity: 1} ) : super( skyColorHex ) {
    groundColor = new Color( groundColorHex );

    _position = new Vector3( 0.0, 100.0, 0.0);
  }
}