/**
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/ 
 */

class ThreeMath 
{
  ThreeMath()
  {
    
  }

  // Clamp value to range <a, b>
  num clamp( num x, num a, num b )
  {
    return ( x < a ) ? a : ( ( x > b ) ? b : x );
  }

  // Clamp value to range <a, inf)
  num clampBottom( num x, num a )
  {
    return x < a ? a : x;
  }

  // Linear mapping from range <a1, a2> to range <b1, b2>
  num mapLinear( num x, num a1, num a2, num b1, num b2 ) 
  {
    return b1 + ( x - a1 ) * ( b2 - b1 ) / ( a2 - a1 );
  }

  // Random float from <0, 1> with 16 bits of randomness
  // (standard Math.random() creates repetitive patterns when applied over larger space)
  num random16() 
  {
    return ( 65280 * Math.random() + 255 * Math.random() ) / 65535;
  }

  // Random integer from <low, high> interval
  int randInt( num low, num high )
  {
    return (low + ( Math.random() * ( high - low + 1 ) ).floor()).toInt();
  }

  // Random float from <low, high> interval
  num randFloat( num low, num high ) 
  {
    return low + Math.random() * ( high - low );
  }

  // Random float from <-range/2, range/2> interval
  num randFloatSpread( num range ) 
  {
    return range * ( 0.5 - Math.random() );
  }
}
