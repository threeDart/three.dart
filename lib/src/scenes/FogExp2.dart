class FogExp2 implements Fog {
  Color color;
  num density;
  FogExp2( num hex, [density = 0.00025] ) {
    this.density = density;
    this.color = new Color( hex );
  }
}
