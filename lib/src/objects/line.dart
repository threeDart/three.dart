part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author adam smith / http://financecoding.wordpress.com/
 */

/// A line or a series of lines.
class Line extends Object3D {
  /// Material for the line.
  Material material;
  /// Possible values: LineStrip or LinePieces.
  ///
  /// LineStrip will draw a series of segments connecting each point (first
  /// connected to the second, the second connected to the third, and so on
  /// and so forth); and LinePieces will draw a series of pairs of segments
  /// (first connected to the second, the third connected to the fourth, and so on and so forth).
  ///
  /// In OpenGL terms, LineStrip is the classic GL_LINE_STRIP and LinePieces is the equivalent to GL_LINES.
  int type;

  Line(Geometry geometry, [this.material, this.type = LineStrip]) : super() {

    if (material == null) {
      material = new LineBasicMaterial(color: new Math.Random().nextInt(0xffffff));
    }

    if (geometry != null) {
      // calc bound radius
      if (geometry.boundingSphere == null) {
        geometry.computeBoundingSphere();
      }
      this.geometry = geometry;
    }
  }
}

const int LineStrip = 0;
const int LinePieces = 1;
