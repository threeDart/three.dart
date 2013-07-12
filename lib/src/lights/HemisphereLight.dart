part of three;

class HemisphereLight extends Light {
  Vector3 _position;
  num intensity;
  Color groundColor;

  HemisphereLight( num skyColorHex, num groundColorHex, {this.intensity: 1} ) : super( skyColorHex ) {
    groundColor = new Color( groundColorHex );

    _position = new Vector3( 0.0, 100.0, 0.0);
  }
}