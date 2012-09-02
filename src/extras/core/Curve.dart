/**************************************************************
 *	Abstract Curve base class
 **************************************************************/
abstract class Curve {

  int _arcLengthDivisions = null;
  List cacheArcLengths = null;
  bool needsUpdate = false;
  
	// Virtual base class method to overwrite and implement in subclasses
	//	- t [0 .. 1]
  abstract Vector2 getPoint(t);

	// Get point at relative position in curve according to arc length
	// - u [0 .. 1]
  Vector2 getPointAt( u ) {
		var t = getUtoTmapping( u );
		return getPoint( t );
	}

	// Get sequence of points using getPoint( t )
	List<Vector2> getPoints( [num divisions = null] ) {

	  if (divisions == null) divisions = 5;
	  
		var d, pts = [];

		for ( d = 0; d <= divisions; d ++ ) {
			pts.add( this.getPoint( d / divisions ) );
		}

		return pts;
	}

	// Get sequence of points using getPointAt( u )
	List<Vector2> getSpacedPoints( [num divisions = 5] ) {


		var d, pts = [];

		for ( d = 0; d <= divisions; d ++ ) {
			pts.add( this.getPointAt( d / divisions ) );
		}

		return pts;
	}

	// Get total curve arc length
	num get length() => getLengths().last();

	// Get list of cumulative segment lengths
	List getLengths( [num divisions = null] ) {

		if (divisions == null) divisions = (_arcLengthDivisions != null) ? (_arcLengthDivisions): 200;

		if ( cacheArcLengths != null
			&& ( cacheArcLengths.length == divisions + 1 ) 
			&& !needsUpdate) {

			//console.log( "cached", this.cacheArcLengths );
			return cacheArcLengths;
		}

		needsUpdate = false;

		var cache = [];
		var current, last = getPoint( 0 );
		var sum = 0;

		cache.add( 0 );

		for ( var p = 1; p <= divisions; p ++ ) {

			current = getPoint ( p / divisions );
			sum += current.distanceTo( last );
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
	getUtoTmapping( u, [distance = null] ) {

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


	// In 2D space, there are actually 2 normal vectors,
	// and in 3D space, infinte
	// TODO this should be depreciated.
	Vector2 getNormalVector( t ) {
		var vec = this.getTangent( t );
		return new Vector2( -vec.y , vec.x );
	}

	// Returns a unit vector tangent at t
	// In case any sub curve does not implement its tangent / normal finding,
	// we get 2 points with a small delta and find a gradient of the 2 points
	// which seems to make a reasonable approximation
	Vector2 getTangent( t ) {

		var delta = 0.0001;
		var t1 = t - delta;
		var t2 = t + delta;

		// Capping in case of danger

		if ( t1 < 0 ) t1 = 0;
		if ( t2 > 1 ) t2 = 1;

		var pt1 = getPoint( t1 );
		var pt2 = getPoint( t2 );

		var vec = pt2.clone().subSelf(pt1);
		return vec.normalize();
	}

	Vector2 getTangentAt( u ) {
		var t = getUtoTmapping( u );
		return getTangent( t );
	}

}

/**************************************************************
 *	Spline 3D curve
 **************************************************************/
class SplineCurve3 extends Curve {

	List<Vector3> _points;

	SplineCurve3( [List<Vector3> points = null] ) {
		if (points == null) {
			_points = [];
		} else {
		  _points = points;
		}
	}

	getPoint( t ) {

		var v = new Vector3();
		var c = [];
		var points = _points, 
		    point = ( points.length - 1 ) * t, 
		    intPoint = point.floor(), 
		    weight = point - intPoint;

		c[ 0 ] = intPoint == 0 ? intPoint : intPoint - 1;
		c[ 1 ] = intPoint;
		c[ 2 ] = intPoint  > points.length - 2 ? points.length - 1 : intPoint + 1;
		c[ 3 ] = intPoint  > points.length - 3 ? points.length - 1 : intPoint + 2;

		var pt0 = points[ c[0] ],
			pt1 = points[ c[1] ],
			pt2 = points[ c[2] ],
			pt3 = points[ c[3] ];

		v.x = CurveUtils.interpolate(pt0.x, pt1.x, pt2.x, pt3.x, weight);
		v.y = CurveUtils.interpolate(pt0.y, pt1.y, pt2.y, pt3.y, weight);
		v.z = CurveUtils.interpolate(pt0.z, pt1.z, pt2.z, pt3.z, weight);

		return v;

	}

 }