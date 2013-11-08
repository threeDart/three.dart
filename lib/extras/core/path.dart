part of three;

/**
 * @author zz85 / http://www.lab4games.net/zz85/blog
 * Creates free form 2d path using series of points, lines or curves.
 *
 **/

class PathAction {
	static const String MOVE_TO = 'moveTo';
	static const String LINE_TO = 'lineTo';
	static const String QUADRATIC_CURVE_TO = 'quadraticCurveTo';    // Bezier quadratic curve
	static const String BEZIER_CURVE_TO = 'bezierCurveTo';  		// Bezier cubic curve
	static const String CSPLINE_THRU = 'splineThru';				// Catmull-rom spline
	static const String ARC = 'arc';								// Circle
	static const String ELLIPSE = 'ellipse';

	String action;
	var args;

	PathAction(this.action, this.args);
}

class Path extends CurvePath {

  var useSpacedPoints = false;

  List _points;
  List<PathAction> actions;

	Path( [List points] ) : actions = [],  super(){
	  if (points != null) {
	    _fromPoints(points);
	  }
	}

  // Create path using straight lines to connect all points
  // - vectors: array of Vector2
  factory Path.fromPoints( vectors ) => new Path(vectors);

  _fromPoints( vectors ){
     moveTo( vectors[0].x, vectors[0].y );

     for ( var v = 1, vlen = vectors.length; v < vlen; v ++ ) {
       this.lineTo( vectors[ v ].x, vectors[ v ].y );
     }
  }

  addAction(String action, [var args]) => actions.add(new PathAction(action, args));



  // startPath() endPath()?
  moveTo( x, y ) => addAction( PathAction.MOVE_TO, [x, y] );

  lineTo( x, y ) {

  	var args = [x, y];

  	var lastargs = actions.last.args;

  	var x0 = lastargs[ lastargs.length - 2 ];
  	var y0 = lastargs[ lastargs.length - 1 ];

  	var curve = new LineCurve( new Vector2( x0, y0 ), new Vector2( x, y ) );
  	curves.add( curve );

  	addAction( PathAction.LINE_TO, args);
  }

  quadraticCurveTo( aCPx, aCPy, aX, aY ) {

  	var args = [aCPx, aCPy, aX, aY];

  	var lastargs = actions.last.args;

  	var x0 = lastargs[ lastargs.length - 2 ].toDouble();
  	var y0 = lastargs[ lastargs.length - 1 ].toDouble();

  	var curve = new QuadraticBezierCurve( new Vector2( x0, y0 ),
  												new Vector2( aCPx.toDouble(), aCPy.toDouble() ),
  												new Vector2( aX.toDouble(), aY.toDouble() ) );
  	curves.add( curve );

  	addAction( PathAction.QUADRATIC_CURVE_TO, args );
  }

  bezierCurveTo( aCP1x, aCP1y,
                 aCP2x, aCP2y,
                 aX, aY ) {

  	var args = [aCP1x, aCP1y,
                 aCP2x, aCP2y,
                 aX, aY];

  	var lastargs = actions.last.args;

  	var x0 = lastargs[ lastargs.length - 2 ].toDouble();
  	var y0 = lastargs[ lastargs.length - 1 ].toDouble();

  	var curve = new CubicBezierCurve( new Vector2( x0, y0 ),
  											new Vector2( aCP1x.toDouble(), aCP1y.toDouble() ),
  											new Vector2( aCP2x.toDouble(), aCP2y.toDouble() ),
  											new Vector2( aX.toDouble(), aY.toDouble() ) );
  	curves.add( curve );

  	addAction( PathAction.BEZIER_CURVE_TO, args );

  }

  splineThru( List<Vector2> pts) {

  	var args = [pts];
  	var lastargs = actions.last.args;

  	var x0 = lastargs[ lastargs.length - 2 ];
  	var y0 = lastargs[ lastargs.length - 1 ];
  //---
  	var npts = [ new Vector2( x0, y0 ) ];
  	npts.addAll(pts); //Array.prototype.push.apply( npts, pts );

  	var curve = new SplineCurve( npts );
  	curves.add( curve );

  	addAction( PathAction.CSPLINE_THRU, args);

  }

  // FUTURE: Change the API or follow canvas API?
  // TODO ARC ( x, y, x - radius, y - radius, startAngle, endAngle )

  arc( aX, aY, aRadius,
  								aStartAngle, aEndAngle, aClockwise ) {

    var lastargs = actions[ actions.length - 1].args;
    var x0 = lastargs[ lastargs.length - 2 ];
    var y0 = lastargs[ lastargs.length - 1 ];

    absarc(aX + x0, aY + y0, aRadius, aStartAngle, aEndAngle, aClockwise );

   }

  absarc( aX, aY, aRadius, aStartAngle, aEndAngle, aClockwise ) {

    absellipse(aX, aY, aRadius, aRadius, aStartAngle, aEndAngle, aClockwise);

   }

  ellipse( aX, aY, xRadius, yRadius, aStartAngle, aEndAngle, aClockwise ) {

    var lastargs = actions.last.args;
    var x0 = lastargs[ lastargs.length - 2 ];
    var y0 = lastargs[ lastargs.length - 1 ];

    absellipse(aX + x0, aY + y0, xRadius, yRadius, aStartAngle, aEndAngle, aClockwise );

  }

  absellipse( aX, aY, xRadius, yRadius, aStartAngle, aEndAngle, aClockwise ) {

    var args = [aX, aY, xRadius, yRadius, aStartAngle, aEndAngle, aClockwise];

    var curve = new EllipseCurve( aX, aY, xRadius, yRadius, aStartAngle, aEndAngle, aClockwise );
    curves.add( curve );

    var lastPoint = curve.getPoint(aClockwise ? 1 : 0);
    args.add(lastPoint.x);
    args.add(lastPoint.y);

    addAction(PathAction.ELLIPSE, args);

  }

  getSpacedPoints( [int divisions = 5, bool closedPath = false] ) {

  	if ( divisions == null ) divisions = 40;

  	var points = [];

  	for ( var i = 0; i < divisions; i ++ ) {

  		points.add( this.getPoint( i / divisions ) );

  		//if( !this.getPoint( i / divisions ) ) throw "DIE";

  	}

  	// if ( closedPath ) {
  	//
  	// 	points.push( points[ 0 ] );
  	//
  	// }

  	return points;

  }

  /* Return an array of vectors based on contour of the path */
  getPoints( [int divisions = null, closedPath = false] ) {

  	if (useSpacedPoints) {
  		return getSpacedPoints( divisions, closedPath );
  	}

  	if (divisions == null) divisions =  12;

  	List<Vector2> points = [];

  	var i, il, item, action, args;
  	var cpx, cpy, cpx2, cpy2, cpx1, cpy1, cpx0, cpy0,
  		laste, j,
  		t, tx, ty;

  	for ( i = 0; i < actions.length; i ++ ) {

  		item = actions[ i ];

  		action = item.action;
  		args = item.args;

  		switch( action ) {

  		case PathAction.MOVE_TO:

  			points.add( new Vector2( args[ 0 ], args[ 1 ] ) );

  			break;

  		case PathAction.LINE_TO:

  			points.add( new Vector2( args[ 0 ], args[ 1 ] ) );

  			break;

  		case PathAction.QUADRATIC_CURVE_TO:

  			cpx  = args[ 2 ];
  			cpy  = args[ 3 ];

  			cpx1 = args[ 0 ];
  			cpy1 = args[ 1 ];

  			if ( points.length > 0 ) {

  				laste = points[ points.length - 1 ];

  				cpx0 = laste.x;
  				cpy0 = laste.y;

  			} else {

  				laste = actions[ i - 1 ].args;

  				cpx0 = laste[ laste.length - 2 ];
  				cpy0 = laste[ laste.length - 1 ];

  			}

  			for ( j = 1; j <= divisions; j ++ ) {

  				t = j / divisions;

  				tx = ShapeUtils.b2( t, cpx0, cpx1, cpx );
  				ty = ShapeUtils.b2( t, cpy0, cpy1, cpy );

  				points.add( new Vector2( tx, ty ) );

  		  	}

  			break;

  		case PathAction.BEZIER_CURVE_TO:

  			cpx  = args[ 4 ];
  			cpy  = args[ 5 ];

  			cpx1 = args[ 0 ];
  			cpy1 = args[ 1 ];

  			cpx2 = args[ 2 ];
  			cpy2 = args[ 3 ];

  			if ( points.length > 0 ) {

  				laste = points[ points.length - 1 ];

  				cpx0 = laste.x;
  				cpy0 = laste.y;

  			} else {

  				laste = actions[ i - 1 ].args;

  				cpx0 = laste[ laste.length - 2 ];
  				cpy0 = laste[ laste.length - 1 ];

  			}


  			for ( j = 1; j <= divisions; j ++ ) {

  				t = j / divisions;

  				tx = ShapeUtils.b3( t, cpx0, cpx1, cpx2, cpx );
  				ty = ShapeUtils.b3( t, cpy0, cpy1, cpy2, cpy );

  				points.add( new Vector2( tx, ty ) );

  			}

  			break;

  		case PathAction.CSPLINE_THRU:

  			laste = actions[ i - 1 ].args;

  			var last = new Vector2( laste[ laste.length - 2 ], laste[ laste.length - 1 ] );
  			var spts = [ last ];

  			var n = divisions * args[ 0 ].length;

  			spts.addAll( args[ 0 ] );

  			var spline = new SplineCurve( spts );

  			for ( j = 1; j <= n; j ++ ) {

  				points.add( spline.getPointAt( j / n ) ) ;

  			}

  			break;

  		case PathAction.ARC:

  			laste = actions[ i - 1 ].args;

  			var aX = args[ 0 ], aY = args[ 1 ],
  				aRadius = args[ 2 ],
  				aStartAngle = args[ 3 ], aEndAngle = args[ 4 ],
  				aClockwise = !!args[ 5 ];


  			var deltaAngle = aEndAngle - aStartAngle;
  			var angle;
  			var tdivisions = divisions * 2;

  			for ( j = 1; j <= tdivisions; j ++ ) {

  				t = j / tdivisions;

  				if ( ! aClockwise ) {

  					t = 1 - t;

  				}

  				angle = aStartAngle + t * deltaAngle;

  				tx = aX + aRadius * Math.cos( angle );
  				ty = aY + aRadius * Math.sin( angle );

  				//console.log('t', t, 'angle', angle, 'tx', tx, 'ty', ty);

  				points.add( new Vector2( tx, ty ) );

  			}

  			//console.log(points);

  		  break;

  		case PathAction.ELLIPSE:

        var aX = args[ 0 ], aY = args[ 1 ],
        xRadius = args[ 2 ],
        yRadius = args[ 3 ],
        aStartAngle = args[ 4 ], aEndAngle = args[ 5 ],
        aClockwise = !!args[ 6 ];


      var deltaAngle = aEndAngle - aStartAngle;
      var angle;
      var tdivisions = divisions * 2;

      for ( j = 1; j <= tdivisions; j ++ ) {

        t = j / tdivisions;

        if ( ! aClockwise ) {

          t = 1 - t;

        }

        angle = aStartAngle + t * deltaAngle;

        tx = aX + xRadius * Math.cos( angle );
        ty = aY + yRadius * Math.sin( angle );

        //console.log('t', t, 'angle', angle, 'tx', tx, 'ty', ty);

        points.add( new Vector2( tx, ty ) );

      }

      //console.log(points);

      break;
  		} // end switch

  	}



  	// Normalize to remove the closing point by default.
  	var lastPoint = points[ points.length - 1];
  	var EPSILON = 0.0000000001;
  	if ( (lastPoint.x - points[ 0 ].x).abs() < EPSILON &&
          (lastPoint.y - points[ 0 ].y).abs() < EPSILON) {
  	  points.removeLast();
  	}
  	if ( closedPath ) {
  		points.add( points[ 0 ] );
  	}

  	return points;

  }



  // This was used for testing purposes. Should be removed soon.
  transform ( path, segments ) {

  	var bounds = getBoundingBox();
  	var oldPts = getPoints( segments ); // getPoints getSpacedPoints

  	//console.log( path.cacheArcLengths() );
  	//path.getLengths(400);
  	//segments = 40;

  	return getWrapPoints( oldPts, path );

  }

  // Breaks path into shapes
  toShapes() {

  	var i, il, item, action, args;

  	List<Path> subPaths = [];
  	var lastPath = new Path();

  	for ( i = 0; i < actions.length; i ++ ) {

  		item = actions[ i ];

  		args = item.args;
  		action = item.action;

  		if ( action == PathAction.MOVE_TO ) {

  			if ( lastPath.actions.length != 0 ) {

  				subPaths.add( lastPath );
  				lastPath = new Path();

  			}

  		}

  		lastPath._applyAction( action, args);

  	}

  	if ( lastPath.actions.length != 0 ) {

  		subPaths.add( lastPath );

  	}

  	// console.log(subPaths);

  	if ( subPaths.length == 0 ) return [];

  	var tmpPath;
  	Shape tmpShape;
  	List<Shape> shapes = [];

  	var holesFirst = !ShapeUtils.isClockWise( subPaths[ 0 ].getPoints() );
  	// console.log("Holes first", holesFirst);

  	if ( subPaths.length == 1) {
  		tmpPath = subPaths[0];
  		tmpShape = new Shape();
  		tmpShape.actions = tmpPath.actions;
  		tmpShape.curves = tmpPath.curves;
  		shapes.add( tmpShape );
  		return shapes;
  	};

  	if ( holesFirst ) {

  		tmpShape = new Shape();

  		for ( i = 0; i < subPaths.length; i ++ ) {

  			tmpPath = subPaths[ i ];

  			if ( ShapeUtils.isClockWise( tmpPath.getPoints() ) ) {

  				tmpShape.actions = tmpPath.actions;
  				tmpShape.curves = tmpPath.curves;

  				shapes.add( tmpShape );
  				tmpShape = new Shape();

  				//console.log('cw', i);

  			} else {

  				tmpShape.holes.add( tmpPath );

  				//console.log('ccw', i);

  			}

  		}

  	} else {

  		// Shapes first

  		for ( i = 0; i < subPaths.length; i ++ ) {

  			tmpPath = subPaths[ i ];

  			if ( ShapeUtils.isClockWise( tmpPath.getPoints() ) ) {


  				if (tmpShape != null) shapes.add( tmpShape );

  				tmpShape = new Shape();
  				tmpShape.actions = tmpPath.actions;
  				tmpShape.curves = tmpPath.curves;

  			} else {

  				tmpShape.holes.add( tmpPath );

  			}

  		}

  		shapes.add( tmpShape );

  	}

  	//console.log("shape", shapes);

  	return shapes;

  }


  // TODO(nelsonsilva) - Come up with a better way to invoke the action
  _applyAction( action, args) {
    switch (action) {
      case PathAction.MOVE_TO:
        moveTo(args[0], args[1]);
        break;
      case PathAction.LINE_TO:
        lineTo(args[0], args[1]);
        break;
      case PathAction.QUADRATIC_CURVE_TO:
        quadraticCurveTo(args[0], args[1], args[2], args[3]);
        break;
      case PathAction.BEZIER_CURVE_TO:
        bezierCurveTo(args[0], args[1], args[2], args[3], args[4], args[5]);
        break;
      case PathAction.CSPLINE_THRU:
        splineThru(args[0]);
        break;
      case PathAction.ARC:
        arc(args[0], args[1], args[2], args[3], args[4], args[5]);
        break;
      case PathAction.ELLIPSE:
        ellipse(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
        break;
    }
  }
}