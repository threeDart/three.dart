part of three;

class WebGLRenderer implements Renderer {

  static const String PRECISION_HIGH = 'highp';

  CanvasElement canvas;
  gl.RenderingContext _gl;

  String precision;

  Color clearColor;
  num clearAlpha;
  int maxLights;

	bool alpha,
		   premultipliedAlpha,
		   antialias,
		   stencil,
		   preserveDrawingBuffer;

  bool autoClear,
		autoClearColor,
		autoClearDepth,
		autoClearStencil;

	// scene graph

  bool sortObjects,
	autoUpdateObjects,
	autoUpdateScene;

	// physically based shading

	bool gammaInput,
	gammaOutput,
	physicallyBasedShading;

	// shadow map

	bool shadowMapEnabled,
	shadowMapAutoUpdate,
	shadowMapSoft,
	shadowMapCullFrontFaces,
	shadowMapDebug,
	shadowMapCascade;

	// morphs

	int maxMorphTargets,
		maxMorphNormals;

	// flags

	bool autoScaleCubemaps;

	// custom render plugins

	List renderPluginsPre,
		renderPluginsPost;


	WebGLRendererInfo info;

	/** Internal properties **/

	List _programs;
	int _programs_counter;

	// internal state cache
	var _currentProgram = null,
		_currentFramebuffer = null,
		_currentMaterialId = -1,
		_currentGeometryGroupHash = null,
		_currentCamera = null,
		_geometryGroupCounter = 0;

	// GL state cache
	var _oldDoubleSided = -1,
	_oldFlipSided = -1,

	_oldBlending = -1,

	_oldBlendEquation = -1,
	_oldBlendSrc = -1,
	_oldBlendDst = -1,

	_oldDepthTest = -1,
	_oldDepthWrite = -1,

	_oldPolygonOffset = null,
	_oldPolygonOffsetFactor = null,
	_oldPolygonOffsetUnits = null,

	_oldLineWidth = null,

	_viewportX = 0,
	_viewportY = 0,
	_viewportWidth = 0,
	_viewportHeight = 0,
	_currentWidth = 0,
	_currentHeight = 0;

	 // frustum
	Frustum _frustum;

   // camera matrices cache
  Matrix4 _projScreenMatrix,
          _projScreenMatrixPS;

  Vector4 _vector3;

  // light arrays cache
  Vector3 _direction;

  Map _lights;
  bool _lightsNeedUpdate;

  // GL Extensions
  gl.OesTextureFloat _glExtensionTextureFloat;
  gl.OesStandardDerivatives _glExtensionStandardDerivatives;
	gl.ExtTextureFilterAnisotropic _glExtensionTextureFilterAnisotropic;

  var maxAnisotropy;

  bool supportsVertexTextures,
  	   supportsBoneTextures;

  var shadowMapPlugin;

  num maxVertexTextures, maxTextureSize, maxCubemapSize;

  WebGLRenderer( {	this.canvas,
  					this.precision: PRECISION_HIGH,
  					this.alpha: true,
			      this.premultipliedAlpha: true,
		        this.antialias: true,
	          this.stencil: true,
  					this.preserveDrawingBuffer: false,
  					num clearColorHex: 0x000000,
  					this.clearAlpha: 0,
  					this.maxLights: 4} )
  		:

  		clearColor = new Color(clearColorHex),

			// clearing
			autoClear = true,
			autoClearColor = true,
			autoClearDepth = true,
			autoClearStencil = true,

			// scene graph
			sortObjects = true,
			autoUpdateObjects = true,
			autoUpdateScene = true,

			// physically based shading
			gammaInput = false,
			gammaOutput = false,
			physicallyBasedShading = false,

			// shadow map
			shadowMapEnabled = false,
			shadowMapAutoUpdate = true,
			shadowMapSoft = true,
			shadowMapCullFrontFaces = true,
			shadowMapDebug = false,
			shadowMapCascade = false,

			// morphs
			maxMorphTargets = 8,
			maxMorphNormals = 4,

			// flags
			autoScaleCubemaps = true,

			// custom render plugins
			renderPluginsPre = [],
			renderPluginsPost = [],

			info = new WebGLRendererInfo(),

			// internal properties

	_programs = [],
	_programs_counter = 0,

	// internal state cache

	_currentProgram = null,
	_currentFramebuffer = null,
	_currentMaterialId = -1,
	_currentGeometryGroupHash = null,
	_currentCamera = null,
	_geometryGroupCounter = 0,

	// GL state cache

	_oldDoubleSided = -1,
	_oldFlipSided = -1,

	_oldBlending = -1,

	_oldBlendEquation = -1,
	_oldBlendSrc = -1,
	_oldBlendDst = -1,

	_oldDepthTest = -1,
	_oldDepthWrite = -1,

	_oldPolygonOffset = null,
	_oldPolygonOffsetFactor = null,
	_oldPolygonOffsetUnits = null,

	_oldLineWidth = null,

	_viewportX = 0,
	_viewportY = 0,
	_viewportWidth = 0,
	_viewportHeight = 0,
	_currentWidth = 0,
	_currentHeight = 0 ,

	// frustum
  _frustum = new Frustum(),

   // camera matrices cache
  _projScreenMatrix = new Matrix4(),
  _projScreenMatrixPS = new Matrix4(),

  _vector3 = new Vector4(),

  // light arrays cache

  _direction = new Vector3(),

  _lightsNeedUpdate = true

  {

	  _lights = {

	    "ambient": [ 0, 0, 0 ],
	    "directional": { "length": 0, "colors": [], "positions": [] },
	    "point": { "length": 0, "colors": [], "positions": [], "distances": [] },
	    "spot": { "length": 0, "colors": [], "positions": [], "distances": [], "directions": [], "angles": [], "exponents": [] }

	  };



    if (canvas == null) {
        canvas = new CanvasElement();
    }

  	// initialize

  	initGL();

  	setDefaultGLState();


  	// GPU capabilities

  	maxVertexTextures = _gl.getParameter( gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS );
	  maxTextureSize = _gl.getParameter( gl.MAX_TEXTURE_SIZE );
	  maxCubemapSize = _gl.getParameter( gl.MAX_CUBE_MAP_TEXTURE_SIZE );

  	maxAnisotropy = (_glExtensionTextureFilterAnisotropic != null) ? _gl.getParameter( gl.ExtTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT ) : 0;

  	supportsVertexTextures = ( maxVertexTextures > 0 );
  	supportsBoneTextures = supportsVertexTextures && (_glExtensionTextureFloat != null);


  	// default plugins (order is important)

  	shadowMapPlugin = new ShadowMapPlugin();
  	addPrePlugin( shadowMapPlugin );

  	//addPostPlugin( new SpritePlugin() );
  	//addPostPlugin( new LensFlarePlugin() );

  }

  Element get domElement => canvas;

	// API

	get context => _gl;


	setSize( width, height ) {
		canvas.width = width;
		canvas.height = height;

		setViewport( 0, 0, canvas.width, canvas.height );

	}

	setViewport( [x = 0, y = 0, width = -1, height = -1] ) {

		_viewportX = x;
		_viewportY = y;


		_viewportWidth = (width != -1) ? width : canvas.width;
		_viewportHeight = (height != -1)? height : canvas.height;

		_gl.viewport( _viewportX, _viewportY, _viewportWidth, _viewportHeight );

	}

	setScissor( x, y, width, height ) {
		_gl.scissor( x, y, width, height );
	}

	enableScissorTest( enable ) {
		enable ? _gl.enable( gl.SCISSOR_TEST ) : _gl.disable( gl.SCISSOR_TEST );
	}

	// Clearing
	setClearColorHex( hex, alpha ) {

		clearColor.setHex( hex );
		clearAlpha = alpha;

		_gl.clearColor( clearColor.r, clearColor.g, clearColor.b, clearAlpha );

	}

	setClearColor( color, alpha ) {

		clearColor.copy( color );
		clearAlpha = alpha;

		_gl.clearColor( clearColor.r, clearColor.g, clearColor.b, clearAlpha );

	}


	clear( [ bool color = true, bool depth = true, bool stencil = true] ) {

		var bits = 0;

		if ( color ) bits |= gl.COLOR_BUFFER_BIT;
		if ( depth ) bits |= gl.DEPTH_BUFFER_BIT;
		if ( stencil ) bits |= gl.STENCIL_BUFFER_BIT;

		_gl.clear( bits );

	}

	clearTarget( renderTarget, color, depth, stencil ) {
		setRenderTarget( renderTarget );
		clear( color, depth, stencil );
	}

	// Plugins
	addPostPlugin( plugin ) {
		plugin.init( this );
		renderPluginsPost.add( plugin );
	}

	addPrePlugin( plugin ) {
		plugin.init( this );
		renderPluginsPre.add( plugin );
	}

	// Deallocation

	deallocateObject( WebGLObject webglobject ) {

	  Object3D object = webglobject.object; // unwrap

		if ( ! webglobject.__webglInit ) return;

		webglobject.__webglInit = false;

		webglobject._modelViewMatrix = null; //delete object["_modelViewMatrix"];
		webglobject._normalMatrix = null; //delete object["_normalMatrix"];

		webglobject._normalMatrixArray = null; //delete object["_normalMatrixArray"];
		webglobject._modelViewMatrixArray = null; //delete object["_modelViewMatrixArray"];
		webglobject.modelMatrixArray = null;//delete object["modelMatrixArray"];

		WebGLGeometry geometry = webglobject.webglgeometry;

		if ( object is Mesh ) {

			for ( var g in geometry.geometryGroups ) {

				deleteMeshBuffers( geometry.geometryGroups[ g ] );

			}

		} else if ( object is Ribbon ) {

			deleteRibbonBuffers( geometry);

		} else if ( object is Line ) {

			deleteLineBuffers( geometry );

		} else if ( object is ParticleSystem ) {

			deleteParticleBuffers( geometry );

		}

	}

	deallocateTexture( texture ) {

		if ( ! texture["__webglInit"] ) return;

		texture["__webglInit"] = false;
		_gl.deleteTexture( texture["__webglTexture"] );

		info.memory.textures --;

	}

	deallocateRenderTarget( WebGLRenderTarget renderTarget ) {

		if ( (renderTarget == null) || (renderTarget.__webglTexture == null) ) return;

		_gl.deleteTexture( renderTarget.__webglTexture );

		if ( renderTarget is WebGLRenderTargetCube ) {

			for ( var i = 0; i < 6; i ++ ) {

				_gl.deleteFramebuffer( renderTarget.__webglFramebuffer[ i ] );
				_gl.deleteRenderbuffer( renderTarget.__webglRenderbuffer[ i ] );

			}

		} else {

			_gl.deleteFramebuffer( renderTarget.__webglFramebuffer );
			_gl.deleteRenderbuffer( renderTarget.__webglRenderbuffer );

		}

	}

	deallocateMaterial( material ) {

		Program program = material.program;

		if ( program == null ) return;

		material.program = null;

		// only deallocate GL program if this was the last use of shared program
		// assumed there is only single copy of any program in the _programs list
		// (that's how it's constructed)

		program.usedTimes --;

    var deleteProgram = ( program.usedTimes == 0 );

		if ( deleteProgram ) {

			// -avoid using array.splice, this is costlier than creating new array from scratch

			_programs.removeAt(_programs.indexOf(program));

			_gl.deleteProgram( program.glProgram );

			info.memory.programs --;

		}

	}

	// Rendering

	updateShadowMap( scene, camera ) {

		_currentProgram = null;
		_oldBlending = -1;
		_oldDepthTest = -1;
		_oldDepthWrite = -1;
		_currentGeometryGroupHash = -1;
		_currentMaterialId = -1;
		_lightsNeedUpdate = true;
		_oldDoubleSided = -1;
		_oldFlipSided = -1;

		shadowMapPlugin.update( scene, camera );

	}

	// Internal functions

	// Buffer allocation

	createParticleBuffers ( WebGLGeometry geometry ) {

		geometry.__webglVertexBuffer = _gl.createBuffer();
		geometry.__webglColorBuffer = _gl.createBuffer();

		info.memory.geometries++;

	}

	createLineBuffers ( WebGLGeometry geometry ) {

		geometry.__webglVertexBuffer = _gl.createBuffer();
		geometry.__webglColorBuffer = _gl.createBuffer();

		info.memory.geometries ++;

	}

	createRibbonBuffers ( WebGLGeometry geometry ) {

		geometry.__webglVertexBuffer = _gl.createBuffer();
		geometry.__webglColorBuffer = _gl.createBuffer();

		info.memory.geometries ++;

	}

	createMeshBuffers ( WebGLGeometry geometryGroup ) {

		geometryGroup.__webglVertexBuffer = _gl.createBuffer();
		geometryGroup.__webglNormalBuffer = _gl.createBuffer();
		geometryGroup.__webglTangentBuffer = _gl.createBuffer();
		geometryGroup.__webglColorBuffer = _gl.createBuffer();
		geometryGroup.__webglUVBuffer = _gl.createBuffer();
		geometryGroup.__webglUV2Buffer = _gl.createBuffer();

		geometryGroup.__webglSkinVertexABuffer = _gl.createBuffer();
		geometryGroup.__webglSkinVertexBBuffer = _gl.createBuffer();
		geometryGroup.__webglSkinIndicesBuffer = _gl.createBuffer();
		geometryGroup.__webglSkinWeightsBuffer = _gl.createBuffer();

		geometryGroup.__webglFaceBuffer = _gl.createBuffer();
		geometryGroup.__webglLineBuffer = _gl.createBuffer();

		var m, ml;

		if ( geometryGroup.numMorphTargets != null ) {

			geometryGroup.__webglMorphTargetsBuffers = [];

			 ml = geometryGroup.numMorphTargets;

			for ( m = 0; m < ml; m ++ ) {

				geometryGroup.__webglMorphTargetsBuffers.add( _gl.createBuffer() );

			}

		}

		if ( geometryGroup.numMorphNormals != null ) {

			geometryGroup.__webglMorphNormalsBuffers = [];

			ml = geometryGroup.numMorphNormals;

			for ( m = 0; m < ml; m ++ ) {
				geometryGroup.__webglMorphNormalsBuffers.add( _gl.createBuffer() );

			}

		}

		info.memory.geometries++;

	}

	// Buffer deallocation

	deleteParticleBuffers ( WebGLGeometry geometry ) {

		_gl.deleteBuffer( geometry.__webglVertexBuffer );
		_gl.deleteBuffer( geometry.__webglColorBuffer );

		info.memory.geometries --;

	}

	deleteLineBuffers ( WebGLGeometry geometry ) {

		_gl.deleteBuffer( geometry.__webglVertexBuffer );
		_gl.deleteBuffer( geometry.__webglColorBuffer );

		info.memory.geometries --;

	}

	deleteRibbonBuffers ( WebGLGeometry geometry ) {

		_gl.deleteBuffer( geometry.__webglVertexBuffer );
		_gl.deleteBuffer( geometry.__webglColorBuffer );

		info.memory.geometries --;

	}

	deleteMeshBuffers ( WebGLGeometry geometryGroup ) {

		_gl.deleteBuffer( geometryGroup.__webglVertexBuffer );
		_gl.deleteBuffer( geometryGroup.__webglNormalBuffer );
		_gl.deleteBuffer( geometryGroup.__webglTangentBuffer );
		_gl.deleteBuffer( geometryGroup.__webglColorBuffer );
		_gl.deleteBuffer( geometryGroup.__webglUVBuffer );
		_gl.deleteBuffer( geometryGroup.__webglUV2Buffer );

		_gl.deleteBuffer( geometryGroup.__webglSkinVertexABuffer );
		_gl.deleteBuffer( geometryGroup.__webglSkinVertexBBuffer );
		_gl.deleteBuffer( geometryGroup.__webglSkinIndicesBuffer );
		_gl.deleteBuffer( geometryGroup.__webglSkinWeightsBuffer );

		_gl.deleteBuffer( geometryGroup.__webglFaceBuffer );
		_gl.deleteBuffer( geometryGroup.__webglLineBuffer );

		var m, ml;

		if ( geometryGroup.numMorphTargets != null ) {

			ml = geometryGroup.numMorphTargets;

			for ( m = 0; m < ml; m ++ ) {

				_gl.deleteBuffer( geometryGroup.__webglMorphTargetsBuffers[ m ] );

			}

		}

		if ( geometryGroup.numMorphNormals > 0 ) {

			ml = geometryGroup.numMorphNormals;

			for ( m = 0; m < ml; m ++ ) {

				_gl.deleteBuffer( geometryGroup.__webglMorphNormalsBuffers[ m ] );

			}

		}


		if ( geometryGroup.__webglCustomAttributesList ) {

			for ( var id in geometryGroup.__webglCustomAttributesList ) {

				_gl.deleteBuffer( geometryGroup.__webglCustomAttributesList[ id ].buffer );

			}

		}

		info.memory.geometries --;

	}

	// Buffer initialization

	initCustomAttributes ( WebGLGeometry geometry, WebGLObject object ) {

		var nvertices = geometry.vertices.length;

		var material = object.webglmaterial;

		if ( material.attributes != null ) {

			if ( geometry.__webglCustomAttributesList == null ) {

				geometry.__webglCustomAttributesList = [];

			}

			for ( var a in material.attributes ) {

				var attribute = material.attributes[ a ];

				if( !attribute["__webglInitialized"] || attribute.createUniqueBuffers ) {

					attribute["__webglInitialized"] = true;

					var size = 1;		// "f" and "i"

					if ( attribute.type == "v2" ) { size = 2;
					} else if ( attribute.type == "v3" ) { size = 3;
					} else if ( attribute.type == "v4" ) { size = 4;
					} else if ( attribute.type == "c"  ) size = 3;

					attribute.size = size;

					attribute.array = new Float32Array( nvertices * size );

					attribute.buffer = new Buffer(_gl.createBuffer());
					attribute.buffer.belongsToAttribute = a;

					attribute.needsUpdate = true;

				}

				geometry.__webglCustomAttributesList.add( attribute );

			}

		}

	}

	initParticleBuffers ( WebGLGeometry geometry, WebGLObject object ) {

		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array( nvertices * 3 );
		geometry.__colorArray = new Float32Array( nvertices * 3 );

		geometry.__sortArray = [];

		geometry.__webglParticleCount = nvertices;

		initCustomAttributes ( geometry, object );

	}

	initLineBuffers ( WebGLGeometry geometry, WebGLObject object ) {

		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array( nvertices * 3 );
		geometry.__colorArray = new Float32Array( nvertices * 3 );

		geometry.__webglLineCount = nvertices;

		initCustomAttributes ( geometry, object );

	}

	initRibbonBuffers ( WebGLGeometry geometry ) {

		var nvertices = geometry.vertices.length;

		geometry.__vertexArray = new Float32Array( nvertices * 3 );
		geometry.__colorArray = new Float32Array( nvertices * 3 );

		geometry.__webglVertexCount = nvertices;

	}

	initMeshBuffers ( WebGLGeometry geometryGroup, WebGLObject object ) {

		var geometry = object.geometry,
			faces3 = geometryGroup.faces3,
			faces4 = geometryGroup.faces4,

			nvertices = faces3.length * 3 + faces4.length * 4,
			ntris     = faces3.length * 1 + faces4.length * 2,
			nlines    = faces3.length * 3 + faces4.length * 4;

		WebGLMaterial material = getBufferMaterial( object, geometryGroup );

		var uvType = bufferGuessUVType( material ),
			normalType = bufferGuessNormalType( material ),
			vertexColorType = bufferGuessVertexColorType( material );

		//console.log( "uvType", uvType, "normalType", normalType, "vertexColorType", vertexColorType, object, geometryGroup, material );

		geometryGroup.__vertexArray = new Float32Array( nvertices * 3 );

		if ( normalType != NoShading ) {

			geometryGroup.__normalArray = new Float32Array( nvertices * 3 );

		}

		if ( geometry.hasTangents ) {

			geometryGroup.__tangentArray = new Float32Array( nvertices * 4 );

		}

		if ( vertexColorType ) {

			geometryGroup.__colorArray = new Float32Array( nvertices * 3 );

		}

		if ( uvType ) {

			if ( geometry.faceUvs.length > 0 || geometry.faceVertexUvs.length > 0 ) {

				geometryGroup.__uvArray = new Float32Array( nvertices * 2 );

			}

			if ( geometry.faceUvs.length > 1 || geometry.faceVertexUvs.length > 1 ) {

				geometryGroup.__uv2Array = new Float32Array( nvertices * 2 );

			}

		}

		if ( !object.geometry.skinWeights.isEmpty && !object.geometry.skinIndices.isEmpty ) {

			geometryGroup.__skinVertexAArray = new Float32Array( nvertices * 4 );
			geometryGroup.__skinVertexBArray = new Float32Array( nvertices * 4 );
			geometryGroup.__skinIndexArray = new Float32Array( nvertices * 4 );
			geometryGroup.__skinWeightArray = new Float32Array( nvertices * 4 );

		}

		geometryGroup.__faceArray = new Uint16Array( ntris * 3 );
		geometryGroup.__lineArray = new Uint16Array( nlines * 2 );

		var m, ml;

		if ( geometryGroup.numMorphTargets != null ) {

			geometryGroup.__morphTargetsArrays = [];

			ml = geometryGroup.numMorphTargets;

			for ( m = 0; m < ml; m ++ ) {

				geometryGroup.__morphTargetsArrays.add( new Float32Array( nvertices * 3 ) );

			}

		}

		if ( geometryGroup.numMorphNormals != null ) {

			geometryGroup.__morphNormalsArrays = [];

			ml = geometryGroup.numMorphNormals;

			for ( m = 0; m < ml; m ++ ) {

				geometryGroup.__morphNormalsArrays.add( new Float32Array( nvertices * 3 ) );

			}

		}

		geometryGroup.__webglFaceCount = ntris * 3;
		geometryGroup.__webglLineCount = nlines * 2;


		// custom attributes

		if ( material.attributes != null) {

			if ( geometryGroup.__webglCustomAttributesList == null ) {

				geometryGroup.__webglCustomAttributesList = [];

			}

			material.attributes.forEach((a) {

				// Do a shallow copy of the attribute object so different geometryGroup chunks use different
				// attribute buffers which are correctly indexed in the setMeshBuffers function

				var originalAttribute = material.attributes[ a ];

				var attribute = {};

				for ( var property in originalAttribute ) {

					attribute[ property ] = originalAttribute[ property ];

				}

				if( ( attribute["__webglInitialized"] == null ||  attribute["__webglInitialized"] == false) ||
				    ( attribute["createUniqueBuffers"] != null && attribute["createUniqueBuffers"]) ) {

					attribute["__webglInitialized"] = true;

					var size = 1;		// "f" and "i"

					if( attribute["type"] == "v2" ) { size = 2;
					} else if( attribute["type"] == "v3" ) { size = 3;
					} else if( attribute["type"] == "v4" ) { size = 4;
					} else if( attribute["type"] == "c"  ) size = 3;

					attribute["size"] = size;

					attribute["array"] = new Float32Array( nvertices * size );

					var buffer = new Buffer(_gl.createBuffer());
					buffer.belongsToAttribute = a;
					attribute["buffer"] = buffer;

					originalAttribute.needsUpdate = true;
					attribute["__original"] = originalAttribute;

				}

				geometryGroup.__webglCustomAttributesList.add( attribute );

			});

		}

		geometryGroup.__inittedArrays = true;

	}

	WebGLMaterial getBufferMaterial( WebGLObject object, WebGLGeometry geometryGroup ) {

	  Material material;

		if ( (object.material != null) && ! ( object.material is MeshFaceMaterial ) ) {

			material = object.material;

		} else if ( geometryGroup.materialIndex >= 0 ) {

			material = object.geometry.materials[ geometryGroup.materialIndex ];

		}

		return new WebGLMaterial.from(material);
	}


	int bufferGuessNormalType ( WebGLMaterial material ) {

		// only MeshBasicMaterial and MeshDepthMaterial don't need normals

		if ( !material.needsNormals  ) {
			return NoShading;
		}

		if ( material.needsSmoothNormals ) {

			return SmoothShading;

		} else {

			return FlatShading;

		}

	}

	bool bufferGuessVertexColorType ( material ) {

		if ( (material.vertexColors != null) &&  (material.vertexColors != NoColors) ) {

			return material.vertexColors;

		}

		return false;

	}

	bool bufferGuessUVType ( material ) {

		// material must use some texture to require uvs

		if ((material.map != null) ||
		    (material.lightMap != null) ||
		    (material.bumpMap != null) ||
		    (material.specularMap != null) ||
		    (material.isShaderMaterial)) {

			return true;

		}

		return false;

	}

	//

	initDirectBuffers( BufferGeometry geometry ) {

		var a, attribute, type;

		geometry.attributes.forEach((a, v) {

			if ( a == "index" ) {

				type = gl.ELEMENT_ARRAY_BUFFER;

			} else {

				type = gl.ARRAY_BUFFER;

			}

			attribute = v;

			attribute.buffer = _gl.createBuffer();

			_gl.bindBuffer( type, attribute.buffer );
			_gl.bufferData( type, attribute.array, gl.STATIC_DRAW );

		});

	}

	// Buffer setting

	setParticleBuffers ( WebGLGeometry geometry, hint, object ) {

		var v, c, vertex, offset, index, color,

		vertices = geometry.vertices,
		vl = vertices.length,

		colors = geometry.colors,
		cl = colors.length,

		vertexArray = geometry.__vertexArray,
		colorArray = geometry.__colorArray,

		sortArray = geometry.__sortArray,

		dirtyVertices = geometry.verticesNeedUpdate,
		dirtyElements = geometry.elementsNeedUpdate,
		dirtyColors = geometry.colorsNeedUpdate,

		customAttributes = geometry.__webglCustomAttributesList,
		i, il,
		a, ca, cal, value,
		customAttribute;

		if ( object.sortParticles ) {

			_projScreenMatrixPS.copy( _projScreenMatrix );
			_projScreenMatrixPS.multiplySelf( object.matrixWorld );

			for ( v = 0; v < vl; v ++ ) {

				vertex = vertices[ v ];

				_vector3.copy( vertex );
				_projScreenMatrixPS.multiplyVector3( _vector3 );

				sortArray[ v ] = [ _vector3.z, v ];

			}

			sortArray.sort( ( a, b ) { return b[ 0 ] - a[ 0 ]; } );

			for ( v = 0; v < vl; v ++ ) {

				vertex = vertices[ sortArray[v][1] ];

				offset = v * 3;

				vertexArray[ offset ]     = vertex.x;
				vertexArray[ offset + 1 ] = vertex.y;
				vertexArray[ offset + 2 ] = vertex.z;

			}

			for ( c = 0; c < cl; c ++ ) {

				offset = c * 3;

				color = colors[ sortArray[c][1] ];

				colorArray[ offset ]     = color.r;
				colorArray[ offset + 1 ] = color.g;
				colorArray[ offset + 2 ] = color.b;

			}

			if ( customAttributes != null ) {

				il = customAttributes.length;
				for ( i = 0; i < il; i ++ ) {

					customAttribute = customAttributes[ i ];

					if ( ! ( customAttribute.boundTo == null || customAttribute.boundTo == "vertices" ) ) continue;

					offset = 0;

					cal = customAttribute.value.length;

					if ( customAttribute.size == 1 ) {

						for ( ca = 0; ca < cal; ca ++ ) {

							index = sortArray[ ca ][ 1 ];

							customAttribute.array[ ca ] = customAttribute.value[ index ];

						}

					} else if ( customAttribute.size == 2 ) {

						for ( ca = 0; ca < cal; ca ++ ) {

							index = sortArray[ ca ][ 1 ];

							value = customAttribute.value[ index ];

							customAttribute.array[ offset ] 	= value.x;
							customAttribute.array[ offset + 1 ] = value.y;

							offset += 2;

						}

					} else if ( customAttribute.size == 3 ) {

						if ( customAttribute.type == "c" ) {

							for ( ca = 0; ca < cal; ca ++ ) {

								index = sortArray[ ca ][ 1 ];

								value = customAttribute.value[ index ];

								customAttribute.array[ offset ]     = value.r;
								customAttribute.array[ offset + 1 ] = value.g;
								customAttribute.array[ offset + 2 ] = value.b;

								offset += 3;

							}

						} else {

							for ( ca = 0; ca < cal; ca ++ ) {

								index = sortArray[ ca ][ 1 ];

								value = customAttribute.value[ index ];

								customAttribute.array[ offset ] 	= value.x;
								customAttribute.array[ offset + 1 ] = value.y;
								customAttribute.array[ offset + 2 ] = value.z;

								offset += 3;

							}

						}

					} else if ( customAttribute.size == 4 ) {

						for ( ca = 0; ca < cal; ca ++ ) {

							index = sortArray[ ca ][ 1 ];

							value = customAttribute.value[ index ];

							customAttribute.array[ offset ]      = value.x;
							customAttribute.array[ offset + 1  ] = value.y;
							customAttribute.array[ offset + 2  ] = value.z;
							customAttribute.array[ offset + 3  ] = value.w;

							offset += 4;

						}

					}

				}

			}

		} else {

			if ( dirtyVertices ) {

				for ( v = 0; v < vl; v ++ ) {

					vertex = vertices[ v ];

					offset = v * 3;

					vertexArray[ offset ]     = vertex.x;
					vertexArray[ offset + 1 ] = vertex.y;
					vertexArray[ offset + 2 ] = vertex.z;

				}

			}

			if ( dirtyColors ) {

				for ( c = 0; c < cl; c ++ ) {

					color = colors[ c ];

					offset = c * 3;

					colorArray[ offset ]     = color.r;
					colorArray[ offset + 1 ] = color.g;
					colorArray[ offset + 2 ] = color.b;

				}

			}

			if ( customAttributes != null) {

				il = customAttributes.length;
				for ( i = 0; i < il; i ++ ) {

					customAttribute = customAttributes[ i ];

					if ( customAttribute.needsUpdate &&
						 ( customAttribute.boundTo == null ||
						   customAttribute.boundTo == "vertices") ) {

						cal = customAttribute.value.length;

						offset = 0;

						if ( customAttribute.size == 1 ) {

							for ( ca = 0; ca < cal; ca ++ ) {

								customAttribute.array[ ca ] = customAttribute.value[ ca ];

							}

						} else if ( customAttribute.size == 2 ) {

							for ( ca = 0; ca < cal; ca ++ ) {

								value = customAttribute.value[ ca ];

								customAttribute.array[ offset ] 	= value.x;
								customAttribute.array[ offset + 1 ] = value.y;

								offset += 2;

							}

						} else if ( customAttribute.size == 3 ) {

							if ( customAttribute.type == "c" ) {

								for ( ca = 0; ca < cal; ca ++ ) {

									value = customAttribute.value[ ca ];

									customAttribute.array[ offset ] 	= value.r;
									customAttribute.array[ offset + 1 ] = value.g;
									customAttribute.array[ offset + 2 ] = value.b;

									offset += 3;

								}

							} else {

								for ( ca = 0; ca < cal; ca ++ ) {

									value = customAttribute.value[ ca ];

									customAttribute.array[ offset ] 	= value.x;
									customAttribute.array[ offset + 1 ] = value.y;
									customAttribute.array[ offset + 2 ] = value.z;

									offset += 3;

								}

							}

						} else if ( customAttribute.size == 4 ) {

							for ( ca = 0; ca < cal; ca ++ ) {

								value = customAttribute.value[ ca ];

								customAttribute.array[ offset ]      = value.x;
								customAttribute.array[ offset + 1  ] = value.y;
								customAttribute.array[ offset + 2  ] = value.z;
								customAttribute.array[ offset + 3  ] = value.w;

								offset += 4;

							}

						}

					}

				}

			}

		}

		if ( dirtyVertices || object.sortParticles ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometry.__webglVertexBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, vertexArray, hint );

		}

		if ( dirtyColors || object.sortParticles ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometry.__webglColorBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, colorArray, hint );

		}

		if ( customAttributes != null) {

			il = customAttributes.length;
			for ( i = 0; i < il; i ++ ) {

				customAttribute = customAttributes[ i ];

				if ( customAttribute.needsUpdate || object.sortParticles ) {

					_gl.bindBuffer( gl.ARRAY_BUFFER, customAttribute.buffer );
					_gl.bufferData( gl.ARRAY_BUFFER, customAttribute.array, hint );

				}

			}

		}


	}

	setLineBuffers ( WebGLGeometry geometry, hint ) {

		var v, c, vertex, offset, color,

		vertices = geometry.vertices,
		colors = geometry.colors,
		vl = vertices.length,
		cl = colors.length,

		vertexArray = geometry.__vertexArray,
		colorArray = geometry.__colorArray,

		dirtyVertices = geometry.verticesNeedUpdate,
		dirtyColors = geometry.colorsNeedUpdate,

		customAttributes = geometry.__webglCustomAttributesList,

		i, il,
		a, ca, cal, value,
		customAttribute;

		if ( dirtyVertices ) {

			for ( v = 0; v < vl; v ++ ) {

				vertex = vertices[ v ];

				offset = v * 3;

				vertexArray[ offset ]     = vertex.x;
				vertexArray[ offset + 1 ] = vertex.y;
				vertexArray[ offset + 2 ] = vertex.z;

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometry.__webglVertexBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, vertexArray, hint );

		}

		if ( dirtyColors ) {

			for ( c = 0; c < cl; c ++ ) {

				color = colors[ c ];

				offset = c * 3;

				colorArray[ offset ]     = color.r;
				colorArray[ offset + 1 ] = color.g;
				colorArray[ offset + 2 ] = color.b;

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometry.__webglColorBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, colorArray, hint );

		}

		if ( customAttributes != null ) {

			il = customAttributes.length;
			for ( i = 0; i < il; i ++ ) {

				customAttribute = customAttributes[ i ];

				if ( customAttribute.needsUpdate &&
					 ( customAttribute.boundTo == null ||
					   customAttribute.boundTo == "vertices" ) ) {

					offset = 0;

					cal = customAttribute.value.length;

					if ( customAttribute.size == 1 ) {

						for ( ca = 0; ca < cal; ca ++ ) {

							customAttribute.array[ ca ] = customAttribute.value[ ca ];

						}

					} else if ( customAttribute.size == 2 ) {

						for ( ca = 0; ca < cal; ca ++ ) {

							value = customAttribute.value[ ca ];

							customAttribute.array[ offset ] 	= value.x;
							customAttribute.array[ offset + 1 ] = value.y;

							offset += 2;

						}

					} else if ( customAttribute.size == 3 ) {

						if ( customAttribute.type == "c" ) {

							for ( ca = 0; ca < cal; ca ++ ) {

								value = customAttribute.value[ ca ];

								customAttribute.array[ offset ] 	= value.r;
								customAttribute.array[ offset + 1 ] = value.g;
								customAttribute.array[ offset + 2 ] = value.b;

								offset += 3;

							}

						} else {

							for ( ca = 0; ca < cal; ca ++ ) {

								value = customAttribute.value[ ca ];

								customAttribute.array[ offset ] 	= value.x;
								customAttribute.array[ offset + 1 ] = value.y;
								customAttribute.array[ offset + 2 ] = value.z;

								offset += 3;

							}

						}

					} else if ( customAttribute.size == 4 ) {

						for ( ca = 0; ca < cal; ca ++ ) {

							value = customAttribute.value[ ca ];

							customAttribute.array[ offset ] 	 = value.x;
							customAttribute.array[ offset + 1  ] = value.y;
							customAttribute.array[ offset + 2  ] = value.z;
							customAttribute.array[ offset + 3  ] = value.w;

							offset += 4;

						}

					}

					_gl.bindBuffer( gl.ARRAY_BUFFER, customAttribute.buffer );
					_gl.bufferData( gl.ARRAY_BUFFER, customAttribute.array, hint );

				}

			}

		}

	}

	setRibbonBuffers ( WebGLGeometry geometry, hint ) {

		var v, c, vertex, offset, color,

		vertices = geometry.vertices,
		colors = geometry.colors,
		vl = vertices.length,
		cl = colors.length,

		vertexArray = geometry.__vertexArray,
		colorArray = geometry.__colorArray,

		dirtyVertices = geometry.verticesNeedUpdate,
		dirtyColors = geometry.colorsNeedUpdate;

		if ( dirtyVertices ) {

			for ( v = 0; v < vl; v ++ ) {

				vertex = vertices[ v ];

				offset = v * 3;

				vertexArray[ offset ]     = vertex.x;
				vertexArray[ offset + 1 ] = vertex.y;
				vertexArray[ offset + 2 ] = vertex.z;

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometry.__webglVertexBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, vertexArray, hint );

		}

		if ( dirtyColors ) {

			for ( c = 0; c < cl; c ++ ) {

				color = colors[ c ];

				offset = c * 3;

				colorArray[ offset ]     = color.r;
				colorArray[ offset + 1 ] = color.g;
				colorArray[ offset + 2 ] = color.b;

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometry.__webglColorBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, colorArray, hint );

		}

	}

	setMeshBuffers( WebGLGeometry geometryGroup, WebGLObject object, hint, dispose, material ) {

		if ( ! geometryGroup.__inittedArrays ) {

			// console.log( object );
			return;

		}

		var normalType = bufferGuessNormalType( material ),
		vertexColorType = bufferGuessVertexColorType( material ),
		uvType = bufferGuessUVType( material ),

		needsSmoothNormals = ( normalType == SmoothShading );

		var f, fl, fi, face,
		vertexNormals, faceNormal, normal,
		vertexColors, faceColor,
		vertexTangents,
		uv, uv2, v1, v2, v3, v4, t1, t2, t3, t4, n1, n2, n3, n4,
		c1, c2, c3, c4,
		sw1, sw2, sw3, sw4,
		si1, si2, si3, si4,
		sa1, sa2, sa3, sa4,
		sb1, sb2, sb3, sb4,
		m, ml, i, il,
		vn, uvi, uv2i,
		vk, vkl, vka,
		nka, chf, faceVertexNormals,
		a,

		vertexIndex = 0,

		offset = 0,
		offset_uv = 0,
		offset_uv2 = 0,
		offset_face = 0,
		offset_normal = 0,
		offset_tangent = 0,
		offset_line = 0,
		offset_color = 0,
		offset_skin = 0,
		offset_morphTarget = 0,
		offset_custom = 0,
		offset_customSrc = 0,

		value,

		vertexArray = geometryGroup.__vertexArray,
		uvArray = geometryGroup.__uvArray,
		uv2Array = geometryGroup.__uv2Array,
		normalArray = geometryGroup.__normalArray,
		tangentArray = geometryGroup.__tangentArray,
		colorArray = geometryGroup.__colorArray,

		skinVertexAArray = geometryGroup.__skinVertexAArray,
		skinVertexBArray = geometryGroup.__skinVertexBArray,
		skinIndexArray = geometryGroup.__skinIndexArray,
		skinWeightArray = geometryGroup.__skinWeightArray,

		morphTargetsArrays = geometryGroup.__morphTargetsArrays,
		morphNormalsArrays = geometryGroup.__morphNormalsArrays,

		customAttributes = geometryGroup.__webglCustomAttributesList,
		customAttribute,

		faceArray = geometryGroup.__faceArray,
		lineArray = geometryGroup.__lineArray,

		geometry = object.webglgeometry, // this is shared for all chunks

		dirtyVertices = geometry.verticesNeedUpdate,
		dirtyElements = geometry.elementsNeedUpdate,
		dirtyUvs = geometry.uvsNeedUpdate,
		dirtyNormals = geometry.normalsNeedUpdate,
		dirtyTangents = geometry.tangentsNeedUpdate,
		dirtyColors = geometry.colorsNeedUpdate,
		dirtyMorphTargets = geometry.morphTargetsNeedUpdate,

		vertices = geometry.vertices,
		chunk_faces3 = geometryGroup.faces3,
		chunk_faces4 = geometryGroup.faces4,
		obj_faces = geometry.faces,

		obj_uvs  = (geometry.faceVertexUvs.length == 0) ? [] : geometry.faceVertexUvs[ 0 ],
		obj_uvs2 = (geometry.faceVertexUvs.length > 1) ? geometry.faceVertexUvs[ 1 ] : null,

		obj_colors = geometry.colors,

		obj_skinVerticesA = geometry.skinVerticesA,
		obj_skinVerticesB = geometry.skinVerticesB,
		obj_skinIndices = geometry.skinIndices,
		obj_skinWeights = geometry.skinWeights,

		morphTargets = geometry.morphTargets,
		morphNormals = geometry.morphNormals;


		if ( dirtyVertices ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces3[ f ] ];

				v1 = vertices[ face.a ];
				v2 = vertices[ face.b ];
				v3 = vertices[ face.c ];

				vertexArray[ offset ]     = v1.x;
				vertexArray[ offset + 1 ] = v1.y;
				vertexArray[ offset + 2 ] = v1.z;

				vertexArray[ offset + 3 ] = v2.x;
				vertexArray[ offset + 4 ] = v2.y;
				vertexArray[ offset + 5 ] = v2.z;

				vertexArray[ offset + 6 ] = v3.x;
				vertexArray[ offset + 7 ] = v3.y;
				vertexArray[ offset + 8 ] = v3.z;

				offset += 9;

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces4[ f ] ];

				v1 = vertices[ face.a ];
				v2 = vertices[ face.b ];
				v3 = vertices[ face.c ];
				v4 = vertices[ face.d ];

				vertexArray[ offset ]     = v1.x;
				vertexArray[ offset + 1 ] = v1.y;
				vertexArray[ offset + 2 ] = v1.z;

				vertexArray[ offset + 3 ] = v2.x;
				vertexArray[ offset + 4 ] = v2.y;
				vertexArray[ offset + 5 ] = v2.z;

				vertexArray[ offset + 6 ] = v3.x;
				vertexArray[ offset + 7 ] = v3.y;
				vertexArray[ offset + 8 ] = v3.z;

				vertexArray[ offset + 9 ]  = v4.x;
				vertexArray[ offset + 10 ] = v4.y;
				vertexArray[ offset + 11 ] = v4.z;

				offset += 12;

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, vertexArray, hint );

		}

		if ( dirtyMorphTargets ) {

			vkl = morphTargets.length;
			for ( vk = 0; vk < vkl; vk ++ ) {

				offset_morphTarget = 0;

				fl = chunk_faces3.length;
				for ( f = 0; f < fl; f ++ ) {

					chf = chunk_faces3[ f ];
					face = obj_faces[ chf ];

					// morph positions

					v1 = morphTargets[ vk ].vertices[ face.a ];
					v2 = morphTargets[ vk ].vertices[ face.b ];
					v3 = morphTargets[ vk ].vertices[ face.c ];

					vka = morphTargetsArrays[ vk ];

					vka[ offset_morphTarget ] 	  = v1.x;
					vka[ offset_morphTarget + 1 ] = v1.y;
					vka[ offset_morphTarget + 2 ] = v1.z;

					vka[ offset_morphTarget + 3 ] = v2.x;
					vka[ offset_morphTarget + 4 ] = v2.y;
					vka[ offset_morphTarget + 5 ] = v2.z;

					vka[ offset_morphTarget + 6 ] = v3.x;
					vka[ offset_morphTarget + 7 ] = v3.y;
					vka[ offset_morphTarget + 8 ] = v3.z;

					// morph normals

					if ( material.morphNormals ) {

						if ( needsSmoothNormals ) {

							faceVertexNormals = morphNormals[ vk ].vertexNormals[ chf ];

							n1 = faceVertexNormals.a;
							n2 = faceVertexNormals.b;
							n3 = faceVertexNormals.c;

						} else {

							n1 = morphNormals[ vk ].faceNormals[ chf ];
							n2 = n1;
							n3 = n1;

						}

						nka = morphNormalsArrays[ vk ];

						nka[ offset_morphTarget ] 	  = n1.x;
						nka[ offset_morphTarget + 1 ] = n1.y;
						nka[ offset_morphTarget + 2 ] = n1.z;

						nka[ offset_morphTarget + 3 ] = n2.x;
						nka[ offset_morphTarget + 4 ] = n2.y;
						nka[ offset_morphTarget + 5 ] = n2.z;

						nka[ offset_morphTarget + 6 ] = n3.x;
						nka[ offset_morphTarget + 7 ] = n3.y;
						nka[ offset_morphTarget + 8 ] = n3.z;

					}

					//

					offset_morphTarget += 9;

				}

				fl = chunk_faces4.length;
				for ( f = 0; f < fl; f ++ ) {

					chf = chunk_faces4[ f ];
					face = obj_faces[ chf ];

					// morph positions

					v1 = morphTargets[ vk ].vertices[ face.a ];
					v2 = morphTargets[ vk ].vertices[ face.b ];
					v3 = morphTargets[ vk ].vertices[ face.c ];
					v4 = morphTargets[ vk ].vertices[ face.d ];

					vka = morphTargetsArrays[ vk ];

					vka[ offset_morphTarget ] 	  = v1.x;
					vka[ offset_morphTarget + 1 ] = v1.y;
					vka[ offset_morphTarget + 2 ] = v1.z;

					vka[ offset_morphTarget + 3 ] = v2.x;
					vka[ offset_morphTarget + 4 ] = v2.y;
					vka[ offset_morphTarget + 5 ] = v2.z;

					vka[ offset_morphTarget + 6 ] = v3.x;
					vka[ offset_morphTarget + 7 ] = v3.y;
					vka[ offset_morphTarget + 8 ] = v3.z;

					vka[ offset_morphTarget + 9 ]  = v4.x;
					vka[ offset_morphTarget + 10 ] = v4.y;
					vka[ offset_morphTarget + 11 ] = v4.z;

					// morph normals

					if ( material.morphNormals ) {

						if ( needsSmoothNormals ) {

							faceVertexNormals = morphNormals[ vk ].vertexNormals[ chf ];

							n1 = faceVertexNormals.a;
							n2 = faceVertexNormals.b;
							n3 = faceVertexNormals.c;
							n4 = faceVertexNormals.d;

						} else {

							n1 = morphNormals[ vk ].faceNormals[ chf ];
							n2 = n1;
							n3 = n1;
							n4 = n1;

						}

						nka = morphNormalsArrays[ vk ];

						nka[ offset_morphTarget ] 	  = n1.x;
						nka[ offset_morphTarget + 1 ] = n1.y;
						nka[ offset_morphTarget + 2 ] = n1.z;

						nka[ offset_morphTarget + 3 ] = n2.x;
						nka[ offset_morphTarget + 4 ] = n2.y;
						nka[ offset_morphTarget + 5 ] = n2.z;

						nka[ offset_morphTarget + 6 ] = n3.x;
						nka[ offset_morphTarget + 7 ] = n3.y;
						nka[ offset_morphTarget + 8 ] = n3.z;

						nka[ offset_morphTarget + 9 ]  = n4.x;
						nka[ offset_morphTarget + 10 ] = n4.y;
						nka[ offset_morphTarget + 11 ] = n4.z;

					}

					//

					offset_morphTarget += 12;

				}

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[ vk ] );
				_gl.bufferData( gl.ARRAY_BUFFER, morphTargetsArrays[ vk ], hint );

				if ( material.morphNormals ) {

					_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[ vk ] );
					_gl.bufferData( gl.ARRAY_BUFFER, morphNormalsArrays[ vk ], hint );

				}

			}

		}

		if ( !obj_skinWeights.isEmpty) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces3[ f ]	];

				// weights

				sw1 = obj_skinWeights[ face.a ];
				sw2 = obj_skinWeights[ face.b ];
				sw3 = obj_skinWeights[ face.c ];

				skinWeightArray[ offset_skin ]     = sw1.x;
				skinWeightArray[ offset_skin + 1 ] = sw1.y;
				skinWeightArray[ offset_skin + 2 ] = sw1.z;
				skinWeightArray[ offset_skin + 3 ] = sw1.w;

				skinWeightArray[ offset_skin + 4 ] = sw2.x;
				skinWeightArray[ offset_skin + 5 ] = sw2.y;
				skinWeightArray[ offset_skin + 6 ] = sw2.z;
				skinWeightArray[ offset_skin + 7 ] = sw2.w;

				skinWeightArray[ offset_skin + 8 ]  = sw3.x;
				skinWeightArray[ offset_skin + 9 ]  = sw3.y;
				skinWeightArray[ offset_skin + 10 ] = sw3.z;
				skinWeightArray[ offset_skin + 11 ] = sw3.w;

				// indices

				si1 = obj_skinIndices[ face.a ];
				si2 = obj_skinIndices[ face.b ];
				si3 = obj_skinIndices[ face.c ];

				skinIndexArray[ offset_skin ]     = si1.x;
				skinIndexArray[ offset_skin + 1 ] = si1.y;
				skinIndexArray[ offset_skin + 2 ] = si1.z;
				skinIndexArray[ offset_skin + 3 ] = si1.w;

				skinIndexArray[ offset_skin + 4 ] = si2.x;
				skinIndexArray[ offset_skin + 5 ] = si2.y;
				skinIndexArray[ offset_skin + 6 ] = si2.z;
				skinIndexArray[ offset_skin + 7 ] = si2.w;

				skinIndexArray[ offset_skin + 8 ]  = si3.x;
				skinIndexArray[ offset_skin + 9 ]  = si3.y;
				skinIndexArray[ offset_skin + 10 ] = si3.z;
				skinIndexArray[ offset_skin + 11 ] = si3.w;

				// vertices A

				sa1 = obj_skinVerticesA[ face.a ];
				sa2 = obj_skinVerticesA[ face.b ];
				sa3 = obj_skinVerticesA[ face.c ];

				skinVertexAArray[ offset_skin ]     = sa1.x;
				skinVertexAArray[ offset_skin + 1 ] = sa1.y;
				skinVertexAArray[ offset_skin + 2 ] = sa1.z;
				skinVertexAArray[ offset_skin + 3 ] = 1; // pad for faster vertex shader

				skinVertexAArray[ offset_skin + 4 ] = sa2.x;
				skinVertexAArray[ offset_skin + 5 ] = sa2.y;
				skinVertexAArray[ offset_skin + 6 ] = sa2.z;
				skinVertexAArray[ offset_skin + 7 ] = 1;

				skinVertexAArray[ offset_skin + 8 ]  = sa3.x;
				skinVertexAArray[ offset_skin + 9 ]  = sa3.y;
				skinVertexAArray[ offset_skin + 10 ] = sa3.z;
				skinVertexAArray[ offset_skin + 11 ] = 1;

				// vertices B

				sb1 = obj_skinVerticesB[ face.a ];
				sb2 = obj_skinVerticesB[ face.b ];
				sb3 = obj_skinVerticesB[ face.c ];

				skinVertexBArray[ offset_skin ]     = sb1.x;
				skinVertexBArray[ offset_skin + 1 ] = sb1.y;
				skinVertexBArray[ offset_skin + 2 ] = sb1.z;
				skinVertexBArray[ offset_skin + 3 ] = 1; // pad for faster vertex shader

				skinVertexBArray[ offset_skin + 4 ] = sb2.x;
				skinVertexBArray[ offset_skin + 5 ] = sb2.y;
				skinVertexBArray[ offset_skin + 6 ] = sb2.z;
				skinVertexBArray[ offset_skin + 7 ] = 1;

				skinVertexBArray[ offset_skin + 8 ]  = sb3.x;
				skinVertexBArray[ offset_skin + 9 ]  = sb3.y;
				skinVertexBArray[ offset_skin + 10 ] = sb3.z;
				skinVertexBArray[ offset_skin + 11 ] = 1;

				offset_skin += 12;

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces4[ f ] ];

				// weights

				sw1 = obj_skinWeights[ face.a ];
				sw2 = obj_skinWeights[ face.b ];
				sw3 = obj_skinWeights[ face.c ];
				sw4 = obj_skinWeights[ face.d ];

				skinWeightArray[ offset_skin ]     = sw1.x;
				skinWeightArray[ offset_skin + 1 ] = sw1.y;
				skinWeightArray[ offset_skin + 2 ] = sw1.z;
				skinWeightArray[ offset_skin + 3 ] = sw1.w;

				skinWeightArray[ offset_skin + 4 ] = sw2.x;
				skinWeightArray[ offset_skin + 5 ] = sw2.y;
				skinWeightArray[ offset_skin + 6 ] = sw2.z;
				skinWeightArray[ offset_skin + 7 ] = sw2.w;

				skinWeightArray[ offset_skin + 8 ]  = sw3.x;
				skinWeightArray[ offset_skin + 9 ]  = sw3.y;
				skinWeightArray[ offset_skin + 10 ] = sw3.z;
				skinWeightArray[ offset_skin + 11 ] = sw3.w;

				skinWeightArray[ offset_skin + 12 ] = sw4.x;
				skinWeightArray[ offset_skin + 13 ] = sw4.y;
				skinWeightArray[ offset_skin + 14 ] = sw4.z;
				skinWeightArray[ offset_skin + 15 ] = sw4.w;

				// indices

				si1 = obj_skinIndices[ face.a ];
				si2 = obj_skinIndices[ face.b ];
				si3 = obj_skinIndices[ face.c ];
				si4 = obj_skinIndices[ face.d ];

				skinIndexArray[ offset_skin ]     = si1.x;
				skinIndexArray[ offset_skin + 1 ] = si1.y;
				skinIndexArray[ offset_skin + 2 ] = si1.z;
				skinIndexArray[ offset_skin + 3 ] = si1.w;

				skinIndexArray[ offset_skin + 4 ] = si2.x;
				skinIndexArray[ offset_skin + 5 ] = si2.y;
				skinIndexArray[ offset_skin + 6 ] = si2.z;
				skinIndexArray[ offset_skin + 7 ] = si2.w;

				skinIndexArray[ offset_skin + 8 ]  = si3.x;
				skinIndexArray[ offset_skin + 9 ]  = si3.y;
				skinIndexArray[ offset_skin + 10 ] = si3.z;
				skinIndexArray[ offset_skin + 11 ] = si3.w;

				skinIndexArray[ offset_skin + 12 ] = si4.x;
				skinIndexArray[ offset_skin + 13 ] = si4.y;
				skinIndexArray[ offset_skin + 14 ] = si4.z;
				skinIndexArray[ offset_skin + 15 ] = si4.w;

				// vertices A

				sa1 = obj_skinVerticesA[ face.a ];
				sa2 = obj_skinVerticesA[ face.b ];
				sa3 = obj_skinVerticesA[ face.c ];
				sa4 = obj_skinVerticesA[ face.d ];

				skinVertexAArray[ offset_skin ]     = sa1.x;
				skinVertexAArray[ offset_skin + 1 ] = sa1.y;
				skinVertexAArray[ offset_skin + 2 ] = sa1.z;
				skinVertexAArray[ offset_skin + 3 ] = 1; // pad for faster vertex shader

				skinVertexAArray[ offset_skin + 4 ] = sa2.x;
				skinVertexAArray[ offset_skin + 5 ] = sa2.y;
				skinVertexAArray[ offset_skin + 6 ] = sa2.z;
				skinVertexAArray[ offset_skin + 7 ] = 1;

				skinVertexAArray[ offset_skin + 8 ]  = sa3.x;
				skinVertexAArray[ offset_skin + 9 ]  = sa3.y;
				skinVertexAArray[ offset_skin + 10 ] = sa3.z;
				skinVertexAArray[ offset_skin + 11 ] = 1;

				skinVertexAArray[ offset_skin + 12 ] = sa4.x;
				skinVertexAArray[ offset_skin + 13 ] = sa4.y;
				skinVertexAArray[ offset_skin + 14 ] = sa4.z;
				skinVertexAArray[ offset_skin + 15 ] = 1;

				// vertices B

				sb1 = obj_skinVerticesB[ face.a ];
				sb2 = obj_skinVerticesB[ face.b ];
				sb3 = obj_skinVerticesB[ face.c ];
				sb4 = obj_skinVerticesB[ face.d ];

				skinVertexBArray[ offset_skin ]     = sb1.x;
				skinVertexBArray[ offset_skin + 1 ] = sb1.y;
				skinVertexBArray[ offset_skin + 2 ] = sb1.z;
				skinVertexBArray[ offset_skin + 3 ] = 1; // pad for faster vertex shader

				skinVertexBArray[ offset_skin + 4 ] = sb2.x;
				skinVertexBArray[ offset_skin + 5 ] = sb2.y;
				skinVertexBArray[ offset_skin + 6 ] = sb2.z;
				skinVertexBArray[ offset_skin + 7 ] = 1;

				skinVertexBArray[ offset_skin + 8 ]  = sb3.x;
				skinVertexBArray[ offset_skin + 9 ]  = sb3.y;
				skinVertexBArray[ offset_skin + 10 ] = sb3.z;
				skinVertexBArray[ offset_skin + 11 ] = 1;

				skinVertexBArray[ offset_skin + 12 ] = sb4.x;
				skinVertexBArray[ offset_skin + 13 ] = sb4.y;
				skinVertexBArray[ offset_skin + 14 ] = sb4.z;
				skinVertexBArray[ offset_skin + 15 ] = 1;

				offset_skin += 16;

			}

			if ( offset_skin > 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexABuffer );
				_gl.bufferData( gl.ARRAY_BUFFER, skinVertexAArray, hint );

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexBBuffer );
				_gl.bufferData( gl.ARRAY_BUFFER, skinVertexBArray, hint );

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer );
				_gl.bufferData( gl.ARRAY_BUFFER, skinIndexArray, hint );

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer );
				_gl.bufferData( gl.ARRAY_BUFFER, skinWeightArray, hint );

			}

		}

		if ( dirtyColors && vertexColorType ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces3[ f ]	];

				vertexColors = face.vertexColors;
				faceColor = face.color;

				if ( vertexColors.length == 3 && vertexColorType == VertexColors ) {

					c1 = vertexColors[ 0 ];
					c2 = vertexColors[ 1 ];
					c3 = vertexColors[ 2 ];

				} else {

					c1 = faceColor;
					c2 = faceColor;
					c3 = faceColor;

				}

				colorArray[ offset_color ]     = c1.r;
				colorArray[ offset_color + 1 ] = c1.g;
				colorArray[ offset_color + 2 ] = c1.b;

				colorArray[ offset_color + 3 ] = c2.r;
				colorArray[ offset_color + 4 ] = c2.g;
				colorArray[ offset_color + 5 ] = c2.b;

				colorArray[ offset_color + 6 ] = c3.r;
				colorArray[ offset_color + 7 ] = c3.g;
				colorArray[ offset_color + 8 ] = c3.b;

				offset_color += 9;

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces4[ f ] ];

				vertexColors = face.vertexColors;
				faceColor = face.color;

				if ( vertexColors.length == 4 && vertexColorType == VertexColors ) {

					c1 = vertexColors[ 0 ];
					c2 = vertexColors[ 1 ];
					c3 = vertexColors[ 2 ];
					c4 = vertexColors[ 3 ];

				} else {

					c1 = faceColor;
					c2 = faceColor;
					c3 = faceColor;
					c4 = faceColor;

				}

				colorArray[ offset_color ]     = c1.r;
				colorArray[ offset_color + 1 ] = c1.g;
				colorArray[ offset_color + 2 ] = c1.b;

				colorArray[ offset_color + 3 ] = c2.r;
				colorArray[ offset_color + 4 ] = c2.g;
				colorArray[ offset_color + 5 ] = c2.b;

				colorArray[ offset_color + 6 ] = c3.r;
				colorArray[ offset_color + 7 ] = c3.g;
				colorArray[ offset_color + 8 ] = c3.b;

				colorArray[ offset_color + 9 ]  = c4.r;
				colorArray[ offset_color + 10 ] = c4.g;
				colorArray[ offset_color + 11 ] = c4.b;

				offset_color += 12;

			}

			if ( offset_color > 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglColorBuffer );
				_gl.bufferData( gl.ARRAY_BUFFER, colorArray, hint );

			}

		}

		if ( dirtyTangents && geometry.hasTangents ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces3[ f ]	];

				vertexTangents = face.vertexTangents;

				t1 = vertexTangents[ 0 ];
				t2 = vertexTangents[ 1 ];
				t3 = vertexTangents[ 2 ];

				tangentArray[ offset_tangent ]     = t1.x;
				tangentArray[ offset_tangent + 1 ] = t1.y;
				tangentArray[ offset_tangent + 2 ] = t1.z;
				tangentArray[ offset_tangent + 3 ] = t1.w;

				tangentArray[ offset_tangent + 4 ] = t2.x;
				tangentArray[ offset_tangent + 5 ] = t2.y;
				tangentArray[ offset_tangent + 6 ] = t2.z;
				tangentArray[ offset_tangent + 7 ] = t2.w;

				tangentArray[ offset_tangent + 8 ]  = t3.x;
				tangentArray[ offset_tangent + 9 ]  = t3.y;
				tangentArray[ offset_tangent + 10 ] = t3.z;
				tangentArray[ offset_tangent + 11 ] = t3.w;

				offset_tangent += 12;

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces4[ f ] ];

				vertexTangents = face.vertexTangents;

				t1 = vertexTangents[ 0 ];
				t2 = vertexTangents[ 1 ];
				t3 = vertexTangents[ 2 ];
				t4 = vertexTangents[ 3 ];

				tangentArray[ offset_tangent ]     = t1.x;
				tangentArray[ offset_tangent + 1 ] = t1.y;
				tangentArray[ offset_tangent + 2 ] = t1.z;
				tangentArray[ offset_tangent + 3 ] = t1.w;

				tangentArray[ offset_tangent + 4 ] = t2.x;
				tangentArray[ offset_tangent + 5 ] = t2.y;
				tangentArray[ offset_tangent + 6 ] = t2.z;
				tangentArray[ offset_tangent + 7 ] = t2.w;

				tangentArray[ offset_tangent + 8 ]  = t3.x;
				tangentArray[ offset_tangent + 9 ]  = t3.y;
				tangentArray[ offset_tangent + 10 ] = t3.z;
				tangentArray[ offset_tangent + 11 ] = t3.w;

				tangentArray[ offset_tangent + 12 ] = t4.x;
				tangentArray[ offset_tangent + 13 ] = t4.y;
				tangentArray[ offset_tangent + 14 ] = t4.z;
				tangentArray[ offset_tangent + 15 ] = t4.w;

				offset_tangent += 16;

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, tangentArray, hint );

		}

		if ( dirtyNormals && (normalType != NoShading) ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces3[ f ]	];

				vertexNormals = face.vertexNormals;
				faceNormal = face.normal;

				if ( vertexNormals.length == 3 && needsSmoothNormals ) {

					for ( i = 0; i < 3; i ++ ) {

						vn = vertexNormals[ i ];

						normalArray[ offset_normal ]     = vn.x;
						normalArray[ offset_normal + 1 ] = vn.y;
						normalArray[ offset_normal + 2 ] = vn.z;

						offset_normal += 3;

					}

				} else {

					for ( i = 0; i < 3; i ++ ) {

						normalArray[ offset_normal ]     = faceNormal.x;
						normalArray[ offset_normal + 1 ] = faceNormal.y;
						normalArray[ offset_normal + 2 ] = faceNormal.z;

						offset_normal += 3;

					}

				}

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces4[ f ] ];

				vertexNormals = face.vertexNormals;
				faceNormal = face.normal;

				if ( vertexNormals.length == 4 && needsSmoothNormals ) {

					for ( i = 0; i < 4; i ++ ) {

						vn = vertexNormals[ i ];

						normalArray[ offset_normal ]     = vn.x;
						normalArray[ offset_normal + 1 ] = vn.y;
						normalArray[ offset_normal + 2 ] = vn.z;

						offset_normal += 3;

					}

				} else {

					for ( i = 0; i < 4; i ++ ) {

						normalArray[ offset_normal ]     = faceNormal.x;
						normalArray[ offset_normal + 1 ] = faceNormal.y;
						normalArray[ offset_normal + 2 ] = faceNormal.z;

						offset_normal += 3;

					}

				}

			}

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer );
			_gl.bufferData( gl.ARRAY_BUFFER, normalArray, hint );

		}

		if ( dirtyUvs && !obj_uvs.isEmpty && uvType ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				fi = chunk_faces3[ f ];

				face = obj_faces[ fi ];
				uv = obj_uvs[ fi ];

				if ( uv == null ) continue;

				for ( i = 0; i < 3; i ++ ) {

					uvi = uv[ i ];

					uvArray[ offset_uv ]     = uvi.u;
					uvArray[ offset_uv + 1 ] = uvi.v;

					offset_uv += 2;

				}

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				fi = chunk_faces4[ f ];

				face = obj_faces[ fi ];
				uv = obj_uvs[ fi ];

				if ( uv == null ) continue;

				for ( i = 0; i < 4; i ++ ) {

					uvi = uv[ i ];

					uvArray[ offset_uv ]     = uvi.u;
					uvArray[ offset_uv + 1 ] = uvi.v;

					offset_uv += 2;

				}

			}

			if ( offset_uv > 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglUVBuffer );
				_gl.bufferData( gl.ARRAY_BUFFER, uvArray, hint );

			}

		}

		if ( dirtyUvs && (obj_uvs2 != null) && uvType ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				fi = chunk_faces3[ f ];

				face = obj_faces[ fi ];
				uv2 = obj_uvs2[ fi ];

				if ( uv2 == null ) continue;

				for ( i = 0; i < 3; i ++ ) {

					uv2i = uv2[ i ];

					uv2Array[ offset_uv2 ]     = uv2i.u;
					uv2Array[ offset_uv2 + 1 ] = uv2i.v;

					offset_uv2 += 2;

				}

			}

			fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				fi = chunk_faces4[ f ];

				face = obj_faces[ fi ];
				uv2 = obj_uvs2[ fi ];

				if ( uv2 == null ) continue;

				for ( i = 0; i < 4; i ++ ) {

					uv2i = uv2[ i ];

					uv2Array[ offset_uv2 ]     = uv2i.u;
					uv2Array[ offset_uv2 + 1 ] = uv2i.v;

					offset_uv2 += 2;

				}

			}

			if ( offset_uv2 > 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer );
				_gl.bufferData( gl.ARRAY_BUFFER, uv2Array, hint );

			}

		}

		if ( dirtyElements ) {

			fl = chunk_faces3.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces3[ f ]	];

				faceArray[ offset_face ] 	 = vertexIndex;
				faceArray[ offset_face + 1 ] = vertexIndex + 1;
				faceArray[ offset_face + 2 ] = vertexIndex + 2;

				offset_face += 3;

				lineArray[ offset_line ]     = vertexIndex;
				lineArray[ offset_line + 1 ] = vertexIndex + 1;

				lineArray[ offset_line + 2 ] = vertexIndex;
				lineArray[ offset_line + 3 ] = vertexIndex + 2;

				lineArray[ offset_line + 4 ] = vertexIndex + 1;
				lineArray[ offset_line + 5 ] = vertexIndex + 2;

				offset_line += 6;

				vertexIndex += 3;

			}

			 fl = chunk_faces4.length;
			for ( f = 0; f < fl; f ++ ) {

				face = obj_faces[ chunk_faces4[ f ] ];

				faceArray[ offset_face ]     = vertexIndex;
				faceArray[ offset_face + 1 ] = vertexIndex + 1;
				faceArray[ offset_face + 2 ] = vertexIndex + 3;

				faceArray[ offset_face + 3 ] = vertexIndex + 1;
				faceArray[ offset_face + 4 ] = vertexIndex + 2;
				faceArray[ offset_face + 5 ] = vertexIndex + 3;

				offset_face += 6;

				lineArray[ offset_line ]     = vertexIndex;
				lineArray[ offset_line + 1 ] = vertexIndex + 1;

				lineArray[ offset_line + 2 ] = vertexIndex;
				lineArray[ offset_line + 3 ] = vertexIndex + 3;

				lineArray[ offset_line + 4 ] = vertexIndex + 1;
				lineArray[ offset_line + 5 ] = vertexIndex + 2;

				lineArray[ offset_line + 6 ] = vertexIndex + 2;
				lineArray[ offset_line + 7 ] = vertexIndex + 3;

				offset_line += 8;

				vertexIndex += 4;

			}

			_gl.bindBuffer( gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer );
			_gl.bufferData( gl.ELEMENT_ARRAY_BUFFER, faceArray, hint );

			_gl.bindBuffer( gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer );
			_gl.bufferData( gl.ELEMENT_ARRAY_BUFFER, lineArray, hint );

		}

		if ( customAttributes != null) {

			il = customAttributes.length;
			for ( i = 0; i < il; i ++ ) {

				customAttribute = customAttributes[ i ];

				if ( ! customAttribute.__original.needsUpdate ) continue;

				offset_custom = 0;
				offset_customSrc = 0;

				if ( customAttribute.size == 1 ) {

					if ( customAttribute.boundTo == null || customAttribute.boundTo == "vertices" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces3[ f ]	];

							customAttribute.array[ offset_custom ] 	   = customAttribute.value[ face.a ];
							customAttribute.array[ offset_custom + 1 ] = customAttribute.value[ face.b ];
							customAttribute.array[ offset_custom + 2 ] = customAttribute.value[ face.c ];

							offset_custom += 3;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces4[ f ] ];

							customAttribute.array[ offset_custom ] 	   = customAttribute.value[ face.a ];
							customAttribute.array[ offset_custom + 1 ] = customAttribute.value[ face.b ];
							customAttribute.array[ offset_custom + 2 ] = customAttribute.value[ face.c ];
							customAttribute.array[ offset_custom + 3 ] = customAttribute.value[ face.d ];

							offset_custom += 4;

						}

					} else if ( customAttribute.boundTo == "faces" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces3[ f ] ];

							customAttribute.array[ offset_custom ] 	   = value;
							customAttribute.array[ offset_custom + 1 ] = value;
							customAttribute.array[ offset_custom + 2 ] = value;

							offset_custom += 3;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces4[ f ] ];

							customAttribute.array[ offset_custom ] 	   = value;
							customAttribute.array[ offset_custom + 1 ] = value;
							customAttribute.array[ offset_custom + 2 ] = value;
							customAttribute.array[ offset_custom + 3 ] = value;

							offset_custom += 4;

						}

					}

				} else if ( customAttribute.size == 2 ) {

					if ( customAttribute.boundTo == null || customAttribute.boundTo == "vertices" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces3[ f ]	];

							v1 = customAttribute.value[ face.a ];
							v2 = customAttribute.value[ face.b ];
							v3 = customAttribute.value[ face.c ];

							customAttribute.array[ offset_custom ] 	   = v1.x;
							customAttribute.array[ offset_custom + 1 ] = v1.y;

							customAttribute.array[ offset_custom + 2 ] = v2.x;
							customAttribute.array[ offset_custom + 3 ] = v2.y;

							customAttribute.array[ offset_custom + 4 ] = v3.x;
							customAttribute.array[ offset_custom + 5 ] = v3.y;

							offset_custom += 6;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces4[ f ] ];

							v1 = customAttribute.value[ face.a ];
							v2 = customAttribute.value[ face.b ];
							v3 = customAttribute.value[ face.c ];
							v4 = customAttribute.value[ face.d ];

							customAttribute.array[ offset_custom ] 	   = v1.x;
							customAttribute.array[ offset_custom + 1 ] = v1.y;

							customAttribute.array[ offset_custom + 2 ] = v2.x;
							customAttribute.array[ offset_custom + 3 ] = v2.y;

							customAttribute.array[ offset_custom + 4 ] = v3.x;
							customAttribute.array[ offset_custom + 5 ] = v3.y;

							customAttribute.array[ offset_custom + 6 ] = v4.x;
							customAttribute.array[ offset_custom + 7 ] = v4.y;

							offset_custom += 8;

						}

					} else if ( customAttribute.boundTo == "faces" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces3[ f ] ];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttribute.array[ offset_custom ] 	   = v1.x;
							customAttribute.array[ offset_custom + 1 ] = v1.y;

							customAttribute.array[ offset_custom + 2 ] = v2.x;
							customAttribute.array[ offset_custom + 3 ] = v2.y;

							customAttribute.array[ offset_custom + 4 ] = v3.x;
							customAttribute.array[ offset_custom + 5 ] = v3.y;

							offset_custom += 6;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces4[ f ] ];

							v1 = value;
							v2 = value;
							v3 = value;
							v4 = value;

							customAttribute.array[ offset_custom ] 	   = v1.x;
							customAttribute.array[ offset_custom + 1 ] = v1.y;

							customAttribute.array[ offset_custom + 2 ] = v2.x;
							customAttribute.array[ offset_custom + 3 ] = v2.y;

							customAttribute.array[ offset_custom + 4 ] = v3.x;
							customAttribute.array[ offset_custom + 5 ] = v3.y;

							customAttribute.array[ offset_custom + 6 ] = v4.x;
							customAttribute.array[ offset_custom + 7 ] = v4.y;

							offset_custom += 8;

						}

					}

				} else if ( customAttribute.size == 3 ) {

					var pp;

					if ( customAttribute.type == "c" ) {

						pp = [ "r", "g", "b" ];

					} else {

						pp = [ "x", "y", "z" ];

					}

					if ( customAttribute.boundTo == null || customAttribute.boundTo == "vertices" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces3[ f ]	];

							v1 = customAttribute.value[ face.a ];
							v2 = customAttribute.value[ face.b ];
							v3 = customAttribute.value[ face.c ];

							customAttribute.array[ offset_custom ] 	   = v1[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 1 ] = v1[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 2 ] = v1[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 3 ] = v2[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 4 ] = v2[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 5 ] = v2[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 6 ] = v3[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 7 ] = v3[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 8 ] = v3[ pp[ 2 ] ];

							offset_custom += 9;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces4[ f ] ];

							v1 = customAttribute.value[ face.a ];
							v2 = customAttribute.value[ face.b ];
							v3 = customAttribute.value[ face.c ];
							v4 = customAttribute.value[ face.d ];

							customAttribute.array[ offset_custom  ] 	= v1[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 1  ] = v1[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 2  ] = v1[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 3  ] = v2[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 4  ] = v2[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 5  ] = v2[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 6  ] = v3[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 7  ] = v3[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 8  ] = v3[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 9  ] = v4[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 10 ] = v4[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 11 ] = v4[ pp[ 2 ] ];

							offset_custom += 12;

						}

					} else if ( customAttribute.boundTo == "faces" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces3[ f ] ];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttribute.array[ offset_custom ] 	   = v1[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 1 ] = v1[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 2 ] = v1[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 3 ] = v2[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 4 ] = v2[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 5 ] = v2[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 6 ] = v3[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 7 ] = v3[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 8 ] = v3[ pp[ 2 ] ];

							offset_custom += 9;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces4[ f ] ];

							v1 = value;
							v2 = value;
							v3 = value;
							v4 = value;

							customAttribute.array[ offset_custom  ] 	= v1[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 1  ] = v1[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 2  ] = v1[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 3  ] = v2[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 4  ] = v2[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 5  ] = v2[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 6  ] = v3[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 7  ] = v3[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 8  ] = v3[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 9  ] = v4[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 10 ] = v4[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 11 ] = v4[ pp[ 2 ] ];

							offset_custom += 12;

						}

					} else if ( customAttribute.boundTo == "faceVertices" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces3[ f ] ];

							v1 = value[ 0 ];
							v2 = value[ 1 ];
							v3 = value[ 2 ];

							customAttribute.array[ offset_custom ] 	   = v1[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 1 ] = v1[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 2 ] = v1[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 3 ] = v2[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 4 ] = v2[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 5 ] = v2[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 6 ] = v3[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 7 ] = v3[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 8 ] = v3[ pp[ 2 ] ];

							offset_custom += 9;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces4[ f ] ];

							v1 = value[ 0 ];
							v2 = value[ 1 ];
							v3 = value[ 2 ];
							v4 = value[ 3 ];

							customAttribute.array[ offset_custom  ] 	= v1[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 1  ] = v1[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 2  ] = v1[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 3  ] = v2[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 4  ] = v2[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 5  ] = v2[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 6  ] = v3[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 7  ] = v3[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 8  ] = v3[ pp[ 2 ] ];

							customAttribute.array[ offset_custom + 9  ] = v4[ pp[ 0 ] ];
							customAttribute.array[ offset_custom + 10 ] = v4[ pp[ 1 ] ];
							customAttribute.array[ offset_custom + 11 ] = v4[ pp[ 2 ] ];

							offset_custom += 12;

						}

					}

				} else if ( customAttribute.size == 4 ) {

					if ( customAttribute.boundTo == null || customAttribute.boundTo == "vertices" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces3[ f ]	];

							v1 = customAttribute.value[ face.a ];
							v2 = customAttribute.value[ face.b ];
							v3 = customAttribute.value[ face.c ];

							customAttribute.array[ offset_custom  ] 	= v1.x;
							customAttribute.array[ offset_custom + 1  ] = v1.y;
							customAttribute.array[ offset_custom + 2  ] = v1.z;
							customAttribute.array[ offset_custom + 3  ] = v1.w;

							customAttribute.array[ offset_custom + 4  ] = v2.x;
							customAttribute.array[ offset_custom + 5  ] = v2.y;
							customAttribute.array[ offset_custom + 6  ] = v2.z;
							customAttribute.array[ offset_custom + 7  ] = v2.w;

							customAttribute.array[ offset_custom + 8  ] = v3.x;
							customAttribute.array[ offset_custom + 9  ] = v3.y;
							customAttribute.array[ offset_custom + 10 ] = v3.z;
							customAttribute.array[ offset_custom + 11 ] = v3.w;

							offset_custom += 12;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							face = obj_faces[ chunk_faces4[ f ] ];

							v1 = customAttribute.value[ face.a ];
							v2 = customAttribute.value[ face.b ];
							v3 = customAttribute.value[ face.c ];
							v4 = customAttribute.value[ face.d ];

							customAttribute.array[ offset_custom  ] 	= v1.x;
							customAttribute.array[ offset_custom + 1  ] = v1.y;
							customAttribute.array[ offset_custom + 2  ] = v1.z;
							customAttribute.array[ offset_custom + 3  ] = v1.w;

							customAttribute.array[ offset_custom + 4  ] = v2.x;
							customAttribute.array[ offset_custom + 5  ] = v2.y;
							customAttribute.array[ offset_custom + 6  ] = v2.z;
							customAttribute.array[ offset_custom + 7  ] = v2.w;

							customAttribute.array[ offset_custom + 8  ] = v3.x;
							customAttribute.array[ offset_custom + 9  ] = v3.y;
							customAttribute.array[ offset_custom + 10 ] = v3.z;
							customAttribute.array[ offset_custom + 11 ] = v3.w;

							customAttribute.array[ offset_custom + 12 ] = v4.x;
							customAttribute.array[ offset_custom + 13 ] = v4.y;
							customAttribute.array[ offset_custom + 14 ] = v4.z;
							customAttribute.array[ offset_custom + 15 ] = v4.w;

							offset_custom += 16;

						}

					} else if ( customAttribute.boundTo == "faces" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces3[ f ] ];

							v1 = value;
							v2 = value;
							v3 = value;

							customAttribute.array[ offset_custom  ] 	= v1.x;
							customAttribute.array[ offset_custom + 1  ] = v1.y;
							customAttribute.array[ offset_custom + 2  ] = v1.z;
							customAttribute.array[ offset_custom + 3  ] = v1.w;

							customAttribute.array[ offset_custom + 4  ] = v2.x;
							customAttribute.array[ offset_custom + 5  ] = v2.y;
							customAttribute.array[ offset_custom + 6  ] = v2.z;
							customAttribute.array[ offset_custom + 7  ] = v2.w;

							customAttribute.array[ offset_custom + 8  ] = v3.x;
							customAttribute.array[ offset_custom + 9  ] = v3.y;
							customAttribute.array[ offset_custom + 10 ] = v3.z;
							customAttribute.array[ offset_custom + 11 ] = v3.w;

							offset_custom += 12;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces4[ f ] ];

							v1 = value;
							v2 = value;
							v3 = value;
							v4 = value;

							customAttribute.array[ offset_custom  ] 	= v1.x;
							customAttribute.array[ offset_custom + 1  ] = v1.y;
							customAttribute.array[ offset_custom + 2  ] = v1.z;
							customAttribute.array[ offset_custom + 3  ] = v1.w;

							customAttribute.array[ offset_custom + 4  ] = v2.x;
							customAttribute.array[ offset_custom + 5  ] = v2.y;
							customAttribute.array[ offset_custom + 6  ] = v2.z;
							customAttribute.array[ offset_custom + 7  ] = v2.w;

							customAttribute.array[ offset_custom + 8  ] = v3.x;
							customAttribute.array[ offset_custom + 9  ] = v3.y;
							customAttribute.array[ offset_custom + 10 ] = v3.z;
							customAttribute.array[ offset_custom + 11 ] = v3.w;

							customAttribute.array[ offset_custom + 12 ] = v4.x;
							customAttribute.array[ offset_custom + 13 ] = v4.y;
							customAttribute.array[ offset_custom + 14 ] = v4.z;
							customAttribute.array[ offset_custom + 15 ] = v4.w;

							offset_custom += 16;

						}

					} else if ( customAttribute.boundTo == "faceVertices" ) {

						fl = chunk_faces3.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces3[ f ] ];

							v1 = value[ 0 ];
							v2 = value[ 1 ];
							v3 = value[ 2 ];

							customAttribute.array[ offset_custom  ] 	= v1.x;
							customAttribute.array[ offset_custom + 1  ] = v1.y;
							customAttribute.array[ offset_custom + 2  ] = v1.z;
							customAttribute.array[ offset_custom + 3  ] = v1.w;

							customAttribute.array[ offset_custom + 4  ] = v2.x;
							customAttribute.array[ offset_custom + 5  ] = v2.y;
							customAttribute.array[ offset_custom + 6  ] = v2.z;
							customAttribute.array[ offset_custom + 7  ] = v2.w;

							customAttribute.array[ offset_custom + 8  ] = v3.x;
							customAttribute.array[ offset_custom + 9  ] = v3.y;
							customAttribute.array[ offset_custom + 10 ] = v3.z;
							customAttribute.array[ offset_custom + 11 ] = v3.w;

							offset_custom += 12;

						}

						fl = chunk_faces4.length;
						for ( f = 0; f < fl; f ++ ) {

							value = customAttribute.value[ chunk_faces4[ f ] ];

							v1 = value[ 0 ];
							v2 = value[ 1 ];
							v3 = value[ 2 ];
							v4 = value[ 3 ];

							customAttribute.array[ offset_custom  ] 	= v1.x;
							customAttribute.array[ offset_custom + 1  ] = v1.y;
							customAttribute.array[ offset_custom + 2  ] = v1.z;
							customAttribute.array[ offset_custom + 3  ] = v1.w;

							customAttribute.array[ offset_custom + 4  ] = v2.x;
							customAttribute.array[ offset_custom + 5  ] = v2.y;
							customAttribute.array[ offset_custom + 6  ] = v2.z;
							customAttribute.array[ offset_custom + 7  ] = v2.w;

							customAttribute.array[ offset_custom + 8  ] = v3.x;
							customAttribute.array[ offset_custom + 9  ] = v3.y;
							customAttribute.array[ offset_custom + 10 ] = v3.z;
							customAttribute.array[ offset_custom + 11 ] = v3.w;

							customAttribute.array[ offset_custom + 12 ] = v4.x;
							customAttribute.array[ offset_custom + 13 ] = v4.y;
							customAttribute.array[ offset_custom + 14 ] = v4.z;
							customAttribute.array[ offset_custom + 15 ] = v4.w;

							offset_custom += 16;

						}

					}

				}

				_gl.bindBuffer( gl.ARRAY_BUFFER, customAttribute.buffer );
				_gl.bufferData( gl.ARRAY_BUFFER, customAttribute.array, hint );

			}

		}

		if ( dispose ) {

			geometryGroup.__inittedArrays = false; //delete geometryGroup.__inittedArrays"];
			geometryGroup.__colorArray = null; //delete geometryGroup.__colorArray"];
			geometryGroup.__normalArray = null; //delete geometryGroup.__normalArray"];
			geometryGroup.__tangentArray = null; //delete geometryGroup.__tangentArray"];
			geometryGroup.__uvArray = null; //delete geometryGroup.__uvArray"];
			geometryGroup.__uv2Array = null; //delete geometryGroup.__uv2Array"];
			geometryGroup.__faceArray = null; //delete geometryGroup.__faceArray"];
			geometryGroup.__vertexArray = null; //delete geometryGroup.__vertexArray"];
			geometryGroup.__lineArray = null; //delete geometryGroup.__lineArray"];
			geometryGroup.__skinVertexAArray = null; //delete geometryGroup.__skinVertexAArray"];
			geometryGroup.__skinVertexBArray = null; //delete geometryGroup.__skinVertexBArray"];
			geometryGroup.__skinIndexArray = null; //delete geometryGroup.__skinIndexArray"];
			geometryGroup.__skinWeightArray = null; //delete geometryGroup.__skinWeightArray"];

		}

	}

	setDirectBuffers ( geometry, hint, dispose ) {

		var attributes = geometry.attributes;

		var index = attributes[ "index" ];
		var position = attributes[ "position" ];
		var normal = attributes[ "normal" ];
		var uv = attributes[ "uv" ];
		var color = attributes[ "color" ];
		var tangent = attributes[ "tangent" ];

		if ( geometry.elementsNeedUpdate && index != null ) {

			_gl.bindBuffer( gl.ELEMENT_ARRAY_BUFFER, index.buffer );
			_gl.bufferData( gl.ELEMENT_ARRAY_BUFFER, index.array, hint );

		}

		if ( geometry.verticesNeedUpdate && position != null ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, position.buffer );
			_gl.bufferData( gl.ARRAY_BUFFER, position.array, hint );

		}

		if ( geometry.normalsNeedUpdate && normal != null ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, normal.buffer );
			_gl.bufferData( gl.ARRAY_BUFFER, normal.array, hint );

		}

		if ( geometry.uvsNeedUpdate && uv != null ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, uv.buffer );
			_gl.bufferData( gl.ARRAY_BUFFER, uv.array, hint );

		}

		if ( geometry.colorsNeedUpdate && color != null ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, color.buffer );
			_gl.bufferData( gl.ARRAY_BUFFER, color.array, hint );

		}

		if ( geometry.tangentsNeedUpdate && tangent != null ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, tangent.buffer );
			_gl.bufferData( gl.ARRAY_BUFFER, tangent.array, hint );

		}

		if ( dispose ) {

			for ( var i in geometry.attributes ) {

				geometry.attributes[ i ].array = null; //delete geometry.attributes[ i ].array;
			}

		}

	}

	// Buffer rendering

	renderBufferImmediate ( object, program, material ) {

		if ( object.hasPositions && ! object["__webglVertexBuffer"] ) object["__webglVertexBuffer"] = _gl.createBuffer();
		if ( object.hasNormals && ! object["__webglNormalBuffer"] ) object["__webglNormalBuffer"] = _gl.createBuffer();
		if ( object.hasUvs && ! object["__webglUVBuffer"] ) object["__webglUVBuffer"] = _gl.createBuffer();
		if ( object.hasColors && ! object["__webglColorBuffer"] ) object["__webglColorBuffer"] = _gl.createBuffer();

		if ( object.hasPositions ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, object["__webglVertexBuffer"] );
			_gl.bufferData( gl.ARRAY_BUFFER, object.positionArray, gl.DYNAMIC_DRAW );
			_gl.enableVertexAttribArray( program.attributes["position"] );
			_gl.vertexAttribPointer( program.attributes["position"], 3, gl.FLOAT, false, 0, 0 );

		}

		if ( object.hasNormals ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, object["__webglNormalBuffer"] );

			if ( material.shading == FlatShading ) {

				var nx, ny, nz,
					nax, nbx, ncx, nay, nby, ncy, naz, nbz, ncz,
					normalArray,
					i, il = object.count * 3;

				for( i = 0; i < il; i += 9 ) {

					normalArray = object.normalArray;

					nax  = normalArray[ i ];
					nay  = normalArray[ i + 1 ];
					naz  = normalArray[ i + 2 ];

					nbx  = normalArray[ i + 3 ];
					nby  = normalArray[ i + 4 ];
					nbz  = normalArray[ i + 5 ];

					ncx  = normalArray[ i + 6 ];
					ncy  = normalArray[ i + 7 ];
					ncz  = normalArray[ i + 8 ];

					nx = ( nax + nbx + ncx ) / 3;
					ny = ( nay + nby + ncy ) / 3;
					nz = ( naz + nbz + ncz ) / 3;

					normalArray[ i ] 	 = nx;
					normalArray[ i + 1 ] = ny;
					normalArray[ i + 2 ] = nz;

					normalArray[ i + 3 ] = nx;
					normalArray[ i + 4 ] = ny;
					normalArray[ i + 5 ] = nz;

					normalArray[ i + 6 ] = nx;
					normalArray[ i + 7 ] = ny;
					normalArray[ i + 8 ] = nz;

				}

			}

			_gl.bufferData( gl.ARRAY_BUFFER, object.normalArray, gl.DYNAMIC_DRAW );
			_gl.enableVertexAttribArray( program.attributes["normal"] );
			_gl.vertexAttribPointer( program.attributes["normal"], 3, gl.FLOAT, false, 0, 0 );

		}

		if ( object.hasUvs && material.map ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, object["__webglUVBuffer"] );
			_gl.bufferData( gl.ARRAY_BUFFER, object.uvArray, gl.DYNAMIC_DRAW );
			_gl.enableVertexAttribArray( program.attributes["uv"] );
			_gl.vertexAttribPointer( program.attributes["uv"], 2, gl.FLOAT, false, 0, 0 );

		}

		if ( object.hasColors && material.vertexColors != NoColors ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, object["__webglColorBuffer"] );
			_gl.bufferData( gl.ARRAY_BUFFER, object.colorArray, gl.DYNAMIC_DRAW );
			_gl.enableVertexAttribArray( program.attributes["color"] );
			_gl.vertexAttribPointer( program.attributes["color"], 3, gl.FLOAT, false, 0, 0 );

		}

		_gl.drawArrays( gl.TRIANGLES, 0, object.count );

		object.count = 0;

	}

	renderBufferDirect ( camera, lights, fog, material, geometry, object ) {

		if ( material.visible == false ) return;

		var program, attributes, linewidth, primitives, a, attribute;

		program = setProgram( camera, lights, fog, material, object );

		attributes = program.attributes;

		var updateBuffers = false,
			wireframeBit = material.wireframe ? 1 : 0,
			geometryHash = ( geometry.id * 0xffffff ) + ( program.id * 2 ) + wireframeBit;

		if ( geometryHash != _currentGeometryGroupHash ) {

			_currentGeometryGroupHash = geometryHash;
			updateBuffers = true;

		}

		// render mesh

		if ( object is Mesh ) {

			var offsets = geometry.offsets;

			// if there is more than 1 chunk
			// must set attribute pointers to use new offsets for each chunk
			// even if geometry and materials didn't change

			if ( offsets.length > 1 ) updateBuffers = true;

			var il = offsets.length;
			for ( var i = 0; i < il; ++ i ) {

				var startIndex = offsets[ i ].index;

				if ( updateBuffers ) {

					// vertices

					var position = geometry.attributes[ "position" ];
					var positionSize = position.itemSize;

					_gl.bindBuffer( gl.ARRAY_BUFFER, position.buffer );
					_gl.vertexAttribPointer( attributes["position"], positionSize, gl.FLOAT, false, 0, startIndex * positionSize * 4 ); // 4 bytes per Float32

					// normals

					var normal = geometry.attributes[ "normal" ];

					if ( attributes["normal"] >= 0 && normal ) {

						var normalSize = normal.itemSize;

						_gl.bindBuffer( gl.ARRAY_BUFFER, normal.buffer );
						_gl.vertexAttribPointer( attributes["normal"], normalSize, gl.FLOAT, false, 0, startIndex * normalSize * 4 );

					}

					// uvs

					var uv = geometry.attributes[ "uv" ];

					if ( attributes["uv"] >= 0 && uv ) {

						if ( uv.buffer ) {

							var uvSize = uv.itemSize;

							_gl.bindBuffer( gl.ARRAY_BUFFER, uv.buffer );
							_gl.vertexAttribPointer( attributes["uv"], uvSize, gl.FLOAT, false, 0, startIndex * uvSize * 4 );

							_gl.enableVertexAttribArray( attributes["uv"] );

						} else {

							_gl.disableVertexAttribArray( attributes["uv"] );

						}

					}

					// colors

					var color = geometry.attributes[ "color" ];

					if ( attributes["color"] >= 0 && color ) {

						var colorSize = color.itemSize;

						_gl.bindBuffer( gl.ARRAY_BUFFER, color.buffer );
						_gl.vertexAttribPointer( attributes["color"], colorSize, gl.FLOAT, false, 0, startIndex * colorSize * 4 );

					}

					// tangents

					var tangent = geometry.attributes[ "tangent" ];

					if ( attributes["tangent"] >= 0 && tangent ) {

						var tangentSize = tangent.itemSize;

						_gl.bindBuffer( gl.ARRAY_BUFFER, tangent.buffer );
						_gl.vertexAttribPointer( attributes["tangent"], tangentSize, gl.FLOAT, false, 0, startIndex * tangentSize * 4 );

					}

					// indices

					var index = geometry.attributes[ "index" ];

					_gl.bindBuffer( gl.ELEMENT_ARRAY_BUFFER, index.buffer );

				}

				// render indexed triangles

				_gl.drawElements( gl.TRIANGLES, offsets[ i ].count, gl.UNSIGNED_SHORT, offsets[ i ].start * 2 ); // 2 bytes per Uint16

				info.render.calls ++;
				info.render.vertices += offsets[ i ].count; // not really true, here vertices can be shared
				info.render.faces += offsets[ i ].count / 3;

			}

		}

	}

	renderBuffer ( camera, lights, fog, material, WebGLGeometry geometryGroup, object ) {

	  // Wrap these into proper WebGL objects since this method is called from plugins
	  WebGLObject webglobject = (object is WebGLObject) ? object : new WebGLObject(object);
      object = webglobject.object;

      WebGLCamera webglcamera = (camera is WebGLCamera) ? camera : new WebGLCamera(camera);
      camera = webglcamera._camera;

		if ( !material.visible ) return;

		var program, attributes, linewidth, primitives, a, attribute, i, il;

		program = setProgram( webglcamera, lights, fog, material, webglobject );

		attributes = program.attributes;

		var updateBuffers = false,
			wireframeBit = material.wireframe ? 1 : 0,
			geometryGroupHash = ( geometryGroup.id * 0xffffff ) + ( program.id * 2 ) + wireframeBit;

		if ( geometryGroupHash != _currentGeometryGroupHash ) {

			_currentGeometryGroupHash = geometryGroupHash;
			updateBuffers = true;

		}

		// vertices

		if ( !material.morphTargets && attributes["position"] >= 0 ) {

			if ( updateBuffers ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer );
				_gl.vertexAttribPointer( attributes["position"], 3, gl.FLOAT, false, 0, 0 );

			}

		} else {

			if ( webglobject.morphTargetBase != 0 ) {

				setupMorphTargets( material, geometryGroup, webglobject );

			}

		}


		if ( updateBuffers ) {

			// custom attributes

			// Use the per-geometryGroup custom attribute arrays which are setup in initMeshBuffers

			if ( geometryGroup.__webglCustomAttributesList != null) {

			  il = geometryGroup.__webglCustomAttributesList.length;
				for ( i = 0; i < il; i ++ ) {

					attribute = geometryGroup.__webglCustomAttributesList[ i ];

					if( attributes[ attribute.buffer.belongsToAttribute ] >= 0 ) {

						_gl.bindBuffer( gl.ARRAY_BUFFER, attribute.buffer );
						_gl.vertexAttribPointer( attributes[ attribute.buffer.belongsToAttribute ], attribute.size, gl.FLOAT, false, 0, 0 );

					}

				}

			}


			// colors

			if ( attributes["color"] >= 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglColorBuffer );
				_gl.vertexAttribPointer( attributes["color"], 3, gl.FLOAT, false, 0, 0 );

			}

			// normals

			if ( attributes["normal"] >= 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer );
				_gl.vertexAttribPointer( attributes["normal"], 3, gl.FLOAT, false, 0, 0 );

			}

			// tangents

			if ( attributes["tangent"] >= 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer );
				_gl.vertexAttribPointer( attributes["tangent"], 4, gl.FLOAT, false, 0, 0 );

			}

			// uvs

			if ( attributes["uv"] >= 0 ) {

				if ( geometryGroup.__webglUVBuffer != null ) {

					_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglUVBuffer );
					_gl.vertexAttribPointer( attributes["uv"], 2, gl.FLOAT, false, 0, 0 );

					_gl.enableVertexAttribArray( attributes["uv"] );

				} else {

					_gl.disableVertexAttribArray( attributes["uv"] );

				}

			}

			if ( attributes["uv2"] >= 0 ) {

				if ( geometryGroup.__webglUV2Buffer != null) {

					_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer );
					_gl.vertexAttribPointer( attributes["uv2"], 2, gl.FLOAT, false, 0, 0 );

					_gl.enableVertexAttribArray( attributes["uv2"] );

				} else {

					_gl.disableVertexAttribArray( attributes["uv2"] );

				}

			}

			if ( material.skinning &&
				 attributes["skinVertexA"] >= 0 && attributes["skinVertexB"] >= 0 &&
				 attributes["skinIndex"] >= 0 && attributes["skinWeight"] >= 0 ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexABuffer );
				_gl.vertexAttribPointer( attributes["skinVertexA"], 4, gl.FLOAT, false, 0, 0 );

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinVertexBBuffer );
				_gl.vertexAttribPointer( attributes["skinVertexB"], 4, gl.FLOAT, false, 0, 0 );

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer );
				_gl.vertexAttribPointer( attributes["skinIndex"], 4, gl.FLOAT, false, 0, 0 );

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer );
				_gl.vertexAttribPointer( attributes["skinWeight"], 4, gl.FLOAT, false, 0, 0 );

			}

		}

		// render mesh

		if ( object is Mesh ) {

			// wireframe

			if ( material.wireframe ) {

				setLineWidth( material.wireframeLinewidth );

				if ( updateBuffers ) _gl.bindBuffer( gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer );
				_gl.drawElements( gl.LINES, geometryGroup.__webglLineCount, gl.UNSIGNED_SHORT, 0 );

			// triangles

			} else {

				if ( updateBuffers ) _gl.bindBuffer( gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer );
				_gl.drawElements( gl.TRIANGLES, geometryGroup.__webglFaceCount, gl.UNSIGNED_SHORT, 0 );

			}

			info.render.calls ++;
			info.render.vertices += geometryGroup.__webglFaceCount;
			info.render.faces += geometryGroup.__webglFaceCount ~/ 3;

		// render lines

		} else if ( object is Line ) {

			primitives = ( (object as Line).type == LineStrip ) ? gl.LINE_STRIP : gl.LINES;

			setLineWidth( material.linewidth );

			_gl.drawArrays( primitives, 0, geometryGroup.__webglLineCount );

			info.render.calls ++;

		// render particles

		} else if ( object is ParticleSystem ) {

			_gl.drawArrays( gl.POINTS, 0, geometryGroup.__webglParticleCount );

			info.render.calls ++;
			info.render.points += geometryGroup.__webglParticleCount;

		// render ribbon

		} else if ( object is Ribbon ) {

			_gl.drawArrays( gl.TRIANGLE_STRIP, 0, geometryGroup.__webglVertexCount );

			info.render.calls ++;

		}

	}

	setupMorphTargets ( material, WebGLGeometry geometryGroup, WebGLObject object ) {

		// set base

		var attributes = material.program.attributes;

		if ( object.morphTargetBase != -1 ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[ object.morphTargetBase ] );
			_gl.vertexAttribPointer( attributes["position"], 3, gl.FLOAT, false, 0, 0 );

		} else if ( attributes["position"] >= 0 ) {

			_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer );
			_gl.vertexAttribPointer( attributes["position"], 3, gl.FLOAT, false, 0, 0 );

		}

		if ( object.morphTargetForcedOrder.length > 0) {

			// set forced order

			var m = 0;
			var order = object.morphTargetForcedOrder;
			var influences = object.morphTargetInfluences;

			while ( m < material.numSupportedMorphTargets && m < order.length ) {

				_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[ order[ m ] ] );
				_gl.vertexAttribPointer( attributes[ "morphTarget$m"], 3, gl.FLOAT, false, 0, 0 );

				if ( material.morphNormals ) {

					_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[ order[ m ] ] );
					_gl.vertexAttribPointer( attributes[ "morphNormal$m" ], 3, gl.FLOAT, false, 0, 0 );

				}

				object.__webglMorphTargetInfluences[ m ] = influences[ order[ m ] ];

				m ++;
			}

		} else {

			// find the most influencing

			var influence;
			List<List> activeInfluenceIndices = [];
			var influences = object.morphTargetInfluences;
			var i, il = influences.length;

			for ( i = 0; i < il; i ++ ) {

				influence = influences[ i ];

				if ( influence > 0 ) {

					activeInfluenceIndices.add( [ i, influence ] );

				}

			}

			if ( activeInfluenceIndices.length > material.numSupportedMorphTargets ) {

				activeInfluenceIndices.sort( numericalSort );
				activeInfluenceIndices.length = material.numSupportedMorphTargets;

			} else if ( activeInfluenceIndices.length > material.numSupportedMorphNormals ) {

				activeInfluenceIndices.sort( numericalSort );

			} else if ( activeInfluenceIndices.length == 0 ) {

				activeInfluenceIndices.add( [ 0, 0 ] );

			};

			var influenceIndex, m = 0;

			while ( m < material.numSupportedMorphTargets ) {

				if ( m < activeInfluenceIndices.length && activeInfluenceIndices[ m ] != null && !activeInfluenceIndices[ m ].isEmpty) {

					influenceIndex = activeInfluenceIndices[ m ][ 0 ];

					_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[ influenceIndex ] );

					_gl.vertexAttribPointer( attributes[ "morphTarget$m" ], 3, gl.FLOAT, false, 0, 0 );

					if ( material.morphNormals ) {

						_gl.bindBuffer( gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[ influenceIndex ] );
						_gl.vertexAttribPointer( attributes[ "morphNormal$m" ], 3, gl.FLOAT, false, 0, 0 );

					}

					object.__webglMorphTargetInfluences[ m ] = influences[ influenceIndex ];

				} else {

					_gl.vertexAttribPointer( attributes[ "morphTarget$m" ], 3, gl.FLOAT, false, 0, 0 );

					if ( material.morphNormals ) {

						_gl.vertexAttribPointer( attributes[ "morphNormal$m" ], 3, gl.FLOAT, false, 0, 0 );

					}

					object.__webglMorphTargetInfluences[ m ] = 0;

				}

				m ++;

			}

		}

		// load updated influences uniform

		if ( material.program.uniforms["morphTargetInfluences"] != null ) {

			_gl.uniform1fv( material.program.uniforms["morphTargetInfluences"], object.__webglMorphTargetInfluences );

		}

	}

	// Sorting

	painterSort ( a, b ) => (a.z.isNaN || b.z.isNaN) ? 0 : (b.z - a.z).toInt();

	numericalSort ( a, b ) => (b[ 1 ] - a[ 1 ]).toInt();


	// Rendering
	render ( Scene scene, Camera camera) => _render( scene, camera);

	_render ( Scene scene, Camera c, {renderTarget: null, forceClear: false} ) {

		var i, il;

		WebGLObject webglObject;
		Object3D object;
		var renderList;

		List lights = scene.lights;
		Fog fog = scene.fog;

		// reset caching for this frame

		_currentMaterialId = -1;
		_lightsNeedUpdate = true;

		// update scene graph

		if ( autoUpdateScene ) scene.updateMatrixWorld();

		var camera = new WebGLCamera(c);

		// update camera matrices and frustum

		if ( camera.parent == null ) camera.updateMatrixWorld();

		camera.matrixWorldInverse.getInverse( camera.matrixWorld );

		camera.matrixWorldInverse.flattenToArray( camera._viewMatrixArray );
		camera.projectionMatrix.flattenToArray( camera._projectionMatrixArray );

		_projScreenMatrix.multiply( camera.projectionMatrix, camera.matrixWorldInverse );
		_frustum.setFromMatrix( _projScreenMatrix );

		// update WebGL objects

		if ( autoUpdateObjects ) initWebGLObjects( scene );

		// custom render plugins (pre pass)

		renderPlugins( renderPluginsPre, scene, camera );

		//

		info.render.calls = 0;
		info.render.vertices = 0;
		info.render.faces = 0;
		info.render.points = 0;

		setRenderTarget( renderTarget );

		if ( autoClear || forceClear ) {

			clear( autoClearColor, autoClearDepth, autoClearStencil );

		}

		// set matrices for regular objects (frustum culled)

		renderList = scene["__webglObjects"];

		il = renderList.length;

		for ( i = 0; i < il; i ++ ) {

			webglObject = renderList[ i ];
			object = webglObject.object;

			webglObject.render = false;

			if ( object.visible ) {

				if ( ! ( object is Mesh || object is ParticleSystem ) || ! ( object.frustumCulled ) || _frustum.contains( object ) ) {

					//object.matrixWorld.flattenToArray( object["modelMatrixArray"] );

					setupMatrices( webglObject, camera );

					unrollBufferMaterial( webglObject );

					webglObject.render = true;

					if ( sortObjects ) {

						if ( object.renderDepth != null ) {

							webglObject.z = object.renderDepth;

						} else {

							_vector3.copy( object.matrixWorld.getPosition() );
							_projScreenMatrix.multiplyVector3( _vector3 );

							webglObject.z = _vector3.z;

						}

					}

				}

			}

		}

		if ( sortObjects ) {

			renderList.sort( painterSort );

		}

		// set matrices for immediate objects

		renderList = scene["__webglObjectsImmediate"];

		il = renderList.length;

		for ( i = 0; i < il; i ++ ) {

			webglObject = renderList[ i ];
			object = webglObject.object;

			if ( object.visible ) {

				/*
				if ( object.matrixAutoUpdate ) {

					object.matrixWorld.flattenToArray( object["modelMatrixArray"] );

				}
				*/

				setupMatrices( webglObject, camera );

				unrollImmediateBufferMaterial( webglObject );

			}

		}

		if ( scene.overrideMaterial != null ) {

			var material = scene.overrideMaterial;

			setBlending( material.blending, material.blendEquation, material.blendSrc, material.blendDst );
			setDepthTest( material.depthTest );
			setDepthWrite( material.depthWrite );
			setPolygonOffset( material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits );

			renderObjects( scene["__webglObjects"], false, "", camera, lights, fog, true, material );
			renderObjectsImmediate( scene["__webglObjectsImmediate"], "", camera, lights, fog, false, material );

		} else {

			// opaque pass (front-to-back order)

			setBlending( NormalBlending );

			renderObjects( scene["__webglObjects"], true, "opaque", camera, lights, fog, false );
			renderObjectsImmediate( scene["__webglObjectsImmediate"], "opaque", camera, lights, fog, false );

			// transparent pass (back-to-front order)

			renderObjects( scene["__webglObjects"], false, "transparent", camera, lights, fog, true );
			renderObjectsImmediate( scene["__webglObjectsImmediate"], "transparent", camera, lights, fog, true );

		}

		// custom render plugins (post pass)

		renderPlugins( renderPluginsPost, scene, camera );


		// Generate mipmap if we're using any kind of mipmap filtering

		if ( (renderTarget != null ) && renderTarget.generateMipmaps && renderTarget.minFilter != NearestFilter && renderTarget.minFilter != LinearFilter ) {

			updateRenderTargetMipmap( renderTarget );

		}

		// Ensure depth buffer writing is enabled so it can be cleared on next render

		setDepthTest( true );
		setDepthWrite( true );

		// _gl.finish();

	}

	renderPlugins( plugins, scene, camera ) {

		plugins.forEach((plugin) {
			// reset state for plugin (to start from clean slate)

			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = -1;
			_oldDepthWrite = -1;
			_oldDoubleSided = -1;
			_oldFlipSided = -1;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

			plugin.render( scene, camera._camera, _currentWidth, _currentHeight );

			// reset state after plugin (anything could have changed)

			_currentProgram = null;
			_currentCamera = null;

			_oldBlending = -1;
			_oldDepthTest = -1;
			_oldDepthWrite = -1;
			_oldDoubleSided = -1;
			_oldFlipSided = -1;
			_currentGeometryGroupHash = -1;
			_currentMaterialId = -1;

			_lightsNeedUpdate = true;

		});

	}

	renderObjects (  List<WebGLObject>renderList,
	                 bool reverse, String materialType,
	                 WebGLCamera camera,
	                 List<Light> lights,
	                 fog,
	                 useBlending,
	                 [overrideMaterial = null] ) {

		WebGLObject webglObject;
		var object, buffer, material;
		num start, end, delta;

		if ( reverse ) {

			start = renderList.length - 1;
			end = -1;
			delta = -1;

		} else {

			start = 0;
			end = renderList.length;
			delta = 1;
		}

		for ( var i = start; i != end; i += delta ) {

			webglObject = renderList[ i ];

			if ( webglObject.render ) {

				object = webglObject.object;
				buffer = webglObject.buffer;

				if ( overrideMaterial != null ) {

					material = overrideMaterial;

				} else {

					material = (materialType == "opaque")? webglObject.opaque : webglObject.transparent;

					if ( material == null ) continue;

					if ( useBlending ) setBlending( material.blending, material.blendEquation, material.blendSrc, material.blendDst );

					setDepthTest( material.depthTest );
					setDepthWrite( material.depthWrite );
					setPolygonOffset( material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits );

				}

				setMaterialFaces( material );

				if ( buffer is BufferGeometry ) {

					renderBufferDirect( camera, lights, fog, material, buffer, webglObject );

				} else {

					renderBuffer( camera, lights, fog, material, buffer, webglObject );

				}

			}

		}

	}

	renderObjectsImmediate ( renderList, materialType, camera, lights, fog, useBlending, [overrideMaterial] ) {

		var webglObject, object, material, program, il;

		il = renderList.length;

		for ( var i = 0; i < il; i ++ ) {

			webglObject = renderList[ i ];
			object = webglObject.object;

			if ( object.visible ) {

				if ( overrideMaterial ) {

					material = overrideMaterial;

				} else {

					material = webglObject[ materialType ];

					if ( ! material ) continue;

					if ( useBlending ) setBlending( material.blending, material.blendEquation, material.blendSrc, material.blendDst );

					setDepthTest( material.depthTest );
					setDepthWrite( material.depthWrite );
					setPolygonOffset( material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits );

				}

				renderImmediateObject( camera, lights, fog, material, object );

			}

		}

	}

	renderImmediateObject( camera, lights, fog, material, object ) {

		var program = setProgram( camera, lights, fog, material, object );

		_currentGeometryGroupHash = -1;

		setMaterialFaces( material );

		if ( object.immediateRenderCallback ) {

			object.immediateRenderCallback( program, _gl, _frustum );

		} else {

			object.render( ( object ) { renderBufferImmediate( object, program, material ); } );

		}

	}

	unrollImmediateBufferMaterial ( WebGLObject webglobject ) {

		var material = webglobject.webglmaterial;

		if ( material.transparent ) {

		  webglobject.transparent = material;
		  webglobject.opaque = null;

		} else {

		  webglobject.opaque = material;
		  webglobject.transparent = null;

		}

	}

	unrollBufferMaterial ( WebGLObject object ) {

		WebGLGeometry	buffer = object.buffer;
		WebGLMaterial meshMaterial = object.webglmaterial;
		int materialIndex;
		WebGLMaterial material;


		if ( object.material is MeshFaceMaterial ) {

			materialIndex = buffer.materialIndex;

			if ( materialIndex >= 0 ) {

				material = new WebGLMaterial.from(object.geometry.materials[ materialIndex ]);

				if ( material.transparent ) {

				  object.transparent = material;
				  object.opaque = null;

				} else {

				  object.opaque = material;
				  object.transparent = null;

				}

			}

		} else {

		  material = meshMaterial;

			if ( material != null ) {

				if ( material.transparent != null ) {

				  object.transparent = material;
				  object.opaque = null;

				} else {

				  object.opaque = material;
				  object.transparent = null;

				}

			}

		}

	}

	// Geometry splitting

	sortFacesByMaterial ( WebGLGeometry geometry ) {

		var f, fl, face, materialIndex, vertices,
			materialHash, groupHash;

		Map<String, Map> hash_map = {};

		var numMorphTargets = geometry.morphTargets.length;
		var numMorphNormals = geometry.morphNormals.length;

		geometry.geometryGroups = {};

		fl = geometry.faces.length;
		for ( f = 0; f < fl; f ++ ) {

			face = geometry.faces[ f ];
			materialIndex = face.materialIndex;

			var materialHash = ( materialIndex != null ) ? materialIndex.toString() : (-1).toString();

			if ( hash_map[ materialHash ] == null ) {

				hash_map[ materialHash ] = { 'hash': materialHash, 'counter': 0 };

			}

			groupHash = "${hash_map[ materialHash ]["hash"]}_${hash_map[ materialHash ]["counter"]}";

			if ( geometry.geometryGroups[ groupHash ] == null ) {

				geometry.geometryGroups[ groupHash ] = new WebGLGeometry(faces3: [], faces4: [], materialIndex: materialIndex, vertices: 0, numMorphTargets: numMorphTargets, numMorphNormals: numMorphNormals);

			}

			vertices = face is Face3 ? 3 : 4;

			if ( geometry.geometryGroups[ groupHash ].vertices + vertices > 65535 ) {

				hash_map[ materialHash ]["counter"] += 1;
				groupHash = "${hash_map[ materialHash ]["hash"]}_${hash_map[ materialHash ]["counter"]}";

				if ( geometry.geometryGroups[ groupHash ] == null ) {

					geometry.geometryGroups[ groupHash ] = new WebGLGeometry(faces3: [], faces4: [], materialIndex: materialIndex, vertices: 0, numMorphTargets: numMorphTargets, numMorphNormals: numMorphNormals );

				}

			}

			if ( face is Face3 ) {

				geometry.geometryGroups[ groupHash ].faces3.add( f );

			} else {

				geometry.geometryGroups[ groupHash ].faces4.add( f );

			}

			geometry.geometryGroups[ groupHash ].vertices += vertices;

		}

		geometry.geometryGroupsList = [];

		geometry.geometryGroups.forEach( (k,g) {

      g.id = _geometryGroupCounter ++;

      geometry.geometryGroupsList.add( g );

    });

		return;

	}

	// Objects refresh

	initWebGLObjects( Scene scene ) {

		if ( scene["__webglObjects"] == null ) {

			scene["__webglObjects"] = [];
			scene["__webglObjectsImmediate"] = [];
			scene["__webglSprites"] = [];
			scene["__webglFlares"] = [];

		}

		while ( scene.__objectsAdded.length > 0 ) {

			addObject( scene.__objectsAdded[ 0 ], scene );
			scene.__objectsAdded.removeAt( 0 );

		}

		while ( scene.__objectsRemoved.length > 0) {

			removeObject( scene.__objectsRemoved[ 0 ], scene );
			scene.__objectsRemoved.removeAt( 0 );

		}

		// update must be called after objects adding / removal

		for ( var o = 0, ol = scene["__webglObjects"].length; o < ol; o ++ ) {

			updateObject( scene["__webglObjects"][ o ] );

		}

	}

	// Objects adding

	addObject ( Object3D object, Scene scene ) {

	  // nelsonsilva - wrapping in our own decorator
    WebGLObject webglobject = new WebGLObject(object);

    // ATTENTION - All type checks must be done with object and object.geometry
    WebGLGeometry geometry = webglobject.webglgeometry;

		if (  !webglobject.__webglInit ) {

		  webglobject.__webglInit = true;

		  webglobject._modelViewMatrix = new Matrix4();
		  webglobject._normalMatrix = new Matrix3();

			if ( object is Mesh ) {

				if ( object.geometry is Geometry ) {

					if ( geometry.geometryGroups == null) {

						sortFacesByMaterial( geometry );

					}

					// create separate VBOs per geometry chunk

					geometry.geometryGroups.forEach((k, geometryGroup) {

						// initialise VBO on the first access

						if ( geometryGroup.__webglVertexBuffer == null ) {

							createMeshBuffers( geometryGroup );
							initMeshBuffers( geometryGroup, webglobject );

							geometry.verticesNeedUpdate = true;
							geometry.morphTargetsNeedUpdate = true;
							geometry.elementsNeedUpdate = true;
							geometry.uvsNeedUpdate = true;
							geometry.normalsNeedUpdate = true;
							geometry.tangentsNeedUpdate = true;
							geometry.colorsNeedUpdate = true;

						}

					});

				} else if ( object.geometry is BufferGeometry ) {

					initDirectBuffers( object.geometry as BufferGeometry);

				}

			} else if ( object is Ribbon ) {

				if( geometry.__webglVertexBuffer == null) {

					createRibbonBuffers( geometry );
					initRibbonBuffers( geometry );

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;

				}

			} else if ( object is Line ) {

				geometry = new WebGLGeometry.from(object.geometry);

				if( geometry.__webglVertexBuffer == null ) {

					createLineBuffers( geometry );
					initLineBuffers( geometry, webglobject );

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;

				}

			} else if ( object is ParticleSystem ) {

				if ( geometry.__webglVertexBuffer == null ) {

					createParticleBuffers( geometry );
					initParticleBuffers( geometry, webglobject );

					geometry.verticesNeedUpdate = true;
					geometry.colorsNeedUpdate = true;

				}

			}
			webglobject.__webglActive = false;
		}

		if (!webglobject.__webglActive) {

			if ( object is Mesh ) {

				if ( object.geometry is BufferGeometry ) {

					addBuffer( scene["__webglObjects"], geometry, webglobject );

				} else {

				  geometry.geometryGroups.forEach( (k, geometryGroup) {

						addBuffer( scene["__webglObjects"], geometryGroup, webglobject );

					});

				}

			} else if ( object is Ribbon ||
						object is Line ||
						object is ParticleSystem ) {

				addBuffer( scene["__webglObjects"],  geometry, webglobject );

			} else if ( object is ImmediateRenderObject || (object["immediateRenderCallback"] != null) ) {

				addBufferImmediate( scene["__webglObjectsImmediate"], webglobject );

			} else if ( object is Sprite ) {

				scene["__webglSprites"].add( object );

			} else if ( object is LensFlare ) {

				scene["__webglFlares"].add( object );

			}

			object["__webglActive"] = true;

		}

	}

	addBuffer ( objlist, WebGLGeometry buffer, WebGLObject object ) {

	  object.buffer = buffer;
	  object.opaque = null;
	  object.transparent = null;
		objlist.add(object);

	}

	addBufferImmediate ( objlist, WebGLObject object ) {

	  object.opaque = null;
    object.transparent = null;

		objlist.add(object);

	}

	// Objects updates

	updateObject ( WebGLObject webglobject ) {

    Object3D object = webglobject.object;
		WebGLGeometry geometry = webglobject.webglgeometry, geometryGroup;
		var customAttributesDirty;

		WebGLMaterial material;

		if ( object is Mesh ) {

			if ( object.geometry is BufferGeometry ) {

				if ( geometry.verticesNeedUpdate || geometry.elementsNeedUpdate ||
					 geometry.uvsNeedUpdate || geometry.normalsNeedUpdate ||
					 geometry.colorsNeedUpdate || geometry.tangentsNeedUpdate ) {

					setDirectBuffers( geometry, gl.DYNAMIC_DRAW, !(geometry as dynamic) );

				}

				geometry.verticesNeedUpdate = false;
				geometry.elementsNeedUpdate = false;
				geometry.uvsNeedUpdate = false;
				geometry.normalsNeedUpdate = false;
				geometry.colorsNeedUpdate = false;
				geometry.tangentsNeedUpdate = false;

			} else {

				// check all geometry groups

				for( var i = 0, il = geometry.geometryGroupsList.length; i < il; i ++ ) {

					geometryGroup = geometry.geometryGroupsList[ i ];

					material = getBufferMaterial( webglobject, geometryGroup );

					customAttributesDirty = (material.attributes != null) && areCustomAttributesDirty( material );

					if ( geometry.verticesNeedUpdate || geometry.morphTargetsNeedUpdate || geometry.elementsNeedUpdate ||
						 geometry.uvsNeedUpdate || geometry.normalsNeedUpdate ||
						 geometry.colorsNeedUpdate || geometry.tangentsNeedUpdate || customAttributesDirty ) {

						setMeshBuffers( geometryGroup, webglobject, gl.DYNAMIC_DRAW, !geometry.isDynamic, material );

					}

				}

				geometry.verticesNeedUpdate = false;
				geometry.morphTargetsNeedUpdate = false;
				geometry.elementsNeedUpdate = false;
				geometry.uvsNeedUpdate = false;
				geometry.normalsNeedUpdate = false;
				geometry.colorsNeedUpdate = false;
				geometry.tangentsNeedUpdate = false;

				if (material.attributes != null) {
				  clearCustomAttributes( material );
				}

			}

		} else if ( object is Ribbon ) {

			if ( geometry.verticesNeedUpdate || geometry.colorsNeedUpdate ) {

				setRibbonBuffers( geometry, gl.DYNAMIC_DRAW );

			}

			geometry.verticesNeedUpdate = false;
			geometry.colorsNeedUpdate = false;

		} else if ( object is Line ) {

			material = getBufferMaterial( webglobject, geometryGroup );

			customAttributesDirty = (material.attributes != null) && areCustomAttributesDirty( material );

			if ( geometry.verticesNeedUpdate ||  geometry.colorsNeedUpdate || customAttributesDirty ) {

				setLineBuffers( geometry, gl.DYNAMIC_DRAW );

			}

			geometry.verticesNeedUpdate = false;
			geometry.colorsNeedUpdate = false;

			if (material.attributes != null) clearCustomAttributes( material );

		} else if ( object is ParticleSystem ) {

			material = getBufferMaterial( webglobject, geometryGroup );

			customAttributesDirty = (material.attributes != null) && areCustomAttributesDirty( material );

			if ( geometry.verticesNeedUpdate || geometry.colorsNeedUpdate || object.sortParticles || customAttributesDirty ) {

				setParticleBuffers( geometry, gl.DYNAMIC_DRAW, object );

			}

			geometry.verticesNeedUpdate = false;
			geometry.colorsNeedUpdate = false;

			if (material.attributes != null) clearCustomAttributes( material );

		}

	}

	// Objects updates - custom attributes check

	areCustomAttributesDirty ( material ) {

		for ( var m in material.attributes ) {

			if ( m.needsUpdate ) return true;

		}

		return false;

	}

	clearCustomAttributes ( material ) {

		for ( var m in material.attributes ) {

			m.needsUpdate = false;

		}

	}

	// Objects removal

	removeObject ( Object3D object, scene ) {

	  WebGLObject webglobject = new WebGLObject(object);

		if ( object is Mesh  ||
			 object is ParticleSystem ||
			 object is Ribbon ||
			 object is Line ) {

			removeInstances( scene["__webglObjects"], object );

		} else if ( object is Sprite ) {

			removeInstancesDirect( scene["__webglSprites"], object );

		} else if ( object is LensFlare ) {

			removeInstancesDirect( scene["__webglFlares"], object );

		} else if ( object is ImmediateRenderObject || (object["immediateRenderCallback"] != null) ) {

			removeInstances( scene["__webglObjectsImmediate"], object );

		}

		webglobject.__webglActive = false;

	}

	removeInstances ( objlist, Object3D object ) {

		for ( var o = objlist.length - 1; o >= 0; o -- ) {

			if ( objlist[ o ].object == object ) {

				objlist.removeAt( o );

			}

		}

	}

	removeInstancesDirect ( objlist, Object3D object ) {

		for ( var o = objlist.length - 1; o >= 0; o -- ) {

      if ( identical(objlist[ o ], object) ) {

				objlist.removeAt( o );

			}

		}

	}

	// Materials

	initMaterial( WebGLMaterial material, List<Light> lights, Fog fog, WebGLObject webglobject ) {

	  Object3D object = webglobject.object;

		var u, a, identifiers, i, parameters, maxLightCount, maxBones, maxShadows, shaderID;

		if ( material.isMeshDepthMaterial ) {

			shaderID = 'depth';

		} else if ( material.isMeshNormalMaterial ) {

			shaderID = 'normal';

		} else if ( material.isMeshBasicMaterial ) {

			shaderID = 'basic';

		} else if ( material.isMeshLambertMaterial ) {

			shaderID = 'lambert';

		} else if ( material.isMeshPhongMaterial ) {

			shaderID = 'phong';

		} else if ( material.isLineBasicMaterial ) {

			shaderID = 'basic';

		} else if ( material.isParticleBasicMaterial ) {

			shaderID = 'particle_basic';

		}

		if ( shaderID != null) {

			setMaterialShaders( material, ShaderLib[ shaderID ] );

		}

		// heuristics to create shader parameters according to lights in the scene
		// (not to blow over maxLights budget)

		maxLightCount = allocateLights( lights );

		maxShadows = allocateShadows( lights );

		maxBones = allocateBones( object );

		material.program = buildProgram(
			shaderID,
			material.fragmentShader,
			material.vertexShader,
			material.uniforms,
			material.attributes,
			map: material.map,
			envMap: material.envMap,
			lightMap: material.lightMap,
			bumpMap: material.bumpMap,
			specularMap: material.specularMap,

			vertexColors: material.vertexColors,

			fog: fog,
			useFog: material.fog,

			sizeAttenuation: material.sizeAttenuation,

			skinning: material.skinning,
			maxBones: maxBones,
			useVertexTexture: supportsBoneTextures && (object != null) && (object is SkinnedMesh) && (object as SkinnedMesh).useVertexTexture,
			boneTextureWidth: ((object != null) && (object is SkinnedMesh)) ? (object as SkinnedMesh).boneTextureWidth : null,
			boneTextureHeight: ((object != null) && (object is SkinnedMesh)) ? (object as SkinnedMesh).boneTextureHeight : null,

			morphTargets: material.morphTargets,
			morphNormals: material.morphNormals,
			maxMorphTargets: maxMorphTargets,
			maxMorphNormals: maxMorphNormals,

			maxDirLights: maxLightCount['directional'],
			maxPointLights: maxLightCount['point'],
			maxSpotLights: maxLightCount['spot'],

			maxShadows: maxShadows,
			shadowMapEnabled: shadowMapEnabled && object.receiveShadow,
			shadowMapSoft: shadowMapSoft,
			shadowMapDebug: shadowMapDebug,
			shadowMapCascade: shadowMapCascade,

			alphaTest: material.alphaTest,
			metal: material.metal,
			perPixel: material.perPixel,
			wrapAround: material.wrapAround,
			doubleSided: material.side == DoubleSide );

		var attributes = material.program.attributes;

		if ( attributes["position"] >= 0 ) _gl.enableVertexAttribArray( attributes["position"] );
		if ( attributes["color"] >= 0 ) _gl.enableVertexAttribArray( attributes["color"] );
		if ( attributes["normal"] >= 0 ) _gl.enableVertexAttribArray( attributes["normal"] );
		if ( attributes["tangent"] >= 0 ) _gl.enableVertexAttribArray( attributes["tangent"] );

		if ( material.skinning &&
			 attributes["skinVertexA"] >=0 && attributes["skinVertexB"] >= 0 &&
			 attributes["skinIndex"] >= 0 && attributes["skinWeight"] >= 0 ) {

			_gl.enableVertexAttribArray( attributes["skinVertexA"] );
			_gl.enableVertexAttribArray( attributes["skinVertexB"] );
			_gl.enableVertexAttribArray( attributes["skinIndex"] );
			_gl.enableVertexAttribArray( attributes["skinWeight"] );

		}

		if ( material.attributes != null) {

			for ( a in material.attributes ) {

				if( attributes[ a ] != null && attributes[ a ] >= 0 ) _gl.enableVertexAttribArray( attributes[ a ] );

			}

		}

		if ( material.morphTargets ) {

			material.numSupportedMorphTargets = 0;

			var id, base = "morphTarget";

			for ( i = 0; i < maxMorphTargets; i ++ ) {

				id = "$base$i";

				if ( attributes[ id ] >= 0 ) {

					_gl.enableVertexAttribArray( attributes[ id ] );
					material.numSupportedMorphTargets ++;

				}

			}

		}

		if ( material.morphNormals ) {

			material.numSupportedMorphNormals = 0;

			var id, base = "morphNormal";

			for ( i = 0; i < maxMorphNormals; i ++ ) {

				id = "$base$i";

				if ( attributes[ id ] >= 0 ) {

					_gl.enableVertexAttribArray( attributes[ id ] );
					material.numSupportedMorphNormals ++;

				}

			}

		}

		material.uniformsList = [];

		material.uniforms.forEach( (k, u) => material.uniformsList.add( [ u, k ] ));

	}

	setMaterialShaders( WebGLMaterial material, shaders ) {

		material.uniforms = UniformsUtils.clone( shaders["uniforms"] );
		material.vertexShader = shaders["vertexShader"];
		material.fragmentShader = shaders["fragmentShader"];

	}

	setProgram( WebGLCamera camera, List lights, Fog fog, WebGLMaterial material, WebGLObject object ) {

		if ( material.needsUpdate ) {

			if ( material.program != null ) deallocateMaterial( material );

			initMaterial( material, lights, fog, object );
			material.needsUpdate = false;

		}

		if ( material.morphTargets ) {

			if ( object.__webglMorphTargetInfluences == null) {

				object.__webglMorphTargetInfluences = new Float32Array( maxMorphTargets );

			}

		}

		var refreshMaterial = false;

		var program = material.program,
			p_uniforms = program.uniforms,
			m_uniforms = material.uniforms;

    if ( !identical(program, _currentProgram) ) {

			_gl.useProgram( program.glProgram );
			_currentProgram = program;

			refreshMaterial = true;

		}

		if ( material.id != _currentMaterialId ) {

			_currentMaterialId = material.id;
			refreshMaterial = true;

		}

    if ( refreshMaterial || !identical(camera, _currentCamera) ) {

			_gl.uniformMatrix4fv( p_uniforms["projectionMatrix"], false, camera._projectionMatrixArray );

      if ( !identical(camera, _currentCamera) ) _currentCamera = camera;

		}

		if ( refreshMaterial ) {

			// refresh uniforms common to several materials

			if ( (fog != null) && material.fog ) {

				refreshUniformsFog( m_uniforms, fog );

			}

			if ( material.isMeshPhongMaterial ||
				 material.isMeshLambertMaterial ||
				 material.lights ) {

				if ( _lightsNeedUpdate ) {

					setupLights( program, lights );
					_lightsNeedUpdate = false;

				}

				refreshUniformsLights( m_uniforms, _lights );

			}

			if ( material.isMeshBasicMaterial ||
				 material.isMeshLambertMaterial ||
				 material.isMeshPhongMaterial ) {

				refreshUniformsCommon( m_uniforms, material );

			}

			// refresh single material specific uniforms

			if ( material.isLineBasicMaterial ) {

				refreshUniformsLine( m_uniforms, material );

			} else if ( material.isParticleBasicMaterial ) {

				refreshUniformsParticle( m_uniforms, material );

			} else if ( material.isMeshPhongMaterial ) {

				refreshUniformsPhong( m_uniforms, material );

			} else if ( material.isMeshLambertMaterial ) {

				refreshUniformsLambert( m_uniforms, material );

			} else if ( material.isMeshDepthMaterial ) {

				m_uniforms["mNear"].value = camera.near;
				m_uniforms["mFar"].value = camera.far;
				m_uniforms["opacity"].value = material.opacity;

			} else if ( material.isMeshNormalMaterial ) {

				m_uniforms["opacity"].value = material.opacity;

			}

			if ( object.receiveShadow && ! material.shadowPass ) {

				refreshUniformsShadow( m_uniforms, lights );

			}

			// load common uniforms

			loadUniformsGeneric( program, material.uniformsList );

			// load material specific uniforms
			// (shader material also gets them for the sake of genericity)

			if ( material.isShaderMaterial ||
				 material.isMeshPhongMaterial ||
				 (material.envMap != null) ) {

				if ( p_uniforms["cameraPosition"] != null ) {

					var position = camera.matrixWorld.getPosition();
					_gl.uniform3f( p_uniforms["cameraPosition"], position.x, position.y, position.z );

				}

			}

			if ( material.isMeshPhongMaterial ||
				 material.isMeshLambertMaterial ||
				 material.isShaderMaterial ||
				 material.skinning ) {

				if ( p_uniforms["viewMatrix"] != null ) {

					_gl.uniformMatrix4fv( p_uniforms["viewMatrix"], false, camera._viewMatrixArray );

				}

			}

		}

		if ( material.skinning ) {

			if ( supportsBoneTextures && object.useVertexTexture ) {

				if ( p_uniforms["boneTexture"] != null ) {

					// shadowMap texture array starts from 6
					// texture unit 12 should leave space for 6 shadowmaps

					var textureUnit = 12;

					_gl.uniform1i( p_uniforms["boneTexture"], textureUnit );
					setTexture( object.boneTexture, textureUnit );

				}

			} else {

				if ( p_uniforms["boneGlobalMatrices"] != null ) {

					_gl.uniformMatrix4fv( p_uniforms["boneGlobalMatrices"], false, object.boneMatrices );

				}

			}

		}

		loadUniformsMatrices( p_uniforms, object );

		if ( p_uniforms["modelMatrix"] != null ) {

			_gl.uniformMatrix4fv( p_uniforms["modelMatrix"], false, object.matrixWorld.elements );

		}

		return program;

	}

	// Uniforms (refresh uniforms objects)

	refreshUniformsCommon ( uniforms, material ) {

		uniforms["opacity"].value = material.opacity;

		if ( gammaInput ) {

			uniforms["diffuse"].value.copyGammaToLinear( material.color );

		} else {

			uniforms["diffuse"].value = material.color;

		}

		uniforms["map"].texture = material.map;
		uniforms["lightMap"].texture = material.lightMap;
		uniforms["specularMap"].texture = material.specularMap;

		if ( material.bumpMap != null ) {

			uniforms["bumpMap"].texture = material.bumpMap;
			uniforms["bumpScale"].value = material.bumpScale;

		}

		// uv repeat and offset setting priorities
		//	1. color map
		//	2. specular map
		//	3. bump map

		var uvScaleMap;

		if ( material.map != null ) {

			uvScaleMap = material.map;

		} else if ( material.specularMap != null ) {

			uvScaleMap = material.specularMap;

		} else if ( material.bumpMap != null ) {

			uvScaleMap = material.bumpMap;

		}

		if ( uvScaleMap != null ) {

			var offset = uvScaleMap.offset;
			var repeat = uvScaleMap.repeat;

			uniforms["offsetRepeat"].value.setValues( offset.x, offset.y, repeat.x, repeat.y );

		}

		uniforms["envMap"].texture = material.envMap;
		uniforms["flipEnvMap"].value = ( material.envMap is WebGLRenderTargetCube ) ? 1 : -1;

		if ( gammaInput ) {

			//uniforms["reflectivity"].value = material.reflectivity * material.reflectivity;
			uniforms["reflectivity"].value = material.reflectivity;

		} else {

			uniforms["reflectivity"].value = material.reflectivity;

		}

		uniforms["refractionRatio"].value = material.refractionRatio;
		uniforms["combine"].value = material.combine;
		uniforms["useRefract"].value = ((material.envMap != null) && (material.envMap.mapping is CubeRefractionMapping))? 1:0;

	}

	refreshUniformsLine ( uniforms, material ) {

		uniforms["diffuse"].value = material.color;
		uniforms["opacity"].value = material.opacity;

	}

	refreshUniformsParticle ( uniforms, material ) {

		uniforms["psColor"].value = material.color;
		uniforms["opacity"].value = material.opacity;
		uniforms["size"].value = material.size;
		uniforms["scale"].value = canvas.height / 2.0; // TODO: Cache

		uniforms["map"].texture = material.map;

	}

	refreshUniformsFog ( uniforms, Fog fog ) {

		uniforms["fogColor"].value = fog.color;

		if ( fog is FogLinear ) {

			uniforms["fogNear"].value = fog.near;
			uniforms["fogFar"].value = fog.far;

		} else if ( fog is FogExp2 ) {

			uniforms["fogDensity"].value = fog.density;

		}

	}

	refreshUniformsPhong ( uniforms, material ) {

		uniforms["shininess"].value = material.shininess;

		if ( gammaInput ) {

			uniforms["ambient"].value.copyGammaToLinear( material.ambient );
			uniforms["emissive"].value.copyGammaToLinear( material.emissive );
			uniforms["specular"].value.copyGammaToLinear( material.specular );

		} else {

			uniforms["ambient"].value = material.ambient;
			uniforms["emissive"].value = material.emissive;
			uniforms["specular"].value = material.specular;

		}

		if ( material.wrapAround ) {

			uniforms["wrapRGB"].value.copy( material.wrapRGB );

		}

	}

	refreshUniformsLambert ( uniforms, material ) {

		if ( gammaInput ) {

			uniforms["ambient"].value.copyGammaToLinear( material.ambient );
			uniforms["emissive"].value.copyGammaToLinear( material.emissive );

		} else {

			uniforms["ambient"].value = material.ambient;
			uniforms["emissive"].value = material.emissive;

		}

		if ( material.wrapAround ) {

			uniforms["wrapRGB"].value.copy( material.wrapRGB );

		}

	}

	refreshUniformsLights ( Map<String, Uniform> uniforms, Map lights ) {

		uniforms["ambientLightColor"].value = lights["ambient"];

		uniforms["directionalLightColor"].value = lights["directional"]["colors"];
		uniforms["directionalLightDirection"].value = lights["directional"]["positions"];

		uniforms["pointLightColor"].value = lights["point"]["colors"];
		uniforms["pointLightPosition"].value = lights["point"]["positions"];
		uniforms["pointLightDistance"].value = lights["point"]["distances"];

		uniforms["spotLightColor"].value = lights["spot"]["colors"];
		uniforms["spotLightPosition"].value = lights["spot"]["positions"];
		uniforms["spotLightDistance"].value = lights["spot"]["distances"];
		uniforms["spotLightDirection"].value = lights["spot"]["directions"];
		uniforms["spotLightAngle"].value = lights["spot"]["angles"];
		uniforms["spotLightExponent"].value = lights["spot"]["exponents"];

	}

	refreshUniformsShadow ( uniforms, lights ) {

		if ( uniforms.containsKey("shadowMatrix") ) {

			var j = 0;

			for ( var i = 0, il = lights.length; i < il; i ++ ) {

				var light = lights[ i ];

				if ( ! light.castShadow ) continue;

				if ( light is SpotLight || ( light is DirectionalLight && ! light.shadowCascade ) ) {

				  // Grow the arrays
				  if (uniforms["shadowMap"].texture.length < j + 1) {
				    uniforms["shadowMap"].texture.length = j + 1;
				    uniforms["shadowMapSize"].value.length = j + 1;
				    uniforms["shadowMatrix"].value.length = j + 1;
				    uniforms["shadowDarkness"].value.length = j + 1;
				    uniforms["shadowBias"].value.length = j + 1;
				  }

					uniforms["shadowMap"].texture[ j ] = light.shadowMap;
					uniforms["shadowMapSize"].value[ j ] = light.shadowMapSize;

					uniforms["shadowMatrix"].value[ j ] = light.shadowMatrix;

					uniforms["shadowDarkness"].value[ j ] = light.shadowDarkness;
					uniforms["shadowBias"].value[ j ] = light.shadowBias;

					j ++;

				}

			}

		}

	}

	// Uniforms (load to GPU)

	loadUniformsMatrices ( uniforms, WebGLObject object ) {

		_gl.uniformMatrix4fv( uniforms["modelViewMatrix"], false, object._modelViewMatrix.elements );

		if ( uniforms["normalMatrix"] != null ) {

			_gl.uniformMatrix3fv( uniforms["normalMatrix"], false, object._normalMatrix.elements );

		}

	}

	loadUniformsGeneric ( program, uniforms ) {

		var uniform, value, type, location, texture, i, il, j, jl, offset;

		jl = uniforms.length;
		for ( j = 0; j < jl; j ++ ) {

			location = program.uniforms[ uniforms[ j ][ 1 ] ];
			if ( location == null ) continue;

			uniform = uniforms[ j ][ 0 ];

			type = uniform.type;
			value = uniform.value;

			if ( type == "i" ) { // single integer

				_gl.uniform1i( location, value );

			} else if ( type == "f" ) { // single float

				_gl.uniform1f( location, value );

			} else if ( type == "v2" ) { // single THREE.Vector2

				_gl.uniform2f( location, value.x, value.y );

			} else if ( type == "v3" ) { // single THREE.Vector3

				_gl.uniform3f( location, value.x, value.y, value.z );

			} else if ( type == "v4" ) { // single THREE.Vector4

				_gl.uniform4f( location, value.x, value.y, value.z, value.w );

			} else if ( type == "c" ) { // single THREE.Color

				_gl.uniform3f( location, value.r, value.g, value.b );

			} else if ( type == "iv1" ) { // flat array of integers (JS or typed array)

				_gl.uniform1iv( location, (value is List) ? new Int32Array.fromList(value) : value );

			} else if ( type == "iv" ) { // flat array of integers with 3 x N size (JS or typed array)

				_gl.uniform3iv( location, (value is List) ? new Int32Array.fromList(value) : value );

			} else if ( type == "fv1" ) { // flat array of floats (JS or typed array)

				_gl.uniform1fv( location, (value is List) ? new Float32Array.fromList(value) : value );

			} else if ( type == "fv" ) { // flat array of floats with 3 x N size (JS or typed array)

				_gl.uniform3fv( location, (value is List) ? new Float32Array.fromList(value) : value );

			} else if ( type == "v2v" ) { // array of THREE.Vector2

				if ( uniform._array == null ) {

					uniform._array = new Float32Array( 2 * value.length );

				}

				il = value.length;
				for ( i = 0; i < il; i ++ ) {

					offset = i * 2;

					uniform._array[ offset ] 	 = value[ i ].x;
					uniform._array[ offset + 1 ] = value[ i ].y;

				}

				_gl.uniform2fv( location, uniform._array );

			} else if ( type == "v3v" ) { // array of THREE.Vector3

				if ( uniform._array == null ) {

					uniform._array = new Float32Array( 3 * value.length );

				}

				il = value.length;
				for ( i = 0; i < il; i ++ ) {

					offset = i * 3;

					uniform._array[ offset ] 	 = value[ i ].x;
					uniform._array[ offset + 1 ] = value[ i ].y;
					uniform._array[ offset + 2 ] = value[ i ].z;

				}

				_gl.uniform3fv( location, uniform._array );

			} else if ( type == "v4v" ) { // array of THREE.Vector4

				if ( uniform._array == null ) {

					uniform._array = new Float32Array( 4 * value.length );

				}

				il = value.length;
				for ( i = 0; i < il; i ++ ) {

					offset = i * 4;

					uniform._array[ offset ] 	 = value[ i ].x;
					uniform._array[ offset + 1 ] = value[ i ].y;
					uniform._array[ offset + 2 ] = value[ i ].z;
					uniform._array[ offset + 3 ] = value[ i ].w;

				}

				_gl.uniform4fv( location, uniform._array );

			} else if ( type == "m4") { // single THREE.Matrix4

				if ( uniform._array == null ) {

					uniform._array = new Float32Array( 16 );

				}

				value.flattenToArray( uniform._array );
				_gl.uniformMatrix4fv( location, false, uniform._array );

			} else if ( type == "m4v" ) { // array of THREE.Matrix4

				if ( uniform._array == null ) {

					uniform._array = new Float32Array( 16 * value.length );

				}

				il = value.length;
				for ( i = 0; i < il; i ++ ) {

					value[ i ].flattenToArrayOffset( uniform._array, i * 16 );

				}

				_gl.uniformMatrix4fv( location, false, uniform._array );

			} else if ( type == "t" ) { // single THREE.Texture (2d or cube)

				_gl.uniform1i( location, value );

				texture = uniform.texture;

				if ( texture == null ) continue;

				if ( (texture.image is ImageList || texture.image is WebGLImageList) && texture.image.length == 6 ) {

					setCubeTexture( texture, value );

				} else if ( texture is WebGLRenderTargetCube ) {

					setCubeTextureDynamic( texture, value );

				} else {

					setTexture( texture, value );

				}

			} else if ( type == "tv" ) { // array of THREE.Texture (2d)

				if ( uniform._array == null ) {

				  uniform._array = new Int32Array( uniform.texture.length );

					il = uniform.texture.length;
					for( i = 0; i < il; i ++ ) {

						uniform._array[ i ] = value + i;

					}

				}

				_gl.uniform1iv( location, uniform._array );

				il = uniform.texture.length;
				for( i = 0; i < il; i ++ ) {

					texture = uniform.texture[ i ];

					if ( texture == null) continue;

					setTexture( texture, uniform._array[ i ] );

				}

			}

		}

	}

	setupMatrices ( WebGLObject object, WebGLCamera camera ) {

		object._modelViewMatrix.multiply( camera.matrixWorldInverse, object.matrixWorld );

		object._normalMatrix.getInverse( object._modelViewMatrix );
		object._normalMatrix.transpose();

	}

	setupLights ( Program program, List<Light> lights ) {

		var l, ll, light, n,
		r = 0, g = 0, b = 0,
		color, position, intensity, distance,

		zlights = _lights;

		List dcolors = zlights["directional"]["colors"],
		     dpositions = zlights["directional"]["positions"],

		     pcolors = zlights["point"]["colors"],
		     ppositions = zlights["point"]["positions"],
      	 pdistances = zlights["point"]["distances"],

      	 scolors = zlights["spot"]["colors"],
      	 spositions = zlights["spot"]["positions"],
      	 sdistances = zlights["spot"]["distances"],
      	 sdirections = zlights["spot"]["directions"],
      	 sangles = zlights["spot"]["angles"],
      	 sexponents = zlights["spot"]["exponents"];

		var dlength = 0,
    		plength = 0,
    		slength = 0,

    		doffset = 0,
    		poffset = 0,
    		soffset = 0;

		ll = lights.length;
		for ( l = 0; l < ll; l ++ ) {

			light = lights[ l ];

			// TODO - Setup proper interfaces for Light to avoid type checks
			if ( (((light is DirectionalLight) || (light is SpotLight)) && (light as dynamic).onlyShadow) ||
			    ! light.visible ) { continue;
			}

			color = light.color;

			if ( (light is DirectionalLight) || (light is SpotLight) || (light is PointLight)) {
  			intensity = (light as dynamic).intensity;
  			distance = (light as dynamic).distance;
			}

			if ( light is AmbientLight ) {

				if ( gammaInput ) {

					r += color.r * color.r;
					g += color.g * color.g;
					b += color.b * color.b;

				} else {

					r += color.r;
					g += color.g;
					b += color.b;

				}

			} else if ( light is DirectionalLight ) {

				doffset = dlength * 3;

				// Grow the lists
				dcolors.length = doffset + 3;
				dpositions.length = doffset + 3;

				if ( gammaInput ) {

					dcolors[ doffset ]     = color.r * color.r * intensity * intensity;
					dcolors[ doffset + 1 ] = color.g * color.g * intensity * intensity;
					dcolors[ doffset + 2 ] = color.b * color.b * intensity * intensity;

				} else {

					dcolors[ doffset ]     = color.r * intensity;
					dcolors[ doffset + 1 ] = color.g * intensity;
					dcolors[ doffset + 2 ] = color.b * intensity;

				}

				_direction.copy( light.matrixWorld.getPosition() );
				_direction.subSelf( light.target.matrixWorld.getPosition() );
				_direction.normalize();

				dpositions[ doffset ]     = _direction.x;
				dpositions[ doffset + 1 ] = _direction.y;
				dpositions[ doffset + 2 ] = _direction.z;

				dlength += 1;

			} else if( light is PointLight ) {

				poffset = plength * 3;

        // Grow the lists
				pcolors.length = poffset + 3;
				ppositions.length = poffset + 3;

				if ( gammaInput ) {

					pcolors[ poffset ]     = color.r * color.r * intensity * intensity;
					pcolors[ poffset + 1 ] = color.g * color.g * intensity * intensity;
					pcolors[ poffset + 2 ] = color.b * color.b * intensity * intensity;

				} else {

					pcolors[ poffset ]     = color.r * intensity;
					pcolors[ poffset + 1 ] = color.g * intensity;
					pcolors[ poffset + 2 ] = color.b * intensity;

				}

				position = light.matrixWorld.getPosition();

				ppositions[ poffset ]     = position.x;
				ppositions[ poffset + 1 ] = position.y;
				ppositions[ poffset + 2 ] = position.z;

				if (pdistances==null) { pdistances = new List(); pdistances.add(0); }
				if (pdistances.length == 0) {pdistances.add(0);}
				pdistances[ plength ] = distance;

				plength += 1;

			} else if( light is SpotLight ) {

				soffset = slength * 3;

        // Grow the lists
				scolors.length = soffset + 3;
				spositions.length = soffset + 3;
				sdirections.length = soffset + 3;
				sdistances.length = slength + 1;

				if ( gammaInput ) {

					scolors[ soffset ]     = color.r * color.r * intensity * intensity;
					scolors[ soffset + 1 ] = color.g * color.g * intensity * intensity;
					scolors[ soffset + 2 ] = color.b * color.b * intensity * intensity;

				} else {

					scolors[ soffset ]     = color.r * intensity;
					scolors[ soffset + 1 ] = color.g * intensity;
					scolors[ soffset + 2 ] = color.b * intensity;

				}

				position = light.matrixWorld.getPosition();

				spositions[ soffset ]     = position.x;
				spositions[ soffset + 1 ] = position.y;
				spositions[ soffset + 2 ] = position.z;

				sdistances[ slength ] = distance;

				_direction.copy( position );
				_direction.subSelf( light.target.matrixWorld.getPosition() );
				_direction.normalize();

				sdirections[ soffset ]     = _direction.x;
				sdirections[ soffset + 1 ] = _direction.y;
				sdirections[ soffset + 2 ] = _direction.z;

				// grow the arrays
				sangles.length = slength + 1;
				sexponents.length = slength + 1;

				sangles[ slength ] = Math.cos( light.angle );
				sexponents[ slength ] = light.exponent;

				slength += 1;

			}

		}

		// null eventual remains from removed lights
		// (this is to avoid if in shader)

		ll = dcolors.length; for ( l = dlength * 3; l < ll; l ++ ) dcolors[ l ] = 0.0;
		ll = pcolors.length; for ( l = plength * 3; l < ll; l ++ ) pcolors[ l ] = 0.0;
		ll = scolors.length; for ( l = slength * 3; l < ll; l ++ ) scolors[ l ] = 0.0;

		zlights["directional"]["length"] = dlength;
		zlights["point"]["length"] = plength;
		zlights["spot"]["length"] = slength;

		zlights["ambient"][ 0 ] = r;
		zlights["ambient"][ 1 ] = g;
		zlights["ambient"][ 2 ] = b;

	}

	// GL state setting

	setFaceCulling( cullFace, frontFace ) {

		if ( cullFace ) {

			if ( !frontFace || frontFace == "ccw" ) {

				_gl.frontFace( gl.CCW );

			} else {

				_gl.frontFace( gl.CW );

			}

			if( cullFace == "back" ) {

				_gl.cullFace( gl.BACK );

			} else if( cullFace == "front" ) {

				_gl.cullFace( gl.FRONT );

			} else {

				_gl.cullFace( gl.FRONT_AND_BACK );

			}

			_gl.enable( gl.CULL_FACE );

		} else {

			_gl.disable( gl.CULL_FACE );

		}

	}

	setMaterialFaces( material ) {

		var doubleSided = material.side == DoubleSide;
		var flipSided = material.side == BackSide;

		if ( _oldDoubleSided != doubleSided ) {

			if ( doubleSided ) {

				_gl.disable( gl.CULL_FACE );

			} else {

				_gl.enable( gl.CULL_FACE );

			}

			_oldDoubleSided = doubleSided;

		}

		if ( _oldFlipSided != flipSided ) {

			if ( flipSided ) {

				_gl.frontFace( gl.CW );

			} else {

				_gl.frontFace( gl.CCW );

			}

			_oldFlipSided = flipSided;

		}

	}

	setDepthTest( depthTest ) {

		if ( _oldDepthTest != depthTest ) {

			if ( depthTest ) {

				_gl.enable( gl.DEPTH_TEST );

			} else {

				_gl.disable( gl.DEPTH_TEST );

			}

			_oldDepthTest = depthTest;

		}

	}

	setDepthWrite( depthWrite ) {

		if ( _oldDepthWrite != depthWrite ) {

			_gl.depthMask( depthWrite );
			_oldDepthWrite = depthWrite;

		}

	}

	setLineWidth ( width ) {

		if ( width != _oldLineWidth ) {

			_gl.lineWidth( width );

			_oldLineWidth = width;

		}

	}

	setPolygonOffset ( polygonoffset, factor, units ) {

		if ( _oldPolygonOffset != polygonoffset ) {

			if ( polygonoffset ) {

				_gl.enable( gl.POLYGON_OFFSET_FILL );

			} else {

				_gl.disable( gl.POLYGON_OFFSET_FILL );

			}

			_oldPolygonOffset = polygonoffset;

		}

		if ( polygonoffset && ( _oldPolygonOffsetFactor != factor || _oldPolygonOffsetUnits != units ) ) {

			_gl.polygonOffset( factor, units );

			_oldPolygonOffsetFactor = factor;
			_oldPolygonOffsetUnits = units;

		}

	}

	setBlending( blending, [blendEquation, blendSrc, blendDst] ) {

		if ( blending != _oldBlending ) {

			if ( blending == NoBlending ) {

				_gl.disable( gl.BLEND );

			} else if ( blending == AdditiveBlending ) {

				_gl.enable( gl.BLEND );
				_gl.blendEquation( gl.FUNC_ADD );
				_gl.blendFunc( gl.SRC_ALPHA, gl.ONE );

			} else if ( blending == SubtractiveBlending ) {

				// TODO: Find blendFuncSeparate() combination
				_gl.enable( gl.BLEND );
				_gl.blendEquation( gl.FUNC_ADD );
				_gl.blendFunc( gl.ZERO, gl.ONE_MINUS_SRC_COLOR );

			} else if ( blending == MultiplyBlending ) {

				// TODO: Find blendFuncSeparate() combination
				_gl.enable( gl.BLEND );
				_gl.blendEquation( gl.FUNC_ADD );
				_gl.blendFunc( gl.ZERO, gl.SRC_COLOR );

			} else if ( blending == CustomBlending ) {

				_gl.enable( gl.BLEND );

			} else {

				_gl.enable( gl.BLEND );
				_gl.blendEquationSeparate( gl.FUNC_ADD, gl.FUNC_ADD );
				_gl.blendFuncSeparate( gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE_MINUS_SRC_ALPHA );

			}

			_oldBlending = blending;

		}

		if ( blending == CustomBlending ) {

			if ( blendEquation != _oldBlendEquation ) {

				_gl.blendEquation( paramThreeToGL( blendEquation ) );

				_oldBlendEquation = blendEquation;

			}

			if ( blendSrc != _oldBlendSrc || blendDst != _oldBlendDst ) {

				_gl.blendFunc( paramThreeToGL( blendSrc ), paramThreeToGL( blendDst ) );

				_oldBlendSrc = blendSrc;
				_oldBlendDst = blendDst;

			}

		} else {

			_oldBlendEquation = null;
			_oldBlendSrc = null;
			_oldBlendDst = null;

		}

	}

	// Shaders

	Program buildProgram( String shaderID, String fragmentShader, String vertexShader, uniforms, attributes,
	                      {	int maxDirLights: 0,
					int maxPointLights: 0,
					int maxSpotLights: 0,
					int maxShadows: 0,
					int maxBones: 0,
					Texture map: null,
					Texture envMap: null,
					bool lightMap: false,
					bool bumpMap: false,
					bool specularMap: false,
					int vertexColors: NoColors,
					bool skinning: false,
					bool useVertexTexture: false,
					num boneTextureWidth: null,
					num boneTextureHeight: null,
					bool morphTargets: false,
					bool morphNormals: false,
					bool perPixel: false,
					bool wrapAround: false,
					bool doubleSided: false,
					bool shadowMapEnabled: false,
					bool shadowMapSoft: false,
					bool shadowMapDebug: false,
					bool shadowMapCascade: false,
					bool sizeAttenuation: false,
					Fog fog: null,
		      bool useFog: false,
		      int maxMorphTargets: 8,
		      int maxMorphNormals: 4,
		      num alphaTest: 0,
		      bool metal: false} ) {

		var p, pl, glprogram, code;
		var chunks = [];

		// Generate code

		if ( shaderID != null ) {

			chunks.add( shaderID );

		} else {

			chunks.add( fragmentShader );
			chunks.add( vertexShader );

		}

		code =  "${chunks.join()}"
		        "maxDirLights$maxDirLights"
		        "maxPointLights$maxPointLights"
		        "maxSpotLights$maxSpotLights"
		        "maxShadows$maxShadows"
		        "maxBones$maxBones"
		        "map$map"
		        "envMap$envMap"
		        "lightMap$lightMap"
		        "bumpMap$bumpMap"
		        "specularMap$specularMap"
		        "vertexColors$vertexColors"
		        "skinning$skinning"
		        "useVertexTexture$useVertexTexture"
		        "boneTextureWidth$boneTextureWidth"
		        "boneTextureHeight$boneTextureHeight"
		        "morphTargets$morphTargets"
            "morphNormals$morphNormals"
            "perPixel$perPixel"
            "wrapAround$wrapAround"
		        "doubleSided$doubleSided"
            "shadowMapEnabled$shadowMapEnabled"
            "shadowMapSoft$shadowMapSoft"
            "shadowMapDebug$shadowMapDebug"
		        "shadowMapCascade$shadowMapCascade"
            "sizeAttenuation$sizeAttenuation";


		// Check if code has been already compiled

		pl = _programs.length;
		for ( p = 0; p < pl; p ++ ) {

			Program program = _programs[ p ];

			// TODO - why do we need identical here ?!
      if ( program.code == code ) {

				//print( "Code already compiled: $program$code" );

			  program.usedTimes ++;

				return program;

			}

		}

		//print( "building new program " );

		//

		glprogram = _gl.createProgram();

		var prefix_vertex = [

			"precision $precision float;",

			supportsVertexTextures ? "#define VERTEX_TEXTURES" : "",

			gammaInput ? "#define GAMMA_INPUT" : "",
			gammaOutput ? "#define GAMMA_OUTPUT" : "",
			physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",

			"#define MAX_DIR_LIGHTS $maxDirLights",
			"#define MAX_POINT_LIGHTS $maxPointLights",
			"#define MAX_SPOT_LIGHTS $maxSpotLights",

			"#define MAX_SHADOWS $maxShadows",

			"#define MAX_BONES $maxBones",

			(map != null) ? "#define USE_MAP" : "",
			(envMap != null) ? "#define USE_ENVMAP" : "",
			(lightMap != null) ? "#define USE_LIGHTMAP" : "",
			(bumpMap != null) ? "#define USE_BUMPMAP" : "",
			(specularMap != null) ? "#define USE_SPECULARMAP" : "",
			(vertexColors != NoColors) ? "#define USE_COLOR" : "",

			skinning ? "#define USE_SKINNING" : "",
			useVertexTexture ? "#define BONE_TEXTURE" : "",
			(boneTextureWidth != null) ? "#define N_BONE_PIXEL_X ${boneTextureWidth.toStringAsFixed(1)}" : "",
			(boneTextureHeight != null) ? "#define N_BONE_PIXEL_Y ${boneTextureHeight.toStringAsFixed( 1 )}" : "",

			morphTargets ? "#define USE_MORPHTARGETS" : "",
			morphNormals ? "#define USE_MORPHNORMALS" : "",
			perPixel ? "#define PHONG_PER_PIXEL" : "",
			wrapAround ? "#define WRAP_AROUND" : "",
			doubleSided ? "#define DOUBLE_SIDED" : "",

			shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
			shadowMapSoft ? "#define SHADOWMAP_SOFT" : "",
			shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "",
			shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",

			sizeAttenuation ? "#define USE_SIZEATTENUATION" : "",

			"uniform mat4 modelMatrix;",
			"uniform mat4 modelViewMatrix;",
			"uniform mat4 projectionMatrix;",
			"uniform mat4 viewMatrix;",
			"uniform mat3 normalMatrix;",
			"uniform vec3 cameraPosition;",

			"attribute vec3 position;",
			"attribute vec3 normal;",
			"attribute vec2 uv;",
			"attribute vec2 uv2;",

			"#ifdef USE_COLOR",

				"attribute vec3 color;",

			"#endif",

			"#ifdef USE_MORPHTARGETS",

				"attribute vec3 morphTarget0;",
				"attribute vec3 morphTarget1;",
				"attribute vec3 morphTarget2;",
				"attribute vec3 morphTarget3;",

				"#ifdef USE_MORPHNORMALS",

					"attribute vec3 morphNormal0;",
					"attribute vec3 morphNormal1;",
					"attribute vec3 morphNormal2;",
					"attribute vec3 morphNormal3;",

				"#else",

					"attribute vec3 morphTarget4;",
					"attribute vec3 morphTarget5;",
					"attribute vec3 morphTarget6;",
					"attribute vec3 morphTarget7;",

				"#endif",

			"#endif",

			"#ifdef USE_SKINNING",

				"attribute vec4 skinVertexA;",
				"attribute vec4 skinVertexB;",
				"attribute vec4 skinIndex;",
				"attribute vec4 skinWeight;",

			"#endif",

			""

		].join("\n");

		var prefix_fragment = [

			"precision $precision float;",

			(bumpMap != null) ? "#extension GL_OES_standard_derivatives : enable" : "",

			"#define MAX_DIR_LIGHTS $maxDirLights",
			"#define MAX_POINT_LIGHTS $maxPointLights",
			"#define MAX_SPOT_LIGHTS $maxSpotLights",

			"#define MAX_SHADOWS $maxShadows",

			(alphaTest != 0) ? "#define ALPHATEST $alphaTest": "",

			gammaInput ? "#define GAMMA_INPUT" : "",
			gammaOutput ? "#define GAMMA_OUTPUT" : "",
			physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",

			( useFog && (fog != null) ) ? "#define USE_FOG" : "",
			( useFog && (fog is FogExp2) ) ? "#define FOG_EXP2" : "",

			(map != null) ? "#define USE_MAP" : "",
			(envMap != null) ? "#define USE_ENVMAP" : "",
			(lightMap != null) ? "#define USE_LIGHTMAP" : "",
			(bumpMap != null) ? "#define USE_BUMPMAP" : "",
			(specularMap != null) ? "#define USE_SPECULARMAP" : "",
			(vertexColors != NoColors) ? "#define USE_COLOR" : "",

			metal ? "#define METAL" : "",
			perPixel ? "#define PHONG_PER_PIXEL" : "",
			wrapAround ? "#define WRAP_AROUND" : "",
			doubleSided ? "#define DOUBLE_SIDED" : "",

			shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
			shadowMapSoft ? "#define SHADOWMAP_SOFT" : "",
			shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "",
			shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",

			"uniform mat4 viewMatrix;",
			"uniform vec3 cameraPosition;",
			""

		].join("\n");

		var glFragmentShader = getShader( "fragment", "$prefix_fragment$fragmentShader" );
		var glVertexShader = getShader( "vertex", "$prefix_vertex$vertexShader" );

		_gl.attachShader( glprogram, glVertexShader );
		_gl.attachShader( glprogram, glFragmentShader );

		_gl.linkProgram( glprogram );

		if ( !_gl.getProgramParameter( glprogram, gl.LINK_STATUS ) ) {

		  var status = _gl.getProgramParameter( glprogram, gl.VALIDATE_STATUS );
		  var error = _gl.getError();
			print( "Could not initialise shader\nVALIDATE_STATUS: $status, gl error [$error]" );

		}

		// clean up

		_gl.deleteShader( glFragmentShader );
		_gl.deleteShader( glVertexShader );

		//console.log( prefix_fragment + fragmentShader );
		//console.log( prefix_vertex + vertexShader );

		//program.uniforms = {};
		//program.attributes = {};

		var program = new Program( _programs_counter++,  glprogram, code, usedTimes: 1 );

		var identifiers, u, a, i;

		// cache uniform locations

		identifiers = [

			'viewMatrix', 'modelViewMatrix', 'projectionMatrix', 'normalMatrix', 'modelMatrix', 'cameraPosition',
			'morphTargetInfluences'

		];

		if ( useVertexTexture ) {

			identifiers.add( 'boneTexture' );

		} else {

			identifiers.add( 'boneGlobalMatrices' );

		}

		uniforms.forEach((u, _) => identifiers.add( u ));

		cacheUniformLocations( program, identifiers );

		// cache attributes locations

		identifiers = [

			"position", "normal", "uv", "uv2", "tangent", "color",
			"skinVertexA", "skinVertexB", "skinIndex", "skinWeight"

		];

		for ( i = 0; i < maxMorphTargets; i ++ ) {

			identifiers.add( "morphTarget$i" );

		}

		for ( i = 0; i < maxMorphNormals; i ++ ) {

			identifiers.add( "morphNormal$i" );

		}

		if (attributes != null) {
		  attributes.forEach((a, _) => identifiers.add( a ));
		}

		cacheAttributeLocations( program, identifiers );

		_programs.add( program );

		info.memory.programs = _programs.length;

		return program;

	}

	// Shader parameters cache

	cacheUniformLocations ( program, identifiers ) {

		var i, l, id;

		l = identifiers.length;
		for( i = 0; i < l; i ++ ) {

			id = identifiers[ i ];
			program.uniforms[ id ] = _gl.getUniformLocation( program.glProgram, id );

		}

	}

	cacheAttributeLocations ( program, identifiers ) {

		var i, l, id;

		l = identifiers.length;
		for( i = 0; i < l; i ++ ) {

			id = identifiers[ i ];
			program.attributes[ id ] = _gl.getAttribLocation( program.glProgram, id );

		}

	}

	addLineNumbers ( string ) {

		var chunks = string.split( "\n" );

		var il = chunks.length;
		for ( var i = 0; i < il; i ++ ) {

			// Chrome reports shader errors on lines
			// starting counting from 1

			chunks[ i ] = "${i + 1}:${chunks[i]}";

		}

		return chunks.join( "\n" );

	}

	getShader ( type, string ) {

		var shader;

		if ( type == "fragment" ) {

			shader = _gl.createShader( gl.FRAGMENT_SHADER );

		} else if ( type == "vertex" ) {

			shader = _gl.createShader( gl.VERTEX_SHADER );

		}

		_gl.shaderSource( shader, string );
		_gl.compileShader( shader );

		if ( !_gl.getShaderParameter( shader, gl.COMPILE_STATUS ) ) {

			print( _gl.getShaderInfoLog( shader ) );
			print( addLineNumbers( string ) );
			return null;

		}

		return shader;

	}

	// Textures


	isPowerOfTwo ( value ) => ( value & ( value - 1 ) ) == 0;

	setTextureParameters ( textureType, texture, isImagePowerOfTwo ) {

		if ( isImagePowerOfTwo ) {

			_gl.texParameteri( textureType, gl.TEXTURE_WRAP_S, paramThreeToGL( texture.wrapS ) );
			_gl.texParameteri( textureType, gl.TEXTURE_WRAP_T, paramThreeToGL( texture.wrapT ) );

			_gl.texParameteri( textureType, gl.TEXTURE_MAG_FILTER, paramThreeToGL( texture.magFilter ) );
			_gl.texParameteri( textureType, gl.TEXTURE_MIN_FILTER, paramThreeToGL( texture.minFilter ) );

		} else {

			_gl.texParameteri( textureType, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE );
			_gl.texParameteri( textureType, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE );

			_gl.texParameteri( textureType, gl.TEXTURE_MAG_FILTER, filterFallback( texture.magFilter ) );
			_gl.texParameteri( textureType, gl.TEXTURE_MIN_FILTER, filterFallback( texture.minFilter ) );

		}

		if ( (_glExtensionTextureFilterAnisotropic != null) && texture.type != FloatType ) {

			if ( texture.anisotropy > 1 || ( texture["__oldAnisotropy"] != null) ) {

				_gl.texParameterf( textureType, gl.ExtTextureFilterAnisotropic.TEXTURE_MAX_ANISOTROPY_EXT, Math.min( texture.anisotropy, maxAnisotropy ) );
				texture["__oldAnisotropy"] = texture.anisotropy;

			}

		}

	}

	_checkGLError() {
    int error = _gl.getError();
    if (error != 0) {
      print( "gl error [$error]" );
    }
	}

	setTexture( Texture texture, slot ) {

		if ( texture.needsUpdate ) {

			if ( texture["__webglInit"] == null ) {

				texture["__webglInit"] = true;
				texture["__webglTexture"] = _gl.createTexture();

				info.memory.textures ++;

			}

			_gl.activeTexture( gl.TEXTURE0 + slot );
			_gl.bindTexture( gl.TEXTURE_2D, texture["__webglTexture"] );

			_gl.pixelStorei( gl.UNPACK_FLIP_Y_WEBGL, (texture.flipY) ? 1 : 0 );
			_gl.pixelStorei( gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, (texture.premultiplyAlpha) ? 1 : 0 );

			var image = texture.image,
			isImagePowerOfTwo = isPowerOfTwo( image.width ) && isPowerOfTwo( image.height ),
			glFormat = paramThreeToGL( texture.format ),
			glType = paramThreeToGL( texture.type );

			setTextureParameters( gl.TEXTURE_2D, texture, isImagePowerOfTwo );

			if ( texture is DataTexture ) {

				_gl.texImage2D( gl.TEXTURE_2D, 0, glFormat, image.width, image.height, 0, glFormat, glType, image.data );

			} else {

				_gl.texImage2D( gl.TEXTURE_2D, 0, glFormat, glFormat, glType, texture.image );

			}

			if ( texture.generateMipmaps && isImagePowerOfTwo ) _gl.generateMipmap( gl.TEXTURE_2D );

			texture.needsUpdate = false;

			if ( texture.onUpdate != null ) texture.onUpdate();

		} else {

			_gl.activeTexture( gl.TEXTURE0 + slot );
			_gl.bindTexture( gl.TEXTURE_2D, texture["__webglTexture"] );

		}

	}

	clampToMaxSize ( image, maxSize ) {

		if ( image.width <= maxSize && image.height <= maxSize ) {

			return image;

		}

		// Warning: Scaling through the canvas will only work with images that use
		// premultiplied alpha.

		var maxDimension = Math.max( image.width, image.height );
		var newWidth = ( image.width * maxSize / maxDimension ).floor();
		var newHeight = ( image.height * maxSize / maxDimension ).floor();

		var canvas = new CanvasElement();
		canvas.width = newWidth;
		canvas.height = newHeight;

		var ctx = canvas.context2d;
		ctx.drawImageScaledFromSource( image, 0, 0, image.width, image.height, 0, 0, newWidth, newHeight );

		return canvas;

	}

	setCubeTexture ( Texture texture, slot ) {

		if ( texture.image.length == 6 ) {
		  if(texture.image is ImageList){
		    texture.image = new WebGLImageList(texture.image);
		  }
			if ( texture.needsUpdate ) {

				if ( texture.image.webglTextureCube == null ) {

					texture.image.webglTextureCube = _gl.createTexture();

				}

				_gl.activeTexture( gl.TEXTURE0 + slot );
				_gl.bindTexture( gl.TEXTURE_CUBE_MAP, texture.image.webglTextureCube);

				_gl.pixelStorei( gl.UNPACK_FLIP_Y_WEBGL, (texture.flipY) ? 1 : 0 );

				var cubeImage = new List(6);

				for ( var i = 0; i < 6; i ++ ) {

					if ( autoScaleCubemaps ) {

						cubeImage[ i ] = clampToMaxSize( texture.image[ i ], maxCubemapSize );

					} else {

						cubeImage[ i ] = texture.image[ i ];

					}

				}

				var image = cubeImage[ 0 ],
				isImagePowerOfTwo = isPowerOfTwo( (image as dynamic).width ) && isPowerOfTwo( (image as dynamic).height ),
				glFormat = paramThreeToGL( texture.format ),
				glType = paramThreeToGL( texture.type );

				setTextureParameters( gl.TEXTURE_CUBE_MAP, texture, isImagePowerOfTwo );

				for ( var i = 0; i < 6; i ++ ) {

					_gl.texImage2D( gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, glFormat, glType, cubeImage[ i ] );

				}

				if ( texture.generateMipmaps && isImagePowerOfTwo ) {

					_gl.generateMipmap( gl.TEXTURE_CUBE_MAP );

				}

				texture.needsUpdate = false;

				if ( texture.onUpdate != null) texture.onUpdate();

			} else {

				_gl.activeTexture( gl.TEXTURE0 + slot );
				_gl.bindTexture( gl.TEXTURE_CUBE_MAP, texture.image.webglTextureCube );

			}

		}

	}

	setCubeTextureDynamic ( texture, slot ) {

		_gl.activeTexture( gl.TEXTURE0 + slot );
		_gl.bindTexture( gl.TEXTURE_CUBE_MAP, texture["__webglTexture"] );

	}

	// Render targets

	setupFrameBuffer ( framebuffer, renderTarget, textureTarget ) {

		_gl.bindFramebuffer( gl.FRAMEBUFFER, framebuffer );
		_gl.framebufferTexture2D( gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, textureTarget, renderTarget.__webglTexture, 0 );

	}

	setupRenderBuffer ( renderbuffer, renderTarget  ) {

		_gl.bindRenderbuffer( gl.RENDERBUFFER, renderbuffer );

		if ( renderTarget.depthBuffer && ! renderTarget.stencilBuffer ) {

			_gl.renderbufferStorage( gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, renderTarget.width, renderTarget.height );
			_gl.framebufferRenderbuffer( gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, renderbuffer );

		/* For some reason this is not working. Defaulting to RGBA4.
		} else if( ! renderTarget.depthBuffer && renderTarget.stencilBuffer ) {

			_gl.renderbufferStorage( gl.RENDERBUFFER, gl.STENCIL_INDEX8, renderTarget.width, renderTarget.height );
			_gl.framebufferRenderbuffer( gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, WebGLRenderingContext.RENDERBUFFER, renderbuffer );
		*/
		} else if( renderTarget.depthBuffer && renderTarget.stencilBuffer ) {

			_gl.renderbufferStorage( gl.RENDERBUFFER, gl.DEPTH_STENCIL, renderTarget.width, renderTarget.height );
			_gl.framebufferRenderbuffer( gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, renderbuffer );

		} else {

			_gl.renderbufferStorage( gl.RENDERBUFFER, gl.RGBA4, renderTarget.width, renderTarget.height );

		}

	}

	setRenderTarget ( WebGLRenderTarget renderTarget ) {

		var isCube = ( renderTarget is WebGLRenderTargetCube );

		if ( (renderTarget != null ) && ( renderTarget.__webglFramebuffer == null) ) {

			if ( renderTarget.depthBuffer == null ) renderTarget.depthBuffer = true;
			if ( renderTarget.stencilBuffer == null ) renderTarget.stencilBuffer = true;

			renderTarget.__webglTexture = _gl.createTexture();

			// Setup texture, create render and frame buffers

			var isTargetPowerOfTwo = isPowerOfTwo( renderTarget.width ) && isPowerOfTwo( renderTarget.height ),
				glFormat = paramThreeToGL( renderTarget.format ),
				glType = paramThreeToGL( renderTarget.type );

			if ( isCube ) {

				renderTarget.__webglFramebuffer = [];
				renderTarget.__webglRenderbuffer = [];

				_gl.bindTexture( gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture );
				setTextureParameters( gl.TEXTURE_CUBE_MAP, renderTarget, isTargetPowerOfTwo );

				for ( var i = 0; i < 6; i ++ ) {

					renderTarget.__webglFramebuffer[ i ] = _gl.createFramebuffer();
					renderTarget.__webglRenderbuffer[ i ] = _gl.createRenderbuffer();

					_gl.texImage2D( gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null );

					setupFrameBuffer( renderTarget.__webglFramebuffer[ i ], renderTarget, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i );
					setupRenderBuffer( renderTarget.__webglRenderbuffer[ i ], renderTarget );

				}

				if ( isTargetPowerOfTwo ) _gl.generateMipmap( gl.TEXTURE_CUBE_MAP );

			} else {

				renderTarget.__webglFramebuffer = _gl.createFramebuffer();
				renderTarget.__webglRenderbuffer = _gl.createRenderbuffer();

				_gl.bindTexture( gl.TEXTURE_2D, renderTarget.__webglTexture );
				setTextureParameters( gl.TEXTURE_2D, renderTarget, isTargetPowerOfTwo );

				_gl.texImage2D( gl.TEXTURE_2D, 0, glFormat, renderTarget.width, renderTarget.height, 0, glFormat, glType, null );

				setupFrameBuffer( renderTarget.__webglFramebuffer, renderTarget, gl.TEXTURE_2D );
				setupRenderBuffer( renderTarget.__webglRenderbuffer, renderTarget );

				if ( isTargetPowerOfTwo ) _gl.generateMipmap( gl.TEXTURE_2D );

			}

			// Release everything

			if ( isCube ) {

				_gl.bindTexture( gl.TEXTURE_CUBE_MAP, null );

			} else {

				_gl.bindTexture( gl.TEXTURE_2D, null );

			}

			_gl.bindRenderbuffer( gl.RENDERBUFFER, null );
			_gl.bindFramebuffer( gl.FRAMEBUFFER, null);

		}

		var framebuffer, width, height, vx, vy;

		if ( renderTarget != null ) {

			if ( isCube ) {

				framebuffer = renderTarget.__webglFramebuffer[ (renderTarget as WebGLRenderTargetCube).activeCubeFace ];

			} else {

				framebuffer = renderTarget.__webglFramebuffer;

			}

			width = renderTarget.width;
			height = renderTarget.height;

			vx = 0;
			vy = 0;

		} else {

			framebuffer = null;

			width = _viewportWidth;
			height = _viewportHeight;

			vx = _viewportX;
			vy = _viewportY;

		}

    if ( !identical(framebuffer, _currentFramebuffer) ) {

			_gl.bindFramebuffer( gl.FRAMEBUFFER, framebuffer );
			_gl.viewport( vx, vy, width, height );

			_currentFramebuffer = framebuffer;

		}

		_currentWidth = width;
		_currentHeight = height;

	}

	updateRenderTargetMipmap ( renderTarget ) {

		if ( renderTarget is WebGLRenderTargetCube ) {

			_gl.bindTexture( gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture );
			_gl.generateMipmap( gl.TEXTURE_CUBE_MAP );
			_gl.bindTexture( gl.TEXTURE_CUBE_MAP, null );

		} else {

			_gl.bindTexture( gl.TEXTURE_2D, renderTarget.__webglTexture );
			_gl.generateMipmap( gl.TEXTURE_2D );
			_gl.bindTexture( gl.TEXTURE_2D, null );

		}

	}

	// Fallback filters for non-power-of-2 textures

	filterFallback ( f ) {

		if ( f == NearestFilter || f == NearestMipMapNearestFilter || f == NearestMipMapLinearFilter ) {

			return gl.NEAREST;

		}

		return gl.LINEAR;

	}

	// Map three.js constants to WebGL constants

	paramThreeToGL ( p ) {

		if ( p == RepeatWrapping ) return gl.REPEAT;
		if ( p == ClampToEdgeWrapping ) return gl.CLAMP_TO_EDGE;
		if ( p == MirroredRepeatWrapping ) return gl.MIRRORED_REPEAT;

		if ( p == NearestFilter ) return gl.NEAREST;
		if ( p == NearestMipMapNearestFilter ) return gl.NEAREST_MIPMAP_NEAREST;
		if ( p == NearestMipMapLinearFilter ) return gl.NEAREST_MIPMAP_LINEAR;

		if ( p == LinearFilter ) return gl.LINEAR;
		if ( p == LinearMipMapNearestFilter ) return gl.LINEAR_MIPMAP_NEAREST;
		if ( p == LinearMipMapLinearFilter ) return gl.LINEAR_MIPMAP_LINEAR;

		if ( p == UnsignedByteType ) return gl.UNSIGNED_BYTE;
		if ( p == UnsignedShort4444Type ) return gl.UNSIGNED_SHORT_4_4_4_4;
		if ( p == UnsignedShort5551Type ) return gl.UNSIGNED_SHORT_5_5_5_1;
		if ( p == UnsignedShort565Type ) return gl.UNSIGNED_SHORT_5_6_5;

		if ( p == ByteType ) return gl.BYTE;
		if ( p == ShortType ) return gl.SHORT;
		if ( p == UnsignedShortType ) return gl.UNSIGNED_SHORT;
		if ( p == IntType ) return gl.INT;
		if ( p == UnsignedIntType ) return gl.UNSIGNED_INT;
		if ( p == FloatType ) return gl.FLOAT;

		if ( p == AlphaFormat ) return gl.ALPHA;
		if ( p == RGBFormat ) return gl.RGB;
		if ( p == RGBAFormat ) return gl.RGBA;
		if ( p == LuminanceFormat ) return gl.LUMINANCE;
		if ( p == LuminanceAlphaFormat ) return gl.LUMINANCE_ALPHA;

		if ( p == AddEquation ) return gl.FUNC_ADD;
		if ( p == SubtractEquation ) return gl.FUNC_SUBTRACT;
		if ( p == ReverseSubtractEquation ) return gl.FUNC_REVERSE_SUBTRACT;

		if ( p == ZeroFactor ) return gl.ZERO;
		if ( p == OneFactor ) return gl.ONE;
		if ( p == SrcColorFactor ) return gl.SRC_COLOR;
		if ( p == OneMinusSrcColorFactor ) return gl.ONE_MINUS_SRC_COLOR;
		if ( p == SrcAlphaFactor ) return gl.SRC_ALPHA;
		if ( p == OneMinusSrcAlphaFactor ) return gl.ONE_MINUS_SRC_ALPHA;
		if ( p == DstAlphaFactor ) return gl.DST_ALPHA;
		if ( p == OneMinusDstAlphaFactor ) return gl.ONE_MINUS_DST_ALPHA;

		if ( p == DstColorFactor ) return gl.DST_COLOR;
		if ( p == OneMinusDstColorFactor ) return gl.ONE_MINUS_DST_COLOR;
		if ( p == SrcAlphaSaturateFactor ) return gl.SRC_ALPHA_SATURATE;

		print("[paramThreeToGL] Unknown param $p");
		return 0;

	}

	// Allocations

	int allocateBones ( Object3D object ) {

		if ( supportsBoneTextures && (object != null) && (object is SkinnedMesh) && (object as SkinnedMesh).useVertexTexture ) {

			return 1024;

		} else {

			// default for when object is not specified
			// ( for example when prebuilding shader
			//   to be used with multiple objects )
			//
			// 	- leave some extra space for other uniforms
			//  - limit here is ANGLE's 254 max uniform vectors
			//    (up to 54 should be safe)

			int nVertexUniforms = _gl.getParameter( gl.MAX_VERTEX_UNIFORM_VECTORS );
			int nVertexMatrices = ( ( nVertexUniforms - 20 ) / 4 ).floor().toInt();

			var maxBones = nVertexMatrices;

			if ( object != null && object is SkinnedMesh ) {

				maxBones = Math.min( object.bones.length, maxBones );

				if ( maxBones < object.bones.length ) {

					print( "WebGLRenderer: too many bones - ${object.bones.length} , this GPU supports just $maxBones  (try OpenGL instead of ANGLE)" );

				}

			}

			return maxBones;

		}

	}

	allocateLights ( List<Light> lights ) {

		var l, ll, light, dirLights, pointLights, spotLights, maxDirLights, maxPointLights, maxSpotLights;

		dirLights = pointLights = spotLights = maxDirLights = maxPointLights = maxSpotLights = 0;

		ll = lights.length;
		for ( l = 0; l < ll; l ++ ) {

			light = lights[ l ];

			if ( (( light is DirectionalLight ) || ( light is SpotLight )) &&
			    (light as dynamic).onlyShadow ) { continue;
			}

			if ( light is DirectionalLight ) dirLights ++;
			if ( light is PointLight ) pointLights ++;
			if ( light is SpotLight ) spotLights ++;

		}

		if ( ( pointLights + spotLights + dirLights ) <= maxLights ) {

			maxDirLights = dirLights;
			maxPointLights = pointLights;
			maxSpotLights = spotLights;

		} else {

			maxDirLights = ( maxLights * dirLights / ( pointLights + dirLights ) ).ceil();
			maxPointLights = maxLights - maxDirLights;
			maxSpotLights = maxPointLights; // this is not really correct

		}

		return { 'directional' : maxDirLights, 'point' : maxPointLights, 'spot': maxSpotLights };

	}

	allocateShadows ( lights ) {

		var l, ll, light, maxShadows = 0;

		ll = lights.length;
		for ( l = 0; l < ll; l++ ) {

			light = lights[ l ];

			if ( ! light.castShadow ) continue;

			if ( light is SpotLight ) maxShadows ++;
			if ( light is DirectionalLight && ! light.shadowCascade ) maxShadows ++;

		}

		return maxShadows;

	}

	// Initialization

	initGL () {

		try {
			_gl = canvas.getContext3d(alpha: alpha, premultipliedAlpha: premultipliedAlpha, antialias: antialias, stencil: stencil, preserveDrawingBuffer: preserveDrawingBuffer );
			if ( _gl == null ) {

				throw 'Error creating WebGL context.';

			}
		} catch ( error ) {

			print( error );

		}
		_glExtensionTextureFloat = _gl.getExtension( 'OES_texture_float' );
		_glExtensionStandardDerivatives = _gl.getExtension( 'OES_standard_derivatives' );

		_glExtensionTextureFilterAnisotropic = _gl.getExtension( 'EXT_texture_filter_anisotropic' );
		if (_glExtensionTextureFilterAnisotropic == null) {
		  _glExtensionTextureFilterAnisotropic = _gl.getExtension( 'MOZ_EXT_texture_filter_anisotropic' );
		}
		if (_glExtensionTextureFilterAnisotropic == null) {
		  _glExtensionTextureFilterAnisotropic = _gl.getExtension( 'WEBKIT_EXT_texture_filter_anisotropic' );
		}


		if ( _glExtensionTextureFloat == null ) {

			print( 'THREE.WebGLRenderer: Float textures not supported.' );

		}

		if ( _glExtensionStandardDerivatives == null ) {

		  print( 'THREE.WebGLRenderer: Standard derivatives not supported.' );

		}

		if ( _glExtensionTextureFilterAnisotropic == null ) {

		  print( 'THREE.WebGLRenderer: Anisotropic texture filtering not supported.' );

		}

	}

	setDefaultGLState () {

		_gl.clearColor( 0, 0, 0, 1 );
		_gl.clearDepth( 1 );
		_gl.clearStencil( 0 );

		_gl.enable( gl.DEPTH_TEST );
		_gl.depthFunc( gl.LEQUAL );

		_gl.frontFace( gl.CCW );
		_gl.cullFace( gl.BACK );
		_gl.enable( gl.CULL_FACE );

		_gl.enable( gl.BLEND );
		_gl.blendEquation( gl.FUNC_ADD );
		_gl.blendFunc( gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA );

		_gl.clearColor( clearColor.r, clearColor.g, clearColor.b, clearAlpha );

	}


}

//
// Rendering Info classes by nelsonsilva
//
class WebGLRendererInfo {
	WebGLRendererMemoryInfo memory;
	WebGLRendererRenderInfo render;

	WebGLRendererInfo() {
		memory = new WebGLRendererMemoryInfo();
		render = new WebGLRendererRenderInfo();
	}
}

class WebGLRendererMemoryInfo {
	int programs = 0,
	    geometries = 0,
	    textures = 0;
}

class WebGLRendererRenderInfo {
	int calls = 0,
	    vertices = 0,
	    faces = 0,
	    points = 0;
}

//
// Wrapper classes for WebGL stuff by nelsonsilva
//
class Program {
	int id;
	gl.Program glProgram;
	String code;
	int usedTimes;
	Map attributes;
	Map uniforms;

	Program( this.id, this.glProgram, this.code, {this.usedTimes: 0} ) : uniforms = {}, attributes = {};
}

class Buffer {
  gl.Buffer glbuffer;
  var belongsToAttribute;
  Buffer(this.glbuffer);
}

//
// Wrapper classes for Object3D, Geometry and Material by nelsonsilva
//
// TODO - Try to use an expando and implement the interfaces
//
class WebGLObject {

  bool __webglInit = false;
  var __webglActive;

  Matrix4 _modelViewMatrix;
  Matrix3 _normalMatrix;

  var _normalMatrixArray;
  var _modelViewMatrixArray;
  var modelMatrixArray;

  WebGLGeometry buffer;
	Object3D object;
	WebGLMaterial opaque, transparent;
	bool render;
	var z;

	var __webglMorphTargetInfluences;

	WebGLObject._internal(this.object, this.opaque, this.transparent, this.buffer, this.render, this.z) ;

	factory WebGLObject(Object3D object, {WebGLMaterial opaque,
	                                      WebGLMaterial transparent,
	                                      WebGLGeometry buffer,
	                                      bool render: true,
	                                      num z: 0}) {
	  if (object["__webglObject"] == null) {
      var webglObject = new WebGLObject._internal(object, opaque, transparent, buffer, render, z );
      object["__webglObject"] = webglObject;
    }

    return object["__webglObject"];
	}

	Geometry get geometry => _hasGeometry ? (object as dynamic).geometry : null;
	WebGLGeometry get webglgeometry => geometry != null ? new WebGLGeometry.from(geometry) : null;

	Material get material => (object as dynamic).material;
  WebGLMaterial get webglmaterial => new WebGLMaterial.from(material);

  get matrixWorld => object.matrixWorld;

  get _hasGeometry => (object is Mesh) || (object is ParticleSystem) || (object is Line);

  get morphTargetBase => (object as dynamic).morphTargetBase;

  get receiveShadow => object.receiveShadow;

  get morphTargetForcedOrder => (object as Mesh).morphTargetForcedOrder;
  get morphTargetInfluences => (object as Mesh).morphTargetInfluences;

  // only SkinnedMesh
  get useVertexTexture => (object as dynamic).useVertexTexture;
  get boneMatrices => (object as dynamic).boneMatrices;
  get boneTexture => (object as dynamic).boneTexture;

}

class WebGLGeometry {

  int id;

  int _vertices;

  List faces3, faces4;
  int materialIndex, numMorphTargets, numMorphNormals;

  var geometryGroups, geometryGroupsList;
  var
    morphTargetsNeedUpdate,
    elementsNeedUpdate,
    uvsNeedUpdate,
    normalsNeedUpdate,
    tangentsNeedUpdate,
    colorsNeedUpdate;

  bool __inittedArrays;
  Float32Array __vertexArray,
               __normalArray,
               __tangentArray,
               __colorArray,
               __uvArray,
               __uv2Array,
               __skinVertexAArray,
               __skinVertexBArray,
               __skinIndexArray,
               __skinWeightArray;
  Uint16Array __faceArray, __lineArray;
  List<Float32Array> __morphTargetsArrays, __morphNormalsArrays;
  int __webglFaceCount, __webglLineCount, __webglParticleCount, __webglVertexCount;

  List __sortArray;

  var __webglCustomAttributesList;

  gl.Buffer __webglVertexBuffer,
              __webglNormalBuffer,
              __webglTangentBuffer,
              __webglColorBuffer,
              __webglUVBuffer,
              __webglUV2Buffer,

              __webglSkinVertexABuffer,
              __webglSkinVertexBBuffer,
              __webglSkinIndicesBuffer,
              __webglSkinWeightsBuffer,

              __webglFaceBuffer,
              __webglLineBuffer;

  List <gl.Buffer> __webglMorphTargetsBuffers, __webglMorphNormalsBuffers;

  Geometry _geometry;

  WebGLGeometry({ this.faces3,
                  this.faces4,
                  this.materialIndex: 0,
                  int vertices: null,
                  this.numMorphTargets: 0,
                  this.numMorphNormals: 0}) : _vertices = vertices;

  WebGLGeometry._internal(Geometry geometry)
  :   _geometry = geometry,
      _vertices = null, // Delegate vertices to geometry
      id = geometry.id,
      materialIndex = 0,
      numMorphTargets = 0,
      numMorphNormals = 0;

  factory WebGLGeometry.from(Geometry geometry) {
    if (geometry["__webglBuffer"] == null) {
      var __webglBuffer = new WebGLGeometry._internal(geometry);
      geometry["__webglBuffer"] = __webglBuffer;
    }

    return geometry["__webglBuffer"];
  }

  // This is weird since vertices can be a List from geometry or a number
  set vertices(int n) => _vertices = n;
  get vertices {
    if (_vertices == null && _geometry != null) {
      return _geometry.vertices;
    }
    return _vertices;
  }

  get verticesNeedUpdate => _geometry["verticesNeedUpdate"];
  set verticesNeedUpdate(bool flag) { _geometry["verticesNeedUpdate"] = flag; }

  get morphTargets => _geometry.morphTargets;
  get morphNormals => _geometry.morphNormals;

  get faces => _geometry.faces;

  get isDynamic => _geometry.isDynamic;

  get faceVertexUvs => _geometry.faceVertexUvs;
  get colors => _geometry.colors;
  get skinIndices => _geometry.skinIndices;
  get skinWeights => _geometry.skinWeights;
  get skinVerticesA => _geometry["skinVerticesA"];
  get skinVerticesB => _geometry["skinVerticesB"];

  get hasTangents => _geometry.hasTangents;

}

class WebGLMaterial { // implements Material {
  Material _material;

  var program;
  var _fragmentShader;
  var _vertexShader;
  var _uniforms;
  var uniformsList;

  num numSupportedMorphTargets = 0, numSupportedMorphNormals = 0;

  // Used by ShadowMapPlugin
  bool shadowPass = false;

  WebGLMaterial._internal(Material material) : _material = material;

  factory WebGLMaterial.from(Material material) {

    if (material["__webglMaterial"] == null) {
      var webglMaterial = new WebGLMaterial._internal(material);
      material["__webglMaterial"] = webglMaterial;
    }

    return material["__webglMaterial"];
  }

  get attributes => (isShaderMaterial)? (_material as ShaderMaterial).attributes : null;
  get fragmentShader => (isShaderMaterial)? (_material as ShaderMaterial).fragmentShader : _fragmentShader;
  get vertexShader => (isShaderMaterial)? (_material as ShaderMaterial).vertexShader : _vertexShader;
  get uniforms => (isShaderMaterial)? (_material as ShaderMaterial).uniforms : _uniforms;
  set fragmentShader(v) => (isShaderMaterial)? (_material as ShaderMaterial).fragmentShader = v : _fragmentShader = v;
  set vertexShader(v) => (isShaderMaterial)? (_material as ShaderMaterial).vertexShader = v: _vertexShader = v;
  set uniforms(v) => (isShaderMaterial)? (_material as ShaderMaterial).uniforms = v : _uniforms = v;

  bool get needsSmoothNormals
    => (_material != null) && (shading != null) && (shading == SmoothShading);

  // only MeshBasicMaterial and MeshDepthMaterial don't need normals
  bool get needsNormals
    => ! (( _material is MeshBasicMaterial && (envMap == null) ) || _material is MeshDepthMaterial);

  String get name => _material.name;
  int get id => _material.id;
  int get side => _material.side;
  num get opacity => _material.opacity;
  int get blending => _material.blending;
  int get blendSrc => _material.blendSrc;
  int get blendDst => _material.blendDst;
  int get blendEquation => _material.blendEquation;
  num get alphaTest => _material.alphaTest;
  int get polygonOffsetFactor => _material.polygonOffsetFactor;
  int get polygonOffsetUnits => _material.polygonOffsetUnits;
  bool get transparent => _material.transparent;
  bool get depthTest => _material.depthTest;
  bool get depthWrite => _material.depthWrite;
  bool get polygonOffset => _material.polygonOffset;
  bool get overdraw => _material.overdraw;
  bool get visible => _material.visible;
  bool get needsUpdate => _material.needsUpdate;
  set needsUpdate(bool flag) => _material.needsUpdate = flag;


  // TODO - Define proper interfaces to remove use of Dynamic
  int get vertexColors => _hasVertexColors ? (_material as dynamic).vertexColors : NoColors;
  get color => (_material as dynamic).color;
  get ambient => (_material as dynamic).ambient;
  get emissive => (_material as dynamic).emissive;

  get shininess => (isMeshPhongMaterial) ? (_material as dynamic).shininess : null;
  get specular => (isMeshPhongMaterial) ? (_material as dynamic).specular : null;

  get lights => isShaderMaterial ? (_material as ShaderMaterial).lights : false;

  get morphTargets => _hasMorhTargets ?  (_material as dynamic).morphTargets : false;
  get morphNormals => _hasMorphNormals ?  (_material as dynamic).morphNormals : false;

  bool get metal => isMeshPhongMaterial ? (_material as MeshPhongMaterial).metal : false; //null;

  bool get perPixel => isMeshPhongMaterial ? (_material as MeshPhongMaterial).perPixel : false; //null;

  get wrapAround => _hasWrapAround ?  (_material as dynamic).wrapAround : false;

  get fog => _hasFog ? (_material as dynamic).fog : false;
  get shading => (_material as dynamic).shading;
  get map => _hasTextureMap ? (_material as dynamic).map : null;
  get envMap => _hasEnvMap ? (_material as dynamic).envMap : null;
  get lightMap => _hasLightMap ? (_material as dynamic).lightMap : null;
  get bumpMap => isMeshPhongMaterial ? (_material as MeshPhongMaterial).bumpMap : null;
  get specularMap => _hasSpecularMap ? (_material as dynamic).specularMap : null;

  get wireframe => !isLineBasicMaterial && !isParticleBasicMaterial && (_material as dynamic).wireframe;
  get wireframeLinewidth => (wireframe) ? (_material as dynamic).wireframeLinewidth : null;
  get wireframeLinecap => (wireframe) ? (_material as dynamic).wireframeLinecap : null;
  get wireframeLinejoin => (wireframe) ? (_material as dynamic).wireframeLinejoin : null;

  get linewidth => (isLineBasicMaterial) ? (_material as dynamic).linewidth : null;
  get reflectivity => (_material as dynamic).reflectivity;
  get refractionRatio => (_material as dynamic).refractionRatio;
  get combine => (_material as dynamic).combine;
  get skinning => _hasSkinning ?  (_material as dynamic).skinning : false;
  get sizeAttenuation => isParticleBasicMaterial ? (_material as ParticleBasicMaterial).sizeAttenuation : false; //null;
  get size => isParticleBasicMaterial ? (_material as ParticleBasicMaterial).size : null;

  bool get isShaderMaterial => _material is ShaderMaterial;
  bool get isMeshFaceMaterial => _material is MeshFaceMaterial;
  bool get isMeshDepthMaterial => _material is MeshDepthMaterial;
  bool get isMeshNormalMaterial => _material is MeshNormalMaterial;
  bool get isMeshBasicMaterial => _material is MeshBasicMaterial;
  bool get isMeshLambertMaterial => _material is MeshLambertMaterial;
  bool get isMeshPhongMaterial => _material is MeshPhongMaterial;
  bool get isLineBasicMaterial => _material is LineBasicMaterial;
  bool get isParticleBasicMaterial => _material is ParticleBasicMaterial;

  // TODO - Use this to identify proper interfaces
  bool get _hasAmbient => isMeshLambertMaterial || isMeshPhongMaterial;
  bool get _hasEmissive => isMeshLambertMaterial || isMeshPhongMaterial;
  bool get _hasWrapAround => isMeshLambertMaterial || isMeshPhongMaterial;

  bool get _hasLightMap => isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial;
  bool get _hasEnvMap => isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial;
  bool get _hasSpecularMap => isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial;

  bool get _hasTextureMap => isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial || isParticleBasicMaterial; //_material is ITextureMapMaterial;

  bool get _hasSkinning => isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial || isShaderMaterial;

  bool get _hasMorhTargets => isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial || isShaderMaterial;

  bool get _hasMorphNormals => isMeshLambertMaterial || isMeshPhongMaterial || isShaderMaterial;

  bool get _hasVertexColors => isLineBasicMaterial || isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial || isParticleBasicMaterial || isShaderMaterial;
  bool get _hasFog => isLineBasicMaterial || isMeshBasicMaterial || isMeshLambertMaterial || isMeshPhongMaterial || isParticleBasicMaterial || isShaderMaterial;
}

class WebGLCamera { // implements Camera {

  Camera _camera;
  Float32Array _viewMatrixArray,
  _projectionMatrixArray;

  WebGLCamera._internal(Camera camera)
      :   _camera = camera,
          _viewMatrixArray = new Float32Array( 16 ),
          _projectionMatrixArray = new Float32Array( 16 );

  factory WebGLCamera(Camera camera) {
    if (camera["__webglCamera"] == null) {
      var __webglCamera = new WebGLCamera._internal(camera);
      camera["__webglCamera"] = __webglCamera;
    }

    return camera["__webglCamera"];
  }

  get near => _camera.near;
  get far => _camera.far;
  get parent => _camera.parent;
  get matrixWorld => _camera.matrixWorld;
  get matrixWorldInverse => _camera.matrixWorldInverse;
  get projectionMatrix => _camera.projectionMatrix;

  void updateMatrixWorld( {bool force: false} ) => _camera.updateMatrixWorld();
}

class WebGLImageList { // implements ImageList
  ImageList _imageList;
  var webglTextureCube;

  WebGLImageList._internal(ImageList imageList) : _imageList = imageList;

  factory WebGLImageList(ImageList imageList) {
    if (imageList.props["__webglImageList"] == null) {
      var __webglImageList = new WebGLImageList._internal(imageList);
      imageList.props["__webglImageList"] = __webglImageList;
    }

    return imageList.props["__webglImageList"];

  }

  ImageElement operator [](int index) => _imageList[index];
  void operator []=(int index, ImageElement img) { _imageList[index] = img; }
  int get length => _imageList.length;

}
