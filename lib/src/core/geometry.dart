part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author kile / http://kile.stravaganza.org/
 * @author alteredq / http://alteredqualia.com/
 * @author mikael emtinger / http://gomo.se/
 * @author zz85 / http://www.lab4games.net/zz85/blog
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Geometry {

  int id;

  String name;

  List<Vector3> vertices;

  List colors; // one-to-one vertex colors, used in ParticleSystem, Line and Ribbon
  List normals = []; // one-to-one vertex normals, used in Ribbon

  List materials;
  List<Face> faces;

  List faceUvs;
  List<List> faceVertexUvs;

  List<MorphTarget> morphTargets;
  List morphColors, morphNormals;
  List skinWeights, skinIndices;
  List lineDistances;

  List<Vector3> __tmpVertices;

  BoundingBox boundingBox;
  BoundingSphere boundingSphere;

  bool hasTangents, _dynamic;

  // Used in JSONLoader
  var bones, animation;

  Geometry()
      : id = GeometryCount ++,

        name = '',

        vertices = <Vector3>[],
        colors = [], // one-to-one vertex colors, used in ParticleSystem, Line and Ribbon

        materials = [],

        faces = [],

        faceUvs = [[]],
        faceVertexUvs = [[]],

        morphTargets = [],
        morphColors = [],
        morphNormals = [],

        skinWeights = [],
        skinIndices = [],

        lineDistances = [],

        boundingBox = null,
        boundingSphere = null,

        hasTangents = false,

        _dynamic = false; // unless set to true the *Arrays will be deleted once sent to a buffer.

  // dynamic is a reserved word in Dart
  bool get isDynamic => _dynamic;
  set isDynamic(bool value) => _dynamic = value;

  void applyMatrix( Matrix4 matrix ) {
    Matrix4 matrixRotation = new Matrix4.identity();
    extractRotation( matrixRotation, matrix);

    vertices.forEach((vertex) =>  vertex.applyProjection(matrix));

    faces.forEach((face) {

      face.normal.applyProjection(matrixRotation);

      face.vertexNormals.forEach((normal) => normal.applyProjection(matrixRotation));

      face.centroid.applyProjection(matrix);
    });
  }

  void computeCentroids() {

    faces.forEach((Face face) {

      face.centroid.setValues( 0.0, 0.0, 0.0 );

      face.indices.forEach((idx) {
        face.centroid.add( vertices[ idx ] );
      });

      face.centroid /= face.size.toDouble();

    });
  }

  void computeFaceNormals() {
    faces.forEach((face) {

      var vA = vertices[ face.a ],
          vB = vertices[ face.b ],
          vC = vertices[ face.c ];

      Vector3 cb = vC - vB;
      Vector3 ab = vA - vB;
      cb = cb.cross( ab );

      cb.normalize();

      face.normal = cb;

    });
  }

  void computeVertexNormals() {

    List<Vector3> vertices;


    // create internal buffers for reuse when calling this method repeatedly
    // (otherwise memory allocation / deallocation every frame is big resource hog)
    if ( __tmpVertices == null ) {

      __tmpVertices = [];
      this.vertices.forEach((_) => __tmpVertices.add(new Vector3.zero()));
      vertices = __tmpVertices;

      faces.forEach((face) {
        face.vertexNormals = new List.generate(face.size, (_) => new Vector3.zero(), growable: false);
      });

    } else {
      vertices = __tmpVertices;

      var vl = this.vertices.length;
      for ( var v = 0; v < vl; v ++ ) {
        vertices[ v ].setValues( 0.0, 0.0, 0.0 );
      }

    }

    faces.forEach((Face face) {

      face.indices.forEach((idx) {
        vertices[ idx ].add( face.normal );
      });

    });

    vertices.forEach((v) => v.normalize());

    faces.forEach((Face face) {

      var i = 0;
      face.indices.forEach((idx) {
        face.vertexNormals[ i++ ].setFrom( vertices[ idx ] );
      });

    });
  }

  // TODO - computeMorphNormals

  void computeTangents() {
    // based on http://www.terathon.com/code/tangent.html
    // tangents go to vertices

    var f, fl, face;
    num i, il, vertexIndex, test, w;
    Vector3 vA, vB, vC;
    UV uvA, uvB, uvC;

    List uv;

    num x1, x2, y1, y2, z1, z2, s1, s2, t1, t2, r;

    Vector3 sdir = new Vector3.zero(),
            tdir = new Vector3.zero(),
            tmp = new Vector3.zero(),
            tmp2 = new Vector3.zero(),
            n = new Vector3.zero(),
            t;

    List<Vector3> tan1 = vertices.map((_) => new Vector3.zero()).toList(),
                  tan2 = vertices.map((_) => new Vector3.zero()).toList();

    var handleTriangle = ( context, a, b, c, ua, ub, uc ) {

      vA = context.vertices[ a ];
      vB = context.vertices[ b ];
      vC = context.vertices[ c ];

      uvA = uv[ ua ];
      uvB = uv[ ub ];
      uvC = uv[ uc ];

      x1 = vB.x - vA.x;
      x2 = vC.x - vA.x;
      y1 = vB.y - vA.y;
      y2 = vC.y - vA.y;
      z1 = vB.z - vA.z;
      z2 = vC.z - vA.z;

      s1 = uvB.u - uvA.u;
      s2 = uvC.u - uvA.u;
      t1 = uvB.v - uvA.v;
      t2 = uvC.v - uvA.v;

      r = 1.0 / ( s1 * t2 - s2 * t1 );
      sdir.setValues( ( t2 * x1 - t1 * x2 ) * r,
          ( t2 * y1 - t1 * y2 ) * r,
          ( t2 * z1 - t1 * z2 ) * r );
      tdir.setValues( ( s1 * x2 - s2 * x1 ) * r,
            ( s1 * y2 - s2 * y1 ) * r,
            ( s1 * z2 - s2 * z1 ) * r );

      tan1[ a ].add( sdir );
      tan1[ b ].add( sdir );
      tan1[ c ].add( sdir );

      tan2[ a ].add( tdir );
      tan2[ b ].add( tdir );
      tan2[ c ].add( tdir );

    };

    fl = this.faces.length;

    for ( f = 0; f < fl; f ++ ) {

      face = this.faces[ f ];
      UV uv = faceVertexUvs[ 0 ][ f ]; // use UV layer 0 for tangents

      // TODO - Come up with a way to handle an arbitrary number of vertexes
      var triangles = [];
      if ( face.size == 3 ) {
        triangles.add([0, 1, 2]);
      } else if ( face.size == 4 ) {
        triangles.add([0, 1, 3]);
        triangles.add([1, 2, 3]);
      }

      triangles.forEach((t) {
        handleTriangle( this, face.indices[t[0]], face.indices[t[1]], face.indices[t[2]], t[0], t[1], t[2] );
      });
    }

    faces.forEach((face) {

      il = face.vertexNormals.length;

      for ( i = 0; i < il; i++ ) {

        n.setFrom( face.vertexNormals[ i ] );

        vertexIndex = face.indices[i];

        t = tan1[ vertexIndex ];

        // Gram-Schmidt orthogonalize

        tmp.setFrom( t );
        tmp.sub( n.scale( n.dot( t ) ) ).normalize();

        // Calculate handedness

        tmp2 = face.vertexNormals[i].cross(t);
        test = tmp2.dot( tan2[ vertexIndex ] );
        w = (test < 0.0) ? -1.0 : 1.0;

        face.vertexTangents[ i ] = new Vector4( tmp.x, tmp.y, tmp.z, w );

      }

    });

    hasTangents = true;

  }

  void computeBoundingBox() {
    if ( boundingBox == null ) {
      boundingBox = new BoundingBox( min: new Vector3.zero(), max: new Vector3.zero() );
    }

    if ( vertices.length > 0 ) {
      Vector3 position, firstPosition = vertices[ 0 ];

      boundingBox.min.setFrom( firstPosition );
      boundingBox.max.setFrom( firstPosition );

      Vector3 min = boundingBox.min,
              max = boundingBox.max;

      num vl = vertices.length;
      for ( int v = 1; v < vl; v ++ ) {
        position = vertices[ v ];

        if ( position.x < min.x ) {
          min.x = position.x;
        } else if ( position.x > max.x ) {
          max.x = position.x;
        }

        if ( position.y < min.y ) {
          min.y = position.y;
        } else if ( position.y > max.y ) {
          max.y = position.y;
        }

        if ( position.z < min.z ) {
          min.z = position.z;
        } else if ( position.z > max.z ) {
          max.z = position.z;
        }
      }
    }
  }

  void computeBoundingSphere() {
    num radiusSq;

    var maxRadiusSq = vertices.fold(0, (num curMaxRadiusSq, Vector3 vertex) {
      radiusSq = vertex.length2;
      return ( radiusSq > curMaxRadiusSq ) ?  radiusSq : curMaxRadiusSq;
    });

    boundingSphere = new BoundingSphere(radius: Math.sqrt(maxRadiusSq) );
  }

  /*
   * Checks for duplicate vertices with hashmap.
   * Duplicated vertices are removed
   * and faces' vertices are updated.
   */

  int mergeVertices() {
    Map verticesMap = {}; // Hashmap for looking up vertice by position coordinates (and making sure they are unique)
    List<Vector3> unique = [];
    List<int> changes = [];

    String key;
    int precisionPoints = 4; // number of decimal points, eg. 4 for epsilon of 0.0001
    num precision = Math.pow( 10, precisionPoints );
    int i, il;
    var abcd = 'abcd', o, k, j, jl, u;

    Vector3 v;
    il = this.vertices.length;

    for( i = 0; i < il; i++) {
      v = this.vertices[i];

      key = [ ( v.x * precision ).round().toStringAsFixed(0),
                            ( v.y * precision ).round().toStringAsFixed(0),
                            ( v.z * precision ).round().toStringAsFixed(0) ].join('_' );

      if ( verticesMap[ key ] == null ) {
        verticesMap[ key ] = i;
        unique.add( v );
        //TODO: pretty sure this is an acceptable change in syntax here:
        //changes[ i ] = unique.length - 1;
        changes.add( unique.length - 1);
      } else {
        //print('Duplicate vertex found. $i could be using  ${verticesMap[key]}');
        //print('changes len ${changes.length} add at i = $i');
        //changes[ i ] = changes[ verticesMap[ key ] ];
        changes.add( changes[ verticesMap[ key ] ] );
      }

    }


    // Start to patch face indices

    faces.forEach((Face face) {
      for (var i = 0; i < face.size; i++) {
        face.indices[i] = changes[ face.indices[i] ];

        /* TODO

        // check dups in (a, b, c, d) and convert to -> face3

        var o = [ face.a, face.b, face.c, face.d ];

        for ( var k = 3; k > 0; k -- ) {

          if ( o.indexOf( face[ abcd[ k ] ] ) != k ) {

            // console.log('faces', face.a, face.b, face.c, face.d, 'dup at', k);

            o.removeAt( k );

            this.faces[ i ] = new THREE.Face3( o[0], o[1], o[2], face.normal, face.color, face.materialIndex );

            for ( j = 0, jl = this.faceVertexUvs.length; j < jl; j ++ ) {

              u = this.faceVertexUvs[ j ][ i ];
              if ( u ) u.removeAt( k );

            }

            this.faces[ i ].vertexColors = face.vertexColors;

            break;
          }

        }*/

      }
    });

    // Use unique set of vertices
    var diff = vertices.length - unique.length;
    vertices = unique;
    return diff;
  }

  clone() {

    // TODO

  }

  // Quick hack to allow setting new properties (used by the renderer)
  Map __data;

  get _data {
    if (__data == null) {
      __data = {};
    }
    return __data;
  }

  operator [] (String key) => _data[key];
  operator []= (String key, value) => _data[key] = value;
}

class BoundingBox {
  Vector3 min;
  Vector3 max;
  BoundingBox({this.min, this.max});
}

class BoundingSphere {
  num radius;
  BoundingSphere({this.radius});
}
