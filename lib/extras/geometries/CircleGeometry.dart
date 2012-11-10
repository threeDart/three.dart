part of three;

class CircleGeometry extends Geometry {
  num radius, segments, thetaStart, thetaLength;

  CircleGeometry( [this.radius = 50, this.segments = 8, this.thetaStart = 0, thetaLength =  Math.PI * 2]) : super() {
    segments = Math.max(3, segments);

    var i,
        uvs = [],
        center = new Vector3(),
        centerUV = new UV( 0.5, 0.5 );

    vertices.add(center);
    uvs.add( centerUV );

    for ( i = 0; i <= segments; i ++ ) {

        var vertex = new Vector3();

        vertex.x = radius * Math.cos( thetaStart + i / segments * thetaLength );
        vertex.y = radius * Math.sin( thetaStart + i / segments * thetaLength );

        vertices.add( vertex );
        uvs.add( new UV( ( vertex.x / radius + 1 ) / 2, - ( vertex.y / radius + 1 ) / 2 + 1 ) );

    }

    var n = new Vector3( 0, 0, -1 );

    for ( i = 1; i <= segments; i ++ ) {

        var v1 = i;
        var v2 = i + 1 ;
        var v3 = 0;

        faces.add( new Face3( v1, v2, v3, [ n, n, n ] ) );
        faceVertexUvs[ 0 ].add( [ uvs[ i ], uvs[ i + 1 ], centerUV ] );

    }

    computeCentroids();
    computeFaceNormals();

    boundingSphere = new BoundingSphere(radius: radius );

  }

}
