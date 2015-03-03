// r58
// TODO - dispatch events
part of three;

class GeometryAttribute<T> {
  static final String POSITION = "position";
  static final String NORMAL = "normal";
  static final String INDEX = "index";
  static final String UV = "uv";
  static final String TANGENT = "tangent";
  static final String COLOR = "color";
  int numItems, itemSize;
  T array;

  // Used in WebGL Renderer
  Buffer buffer;

  GeometryAttribute._internal(this.numItems, this.itemSize, this.array);

  factory GeometryAttribute.float32(int numItems, [int itemSize = 1]) =>
      new GeometryAttribute._internal(numItems, itemSize, new Float32List(numItems));

  factory GeometryAttribute.int16(int numItems, [int itemSize = 1]) =>
      new GeometryAttribute._internal(numItems, itemSize, new Int16List(numItems));

}

class Chunk {
  int start, count, index;
  Chunk({this.start, this.count, this.index});
}

/// This class is an efficient alternative to Geometry, because it stores all
/// data, including vertex positions, face indices, normals, colors, UVs, and
/// custom attributes within buffers; this reduces the cost of passing all this
/// data to the GPU.
///
/// This also makes BufferGeometry harder to work with than Geometry; rather
/// than accessing position data as Vector3 objects, color data as Color
/// objects, and so on, you have to access the raw data from the appropriate
/// attribute buffer. BufferGeometry is best-suited for static objects where you
/// don't need to manipulate the geometry much after instantiating it.
///
/// TODO: there are several unported methods from three.js.
class BufferGeometry implements Geometry {

  int id = GeometryCount++;

  // attributes
  Map<String, GeometryAttribute> attributes = {};

  // offsets for chunks when using indexed elements
  List<Chunk> offsets = [];

  // attributes typed arrays are kept only if dynamic flag is set
  bool _dynamic = false;

  // boundings
  var boundingBox = null;
  var boundingSphere = null;

  bool hasTangents;

  // for compatibility
  List morphTargets = [];
  List morphNormals = [];

  // WebGL
  bool verticesNeedUpdate = true,
      colorsNeedUpdate = true,
      elementsNeedUpdate = true,
      uvsNeedUpdate = true,
      normalsNeedUpdate = true,
      tangentsNeedUpdate = true,
      buffersNeedUpdate = true,
      morphTargetsNeedUpdate = true,
      lineDistancesNeedUpdate = true;
  bool __webglInit = false;
  var __webglVertexBuffer, __webglColorBuffer, __webglLineDistanceBuffer;

  applyMatrix(Matrix4 matrix) {

    var positionArray;
    var normalArray;

    if (aPosition != null) positionArray = aPosition.array;
    if (aNormal != null) normalArray = aNormal.array;

    if (positionArray != null) {

      multiplyVector3Array(matrix, positionArray);
      this["verticesNeedUpdate"] = true;

    }

    if (normalArray != null) {

      var matrixRotation = new Matrix4.identity();
      extractRotation(matrixRotation, matrix);

      multiplyVector3Array(matrixRotation, normalArray);
      this["normalsNeedUpdate"] = true;

    }

  }

  BufferGeometry();

  BufferGeometry.fromGeometry(geometry, [settings] ) {

    if(settings == null) {
      settings = { 'vertexColors': NoColors};
    }
    var vertices = geometry.vertices;
    var faces = geometry.faces;
    var faceVertexUvs = geometry.faceVertexUvs;
    var vertexColors = settings["vertexColors"];
    var hasFaceVertexUv = faceVertexUvs[ 0 ].length > 0;
    var hasFaceVertexNormals = !faces.isEmpty && faces[ 0 ].vertexNormals.length == 3;
    var colors, positions, normals, uvs;

    aPosition = new GeometryAttribute.float32( faces.length * 3 * 3, 3 );
    positions = aPosition.array;

    aNormal = new GeometryAttribute.float32( faces.length * 3 * 3, 3 );
    normals = aNormal.array;

    if ( vertexColors != NoColors ) {

      aColor = new GeometryAttribute.float32( faces.length * 3 * 3, 3 );
      colors = aColor.array;

    }

    if ( hasFaceVertexUv ) {

      aUV = new GeometryAttribute.float32( faces.length * 3 * 2, 2 );
      uvs = aUV.array;

    }

    for ( var i = 0, i2 = 0, i3 = 0; i < faces.length; i ++, i2 += 6, i3 += 9 ) {

      var face = faces[ i ];

      var a = vertices[ face.a ];
      var b = vertices[ face.b ];
      var c = vertices[ face.c ];

      positions[ i3     ] = a.x;
      positions[ i3 + 1 ] = a.y;
      positions[ i3 + 2 ] = a.z;

      positions[ i3 + 3 ] = b.x;
      positions[ i3 + 4 ] = b.y;
      positions[ i3 + 5 ] = b.z;

      positions[ i3 + 6 ] = c.x;
      positions[ i3 + 7 ] = c.y;
      positions[ i3 + 8 ] = c.z;

      if ( hasFaceVertexNormals == true ) {

        var na = face.vertexNormals[ 0 ];
        var nb = face.vertexNormals[ 1 ];
        var nc = face.vertexNormals[ 2 ];

        normals[ i3     ] = na.x;
        normals[ i3 + 1 ] = na.y;
        normals[ i3 + 2 ] = na.z;

        normals[ i3 + 3 ] = nb.x;
        normals[ i3 + 4 ] = nb.y;
        normals[ i3 + 5 ] = nb.z;

        normals[ i3 + 6 ] = nc.x;
        normals[ i3 + 7 ] = nc.y;
        normals[ i3 + 8 ] = nc.z;

      } else {

        var n = face.normal;

        normals[ i3     ] = n.x;
        normals[ i3 + 1 ] = n.y;
        normals[ i3 + 2 ] = n.z;

        normals[ i3 + 3 ] = n.x;
        normals[ i3 + 4 ] = n.y;
        normals[ i3 + 5 ] = n.z;

        normals[ i3 + 6 ] = n.x;
        normals[ i3 + 7 ] = n.y;
        normals[ i3 + 8 ] = n.z;

      }

      if ( vertexColors == FaceColors ) {

        var fc = face.color;

        colors[ i3     ] = fc.r;
        colors[ i3 + 1 ] = fc.g;
        colors[ i3 + 2 ] = fc.b;

        colors[ i3 + 3 ] = fc.r;
        colors[ i3 + 4 ] = fc.g;
        colors[ i3 + 5 ] = fc.b;

        colors[ i3 + 6 ] = fc.r;
        colors[ i3 + 7 ] = fc.g;
        colors[ i3 + 8 ] = fc.b;

      } else if ( vertexColors == VertexColors ) {

        var vca = face.vertexColors[ 0 ];
        var vcb = face.vertexColors[ 1 ];
        var vcc = face.vertexColors[ 2 ];

        colors[ i3     ] = vca.r;
        colors[ i3 + 1 ] = vca.g;
        colors[ i3 + 2 ] = vca.b;

        colors[ i3 + 3 ] = vcb.r;
        colors[ i3 + 4 ] = vcb.g;
        colors[ i3 + 5 ] = vcb.b;

        colors[ i3 + 6 ] = vcc.r;
        colors[ i3 + 7 ] = vcc.g;
        colors[ i3 + 8 ] = vcc.b;

      }

      if ( hasFaceVertexUv == true ) {

        var uva = faceVertexUvs[ 0 ][ i ][ 0 ];
        var uvb = faceVertexUvs[ 0 ][ i ][ 1 ];
        var uvc = faceVertexUvs[ 0 ][ i ][ 2 ];

        uvs[ i2     ] = uva.u;
        uvs[ i2 + 1 ] = uva.v;

        uvs[ i2 + 2 ] = uvb.u;
        uvs[ i2 + 3 ] = uvb.v;

        uvs[ i2 + 4 ] = uvc.u;
        uvs[ i2 + 5 ] = uvc.v;

      }

    }

    this.computeBoundingSphere();

  }

  /// Computes bounding box of the geometry, updating Geometry.boundingBox.
  computeBoundingBox() {

    if (boundingBox == null) {

      boundingBox = new BoundingBox(
          min: new Vector3(double.INFINITY, double.INFINITY, double.INFINITY),
          max: new Vector3(-double.INFINITY, -double.INFINITY, -double.INFINITY));

    }

    var positions = aPosition.array;

    if (positions) {

      var bb = boundingBox;
      var x, y, z;

      for (var i = 0,
          il = positions.length; i < il; i += 3) {

        x = positions[i];
        y = positions[i + 1];
        z = positions[i + 2];

        // bounding box

        if (x < bb.min.x) {

          bb.min.x = x;

        } else if (x > bb.max.x) {

          bb.max.x = x;

        }

        if (y < bb.min.y) {

          bb.min.y = y;

        } else if (y > bb.max.y) {

          bb.max.y = y;

        }

        if (z < bb.min.z) {

          bb.min.z = z;

        } else if (z > bb.max.z) {

          bb.max.z = z;

        }

      }

    }

    if (positions == null || positions.length == 0) {

      boundingBox.min.setValues(0, 0, 0);
      boundingBox.max.setValues(0, 0, 0);

    }

  }

  /// Computes bounding sphere of the geometry, updating Geometry.boundingSphere.
  ///
  /// Neither bounding boxes or bounding spheres are computed by default.
  /// They need to be explicitly computed, otherwise they are null.
  computeBoundingSphere() {

    if (boundingSphere == null) boundingSphere = new BoundingSphere(radius: 0);

    var positions = aPosition.array;

    if (positions != null) {

      var radiusSq,
          maxRadiusSq = 0;
      var x, y, z;

      for (var i = 0,
          il = positions.length; i < il; i += 3) {

        x = positions[i];
        y = positions[i + 1];
        z = positions[i + 2];

        radiusSq = x * x + y * y + z * z;
        if (radiusSq > maxRadiusSq) maxRadiusSq = radiusSq;

      }

      boundingSphere.radius = Math.sqrt(maxRadiusSq);

    }

  }

  /// Computes vertex normals by averaging face normals.
  /// Face normals must be existing / computed beforehand.
  computeVertexNormals() {

    if (aPosition != null && aIndex != null) {

      var i, il;
      var j, jl;

      if (aNormal == null) {

        attributes[GeometryAttribute.NORMAL] = new GeometryAttribute.float32(aPosition.numItems, 3);

      } else {

        // reset existing normals to zero
        il = aNormal.array.length;

        for (i = 0; i < il; i++) {

          attributes["normal"].array[i] = 0.0;

        }

      }

      var indices = aIndex.array;
      var positions = aPosition.array;
      var normals = aNormal.array;

      var vA,
          vB,
          vC,
          x,
          y,
          z,

          pA = new Vector3.zero(),
          pB = new Vector3.zero(),
          pC = new Vector3.zero(),

          cb = new Vector3.zero(),
          ab = new Vector3.zero();

      jl = offsets.length;
      for (j = 0; j < jl; ++j) {

        var start = offsets[j].start;
        var count = offsets[j].count;
        var index = offsets[j].index;

        il = start + count;
        for (i = start; i < il; i += 3) {

          vA = index + indices[i];
          vB = index + indices[i + 1];
          vC = index + indices[i + 2];

          x = positions[vA * 3];
          y = positions[vA * 3 + 1];
          z = positions[vA * 3 + 2];
          pA.setValues(x, y, z);

          x = positions[vB * 3];
          y = positions[vB * 3 + 1];
          z = positions[vB * 3 + 2];
          pB.setValues(x, y, z);

          x = positions[vC * 3];
          y = positions[vC * 3 + 1];
          z = positions[vC * 3 + 2];
          pC.setValues(x, y, z);

          cb = pC - pB;
          ab = pA - pB;
          cb = cb.cross(ab);

          normals[vA * 3] += cb.x;
          normals[vA * 3 + 1] += cb.y;
          normals[vA * 3 + 2] += cb.z;

          normals[vB * 3] += cb.x;
          normals[vB * 3 + 1] += cb.y;
          normals[vB * 3 + 2] += cb.z;

          normals[vC * 3] += cb.x;
          normals[vC * 3 + 1] += cb.y;
          normals[vC * 3 + 2] += cb.z;

        }

      }

      // normalize normals
      il = normals.length;
      for (i = 0; i < il; i += 3) {

        x = normals[i];
        y = normals[i + 1];
        z = normals[i + 2];

        var n = 1.0 / Math.sqrt(x * x + y * y + z * z);

        normals[i] *= n;
        normals[i + 1] *= n;
        normals[i + 2] *= n;

      }

      normalsNeedUpdate = true;

    }

  }

  /// Computes vertex tangents.
  /// Based on http://www.terathon.com/code/tangent.html
  /// Geometry must have vertex UVs (layer 0 will be used).
  computeTangents() {

    // based on http://www.terathon.com/code/tangent.html
    // (per vertex tangents)

    if (aIndex == null || aPosition == null || aNormal == null || aUV == null) {

      print("Missing required attributes (index, position, normal or uv) in BufferGeometry.computeTangents()");
      return;

    }

    var indices = aIndex.array;
    var positions = aPosition.array;
    var normals = aNormal.array;
    var uvs = aUV.array;

    var nVertices = aPosition.numItems ~/ 3;

    if (aTangent == null) {

      attributes["tangent"] = new GeometryAttribute.float32(nVertices, 4);

    }

    var tangents = aTangent.array;

    List<Vector3> tan1 = [],
        tan2 = [];

    for (var k = 0; k < nVertices; k++) {

      tan1[k] = new Vector3.zero();
      tan2[k] = new Vector3.zero();

    }

    var xA, yA, zA, xB, yB, zB, xC, yC, zC, uA, vA, uB, vB, uC, vC, x1, x2, y1, y2, z1, z2, s1, s2, t1, t2, r;

    var sdir = new Vector3.zero(),
        tdir = new Vector3.zero();

    var handleTriangle = (a, b, c) {

      xA = positions[a * 3];
      yA = positions[a * 3 + 1];
      zA = positions[a * 3 + 2];

      xB = positions[b * 3];
      yB = positions[b * 3 + 1];
      zB = positions[b * 3 + 2];

      xC = positions[c * 3];
      yC = positions[c * 3 + 1];
      zC = positions[c * 3 + 2];

      uA = uvs[a * 2];
      vA = uvs[a * 2 + 1];

      uB = uvs[b * 2];
      vB = uvs[b * 2 + 1];

      uC = uvs[c * 2];
      vC = uvs[c * 2 + 1];

      x1 = xB - xA;
      x2 = xC - xA;

      y1 = yB - yA;
      y2 = yC - yA;

      z1 = zB - zA;
      z2 = zC - zA;

      s1 = uB - uA;
      s2 = uC - uA;

      t1 = vB - vA;
      t2 = vC - vA;

      r = 1.0 / (s1 * t2 - s2 * t1);

      sdir.setValues((t2 * x1 - t1 * x2) * r, (t2 * y1 - t1 * y2) * r, (t2 * z1 - t1 * z2) * r);

      tdir.setValues((s1 * x2 - s2 * x1) * r, (s1 * y2 - s2 * y1) * r, (s1 * z2 - s2 * z1) * r);

      tan1[a].add(sdir);
      tan1[b].add(sdir);
      tan1[c].add(sdir);

      tan2[a].add(tdir);
      tan2[b].add(tdir);
      tan2[c].add(tdir);

    };

    var i, il;
    var j, jl;
    var iA, iB, iC;

    jl = offsets.length;
    for (j = 0; j < jl; ++j) {

      var start = offsets[j].start;
      var count = offsets[j].count;
      var index = offsets[j].index;

      il = start + count;
      for (i = start; i < il; i += 3) {

        iA = index + indices[i];
        iB = index + indices[i + 1];
        iC = index + indices[i + 2];

        handleTriangle(iA, iB, iC);

      }

    }

    var tmp = new Vector3.zero(),
        tmp2 = new Vector3.zero();
    var n = new Vector3.zero(),
        n2 = new Vector3.zero();
    var w, t, test;
    var nx, ny, nz;

    var handleVertex = (v) {

      n.x = normals[v * 3];
      n.y = normals[v * 3 + 1];
      n.z = normals[v * 3 + 2];

      n2.setFrom(n);

      t = tan1[v];

      // Gram-Schmidt orthogonalize

      tmp.setFrom(t);
      tmp.sub(n.scale(n.dot(t))).normalize();

      // Calculate handedness

      tmp2 = n2.cross(t);
      test = tmp2.dot(tan2[v]);
      w = (test < 0.0) ? -1.0 : 1.0;

      tangents[v * 4] = tmp.x;
      tangents[v * 4 + 1] = tmp.y;
      tangents[v * 4 + 2] = tmp.z;
      tangents[v * 4 + 3] = w;

    };

    jl = offsets.length;
    for (j = 0; j < jl; ++j) {

      var start = offsets[j].start;
      var count = offsets[j].count;
      var index = offsets[j].index;

      il = start + count;
      for (i = start; i < il; i += 3) {

        iA = index + indices[i];
        iB = index + indices[i + 1];
        iC = index + indices[i + 2];

        handleVertex(iA);
        handleVertex(iB);
        handleVertex(iC);

      }

    }

    hasTangents = true;
    this["tangentsNeedUpdate"] = true;

  }

  // dynamic is a reserved word in Dart
  bool get isDynamic => _dynamic;
  set isDynamic(bool value) => _dynamic = value;

  // default attributes
  GeometryAttribute<Float32List> get aPosition => attributes[GeometryAttribute.POSITION];
  set aPosition(a) {
    attributes[GeometryAttribute.POSITION] = a;
  }

  GeometryAttribute<Float32List> get aNormal => attributes[GeometryAttribute.NORMAL];
  set aNormal(a) {
    attributes[GeometryAttribute.NORMAL] = a;
  }

  GeometryAttribute<Int16List> get aIndex => attributes[GeometryAttribute.INDEX];
  set aIndex(a) {
    attributes[GeometryAttribute.INDEX] = a;
  }

  GeometryAttribute<Float32List> get aUV => attributes[GeometryAttribute.UV];
  set aUV(a) {
    attributes[GeometryAttribute.UV] = a;
  }

  GeometryAttribute<Float32List> get aTangent => attributes[GeometryAttribute.TANGENT];
  set aTangent(a) {
    attributes[GeometryAttribute.TANGENT] = a;
  }

  GeometryAttribute<Float32List> get aColor => attributes[GeometryAttribute.COLOR];
  set aColor(a) {
    attributes[GeometryAttribute.COLOR] = a;
  }

  noSuchMethod(Invocation invocation) {
    throw new Exception('Unimplemented ${invocation.memberName}');
  }

}
