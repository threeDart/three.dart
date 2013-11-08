part of three;

class TorusGeometry extends Geometry {
  num radius, tube, segmentsR, segmentsT, arc;

  TorusGeometry ([this.radius = 100, this.tube = 40, this.segmentsR = 8, this.segmentsT = 6, this.arc = Math.PI * 2]) : super() {

    var center = new Vector3.zero();
    var uvs = <UV>[];
    var normals = <Vector3>[];

    for ( var j = 0; j <= this.segmentsR; j ++ ) {

      for ( var i = 0; i <= this.segmentsT; i ++ ) {

        var u = i / this.segmentsT * this.arc;
        var v = j / this.segmentsR * Math.PI * 2;

        center.x = this.radius * Math.cos( u );
        center.y = this.radius * Math.sin( u );

        var vertex = new Vector3.zero();
        vertex.x = ( this.radius + this.tube * Math.cos( v ) ) * Math.cos( u );
        vertex.y = ( this.radius + this.tube * Math.cos( v ) ) * Math.sin( u );
        vertex.z = this.tube * Math.sin( v );

        this.vertices.add( vertex );

        uvs.add( new UV( i / this.segmentsT, j / this.segmentsR ) );
        normals.add( vertex.clone().sub( center ).normalize() );

      }
    }


    for ( var j = 1; j <= this.segmentsR; j ++ ) {

      for ( var i = 1; i <= this.segmentsT; i ++ ) {

        var a = ( this.segmentsT + 1 ) * j + i - 1;
        var b = ( this.segmentsT + 1 ) * ( j - 1 ) + i - 1;
        var c = ( this.segmentsT + 1 ) * ( j - 1 ) + i;
        var d = ( this.segmentsT + 1 ) * j + i;

        var face = new Face4( a, b, c, d, [ normals[ a ], normals[ b ], normals[ c ], normals[ d ] ] );
        face.normal.add( normals[ a ] );
        face.normal.add( normals[ b ] );
        face.normal.add( normals[ c ] );
        face.normal.add( normals[ d ] );
        face.normal.normalize();

        this.faces.add( face );

        this.faceVertexUvs[ 0 ].add( [ uvs[ a ].clone(), uvs[ b ].clone(), uvs[ c ].clone(), uvs[ d ].clone() ] );
      }

    }

    this.computeCentroids();

  }
}
