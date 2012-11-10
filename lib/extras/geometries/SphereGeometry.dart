part of three;

class SphereGeometry extends Geometry {
  num radius;

  SphereGeometry([this.radius = 50,
                  num segmentsWidth = 8,
                  num segmentsHeight = 6,
                  num phiStart = 0,
                  num phiLength = Math.PI * 2,
                  num thetaStart = 0,
                  num thetaLength = Math.PI]) : super() {

    num segmentsX = Math.max( 3, segmentsWidth.floor()),
        segmentsY = Math.max( 2, segmentsHeight.floor());

    List vertices = [], uvs = [];
    var x, y;

    for (y = 0; y <= segmentsY; y++ ) {

      var verticesRow = [];
      var uvsRow = [];

      for (x = 0; x <= segmentsX; x++ ) {

        num u = x / segmentsX;
        num v = y / segmentsY;

        Vector3 vertex = new Vector3();
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

    for (y = 0; y < segmentsY; y++ ) {

      for (x = 0; x < segmentsX; x++ ) {

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
