part of three;

class CylinderGeometry extends Geometry {
  double radiusTop, radiusBottom, height;
  int segmentsRadius, segmentsHeight;
  bool openEnded;

  CylinderGeometry( [ this.radiusTop = 20.0,
                      this.radiusBottom = 20.0,
                      this.height = 100.0,
                      this.segmentsRadius = 8,
                      this.segmentsHeight = 1,
                      this.openEnded = false] ) : super() {

    double heightHalf = height / 2;
    int segmentsX = segmentsRadius;
    int segmentsY = segmentsHeight;

    int x, y;

    List vertices = [], uvs = [];

    for ( y = 0; y <= segmentsY; y ++ ) {

      var verticesRow = [];
      var uvsRow = [];

      double v = y / segmentsY;
      var radius = v * ( radiusBottom - radiusTop ) + radiusTop;

      for ( x = 0; x <= segmentsX; x ++ ) {

        double u = x / segmentsX;

        var vertex = new Vector3.zero();
        vertex.x = radius * Math.sin( u * Math.PI * 2 );
        vertex.y = - v * height + heightHalf;
        vertex.z = radius * Math.cos( u * Math.PI * 2 );

        this.vertices.add( vertex );

        verticesRow.add( this.vertices.length - 1 );
        uvsRow.add( new UV( u, 1 - v ) );

      }

      vertices.add( verticesRow );
      uvs.add( uvsRow );

    }

    var tanTheta = ( radiusBottom - radiusTop ) / height;
    var na, nb;

    for ( x = 0; x < segmentsX; x ++ ) {

      if ( radiusTop != 0 ) {

        na = this.vertices[ vertices[ 0 ][ x ] ].clone();
        nb = this.vertices[ vertices[ 0 ][ x + 1 ] ].clone();

      } else {

        na = this.vertices[ vertices[ 1 ][ x ] ].clone();
        nb = this.vertices[ vertices[ 1 ][ x + 1 ] ].clone();

      }

      na[1] = Math.sqrt( na.x * na.x + na.z * na.z ) * tanTheta;
      na.normalize();
      nb[1] = Math.sqrt( nb.x * nb.x + nb.z * nb.z ) * tanTheta;
      na.normalize();

      for ( y = 0; y < segmentsY; y ++ ) {

        var v1 = vertices[ y ][ x ];
        var v2 = vertices[ y + 1 ][ x ];
        var v3 = vertices[ y + 1 ][ x + 1 ];
        var v4 = vertices[ y ][ x + 1 ];

        var n1 = na.clone();
        var n2 = na.clone();
        var n3 = nb.clone();
        var n4 = nb.clone();

        var uv1 = uvs[ y ][ x ].clone();
        var uv2 = uvs[ y + 1 ][ x ].clone();
        var uv3 = uvs[ y + 1 ][ x + 1 ].clone();
        var uv4 = uvs[ y ][ x + 1 ].clone();

        this.faces.add( new Face4( v1, v2, v3, v4, [ n1, n2, n3, n4 ] ) );
        this.faceVertexUvs[ 0 ].add( [ uv1, uv2, uv3, uv4 ] );

      }

    }

    // top cap

    if ( !openEnded && radiusTop > 0 ) {

      this.vertices.add( new Vector3( 0.0, heightHalf, 0.0 ) );

      for ( x = 0; x < segmentsX; x ++ ) {

        var v1 = vertices[ 0 ][ x ];
        var v2 = vertices[ 0 ][ x + 1 ];
        var v3 = this.vertices.length - 1;

        var n1 = new Vector3( 0.0, 1.0, 0.0 );
        var n2 = new Vector3( 0.0, 1.0, 0.0 );
        var n3 = new Vector3( 0.0, 1.0, 0.0 );

        var uv1 = uvs[ 0 ][ x ].clone();
        var uv2 = uvs[ 0 ][ x + 1 ].clone();
        var uv3 = new UV( uv2.u, 0.0 );

        this.faces.add( new Face3( v1, v2, v3, [ n1, n2, n3 ] ) );
        this.faceVertexUvs[ 0 ].add( [ uv1, uv2, uv3 ] );

      }

    }

    // bottom cap

    if ( !openEnded && radiusBottom > 0 ) {

      this.vertices.add( new Vector3( 0.0, - heightHalf, 0.0 ) );

      for ( x = 0; x < segmentsX; x ++ ) {

        var v1 = vertices[ y ][ x + 1 ];
        var v2 = vertices[ y ][ x ];
        var v3 = this.vertices.length - 1;

        var n1 = new Vector3( 0.0, -1.0, 0.0 );
        var n2 = new Vector3( 0.0, -1.0, 0.0 );
        var n3 = new Vector3( 0.0, -1.0, 0.0 );

        var uv1 = uvs[ y ][ x + 1 ].clone();
        var uv2 = uvs[ y ][ x ].clone();
        var uv3 = new UV( uv2.u, 1.0 );

        this.faces.add( new Face3( v1, v2, v3, [ n1, n2, n3 ] ) );
        this.faceVertexUvs[ 0 ].add( [ uv1, uv2, uv3 ] );

      }

    }

    this.computeCentroids();
    this.computeFaceNormals();
   }
}
