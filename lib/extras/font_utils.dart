/**
 * @author zz85 / http://www.lab4games.net/zz85/blog
 * @author alteredq / http://alteredqualia.com/
 *
 * For Text operations in three.js (See TextGeometry)
 *
 * It uses techniques used in:
 *
 *  typeface.js and canvastext
 *    For converting fonts and rendering with javascript
 *    http://typeface.neocracy.org
 *
 *  Triangulation ported from AS3
 *    Simple Polygon Triangulation
 *    http://actionsnippet.com/?p=1462
 *
 *  A Method to triangulate shapes with holes
 *    http://www.sakri.net/blog/2009/06/12/an-approach-to-triangulating-polygons-with-holes/
 *
 */

library FontUtils;

import 'package:vector_math/vector_math.dart';
import "package:three/three.dart";
import "core/shape_utils.dart" as ShapeUtils;

var  _face = "helvetiker",
     _weight = "normal",
     _style = "normal",
     _size = 150,
     _divisions = 10;

/// Map of [FontFace]
Map<String, Map<String, Map<String, Map<String, Map>>>> _faces = {};

Map<String, Map> getFace() => _faces[ _face ][ _weight ][ _style ];

loadFace( data ) {

  var family = data["familyName"].toLowerCase();

  if (_faces[ family ] == null) _faces[ family ] = {};

  if (_faces[ family ][ data["cssFontWeight"] ] == null) _faces[ family ][ data["cssFontWeight"] ] = {};
  _faces[ family ][ data["cssFontWeight"] ][ data["cssFontStyle"] ] = data;

  // TODO - Parse data
  var face = _faces[ family ][ data["cssFontWeight"] ][ data["cssFontStyle"] ] = data;

  return data;

}

drawText( String text ) {

  var characterPts = [], allPts = [];

  // RenderText

  var i, p,
    face = getFace(),
    scale = _size / face["resolution"],
    offset = 0,
    chars = text.split( '' ),
    length = chars.length;

  var fontPaths = [];

  for ( i = 0; i < length; i ++ ) {

    var path = new Path();

    var ret = extractGlyphPoints( chars[ i ], face, scale, offset, path );
    offset += ret["offset"];

    fontPaths.add( ret["path"] );

  }

  // get the width

  var width = offset / 2;
  //
  // for ( p = 0; p < allPts.length; p++ ) {
  //
  //  allPts[ p ].x -= width;
  //
  // }

  //var extract = this.extractPoints( allPts, characterPts );
  //extract.contour = allPts;

  //extract.paths = fontPaths;
  //extract.offset = width;

  return { "paths" : fontPaths, "offset" : width };

}

extractGlyphPoints ( String c, face, scale, offset, path ) {

  List<Vector2> pts = [];

  var i, i2, divisions,
    outline, action, length,
    scaleX, scaleY,
    x, y, cpx, cpy, cpx0, cpy0, cpx1, cpy1, cpx2, cpy2,
    laste;

  var glyph = face["glyphs"][ c ];
  if (glyph == null) glyph = face["glyphs"][ '?' ];

  if ( glyph == null ) return null;

  if ( glyph["o"] != null) {

    outline = glyph["_cachedOutline"];
    if (outline == null) {
      glyph["_cachedOutline"] = glyph["o"].split( ' ' );
      outline = glyph["_cachedOutline"];
    }
    length = outline.length;

    scaleX = scale;
    scaleY = scale;

    for ( i = 0; i < length; ) {

      action = outline[ i ++ ];

      //console.log( action );

      switch( action ) {

      case 'm':

        // Move To

        x = int.parse(outline[ i++ ]) * scaleX + offset;
        y = int.parse(outline[ i++ ]) * scaleY;

        path.moveTo( x, y );
        break;

      case 'l':

        // Line To

        x = int.parse(outline[ i++ ]) * scaleX + offset;
        y = int.parse(outline[ i++ ]) * scaleY;
        path.lineTo(x,y);
        break;

      case 'q':

        // QuadraticCurveTo

        cpx  = int.parse(outline[ i++ ]) * scaleX + offset;
        cpy  = int.parse(outline[ i++ ]) * scaleY;
        cpx1 = int.parse(outline[ i++ ]) * scaleX + offset;
        cpy1 = int.parse(outline[ i++ ]) * scaleY;

        path.quadraticCurveTo(cpx1, cpy1, cpx, cpy);

        if (pts.length > 0) laste = pts[ pts.length - 1 ];

        if ( laste != null ) {

          cpx0 = laste.x;
          cpy0 = laste.y;

          for ( i2 = 1; i2 <= divisions; i2 ++ ) {

            var t = i2 / divisions;
            var tx = ShapeUtils.b2( t, cpx0, cpx1, cpx );
            var ty = ShapeUtils.b2( t, cpy0, cpy1, cpy );
          }

        }

        break;

      case 'b':

        // Cubic Bezier Curve

        cpx  = int.parse(outline[ i++ ]) *  scaleX + offset;
        cpy  = int.parse(outline[ i++ ]) *  scaleY;
        cpx1 = int.parse(outline[ i++ ]) *  scaleX + offset;
        cpy1 = int.parse(outline[ i++ ]) * -scaleY;
        cpx2 = int.parse(outline[ i++ ]) *  scaleX + offset;
        cpy2 = int.parse(outline[ i++ ]) * -scaleY;

        path.bezierCurveTo( cpx, cpy, cpx1, cpy1, cpx2, cpy2 );

        if (pts.length > 0) laste = pts[ pts.length - 1 ];

        if ( laste != null ) {

          cpx0 = laste.x;
          cpy0 = laste.y;

          for ( i2 = 1; i2 <= divisions; i2 ++ ) {

            var t = i2 / divisions;
            var tx = ShapeUtils.b3( t, cpx0, cpx1, cpx2, cpx );
            var ty = ShapeUtils.b3( t, cpy0, cpy1, cpy2, cpy );

          }

        }

        break;

      }

    }
  }



  return { "offset": glyph["ha"]*scale, "path":path};
}

generateShapes( text, [ int size = 100,
                        int curveSegments = 4,
                        String font = "helvetiker",
                        String weight = "normal",
                        String style = "normal"] ) {

  var face = _faces[font][weight][style];

  if (_faces == null) {
    face = new FontFace(size: size, divisions: curveSegments);
    _faces[font][weight][style] = face;
  }
  
  _size = size;
  _divisions = curveSegments;

  _face = font;
  _weight = weight;
  _style = style;

  // Get a Font data json object

  var data = drawText( text );

  var paths = data["paths"];
  var shapes = [];
  var pl = paths.length;

  for ( var p = 0; p < pl; p ++ ) {

    shapes.addAll(paths[ p ].toShapes() );

  }

  return shapes;

}

class Glyph {
  String o; /// outline
  List _cachedOutline;

  num ha;
}

class FontFace {
  Map<String, Map> _data;

  Map<String, Glyph> glyphs;

  num size, divisions;

  num resolution;

  FontFace( { this.size: 150,
              this.divisions: 10} ) : glyphs = {};

  Map operator [](String weight) => _data[weight];
}

/**
 * This code is a quick port of code written in C++ which was submitted to
 * flipcode.com by John W. Ratcliff  // July 22, 2000
 * See original code and more information here:
 * http://www.flipcode.com/archives/Efficient_Polygon_Triangulation.shtml
 *
 * ported to actionscript by Zevan Rosser
 * www.actionsnippet.com
 *
 * ported to javascript by Joshua Koo
 * http://www.lab4games.net/zz85/blog
 *
 */


var EPSILON = 0.0000000001;

// takes in an contour array and returns
List<List<Vector2>> process( List<Vector2> contour, bool indices ) {

  var n = contour.length;

  if ( n < 3 ) return null;

  var result = [],
    verts = new List(n),
    vertIndices = [];

  /* we want a counter-clockwise polygon in verts */

  num u, v, w;

  if ( area( contour ) > 0.0 ) {

    for ( v = 0; v < n; v++ ) verts[ v ] = v;

  } else {

    for ( v = 0; v < n; v++ ) verts[ v ] = ( n - 1 ) - v;

  }

  num nv = n;

  /*  remove nv - 2 vertices, creating 1 triangle every time */

  var count = 2 * nv;   /* error detection */

  for( v = nv - 1; nv > 2; ) {

    /* if we loop, it is probably a non-simple polygon */

    if ( ( count-- ) <= 0 ) {

      //** Triangulate: ERROR - probable bad polygon!

      //throw ( "Warning, unable to triangulate polygon!" );
      //return null;
      // Sometimes warning is fine, especially polygons are triangulated in reverse.
      print( "Warning, unable to triangulate polygon!" );

      if ( indices ) return vertIndices;
      return result;

    }

    /* three consecutive vertices in current polygon, <u,v,w> */

    u = v;    if ( nv <= u ) u = 0;     /* previous */
    v = u + 1;  if ( nv <= v ) v = 0;     /* new v    */
    w = v + 1;  if ( nv <= w ) w = 0;     /* next     */

    if ( snip( contour, u, v, w, nv, verts ) ) {

      var a, b, c, s, t;

      /* true names of the vertices */

      a = verts[ u ];
      b = verts[ v ];
      c = verts[ w ];

      /* output Triangle */

      result.add( [ contour[ a ],
                    contour[ b ],
                    contour[ c ] ] );


      vertIndices.addAll( [ verts[ u ], verts[ v ], verts[ w ] ] );

      /* remove v from the remaining polygon */
      s = v;
      for( t = v + 1; t < nv; t++ ) {

        verts[ s ] = verts[ t ];
        s++;
      }

      nv--;

      /* reset error detection counter */

      count = 2 * nv;

    }

  }

  if ( indices ) return vertIndices;
  return result;

}

// calculate area of the contour polygon
area( contour ) {

  var n = contour.length;
  var a = 0.0;

  for( var p = n - 1, q = 0; q < n; p = q++ ) {

    a += contour[ p ].x * contour[ q ].y - contour[ q ].x * contour[ p ].y;

  }

  return a * 0.5;

}

// see if p is inside triangle abc
insideTriangle( ax, ay,
                 bx, by,
                 cx, cy,
                 px, py ) {

    var aX, aY, bX, bY;
    var cX, cY, apx, apy;
    var bpx, bpy, cpx, cpy;
    var cCROSSap, bCROSScp, aCROSSbp;

    aX = cx - bx;  aY = cy - by;
    bX = ax - cx;  bY = ay - cy;
    cX = bx - ax;  cY = by - ay;
    apx= px  -ax;  apy= py - ay;
    bpx= px - bx;  bpy= py - by;
    cpx= px - cx;  cpy= py - cy;

    aCROSSbp = aX*bpy - aY*bpx;
    cCROSSap = cX*apy - cY*apx;
    bCROSScp = bX*cpy - bY*cpx;

    return ( (aCROSSbp >= 0.0) && (bCROSScp >= 0.0) && (cCROSSap >= 0.0) );

}


snip( contour, u, v, w, n, verts ) {

  var p;
  var ax, ay, bx, by;
  var cx, cy, px, py;

  ax = contour[ verts[ u ] ].x;
  ay = contour[ verts[ u ] ].y;

  bx = contour[ verts[ v ] ].x;
  by = contour[ verts[ v ] ].y;

  cx = contour[ verts[ w ] ].x;
  cy = contour[ verts[ w ] ].y;

  if ( EPSILON > (((bx-ax)*(cy-ay)) - ((by-ay)*(cx-ax))) ) return false;

    for ( p = 0; p < n; p++ ) {

      if( (p == u) || (p == v) || (p == w) ) continue;

      px = contour[ verts[ p ] ].x;
      py = contour[ verts[ p ] ].y;

      if ( insideTriangle( ax, ay, bx, by, cx, cy, px, py ) ) return false;

    }

    return true;

}


//namespace.Triangulate = process;
//namespace.Triangulate.area = area;