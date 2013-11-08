part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * based on http://papervision3d.googlecode.com/svn/trunk/as3/trunk/src/org/papervision3d/objects/primitives/Cube.as
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class CubeGeometry extends Geometry {
  //List materials;
  CubeGeomSides _sides;
  int segmentsWidth;
  int segmentsHeight;
  int segmentsDepth;

  /**
   * [materialOrList] is a [Material] or a [List] of [Material]. */
  CubeGeometry( double width, double height, double depth, [this.segmentsWidth = 1,
                                                   this.segmentsHeight = 1,
                                                   this.segmentsDepth = 1,
                                                   materialOrList,
                                                   List sides] )
                                                   : super() {

    double width_half = width / 2,
        height_half = height / 2,
        depth_half = depth / 2;

    int mpx, mpy, mpz, mnx, mny, mnz;

    if ( materialOrList != null ) {
      if ( materialOrList is List ) {
        materials = materialOrList;
      } else {
        materials = [];

        for ( int i = 0; i < 6; i ++ ) {
          materials.add( materialOrList );
        }
      }

      mpx = 0; mnx = 1; mpy = 2; mny = 3; mpz = 4; mnz = 5;

    } else {
      materials = [];
    }

    //_sides = { "px": true, "nx": true, "py": true, "ny": true, "pz": true, "nz": true };
    _sides = new CubeGeomSides();

    //TODO: not sure if this is the correct use of "dynamic"
    if ( sides != null ) {
      for ( var s in sides ) {
        if ( (_sides as dynamic)[ s ] != null ) {
          (_sides as dynamic)[ s ] = sides[ s ];
        }
      }
    }

    if (_sides.px)  buildPlane( 'z', 'y', -1.0, -1.0, depth, height, width_half, mpx ); // px
    if (_sides.nx)  buildPlane( 'z', 'y',  1.0, -1.0, depth, height, - width_half, mnx ); // nx
    if (_sides.py)  buildPlane( 'x', 'z',  1.0,  1.0, width, depth, height_half, mpy ); // py
    if (_sides.ny)  buildPlane( 'x', 'z',  1.0, -1.0, width, depth, - height_half, mny ); // ny
    if (_sides.pz)  buildPlane( 'x', 'y',  1.0, -1.0, width, height, depth_half, mpz ); // pz
    if (_sides.nz)  buildPlane( 'x', 'y', -1.0, -1.0, width, height, - depth_half, mnz ); // nz

    computeCentroids();
    mergeVertices();
  }

  void buildPlane( String u, String v, double udir, double vdir, double width, double height, double depth, int material ) {
    String w;
    int gridX = ( segmentsWidth != null ) ? segmentsWidth : 1;
    int gridY = ( segmentsHeight != null ) ? segmentsHeight : 1;
    double width_half = width / 2.0;
    double height_half = height / 2.0;
    int offset = vertices.length;

    if ( ( u == 'x' && v == 'y' ) || ( u == 'y' && v == 'x' ) ) {
      w = 'z';
    } else if ( ( u == 'x' && v == 'z' ) || ( u == 'z' && v == 'x' ) ) {
      w = 'y';
      gridY = ( segmentsDepth != null ) ? segmentsDepth : 1;
    } else if ( ( u == 'z' && v == 'y' ) || ( u == 'y' && v == 'z' ) ) {
      w = 'x';
      gridX = ( segmentsDepth != null ) ? segmentsDepth : 1;
    }

    num gridX1 = gridX + 1,
    gridY1 = gridY + 1,
    segment_width = width / gridX,
    segment_height = height / gridY;
    Vector3 normal = new Vector3.zero();

    //TODO: find out how to do this sort of casting in Dart...
    // normal.dynamic[ w ] = depth > 0 ? 1 : - 1;

    if ( w == 'x' ) {        normal.x = depth > 0 ? 1.0 : - 1.0;
    } else if ( w == 'y' ) { normal.y = depth > 0 ? 1.0 : - 1.0;
    } else if ( w == 'z' )   normal.z = depth > 0 ? 1.0 : - 1.0;

    for ( int iy = 0; iy < gridY1; iy ++ )  {
      for ( int ix = 0; ix < gridX1; ix ++ ) {
        Vector3 vector = new Vector3.zero();
        //TODO: find out how to do this sort of casting in Dart...
//        vector[ u ] = ( ix * segment_width - width_half ) * udir;
//        vector[ v ] = ( iy * segment_height - height_half ) * vdir;
//        vector[ w ] = depth;

        if ( u == 'x' ) {        vector.x = ( ix * segment_width - width_half ) * udir;
        } else if ( u == 'y' ) {   vector.y = ( ix * segment_width - width_half ) * udir;
        } else if ( u == 'z' )   vector.z = ( ix * segment_width - width_half ) * udir;

        if ( v == 'x' ) {        vector.x = ( iy * segment_height - height_half ) * vdir;
        } else if ( v == 'y' ) {   vector.y = ( iy * segment_height - height_half ) * vdir;
        } else if ( v == 'z' )   vector.z = ( iy * segment_height - height_half ) * vdir;

        if ( w == 'x' ) {        vector.x = depth;
        } else if ( w == 'y' ) {   vector.y = depth;
        } else if ( w == 'z' )   vector.z = depth;

        vertices.add( vector );
      }
    }

    for ( int iy = 0; iy < gridY; iy++ ) {
      for ( int ix = 0; ix < gridX; ix++ ) {
        num a = ix + gridX1 * iy;
        num b = ix + gridX1 * ( iy + 1 );
        num c = ( ix + 1 ) + gridX1 * ( iy + 1 );
        num d = ( ix + 1 ) + gridX1 * iy;

        Face4 face = new Face4( a + offset, b + offset, c + offset, d + offset );
        face.normal.setFrom(normal);
        face.vertexNormals.addAll( [normal.clone(), normal.clone(), normal.clone(), normal.clone()] );
        face.materialIndex = material;

        faces.add( face );

        List faceVertexUV = faceVertexUvs[ 0 ];
        List newUVs = new List();
        newUVs.addAll([
                       new UV( ix / gridX, iy / gridY ),
                       new UV( ix / gridX, ( iy + 1 ) / gridY ),
                       new UV( ( ix + 1 ) / gridX, ( iy + 1 ) / gridY ),
                       new UV( ( ix + 1 ) / gridX, iy / gridY )
                     ]);
        faceVertexUV.add( newUVs );
      }
    }
  }
}

//_sides = { "px": true, "nx": true, "py": true, "ny": true, "pz": true, "nz": true };
class CubeGeomSides{
  bool px, nx, py, ny, pz, nz;

  CubeGeomSides( {this.px: true,
                  this.nx: true,
                  this.py: true,
                  this.ny: true,
                  this.pz: true,
                  this.nz: true} );
}



