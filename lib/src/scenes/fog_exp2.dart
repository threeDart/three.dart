part of three;

class FogExp2 extends Fog {
  num density;
  FogExp2(num hex, [this.density = 0.00025]) {
    color = new Color(hex);
  }
}
