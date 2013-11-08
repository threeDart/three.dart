part of three;

/**
 * @author zz85 / https://github.com/zz85
 * Parametric Surfaces Geometry
 * based on the brilliant article by @prideout http://prideout.net/blog/?p=44
 *
 * new THREE.ParametricGeometry( parametricFunction, uSegments, ySegements, useTris );
 *
 */

class ParametricGeometry extends Geometry {

  ParametricGeometry( func(u, v), int slices, int stacks, [bool useTris = false] ) : super() {
    var verts = this.vertices;
    var faces = this.faces;
    var uvs = this.faceVertexUvs[ 0 ];

    var i, il, j, p;
    var u, v;

    var stackCount = stacks + 1;
    var sliceCount = slices + 1;

    for ( i = 0; i <= stacks; i ++ ) {

      v = i / stacks;

      for ( j = 0; j <= slices; j ++ ) {

        u = j / slices;

        p = func( u, v );
        verts.add( p );

      }
    }

    var a, b, c, d;
    var uva, uvb, uvc, uvd;

    for ( i = 0; i < stacks; i ++ ) {

      for ( j = 0; j < slices; j ++ ) {

        a = i * sliceCount + j;
        b = i * sliceCount + j + 1;
        c = (i + 1) * sliceCount + j;
        d = (i + 1) * sliceCount + j + 1;

        uva = new UV( j / slices, i / stacks );
        uvb = new UV( ( j + 1 ) / slices, i / stacks );
        uvc = new UV( j / slices, ( i + 1 ) / stacks );
        uvd = new UV( ( j + 1 ) / slices, ( i + 1 ) / stacks );

        if ( useTris ) {

          faces.add( new Face3( a, b, c ) );
          faces.add( new Face3( b, d, c ) );

          uvs.add( [ uva, uvb, uvc ] );
          uvs.add( [ uvb, uvd, uvc ] );

        } else {

          faces.add( new Face4( a, b, d, c ) );
          uvs.add( [ uva, uvb, uvd, uvc ] );

        }

      }

    }

    // console.log(this);

    // magic bullet
    // var diff = this.mergeVertices();
    // console.log('removed ', diff, ' vertices by merging');

    computeCentroids();
    computeFaceNormals();
    computeVertexNormals();

  }
}
