part of three;

class LatheGeometry extends Geometry {

  int steps;
  num angle;

  LatheGeometry(points, [this.steps = 12, this.angle = 2 * Math.PI] ) : super() {

    var newV = points.map((pt) => pt.clone()).toList();
    vertices.addAll(newV);

    Matrix4 matrix = new Matrix4.rotationZ( angle / steps );

    var i, il = steps + 1;

    for ( i = 0; i < il; i ++ ) {

      for ( var j = 0; j < newV.length; j ++ ) {
        newV[ j ].applyProjection( matrix );
        vertices.add( newV[ j ] );
      }

    }

    for ( i = 0; i < steps; i ++ ) {

      for ( var k = 0, kl = points.length; k < kl - 1; k ++ ) {

        var a = i * kl + k;
        var b = ( ( i + 1 ) % il ) * kl + k;
        var c = ( ( i + 1 ) % il ) * kl + ( k + 1 ) % kl;
        var d = i * kl + ( k + 1 ) % kl;

        this.faces.add( new Face4( a, b, c, d ) );

        this.faceVertexUvs[ 0 ].add( [

                                       new UV( 1 - i / steps, k / kl ),
                                       new UV( 1 - ( i + 1 ) / steps, k / kl ),
                                       new UV( 1 - ( i + 1 ) / steps, ( k + 1 ) / kl ),
                                       new UV( 1 - i / steps, ( k + 1 ) / kl )

                                       ] );

      }

    }

    computeCentroids();
    computeFaceNormals();
    computeVertexNormals();
  }
}
