part of three;

/**
 * @author alteredq / http://alteredqualia.com/
 */

class ShadowMapPlugin {

  static Projector __projector = new Projector();

  Frustum _frustum;
  Matrix4 _projScreenMatrix;
  Vector3 _min, _max;

  gl.RenderingContext _gl;
  WebGLRenderer _renderer;
  WebGLMaterial _depthMaterial, _depthMaterialMorph, _depthMaterialSkin, _depthMaterialMorphSkin;

  ShadowMapPlugin() :
    _frustum = new Frustum(),
    _projScreenMatrix = new Matrix4(),
    _min = new Vector3(),
    _max = new Vector3();


  init( WebGLRenderer renderer ) {

    _gl = renderer.context;
    _renderer = renderer;

    var depthShader = ShaderLib[ "depthRGBA" ];
    var depthUniforms = UniformsUtils.clone( depthShader["uniforms"] );

    _depthMaterial = new WebGLMaterial.from(new ShaderMaterial( fragmentShader: depthShader["fragmentShader"], vertexShader: depthShader["vertexShader"], uniforms: depthUniforms ));
    _depthMaterialMorph =  new WebGLMaterial.from(new ShaderMaterial( fragmentShader: depthShader["fragmentShader"], vertexShader: depthShader["vertexShader"], uniforms: depthUniforms, morphTargets: true ));
    _depthMaterialSkin =  new WebGLMaterial.from(new ShaderMaterial( fragmentShader: depthShader["fragmentShader"], vertexShader: depthShader["vertexShader"], uniforms: depthUniforms, skinning: true ));
    _depthMaterialMorphSkin =  new WebGLMaterial.from(new ShaderMaterial( fragmentShader: depthShader["fragmentShader"], vertexShader: depthShader["vertexShader"], uniforms: depthUniforms, morphTargets: true, skinning: true ));

    _depthMaterial.shadowPass = true;
    _depthMaterialMorph.shadowPass = true;
    _depthMaterialSkin.shadowPass = true;
    _depthMaterialMorphSkin.shadowPass = true;

  }

  render( Scene scene, Camera camera, [num width, num height] ) {

    if ( ! ( _renderer.shadowMapEnabled && _renderer.shadowMapAutoUpdate ) ) return;

    update( scene, camera );

  }

  update( Scene scene, Camera camera ) {

    var i, il, j, jl, n,

    shadowMap, shadowMatrix, shadowCamera,
    program, buffer, material,
    webglObject, object, light, virtualLight,
    renderList,

    lights = [],

    fog = null;

    // set GL state for depth map

    _gl.clearColor( 1, 1, 1, 1 );
    _gl.disable( gl.BLEND );

    _gl.enable( gl.CULL_FACE );
    _gl.frontFace( gl.CCW );

    if ( _renderer.shadowMapCullFrontFaces ) {

      _gl.cullFace( gl.FRONT );

    } else {

      _gl.cullFace( gl.BACK );

    }

    _renderer.setDepthTest( true );

    // preprocess lights
    //  - skip lights that are not casting shadows
    //  - create virtual lights for cascaded shadow maps
    il = scene.lights.length;
    for ( i = 0; i < il; i ++ ) {

      light = scene.lights[ i ];

      if ( ! light.castShadow ) continue;

      if ( ( light is DirectionalLight ) && light.shadowCascade ) {

        for ( n = 0; n < light.shadowCascadeCount; n ++ ) {

          if ( ! light.shadowCascadeArray[ n ] ) {

            virtualLight = createVirtualLight( light, n );
            virtualLight.originalCamera = camera;

            var gyro = new Gyroscope();
            gyro.position = light.shadowCascadeOffset;

            gyro.add( virtualLight );
            gyro.add( virtualLight.target );

            camera.add( gyro );

            light.shadowCascadeArray[ n ] = virtualLight;

            print( "Created virtualLight $virtualLight" );

          } else {

            virtualLight = light.shadowCascadeArray[ n ];

          }

          updateVirtualLight( light, n );

          lights.add(virtualLight);

        }

      } else {

        lights.add(light);

      }

    }

    // render depth map
    il = lights.length;
    for ( i = 0; i < il; i ++ ) {

      light = lights[ i ];

      if ( light.shadowMap == null ) {

        light.shadowMap = new WebGLRenderTarget( light.shadowMapWidth, light.shadowMapHeight, minFilter: LinearFilter, magFilter: LinearFilter, format: RGBAFormat );
        light.shadowMapSize = new Vector2( light.shadowMapWidth, light.shadowMapHeight );

        light.shadowMatrix = new Matrix4();

      }

      if ( light.shadowCamera == null ) {

        if ( light is SpotLight ) {

          light.shadowCamera = new PerspectiveCamera( light.shadowCameraFov, light.shadowMapWidth / light.shadowMapHeight, light.shadowCameraNear, light.shadowCameraFar );

        } else if ( light is DirectionalLight ) {

          light.shadowCamera = new OrthographicCamera( light.shadowCameraLeft, light.shadowCameraRight, light.shadowCameraTop, light.shadowCameraBottom, light.shadowCameraNear, light.shadowCameraFar );

        } else {

          print( "Unsupported light type for shadow" );
          continue;

        }

        scene.add( light.shadowCamera );

        if ( _renderer.autoUpdateScene ) scene.updateMatrixWorld();

      }

      if ( light.shadowCameraVisible && light.cameraHelper == null ) {

        light.cameraHelper = new CameraHelper( light.shadowCamera );
        light.shadowCamera.add( light.cameraHelper );

      }

      if ( light is VirtualLight && virtualLight.originalCamera == camera ) {

        updateShadowCamera( camera, light );

      }

      shadowMap = light.shadowMap;
      shadowMatrix = light.shadowMatrix;
      shadowCamera = light.shadowCamera;

      shadowCamera.position.copy( light.matrixWorld.getPosition() );
      shadowCamera.lookAt( light.target.matrixWorld.getPosition() );
      shadowCamera.updateMatrixWorld();

      shadowCamera.matrixWorldInverse.getInverse( shadowCamera.matrixWorld );

      if ( light.cameraHelper != null ) light.cameraHelper.visible = light.shadowCameraVisible;
      if ( light.shadowCameraVisible ) light.cameraHelper.update();

      // compute shadow matrix

      shadowMatrix.setValues( 0.5, 0.0, 0.0, 0.5,
                0.0, 0.5, 0.0, 0.5,
                0.0, 0.0, 0.5, 0.5,
                0.0, 0.0, 0.0, 1.0 );

      shadowMatrix.multiplySelf( shadowCamera.projectionMatrix );
      shadowMatrix.multiplySelf( shadowCamera.matrixWorldInverse );

      // update camera matrices and frustum

      var webglCamera = new WebGLCamera(shadowCamera);
      if ( webglCamera._viewMatrixArray == null) webglCamera._viewMatrixArray = new Float32Array( 16 );
      if ( webglCamera._projectionMatrixArray == null ) webglCamera._projectionMatrixArray = new Float32Array( 16 );

      shadowCamera.matrixWorldInverse.flattenToArray( webglCamera._viewMatrixArray );
      shadowCamera.projectionMatrix.flattenToArray( webglCamera._projectionMatrixArray );

      _projScreenMatrix.multiply( shadowCamera.projectionMatrix, shadowCamera.matrixWorldInverse );
      _frustum.setFromMatrix( _projScreenMatrix );

      // render shadow map

      _renderer.setRenderTarget( shadowMap );
      _renderer.clear();

      // set object matrices & frustum culling

      renderList = scene["__webglObjects"];

      jl = renderList.length;
      for ( j = 0; j < jl; j ++ ) {

        webglObject = renderList[ j ];
        object = webglObject.object;

        webglObject.render = false;

        if ( object.visible && object.castShadow ) {

          if ( ! ( object is Mesh ) || ! ( object.frustumCulled ) || _frustum.contains( object ) ) {

            webglObject._modelViewMatrix.multiply( shadowCamera.matrixWorldInverse, object.matrixWorld );

            webglObject.render = true;

          }

        }

      }

      // render regular objects

      var objectMaterial, useMorphing, useSkinning;

      jl = renderList.length;
      for ( j = 0; j < jl; j ++ ) {

        webglObject = renderList[ j ];

        if ( webglObject.render ) {

          object = webglObject.object;
          buffer = webglObject.buffer;

          // culling is overriden globally for all objects
          // while rendering depth map

          // need to deal with MeshFaceMaterial somehow
          // in that case just use the first of geometry.materials for now
          // (proper solution would require to break objects by materials
          //  similarly to regular rendering and then set corresponding
          //  depth materials per each chunk instead of just once per object)

          objectMaterial = getObjectMaterial( object );

          useMorphing = object.geometry.morphTargets.length > 0 && objectMaterial.morphTargets;
          useSkinning = object is SkinnedMesh && objectMaterial.skinning;

          if ( object.customDepthMaterial != null ) {

            material = object.customDepthMaterial;

          } else if ( useSkinning ) {

            material = useMorphing ? _depthMaterialMorphSkin : _depthMaterialSkin;

          } else if ( useMorphing ) {

            material = _depthMaterialMorph;

          } else {

            material = _depthMaterial;

          }

          if ( buffer is BufferGeometry ) {

            _renderer.renderBufferDirect( shadowCamera, scene.lights, fog, material, buffer, object );

          } else {

            _renderer.renderBuffer( shadowCamera, scene.lights, fog, material, buffer, object );

          }

        }

      }

      // set matrices and render immediate objects

      renderList = scene["__webglObjectsImmediate"];

      jl = renderList.length;
      for ( j = 0; j < jl; j ++ ) {

        webglObject = renderList[ j ];
        object = webglObject.object;

        if ( object.visible && object.castShadow ) {

          object._modelViewMatrix.multiply( shadowCamera.matrixWorldInverse, object.matrixWorld );

          _renderer.renderImmediateObject( shadowCamera, scene.lights, fog, _depthMaterial, object );

        }

      }

    }

    // restore GL state

    var clearColor = _renderer.clearColor;
    var clearAlpha = _renderer.clearAlpha;

    _gl.clearColor( clearColor.r, clearColor.g, clearColor.b, clearAlpha );
    _gl.enable( gl.BLEND );

    if ( _renderer.shadowMapCullFrontFaces ) {

      _gl.cullFace( gl.BACK );

    }

  }

  createVirtualLight( light, cascade ) {

    var virtualLight = new VirtualLight();

    virtualLight.onlyShadow = true;
    virtualLight.castShadow = true;

    virtualLight.shadowCameraNear = light.shadowCameraNear;
    virtualLight.shadowCameraFar = light.shadowCameraFar;

    virtualLight.shadowCameraLeft = light.shadowCameraLeft;
    virtualLight.shadowCameraRight = light.shadowCameraRight;
    virtualLight.shadowCameraBottom = light.shadowCameraBottom;
    virtualLight.shadowCameraTop = light.shadowCameraTop;

    virtualLight.shadowCameraVisible = light.shadowCameraVisible;

    virtualLight.shadowDarkness = light.shadowDarkness;

    virtualLight.shadowBias = light.shadowCascadeBias[ cascade ];
    virtualLight.shadowMapWidth = light.shadowCascadeWidth[ cascade ];
    virtualLight.shadowMapHeight = light.shadowCascadeHeight[ cascade ];

    virtualLight.pointsWorld = [];
    virtualLight.pointsFrustum = [];

    var pointsWorld = virtualLight.pointsWorld,
      pointsFrustum = virtualLight.pointsFrustum;

    for ( var i = 0; i < 8; i ++ ) {

      pointsWorld[ i ] = new Vector3();
      pointsFrustum[ i ] = new Vector3();

    }

    var nearZ = light.shadowCascadeNearZ[ cascade ];
    var farZ = light.shadowCascadeFarZ[ cascade ];

    pointsFrustum[ 0 ].set( -1, -1, nearZ );
    pointsFrustum[ 1 ].set(  1, -1, nearZ );
    pointsFrustum[ 2 ].set( -1,  1, nearZ );
    pointsFrustum[ 3 ].set(  1,  1, nearZ );

    pointsFrustum[ 4 ].set( -1, -1, farZ );
    pointsFrustum[ 5 ].set(  1, -1, farZ );
    pointsFrustum[ 6 ].set( -1,  1, farZ );
    pointsFrustum[ 7 ].set(  1,  1, farZ );

    return virtualLight;

  }

  // Synchronize virtual light with the original light

  updateVirtualLight( light, cascade ) {

    var virtualLight = light.shadowCascadeArray[ cascade ];

    virtualLight.position.copy( light.position );
    virtualLight.target.position.copy( light.target.position );
    virtualLight.lookAt( virtualLight.target );

    virtualLight.shadowCameraVisible = light.shadowCameraVisible;
    virtualLight.shadowDarkness = light.shadowDarkness;

    virtualLight.shadowBias = light.shadowCascadeBias[ cascade ];

    var nearZ = light.shadowCascadeNearZ[ cascade ];
    var farZ = light.shadowCascadeFarZ[ cascade ];

    var pointsFrustum = virtualLight.pointsFrustum;

    pointsFrustum[ 0 ].z = nearZ;
    pointsFrustum[ 1 ].z = nearZ;
    pointsFrustum[ 2 ].z = nearZ;
    pointsFrustum[ 3 ].z = nearZ;

    pointsFrustum[ 4 ].z = farZ;
    pointsFrustum[ 5 ].z = farZ;
    pointsFrustum[ 6 ].z = farZ;
    pointsFrustum[ 7 ].z = farZ;

  }

  // Fit shadow camera's ortho frustum to camera frustum

  updateShadowCamera( camera, light ) {

    var shadowCamera = light.shadowCamera,
      pointsFrustum = light.pointsFrustum,
      pointsWorld = light.pointsWorld;

    _min.setValues( double.INFINITY, double.INFINITY, double.INFINITY );
    _max.setValues( double.NEGATIVE_INFINITY, double.NEGATIVE_INFINITY, double.NEGATIVE_INFINITY );

    for ( var i = 0; i < 8; i ++ ) {

      var p = pointsWorld[ i ];

      p.copy( pointsFrustum[ i ] );
      __projector.unprojectVector( p, camera );

      shadowCamera.matrixWorldInverse.multiplyVector3( p );

      if ( p.x < _min.x ) _min.x = p.x;
      if ( p.x > _max.x ) _max.x = p.x;

      if ( p.y < _min.y ) _min.y = p.y;
      if ( p.y > _max.y ) _max.y = p.y;

      if ( p.z < _min.z ) _min.z = p.z;
      if ( p.z > _max.z ) _max.z = p.z;

    }

    shadowCamera.left = _min.x;
    shadowCamera.right = _max.x;
    shadowCamera.top = _max.y;
    shadowCamera.bottom = _min.y;

    // can't really fit near/far
    //shadowCamera.near = _min.z;
    //shadowCamera.far = _max.z;

    shadowCamera.updateProjectionMatrix();

  }

  // For the moment just ignore objects that have multiple materials with different animation methods
  // Only the first material will be taken into account for deciding which depth material to use for shadow maps

  getObjectMaterial( object ) {

    return object.material is MeshFaceMaterial ? object.geometry.materials[ 0 ] : object.material;

  }

}

class VirtualLight extends DirectionalLight {
  List pointsWorld, pointsFrustum;

  VirtualLight() :
    pointsWorld = [],
    pointsFrustum = [],
    super(0);
}

