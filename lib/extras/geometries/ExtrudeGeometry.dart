part of three;

/**
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Creates extruded geometry from a path shape.
 *
 * parameters = {
 *
 *  size:       <float>,  // size of the text
 *  height:     <float>,  // thickness to extrude text
 *  curveSegments:  <int>,    // number of points on the curves
 *  steps:      <int> | <List>,    // number of points or list of U positions for z-side extrusions / used for subdividing segements of extrude spline too
 *  amount: <int>,  // Amount
 *
 *  bevelEnabled: <bool>,     // turn on bevel
 *  bevelThickness: <float>,    // how deep into text bevel goes
 *  bevelSize:    <float>,    // how far from text outline is bevel
 *  bevelSegments:  <int>,      // number of bevel layers
 *
 *  extrudePath:  <THREE.CurvePath> // 2d/3d spline path to extrude shape orthogonality to
 *  frames: <THREE.TubeGeometry.FrenetFrames> // containing arrays of tangents, normals, binormals
 *
 *  bendPath:   <THREE.CurvePath>   // 2d path for bend the shape around x/y plane
 *
 *  material:    <int>  // material index for front and back faces
 *  extrudeMaterial: <int>  // material index for extrusion and beveled faces
 *
 *  }
  **/

class ExtrudeGeometry extends Geometry {

  List shapes;

  var shapebb;

  ExtrudeGeometry( this.shapes,
                  {
                    amount: 100,
                    bevelThickness: 6.0,
                    bevelSize: null,
                    bevelSegments: 3,
                    bevelEnabled: true,
                    curveSegments: 12,
                    steps: 1, //can assume a number of steps or a List with all U's of steps
                    bendPath,
                    extrudePath,
                    frames,
                    material,
                    extrudeMaterial } ) : super() {

    if (bevelSize == null) bevelSize = bevelThickness - 2.0;

    if (shapes == null) {
      shapes = [];
      return;
    }

    shapebb = shapes.last.getBoundingBox();

    addShapeList( shapes,
      amount, bevelThickness, bevelSize, bevelSegments,bevelEnabled,
      curveSegments, steps, bendPath, extrudePath, frames, material, extrudeMaterial );

    computeCentroids();
    computeFaceNormals();

    // can't really use automatic vertex normals
    // as then front and back sides get smoothed too
    // should do separate smoothing just for sides

    //this.computeVertexNormals();

    //console.log( "took", ( Date.now() - startTime ) );

  }



  addShapeList(shapes, amount, bevelThickness, bevelSize, bevelSegments,bevelEnabled,
               curveSegments,steps,bendPath,extrudePath,frames,material, extrudeMaterial) {
    var sl = shapes.length;

    for ( var s = 0; s < sl; s ++ ) {
      var shape = shapes[ s ];
      addShape( shape, amount, bevelThickness, bevelSize, bevelSegments,bevelEnabled,
                curveSegments, steps, bendPath, extrudePath, frames, material, extrudeMaterial );
    }
  }

  // addShape Helpers
  _scalePt2 ( Vector2 pt, Vector2 vec, num size ) {
    if ( vec == null ) print( "die" );
    return vec.clone().scale( size ).add( pt );
  }

  _getBevelVec2( Vector2 pt_i, Vector2 pt_j, Vector2 pt_k ) {

    var a = ExtrudeGeometry.__v1,
      b = ExtrudeGeometry.__v2,
      v_hat = ExtrudeGeometry.__v3,
      w_hat = ExtrudeGeometry.__v4,
      p = ExtrudeGeometry.__v5,
      q = ExtrudeGeometry.__v6,
      v, w,
      v_dot_w_hat, q_sub_p_dot_w_hat,
      s, intersection;

    // good reading for line-line intersection
    // http://sputsoft.com/blog/2010/03/line-line-intersection.html

    // define a as vector j->i
    // define b as vectot k->i

    a.setValues( pt_i.x - pt_j.x, pt_i.y - pt_j.y );
    b.setValues( pt_i.x - pt_k.x, pt_i.y - pt_k.y );

    // get unit vectors

    v = a.normalize();
    w = b.normalize();

    // normals from pt i

    v_hat.setValues( -v.y, v.x );
    w_hat.setValues( w.y, -w.x );

    // pts from i

    p.setFrom( pt_i ).add( v_hat );
    q.setFrom( pt_i ).add( w_hat );

    if ( p.x == q.x && p.y == q.y) { // TODO add vector_math ".equals(p, q)"

      //console.log("Warning: lines are straight");
      return w_hat.clone();

    }

    // Points from j, k. helps prevents points cross overover most of the time

    p.setFrom( pt_j ).add( v_hat );
    q.setFrom( pt_k ).add( w_hat );

    v_dot_w_hat = v.dot( w_hat );
    q_sub_p_dot_w_hat = q.sub( p ).dot( w_hat );

    // We should not reach these conditions

    if ( v_dot_w_hat == 0 ) {

      print( "Either infinite or no solutions!" );

      if ( q_sub_p_dot_w_hat == 0 ) {

        print( "Its finite solutions." );

      } else {

        print( "Too bad, no solutions." );

      }

    }

    s = q_sub_p_dot_w_hat / v_dot_w_hat;

    if ( s < 0 ) {

      // in case of emergecy, revert to algorithm 1.

      return _getBevelVec1( pt_i, pt_j, pt_k );

    }

    intersection = v.scale( s ).add( p );

    return intersection.sub( pt_i ).clone(); // Don't normalize!, otherwise sharp corners become ugly

  }


  static var RAD_TO_DEGREES = 180 / Math.PI;


// Algorithm 2
  _getBevelVec( pt_i, pt_j, pt_k ) => _getBevelVec2( pt_i, pt_j, pt_k );

  _getBevelVec1( pt_i, pt_j, pt_k ) {

    var anglea = Math.atan2( pt_j.y - pt_i.y, pt_j.x - pt_i.x );
    var angleb = Math.atan2( pt_k.y - pt_i.y, pt_k.x - pt_i.x );

    if ( anglea > angleb ) {

      angleb += Math.PI * 2;

    }

    var anglec = ( anglea + angleb ) / 2;


    //console.log('angle1', anglea * RAD_TO_DEGREES,'angle2', angleb * RAD_TO_DEGREES, 'anglec', anglec *RAD_TO_DEGREES);

    var x = - Math.cos( anglec );
    var y = - Math.sin( anglec );

    var vec = new Vector2( x, y ); //.normalize();

    return vec;

  }

    _v( x, y, z ) {
      vertices.add( new Vector3( x, y, z ) );
    }


    // TODO - This is a helper function to reverse a list added by nelsonsilva
   List _reverse(List list) {
      List reversed = [];
      var i = list.length;
      while (i > 0) {
        reversed.add(list[--i]);
      }
      return reversed;
   }

  addShape( Shape shape, amount, bevelThickness, bevelSize, bevelSegments, bevelEnabled,
            curveSegments, steps, bendPath, extrudePath, TubeGeometry frames, material, extrudeMaterial,
            {ExtrudeGeometryWorldUVGenerator UVGenerator }) {


    var extrudePts, extrudeByPath = false;

    //shapebb = shape.getBoundingBox();

    // set UV generator
    var uvgen = (UVGenerator!= null) ? UVGenerator : new ExtrudeGeometryWorldUVGenerator();

    TubeGeometry splineTube;
    Vector3 binormal, normal, position2;

    var nSteps = (steps is List)? steps.length : steps;

    if ( extrudePath != null ) {

      if(steps is List){
        List divisions = [0];
        divisions.addAll(steps);
        extrudePts = extrudePath.getUPoints(divisions);
      } else{
        extrudePts =  extrudePath.getSpacedPoints( steps );
      }

      extrudeByPath = true;
      bevelEnabled = false; // bevels not supported for path extrusion

      // SETUP TNB variables

      // Reuse TNB from TubeGeomtry for now.
      // TODO1 - have a .isClosed in spline?
      splineTube = (frames != null) ? frames : new TubeGeometry.FrenetFrames(extrudePath, steps, false);

      // console.log(splineTube, 'splineTube', splineTube.normals.length, 'steps', steps, 'extrudePts', extrudePts.length);

      binormal = new Vector3.zero();
      normal = new Vector3.zero();
      position2 = new Vector3.zero();

    }

    // Safeguards if bevels are not enabled

    if ( ! bevelEnabled ) {

      bevelSegments = 0;
      bevelThickness = 0;
      bevelSize = 0;

    }

    // Variables initalization

    List<Vector2> ahole;
    var h, hl; // looping of holes

    var bevelPoints = [];

    var shapesOffset = this.vertices.length;

    if ( bendPath != null ) {

      shape.addWrapPath( bendPath );

    }

    var shapePoints = shape.extractPoints();

    List vertices = shapePoints["shape"];
    List<List<Vector2>> holes = shapePoints["holes"];

    var reverse = !ShapeUtils.isClockWise( vertices ) ;

    if ( reverse ) {

      vertices = _reverse(vertices);

      // Maybe we should also check if holes are in the opposite direction, just to be safe ...

      for ( h = 0; h < holes.length; h ++ ) {

        ahole = holes[ h ];

        if ( ShapeUtils.isClockWise( ahole ) ) {

          holes[ h ] = _reverse(ahole);

        }

      }

      reverse = false; // If vertices are in order now, we shouldn't need to worry about them again (hopefully)!

    }



    var faces = ShapeUtils.triangulateShape ( vertices, holes );
    //var faces = THREE.Shape.Utils.triangulate2( vertices, holes );

    // Would it be better to move points after triangulation?
    // shapePoints = shape.extractAllPointsWithBend( curveSegments, bendPath );
    //  vertices = shapePoints.shape;
    //  holes = shapePoints.holes;

    //console.log(faces);

    ////
    ///   Handle Vertices
    ////

    var contour = vertices; // vertices has all points but contour has only points of circumference

    for ( h = 0;  h < holes.length; h ++ ) {

      ahole = holes[ h ];

      vertices = new List.from(vertices);
      vertices.addAll( ahole );

    }


    var b, bs, t, z,
      vert, vlen = vertices.length,
      face, flen = faces.length,
      cont, clen = contour.length;


    //------
    // Find directions for point movement
    //



    var contourMovements = new List(contour.length);

    num i = 0,
        il = contour.length,
        j = il - 1,
        k = i + 1;
    for ( i = 0; i < il; i ++ ) {

      if ( j == il ) j = 0;
      if ( k == il ) k = 0;

      //  (j)---(i)---(k)
      // console.log('i,j,k', i, j , k)

      var pt_i = contour[ i ];
      var pt_j = contour[ j ];
      var pt_k = contour[ k ];

      contourMovements[ i ]= _getBevelVec( contour[ i ], contour[ j ], contour[ k ] );
      j ++; k ++;
    }

    List  holesMovements = [],
          oneHoleMovements,
          verticesMovements = new List.from(contourMovements);

    for ( h = 0; h < holes.length; h ++ ) {

      ahole = holes[ h ];

      oneHoleMovements = new List(ahole.length);

      i = 0;
      il = ahole.length;
      j = il - 1;
      k = i + 1;

      for ( i = 0; i < il; i++) {

        if ( j == il ) j = 0;
        if ( k == il ) k = 0;

        //  (j)---(i)---(k)
        oneHoleMovements[ i ]= _getBevelVec( ahole[ i ], ahole[ j ], ahole[ k ] );
        j++;
        k++;
      }

      holesMovements.add( oneHoleMovements );
      verticesMovements.addAll( oneHoleMovements );

    }


    // Loop bevelSegments, 1 for the front, 1 for the back

    for ( b = 0; b < bevelSegments; b ++ ) {
    //for ( b = bevelSegments; b > 0; b -- ) {

      t = b / bevelSegments;
      z = bevelThickness * ( 1 - t );

      //z = bevelThickness * t;
      bs = bevelSize * ( Math.sin ( t * Math.PI/2 ) ) ; // curved
      //bs = bevelSize * t ; // linear

      // contract shape

      for ( i = 0; i < contour.length; i ++ ) {

        vert = _scalePt2( contour[ i ], contourMovements[ i ], bs );
        //vert = scalePt( contour[ i ], contourCentroid, bs, false );
        _v( vert.x, vert.y,  - z );

      }

      // expand holes

      for ( h = 0; h < holes.length; h++ ) {

        ahole = holes[ h ];
        oneHoleMovements = holesMovements[ h ];

        for ( i = 0; i < ahole.length; i++ ) {

          vert = _scalePt2( ahole[ i ], oneHoleMovements[ i ], bs );
          //vert = scalePt( ahole[ i ], holesCentroids[ h ], bs, true );

          _v( vert.x, vert.y,  -z );

        }

      }

    }


    bs = bevelSize;

    // Back facing vertices

    for ( i = 0; i < vlen; i ++ ) {

      vert = bevelEnabled ? _scalePt2( vertices[ i ], verticesMovements[ i ], bs ) : vertices[ i ];

      if ( !extrudeByPath ) {

        _v( vert.x, vert.y, 0.0 );

      } else {

        // v( vert.x, vert.y + extrudePts[ 0 ].y, extrudePts[ 0 ].x );

        normal.setFrom(splineTube.normals[0]).scale(vert.x);
        binormal.setFrom(splineTube.binormals[0]).scale(vert.y);

        position2.setFrom(extrudePts[0]).add(normal).add(binormal);

        _v(position2.x, position2.y, position2.z);

      }

    }

    // Add stepped vertices...
    // Including front facing vertices

    var s;

    for ( s = 1; s <= nSteps; s ++ ) {

      for ( i = 0; i < vlen; i ++ ) {

        vert = bevelEnabled ? _scalePt2( vertices[ i ], verticesMovements[ i ], bs ) : vertices[ i ];

        if ( !extrudeByPath ) {

          _v( vert.x, vert.y, amount / nSteps * s );

        } else {

          // v( vert.x, vert.y + extrudePts[ s - 1 ].y, extrudePts[ s - 1 ].x );

          normal.setFrom(splineTube.normals[s]).scale(vert.x);
          binormal.setFrom(splineTube.binormals[s]).scale(vert.y);

          position2.setFrom(extrudePts[s]).add(normal).add(binormal);

          _v(position2.x, position2.y, position2.z );

        }

      }

    }


    // Add bevel segments planes

    //for ( b = 1; b <= bevelSegments; b ++ ) {
    for ( b = bevelSegments - 1; b >= 0; b -- ) {

      t = b / bevelSegments;
      z = bevelThickness * ( 1 - t );
      //bs = bevelSize * ( 1-Math.sin ( ( 1 - t ) * Math.PI/2 ) );
      bs = bevelSize * Math.sin ( t * Math.PI/2 ) ;

      // contract shape

      for ( i = 0; i < contour.length; i ++ ) {

        vert = _scalePt2( contour[ i ], contourMovements[ i ], bs );
        _v( vert.x, vert.y,  amount + z );

      }

      // expand holes

      for ( h = 0; h < holes.length; h ++ ) {

        ahole = holes[ h ];
        oneHoleMovements = holesMovements[ h ];

        for ( i = 0; i < ahole.length; i++ ) {

          vert = _scalePt2( ahole[ i ], oneHoleMovements[ i ], bs );

          if ( !extrudeByPath ) {

            _v( vert.x, vert.y,  amount + z );

          } else {

            _v( vert.x, vert.y + extrudePts[ nSteps - 1 ].y, extrudePts[ nSteps - 1 ].x + z );

          }

        }

      }

    }


    ////
    ///   Handle Faces
    ////

  /////  Internal functions

    f3( a, b, c, isBottom ) {
      a += shapesOffset;
      b += shapesOffset;
      c += shapesOffset;

      // normal, color, material
      this.faces.add( new Face3( a, b, c, null, null, material ) );

      var uvs = isBottom ? uvgen.generateBottomUV( this, shape, null, a, b, c)
                         : uvgen.generateTopUV( this, shape, null, a, b, c);

      this.faceVertexUvs[ 0 ].add(uvs);
    }

    f4( a, b, c, d, wallContour, stepIndex, stepsLength ) {
      a += shapesOffset;
      b += shapesOffset;
      c += shapesOffset;
      d += shapesOffset;

      this.faces.add( new Face4( a, b, c, d, null, null, extrudeMaterial ) );

      var uvs = uvgen.generateSideWallUV( this, shape, wallContour, null, a, b, c, d, stepIndex, stepsLength);
      this.faceVertexUvs[ 0 ].add(uvs);
    }

    // Top and bottom faces
    //buildLidFaces() {
    if ( bevelEnabled ) {

      var layer = 0 ; // steps + 1
      var offset = vlen * layer;

      // Bottom faces

      for ( i = 0; i < flen; i ++ ) {

        face = faces[ i ];
        f3( face[ 2 ]+ offset, face[ 1 ]+ offset, face[ 0 ] + offset, true );

      }

      layer = nSteps + bevelSegments * 2;
      offset = vlen * layer;

      // Top faces

      for ( i = 0; i < flen; i ++ ) {
        face = faces[ i ];
        f3( face[ 0 ] + offset, face[ 1 ] + offset, face[ 2 ] + offset, false );
      }
    } else {

      // Bottom faces

      for ( i = 0; i < flen; i++ ) {
        face = faces[ i ];
        f3( face[ 2 ], face[ 1 ], face[ 0 ], true );
      }

      // Top faces

      for ( i = 0; i < flen; i ++ ) {
        face = faces[ i ];
        f3( face[ 0 ] + vlen * nSteps, face[ 1 ] + vlen * nSteps, face[ 2 ] + vlen * nSteps, false );
      }
    }

    sidewalls( contour, layeroffset ) {
      var i, j, k;
      i = contour.length;

      while ( --i >= 0 ) {
        j = i;
        k = i - 1;
        if ( k < 0 ) k = contour.length - 1;

        //console.log('b', i,j, i-1, k,vertices.length);

        var s = 0, sl = nSteps  + bevelSegments * 2;

        for ( s = 0; s < sl; s ++ ) {
          var slen1 = vlen * s;
          var slen2 = vlen * ( s + 1 );
          var a = layeroffset + j + slen1,
            b = layeroffset + k + slen1,
            c = layeroffset + k + slen2,
            d = layeroffset + j + slen2;

          f4( a, b, c, d, contour, s, sl );
        }
      }
    }

    // Sides faces
    //buildSideFaces() {
    // Create faces for the z-sides of the shape
    var layeroffset = 0;
    sidewalls( contour, layeroffset );
    layeroffset += contour.length;

    for ( h = 0;  h < holes.length; h ++ ) {
      ahole = holes[ h ];
      sidewalls( ahole, layeroffset );

      //, true
      layeroffset += ahole.length;
    }
  }


  static Vector2 ___v1 = null; static get __v1 => (___v1 == null)? ___v1 = new Vector2.zero() : ___v1;
  static Vector2 ___v2 = null; static get __v2 => (___v2 == null)? ___v2 = new Vector2.zero() : ___v2;
  static Vector2 ___v3 = null; static get __v3 => (___v3 == null)? ___v3 = new Vector2.zero() : ___v3;
  static Vector2 ___v4 = null; static get __v4 => (___v4 == null)? ___v4 = new Vector2.zero() : ___v4;
  static Vector2 ___v5 = null; static get __v5 => (___v5 == null)? ___v5 = new Vector2.zero() : ___v5;
  static Vector2 ___v6 = null; static get __v6 => (___v6 == null)? ___v6 = new Vector2.zero() : ___v6;
}

class ExtrudeGeometryWorldUVGenerator {
  generateTopUV( geometry, extrudedShape, extrudeOptions, indexA, indexB, indexC) {
    var ax = geometry.vertices[ indexA ].x,
      ay = geometry.vertices[ indexA ].y,

      bx = geometry.vertices[ indexB ].x,
      by = geometry.vertices[ indexB ].y,

      cx = geometry.vertices[ indexC ].x,
      cy = geometry.vertices[ indexC ].y;

    return [
      new UV( ax, 1 - ay ),
      new UV( bx, 1 - by ),
      new UV( cx, 1 - cy )
    ];
  }

  generateBottomUV( geometry, extrudedShape, extrudeOptions, indexA, indexB, indexC) {
    return generateTopUV( geometry, extrudedShape, extrudeOptions, indexA, indexB, indexC );
  }

  generateSideWallUV( geometry, extrudedShape, wallContour, extrudeOptions,
                                indexA, indexB, indexC, indexD, stepIndex, stepsLength) {
    var ax = geometry.vertices[ indexA ].x,
      ay = geometry.vertices[ indexA ].y,
      az = geometry.vertices[ indexA ].z,

      bx = geometry.vertices[ indexB ].x,
      by = geometry.vertices[ indexB ].y,
      bz = geometry.vertices[ indexB ].z,

      cx = geometry.vertices[ indexC ].x,
      cy = geometry.vertices[ indexC ].y,
      cz = geometry.vertices[ indexC ].z,

      dx = geometry.vertices[ indexD ].x,
      dy = geometry.vertices[ indexD ].y,
      dz = geometry.vertices[ indexD ].z;

    if ( ( ay - by ).abs() < 0.01 ) {
      return [
        new UV( ax, az ),
        new UV( bx, bz ),
        new UV( cx, cz ),
        new UV( dx, dz )
      ];
    } else {
      return [
        new UV( ay, az ),
        new UV( by, bz ),
        new UV( cy, cz ),
        new UV( dy, dz )
      ];
    }
  }
}


