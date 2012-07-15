/**
 * @author mr.doob / http://mrdoob.com/
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author julianwa / https://github.com/julianwa
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/ 
 */

class Projector 
{
  List<RenderableObject>_objectPool;
  List<RenderableVertex> _vertexPool;
  List<RenderableFace4> _face4Pool;
  List<RenderableFace3> _face3Pool;
  List<RenderableLine> _linePool;
  List<RenderableParticle> _particlePool;
  
  int _objectCount, _vertexCount, _face3Count, _face4Count, _lineCount, _particleCount;
  
  RenderableObject _object;
  RenderableVertex _vertex; 
  RenderableLine _line;
  RenderableParticle _particle;
  
  Vector3 _vector3; 
  Vector4 _vector4;
  
  Vector4 _clippedVertex1PositionScreen, _clippedVertex2PositionScreen;
  
  ProjectorRenderData _renderData;
  
  Matrix4 _projScreenMatrix, _projScreenobjectMatrixWorld;
  
  Frustum _frustum;
  
  Projector()
  {
    _objectPool = [];
    _vertexPool = [];
    _face3Pool = [];
    _face4Pool = [];
    _linePool = [];
    _particlePool = [];

    //_renderData = { "objects": [], "sprites": [], "lights": [], "elements": [] };
    _renderData = new ProjectorRenderData();

    _vector3 = new Vector3();
    _vector4 = new Vector4();

    _projScreenMatrix = new Matrix4();
    _projScreenobjectMatrixWorld = new Matrix4();

    _frustum = new Frustum();

    _clippedVertex1PositionScreen = new Vector4();
    _clippedVertex2PositionScreen = new Vector4();

    //TODO: this seems to be redundant?
    var _face3VertexNormals;
  }
  
  Vector3 projectVector( Vector3 vector, Camera camera )
  {
    camera.matrixWorldInverse.getInverse( camera.matrixWorld );

    _projScreenMatrix.multiply( camera.projectionMatrix, camera.matrixWorldInverse );
    _projScreenMatrix.multiplyVector3( vector );

    return vector;
  }

  Vector3 unprojectVector( Vector3 vector, Camera camera )
  {
    camera.projectionMatrixInverse.getInverse( camera.projectionMatrix );

    _projScreenMatrix.multiply( camera.matrixWorld, camera.projectionMatrixInverse );
    _projScreenMatrix.multiplyVector3( vector );

    return vector;
  }

  /**
   * Translates a 2D point from NDC to a THREE.Ray
   * that can be used for picking.
   * @vector - THREE.Vector3 that represents 2D point
   * @camera - THREE.Camera
   */
  Ray pickingRay( Vector3 vector, Camera camera ) 
  {
    Vector3 end, ray, t;

    // set two vectors with opposing z values
    vector.z = -1.0;
    end = new Vector3( vector.x, vector.y, 1.0 );

    unprojectVector( vector, camera );
    unprojectVector( end, camera );

    // find direction from vector to end
    end.subSelf( vector ).normalize();

    return new Ray( vector, end );
  }

  ProjectorRenderData projectGraph( Object3D root, bool sort )
  {
    _objectCount = 0;
    
    //TODO: does this clear the Lists in Dart?
//    _renderData.objects.length = 0;
//    _renderData.sprites.length = 0;
//    _renderData.lights.length = 0;
      _renderData.objects = [];
      _renderData.sprites = [];
      _renderData.lights = [];

    projectObject( root );

    //TODO: assuming this is a form of 'if' statement.
    //sort && _renderData.objects.sort( painterSort );

    if (sort) {
      _renderData.objects.sort( painterSort );
    }
    
    return _renderData;
  }
  
  ProjectorRenderData projectObject( Object3D object ) 
  {
    if ( object.visible === false ) return null;
    
    if ( ( object is Mesh || object is Line ) &&
    ( object.frustumCulled === false || _frustum.contains( object ) ) ) 
    {
      _projScreenMatrix.multiplyVector3( _vector3.copy( object.position ) );

      _object = getNextObjectInPool();
      _object.object = object;
      _object.z = _vector3.z;

      _renderData.objects.add( _object );
    }
    else if ( object is Sprite || object is Particle ) 
    {
      _projScreenMatrix.multiplyVector3( _vector3.copy( object.position ) );

      _object = getNextObjectInPool();
      _object.object = object;
      _object.z = _vector3.z;

      _renderData.sprites.add( _object );
    } 
    else if ( object is Light ) 
    {
      _renderData.lights.add( object );
    }
    
    int cl = object.children.length;
    for ( int c = 0; c < cl; c ++ ) {
      Object3D obj = object.children[ c ];
      projectObject( object.children[ c ] );
    }
  }

  //TODO: check logic of using PerspectiveCamera here, seems odd.
  ProjectorRenderData projectScene( Scene scene, PerspectiveCamera camera, bool sort )
  {
    num near = camera.near, far = camera.far;
    int o, ol, v, vl, f, fl, n, nl, c, cl, u, ul;
    Object3D object;
    Matrix4 objectMatrixWorld, objectMatrixWorldRotation;
    Material objectMaterial;
    Geometry geometry;
    List geometryMaterials;
    List<Vertex> vertices; 
    Vertex vertex; 
    Vector3 vertexPositionScreen, normal;
    List<IFace3> faces;
    IFace3 face;
    IRenderableFace3 _face;
    List faceVertexNormals;
    List<List> faceVertexUvs;
    RenderableVertex v1, v2, v3, v4;

    _face3Count = 0;
    _face4Count = 0;
    _lineCount = 0;
    _particleCount = 0;

    //TODO: does this clear a List in Dart?
    //_renderData.elements.length = 0;
    _renderData.elements = [];

    if ( camera.parent === null ) {
//      console.warn( 'DEPRECATED: Camera hasn\'t been added to a Scene. Adding it...' );
      scene.add( camera );
    }

    scene.updateMatrixWorld();

    camera.matrixWorldInverse.getInverse( camera.matrixWorld );

    _projScreenMatrix.multiply( camera.projectionMatrix, camera.matrixWorldInverse );

    _frustum.setFromMatrix( _projScreenMatrix );

    _renderData = projectGraph( scene, false );

    ol = _renderData.objects.length;
    
    for ( o = 0; o < ol; o++ ) 
    {
      object = _renderData.objects[ o ].object;

      objectMatrixWorld = object.matrixWorld;
      objectMaterial = object.material;

      _vertexCount = 0;

      if ( object is Mesh )
      {
        geometry = object.geometry;
        geometryMaterials = object.geometry.materials;
        vertices = geometry.vertices;
        faces = geometry.faces;
        faceVertexUvs = geometry.faceVertexUvs;

        objectMatrixWorldRotation = object.matrixRotationWorld.extractRotation( objectMatrixWorld );

        vl = vertices.length;
        
        for ( v = 0; v < vl; v ++ ) 
        {
          _vertex = getNextVertexInPool();
          _vertex.positionWorld.copy( vertices[ v ].position );

          objectMatrixWorld.multiplyVector3( _vertex.positionWorld );
          _vertex.positionScreen.copy( _vertex.positionWorld );
          _projScreenMatrix.multiplyVector4( _vertex.positionScreen );
          _vertex.positionScreen.x /= _vertex.positionScreen.w;
          _vertex.positionScreen.y /= _vertex.positionScreen.w;

          _vertex.visible = _vertex.positionScreen.z > near && _vertex.positionScreen.z < far;
        }

        fl = faces.length;
        for ( f = 0; f < fl; f ++ ) 
        {
          face = faces[ f ];

          if ( face is Face3 )
          {
            v1 = _vertexPool[ face.a ];
            v2 = _vertexPool[ face.b ];
            v3 = _vertexPool[ face.c ];

            if ( v1.visible && v2.visible && v3.visible &&
              ( object.doubleSided || ( object.flipSided !=
              ( v3.positionScreen.x - v1.positionScreen.x ) * ( v2.positionScreen.y - v1.positionScreen.y ) -
              ( v3.positionScreen.y - v1.positionScreen.y ) * ( v2.positionScreen.x - v1.positionScreen.x ) < 0 ) ) ) {

              _face = getNextFace3InPool();

              _face.v1.copy( v1 );
              _face.v2.copy( v2 );
              _face.v3.copy( v3 );

            } else {
              continue;
            }
          }
          else if ( face is Face4 )
          {
            Face4 face4 = face;
            v1 = _vertexPool[ face4.a ];
            v2 = _vertexPool[ face4.b ];
            v3 = _vertexPool[ face4.c ];
            v4 = _vertexPool[ face4.d ];
            
            bool bool1  = ( v4.positionScreen.x - v1.positionScreen.x ) * ( v2.positionScreen.y - v1.positionScreen.y ) -
                ( v4.positionScreen.y - v1.positionScreen.y ) * ( v2.positionScreen.x - v1.positionScreen.x ) < 0;
            bool bool2 = ( v2.positionScreen.x - v3.positionScreen.x ) * ( v4.positionScreen.y - v3.positionScreen.y ) -
                ( v2.positionScreen.y - v3.positionScreen.y ) * ( v4.positionScreen.x - v3.positionScreen.x ) < 0;
            bool bool3 = bool1 || bool2; 
            
            if ( v1.visible && v2.visible && v3.visible && v4.visible && ( object.doubleSided || ( object.flipSided != bool3 ) ) )
            {
              _face = getNextFace4InPool();

              _face.v1.copy( v1 );
              _face.v2.copy( v2 );
              _face.v3.copy( v3 );
              IRenderableFace4 rFace4 = _face;
              //_face.v4.copy( v4 );
              rFace4.v4.copy( v4 );
            } else {
              continue;
            }
          }
          
          _face.normalWorld.copy( face.normal );
          objectMatrixWorldRotation.multiplyVector3( _face.normalWorld );

          _face.centroidWorld.copy( face.centroid );
          objectMatrixWorld.multiplyVector3( _face.centroidWorld );

          _face.centroidScreen.copy( _face.centroidWorld );
          _projScreenMatrix.multiplyVector3( _face.centroidScreen );

          faceVertexNormals = face.vertexNormals;

          nl = faceVertexNormals.length;
          for ( n = 0; n < nl; n ++ ) 
          {
            normal = _face.vertexNormalsWorld[ n ];
            normal.copy( faceVertexNormals[ n ] );
            objectMatrixWorldRotation.multiplyVector3( normal );
          }

          cl = faceVertexUvs.length;
          for ( c = 0; c < cl; c ++ )
          {
            List<UV> uvs = faceVertexUvs[ c ][ f ];

            if ( uvs == null ) continue;
            
            //TODO: interpreting this code as dynamically creating arrays.
            ul = uvs.length;
            for ( u = 0; u < ul; u ++ ) {
              List faceUVs = _face.uvs[c];
              faceUVs.add(uvs[u]);
              //_face.uvs[ c ][ u ] = uvs[ u ];
            }
          }

          _face.material = objectMaterial;
          _face.faceMaterial = face.materialIndex !== null ? geometryMaterials[ face.materialIndex ] : null;

          _face.z = _face.centroidScreen.z;

          _renderData.elements.add( _face );
        }
        
      } 
      else if ( object is Line ) 
      {
        _projScreenobjectMatrixWorld.multiply( _projScreenMatrix, objectMatrixWorld );

        vertices = object.geometry.vertices;

        v1 = getNextVertexInPool();
        v1.positionScreen.copy( vertices[ 0 ].position );
        _projScreenobjectMatrixWorld.multiplyVector4( v1.positionScreen );

        vl = vertices.length;
        for ( v = 1; v < vl; v++ ) 
        {
          v1 = getNextVertexInPool();
          v1.positionScreen.copy( vertices[ v ].position );
          _projScreenobjectMatrixWorld.multiplyVector4( v1.positionScreen );

          v2 = _vertexPool[ _vertexCount - 2 ];

          _clippedVertex1PositionScreen.copy( v1.positionScreen );
          _clippedVertex2PositionScreen.copy( v2.positionScreen );

          if ( clipLine( _clippedVertex1PositionScreen, _clippedVertex2PositionScreen ) ) 
          {
            // Perform the perspective divide
            _clippedVertex1PositionScreen.multiplyScalar( 1 / _clippedVertex1PositionScreen.w );
            _clippedVertex2PositionScreen.multiplyScalar( 1 / _clippedVertex2PositionScreen.w );

            _line = getNextLineInPool();
            _line.v1.positionScreen.copy( _clippedVertex1PositionScreen );
            _line.v2.positionScreen.copy( _clippedVertex2PositionScreen );

            _line.z = Math.max( _clippedVertex1PositionScreen.z, _clippedVertex2PositionScreen.z );

            _line.material = objectMaterial;

            _renderData.elements.add( _line );
          }
        }
      }
    }
    
    ol = _renderData.sprites.length;
    for ( o = 0; o < ol; o++ ) 
    {
      object = _renderData.sprites[ o ].object;

      objectMatrixWorld = object.matrixWorld;

      if ( object is Particle )
      {
        _vector4.setValues( objectMatrixWorld.n14, objectMatrixWorld.n24, objectMatrixWorld.n34, 1 );
        _projScreenMatrix.multiplyVector4( _vector4 );

        _vector4.z /= _vector4.w;

        if ( _vector4.z > 0 && _vector4.z < 1 ) 
        {         
          _particle = getNextParticleInPool();
          _particle.x = _vector4.x / _vector4.w;
          _particle.y = _vector4.y / _vector4.w;
          _particle.z = _vector4.z;

          _particle.rotation = object.rotation.z;
          
          _particle.scale.x = object.scale.x * ( _particle.x - ( _vector4.x + camera.projectionMatrix.n11 ) / ( _vector4.w + camera.projectionMatrix.n14 ) ).abs();
          _particle.scale.y = object.scale.y * ( _particle.y - ( _vector4.y + camera.projectionMatrix.n22 ) / ( _vector4.w + camera.projectionMatrix.n24 ) ).abs();

          _particle.material = object.material;

          _renderData.elements.add( _particle );
        }
      }
    }
    //TODO: assuming this equates to an 'if' statement
    //sort && _renderData.elements.sort( painterSort );
    if ( sort ) {
      _renderData.elements.sort( painterSort );
    }
    
    return _renderData;
  }

  // Pools
  RenderableObject getNextObjectInPool() 
  {
    //TODO: make sure I've interpreted this logic correctly
    // RenderableObject object = _objectPool[ _objectCount ] = _objectPool[ _objectCount ] || new RenderableObject();
    
    RenderableObject object;
    if ( _objectCount < _objectPool.length ) {
      object = ( _objectPool[ _objectCount ] != null ) ? _objectPool[ _objectCount ] : new RenderableObject();
    } else {
      object = new RenderableObject(); 
      _objectPool.add(object);
    }
    
    _objectCount ++;

    return object;
  }

  RenderableVertex getNextVertexInPool() 
  {
    //TODO: make sure I've interpreted this logic correctly
    // var vertex = _vertexPool[ _vertexCount ] = _vertexPool[ _vertexCount ] || new THREE.RenderableVertex();
    RenderableVertex vertex;
    
    // Vertex is already within List    
    if ( _vertexCount < _vertexPool.length ) {
      vertex = ( _vertexPool[ _vertexCount ] != null ) ? _vertexPool[ _vertexCount ] : new RenderableVertex(); 
    } else {
      vertex = new RenderableVertex();
      _vertexPool.add(vertex);
    }
    
    _vertexCount ++;

    return vertex;
  }

  IRenderableFace3 getNextFace3InPool()
  {
    //TODO: make sure I've interpreted this logic correctly
    // RenderableFace3 face = _face3Pool[ _face3Count ] = _face3Pool[ _face3Count ] || new RenderableFace3();
    RenderableFace3 face;
    if ( _face3Count < _face3Pool.length ) {
      face = ( _face3Pool[ _face3Count ] != null ) ? _face3Pool[ _face3Count ] : new RenderableFace3();
    } else {
      face = new RenderableFace3();
      _face3Pool.add(face);
    }
    
    _face3Count ++;

    return face;
  }

  IRenderableFace4 getNextFace4InPool() 
  {
    //TODO: make sure I've interpreted this logic correctly
    //RenderableFace4 face = _face4Pool[ _face4Count ] = _face4Pool[ _face4Count ] || new RenderableFace4();
    RenderableFace4 face;
    if ( _face4Count < _face4Pool.length ) {
      face = ( _face4Pool[ _face4Count ] != null ) ? _face4Pool[ _face4Count ] : new RenderableFace4();
    } else {
      face = new RenderableFace4();
      _face4Pool.add(face);
    }
    
    _face4Count ++;

    return face;
  }

  RenderableLine getNextLineInPool()
  {
    //TODO: make sure I've interpreted this logic correctly
    //RenderableLine line = _linePool[ _lineCount ] = _linePool[ _lineCount ] || new RenderableLine();
    RenderableLine line;
    if ( _lineCount < _linePool.length ) {
      line = ( _linePool[ _lineCount ] != null ) ? _linePool[ _lineCount ] : new RenderableLine();
    } else {
      line = new RenderableLine();
      _linePool.add(line);
    }
   
    _lineCount ++;

    return line;
  }

  RenderableParticle getNextParticleInPool()
  {
    //TODO: make sure I've interpreted this logic correctly
    //RenderableParticle particle = _particlePool[ _particleCount ] = _particlePool[ _particleCount ] || new RenderableParticle();
    RenderableParticle particle;
    if ( _particleCount < _particlePool.length ) {
      particle = ( _particlePool[ _particleCount ] != null ) ? _particlePool[ _particleCount ] : new RenderableParticle();
    } else {
      particle = new RenderableParticle();
      _particlePool.add(particle);
    }
    
    _particleCount ++;
    return particle;
  }

  //
  num painterSort( a, b ) {
    return b.z - a.z;
  }

  bool clipLine( Vector4 s1, Vector4 s2 ) 
  {
    num alpha1 = 0, alpha2 = 1,

    // Calculate the boundary coordinate of each vertex for the near and far clip planes,
    // Z = -1 and Z = +1, respectively.
    bc1near =  s1.z + s1.w,
    bc2near =  s2.z + s2.w,
    bc1far =  - s1.z + s1.w,
    bc2far =  - s2.z + s2.w;

    if ( bc1near >= 0 && bc2near >= 0 && bc1far >= 0 && bc2far >= 0 ) {
      // Both vertices lie entirely within all clip planes.
      return true;
    } else if ( ( bc1near < 0 && bc2near < 0) || (bc1far < 0 && bc2far < 0 ) ) {
      // Both vertices lie entirely outside one of the clip planes.
      return false;
    } else {
      // The line segment spans at least one clip plane.
      if ( bc1near < 0 ) {
        // v1 lies outside the near plane, v2 inside
        alpha1 = Math.max( alpha1, bc1near / ( bc1near - bc2near ) );
      } else if ( bc2near < 0 ) {
        // v2 lies outside the near plane, v1 inside
        alpha2 = Math.min( alpha2, bc1near / ( bc1near - bc2near ) );
      }

      if ( bc1far < 0 ) {
        // v1 lies outside the far plane, v2 inside
        alpha1 = Math.max( alpha1, bc1far / ( bc1far - bc2far ) );
      } else if ( bc2far < 0 ) {
        // v2 lies outside the far plane, v2 inside
        alpha2 = Math.min( alpha2, bc1far / ( bc1far - bc2far ) );
      }

      if ( alpha2 < alpha1 ) {
        // The line segment spans two boundaries, but is outside both of them.
        // (This can't happen when we're only clipping against just near/far but good
        //  to leave the check here for future usage if other clip planes are added.)
        return false;
      } else {
        // Update the s1 and s2 vertices to match the clipped line segment.
        s1.lerpSelf( s2, alpha1 );
        s2.lerpSelf( s1, 1 - alpha2 );

        return true;
      }
    }
  }
}

// _renderData = { "objects": [], "sprites": [], "lights": [], "elements": [] };
class ProjectorRenderData
{
  List objects, sprites, lights, elements;
  
  ProjectorRenderData()
  {
    objects = [];
    sprites = [];
    lights = [];
    elements = [];
  }
}






