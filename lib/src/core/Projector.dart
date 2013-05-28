part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author julianwa / https://github.com/julianwa
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 * @author nelson silva / http://www.inevo.pt
 *
 * updated to 81ef5c3b32 - Made Projector.projectObject more open for custom rendererers.
 */

class Projector {
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

  Vector4 _clippedVertex1PositionScreen;
  Vector4 _clippedVertex2PositionScreen;

  ProjectorRenderData _renderData;

  Matrix4 _viewProjectionMatrix, _modelViewProjectionMatrix;

  Frustum _frustum;

  Projector()
      : _objectPool = [],
        _vertexPool = [],
        _face3Pool = [],
        _face4Pool = [],
        _linePool = [],
        _particlePool = [],

        //_renderData = { "objects": [], "sprites": [], "lights": [], "elements": [] };
        _renderData = new ProjectorRenderData(),

        _vector3 = new Vector3.zero(),
        _vector4 = new Vector4(0.0, 0.0, 0.0, 1.0),

        _viewProjectionMatrix = new Matrix4.identity(),
        _modelViewProjectionMatrix = new Matrix4.identity(),

        _frustum = new Frustum(),

        _clippedVertex1PositionScreen = new Vector4(0.0, 0.0, 0.0, 1.0),
        _clippedVertex2PositionScreen = new Vector4(0.0, 0.0, 0.0, 1.0);

  Vector3 projectVector( Vector3 vector, Camera camera ) {
    camera.matrixWorldInverse.getInverse( camera.matrixWorld );

    _viewProjectionMatrix.multiply( camera.projectionMatrix, camera.matrixWorldInverse );
    _viewProjectionMatrix.multiplyVector3( vector );

    return vector;
  }

  Vector3 unprojectVector( Vector3 vector, Camera camera ) {
    camera.projectionMatrixInverse = camera.projectionMatrix.clone();
    camera.projectionMatrixInverse.invert();

    _viewProjectionMatrix = camera.matrixWorld.clone();
    _viewProjectionMatrix.multiply( camera.projectionMatrixInverse );
    multiplyVector3(_viewProjectionMatrix, vector );

    return vector;
  }

  /**
   * Translates a 2D point from NDC to a THREE.Ray
   * that can be used for picking.
   * @vector - THREE.Vector3 that represents 2D point
   * @camera - THREE.Camera
   */
  Ray pickingRay( Vector3 vector, Camera camera ) {
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

  _projectObject( Object3D parent ) {
    var cl = parent.children.length;
    for ( var c = 0; c < cl; c ++ ) {

      var object = parent.children[ c ];

      if ( !object.visible ) continue;

      if ( object is Light ) {

        _renderData.lights.add( object );

      } else if ( object is Mesh || object is Line ) {

        if ( !object.frustumCulled || _frustum.contains( object ) ) {

          _object = getNextObjectInPool();
          _object.object = object;

          if ( object.renderDepth != null ) {

            _object.z = object.renderDepth;

          } else {

            _vector3 = object.matrixWorld.getTranslation();
            multiplyVector3(_viewProjectionMatrix, _vector3 );
            _object.z = _vector3.z;

          }

          _renderData.objects.add( _object );

        }

      } else if ( object is Sprite || object is Particle ) {

        _object = getNextObjectInPool();
        _object.object = object;

        // TODO: Find an elegant and performant solution and remove this dupe code.

        if ( object.renderDepth != null ) {

          _object.z = object.renderDepth;

        } else {

          _vector3 = object.matrixWorld.getTranslation();
          multiplyVector3(_viewProjectionMatrix, _vector3 );
          _object.z = _vector3.z;

        }

        _renderData.sprites.add( _object );

      } else {

        _object = getNextObjectInPool();
        _object.object = object;

        if ( object.renderDepth != null ) {

          _object.z = object.renderDepth;

        } else {

          _vector3 = object.matrixWorld.getTranslation();
          multiplyVector3(_viewProjectionMatrix, _vector3 );
          _object.z = _vector3.z;

        }

        _renderData.objects.add( _object );

      }

      _projectObject( object );
    }
  }

  ProjectorRenderData projectGraph( Object3D root, bool sort ) {
    _objectCount = 0;

    _renderData.objects = [];
    _renderData.sprites = [];
    _renderData.lights = [];

    _projectObject( root );

    //TODO: assuming this is a form of 'if' statement.
    //sort && _renderData.objects.sort( painterSort );

    if (sort) {
      _renderData.objects.sort( painterSort );
    }

    return _renderData;
  }


  ProjectorRenderData projectScene( Scene scene, Camera camera, bool sort ) {
    num near = camera.near, far = camera.far;
    bool visible = false;
    int o, ol, v, vl, f, fl, n, nl, c, cl, u, ul;
    Object3D object;
    Matrix4 modelMatrix, rotationMatrix;
    Geometry geometry;
    List geometryMaterials;
    List<Vector3> vertices;
    Vertex vertex;
    Vector3 vertexPositionScreen, normal;
    List<IFace3> faces;
    IFace3 face;
    IRenderableFace3 _face;
    List faceVertexNormals;
    List<List> faceVertexUvs;
    RenderableVertex v1, v2, v3, v4;
    bool isFaceMaterial;
    Material material;
    int side;

    _face3Count = 0;
    _face4Count = 0;
    _lineCount = 0;
    _particleCount = 0;

    _renderData.elements = [];

    scene.updateMatrixWorld();

    if ( camera.parent == null ) {
      // console.warn( 'DEPRECATED: Camera hasn\'t been added to a Scene. Adding it...' );
      // scene.add( camera );
      camera.updateMatrixWorld();
    }

    camera.matrixWorldInverse.setFrom(camera.matrixWorld);
    camera.matrixWorldInverse.invert();

    _viewProjectionMatrix = camera.projectionMatrix * camera.matrixWorldInverse;

    _frustum.setFromMatrix( _viewProjectionMatrix );

    _renderData = projectGraph( scene, false );

    _renderData.objects.forEach((o) {

      object = o.object;

      modelMatrix = object.matrixWorld;

      _vertexCount = 0;

      if ( object is Mesh ) {

        geometry = object.geometry;
        geometryMaterials = object.geometry.materials;
        vertices = geometry.vertices;
        faces = geometry.faces;
        faceVertexUvs = geometry.faceVertexUvs;

        extractRotation( object.matrixRotationWorld, modelMatrix );
        rotationMatrix = object.matrixRotationWorld;

        isFaceMaterial = (object.material is MeshFaceMaterial);
        side = object.material.side;

        vertices.forEach((Vector3 v) {
          _vertex = getNextVertexInPool();
          _vertex.positionWorld.setFrom(v);

          multiplyVector3(modelMatrix, _vertex.positionWorld );
          _vertex.positionScreen = new Vector4(_vertex.positionWorld[0],
              _vertex.positionWorld[1],
              _vertex.positionWorld[2], 1.0); //  _vertex.positionWorld.clone();
          _viewProjectionMatrix.transform( _vertex.positionScreen );
          _vertex.positionScreen.x /= _vertex.positionScreen.w;
          _vertex.positionScreen.y /= _vertex.positionScreen.w;

          _vertex.visible = _vertex.positionScreen.z > near && _vertex.positionScreen.z < far;
        });

        fl = faces.length;
        for ( f = 0; f < fl; f ++ ) {

          face = faces[ f ];

          material = isFaceMaterial == true ? geometryMaterials[ face.materialIndex ] : object.material;

          if ( material == null ) continue;

          side = material.side;

          if ( face is Face3 ) {
            v1 = _vertexPool[ face.a ];
            v2 = _vertexPool[ face.b ];
            v3 = _vertexPool[ face.c ];

            if ( v1.visible && v2.visible && v3.visible ) {

              visible = (
                  ( ( v3.positionScreen.x - v1.positionScreen.x ) * ( v2.positionScreen.y - v1.positionScreen.y ) -
                    ( v3.positionScreen.y - v1.positionScreen.y ) * ( v2.positionScreen.x - v1.positionScreen.x ) ) < 0);

              if ( side == DoubleSide || visible == ( side == FrontSide ) ) {


              _face = getNextFace3InPool();

              _face.v1.copy( v1 );
              _face.v2.copy( v2 );
              _face.v3.copy( v3 );

              } else {
                continue;
              }
            } else {
              continue;
            }

          } else if ( face is Face4 ) {

            Face4 face4 = face;
            v1 = _vertexPool[ face4.a ];
            v2 = _vertexPool[ face4.b ];
            v3 = _vertexPool[ face4.c ];
            v4 = _vertexPool[ face4.d ];

            if ( v1.visible && v2.visible && v3.visible && v4.visible ) {

              visible = ( v4.positionScreen.x - v1.positionScreen.x ) * ( v2.positionScreen.y - v1.positionScreen.y ) -
                  ( v4.positionScreen.y - v1.positionScreen.y ) * ( v2.positionScreen.x - v1.positionScreen.x ) < 0 ||
                  ( v2.positionScreen.x - v3.positionScreen.x ) * ( v4.positionScreen.y - v3.positionScreen.y ) -
                  ( v2.positionScreen.y - v3.positionScreen.y ) * ( v4.positionScreen.x - v3.positionScreen.x ) < 0;

              if ( side == DoubleSide || visible == ( side == FrontSide ) ) {

                _face = getNextFace4InPool();

                _face.v1.copy( v1 );
                _face.v2.copy( v2 );
                _face.v3.copy( v3 );
                (_face as IRenderableFace4).v4.copy( v4 );
              } else {
                continue;
              }
            } else {
              continue;
            }
          }

          _face.normalWorld.setFrom( face.normal );

		      if ( visible == false && ( side == BackSide || side == DoubleSide ) ) _face.normalWorld.negate();
          multiplyVector3(rotationMatrix, _face.normalWorld );

          _face.centroidWorld.setFrom( face.centroid );
          multiplyVector3(modelMatrix, _face.centroidWorld );

          _face.centroidScreen.setFrom( _face.centroidWorld );
          multiplyVector3(_viewProjectionMatrix, _face.centroidScreen );

          faceVertexNormals = face.vertexNormals;

          nl = faceVertexNormals.length;
          for ( n = 0; n < nl; n ++ ) {
            normal = _face.vertexNormalsWorld[ n ];
            normal.setFrom( faceVertexNormals[ n ] );

            if ( !visible && ( side == BackSide || side == DoubleSide ) ) normal.negate();

            multiplyVector3( rotationMatrix, normal );
          }

          cl = faceVertexUvs.length;
          for ( c = 0; c < cl; c ++ ) {
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

          _face.material = material;
          _face.faceMaterial = face.materialIndex != null ? geometryMaterials[ face.materialIndex ] : null;

          _face.z = _face.centroidScreen.z;

          _renderData.elements.add( _face );
        }

      } else if ( object is Line ) {
        _modelViewProjectionMatrix = _viewProjectionMatrix * modelMatrix;

        vertices = object.geometry.vertices;

        v1 = getNextVertexInPool();
        Vector3 vec = vertices[ 0 ];
        v1.positionScreen = new Vector4(vec.x, vec.y, vec.z, 1.0);
        _modelViewProjectionMatrix.transform( v1.positionScreen );

      // Handle LineStrip and LinePieces
        var step = object.type == LinePieces ? 2 : 1;

        vl = vertices.length;
        for ( v = 1; v < vl; v++ ) {

          v1 = getNextVertexInPool();
          Vector3 vec = vertices[ v ];
          v1.positionScreen = new Vector4(vec.x, vec.y, vec.z, 1.0);
          _modelViewProjectionMatrix.transform( v1.positionScreen );

          if ( ( v + 1 ) % step > 0 ) continue;

          v2 = _vertexPool[ _vertexCount - 2 ];

          _clippedVertex1PositionScreen.setFrom(v1.positionScreen);
          _clippedVertex2PositionScreen.setFrom(v2.positionScreen);

          if ( clipLine( _clippedVertex1PositionScreen, _clippedVertex2PositionScreen ) ) {
            // Perform the perspective divide
            _clippedVertex1PositionScreen /= _clippedVertex1PositionScreen.w;
            _clippedVertex2PositionScreen /= _clippedVertex2PositionScreen.w;

            _line = getNextLineInPool();
            _line.v1.positionScreen.setFrom(_clippedVertex1PositionScreen);
            _line.v2.positionScreen.setFrom(_clippedVertex2PositionScreen);

            _line.z = Math.max( _clippedVertex1PositionScreen.z, _clippedVertex2PositionScreen.z );

            _line.material = object.material;

            _renderData.elements.add( _line );
          }
        }
      }
    });

   _renderData.sprites.forEach((o) {

      object = o.object;

      modelMatrix = object.matrixWorld;

      if ( object is Particle ) {
        _vector4.setValues ( modelMatrix[12], modelMatrix[13], modelMatrix[14], 1.0 );
        _viewProjectionMatrix.transform( _vector4 );

        _vector4.z /= _vector4.w;

        if ( _vector4.z > 0 && _vector4.z < 1 ) {
          _particle = getNextParticleInPool();
          _particle.x = _vector4.x / _vector4.w;
          _particle.y = _vector4.y / _vector4.w;
          _particle.z = _vector4.z;

          _particle.rotation = object.rotation.z;

          _particle.scale.x = object.scale.x * ( _particle.x - ( _vector4.x + camera.projectionMatrix[0] ) / ( _vector4.w + camera.projectionMatrix[12] ) ).abs();
          _particle.scale.y = object.scale.y * ( _particle.y - ( _vector4.y + camera.projectionMatrix[5] ) / ( _vector4.w + camera.projectionMatrix[13] ) ).abs();

          _particle.material = object.material as Material;

          _renderData.elements.add( _particle );
        }
      }
    });

    if ( sort ) {
      _renderData.elements.sort( painterSort );
    }

    return _renderData;
  }

  // Pools
  RenderableObject getNextObjectInPool() {
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

  RenderableVertex getNextVertexInPool() {
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

  IRenderableFace3 getNextFace3InPool() {
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

  IRenderableFace4 getNextFace4InPool() {

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

  RenderableLine getNextLineInPool() {
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

  RenderableParticle getNextParticleInPool() {
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

  int painterSort( a, b ) => b.z.compareTo(a.z);

  bool clipLine( Vector4 s1, Vector4 s2 ) {
    double alpha1 = 0.0, alpha2 = 1.0,

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
        s1 = lerp4(s1, s2, alpha1 );
        s2 = lerp4(s2, s1, 1.0 - alpha2 );

        return true;
      }
    }
  }
}

// _renderData = { "objects": [], "sprites": [], "lights": [], "elements": [] };
class ProjectorRenderData {
  List objects, sprites, lights, elements;

  ProjectorRenderData()
      : objects = [],
        sprites = [],
        lights = [],
        elements = [];
}






