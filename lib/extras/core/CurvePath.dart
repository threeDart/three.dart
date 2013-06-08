part of three;

/**
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 **/

/**************************************************************
 *	Curved Path - a curve path is simply a array of connected
 *  curves, but retains the api of a curve
 **************************************************************/

class CurvePath extends Curve {

	List curves;
	List _bends;

	bool autoClose; // Automatically closes the path

	List cacheLengths = null;

	CurvePath()
		:	curves = [],
			_bends = [],
			autoClose = false,
			super();

	add( curve ) => curves.add( curve );

	checkConnection() {
		// TODO
		// If the ending of curve is not connected to the starting
		// or the next curve, then, this is not a real path
	}

	closePath() {
		// TODO Test
		// and verify for vector3 (needs to implement equals)
		// Add a line curve if start and end of lines are not connected
		var startPoint = curves[0].getPoint(0);
		var endPoint = curves[curves.length-1].getPoint(1);

		if (!startPoint.equals(endPoint)) {
			this.curves.add( new LineCurve(endPoint, startPoint) );
		}

	}

	// To get accurate point with reference to
	// entire path distance at time t,
	// following has to be done:

	// 1. Length of each sub path have to be known
	// 2. Locate and identify type of curve
	// 3. Get t for the curve
	// 4. Return curve.getPointAt(t')
	getPoint( num t ) {

		var d = t * this.length;
		var curveLengths = this.getCurveLengths();
		var i = 0, diff;
		Curve curve;

		// To think about boundaries points.

		while ( i < curveLengths.length ) {

			if ( curveLengths[ i ] >= d ) {

				diff = curveLengths[ i ] - d;
				curve = this.curves[ i ];

				var u = 1 - diff / curve.length;

				return curve.getPointAt( u );

			}

			i ++;

		}

		return null;

		// loop where sum != 0, sum > d , sum+1 <d

	}


	// We cannot use the default THREE.Curve getPoint() with getLength() because in
	// THREE.Curve, getLength() depends on getPoint() but in THREE.CurvePath
	// getPoint() depends on getLength
	num get length => getCurveLengths().last;

	// Compute lengths and cache them
	// We cannot overwrite getLengths() because UtoT mapping uses it.

	List<num> getCurveLengths() {

		// We use cache values if curves and cache array are same length

		if ( this.cacheLengths != null && this.cacheLengths.length == this.curves.length ) {

			return this.cacheLengths;

		}

		// Get length of subsurve
		// Push sums into cached array

		var lengths = [], sums = 0;
		var i, il = this.curves.length;

		for ( i = 0; i < il; i ++ ) {

			sums += this.curves[ i ].length;
			lengths.add( sums );

		}

		this.cacheLengths = lengths;

		return lengths;

	}


	// Returns min and max coordinates, as well as centroid
	getBoundingBox() {

		var points = getPoints();

		var maxX, maxY, maxZ;
		var minX, minY, minZ;

		maxX = maxY = double.NEGATIVE_INFINITY;
		minX = minY = double.INFINITY;

		var p, i, sum;

		var v3 = points[0] is Vector3;

		sum = (v3) ? new Vector3.zero() : new Vector2.zero();

		int il = points.length;
		for ( i = 0; i < il; i ++ ) {

			p = points[ i ];

			if ( p.x > maxX ) { maxX = p.x;
			} else if ( p.x < minX ) minX = p.x;

			if ( p.y > maxY ) { maxY = p.y;
			} else if ( p.y < minY ) minY = p.y;

			if (v3) {
			  p = p as Vector3;
	      if ( p.z > maxZ ) { maxZ = p.z;
	      } else if ( p.z < minZ ) minZ = p.z;

	      (sum as Vector3).add( p );
	    } else {
	      (sum as Vector2).add( p );
	    }



		}

		var ret = {

			"minX": minX,
			"minY": minY,
			"maxX": maxX,
			"maxY": maxY,
			"centroid": (sum as dynamic).scale( 1.0 / il )

		};

		if (v3) {

	    ret["maxZ"] = maxZ;
	    ret["minZ"] = minZ;

	  }

	  return ret;
	}

	/**************************************************************
	 *	Create Geometries Helpers
	 **************************************************************/

	/// Generate geometry from path points (for Line or ParticleSystem objects)
	createPointsGeometry( {divisions} ) {
		var pts = this.getPoints( divisions, true );
		return this.createGeometry( pts );
	}

	// Generate geometry from equidistance sampling along the path
	createSpacedPointsGeometry( [divisions] ) {
		var pts = this.getSpacedPoints( divisions, true );
		return this.createGeometry( pts );
	}

	createGeometry( points ) {

		var geometry = new Geometry();

		for ( var i = 0; i < points.length; i ++ ) {
		  var z = (points[i] is Vector3) ? points[ i ].z : 0.0;
			geometry.vertices.add( new Vector3( points[ i ].x, points[ i ].y, z) );
		}

		return geometry;
	}


	/**************************************************************
	 *	Bend / Wrap Helper Methods
	 **************************************************************/

	// Wrap path / Bend modifiers?

	addWrapPath( bendpath ) => _bends.add( bendpath );

	getTransformedPoints( segments, {List bends: null} ) {

		var oldPts = this.getPoints( segments ); // getPoints getSpacedPoints
		var i, il;

		if (bends == null) {
			bends = _bends;
		}

		for ( i = 0; i < bends.length; i ++ ) {
			oldPts = this.getWrapPoints( oldPts, bends[ i ] );
		}

		return oldPts;

	}

	getTransformedSpacedPoints( [num segments, List bends = null] ) {

		var oldPts = getSpacedPoints( segments );

		var i, il;

		if (bends == null) {
			bends = _bends;
		}

		for ( i = 0; i < bends.length; i ++ ) {
			oldPts = this.getWrapPoints( oldPts, bends[ i ] );
		}

		return oldPts;
	}

	// This returns getPoints() bend/wrapped around the contour of a path.
	// Read http://www.planetclegg.com/projects/WarpingTextToSplines.html

	getWrapPoints( oldPts, path ) {

		var bounds = getBoundingBox();

		var i, il, p, oldX, oldY, xNorm;

		for ( i = 0; i < oldPts.length; i ++ ) {

			p = oldPts[ i ];

			oldX = p.x;
			oldY = p.y;

			xNorm = oldX / bounds.maxX;

			// If using actual distance, for length > path, requires line extrusions
			//xNorm = path.getUtoTmapping(xNorm, oldX); // 3 styles. 1) wrap stretched. 2) wrap stretch by arc length 3) warp by actual distance

			xNorm = path.getUtoTmapping( xNorm, oldX );

			// check for out of bounds?

			var pathPt = path.getPoint( xNorm );
			var normal = path.getNormalVector( xNorm ).scale( oldY );

			p.x = pathPt.x + normal.x;
			p.y = pathPt.y + normal.y;

		}

		return oldPts;

	}
}
