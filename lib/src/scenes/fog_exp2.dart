part of three;

class FogExp2 implements Fog {
  Color color;
  num density;
  FogExp2( num hex, [this.density = 0.00025] ) : color = new Color( hex );
}
