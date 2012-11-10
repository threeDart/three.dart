part of three;

/**
 * @author WestLangley / https://github.com/WestLangley
 * @author zz85 / https://github.com/zz85
 * @author miningold / https://github.com/miningold
 *
 * Modified from the TorusKnotGeometry by @oosmoxiecode
 *
 * Creates a tube which extrudes along a 3d spline
 *
 * Uses parallel transport frames as described in
 * http://www.cs.indiana.edu/pub/techreports/TR425.pdf
 */

class TubeGeometry extends Geometry {

  var path, segments;
  num nSegments, radius, segmentsRadius;
  bool closed;

  var grid;
  var tangents, normals, binormals;

  Object3D debug;

  TubeGeometry ( path, [segments = 64, this.radius = 1, this.segmentsRadius = 8, closed = false, bool debug])
    : grid = [], super() {

    if ( debug ) this.debug = new Object3D();

    var tangent,
        normal,
        binormal,

        numpoints = segments + 1,

        x, y, z,
        tx, ty, tz,
        u, v,

        cx, cy,
        pos, pos2 = new Vector3(),
        i, j,
        ip, jp,
        a, b, c, d,
        uva, uvb, uvc, uvd;

    var frames = _frenetFrames(path, segments, closed);

    // consruct the grid
    grid.length = numpoints;

    for ( i = 0; i < numpoints; i++ ) {

      grid[ i ] = new List(this.segmentsRadius);

      u = i / ( numpoints - 1 );

      pos = path.getPointAt( u );

      tangent = tangents[ i ];
      normal = normals[ i ];
      binormal = binormals[ i ];

      if ( debug ) {

        this.debug.add(new ArrowHelper(tangent, pos, radius, 0x0000ff));
        this.debug.add(new ArrowHelper(normal, pos, radius, 0xff0000));
        this.debug.add(new ArrowHelper(binormal, pos, radius, 0x00ff00));

      }

      for ( j = 0; j < this.segmentsRadius; j++ ) {

        v = j / this.segmentsRadius * 2 * Math.PI;

        cx = -this.radius * Math.cos( v ); // TODO: Hack: Negating it so it faces outside.
        cy = this.radius * Math.sin( v );

        pos2.copy( pos );
        pos2.x += cx * normal.x + cy * binormal.x;
        pos2.y += cx * normal.y + cy * binormal.y;
        pos2.z += cx * normal.z + cy * binormal.z;

        this.grid[ i ][ j ] = _vert( pos2.x, pos2.y, pos2.z );

      }
    }


    // construct the mesh

    for ( i = 0; i < this.nSegments; i++ ) {

      for ( j = 0; j < this.segmentsRadius; j++ ) {

        ip = ( closed ) ? (i + 1) % this.nSegments : i + 1;
        jp = (j + 1) % this.segmentsRadius;

        a = this.grid[ i ][ j ];    // *** NOT NECESSARILY PLANAR ! ***
        b = this.grid[ ip ][ j ];
        c = this.grid[ ip ][ jp ];
        d = this.grid[ i ][ jp ];

        uva = new UV( i / this.nSegments, j / this.segmentsRadius );
        uvb = new UV( ( i + 1 ) / this.nSegments, j / this.segmentsRadius );
        uvc = new UV( ( i + 1 ) / this.nSegments, ( j + 1 ) / this.segmentsRadius );
        uvd = new UV( i / this.nSegments, ( j + 1 ) / this.segmentsRadius );

        this.faces.add( new Face4( a, b, c, d ) );
        this.faceVertexUvs[ 0 ].add( [ uva, uvb, uvc, uvd ] );

      }
    }

    computeCentroids();
    computeFaceNormals();
    computeVertexNormals();

  }


  _vert( x, y, z ) {
    vertices.add( new Vector3(x, y, z) );
    return vertices.length - 1;
  }


  // FrenetFrames


  TubeGeometry.FrenetFrames(path, segments, closed) {
    _frenetFrames(path, segments, closed);
  }

// For computing of Frenet frames, exposing the tangents, normals and binormals the spline
  _frenetFrames(ppath, psegments, pclosed) {

    this.path = ppath;
    this.segments = psegments;

    this.closed = pclosed;

    var
      tangent = new Vector3(),
      normal = new Vector3(),
      binormal = new Vector3(),

      vec = new Vector3(),
      mat = new Matrix4(),
      theta,
      epsilon = 0.0001,
      smallest,

      tx, ty, tz,
      i, u, v;

    if(segments is num){
      var length = segments;
      segments = [];
        for ( i = 1; i <= length; i++ ) {
          segments.add( i / ( length ));
        }
    }
    this.nSegments = segments.length;
    var numpoints = this.nSegments + 1;

    // expose internals
    tangents = new List(numpoints);
    normals = new List(numpoints);
    binormals = new List(numpoints);

    // compute the tangent vectors for each segment on the path

    for ( i = 0; i < numpoints; i++ ) {
      tangents[ i ] = (i == 0)? path.getTangentAt( 0 ): path.getTangentAt( segments[i - 1] );
      tangents[ i ].normalize();
    }

    _initialNormal1([lastBinormal = null]) {
      // fixed start binormal. Has dangers of 0 vectors
      normals[ 0 ] = new Vector3();
      binormals[ 0 ] = new Vector3();
      if (lastBinormal==null) lastBinormal = new Vector3( 0, 0, 1 );
      normals[ 0 ].cross( lastBinormal, tangents[ 0 ] ).normalize();
      binormals[ 0 ].cross( tangents[ 0 ], normals[ 0 ] ).normalize();
    }

    _initialNormal2() {
      // This uses the Frenet-Serret formula for deriving binormal
      var t2 = path.getTangentAt( epsilon );

      normals[ 0 ] = new Vector3().sub( t2, tangents[ 0 ] ).normalize();
      binormals[ 0 ] = new Vector3().cross( tangents[ 0 ], normals[ 0 ] );

      normals[ 0 ].cross( binormals[ 0 ], tangents[ 0 ] ).normalize(); // last binormal x tangent
      binormals[ 0 ].cross( tangents[ 0 ], normals[ 0 ] ).normalize();

    }

    _initialNormal3() {
      // select an initial normal vector perpenicular to the first tangent vector,
      // and in the direction of the smallest tangent xyz component

      normals[ 0 ] = new Vector3();
      binormals[ 0 ] = new Vector3();
      smallest = double.INFINITY;
      tx = ( tangents[ 0 ].x ).abs();
      ty = ( tangents[ 0 ].y ).abs();
      tz = ( tangents[ 0 ].z ).abs();

      if ( tx <= smallest ) {
        smallest = tx;
        normal.setValues( 1, 0, 0 );
      }

      if ( ty <= smallest ) {
        smallest = ty;
        normal.setValues( 0, 1, 0 );
      }

      if ( tz <= smallest ) {
        normal.setValues( 0, 0, 1 );
      }

      vec.cross( tangents[ 0 ], normal ).normalize();

      normals[ 0 ].cross( tangents[ 0 ], vec );
      binormals[ 0 ].cross( tangents[ 0 ], normals[ 0 ] );
    }

    _initialNormal3();


    // compute the slowly-varying normal and binormal vectors for each segment on the path

    for ( i = 1; i < numpoints; i++ ) {

      normals[ i ] = normals[ i-1 ].clone();

      binormals[ i ] = binormals[ i-1 ].clone();

      vec.cross( tangents[ i-1 ], tangents[ i ] );

      if ( vec.length() > epsilon ) {

        vec.normalize();

        theta = Math.acos( tangents[ i-1 ].dot( tangents[ i ] ) );

        mat.makeRotationAxis( vec, theta ).multiplyVector3( normals[ i ] );

      }

      binormals[ i ].cross( tangents[ i ], normals[ i ] );

    }


    // if the curve is closed, postprocess the vectors so the first and last normal vectors are the same

    if ( closed ) {

      theta = Math.acos( normals[ 0 ].dot( normals[ numpoints-1 ] ) );
      theta /= ( numpoints - 1 );

      if ( tangents[ 0 ].dot( vec.cross( normals[ 0 ], normals[ numpoints-1 ] ) ) > 0 ) {

        theta = -theta;

      }

      for ( i = 1; i < numpoints; i++ ) {

        // twist a little...
        mat.makeRotationAxis( tangents[ i ], theta * i ).multiplyVector3( normals[ i ] );
        binormals[ i ].cross( tangents[ i ], normals[ i ] );

      }

    }
  }
}
