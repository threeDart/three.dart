part of three;

class PolyhedronGeometry extends Geometry {

  List _midpoints;

  // nelsonsilva - We're using a PolyhedronGeometryVertex decorator to allow adding index and uv properties
  List<PolyhedronGeometryVertex> _p = [];

  PolyhedronGeometry(List<List<num>> lvertices, List<List<num>> lfaces, [double radius = 1.0, num detail = 0]) : super() {

    _midpoints = [];

    lvertices.forEach( (vertex) {
      _prepare( new PolyhedronGeometryVertex(vertex[ 0 ], vertex[ 1 ], vertex[ 2 ]));
    });

    lfaces.forEach((face) => _make( _p[ face[ 0 ] ], _p[ face[ 1 ] ], _p[ face[ 2 ] ], detail ));

    // TODO No need to unwrap ? (now unwrapp and add the original Vector3 to the vertices)
    _p.forEach((v) => this.vertices.add(v));

    mergeVertices();

    // Apply radius

    this.vertices.forEach((Vector3 vertex) => vertex.scale( radius ));

    computeCentroids();

    boundingSphere = new BoundingSphere(radius: radius);

  }

  // Project vector onto sphere's surface
  PolyhedronGeometryVertex _prepare( PolyhedronGeometryVertex vertex) {

    vertex.normalize();
    _p.add( vertex );
    vertex.index = _p.length - 1;

    // Texture coords are equivalent to map coords, calculate angle and convert to fraction of a circle.

    var u = _azimuth( vertex ) / 2 / Math.PI + 0.5;
    var v = _inclination( vertex ) / Math.PI + 0.5;
    vertex.uv = new UV( u, 1 - v );

    return vertex;

  }


  // Approximate a curved face with recursively sub-divided triangles.

  _make( PolyhedronGeometryVertex v1, PolyhedronGeometryVertex v2, PolyhedronGeometryVertex v3, detail ) {

    if ( detail < 1 ) {

      var face = new Face3( v1.index, v2.index, v3.index, [ v1.clone(), v2.clone(), v3.clone() ] );
      face.centroid.add( v1 ).add( v2 ).add( v3 ).scale( 1.0 / 3.0 );
      face.normal = face.centroid.clone().normalize();
      this.faces.add( face );

      var azi = _azimuth( face.centroid );
      this.faceVertexUvs[ 0 ].add( [
                                     _correctUV( v1.uv, v1, azi ),
                                     _correctUV( v2.uv, v2, azi ),
                                     _correctUV( v3.uv, v3, azi )
                                     ] );

    } else {

      detail -= 1;

      // split triangle into 4 smaller triangles

      _make( v1, _midpoint( v1, v2 ), _midpoint( v1, v3 ), detail ); // top quadrant
      _make( _midpoint( v1, v2 ), v2, _midpoint( v2, v3 ), detail ); // left quadrant
      _make( _midpoint( v1, v3 ), _midpoint( v2, v3 ), v3, detail ); // right quadrant
      _make( _midpoint( v1, v2 ), _midpoint( v2, v3 ), _midpoint( v1, v3 ), detail ); // center quadrant

    }

  }

  _midpoint( v1, v2 ) {

    // TODO - nelsonsilva - refactor this code
    // arrays don't "automagically" grow in Dart!
    if ( _midpoints.length < v1.index + 1) {
      _midpoints.length = v1.index + 1;
      _midpoints[ v1.index ] = [];
    }
    if ( _midpoints.length < v2.index + 1) {
      _midpoints.length = v2.index + 1;
      _midpoints[ v2.index ] = [];
    }

    // prepare _midpoints[ v1.index ][ v2.index ]
    if (_midpoints[ v1.index ] == null ) {
      _midpoints[ v1.index ] = [];
    }

    if (_midpoints[ v1.index ].length < v2.index + 1) {
      _midpoints[ v1.index ].length = v2.index + 1;
    }

    // prepare _midpoints[ v2.index ][ v1.index ]
    if (_midpoints[ v2.index ] == null ) {
      _midpoints[ v2.index ] = [];
    }

    if (_midpoints[ v2.index ].length < v1.index + 1) {
      _midpoints[ v2.index ].length = v1.index + 1;
    }

    var mid = _midpoints[ v1.index ][ v2.index ];

    if ( mid == null ) {

      // generate mean point and project to surface with prepare()
      mid = _prepare(
          new PolyhedronGeometryVertex.fromVector3( (v1 + v2).scale(0.5) )
      );
      _midpoints[ v1.index ][ v2.index ] = mid;
      _midpoints[ v2.index ][ v1.index ] = mid;
    }

    return mid;

  }


  /// Angle around the Y axis, counter-clockwise when looking from above.
  _azimuth( vector ) => Math.atan2( vector.z, -vector.x );


  /// Angle above the XZ plane.
  _inclination( vector ) => Math.atan2( -vector.y, Math.sqrt( ( vector.x * vector.x ) + ( vector.z * vector.z ) ) );

  /// Texture fixing helper. Spheres have some odd behaviours.
  _correctUV( uv, vector, azimuth ) {
    if ( ( azimuth < 0 ) && ( uv.u == 1 ) ) uv = new UV( uv.u - 1, uv.v );
    if ( ( vector.x == 0 ) && ( vector.z == 0 ) ) uv = new UV( azimuth / 2 / Math.PI + 0.5, uv.v );
    return uv;

  }
}

/**
 * [PolyhedronGeometryVertex] is a [Vector3] decorator to allow introducing [index] and [uv].
 * */
class PolyhedronGeometryVertex extends Vector3 {
  int index;
  UV uv;
  PolyhedronGeometryVertex([num x = 0.0, num y = 0.0, num z = 0.0]) : super(x.toDouble(), y.toDouble(), z.toDouble());

  PolyhedronGeometryVertex.fromVector3(Vector3 other) : super.copy(other);
}
