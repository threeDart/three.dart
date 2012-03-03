/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Color 
{
  //TODO: declaring a value here seems to automatically set the var as a constant.
  num r;// = 1;
  num g;// = 1;
  num b;// = 1;
  
  Color( [num hex] )
  {
    r = 1;
    g = 1;
    b = 1;
    
    if ( hex is num ) setHex( hex );
    //TODO: Work out how pivotal this odd return statement is.
    //return this;
  }

  Color copy( Color color )
  {
    r = color.r;
    g = color.g;
    b = color.b;
    
    return this;
  }

  Color copyGammaToLinear( Color color )
  {
    r = color.r * color.r;
    g = color.g * color.g;
    b = color.b * color.b;

    return this;
  }

  Color copyLinearToGamma( Color color ) 
  {
    num x = Math.sqrt( color.r );
    
    r = Math.sqrt( color.r );
    g = Math.sqrt( color.g );
    b = Math.sqrt( color.b );

    return this;
  }

  Color convertGammaToLinear() 
  {
    var _r = r, _g = g, _b = b;

    r = _r * _r;
    g = _g * _g;
    b = _b * _b;
    
    return this;
  }

  Color convertLinearToGamma()
  {
    r = Math.sqrt( r );
    g = Math.sqrt( g );
    b = Math.sqrt( b );
    return this;
  }

  Color setRGB( num newR, num newG, num newB ) 
  {
    r = newR;
    g = newG;
    b = newB;

    return this;
  }

  Color setHSV( num h, num s, num v )
  {
    // based on MochiKit implementation by Bob Ippolito
    // h,s,v ranges are < 0.0 - 1.0 >  
    num i, f, p, q, t;

    if ( v === 0 ) {
      r = g = b = 0;
    } else {
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

  Color setHex( num hex )
  {
    var h = hex.floor().toInt();    
    r = (h&0xFF0000)>>16; 
    g = (h&0x00FF00)>>8;
    b = (h&0x0000FF);
    return this;
  }

  num getHex()
  {
    num h = (r<<16)^(g<<8)^(b);
    return h;
  }

  String getContextStyle()
  {
    // TODO: this is a little bit of a mess. We should stay consistent between
    // how r,g,b is set. Something in CanvasRender is setting them to doubles
    // when they should be int's. We could add setter/getter's to handle this
    
    int rr=r,bb=b,gg=g;
    
    if (r is double && r < 1) {
      rr = (r*0xff).toInt();
    }
    
    if (g is double && g < 1) {
      gg = (g*0xff).toInt();
    }
    
    if (b is double && b < 1) {
      bb = (b*0xff).toInt();
    }
    
    return 'rgb(${rr},${gg},${bb})';
  }

  Color clone() 
  {
    return new Color().setRGB( r, g, b);
  }
}
