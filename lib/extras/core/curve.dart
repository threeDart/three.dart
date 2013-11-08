part of three;

/**************************************************************
 *	Abstract Curve base class
 **************************************************************/
abstract class Curve<V> {

  int _arcLengthDivisions = null;
  List cacheArcLengths = null;
  bool needsUpdate = false;

	// Virtual base class method to overwrite and implement in subclasses
	//	- t [0 .. 1]
  V getPoint(t);

	// Get point at relative position in curve according to arc length
	// - u [0 .. 1]
  V getPointAt( u ) {
		var t = getUtoTmapping( u );
		return getPoint( t );
	}

	// Get sequence of points using getPoint( t )
  // TODO(nelsonsilva) - closedPath is only used in Path
	List<V> getPoints( [num divisions = null, closedPath = false] ) {

	  if (divisions == null) divisions = 5;

		var d, pts = [];

		for ( d = 0; d <= divisions; d ++ ) {
			pts.add( this.getPoint( d / divisions ) );
		}

		return pts;
	}

	// Get sequence of points using getPointAt( u )
  // TODO(nelsonsilva) - closedPath is only used in Path
	List<V> getSpacedPoints( [num divisions = 5, closedPath = false] ) {


		var d, pts = [];

		for ( d = 0; d <= divisions; d ++ ) {
			pts.add( this.getPointAt( d / divisions ) );
		}

		return pts;
	}

	 // Get sequence of points using getPointAt( u )
  // TODO(tiagocardoso) - closedPath is only used in Path
  List<V> getUPoints( [List uList , closedPath = false] ) {
    var pts = [];

    for ( var u in uList ) {
      pts.add( this.getPointAt( u ) );
    }

    return pts;
  }


	// Get total curve arc length
	num get length => getLengths().last;

	// Get list of cumulative segment lengths
	List getLengths( {num divisions: null} ) {

		if (divisions == null) divisions = (_arcLengthDivisions != null) ? (_arcLengthDivisions): 200;

		if ( cacheArcLengths != null
			&& ( cacheArcLengths.length == divisions + 1 )
			&& !needsUpdate) {

			//console.log( "cached", this.cacheArcLengths );
			return cacheArcLengths;
		}

		needsUpdate = false;

		var cache = [];
		var current;
		var last = getPoint( 0.0 );
		var sum = 0;

		cache.add( 0 );

		for ( var p = 1; p <= divisions; p ++ ) {

			current = getPoint ( p / divisions );

			var distance;

			// TODO(nelsonsilva) - Must move distanceTo to IVector interface os create a new IHasDistance
			if (current is Vector3) {
			  distance = (current as Vector3).absoluteError( last as Vector3 );
			} else {
        distance = (current as Vector2).absoluteError( last as Vector2);
      }

			sum += distance;
			cache.add( sum );
			last = current;

		}

		cacheArcLengths = cache;

		return cache; // { sums: cache, sum:sum }; Sum is in the last element.
	}


	updateArcLengths() {
		needsUpdate = true;
		getLengths();
	}

	// Given u ( 0 .. 1 ), get a t to find p. This gives you points which are equi distance
	getUtoTmapping( u, {distance: null} ) {

		var arcLengths = getLengths();

		int i = 0, il = arcLengths.length;

		var targetArcLength; // The targeted u distance value to get

		if (distance != null) {
			targetArcLength = distance;
		} else {
			targetArcLength = u * arcLengths[ il - 1 ];
		}

		//var time = Date.now();

		// binary search for the index with largest value smaller than target u distance

		var low = 0, high = il - 1, comparison;

		while ( low <= high ) {

			i = ( low + ( high - low ) / 2 ).floor().toInt(); // less likely to overflow, though probably not issue here, JS doesn't really have integers, all numbers are floats

			comparison = arcLengths[ i ] - targetArcLength;

			if ( comparison < 0 ) {

				low = i + 1;
				continue;

			} else if ( comparison > 0 ) {

				high = i - 1;
				continue;

			} else {

				high = i;
				break;

				// DONE

			}

		}

		i = high;

		//console.log('b' , i, low, high, Date.now()- time);

		if ( arcLengths[ i ] == targetArcLength ) {

			var t = i / ( il - 1 );
			return t;

		}

		// we could get finer grain at lengths, or use simple interpolatation between two points

		var lengthBefore = arcLengths[ i ];
	    var lengthAfter = arcLengths[ i + 1 ];

	    var segmentLength = lengthAfter - lengthBefore;

	    // determine where we are between the 'before' and 'after' points

	    var segmentFraction = ( targetArcLength - lengthBefore ) / segmentLength;

	    // add that fractional amount to t

	    var t = ( i + segmentFraction ) / ( il -1 );

		return t;
	}


	// Returns a unit vector tangent at t
	// In case any sub curve does not implement its tangent / normal finding,
	// we get 2 points with a small delta and find a gradient of the 2 points
	// which seems to make a reasonable approximation
	V getTangent( t ) {

		var delta = 0.0001;
		var t1 = t - delta;
		var t2 = t + delta;

		// Capping in case of danger

		if ( t1 < 0 ) t1 = 0;
		if ( t2 > 1 ) t2 = 1;

		var pt1 = getPoint( t1 );
		var pt2 = getPoint( t2 );

		var vec = pt2 - pt1;
		return vec.normalize();
	}

	V getTangentAt( u ) {
		var t = getUtoTmapping( u );
		return getTangent( t );
	}

}

abstract class Curve2D extends Curve<Vector2> {
  // In 2D space, there are actually 2 normal vectors,
  // and in 3D space, infinte
  // TODO this should be depreciated.
  Vector2 getNormalVector( t ) {
    var vec = this.getTangent( t );
    return new Vector2( -vec.y , vec.x );
  }
}

abstract class Curve3D extends Curve<Vector3> {
}