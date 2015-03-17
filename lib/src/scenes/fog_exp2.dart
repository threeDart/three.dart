part of three;

class FogExp2 extends Fog {
  Color color;
  num density;
  FogExp2(num hex, [this.density = 0.00025]) : color = new Color(hex) ;
}
