part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * based on http://papervision3d.googlecode.com/svn/trunk/as3/trunk/src/org/papervision3d/objects/primitives/Plane.as
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class PlaneGeometry extends Geometry {

  PlaneGeometry( num width, num height, [num segmentsWidth, num segmentsHeight] ) : super() {
    //THREE.Geometry.call( this );

    int ix, iy;
    num width_half = width / 2,
        height_half = height / 2,
        gridX = segmentsWidth != null ? segmentsWidth : 1,
        gridY = segmentsHeight != null ? segmentsHeight : 1,
        gridX1 = gridX + 1,
        gridY1 = gridY + 1,
        segment_width = width / gridX,
        segment_height = height / gridY;
    Vector3 normal = new Vector3( 0, 0, 1 );

    for ( iy = 0; iy < gridY1; iy++ ) {
      for ( ix = 0; ix < gridX1; ix++ ) {
        num x = ix * segment_width - width_half;
        num y = iy * segment_height - height_half;

        vertices.add( new Vector3( x, - y, 0 ) );
      }
    }

    for ( iy = 0; iy < gridY; iy++ ) {
      for ( ix = 0; ix < gridX; ix++ ) {
        num a = ix + gridX1 * iy;
        num b = ix + gridX1 * ( iy + 1 );
        num c = ( ix + 1 ) + gridX1 * ( iy + 1 );
        num d = ( ix + 1 ) + gridX1 * iy;

        Face4 face = new Face4( a, b, c, d );
        face.normal.copy( normal );
        face.vertexNormals.addAll( [normal.clone(), normal.clone(), normal.clone(), normal.clone()] );

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

    computeCentroids();
  }
}
