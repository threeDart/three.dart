part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author adam smith / http://financecoding.wordpress.com/
 */

class Line extends Object3D {

  Geometry geometry;
  Material material;
  int type;


  Line(this.geometry, [this.material, this.type = LineStrip]) : super() {

    if (material == null) { material = new LineBasicMaterial( color: new Math.Random().nextInt(0xffffff) ); }

    if ( geometry != null ) {
      // calc bound radius
      if( geometry.boundingSphere == null ) {
        geometry.computeBoundingSphere();
      }
    }
  }
}

const int LineStrip = 0;
const int LinePieces = 1;