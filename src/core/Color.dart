/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Color 
{
  //TODO: declaring a value here seems to automatically set the var as a constant.
  num _r;// = 1;
  num _g;// = 1;
  num _b;// = 1;
  
  num get r() {  return _r;  }
  num get g() {  return _g;  }
  num get b() {  return _b;  }
  
  Color( [num hex] )
  {
    _r = 1;
    _g = 1;
    _b = 1;
    
    if ( hex !== null ) setHex( hex );
    //TODO: Work out how pivotal this odd return statement is.
    //return this;
  }

  Color copy( Color color )
  {
    _r = color.r;
    _g = color.g;
    _b = color.b;

    return this;
  }

  Color copyGammaToLinear( Color color )
  {
    _r = color.r * color.r;
    _g = color.g * color.g;
    _b = color.b * color.b;

    return this;
  }

  Color copyLinearToGamma( Color color ) 
  {
    num x = Math.sqrt( color.r );
    
    _r = Math.sqrt( color.r );
    _g = Math.sqrt( color.g );
    _b = Math.sqrt( color.b );

    return this;
  }

  Color convertGammaToLinear() 
  {
    var r = _r, g = _g, b = _b;

    _r = r * r;
    _g = g * g;
    _b = b * b;

    return this;
  }

  Color convertLinearToGamma()
  {
    _r = Math.sqrt( _r );
    _g = Math.sqrt( _g );
    _b = Math.sqrt( _b );

    return this;
  }

  Color setRGB( num r, num g, num b ) 
  {
    _r = r;
    _g = g;
    _b = b;

    return this;
  }

  Color setHSV( num h, num s, num v )
  {
    // based on MochiKit implementation by Bob Ippolito
    // h,s,v ranges are < 0.0 - 1.0 >

    num i, f, p, q, t;

    if ( v === 0 ) {
      _r = _g = _b = 0;
    } else {
      i = ( h * 6 ).floor();
      f = ( h * 6 ) - i;
      p = v * ( 1 - s );
      q = v * ( 1 - ( s * f ) );
      t = v * ( 1 - ( s * ( 1 - f ) ) );

      switch ( i ) {
        case 1: _r = q; _g = v; _b = p; break;
        case 2: _r = p; _g = v; _b = t; break;
        case 3: _r = p; _g = q; _b = v; break;
        case 4: _r = t; _g = p; _b = v; break;
        case 5: _r = v; _g = p; _b = q; break;
        case 6: // fall through
        case 0: _r = v; _g = t; _b = p; break;
      }
    }

    return this;
  }

  Color setHex( num hex )
  {
    hex = hex.floor();

    _r = ( hex >> 16 & 255 ) / 255;
    _g = ( hex >> 8 & 255 ) / 255;
    _b = ( hex & 255 ) / 255;

    return this;
  }

  num getHex()
  {
    return ( _r * 255 ).floor() << 16 ^ ( _g * 255 ).floor() << 8 ^ ( _b * 255 ).floor();
  }

  String getContextStyle()
  {
    return 'rgb(' + ( _r * 255 ).floor() + ',' + ( _g * 255 ).floor() + ',' + ( _b * 255 ).floor() + ')';
  }

  Color clone() 
  {
    return new Color().setRGB( _r, _g, _b );
  }
}
