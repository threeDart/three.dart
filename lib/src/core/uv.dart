part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class UV {
  double u, v;

  UV( [this.u = 0.0, this.v = 0.0] );

  UV setValues( double u, double v ) {
    this.u = u;
    this.v = v;
    return this;
  }

  UV copy( UV uv ) {
    u = uv.u;
    v = uv.v;

    return this;
  }

  lerpSelf( UV uv, num alpha ) {

    u += ( uv.u - u ) * alpha;
    v += ( uv.v - v ) * alpha;

    return this;

  }

  UV clone()=> new UV( u, v );

}
