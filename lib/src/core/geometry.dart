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

/// Base class for geometries.
/// A geometry holds all data necessary to describe a 3D model.
// TODO - Create a IGeometry with only the necessary interface methods
class Geometry extends Object with WebGLGeometry {

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


  // WebGL
  bool  verticesNeedUpdate = false,
        colorsNeedUpdate = false,
        elementsNeedUpdate = false,
        uvsNeedUpdate = false,
        normalsNeedUpdate = false,
        tangentsNeedUpdate = false,
        buffersNeedUpdate = false,
        morphTargetsNeedUpdate = false,
        lineDistancesNeedUpdate = false;

  Geometry()
      : name = '',

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

        _dynamic = false // unless set to true the *Arrays will be deleted once sent to a buffer.
  {
    id = GeometryCount ++;
  }

  /// Defaults to true.
  // named isDynamic because dynamic is a reserved word in Dart
  bool get isDynamic => _dynamic;
  /// Set to true if attribute buffers will need to change in runtime (using "dirty" flags).
  /// Unless set to true internal typed arrays corresponding to buffers will be
  /// deleted once sent to GPU.
  ///
  /// Defaults to true.
  // named isDynamic because dynamic is a reserved word in Dart
  set isDynamic(bool value) => _dynamic = value;

  /// Bakes matrix transform directly into vertex coordinates.
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

  /// Computes face normals.
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

  /// Computes vertex normals by averaging face normals.
  ///
  /// Face normals must be existing / computed beforehand.
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

  /// Computes vertex tangents.
  ///
  /// Based on http://www.terathon.com/code/tangent.html
  /// Geometry must have vertex UVs (layer 0 will be used).
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

  /// Computes bounding box of the geometry, updating Geometry.boundingBox.
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

  /// Computes bounding sphere of the geometry, updating Geometry.boundingSphere.
  ///
  /// Neither bounding boxes or bounding spheres are computed by default.
  /// They need to be explicitly computed, otherwise they are null.
  void computeBoundingSphere() {
    num radiusSq;

    var maxRadiusSq = vertices.fold(0, (num curMaxRadiusSq, Vector3 vertex) {
      radiusSq = vertex.length2;
      return ( radiusSq > curMaxRadiusSq ) ?  radiusSq : curMaxRadiusSq;
    });

    boundingSphere = new BoundingSphere(radius: Math.sqrt(maxRadiusSq) );
  }

  /// Checks for duplicate vertices with hashmap.
  /// Duplicated vertices are removed
  /// and faces' vertices are updated.
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

  Aabb3 _aabb3;

  get min => _aabb3.min;
  get max => _aabb3.max;

  BoundingBox({Vector3 min, Vector3 max}) : _aabb3 = new Aabb3.copyMinMax(min,max);

  BoundingBox.fromPoints( Iterable<Vector3> points ) {
    _aabb3 = new Aabb3.copyMinMax(points.first, points.first);
    points.skip(1).forEach( (point) => _aabb3.hullPoint(point));
  }

  BoundingBox.fromCenterAndSize( Vector3 center, Vector3 size ) {
    var halfSize = new Vector3.copy( size ).multiplyScalar( 0.5 );
    _aabb3 = new Aabb3.copyMinMax(new Vector3.copy( center ).sub( haldSize ), new Vector3.copy( center ).add( haldSize ));
  }

  BoundingBox.fromObject( Object3D object ) {
    object.updateMatrixWorld(true);
    object.traverse(( node ) {
      var geometry = node.geometry;
      if( geometry is BufferGeometry ) {
        if(geometry.aPosition != null) {
          var position = new Vector3.zero();
          var a = geometry.aPosition.array;
          var il = a.length;
          for ( var i = 0; i < il; i += 3 ) {
            position.setValues( a[ i ], a[ i + 1 ],a[ i + 2 ] ).applyProjection( node.matrixWorld );
            if(_aabb3 == null) {
              _aabb3 = new Aabb3.copyMinMax(position,position);
            } else {
              _aabb3.hullPoint(position);
            }
          }
        }
      } else if (geometry is Geometry) {
        geometry.vertices.forEach( (vertice) {
          var transfVertice = new Vector3.copy(vertice).applyProjection(node.matrixWorld);
          if(_aabb3 == null) {
            _aabb3 = new Aabb3.copyMinMax(transfVertice,transfVertice);
          } else {
            _aabb3.hullPoint(transfVertice);
          }
        });
      }
    });
    if( _aabb3 == null ) {
      _aabb3 = new Aabb3();
    }
  }

  set copy( BoundingBox box ) => _aabb3.copyMinMax(box.min,box.max);

  bool get isEmpty => ( this.max.x < this.min.x ) || ( this.max.y < this.min.y ) || ( this.max.z < this.min.z );

  Vector3 get center =>  _aabb3.center;

  Vector3 get size => new Vector3.copy( this.max ).sub( this.min );

  expandByPoint( Vector3 point ) => _aabb3.hullPoint( point );

  expandByVector( Vector3 vector ) => _aabb3.copyMinMax(_aabb3.min.sub(vector),_aabb3.max.add(vector));

  expandByScalar( num scalar ) => _aabb3.copyMinMax(_aabb3.min.addScalar(-scalar),_aabb3.max.addScalar(scalar));

  bool containsPoint( Vector3 point ) => _aabb3.containsVector3(point);

  bool containsBox( BoundingBox box ) => _aabb3.containsAabb3( new _aabb3.copyMinMax(box.min,box.max) );

  Vector3 getParameter( Vector3 point ) => new Vector3.array([( point.x - min.x ) / ( max.x - min.x ),
                                                    ( point.y - min.y ) / ( max.y - min.y ),
                                                    ( point.z - min.z ) / ( max.z - min.z )]
  );

  bool isIntersectionBox( BoundingBox box) => _aabb3.intersectsWithAabb3( new _aabb3.copyMinMax(box.min,box.max) );

  //todo: clampPoint

  //todo: distanceToPoint

  BoundingSphere get boundingSphere => new BoundingSphere( size.length * 0.5, center );

  intersect( BoundingBox box ) {
    _aabb3.min.max( box.min );
    _aabb3.max.min( box.max );
  }

  union( BoundingBox box ) {
    _aabb3.min.min( box.min );
    _aabb3.max.min( box.max );
  }

  applyMatrix4( Matrix4 matrix ) {
    _aabb3.transform( matrix );
  }

  translate( Vector3 offset ) {
    _aabb3.min.add( offset );
    _aabb3.max.add( offset );
  }

  bool operator== ( BoundingBox box ) => min == box.min && max == box.max;

  BoundingBox clone() => new BoundingBox( min, max );

}

class BoundingSphere {
  num radius;
  Vector3 center;
  BoundingSphere({this.radius, this.center});
}
