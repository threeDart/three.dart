part of three;

/**
 * @author oosmoxiecode
 * based on http://code.google.com/p/away3d/source/browse/trunk/fp10/Away3D/src/away3d/primitives/TorusKnot.as?spec=svn2473&r=2473
 */

class TorusKnotGeometry extends Geometry {

  num radius, tube, segmentsR, segmentsT, p, q, heightScale;
  List grid;

  TorusKnotGeometry( [ this.radius = 200,
                       this.tube = 40,
                       this.segmentsR = 64,
                       this.segmentsT = 8,
                       this.p = 2,
                       this.q = 3,
                       this.heightScale = 1]) : super() {

    grid = new List(segmentsR);

    var tang = new Vector3.zero();
    var n = new Vector3.zero();
    var bitan = new Vector3.zero();

    for ( var i = 0; i < segmentsR; ++ i ) {

      this.grid[ i ] = new List( this.segmentsT );

      for ( var j = 0; j < this.segmentsT; ++ j ) {

        var u = i / this.segmentsR * 2 * this.p * Math.PI;
        var v = j / this.segmentsT * 2 * Math.PI;
        var p1 = getPos( u, v, this.q, this.p, this.radius, this.heightScale );
        var p2 = getPos( u + 0.01, v, this.q, this.p, this.radius, this.heightScale );
        var cx, cy;

        tang = p2 - p1;
        n = p2 + p1;

        bitan = tang.cross( n );
        n = bitan.cross( tang );
        bitan.normalize();
        n.normalize();

        cx = - this.tube * Math.cos( v ); // TODO: Hack: Negating it so it faces outside.
        cy = this.tube * Math.sin( v );

        p1.x += cx * n.x + cy * bitan.x;
        p1.y += cx * n.y + cy * bitan.y;
        p1.z += cx * n.z + cy * bitan.z;

        this.grid[ i ][ j ] = _vert( p1.x, p1.y, p1.z );

      }

    }

    for ( var i = 0; i < this.segmentsR; ++ i ) {

      for ( var j = 0; j < this.segmentsT; ++ j ) {

        var ip = ( i + 1 ) % this.segmentsR;
        var jp = ( j + 1 ) % this.segmentsT;

        var a = this.grid[ i ][ j ];
        var b = this.grid[ ip ][ j ];
        var c = this.grid[ ip ][ jp ];
        var d = this.grid[ i ][ jp ];

        var uva = new UV( i / this.segmentsR, j / this.segmentsT );
        var uvb = new UV( ( i + 1 ) / this.segmentsR, j / this.segmentsT );
        var uvc = new UV( ( i + 1 ) / this.segmentsR, ( j + 1 ) / this.segmentsT );
        var uvd = new UV( i / this.segmentsR, ( j + 1 ) / this.segmentsT );

        this.faces.add( new Face4( a, b, c, d ) );
        this.faceVertexUvs[ 0 ].add( [ uva,uvb,uvc, uvd ] );

      }
    }

    this.computeCentroids();
    this.computeFaceNormals();
    this.computeVertexNormals();

   }

  num _vert( x, y, z ) {
    vertices.add( new Vector3( x, y, z ) );
    return vertices.length - 1;
  }

  Vector3 getPos( u, v, in_q, in_p, radius, heightScale ) {

    var cu = Math.cos( u );
    var cv = Math.cos( v );
    var su = Math.sin( u );
    var quOverP = in_q / in_p * u;
    var cs = Math.cos( quOverP );

    var tx = radius * ( 2 + cs ) * 0.5 * cu;
    var ty = radius * ( 2 + cs ) * su * 0.5;
    var tz = heightScale * radius * Math.sin( quOverP ) * 0.5;

    return new Vector3( tx, ty, tz );

  }
}
