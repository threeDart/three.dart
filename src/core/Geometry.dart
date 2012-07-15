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

class Geometry 
{
  int _id;

  List<Vertex> _vertices;
  List _colors, _materials;
  List<IFace3> _faces;
  
  //TODO: not entirely sure these should be declared here...
  List tan1, tan2;

  List _faceUvs;// = [[]];
  List<List> _faceVertexUvs;// = [[]];

  List _morphTargets, _morphColors, _skinWeights, _skinIndices;

  List __tmpVertices;
  
  Map _boundingBox, _boundingSphere;

  bool _hasTangents, _dynamic;
  
  Map get boundingSphere() {  return _boundingSphere;  }
  List get morphTargets() {  return _morphTargets;  }
  List<IFace3> get faces() {  return _faces;  }
  List get materials() {  return _materials;  }
  List<Vertex> get vertices() {  return _vertices;  }
  List<List> get faceVertexUvs() {  return _faceVertexUvs;  }
  
  //TODO: is this in the right scope?
//  THREE.GeometryCount = 0;
//  static int GeometryCount = 0;
  
  Geometry() 
  {
    _id = Three.GeometryCount ++;

    _vertices = [];
    _colors = []; // one-to-one vertex colors, used in ParticleSystem, Line and Ribbon

    _materials = [];

    _faces = [];

    _faceUvs = [[]];
    _faceVertexUvs = [];//[[]];
    _faceVertexUvs.add(new List());

    _morphTargets = [];
    _morphColors = [];

    _skinWeights = [];
    _skinIndices = [];

    _boundingBox = null;
    _boundingSphere = null;

    _hasTangents = false;

    _dynamic = false; // unless set to true the *Arrays will be deleted once sent to a buffer.
  }

  void applyMatrix( Matrix4 matrix ) 
  {
    Matrix4 matrixRotation = new Matrix4();
    //TODO: figure out why this has extra arg...
    matrixRotation.extractRotation( matrix);//, new Vector3( 1, 1, 1 ) );

    for ( int i = 0, il = _vertices.length; i < il; i ++ ) 
    {
      Vertex vertex = _vertices[ i ];

      matrix.multiplyVector3( vertex.position );
    }

    for ( int i = 0, il = _faces.length; i < il; i ++ )
    {
      IFace3 face = _faces[ i ];

      matrixRotation.multiplyVector3( face.normal );

      for ( int j = 0, jl = face.vertexNormals.length; j < jl; j ++ ) {
        matrixRotation.multiplyVector3( face.vertexNormals[ j ] );
      }

      matrix.multiplyVector3( face.centroid );
    }
  }

  void computeCentroids()
  {
    int f;
    int fl = _faces.length;
    //TODO: face should be typed
    IFace3 face;

    for ( f = 0; f < fl; f ++ ) 
    {
      face = _faces[ f ];
      face.centroid.setValues( 0, 0, 0 );

      if ( face is Face3 ) {
        face.centroid.addSelf( _vertices[ face.a ].position );
        face.centroid.addSelf( _vertices[ face.b ].position );
        face.centroid.addSelf( _vertices[ face.c ].position );
        face.centroid.divideScalar( 3 );
      } else if ( face is Face4 ) {
        Face4 face4 = face;
        face4.centroid.addSelf( _vertices[ face4.a ].position );
        face4.centroid.addSelf( _vertices[ face4.b ].position );
        face4.centroid.addSelf( _vertices[ face4.c ].position );
        face4.centroid.addSelf( _vertices[ face4.d ].position );
        face4.centroid.divideScalar( 4 );
      }
    }
  }

  void computeFaceNormals() 
  {
    num n, nl, v, vl, f;  
    Vertex vertex;
    int fl = _faces.length;
    //TODO: face should be typed
    IFace3 face;
    Vertex vA, vB, vC;
    Vector3 cb = new Vector3(), ab = new Vector3();

    for ( f = 0; f < fl; f ++ )
    {
      face = _faces[ f ];

      vA = _vertices[ face.a ];
      vB = _vertices[ face.b ];
      vC = _vertices[ face.c ];

      cb.sub( vC.position, vB.position );
      ab.sub( vA.position, vB.position );
      cb.crossSelf( ab );

      if ( !cb.isZero() ) {
        cb.normalize();
      }

      face.normal.copy( cb );
    }
  }

  void computeVertexNormals() 
  {
    int v, f; 
    int vl = _vertices.length;
    int fl = _faces.length;
    //TODO: face should be typed
    IFace3 face;
    List vertices;
    
    Vector3 v3;

    // create internal buffers for reuse when calling this method repeatedly
    // (otherwise memory allocation / deallocation every frame is big resource hog)
    if ( __tmpVertices === null ) 
    {
      __tmpVertices = new List( vertices.length );
      vertices = __tmpVertices;

      for ( v = 0; v < vl; v ++ ) {
        vertices[ v ] = new Vector3();
      }

      for ( f = 0; f < fl; f ++ )
      {
        face = _faces[ f ];

        if ( face is Face3 ) {
          face.vertexNormals = [ new Vector3(), new Vector3(), new Vector3() ];

        } else if ( face is Face4 ) {
          face.vertexNormals = [ new Vector3(), new Vector3(), new Vector3(), new Vector3() ];
        }
      }

    } else {
      vertices = __tmpVertices;
      vl =_vertices.length;

      for ( v = 0; v < vl; v ++ ) {
        v3 = vertices[v];
        v3.setValues( 0, 0, 0 );
      }
    }

    fl = _faces.length;
    for ( f = 0; f < fl; f ++ )
    {
      face = _faces[ f ];

      if ( face is Face3 ) {
        vertices[ face.a ].addSelf( face.normal );
        vertices[ face.b ].addSelf( face.normal );
        vertices[ face.c ].addSelf( face.normal );
      } else if ( face is Face4 ) {
        Face4 face4 = face;
        vertices[ face4.a ].addSelf( face4.normal );
        vertices[ face4.b ].addSelf( face4.normal );
        vertices[ face4.c ].addSelf( face4.normal );
        vertices[ face4.d ].addSelf( face4.normal );
      }
    }
    
    vl = _vertices.length;
    for ( v = 0; v < vl; v ++ ) {
      v3 = vertices[v];
      v3.normalize();
    }

    fl = _faces.length;
    for ( f = 0; f < fl; f ++ ) {
      face = _faces[ f ];

      if ( face is Face3 ) {
        face.vertexNormals[ 0 ].copy( vertices[ face.a ] );
        face.vertexNormals[ 1 ].copy( vertices[ face.b ] );
        face.vertexNormals[ 2 ].copy( vertices[ face.c ] );
      } else if ( face is Face4 ) {
        Face4 face4 = face;
        face4.vertexNormals[ 0 ].copy( vertices[ face4.a ] );
        face4.vertexNormals[ 1 ].copy( vertices[ face4.b ] );
        face4.vertexNormals[ 2 ].copy( vertices[ face4.c ] );
        face4.vertexNormals[ 3 ].copy( vertices[ face4.d ] );
      }
    }
  }

  void computeTangents()
  {
    // based on http://www.terathon.com/code/tangent.html
    // tangents go to vertices

    int f, fl, v, vl;
    num i, il, vertexIndex, test, w;
      
    tan1 = [];
    tan2 = [];
      
    IFace3 face;  
      
    Vector3 tmp = new Vector3(), tmp2 = new Vector3(), n = new Vector3(), t;

    vl = _vertices.length;
    
    for ( v = 0; v < vl; v ++ ) {
      tan1[ v ] = new Vector3();
      tan2[ v ] = new Vector3();
    }

    fl = _faces.length;
    for ( f = 0; f < fl; f ++ ) 
    {
      face = _faces[ f ];
      UV uv = _faceVertexUvs[ 0 ][ f ]; // use UV layer 0 for tangents

      if ( face is Face3 ) {
        handleTriangle( this, face.a, face.b, face.c, 0, 1, 2 );
      } else if ( face is Face4 ) {
        Face4 face4 = face;
        handleTriangle( this, face4.a, face4.b, face4.c, 0, 1, 2 );
        handleTriangle( this, face4.a, face4.b, face4.d, 0, 1, 3 );
      }
    }

    var faceIndex = [ 'a', 'b', 'c', 'd' ];

    fl = _faces.length;
    for ( f = 0; f < fl; f ++ ) 
    {
      face = _faces[ f ];

      for ( i = 0; i < face.vertexNormals.length; i++ ) 
      {
        n.copy( face.vertexNormals[ i ] );

        //TODO: Figure out how to cast variables
        //vertexIndex = face[faceIndex[ i ]];
        if ( faceIndex[i] == "a") {
          vertexIndex = face.a;
        } else if ( faceIndex[i] == "b") {
          vertexIndex = face.b;
        } else if ( faceIndex[i] == "c") {
          vertexIndex = face.c;
        } else if ( faceIndex[i] == "d") {
          //had to get the type right here anyway...
          Face4 face4 = face;
          vertexIndex = face4.d;
        }
        
        t = tan1[ vertexIndex ];

        // Gram-Schmidt orthogonalize

        tmp.copy( t );
        tmp.subSelf( n.multiplyScalar( n.dot( t ) ) ).normalize();

        // Calculate handedness

        tmp2.cross( face.vertexNormals[ i ], t );
        test = tmp2.dot( tan2[ vertexIndex ] );
        w = (test < 0.0) ? -1.0 : 1.0;

        face.vertexTangents[ i ] = new Vector4( tmp.x, tmp.y, tmp.z, w );

      }

    }

    _hasTangents = true;

  }
  
  handleTriangle( context, a, b, c, ua, ub, uc )
  {
    Vector3 sdir = new Vector3(), tdir = new Vector3();
    
    List uv;
    
    num x1, x2, y1, y2, z1, z2, s1, s2, t1, t2, r;
    
    Vector3 vA, vB, vC; 
    
    UV uvA, uvB, uvC;
    
    vA = context.vertices[ a ].position;
    vB = context.vertices[ b ].position;
    vC = context.vertices[ c ].position;

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

    tan1[ a ].addSelf( sdir );
    tan1[ b ].addSelf( sdir );
    tan1[ c ].addSelf( sdir );

    tan2[ a ].addSelf( tdir );
    tan2[ b ].addSelf( tdir );
    tan2[ c ].addSelf( tdir );

  }

  void computeBoundingBox()
  {
    if ( _vertices.length > 0 )
    {
      Vector3 position, firstPosition = _vertices[ 0 ].position;

      if ( _boundingBox === null ) {
        _boundingBox = { "min": firstPosition.clone(), "max": firstPosition.clone() };
      } else {
        _boundingBox["min"].copy( firstPosition );
        _boundingBox["max"].copy( firstPosition );
      }

      Vector3 min = _boundingBox["min"],
        max = _boundingBox["max"];

      num vl = _vertices.length;
      for ( int v = 1; v < vl; v ++ ) 
      {
        position = _vertices[ v ].position;

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

  void computeBoundingSphere()
  {
    num radius, maxRadius = 0;
    int vl = _vertices.length;
    for ( int v = 0; v < vl; v ++ ) {
      radius = _vertices[ v ].position.length();
      if ( radius > maxRadius ) maxRadius = radius;
    }

    _boundingSphere = { "radius": maxRadius };
  }

  /*
   * Checks for duplicate vertices with hashmap.
   * Duplicated vertices are removed
   * and faces' vertices are updated.
   */
  
  void mergeVertices()
  {
    Map verticesMap = {}; // Hashmap for looking up vertice by position coordinates (and making sure they are unique)
    List<Vertex> unique = [];
    List<int> changes = [];

    String key;
    int precisionPoints = 4; // number of decimal points, eg. 4 for epsilon of 0.0001
    num precision = Math.pow( 10, precisionPoints );
    int i;
    
    int il = _vertices.length;
    for ( i = 0; i < il; i ++ ) 
    {
      Vector3 v = _vertices[ i ].position;
      
      //key = [ ThreeMath.round( v.x * precision ), ThreeMath.round( v.y * precision ), ThreeMath.round( v.z * precision ) ].join( '_' );
      
      int vx = ( v.x * precision ).round().toInt();
      int vy = ( v.y * precision ).round().toInt();
      int vz = ( v.z * precision ).round().toInt();
     
      key = "${vx}_${vy}_${vz}";
      
      if ( verticesMap[ key ] === null ) 
      {
        verticesMap[ key ] = i;
        unique.add( _vertices[ i ] );
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

    il = _faces.length;
    // Start to patch face indices
    for( i = 0; i < il; i ++ ) 
    {
      IFace3 face = _faces[ i ];

      if ( face is Face3 ) {
        face.a = changes[ face.a ];
        face.b = changes[ face.b ];
        face.c = changes[ face.c ];
      }
      else if ( face is Face4 )
      {
        Face4 face4 = face;
        face4.a = changes[ face4.a ];
        face4.b = changes[ face4.b ];
        face4.c = changes[ face4.c ];
        face4.d = changes[ face4.d ];
      }
    }
    
    // Use unique set of vertices
    _vertices = unique;
  }
}
