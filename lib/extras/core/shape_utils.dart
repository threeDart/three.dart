/**************************************************************
 *  Utils
 **************************************************************/
library ShapeUtils;

import "package:three/three.dart";
import 'package:three/extras/font_utils.dart' as FontUtils;

/*
  contour - array of vector2 for contour
  holes   - array of array of vector2
*/
removeHoles( List<Vector2> contour, List<List<Vector2>>holes ) {

  var shape = new List.from(contour); // work on this shape
  var allpoints = new List.from(shape);

  /* For each isolated shape, find the closest points and break to the hole to allow triangulation */


  var prevShapeVert, nextShapeVert,
    prevHoleVert, nextHoleVert;

  int holeIndex, shapeIndex;

  var shapeId, shapeGroup,
    h, h2,
    hole, shortest, d,
    p, pts1, pts2,
    tmpShape1, tmpShape2,
    tmpHole1, tmpHole2,
    verts = [];

  for ( h = 0; h < holes.length; h ++ ) {

    hole = holes[ h ];

    /*
    shapeholes[ h ].concat(); // preserves original
    holes.push( hole );
    */

    allpoints.addAll(hole); //Array.prototype.push.apply( allpoints, hole );

    shortest = double.INFINITY;


    // Find the shortest pair of pts between shape and hole

    // Note: Actually, I'm not sure now if we could optimize this to be faster than O(m*n)
    // Using distanceToSquared() intead of distanceTo() should speed a little
    // since running square roots operations are reduced.

    for ( h2 = 0; h2 < hole.length; h2 ++ ) {

      pts1 = hole[ h2 ];
      var dist = [];

      for ( p = 0; p < shape.length; p++ ) {

        pts2 = shape[ p ];
        d = pts1.distanceToSquared( pts2 );
        dist.add( d );

        if ( d < shortest ) {

          shortest = d;
          holeIndex = h2;
          shapeIndex = p;

        }

      }

    }

    //console.log("shortest", shortest, dist);

    prevShapeVert = ( shapeIndex - 1 ) >= 0 ? shapeIndex - 1 : shape.length - 1;
    prevHoleVert = ( holeIndex - 1 ) >= 0 ? holeIndex - 1 : hole.length - 1;

    var areaapts = [

      hole[ holeIndex ],
      shape[ shapeIndex ],
      shape[ prevShapeVert ]

    ];

    var areaa = FontUtils.area( areaapts );

    var areabpts = [

      hole[ holeIndex ],
      hole[ prevHoleVert ],
      shape[ shapeIndex ]

    ];

    var areab = FontUtils.area( areabpts );

    var shapeOffset = 1;
    var holeOffset = -1;

    var oldShapeIndex = shapeIndex, oldHoleIndex = holeIndex;
    shapeIndex += shapeOffset;
    holeIndex += holeOffset;

    if ( shapeIndex < 0 ) { shapeIndex += shape.length;  }
    shapeIndex %= shape.length;

    if ( holeIndex < 0 ) { holeIndex += hole.length;  }
    holeIndex %= hole.length;

    prevShapeVert = ( shapeIndex - 1 ) >= 0 ? shapeIndex - 1 : shape.length - 1;
    prevHoleVert = ( holeIndex - 1 ) >= 0 ? holeIndex - 1 : hole.length - 1;

    areaapts = [

      hole[ holeIndex ],
      shape[ shapeIndex ],
      shape[ prevShapeVert ]

    ];

    var areaa2 = FontUtils.area( areaapts );

    areabpts = [

      hole[ holeIndex ],
      hole[ prevHoleVert ],
      shape[ shapeIndex ]

    ];

    var areab2 = FontUtils.area( areabpts );
    //console.log(areaa,areab ,areaa2,areab2, ( areaa + areab ),  ( areaa2 + areab2 ));

    if ( ( areaa + areab ) > ( areaa2 + areab2 ) ) {

      // In case areas are not correct.
      //console.log("USE THIS");

      shapeIndex = oldShapeIndex;
      holeIndex = oldHoleIndex ;

      if ( shapeIndex < 0 ) { shapeIndex += shape.length;  }
      shapeIndex %= shape.length;

      if ( holeIndex < 0 ) { holeIndex += hole.length;  }
      holeIndex %= hole.length;

      prevShapeVert = ( shapeIndex - 1 ) >= 0 ? shapeIndex - 1 : shape.length - 1;
      prevHoleVert = ( holeIndex - 1 ) >= 0 ? holeIndex - 1 : hole.length - 1;

    } else {

      //console.log("USE THAT ")

    }

    tmpShape1 = shape.getRange( 0, shapeIndex );
    tmpShape2 = shape.getRange( shapeIndex, shape.length - shapeIndex );
    tmpHole1 = hole.getRange( holeIndex, hole.length - holeIndex );
    tmpHole2 = hole.getRange( 0, holeIndex );

    // Should check orders here again?

    var trianglea = [

      hole[ holeIndex ],
      shape[ shapeIndex ],
      shape[ prevShapeVert ]

    ];

    var triangleb = [

      hole[ holeIndex ] ,
      hole[ prevHoleVert ],
      shape[ shapeIndex ]

    ];

    verts.add( trianglea );
    verts.add( triangleb );

    shape = [];
    shape.addAll(tmpShape1);
    shape.addAll(tmpHole1 );
    shape.addAll( tmpHole2 );
    shape.addAll( tmpShape2 );

  }

  return {

    "shape":shape,    /* shape with no holes */
    "isolatedPts": verts, /* isolated faces */
    "allpoints": allpoints

  };


}

triangulateShape( contour, holes ) {

  var shapeWithoutHoles = removeHoles( contour, holes );

  var shape = shapeWithoutHoles["shape"],
    allpoints = shapeWithoutHoles["allpoints"],
    isolatedPts = shapeWithoutHoles["isolatedPts"];

  var triangles = FontUtils.process( shape, false ); // True returns indices for points of spooled shape

  // To maintain reference to old shape, one must match coordinates, or offset the indices from original arrays. It's probably easier to do the first.

  //console.log( "triangles",triangles, triangles.length );
  //console.log( "allpoints",allpoints, allpoints.length );

  var i, il, f, face,
    key, index,
    allPointsMap = {},
    isolatedPointsMap = {};

  // prepare all points map

  for ( i = 0; i < allpoints.length; i ++ ) {

    key = "${allpoints[ i ].x}:${allpoints[ i ].y}";

    if ( allPointsMap.containsKey(key)) {

      print( "Duplicate point $key" );

    }

    allPointsMap[ key ] = i;

  }

  // check all face vertices against all points map

  for ( i = 0; i < triangles.length; i ++ ) {

    face = triangles[ i ];

    for ( f = 0; f < 3; f ++ ) {

      key = "${face[ f ].x}:${face[ f ].y}";

      if ( allPointsMap.containsKey(key) ) {

        face[ f ] = allPointsMap[key];

      }

    }

  }

  // check isolated points vertices against all points map

  for ( i = 0; i < isolatedPts.length; i ++ ) {

    face = isolatedPts[ i ];

    for ( f = 0; f < 3; f ++ ) {

      key = "${face[ f ].x}:${face[ f ].y}";

      if ( allPointsMap.containsKey(key)) {

        face[ f ] = allPointsMap[key];

      }

    }

  }

  triangles.addAll( isolatedPts );
  return triangles;

}

isClockWise( pts ) => FontUtils.area( pts ) < 0;


// Bezier Curves formulas obtained from
// http://en.wikipedia.org/wiki/B%C3%A9zier_curve

// Quad Bezier Functions

b2p0( t, p ) {

  var k = 1 - t;
  return k * k * p;

}

b2p1( t, p ) =>  2 * ( 1 - t ) * t * p;

b2p2( t, p ) => t * t * p;

b2( t, p0, p1, p2 ) => b2p0( t, p0 ) + b2p1( t, p1 ) + b2p2( t, p2 );



// Cubic Bezier Functions

b3p0( t, p ) {
  var k = 1 - t;
  return k * k * k * p;
}

b3p1( t, p ) {

  var k = 1 - t;
  return 3 * k * k * t * p;

}

b3p2( t, p ) {

  var k = 1 - t;
  return 3 * k * t * t * p;

}

b3p3 ( t, p ) => t * t * t * p;


b3( t, p0, p1, p2, p3 ) => b3p0( t, p0 ) + b3p1( t, p1 ) + b3p2( t, p2 ) + b3p3( t, p3 );

