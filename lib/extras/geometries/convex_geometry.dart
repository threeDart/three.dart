part of three;

class ConvexGeometry extends Geometry {
  ConvexGeometry(List vertices) : super() {

    var faces = [ [ 0, 1, 2 ], [ 0, 2, 1 ] ];

    var addPoint = ( vertexId ) {

      var vertex = vertices[ vertexId ].clone();

      var mag = vertex.length();
      vertex.x += mag * _randomOffset();
      vertex.y += mag * _randomOffset();
      vertex.z += mag * _randomOffset();

      List hole = [];

      for ( var f = 0; f < faces.length; ) {

        var face = faces[ f ];

        // for each face, if the vertex can see it,
        // then we try to add the face's edges into the hole.
        if ( _visible( face, vertex ) ) {

          for ( var e = 0; e < 3; e++ ) {

            var edge = [ face[ e ], face[ ( e + 1 ) % 3 ] ];
            var boundary = true;

            // remove duplicated edges.
            for ( var h = 0; h < hole.length; h++ ) {

              if ( _equalEdge( hole[ h ], edge ) ) {

                hole[ h ] = hole[ hole.length - 1 ];
                hole.removeLast();
                boundary = false;
                break;

              }

            }

            if ( boundary ) {

              hole.add( edge );

            }

          }

          // remove faces[ f ]
          faces[ f ] = faces[ faces.length - 1 ];
          faces.removeLast();

        } else { // not visible

          f++;

        }
      }

      // construct the new faces formed by the edges of the hole and the vertex
      for ( var h = 0; h < hole.length; h++ ) {

        faces.add( [
                     hole[ h ][ 0 ],
                     hole[ h ][ 1 ],
                     vertexId
                     ] );

      }
    };


    for ( var i = 3; i < vertices.length; i++ ) {
      addPoint( i );
    }


    // Push vertices into `this.vertices`, skipping those inside the hull
    var id = 0;
    var newId = new List(vertices.length); // map from old vertex id to new id

    for ( var i = 0; i < faces.length; i++ ) {

      var face = faces[ i ];

      for ( var j = 0; j < 3; j++ ) {

        if ( newId[ face[ j ] ] == null ) {

            newId[ face[ j ] ] = id++;
            this.vertices.add( vertices[ face[ j ] ] );

        }
        face[ j ] = newId[ face[ j ] ];
      }
    }

    // Convert faces into instances of THREE.Face3
    for ( var i = 0; i < faces.length; i++ ) {

      this.faces.add( new Face3(
          faces[ i ][ 0 ],
          faces[ i ][ 1 ],
          faces[ i ][ 2 ]
      ) );

    }

    // Compute UVs
    for ( var i = 0; i < this.faces.length; i++ ) {

      var face = this.faces[ i ];

      this.faceVertexUvs[ 0 ].add( [
        _vertexUv( this.vertices[ face.a ] ),
        _vertexUv( this.vertices[ face.b ] ),
        _vertexUv( this.vertices[ face.c ])
      ] );

    }


    this.computeCentroids();
    this.computeFaceNormals();
    this.computeVertexNormals();
  }

  /**
   * Whether the face is visible from the vertex
   */
  _visible( face, vertex ) {

    var va = vertices[ face[ 0 ] ];
    var vb = vertices[ face[ 1 ] ];
    var vc = vertices[ face[ 2 ] ];

    var n = _normal( va, vb, vc );

    // distance from face to origin
    var dist = n.dot( va );

    return n.dot( vertex ) >= dist;

  }

  /**
   * Face normal
   */
  _normal( va, vb, vc ) {

    Vector3 cb = new Vector3.zero();
    Vector3 ab = new Vector3.zero();

    cb = vc - vb;
    ab = va - vb;
    cb = cb.cross( ab );
    cb.normalize();

    return cb;

  }

  /**
   * Detect whether two edges are equal.
   * Note that when constructing the convex hull, two same edges can only
   * be of the negative direction.
   */
  _equalEdge( ea, eb ) => ea[ 0 ] == eb[ 1 ] && ea[ 1 ] == eb[ 0 ];


  /**
   * Create a random offset between -1e-6 and 1e-6.
   */
  _randomOffset() => ( new Math.Random().nextDouble() - 0.5 ) * 2 * 1e-6;


  /**
   * XXX: Not sure if this is the correct approach. Need someone to review.
   */
  _vertexUv( vertex ) {

    var mag = vertex.length();
    return new UV( vertex.x / mag, vertex.y / mag );

  }
}
