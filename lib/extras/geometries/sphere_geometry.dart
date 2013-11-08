part of three;

class SphereGeometry extends Geometry {
  double radius;

  SphereGeometry([this.radius = 50.0,
                  int segmentsWidth = 8,
                  int segmentsHeight = 6,
                  double phiStart = 0.0,
                  double phiLength = Math.PI * 2.0,
                  double thetaStart = 0.0,
                  double thetaLength = Math.PI]) : super() {

    int segmentsX = Math.max( 3, segmentsWidth);
    int segmentsY = Math.max( 2, segmentsHeight);

    List vertices = [], uvs = [];

    for (int y = 0; y <= segmentsY; y++ ) {

      var verticesRow = [];
      var uvsRow = [];

      for (int x = 0; x <= segmentsX; x++ ) {

        double u = x.toDouble() / segmentsX.toDouble();
        double v = y.toDouble() / segmentsY.toDouble();

        Vector3 vertex = new Vector3.zero();
        vertex.x = - radius * Math.cos( phiStart + u * phiLength ) * Math.sin( thetaStart + v * thetaLength );
        vertex.y = radius * Math.cos( thetaStart + v * thetaLength );
        vertex.z = radius * Math.sin( phiStart + u * phiLength ) * Math.sin( thetaStart + v * thetaLength );

        this.vertices.add( vertex );

        verticesRow.add( this.vertices.length - 1 );
        uvsRow.add( new UV( u, 1 - v ) );

      }

      vertices.add( verticesRow );
      uvs.add( uvsRow );

    }

    for (int y = 0; y < segmentsY; y++ ) {

      for (int x = 0; x < segmentsX; x++ ) {

        var v1 = vertices[ y ][ x + 1 ];
        var v2 = vertices[ y ][ x ];
        var v3 = vertices[ y + 1 ][ x ];
        var v4 = vertices[ y + 1 ][ x + 1 ];

        var n1 = this.vertices[ v1 ].clone().normalize();
        var n2 = this.vertices[ v2 ].clone().normalize();
        var n3 = this.vertices[ v3 ].clone().normalize();
        var n4 = this.vertices[ v4 ].clone().normalize();

        var uv1 = uvs[ y ][ x + 1 ].clone();
        var uv2 = uvs[ y ][ x ].clone();
        var uv3 = uvs[ y + 1 ][ x ].clone();
        var uv4 = uvs[ y + 1 ][ x + 1 ].clone();

        if ( this.vertices[ v1 ].y.abs() == radius ) {

          this.faces.add( new Face3( v1, v3, v4, [ n1, n3, n4 ] ) );
          this.faceVertexUvs[ 0 ].add( [ uv1, uv3, uv4 ] );

        } else if (  this.vertices[ v3 ].y.abs() ==  radius ) {

          this.faces.add( new Face3( v1, v2, v3, [ n1, n2, n3 ] ) );
          this.faceVertexUvs[ 0 ].add( [ uv1, uv2, uv3 ] );

        } else {

          this.faces.add( new Face4( v1, v2, v3, v4, [ n1, n2, n3, n4 ] ) );
          this.faceVertexUvs[ 0 ].add( [ uv1, uv2, uv3, uv4 ] );

        }

      }

    }

    this.computeCentroids();
    this.computeFaceNormals();

    this.boundingSphere = new BoundingSphere( radius: radius );

  }

}
