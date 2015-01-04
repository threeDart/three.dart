part of three;

/**
 * Represents a color.
 *
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Color {

  double _r;
  double _g;
  double _b;

  /// Sets the red component. The value passed must be between 0 and 1.
  set r(num r) { _r = r.toDouble();}
  /// Gets the red component. The value will be between 0 and 1.
  double get r => _r;

  /// Sets the green component. The value passed must be between 0 and 1.
  set g(num g) { _g = g.toDouble();}
  /// Gets the green component. The value will be between 0 and 1.
  double get g => _g;

  /// Sets the blue component. The value passed must be between 0 and 1.
  set b(num b) { _b = b.toDouble();}
  /// Gets the blue component. The value will be between 0 and 1.
  double get b => _b;

  /// Gets the red component as a value between 0 and 255.
  int get rr => (r*255).floor();
  /// Gets the green component as a value between 0 and 255.
  int get gg => (g*255).floor();
  /// Gets the blue component as a value between 0 and 255.
  int get bb => (b*255).floor();

  /// Creates a Color from the (optional) given hex value.
  Color( [num hex] )
      : _r = 1.0,
        _g = 1.0,
        _b = 1.0 {

    if ( hex is num ) setHex( hex );
  }

  /// Copies the color and returns this color.
  Color copy( Color color ) {
    r = color.r;
    g = color.g;
    b = color.b;

    return this;
  }

  /// Copies the given color making conversions from gamma to linear space.
  Color copyGammaToLinear( Color color ) {
    r = color.r * color.r;
    g = color.g * color.g;
    b = color.b * color.b;

    return this;
  }

  /// Copies the given color making conversions from linear to gamma space.
  Color copyLinearToGamma( Color color ) {
    num x = Math.sqrt( color.r );

    r = Math.sqrt( color.r );
    g = Math.sqrt( color.g );
    b = Math.sqrt( color.b );

    return this;
  }

  /// Converts this color from gamma to linear space.
  Color convertGammaToLinear() {
    var _r = r, _g = g, _b = b;

    r = _r * _r;
    g = _g * _g;
    b = _b * _b;

    return this;
  }

  /// Converts this color from linear to gamma space.
  Color convertLinearToGamma() {
    r = Math.sqrt( r );
    g = Math.sqrt( g );
    b = Math.sqrt( b );
    return this;
  }

  /// Sets this color from RGB values.
  /// RGB ranges are in 0.0 - 1.0.
  Color setRGB( num newR, num newG, num newB ) {
    r = newR.toDouble();
    g = newG.toDouble();
    b = newB.toDouble();

    return this;
  }

  /// Sets this color from HSV.
  /// HSL ranges are in 0.0 - 1.0.
  Color setHSV( double h, double s, double v ) {
    // based on MochiKit implementation by Bob Ippolito

    if ( v == 0 ) {
      r = g = b = 0.0;
    } else {
      var i, f, p, q, t;

      i = ( h * 6 ).floor();
      f = ( h * 6 ) - i;
      p = v * ( 1 - s );
      q = v * ( 1 - ( s * f ) );
      t = v * ( 1 - ( s * ( 1 - f ) ) );

      switch ( i ) {
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
        case 6: // fall through
        case 0: r = v; g = t; b = p; break;
      }
    }

    return this;
  }

  /// Sets this color from HSL.
  /// HSL ranges are in 0.0 - 1.0.
  Color setHSL( double h, double s, double l ) {
    if ( s == 0 ) {

      r = g = b = l;

    } else {

      var hue2rgb = ( p, q, t ) {

        if ( t < 0 ) t += 1;
        if ( t > 1 ) t -= 1;
        if ( t < 1 / 6 ) return p + ( q - p ) * 6 * t;
        if ( t < 1 / 2 ) return q;
        if ( t < 2 / 3 ) return p + ( q - p ) * 6 * ( 2 / 3 - t );
        return p;

      };

      var p = l <= 0.5 ? l * ( 1 + s ) : l + s - ( l * s );
      var q = ( 2 * l ) - p;

      this.r = hue2rgb( q, p, h + 1 / 3 );
      this.g = hue2rgb( q, p, h );
      this.b = hue2rgb( q, p, h - 1 / 3 );

    }

    return this;

  }

  /// Gets this color as HSL (returned as [hue, saturation, lightness]).
  /// HSL ranges are in 0.0 - 1.0.
  List<double> get HSL {
    var r = this.r, g = this.g, b = this.b;

    var max = Math.max(Math.max( r, g), b );
    var min = Math.min(Math.min( r, g), b );

    var hue, saturation;
    var lightness = ( min + max ) / 2.0;

    if ( min == max ) {

      hue = 0;
      saturation = 0;

    } else {

      var delta = max - min;

      saturation = lightness <= 0.5 ? delta / ( max + min ) : delta / ( 2 - max - min );

      if (max == r) {
        hue = ( g - b ) / delta + ( g < b ? 6 : 0 );
      } else if (max == g) {
        hue = ( b - r ) / delta + 2;
      } else if (max == b) {
        hue = ( r - g ) / delta + 4;
      }

      hue /= 6;

    }

    return [hue, saturation, lightness];

  }

  /// Adds HSL to this color's HSL.
  /// HSL ranges are in 0.0 - 1.0.
  Color offsetHSL( double h, double s, double l ) {

    var hsl = this.HSL;

    hsl[0] += h; hsl[1] += s; hsl[2] += l;

    setHSL( hsl[0], hsl[1], hsl[2] );

    return this;

  }

  /// Sets this color from a hexadecimal value.
  Color setHex( num hex ) {
    var h = hex.floor().toInt();
    r = ( (h&0xFF0000)>>16 ) / 255;
    g = ( (h&0x00FF00)>>8 ) / 255;
    b = (h&0x0000FF) / 255;
    return this;
  }

  /// Returns the hexadecimal value of this color.
  num getHex() {
    num h = (rr<<16)^(gg<<8)^(bb);
    return h;
  }

  /// Returns the value of this color as a CSS-style string (ex: rgb(255, 0, 0))
  String getContextStyle() {
    // TODO: this is a little bit of a mess. We should stay consistent between
    // how r,g,b is set. Something in CanvasRender is setting them to doubles
    // when they should be int's. We could add setter/getter's to handle this

    return 'rgb(${rr},${gg},${bb})';
  }

  /// Clones this color.
  Color clone() {
    return new Color().setRGB( r, g, b);
  }
}
