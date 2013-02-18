/**
 * Based on Tween.js
 *
 * @author sole / http://soledadpenades.com
 * @author mrdoob / http://mrdoob.com
 * @author Robert Eisele / http://www.xarg.org
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 * @author Paul Lewis / http://www.aerotwist.com/
 * @author lechecacharro
 * @author Josh Faul / http://jocafa.com/
 * @author egraether / http://egraether.com/
 *
 * Ported to Dart by
 *
 * @author nelson silva / http://www.inevo.pt
 *
 */

library tween;

import 'dart:math' as Math;

const REVISION = '7';

List<Tween> _tweens = [];

get all => _tweens;

removeAll() => _tweens = [];

add( tween ) => _tweens.add( tween );

remove( tween ) => _tweens.removeAt(_tweens.indexOf(tween));

update( {num time} ) {

  if ( _tweens.isEmpty ) { return false; }

  var i = 0, l = _tweens.length;

  if (!?time) {
    time = new DateTime.now().millisecondsSinceEpoch;
  }

  while ( i < l ) {
    if ( _tweens[ i ].update( time ) ) {
      i ++;
    } else {
      _tweens.removeAt( i );
      l--;
    }
  }
  return true;
}

class Tween {
  var object;
  Map _valuesStart = {};
  Map _valuesEnd = {};
  num _duration = 1000;
  num _delayTime = 0;
  num _startTime = null;
  var _easingFunction = Easing.Linear.None;
  var _interpolationFunction = Interpolation.Linear;
  List _chainedTweens = [];
  var _onStartCallback = null;
  bool _onStartCallbackFired = false;
  var _onUpdateCallback = null;
  var _onCompleteCallback = null;

  Tween(this.object);

  to( properties, [duration] ) {
    if ( ?duration ) {
      _duration = duration;
    }

    _valuesEnd = properties;
  }

  // TODO(nelsonsilva) - We just support x, y and z props for now (no mirrors yet :(
  _setPropertyValue(String name, Object value) {
    switch(name) {
      case "x": object.x = value; break;
      case "y": object.y = value; break;
      case "z": object.z = value; break;
      default:
        throw new Exception("The supplied property name ('$name') is not supported at this time.");
    }
  }

  // TODO(nelsonsilva) - We just support x, y and z props for now (no mirrors yet :(
  Object _getPropertyValue(String name) {
    switch(name) {
      case "x": return object.x;
      case "y": return object.y;
      case "z": return object.z;
      default:
        throw new Exception("The supplied property name ('$name') is not supported at this time.");
    }
  }

  start( {num time} ) {

    add( this );

    _onStartCallbackFired = false;

    _startTime = (?time)? time : new DateTime.now().millisecondsSinceEpoch;
    _startTime += _delayTime;

    _valuesEnd.forEach((property, _) {

      var value = _getPropertyValue(property);

      // This prevents the engine from interpolating null values
      if ( value != null ) {

        // check if an Array was provided as property value
        if ( _valuesEnd[ property ] is List && ! _valuesEnd[ property ].isEmpty) {

          // create a local copy of the Array with the start value at the front
          _valuesEnd[ property ] = [ value ]..add( _valuesEnd[ property ] );

        }

        _valuesStart[ property ] = value;
      }

    });

  }

  stop() => remove( this );


  set delay( amount ) { _delayTime = amount; }

  set easing( easing ) { _easingFunction = easing; }

  set interpolation( interpolation ) { _interpolationFunction = interpolation; }

  chain( List tweens) {  _chainedTweens = tweens; }

  set onStart( callback ) { _onStartCallback = callback; }

  set onUpdate( callback ) { _onUpdateCallback = callback; }

  set onComplete( callback ) { _onCompleteCallback = callback; }

  update( num time ) {

    if ( time < _startTime ) {
      return true;
    }

    if ( !_onStartCallbackFired ) {
      if ( _onStartCallback != null ) {
        _onStartCallback(object );
      }
      _onStartCallbackFired = true;
    }

    var elapsed = ( time - _startTime ) / _duration;
    elapsed = elapsed > 1 ? 1 : elapsed;

    var value = _easingFunction( elapsed );

    _valuesStart.forEach((property, start) {

      var end = _valuesEnd[ property ];

      if ( end is List ) {
        _setPropertyValue( property, _interpolationFunction( end, value ));
      } else {
        _setPropertyValue( property, start + ( end - start ) * value);
      }
    });

    if ( _onUpdateCallback != null ) {
      _onUpdateCallback( object, value );
    }

    if ( elapsed == 1 ) {

      if ( _onCompleteCallback != null ) {
        _onCompleteCallback( object );
      }

      _chainedTweens.forEach((t) => t.start(time));

      return false;

    }

    return true;

  }
}

class Easing {
  static const Linear = const _EasingLinear();
  static const Quadratic = const _EasingQuadratic();
  static const Exponential = const _EasingExponential();
}

class Interpolation {
  static Linear( v, k ) {
    var m = v.length - 1,
        f = m * k,
        i = f.floor(),
        fn = _InterpolationUtils.Linear;

    if ( k < 0 ) return fn( v[ 0 ], v[ 1 ], f );
    if ( k > 1 ) return fn( v[ m ], v[ m - 1 ], m - f );

    return fn( v[ i ], v[ i + 1 > m ? m : i + 1 ], f - i );

  }
}

class _EasingLinear {
  const _EasingLinear();
  None(k) => k;
}

class _EasingQuadratic {
  const _EasingQuadratic();
  In(k) => k * k;
  Out(k) => k * (2 - k);
  InOut(k) {
    if ( ( k *= 2 ) < 1 ) return 0.5 * k * k;
    return - 0.5 * ( --k * ( k - 2 ) - 1 );
  }
}

class _EasingExponential {
  const _EasingExponential();
  In(k) => k == 0 ? 0 : Math.pow( 1024, k - 1 );
  Out(k) =>  k == 1 ? 1 : 1 - Math.pow( 2, - 10 * k );
  InOut(k) {
    if ( k == 0 ) return 0;
    if ( k == 1 ) return 1;
    if ( ( k *= 2 ) < 1 ) return 0.5 * Math.pow( 1024, k - 1 );
    return 0.5 * ( - Math.pow( 2, - 10 * ( k - 1 ) ) + 2 );
  }
}

class _InterpolationUtils {
  static Linear( p0, p1, t ) => ( p1 - p0 ) * t + p0;
}

