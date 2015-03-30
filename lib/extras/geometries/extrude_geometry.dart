part of three;

/**
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Creates extruded geometry from a path shape.
 *
 * parameters = {
 *
 *  size:       <float>,  // size of the text
 *  height:     <float>,  // thickness to extrude text
 *  curveSegments:  <int>,    // number of points on the curves
 *  steps:      <int> | <List>,    // number of points or list of U positions for z-side extrusions / used for subdividing segements of extrude spline too
 *  amount: <int>,  // Amount
 *
 *  bevelEnabled: <bool>,     // turn on bevel
 *  bevelThickness: <float>,    // how deep into text bevel goes
 *  bevelSize:    <float>,    // how far from text outline is bevel
 *  bevelSegments:  <int>,      // number of bevel layers
 *
 *  extrudePath:  <THREE.CurvePath> // 2d/3d spline path to extrude shape orthogonality to
 *  frames: <THREE.TubeGeometry.FrenetFrames> // containing arrays of tangents, normals, binormals
 *
 *  bendPath:   <THREE.CurvePath>   // 2d path for bend the shape around x/y plane
 *
 *  material:    <int>  // material index for front and back faces
 *  extrudeMaterial: <int>  // material index for extrusion and beveled faces
 *
 *  }
  **/

class ExtrudeGeometry extends Geometry {
  String type = 'ExtrudeGeometry';
  List<Shape> shapes;

  ExtrudeGeometry(shapes, {int curveSegments: 12, int steps: 1, int amount: 100, bool bevelEnabled: true, 
    double bevelThickness: 6.0, double bevelSize, int bevelSegments: 3, 
    Curve extrudePath, TubeGeometryFrenetFrames frames, int material, int extrudeMaterial, ExtrudeGeometryWorldUVGenerator uvGenerator}) : super() {

    if (bevelSize == null) bevelSize = bevelThickness - 2.0;

    if (shapes == null) {
      this.shapes = [];
      return;
    }
    
    this.shapes = shapes is! List ? [shapes] : shapes;
    
    addShapeList(this.shapes, curveSegments, steps, amount, bevelEnabled, bevelThickness, bevelSize, bevelSegments,
        extrudePath, frames, material, extrudeMaterial, uvGenerator);

    computeCentroids();
    computeFaceNormals();
  }

  void addShapeList(shapes, curveSegments, steps, amount, bevelEnabled, bevelThickness, bevelSize, bevelSegments,
                    extrudePath, frames, material, extrudeMaterial, uvGenerator) {
    var sl = shapes.length;

    for (var s = 0; s < sl; s++) {
      var shape = shapes[s];
      addShape(shape, curveSegments, steps, amount, bevelEnabled, bevelThickness, bevelSize, bevelSegments,
               extrudePath, frames, material, extrudeMaterial, uvGenerator);
    }
  }

  // addShape Helpers
  Vector2 _scalePt2(Vector2 pt, Vector2 vec, num size) {
    if (vec == null) print("THREE.ExtrudeGeometry: vec does not exist");
    return vec.clone().scale(size).add(pt);
  }

  Vector2 _getBevelVec(Vector2 inPt, Vector2 inPrev, Vector2 inNext) {
    var EPSILON = 0.0000000001;
    
    // computes for inPt the corresponding point inPt' on a new contour
    //   shiftet by 1 unit (length of normalized vector) to the left
    // if we walk along contour clockwise, this new contour is outside the old one
    //
    // inPt' is the intersection of the two lines parallel to the two
    //  adjacent edges of inPt at a distance of 1 unit on the left side.
    
    var v_trans_x, v_trans_y, shrink_by = 1;    // resulting translation vector for inPt

    // good reading for geometry algorithms (here: line-line intersection)
    // http://geomalgorithms.com/a05-_intersect-1.html

    var v_prev_x = inPt.x - inPrev.x, v_prev_y = inPt.y - inPrev.y;
    var v_next_x = inNext.x - inPt.x, v_next_y = inNext.y - inPt.y;
    
    var v_prev_lensq = (v_prev_x * v_prev_x + v_prev_y * v_prev_y);
    
    // check for colinear edges
    var colinear0 = (v_prev_x * v_next_y - v_prev_y * v_next_x);
    
    if (colinear0.abs() > EPSILON) {    // not colinear
      
      // length of vectors for normalizing
  
      var v_prev_len = Math.sqrt(v_prev_lensq);
      var v_next_len = Math.sqrt(v_next_x * v_next_x + v_next_y * v_next_y);
      
      // shift adjacent points by unit vectors to the left
  
      var ptPrevShift_x = (inPrev.x - v_prev_y / v_prev_len);
      var ptPrevShift_y = (inPrev.y + v_prev_x / v_prev_len);
      
      var ptNextShift_x = (inNext.x - v_next_y / v_next_len);
      var ptNextShift_y = (inNext.y + v_next_x / v_next_len);
  
      // scaling factor for v_prev to intersection point
  
      var sf = ((ptNextShift_x - ptPrevShift_x) * v_next_y -
            (ptNextShift_y - ptPrevShift_y) * v_next_x  ) /
            (v_prev_x * v_next_y - v_prev_y * v_next_x);
  
      // vector from inPt to intersection point
  
      v_trans_x = (ptPrevShift_x + v_prev_x * sf - inPt.x);
      v_trans_y = (ptPrevShift_y + v_prev_y * sf - inPt.y);
  
      // Don't normalize!, otherwise sharp corners become ugly
      //  but prevent crazy spikes
      var v_trans_lensq = (v_trans_x * v_trans_x + v_trans_y * v_trans_y);
      if (v_trans_lensq <= 2) {
        return  new Vector2(v_trans_x, v_trans_y);
      } else {
        shrink_by = Math.sqrt(v_trans_lensq / 2);
      }
    } else {    // handle special case of colinear edges
      var direction_eq = false;   // assumes: opposite
      if (v_prev_x > EPSILON) {
        if (v_next_x > EPSILON) { direction_eq = true; }
      } else {
        if (v_prev_x < -EPSILON) {
          if (v_next_x < -EPSILON) { direction_eq = true; }
        } else {
          if (v_prev_y.sign == v_next_y.sign) { direction_eq = true; }
        }
      }

      if (direction_eq) {
        // console.log("Warning: lines are a straight sequence");
        v_trans_x = - v_prev_y;
        v_trans_y =  v_prev_x;
        shrink_by = Math.sqrt(v_prev_lensq);
      } else {
        // console.log("Warning: lines are a straight spike");
        v_trans_x = v_prev_x;
        v_trans_y = v_prev_y;
        shrink_by = Math.sqrt(v_prev_lensq / 2);
      }
    }

    return new Vector2(v_trans_x / shrink_by, v_trans_y / shrink_by);
  }

  _v(x, y, z) {
    vertices.add(new Vector3(x, y, z));
  }

  void addShape(Shape shape, curveSegments, steps, amount, bevelEnabled, bevelThickness, bevelSize, bevelSegments,
                extrudePath, frames, material, extrudeMaterial, uvGenerator) {
    var extrudePts,
        extrudeByPath = false;

    // set UV generator
    var uvgen = uvGenerator != null ? uvGenerator : new ExtrudeGeometryWorldUVGenerator();

    TubeGeometryFrenetFrames splineTube;

    if (extrudePath != null) {
      extrudePts = extrudePath.getSpacedPoints( steps );

      extrudeByPath = true;
      bevelEnabled = false; // bevels not supported for path extrusion

      // SETUP TNB variables

      // Reuse TNB from TubeGeomtry for now.
      // TODO1 - have a .isClosed in spline?

      splineTube = frames != null ? frames : new TubeGeometryFrenetFrames(extrudePath, steps, false);
    }

    // Safeguards if bevels are not enabled

    if (!bevelEnabled) {
      bevelSegments = 0;
      bevelThickness = 0.0;
      bevelSize = 0.0;
    }

    // Variables initalization
    
    var shapesOffset = this.vertices.length;

    var shapePoints = shape.extractPoints(curveSegments);

    List vertices = shapePoints["shape"];
    List<List<Vector2>> holes = shapePoints["holes"];

    var reverse = !ShapeUtils.isClockWise(vertices);

    if (reverse) {
      vertices = vertices.reversed.toList();

      // Maybe we should also check if holes are in the opposite direction, just to be safe ...

      for (var h = 0; h < holes.length; h++) {
        var ahole = holes[h];

        if (ShapeUtils.isClockWise(ahole)) {
          holes[h] = ahole.reversed.toList();
        }
      }

      reverse = false; // If vertices are in order now, we shouldn't need to worry about them again (hopefully)!
    }

    var faces = ShapeUtils.triangulateShape(vertices, holes);
    
    // Would it be better to move points after triangulation?
    // shapePoints = shape.extractAllPointsWithBend(curveSegments, bendPath);
    //  vertices = shapePoints.shape;
    //  holes = shapePoints.holes;

    //console.log(faces);

    ////
    ///   Handle Vertices
    ////

    var contour = vertices; // vertices has all points but contour has only points of circumference

    for (var h = 0; h < holes.length; h++) {
      var ahole = holes[h];

      vertices = new List.from(vertices);
      vertices.addAll(ahole);
    }

    var vlen = vertices.length,
        flen = faces.length;

    //------
    // Find directions for point movement
    //

    var contourMovements = [];

    for (var i = 0, il = contour.length, j = il - 1, k = i + 1; i < il; i++, j++, k++) {
      if (j == il) j = 0;
      if (k == il) k = 0;

      //  (j)---(i)---(k)
      // console.log('i,j,k', i, j , k)

      contourMovements.add(_getBevelVec(contour[i], contour[j], contour[k]));
    }

    var holesMovements = [],
        verticesMovements = new List.from(contourMovements);

    for (var h = 0, hl = holes.length; h < hl; h ++) {
      var ahole = holes[h];

      var oneHoleMovements = [];

      for (var i = 0, il = ahole.length, j = il - 1, k = i + 1; i < il; i ++, j ++, k ++) {
        if (j == il) j = 0;
        if (k == il) k = 0;

        //  (j)---(i)---(k)
        oneHoleMovements.add(_getBevelVec(ahole[i], ahole[j], ahole[k]));
      }

      holesMovements.add(oneHoleMovements);
      verticesMovements.addAll(oneHoleMovements);
    }

    // Loop bevelSegments, 1 for the front, 1 for the back

    for (var b = 0; b < bevelSegments; b++) {
      var t = b / bevelSegments;
      var z = bevelThickness * (1 - t);

      var bs = bevelSize * (Math.sin(t * Math.PI / 2)); // curved

      // contract shape

      for (var i = 0; i < contour.length; i++) {
        var vert = _scalePt2(contour[i], contourMovements[i], bs);
        _v(vert.x, vert.y, -z);
      }

      // expand holes

      for (var h = 0; h < holes.length; h++) {
        var ahole = holes[h];
        var oneHoleMovements = holesMovements[h];

        for (var i = 0; i < ahole.length; i++) {
          var vert = _scalePt2(ahole[i], oneHoleMovements[i], bs);
          _v(vert.x, vert.y, -z);
        }
      }
    }

    var bs = bevelSize;

    // Back facing vertices

    for (var i = 0; i < vlen; i++) {
      var vert = bevelEnabled ? _scalePt2(vertices[i], verticesMovements[i], bs) : vertices[i];

      if (!extrudeByPath) {
        _v(vert.x, vert.y, 0.0);
      } else {
        var normal = new Vector3.copy(splineTube.normals[0])..scale(vert.x);
        var binormal = new Vector3.copy(splineTube.binormals[0])..scale(vert.y);

        var position2 = new Vector3.copy(extrudePts[0])..add(normal)..add(binormal);

        _v(position2.x, position2.y, position2.z);
      }
    }

    // Add stepped vertices...
    // Including front facing vertices

    for (var s = 1; s <= steps; s++) {
      for (var i = 0; i < vlen; i++) {
        var vert = bevelEnabled ? _scalePt2(vertices[i], verticesMovements[i], bs) : vertices[i];

        if (!extrudeByPath) {
          _v(vert.x, vert.y, amount / steps * s);
        } else {
          var normal = new Vector3.copy(splineTube.normals[s])..scale(vert.x);
          var binormal = new Vector3.copy(splineTube.binormals[s])..scale(vert.y);

          var position2 = new Vector3.copy(extrudePts[s])..add(normal)..add(binormal);

          _v(position2.x, position2.y, position2.z);
        }
      }
    }

    // Add bevel segments planes

    for (var b = bevelSegments - 1; b >= 0; b--) {
      var t = b / bevelSegments;
      var z = bevelThickness * (1 - t);
      bs = bevelSize * Math.sin(t * Math.PI / 2);

      // contract shape

      for (var i = 0; i < contour.length; i++) {
        var vert = _scalePt2(contour[i], contourMovements[i], bs);
        _v(vert.x, vert.y, amount + z);
      }

      // expand holes

      for (var h = 0; h < holes.length; h++) {
        var ahole = holes[h];
        var oneHoleMovements = holesMovements[h];

        for (var i = 0; i < ahole.length; i++) {
          var vert = _scalePt2(ahole[i], oneHoleMovements[i], bs);

          if (!extrudeByPath) {
            _v(vert.x, vert.y, amount + z);
          } else {
            _v(vert.x, vert.y + extrudePts[steps - 1].y, extrudePts[steps - 1].x + z);
          }
        }
      }
    }

    ////
    ///   Handle Faces
    ////

    /////  Internal functions

    f3(a, b, c) {
      a += shapesOffset;
      b += shapesOffset;
      c += shapesOffset;

      // normal, color, material
      this.faces.add(new Face3(a, b, c, null, null, material));

      var uvs = uvgen.generateTopUV(this, a, b, c);

      this.faceVertexUvs[0].add(uvs);
    }

    f4(a, b, c, d, wallContour, stepIndex, stepsLength) {
      a += shapesOffset;
      b += shapesOffset;
      c += shapesOffset;
      d += shapesOffset;

      this.faces.add(new Face3(a, b, d, null, null, extrudeMaterial));
      this.faces.add(new Face3(b, c, d, null, null, extrudeMaterial));

      var uvs = uvgen.generateSideWallUV(this, a, b, c, d);

      this.faceVertexUvs[0].add([uvs[0], uvs[1], uvs[3]]);
      this.faceVertexUvs[0].add([uvs[1], uvs[2], uvs[3]]);
    }

    // Top and bottom faces
    //buildLidFaces() {
    if (bevelEnabled) {
      var layer = 0; // steps + 1
      var offset = vlen * layer;

      // Bottom faces

      for (var i = 0; i < flen; i++) {
        var face = faces[i];
        f3(face[2] + offset, face[1] + offset, face[0] + offset);
      }

      layer = steps + bevelSegments * 2;
      offset = vlen * layer;

      // Top faces

      for (var i = 0; i < flen; i++) {
        var face = faces[i];
        f3(face[0] + offset, face[1] + offset, face[2] + offset);
      }
    } else {
      // Bottom faces
      for (var i = 0; i < flen; i++) {
        var face = faces[i];
        f3(face[2], face[1], face[0]);
      }

      // Top faces
      for (var i = 0; i < flen; i++) {
        var face = faces[i];
        f3(face[0] + vlen * steps, face[1] + vlen * steps, face[2] + vlen * steps);
      }
    }

    void sidewalls(List contour, int layeroffset) {
      var i = contour.length;

      while (--i >= 0) {
        var j = i;
        var k = i - 1;
        if (k < 0) k = contour.length - 1;

        //console.log('b', i,j, i-1, k,vertices.length);

        var s = 0,
            sl = steps + bevelSegments * 2;

        for (s = 0; s < sl; s++) {
          var slen1 = vlen * s;
          var slen2 = vlen * (s + 1);
          var a = layeroffset + j + slen1,
              b = layeroffset + k + slen1,
              c = layeroffset + k + slen2,
              d = layeroffset + j + slen2;

          f4(a, b, c, d, contour, s, sl);
        }
      }
    }

    // Sides faces
    //buildSideFaces() {
    // Create faces for the z-sides of the shape
    var layeroffset = 0;
    sidewalls(contour, layeroffset);
    layeroffset += contour.length;

    for (var h = 0; h < holes.length; h++) {
      var ahole = holes[h];
      sidewalls(ahole, layeroffset);

      //, true
      layeroffset += ahole.length;
    }
  }
}

class ExtrudeGeometryWorldUVGenerator {
  List<Vector2> generateTopUV(Geometry geometry, int indexA, int indexB, int indexC) {
    var vertices = geometry.vertices;

    var a = vertices[indexA];
    var b = vertices[indexB];
    var c = vertices[indexC];

    return [
      new Vector2(a.x, a.y),
      new Vector2(b.x, b.y),
      new Vector2(c.x, c.y)
    ];
  }

  List<Vector2> generateSideWallUV(Geometry geometry, int indexA, int indexB, int indexC, int indexD) {
    var vertices = geometry.vertices;

    var a = vertices[indexA];
    var b = vertices[indexB];
    var c = vertices[indexC];
    var d = vertices[indexD];

    if ((a.y - b.y).abs() < 0.01) {
      return [
        new Vector2(a.x, 1 - a.z),
        new Vector2(b.x, 1 - b.z),
        new Vector2(c.x, 1 - c.z),
        new Vector2(d.x, 1 - d.z)
      ];
    } else {
      return [
        new Vector2(a.y, 1 - a.z),
        new Vector2(b.y, 1 - b.z),
        new Vector2(c.y, 1 - c.z),
        new Vector2(d.y, 1 - d.z)
      ];
    }
  }
}


