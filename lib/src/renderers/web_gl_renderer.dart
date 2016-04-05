// r54
part of three;

/// The WebGL renderer displays your beautifully crafted scenes using WebGL,
/// if your device supports it.
///
/// This renderer has way better performance than CanvasRenderer.
class WebGLRenderer implements Renderer {

  static const String PRECISION_HIGH = 'highp';

  /// A Canvas where the renderer draws its output.
  ///
  /// This is automatically created by the renderer in the constructor (if not
  /// provided already); you just need to add it to your page.
  CanvasElement canvas;
  gl.RenderingContext _gl;

  String precision;

  Color _clearColor;
  num _clearAlpha;
  num devicePixelRatio;

  bool alpha, premultipliedAlpha, antialias, stencil, preserveDrawingBuffer;

  /// Defines whether the renderer should automatically clear its output before rendering.
  bool autoClear;
  /// If autoClear is true, defines whether the renderer should clear the color buffer. Default is true.
  bool autoClearColor;
  /// If autoClear is true, defines whether the renderer should clear the depth buffer. Default is true.
  bool autoClearDepth;
  /// If autoClear is true, defines whether the renderer should clear the stencil buffer. Default is true.
  bool autoClearStencil;

  // scene graph

  /// Defines whether the renderer should sort objects. Default is true.
  ///
  /// Note: Sorting is used to attempt to properly render objects that have some
  /// degree of transparency. By definition, sorting objects may not work in all
  /// cases. Depending on the needs of application, it may be necessary to turn
  /// off sorting and use other methods to deal with transparency rendering
  /// (e.g. manually determining the object rendering order).
  bool sortObjects;
  /// Defines whether the renderer should auto update objects. Default is true.
  bool autoUpdateObjects;
  bool autoUpdateScene;

  // physically based shading

  /// Default is false. If set, then it expects that all textures and colors are premultiplied gamma.
  bool gammaInput;

  /// Default is false. If set, then it expects that all textures and colors need to be outputted in
  /// premultiplied gamma.
  bool gammaOutput;
  bool physicallyBasedShading;

  // shadow map

  /// Default is false. If set, use shadow maps in the scene.
  bool shadowMapEnabled;
  bool shadowMapAutoUpdate;
  bool shadowMapDebug;
  bool shadowMapCascade;
  /// Defines shadow map type (unfiltered, percentage close filtering,
  /// percentage close filtering with bilinear filtering in shader)
  ///
  /// Options are BasicShadowMap, PCFShadowMap, PCFSoftShadowMap. Default is PCFShadowMap.
  int shadowMapType;
  /// Default is CullFaceFront. The faces that needed to be culled.
  ///
  /// Possible values: CullFaceFront and CullFaceBack
  int shadowMapCullFrontFaces;

  // morphs

  /// Default is 8. The maximum number of MorphTargets allowed in a shader.
  ///
  /// Keep in mind that the standard materials only allow 8 MorphTargets.
  int maxMorphTargets;
  /// Default is 4. The maximum number of MorphNormals allowed in a shader.
  ///
  /// Keep in mind that the standard materials only allow 4 MorphNormals.
  int maxMorphNormals;

  // flags

  /// Default is true. If set, then Cubemaps are scaled, when they are bigger
  /// than the maximum size, to make sure that they aren't bigger than the maximum size.
  bool autoScaleCubemaps;

  // custom render plugins

  List renderPluginsPre, renderPluginsPost;


  WebGLRendererInfo info;

  /** Internal properties **/

  List<Program> _programs;
  int _programs_counter;

  // internal state cache
  var _currentProgram = null,
      _currentFramebuffer = null,
      _currentMaterialId = -1,
      _currentGeometryGroupHash = null,
      _currentCamera = null,
      _geometryGroupCounter = 0,
      _usedTextureUnits = 0,
      _enabledAttributes = {};

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
  Matrix4 _projScreenMatrix, _projScreenMatrixPS;

  Vector3 _vector3;

  // light arrays cache
  Vector3 _direction;

  Map _lights;
  bool _lightsNeedUpdate;

  // GL Extensions
  gl.OesTextureFloat _glExtensionTextureFloat;
  gl.OesStandardDerivatives _glExtensionStandardDerivatives;
  gl.ExtTextureFilterAnisotropic _glExtensionTextureFilterAnisotropic;
  gl.CompressedTextureS3TC _glExtensionCompressedTextureS3TC;

  var maxAnisotropy;

  bool supportsVertexTextures, supportsBoneTextures;

  var shadowMapPlugin;

  num maxTextures, maxVertexTextures, maxTextureSize, maxCubemapSize;

  WebGLRenderer({this.canvas, this.precision: PRECISION_HIGH, this.alpha: true, this.premultipliedAlpha: true,
      this.antialias: true, this.stencil: true, this.preserveDrawingBuffer: false, num clearColorHex: 0x000000,
      num clearAlpha: 0, num devicePixelRatio})
      : _clearColor = new Color(clearColorHex),
        _clearAlpha = clearAlpha,

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
        shadowMapType = PCFShadowMap,
        shadowMapCullFrontFaces = CullFaceFront,
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
        _currentHeight = 0,

        _enabledAttributes = {},

        // frustum
      _frustum = new Frustum(),

        // camera matrices cache
      _projScreenMatrix = new Matrix4.identity(),
        _projScreenMatrixPS = new Matrix4.identity(),

        _vector3 = new Vector3.zero(),

        // light arrays cache

      _direction = new Vector3.zero(),

        _lightsNeedUpdate = true {

    this.devicePixelRatio =
        (devicePixelRatio != null) ? devicePixelRatio : ((window.devicePixelRatio != null) ? window.devicePixelRatio : 1);

    _lights = {

      "ambient": [0, 0, 0],
      "directional": {
        "length": 0,
        "colors": [],
        "positions": []
      },
      "point": {
        "length": 0,
        "colors": [],
        "positions": [],
        "distances": []
      },
      "spot": {
        "length": 0,
        "colors": [],
        "positions": [],
        "distances": [],
        "directions": [],
        "anglesCos": [],
        "exponents": []
      },
      "hemi": {
        "length": 0,
        "skyColors": [],
        "groundColors": [],
        "positions": []
      }
    };



    if (canvas == null) {
      canvas = new CanvasElement();
    }

    // initialize

    initGL();

    setDefaultGLState();


    // GPU capabilities
    maxTextures = _gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);
    maxVertexTextures = _gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
    maxTextureSize = _gl.getParameter(gl.MAX_TEXTURE_SIZE);
    maxCubemapSize = _gl.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);

    maxAnisotropy = (_glExtensionTextureFilterAnisotropic != null) ?
        _gl.getParameter(gl.ExtTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT) :
        0;

    supportsVertexTextures = (maxVertexTextures > 0);
    supportsBoneTextures = supportsVertexTextures && (_glExtensionTextureFloat != null);

    var _compressedTextureFormats =
        (_glExtensionCompressedTextureS3TC != null) ? _gl.getParameter(gl.COMPRESSED_TEXTURE_FORMATS) : [];

    //

    var _vertexShaderPrecisionHighpFloat = _gl.getShaderPrecisionFormat(gl.VERTEX_SHADER, gl.HIGH_FLOAT);
    var _vertexShaderPrecisionMediumpFloat = _gl.getShaderPrecisionFormat(gl.VERTEX_SHADER, gl.MEDIUM_FLOAT);
    var _vertexShaderPrecisionLowpFloat = _gl.getShaderPrecisionFormat(gl.VERTEX_SHADER, gl.LOW_FLOAT);

    var _fragmentShaderPrecisionHighpFloat = _gl.getShaderPrecisionFormat(gl.FRAGMENT_SHADER, gl.HIGH_FLOAT);
    var _fragmentShaderPrecisionMediumpFloat = _gl.getShaderPrecisionFormat(gl.FRAGMENT_SHADER, gl.MEDIUM_FLOAT);
    var _fragmentShaderPrecisionLowpFloat = _gl.getShaderPrecisionFormat(gl.FRAGMENT_SHADER, gl.LOW_FLOAT);

    var _vertexShaderPrecisionHighpInt = _gl.getShaderPrecisionFormat(gl.VERTEX_SHADER, gl.HIGH_INT);
    var _vertexShaderPrecisionMediumpInt = _gl.getShaderPrecisionFormat(gl.VERTEX_SHADER, gl.MEDIUM_INT);
    var _vertexShaderPrecisionLowpInt = _gl.getShaderPrecisionFormat(gl.VERTEX_SHADER, gl.LOW_INT);

    var _fragmentShaderPrecisionHighpInt = _gl.getShaderPrecisionFormat(gl.FRAGMENT_SHADER, gl.HIGH_INT);
    var _fragmentShaderPrecisionMediumpInt = _gl.getShaderPrecisionFormat(gl.FRAGMENT_SHADER, gl.MEDIUM_INT);
    var _fragmentShaderPrecisionLowpInt = _gl.getShaderPrecisionFormat(gl.FRAGMENT_SHADER, gl.LOW_INT);

    // clamp precision to maximum available

    var highpAvailable =
        _vertexShaderPrecisionHighpFloat.precision > 0 &&
        _fragmentShaderPrecisionHighpFloat.precision > 0;
    var mediumpAvailable =
        _vertexShaderPrecisionMediumpFloat.precision > 0 &&
        _fragmentShaderPrecisionMediumpFloat.precision > 0;

    if (precision == "highp" && !highpAvailable) {

      if (mediumpAvailable) {

        precision = "mediump";
        print("WebGLRenderer: highp not supported, using mediump");

      } else {

        precision = "lowp";
        print("WebGLRenderer: highp and mediump not supported, using lowp");

      }

    }

    if (precision == "mediump" && !mediumpAvailable) {

      precision = "lowp";
      print("WebGLRenderer: mediump not supported, using lowp");

    }

    // default plugins (order is important)

    shadowMapPlugin = new ShadowMapPlugin();
    addPrePlugin(shadowMapPlugin);

    //addPostPlugin( new SpritePlugin() );
    //addPostPlugin( new LensFlarePlugin() );

  }

  Element get domElement => canvas;

  // API

  gl.RenderingContext get context => _gl;


  /// Resizes the output canvas to (width, height), and also sets the viewport
  /// to fit that size, starting in (0, 0).
  setSize(width, height) {
    canvas.width = (width * devicePixelRatio).toInt();
    canvas.height = (height * devicePixelRatio).toInt();

    canvas.style.width = "${width}px";
    canvas.style.height = "${height}px";

    setViewport(0, 0, canvas.width, canvas.height);

  }

  /// Sets the viewport to render from (x, y) to (x + width, y + height).
  setViewport([x = 0, y = 0, width = -1, height = -1]) {

    _viewportX = x;
    _viewportY = y;


    _viewportWidth = (width != -1) ? width : canvas.width;
    _viewportHeight = (height != -1) ? height : canvas.height;

    _gl.viewport(_viewportX, _viewportY, _viewportWidth, _viewportHeight);

  }

  // Sets the scissor area from (x, y) to (x + width, y + height).
  setScissor(int x, int y, int width, int height) {
    _gl.scissor(x, y, width, height);
  }

  /// Enable the scissor test.
  ///
  /// When this is enabled, only the pixels within the defined scissor area will
  /// be affected by further renderer actions.
  enableScissorTest(bool enable) {
    enable ? _gl.enable(gl.SCISSOR_TEST) : _gl.disable(gl.SCISSOR_TEST);
  }

  // Clearing
  setClearColorHex(num hex, num alpha) {

    _clearColor.setHex(hex);
    _clearAlpha = alpha;

    _gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearAlpha);

  }

  /// Gets the clear alpha.
  double getClearAlpha() => _clearAlpha;

  /// Gets the clear color.
  Color getClearColor() => _clearColor;

  /// Sets the clear color and opacity.
  setClearColor(Color color, num alpha) {

    _clearColor.copy(color);
    _clearAlpha = alpha;

    _gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearAlpha);

  }

  /// Tells the renderer to clear its color, depth or stencil drawing buffer(s).
  ///
  /// Arguments default to true.
  clear([bool color = true, bool depth = true, bool stencil = true]) {

    var bits = 0;

    if (color) bits |= gl.COLOR_BUFFER_BIT;
    if (depth) bits |= gl.DEPTH_BUFFER_BIT;
    if (stencil) bits |= gl.STENCIL_BUFFER_BIT;

    _gl.clear(bits);

  }

  clearTarget(WebGLRenderTarget renderTarget, bool color, bool depth, bool stencil) {
    setRenderTarget(renderTarget);
    clear(color, depth, stencil);
  }

  // Plugins
  addPostPlugin(plugin) {
    plugin.init(this);
    renderPluginsPost.add(plugin);
  }

  addPrePlugin(plugin) {
    plugin.init(this);
    renderPluginsPre.add(plugin);
  }

  // Rendering

  updateShadowMap(scene, camera) {

    _currentProgram = null;
    _oldBlending = -1;
    _oldDepthTest = -1;
    _oldDepthWrite = -1;
    _currentGeometryGroupHash = -1;
    _currentMaterialId = -1;
    _lightsNeedUpdate = true;
    _oldDoubleSided = -1;
    _oldFlipSided = -1;

    shadowMapPlugin.update(scene, camera);

  }

  // Internal functions

  // Buffer allocation

  createParticleBuffers(Geometry geometry) {

    geometry.__webglVertexBuffer = _gl.createBuffer();
    geometry.__webglColorBuffer = _gl.createBuffer();

    info.memory.geometries++;

  }

  createLineBuffers(Geometry geometry) {

    geometry.__webglVertexBuffer = _gl.createBuffer();
    geometry.__webglColorBuffer = _gl.createBuffer();
    geometry.__webglLineDistanceBuffer = _gl.createBuffer();

    info.memory.geometries++;

  }

  createRibbonBuffers(Geometry geometry) {

    geometry.__webglVertexBuffer = _gl.createBuffer();
    geometry.__webglColorBuffer = _gl.createBuffer();
    geometry.__webglNormalBuffer = _gl.createBuffer();

    info.memory.geometries++;

  }

  createMeshBuffers(WebGLGeometry geometryGroup) {

    geometryGroup.__webglVertexBuffer = _gl.createBuffer();
    geometryGroup.__webglNormalBuffer = _gl.createBuffer();
    geometryGroup.__webglTangentBuffer = _gl.createBuffer();
    geometryGroup.__webglColorBuffer = _gl.createBuffer();
    geometryGroup.__webglUVBuffer = _gl.createBuffer();
    geometryGroup.__webglUV2Buffer = _gl.createBuffer();

    geometryGroup.__webglSkinIndicesBuffer = _gl.createBuffer();
    geometryGroup.__webglSkinWeightsBuffer = _gl.createBuffer();

    geometryGroup.__webglFaceBuffer = _gl.createBuffer();
    geometryGroup.__webglLineBuffer = _gl.createBuffer();

    var m, ml;

    if (geometryGroup.numMorphTargets != null) {

      geometryGroup.__webglMorphTargetsBuffers = [];

      ml = geometryGroup.numMorphTargets;

      for (m = 0; m < ml; m++) {

        geometryGroup.__webglMorphTargetsBuffers.add(_gl.createBuffer());

      }

    }

    if (geometryGroup.numMorphNormals != null) {

      geometryGroup.__webglMorphNormalsBuffers = [];

      ml = geometryGroup.numMorphNormals;

      for (m = 0; m < ml; m++) {
        geometryGroup.__webglMorphNormalsBuffers.add(_gl.createBuffer());

      }

    }

    info.memory.geometries++;

  }

  // Events

  onGeometryDispose(event) {

    var geometry = event.target;

    geometry.removeEventListener('dispose', onGeometryDispose);

    deallocateGeometry(geometry);

    info.memory.geometries--;

  }

  onTextureDispose(event) {

    var texture = event.target;

    texture.removeEventListener('dispose', onTextureDispose);

    deallocateTexture(texture);

    info.memory.textures--;

  }

  onRenderTargetDispose(event) {

    var renderTarget = event.target;

    renderTarget.removeEventListener('dispose', onRenderTargetDispose);

    deallocateRenderTarget(renderTarget);

    info.memory.textures--;

  }

  onMaterialDispose(event) {

    var material = event.target;

    material.removeEventListener('dispose', onMaterialDispose);

    deallocateMaterial(material);

  }

  // Buffer deallocation
  deallocateGeometry(Geometry geometry) {

    geometry.__webglInit = false;

    if (geometry.__webglVertexBuffer != null) _gl.deleteBuffer(geometry.__webglVertexBuffer);
    if (geometry.__webglNormalBuffer != null) _gl.deleteBuffer(geometry.__webglNormalBuffer);
    if (geometry.__webglTangentBuffer != null) _gl.deleteBuffer(geometry.__webglTangentBuffer);
    if (geometry.__webglColorBuffer != null) _gl.deleteBuffer(geometry.__webglColorBuffer);
    if (geometry.__webglUVBuffer != null) _gl.deleteBuffer(geometry.__webglUVBuffer);
    if (geometry.__webglUV2Buffer != null) _gl.deleteBuffer(geometry.__webglUV2Buffer);

    if (geometry.__webglSkinIndicesBuffer != null) _gl.deleteBuffer(geometry.__webglSkinIndicesBuffer);
    if (geometry.__webglSkinWeightsBuffer != null) _gl.deleteBuffer(geometry.__webglSkinWeightsBuffer);

    if (geometry.__webglFaceBuffer != null) _gl.deleteBuffer(geometry.__webglFaceBuffer);
    if (geometry.__webglLineBuffer != null) _gl.deleteBuffer(geometry.__webglLineBuffer);

    if (geometry.__webglLineDistanceBuffer != null) _gl.deleteBuffer(geometry.__webglLineDistanceBuffer);

    // geometry groups

    if (geometry.geometryGroups != null) {

      for (var g in geometry.geometryGroups) {

        var geometryGroup = geometry.geometryGroups[g];

        if (geometryGroup.numMorphTargets != null) {

          for (var m = 0,
              ml = geometryGroup.numMorphTargets; m < ml; m++) {

            _gl.deleteBuffer(geometryGroup.__webglMorphTargetsBuffers[m]);

          }

        }

        if (geometryGroup.numMorphNormals != null) {

          for (var m = 0,
              ml = geometryGroup.numMorphNormals; m < ml; m++) {

            _gl.deleteBuffer(geometryGroup.__webglMorphNormalsBuffers[m]);

          }

        }

        deleteCustomAttributesBuffers(geometryGroup);

      }

    }

    deleteCustomAttributesBuffers(geometry);

  }

  deallocateTexture(Texture texture) {

    if (texture.image && texture.image.__webglTextureCube) {

      // cube texture

      _gl.deleteTexture(texture.image.__webglTextureCube);

    } else {

      // 2D texture

      if (!texture["__webglInit"]) return;

      texture["__webglInit"] = false;
      _gl.deleteTexture(texture.__webglTexture);

    }

  }

  deallocateRenderTarget(WebGLRenderTarget renderTarget) {

    if (renderTarget == null || renderTarget.__webglTexture == null) return;

    _gl.deleteTexture(renderTarget.__webglTexture);

    if (renderTarget is WebGLRenderTargetCube) {

      for (var i = 0; i < 6; i++) {

        _gl.deleteFramebuffer(renderTarget.__webglFramebuffer[i]);
        _gl.deleteRenderbuffer(renderTarget.__webglRenderbuffer[i]);

      }

    } else {

      _gl.deleteFramebuffer(renderTarget.__webglFramebuffer);
      _gl.deleteRenderbuffer(renderTarget.__webglRenderbuffer);

    }

  }

  deallocateMaterial(Material material) {

    var program = material._program;

    if (program == null) return;

    material._program = null;

    // only deallocate GL program if this was the last use of shared program
    // assumed there is only single copy of any program in the _programs list
    // (that's how it's constructed)

    var i, il;
    Program programInfo;
    var deleteProgram = false;

    for (var i = 0,
        il = _programs.length; i < il; i++) {

      programInfo = _programs[i];

      if (programInfo.glProgram == program) {

        programInfo.usedTimes--;

        if (programInfo.usedTimes == 0) {

          deleteProgram = true;

        }

        break;

      }

    }

    if (deleteProgram == true) {

      // avoid using array.splice, this is costlier than creating new array from scratch

      var newPrograms = [];

      for (var i = 0,
          il = _programs.length; i < il; i++) {

        programInfo = _programs[i];

        if (programInfo.glProgram != program) {

          newPrograms.add(programInfo);

        }

      }

      _programs = newPrograms;

      _gl.deleteProgram(program);

      info.memory.programs--;

    }

  }

  deleteCustomAttributesBuffers(Geometry geometry) {

    if (geometry.__webglCustomAttributesList) {

      for (var id in geometry.__webglCustomAttributesList) {

        _gl.deleteBuffer(geometry.__webglCustomAttributesList[id].buffer);

      }

    }

  }

  // Buffer initialization

  initCustomAttributes(Geometry geometry, Object3D object) {

    var nvertices = geometry.vertices.length;

    var material = object.material;

    if (material is ShaderMaterial && material.attributes != null) {

      if (geometry.__webglCustomAttributesList == null) {

        geometry.__webglCustomAttributesList = [];

      }

      material.attributes.forEach((key, attribute) {

        if (!attribute.__webglInitialized || attribute.createUniqueBuffers) {

          attribute.__webglInitialized = true;

          attribute.array = new Float32List(nvertices * attribute.size);

          attribute.buffer = new Buffer(_gl);
          attribute.buffer.belongsToAttribute = key;

          attribute.needsUpdate = true;

        }

        geometry.__webglCustomAttributesList.add(attribute);

      });

    }

  }

  initParticleBuffers(Geometry geometry, Object3D object) {

    var nvertices = geometry.vertices.length;

    geometry.__vertexArray = new Float32List(nvertices * 3);
    geometry.__colorArray = new Float32List(nvertices * 3);

    geometry.__sortArray = [];

    geometry.__webglParticleCount = nvertices;

    initCustomAttributes(geometry, object);

  }

  initLineBuffers(Geometry geometry, Object3D object) {

    var nvertices = geometry.vertices.length;

    geometry.__vertexArray = new Float32List(nvertices * 3);
    geometry.__colorArray = new Float32List(nvertices * 3);
    geometry.__lineDistanceArray = new Float32List(nvertices * 1);

    geometry.__webglLineCount = nvertices;

    initCustomAttributes(geometry, object);

  }

  initRibbonBuffers(Geometry geometry, object) {

    var nvertices = geometry.vertices.length;

    geometry.__vertexArray = new Float32List(nvertices * 3);
    geometry.__colorArray = new Float32List(nvertices * 3);
    geometry.__normalArray = new Float32List(nvertices * 3);

    geometry.__webglVertexCount = nvertices;

    initCustomAttributes(geometry, object);

  }

  initMeshBuffers(WebGLGeometry geometryGroup, Object3D object) {

    var geometry = object.geometry,
        faces3 = geometryGroup.faces3,
        faces4 = geometryGroup.faces4,

        nvertices = faces3.length * 3 + faces4.length * 4,
        ntris = faces3.length * 1 + faces4.length * 2,
        nlines = faces3.length * 3 + faces4.length * 4;

    Material material = getBufferMaterial(object, geometryGroup);

    var uvType = bufferGuessUVType(material),
        normalType = bufferGuessNormalType(material);

    geometryGroup.__vertexArray = new Float32List(nvertices * 3);

    if (normalType != NoShading) {

      geometryGroup.__normalArray = new Float32List(nvertices * 3);

    }

    if (geometry.hasTangents) {

      geometryGroup.__tangentArray = new Float32List(nvertices * 4);

    }

    if (material.vertexColors != NoColors) {

      geometryGroup.__colorArray = new Float32List(nvertices * 3);

    }

    if (uvType) {

      if (geometry.faceUvs.length > 0 || geometry.faceVertexUvs.length > 0) {

        geometryGroup.__uvArray = new Float32List(nvertices * 2);

      }

      if (geometry.faceUvs.length > 1 || geometry.faceVertexUvs.length > 1) {

        geometryGroup.__uv2Array = new Float32List(nvertices * 2);

      }

    }

    if (!object.geometry.skinWeights.isEmpty && !object.geometry.skinIndices.isEmpty) {

      geometryGroup.__skinIndexArray = new Float32List(nvertices * 4);
      geometryGroup.__skinWeightArray = new Float32List(nvertices * 4);

    }

    geometryGroup.__faceArray = new Uint16List(ntris * 3);
    geometryGroup.__lineArray = new Uint16List(nlines * 2);

    var m, ml;

    if (geometryGroup.numMorphTargets != null) {

      geometryGroup.__morphTargetsArrays = [];

      ml = geometryGroup.numMorphTargets;

      for (m = 0; m < ml; m++) {

        geometryGroup.__morphTargetsArrays.add(new Float32List(nvertices * 3));

      }

    }

    if (geometryGroup.numMorphNormals != null) {

      geometryGroup.__morphNormalsArrays = [];

      ml = geometryGroup.numMorphNormals;

      for (m = 0; m < ml; m++) {

        geometryGroup.__morphNormalsArrays.add(new Float32List(nvertices * 3));

      }

    }

    geometryGroup.__webglFaceCount = ntris * 3;
    geometryGroup.__webglLineCount = nlines * 2;


    // custom attributes

    if (material is ShaderMaterial && material.attributes != null) {

      if (geometryGroup.__webglCustomAttributesList == null) {

        geometryGroup.__webglCustomAttributesList = [];

      }

      material.attributes.forEach((key, attribute) {

        if (!attribute.__webglInitialized || attribute.createUniqueBuffers) {

          attribute.__webglInitialized = true;
          attribute.array = new Float32List(nvertices * attribute.size);

          var buffer = new Buffer(_gl);
          buffer.belongsToAttribute = key;
          attribute.buffer = buffer;

          // Do a shallow copy of the attribute object so different geometryGroup chunks use different
          // attribute buffers which are correctly indexed in the setMeshBuffers function

          var originalAttribute = attribute.clone();
          originalAttribute.needsUpdate = true;
          attribute.__original = originalAttribute;

        }

        geometryGroup.__webglCustomAttributesList.add(attribute);

      });

    }

    geometryGroup.__inittedArrays = true;

  }

  Material getBufferMaterial(Object3D object, WebGLGeometry geometry) {

    return (object.material is MeshFaceMaterial) ?
        (object.material as MeshFaceMaterial).materials[geometry.materialIndex] :
        object.material;

  }

  bool materialNeedsSmoothNormals(material) {

    return material != null && material.shading != null && material.shading == SmoothShading;

  }

  int bufferGuessNormalType(Material material) {

    // only MeshBasicMaterial and MeshDepthMaterial don't need normals

    if (((material is MeshBasicMaterial) && (material.envMap == null)) || (material is MeshDepthMaterial)) {
      return NoShading;
    }

    if (materialNeedsSmoothNormals(material)) {

      return SmoothShading;

    } else {

      return FlatShading;

    }

  }

  bool bufferGuessUVType(Material material) {

    // material must use some texture to require uvs

    if (((material is TextureMapping) && (material as TextureMapping).map != null)) {
      return true;
    }

    if (material is EnvironmentMapping) {
      if (((material as EnvironmentMapping).lightMap != null) ||
          ((material as EnvironmentMapping).specularMap != null)) {
        return true;
      }
    }

    if (material is BumpMapping) {
      if (((material as BumpMapping).bumpMap != null) || ((material as BumpMapping).normalMap != null)) {
        return true;
      }
    }

    return (material is ShaderMaterial);

  }

  //

  initDirectBuffers(BufferGeometry geometry) {

    var a, attribute, type;

    geometry.attributes.forEach((a, v) {

      if (a == "index") {

        type = gl.ELEMENT_ARRAY_BUFFER;

      } else {

        type = gl.ARRAY_BUFFER;

      }

      attribute = v;

      attribute.buffer = new Buffer(_gl);
      attribute.buffer.bind(type);
      _gl.bufferDataTyped(type, attribute.array, gl.STATIC_DRAW);

    });

  }

  // Buffer setting

  setParticleBuffers(Geometry geometry, int hint, object) {

    var v,
        c,
        vertex,
        offset,
        index,
        color,

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
        i,
        il,
        a,
        ca,
        cal,
        value,
        customAttribute;

    if (object.sortParticles) {

      _projScreenMatrixPS.setFrom(_projScreenMatrix);
      _projScreenMatrixPS.multiply(object.matrixWorld);

      for (v = 0; v < vl; v++) {

        vertex = vertices[v];

        _vector3.setFrom(vertex);
        _vector3.applyProjection(_projScreenMatrixPS);

        sortArray[v] = [_vector3.z, v];

      }

      sortArray.sort(numericalSort);

      for (v = 0; v < vl; v++) {

        vertex = vertices[sortArray[v][1]];

        offset = v * 3;

        vertexArray[offset] = vertex.x;
        vertexArray[offset + 1] = vertex.y;
        vertexArray[offset + 2] = vertex.z;

      }

      for (c = 0; c < cl; c++) {

        offset = c * 3;

        color = colors[sortArray[c][1]];

        colorArray[offset] = color.r;
        colorArray[offset + 1] = color.g;
        colorArray[offset + 2] = color.b;

      }

      if (customAttributes != null) {

        il = customAttributes.length;
        for (i = 0; i < il; i++) {

          customAttribute = customAttributes[i];

          if (!(customAttribute.boundTo == null || customAttribute.boundTo == "vertices")) continue;

          offset = 0;

          cal = customAttribute.value.length;

          if (customAttribute.size == 1) {

            for (ca = 0; ca < cal; ca++) {

              index = sortArray[ca][1];

              customAttribute.array[ca] = customAttribute.value[index];

            }

          } else if (customAttribute.size == 2) {

            for (ca = 0; ca < cal; ca++) {

              index = sortArray[ca][1];

              value = customAttribute.value[index];

              customAttribute.array[offset] = value.x;
              customAttribute.array[offset + 1] = value.y;

              offset += 2;

            }

          } else if (customAttribute.size == 3) {

            if (customAttribute.type == "c") {

              for (ca = 0; ca < cal; ca++) {

                index = sortArray[ca][1];

                value = customAttribute.value[index];

                customAttribute.array[offset] = value.r;
                customAttribute.array[offset + 1] = value.g;
                customAttribute.array[offset + 2] = value.b;

                offset += 3;

              }

            } else {

              for (ca = 0; ca < cal; ca++) {

                index = sortArray[ca][1];

                value = customAttribute.value[index];

                customAttribute.array[offset] = value.x;
                customAttribute.array[offset + 1] = value.y;
                customAttribute.array[offset + 2] = value.z;

                offset += 3;

              }

            }

          } else if (customAttribute.size == 4) {

            for (ca = 0; ca < cal; ca++) {

              index = sortArray[ca][1];

              value = customAttribute.value[index];

              customAttribute.array[offset] = value.x;
              customAttribute.array[offset + 1] = value.y;
              customAttribute.array[offset + 2] = value.z;
              customAttribute.array[offset + 3] = value.w;

              offset += 4;

            }

          }

        }

      }

    } else {

      if (dirtyVertices) {

        for (v = 0; v < vl; v++) {

          vertex = vertices[v];

          offset = v * 3;

          vertexArray[offset] = vertex.x;
          vertexArray[offset + 1] = vertex.y;
          vertexArray[offset + 2] = vertex.z;

        }

      }

      if (dirtyColors) {

        for (c = 0; c < cl; c++) {

          color = colors[c];

          offset = c * 3;

          colorArray[offset] = color.r;
          colorArray[offset + 1] = color.g;
          colorArray[offset + 2] = color.b;

        }

      }

      if (customAttributes != null) {

        il = customAttributes.length;
        for (i = 0; i < il; i++) {

          customAttribute = customAttributes[i];

          if (customAttribute.needsUpdate &&
              (customAttribute.boundTo == null || customAttribute.boundTo == "vertices")) {

            cal = customAttribute.value.length;

            offset = 0;

            if (customAttribute.size == 1) {

              for (ca = 0; ca < cal; ca++) {

                customAttribute.array[ca] = customAttribute.value[ca];

              }

            } else if (customAttribute.size == 2) {

              for (ca = 0; ca < cal; ca++) {

                value = customAttribute.value[ca];

                customAttribute.array[offset] = value.x;
                customAttribute.array[offset + 1] = value.y;

                offset += 2;

              }

            } else if (customAttribute.size == 3) {

              if (customAttribute.type == "c") {

                for (ca = 0; ca < cal; ca++) {

                  value = customAttribute.value[ca];

                  customAttribute.array[offset] = value.r;
                  customAttribute.array[offset + 1] = value.g;
                  customAttribute.array[offset + 2] = value.b;

                  offset += 3;

                }

              } else {

                for (ca = 0; ca < cal; ca++) {

                  value = customAttribute.value[ca];

                  customAttribute.array[offset] = value.x;
                  customAttribute.array[offset + 1] = value.y;
                  customAttribute.array[offset + 2] = value.z;

                  offset += 3;

                }

              }

            } else if (customAttribute.size == 4) {

              for (ca = 0; ca < cal; ca++) {

                value = customAttribute.value[ca];

                customAttribute.array[offset] = value.x;
                customAttribute.array[offset + 1] = value.y;
                customAttribute.array[offset + 2] = value.z;
                customAttribute.array[offset + 3] = value.w;

                offset += 4;

              }

            }

          }

        }

      }

    }

    if (dirtyVertices || object.sortParticles) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglVertexBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, vertexArray, hint);

    }

    if (dirtyColors || object.sortParticles) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglColorBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, colorArray, hint);

    }

    if (customAttributes != null) {

      il = customAttributes.length;
      for (i = 0; i < il; i++) {

        customAttribute = customAttributes[i];

        if (customAttribute.needsUpdate || object.sortParticles) {

          customAttribute.buffer.bind(gl.ARRAY_BUFFER);
          _gl.bufferDataTyped(gl.ARRAY_BUFFER, customAttribute.array, hint);

        }

      }

    }


  }

  setLineBuffers(Geometry geometry, int hint) {

    var v,
        c,
        d,
        vertex,
        offset,
        color,

        vertices = geometry.vertices,
        colors = geometry.colors,
        lineDistances = geometry.lineDistances,

        vl = vertices.length,
        cl = colors.length,
        dl = lineDistances.length,

        vertexArray = geometry.__vertexArray,
        colorArray = geometry.__colorArray,
        lineDistanceArray = geometry.__lineDistanceArray,

        dirtyVertices = geometry.verticesNeedUpdate,
        dirtyColors = geometry.colorsNeedUpdate,
        dirtyLineDistances = geometry.lineDistancesNeedUpdate,

        customAttributes = geometry.__webglCustomAttributesList,

        i,
        il,
        a,
        ca,
        cal,
        value,
        customAttribute;

    if (dirtyVertices) {

      for (v = 0; v < vl; v++) {

        vertex = vertices[v];

        offset = v * 3;

        vertexArray[offset] = vertex.x;
        vertexArray[offset + 1] = vertex.y;
        vertexArray[offset + 2] = vertex.z;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglVertexBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, vertexArray, hint);

    }

    if (dirtyColors) {

      for (c = 0; c < cl; c++) {

        color = colors[c];

        offset = c * 3;

        colorArray[offset] = color.r;
        colorArray[offset + 1] = color.g;
        colorArray[offset + 2] = color.b;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglColorBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, colorArray, hint);

    }

    if (dirtyLineDistances) {

      for (d = 0; d < dl; d++) {

        lineDistanceArray[d] = lineDistances[d];

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglLineDistanceBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, lineDistanceArray, hint);

    }

    if (customAttributes != null) {

      il = customAttributes.length;
      for (i = 0; i < il; i++) {

        customAttribute = customAttributes[i];

        if (customAttribute.needsUpdate && (customAttribute.boundTo == null || customAttribute.boundTo == "vertices")) {

          offset = 0;

          cal = customAttribute.value.length;

          if (customAttribute.size == 1) {

            for (ca = 0; ca < cal; ca++) {

              customAttribute.array[ca] = customAttribute.value[ca];

            }

          } else if (customAttribute.size == 2) {

            for (ca = 0; ca < cal; ca++) {

              value = customAttribute.value[ca];

              customAttribute.array[offset] = value.x;
              customAttribute.array[offset + 1] = value.y;

              offset += 2;

            }

          } else if (customAttribute.size == 3) {

            if (customAttribute.type == "c") {

              for (ca = 0; ca < cal; ca++) {

                value = customAttribute.value[ca];

                customAttribute.array[offset] = value.r;
                customAttribute.array[offset + 1] = value.g;
                customAttribute.array[offset + 2] = value.b;

                offset += 3;

              }

            } else {

              for (ca = 0; ca < cal; ca++) {

                value = customAttribute.value[ca];

                customAttribute.array[offset] = value.x;
                customAttribute.array[offset + 1] = value.y;
                customAttribute.array[offset + 2] = value.z;

                offset += 3;

              }

            }

          } else if (customAttribute.size == 4) {

            for (ca = 0; ca < cal; ca++) {

              value = customAttribute.value[ca];

              customAttribute.array[offset] = value.x;
              customAttribute.array[offset + 1] = value.y;
              customAttribute.array[offset + 2] = value.z;
              customAttribute.array[offset + 3] = value.w;

              offset += 4;

            }

          }

          customAttribute.buffer.bind(gl.ARRAY_BUFFER);
          _gl.bufferDataTyped(gl.ARRAY_BUFFER, customAttribute.array, hint);

        }

      }

    }

  }

  setRibbonBuffers(Geometry geometry, int hint) {

    var v,
        c,
        n,
        vertex,
        offset,
        color,
        normal,

        i,
        il,
        ca,
        cal,
        customAttribute,
        value,

        vertices = geometry.vertices,
        colors = geometry.colors,
        normals = geometry.normals,

        vl = vertices.length,
        cl = colors.length,
        nl = normals.length,

        vertexArray = geometry.__vertexArray,
        colorArray = geometry.__colorArray,
        normalArray = geometry.__normalArray,

        dirtyVertices = geometry.verticesNeedUpdate,
        dirtyColors = geometry.colorsNeedUpdate,
        dirtyNormals = geometry.normalsNeedUpdate,

        customAttributes = geometry.__webglCustomAttributesList;

    if (dirtyVertices) {

      for (v = 0; v < vl; v++) {

        vertex = vertices[v];

        offset = v * 3;

        vertexArray[offset] = vertex.x;
        vertexArray[offset + 1] = vertex.y;
        vertexArray[offset + 2] = vertex.z;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglVertexBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, vertexArray, hint);

    }

    if (dirtyColors) {

      for (c = 0; c < cl; c++) {

        color = colors[c];

        offset = c * 3;

        colorArray[offset] = color.r;
        colorArray[offset + 1] = color.g;
        colorArray[offset + 2] = color.b;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglColorBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, colorArray, hint);

    }

    if (dirtyNormals) {

      for (n = 0; n < nl; n++) {

        normal = normals[n];

        offset = n * 3;

        normalArray[offset] = normal.x;
        normalArray[offset + 1] = normal.y;
        normalArray[offset + 2] = normal.z;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometry.__webglNormalBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, normalArray, hint);

    }

    if (customAttributes) {

      for (var i = 0,
          il = customAttributes.length; i < il; i++) {

        customAttribute = customAttributes[i];

        if (customAttribute.needsUpdate && (customAttribute.boundTo == null || customAttribute.boundTo == "vertices")) {

          offset = 0;

          cal = customAttribute.value.length;

          if (customAttribute.size == 1) {

            for (ca = 0; ca < cal; ca++) {

              customAttribute.array[ca] = customAttribute.value[ca];

            }

          } else if (customAttribute.size == 2) {

            for (ca = 0; ca < cal; ca++) {

              value = customAttribute.value[ca];

              customAttribute.array[offset] = value.x;
              customAttribute.array[offset + 1] = value.y;

              offset += 2;

            }

          } else if (customAttribute.size == 3) {

            if (customAttribute.type == "c") {

              for (ca = 0; ca < cal; ca++) {

                value = customAttribute.value[ca];

                customAttribute.array[offset] = value.r;
                customAttribute.array[offset + 1] = value.g;
                customAttribute.array[offset + 2] = value.b;

                offset += 3;

              }

            } else {

              for (ca = 0; ca < cal; ca++) {

                value = customAttribute.value[ca];

                customAttribute.array[offset] = value.x;
                customAttribute.array[offset + 1] = value.y;
                customAttribute.array[offset + 2] = value.z;

                offset += 3;

              }

            }

          } else if (customAttribute.size == 4) {

            for (ca = 0; ca < cal; ca++) {

              value = customAttribute.value[ca];

              customAttribute.array[offset] = value.x;
              customAttribute.array[offset + 1] = value.y;
              customAttribute.array[offset + 2] = value.z;
              customAttribute.array[offset + 3] = value.w;

              offset += 4;

            }

          }

          customAttribute.buffer.bind(gl.ARRAY_BUFFER);
          _gl.bufferDataTyped(gl.ARRAY_BUFFER, customAttribute.array, hint);

        }

      }

    }

  }

  setMeshBuffers(WebGLGeometry geometryGroup, Object3D object, int hint, bool dispose, Material material) {

    if (!geometryGroup.__inittedArrays) {

      return;

    }

    var normalType = bufferGuessNormalType(material),
        uvType = bufferGuessUVType(material),

        needsSmoothNormals = (normalType == SmoothShading);

    var f,
        fl,
        fi,
        face,
        vertexNormals,
        faceNormal,
        normal,
        vertexColors,
        faceColor,
        vertexTangents,
        uv,
        uv2,
        v1,
        v2,
        v3,
        v4,
        t1,
        t2,
        t3,
        t4,
        n1,
        n2,
        n3,
        n4,
        c1,
        c2,
        c3,
        c4,
        sw1,
        sw2,
        sw3,
        sw4,
        si1,
        si2,
        si3,
        si4,
        sa1,
        sa2,
        sa3,
        sa4,
        sb1,
        sb2,
        sb3,
        sb4,
        m,
        ml,
        i,
        il,
        vn,
        uvi,
        uv2i,
        vk,
        vkl,
        vka,
        nka,
        chf,
        faceVertexNormals,
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

        skinIndexArray = geometryGroup.__skinIndexArray,
        skinWeightArray = geometryGroup.__skinWeightArray,

        morphTargetsArrays = geometryGroup.__morphTargetsArrays,
        morphNormalsArrays = geometryGroup.__morphNormalsArrays,

        customAttributes = geometryGroup.__webglCustomAttributesList,
        customAttribute,

        faceArray = geometryGroup.__faceArray,
        lineArray = geometryGroup.__lineArray,

        geometry = object.geometry, // this is shared for all chunks

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

        obj_uvs = (geometry.faceVertexUvs.length == 0) ? [] : geometry.faceVertexUvs[0],
        obj_uvs2 = (geometry.faceVertexUvs.length > 1) ? geometry.faceVertexUvs[1] : null,

        obj_colors = geometry.colors,

        obj_skinIndices = geometry.skinIndices,
        obj_skinWeights = geometry.skinWeights,

        morphTargets = geometry.morphTargets,
        morphNormals = geometry.morphNormals;


    if (dirtyVertices) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces3[f]];

        v1 = vertices[face.a];
        v2 = vertices[face.b];
        v3 = vertices[face.c];

        vertexArray[offset] = v1.x;
        vertexArray[offset + 1] = v1.y;
        vertexArray[offset + 2] = v1.z;

        vertexArray[offset + 3] = v2.x;
        vertexArray[offset + 4] = v2.y;
        vertexArray[offset + 5] = v2.z;

        vertexArray[offset + 6] = v3.x;
        vertexArray[offset + 7] = v3.y;
        vertexArray[offset + 8] = v3.z;

        offset += 9;

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces4[f]];

        v1 = vertices[face.a];
        v2 = vertices[face.b];
        v3 = vertices[face.c];
        v4 = vertices[face.d];

        vertexArray[offset] = v1.x;
        vertexArray[offset + 1] = v1.y;
        vertexArray[offset + 2] = v1.z;

        vertexArray[offset + 3] = v2.x;
        vertexArray[offset + 4] = v2.y;
        vertexArray[offset + 5] = v2.z;

        vertexArray[offset + 6] = v3.x;
        vertexArray[offset + 7] = v3.y;
        vertexArray[offset + 8] = v3.z;

        vertexArray[offset + 9] = v4.x;
        vertexArray[offset + 10] = v4.y;
        vertexArray[offset + 11] = v4.z;

        offset += 12;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, vertexArray, hint);

    }

    if (dirtyMorphTargets) {

      vkl = morphTargets.length;
      for (vk = 0; vk < vkl; vk++) {

        offset_morphTarget = 0;

        fl = chunk_faces3.length;
        for (f = 0; f < fl; f++) {

          chf = chunk_faces3[f];
          face = obj_faces[chf];

          // morph positions

          v1 = morphTargets[vk].vertices[face.a];
          v2 = morphTargets[vk].vertices[face.b];
          v3 = morphTargets[vk].vertices[face.c];

          vka = morphTargetsArrays[vk];

          vka[offset_morphTarget] = v1.x;
          vka[offset_morphTarget + 1] = v1.y;
          vka[offset_morphTarget + 2] = v1.z;

          vka[offset_morphTarget + 3] = v2.x;
          vka[offset_morphTarget + 4] = v2.y;
          vka[offset_morphTarget + 5] = v2.z;

          vka[offset_morphTarget + 6] = v3.x;
          vka[offset_morphTarget + 7] = v3.y;
          vka[offset_morphTarget + 8] = v3.z;

          // morph normals

          if ((material is Morphing) && (material as Morphing).morphNormals) {

            if (needsSmoothNormals) {

              faceVertexNormals = morphNormals[vk].vertexNormals[chf];

              n1 = faceVertexNormals.a;
              n2 = faceVertexNormals.b;
              n3 = faceVertexNormals.c;

            } else {

              n1 = morphNormals[vk].faceNormals[chf];
              n2 = n1;
              n3 = n1;

            }

            nka = morphNormalsArrays[vk];

            nka[offset_morphTarget] = n1.x;
            nka[offset_morphTarget + 1] = n1.y;
            nka[offset_morphTarget + 2] = n1.z;

            nka[offset_morphTarget + 3] = n2.x;
            nka[offset_morphTarget + 4] = n2.y;
            nka[offset_morphTarget + 5] = n2.z;

            nka[offset_morphTarget + 6] = n3.x;
            nka[offset_morphTarget + 7] = n3.y;
            nka[offset_morphTarget + 8] = n3.z;

          }

          //

          offset_morphTarget += 9;

        }

        fl = chunk_faces4.length;
        for (f = 0; f < fl; f++) {

          chf = chunk_faces4[f];
          face = obj_faces[chf];

          // morph positions

          v1 = morphTargets[vk].vertices[face.a];
          v2 = morphTargets[vk].vertices[face.b];
          v3 = morphTargets[vk].vertices[face.c];
          v4 = morphTargets[vk].vertices[face.d];

          vka = morphTargetsArrays[vk];

          vka[offset_morphTarget] = v1.x;
          vka[offset_morphTarget + 1] = v1.y;
          vka[offset_morphTarget + 2] = v1.z;

          vka[offset_morphTarget + 3] = v2.x;
          vka[offset_morphTarget + 4] = v2.y;
          vka[offset_morphTarget + 5] = v2.z;

          vka[offset_morphTarget + 6] = v3.x;
          vka[offset_morphTarget + 7] = v3.y;
          vka[offset_morphTarget + 8] = v3.z;

          vka[offset_morphTarget + 9] = v4.x;
          vka[offset_morphTarget + 10] = v4.y;
          vka[offset_morphTarget + 11] = v4.z;

          // morph normals

          if ((material is Morphing) && (material as Morphing).morphNormals) {

            if (needsSmoothNormals) {

              faceVertexNormals = morphNormals[vk].vertexNormals[chf];

              n1 = faceVertexNormals.a;
              n2 = faceVertexNormals.b;
              n3 = faceVertexNormals.c;
              n4 = faceVertexNormals.d;

            } else {

              n1 = morphNormals[vk].faceNormals[chf];
              n2 = n1;
              n3 = n1;
              n4 = n1;

            }

            nka = morphNormalsArrays[vk];

            nka[offset_morphTarget] = n1.x;
            nka[offset_morphTarget + 1] = n1.y;
            nka[offset_morphTarget + 2] = n1.z;

            nka[offset_morphTarget + 3] = n2.x;
            nka[offset_morphTarget + 4] = n2.y;
            nka[offset_morphTarget + 5] = n2.z;

            nka[offset_morphTarget + 6] = n3.x;
            nka[offset_morphTarget + 7] = n3.y;
            nka[offset_morphTarget + 8] = n3.z;

            nka[offset_morphTarget + 9] = n4.x;
            nka[offset_morphTarget + 10] = n4.y;
            nka[offset_morphTarget + 11] = n4.z;

          }

          //

          offset_morphTarget += 12;

        }

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[vk]);
        _gl.bufferDataTyped(gl.ARRAY_BUFFER, morphTargetsArrays[vk], hint);

        if ((material is Morphing) && (material as Morphing).morphNormals) {

          _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[vk]);
          _gl.bufferDataTyped(gl.ARRAY_BUFFER, morphNormalsArrays[vk], hint);

        }

      }

    }

    if (!obj_skinWeights.isEmpty) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces3[f]];

        // weights

        sw1 = obj_skinWeights[face.a];
        sw2 = obj_skinWeights[face.b];
        sw3 = obj_skinWeights[face.c];

        skinWeightArray[offset_skin] = sw1.x;
        skinWeightArray[offset_skin + 1] = sw1.y;
        skinWeightArray[offset_skin + 2] = sw1.z;
        skinWeightArray[offset_skin + 3] = sw1.w;

        skinWeightArray[offset_skin + 4] = sw2.x;
        skinWeightArray[offset_skin + 5] = sw2.y;
        skinWeightArray[offset_skin + 6] = sw2.z;
        skinWeightArray[offset_skin + 7] = sw2.w;

        skinWeightArray[offset_skin + 8] = sw3.x;
        skinWeightArray[offset_skin + 9] = sw3.y;
        skinWeightArray[offset_skin + 10] = sw3.z;
        skinWeightArray[offset_skin + 11] = sw3.w;

        // indices

        si1 = obj_skinIndices[face.a];
        si2 = obj_skinIndices[face.b];
        si3 = obj_skinIndices[face.c];

        skinIndexArray[offset_skin] = si1.x;
        skinIndexArray[offset_skin + 1] = si1.y;
        skinIndexArray[offset_skin + 2] = si1.z;
        skinIndexArray[offset_skin + 3] = si1.w;

        skinIndexArray[offset_skin + 4] = si2.x;
        skinIndexArray[offset_skin + 5] = si2.y;
        skinIndexArray[offset_skin + 6] = si2.z;
        skinIndexArray[offset_skin + 7] = si2.w;

        skinIndexArray[offset_skin + 8] = si3.x;
        skinIndexArray[offset_skin + 9] = si3.y;
        skinIndexArray[offset_skin + 10] = si3.z;
        skinIndexArray[offset_skin + 11] = si3.w;

        offset_skin += 12;

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces4[f]];

        // weights

        sw1 = obj_skinWeights[face.a];
        sw2 = obj_skinWeights[face.b];
        sw3 = obj_skinWeights[face.c];
        sw4 = obj_skinWeights[face.d];

        skinWeightArray[offset_skin] = sw1.x;
        skinWeightArray[offset_skin + 1] = sw1.y;
        skinWeightArray[offset_skin + 2] = sw1.z;
        skinWeightArray[offset_skin + 3] = sw1.w;

        skinWeightArray[offset_skin + 4] = sw2.x;
        skinWeightArray[offset_skin + 5] = sw2.y;
        skinWeightArray[offset_skin + 6] = sw2.z;
        skinWeightArray[offset_skin + 7] = sw2.w;

        skinWeightArray[offset_skin + 8] = sw3.x;
        skinWeightArray[offset_skin + 9] = sw3.y;
        skinWeightArray[offset_skin + 10] = sw3.z;
        skinWeightArray[offset_skin + 11] = sw3.w;

        skinWeightArray[offset_skin + 12] = sw4.x;
        skinWeightArray[offset_skin + 13] = sw4.y;
        skinWeightArray[offset_skin + 14] = sw4.z;
        skinWeightArray[offset_skin + 15] = sw4.w;

        // indices

        si1 = obj_skinIndices[face.a];
        si2 = obj_skinIndices[face.b];
        si3 = obj_skinIndices[face.c];
        si4 = obj_skinIndices[face.d];

        skinIndexArray[offset_skin] = si1.x;
        skinIndexArray[offset_skin + 1] = si1.y;
        skinIndexArray[offset_skin + 2] = si1.z;
        skinIndexArray[offset_skin + 3] = si1.w;

        skinIndexArray[offset_skin + 4] = si2.x;
        skinIndexArray[offset_skin + 5] = si2.y;
        skinIndexArray[offset_skin + 6] = si2.z;
        skinIndexArray[offset_skin + 7] = si2.w;

        skinIndexArray[offset_skin + 8] = si3.x;
        skinIndexArray[offset_skin + 9] = si3.y;
        skinIndexArray[offset_skin + 10] = si3.z;
        skinIndexArray[offset_skin + 11] = si3.w;

        skinIndexArray[offset_skin + 12] = si4.x;
        skinIndexArray[offset_skin + 13] = si4.y;
        skinIndexArray[offset_skin + 14] = si4.z;
        skinIndexArray[offset_skin + 15] = si4.w;

        offset_skin += 16;

      }

      if (offset_skin > 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer);
        _gl.bufferDataTyped(gl.ARRAY_BUFFER, skinIndexArray, hint);

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer);
        _gl.bufferDataTyped(gl.ARRAY_BUFFER, skinWeightArray, hint);

      }

    }

    if (dirtyColors && (material.vertexColors != NoColors)) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces3[f]];

        vertexColors = face.vertexColors;
        faceColor = face.color;

        if ((vertexColors.length == 3) && (material.vertexColors == VertexColors)) {

          c1 = vertexColors[0];
          c2 = vertexColors[1];
          c3 = vertexColors[2];

        } else {

          c1 = faceColor;
          c2 = faceColor;
          c3 = faceColor;

        }

        colorArray[offset_color] = c1.r;
        colorArray[offset_color + 1] = c1.g;
        colorArray[offset_color + 2] = c1.b;

        colorArray[offset_color + 3] = c2.r;
        colorArray[offset_color + 4] = c2.g;
        colorArray[offset_color + 5] = c2.b;

        colorArray[offset_color + 6] = c3.r;
        colorArray[offset_color + 7] = c3.g;
        colorArray[offset_color + 8] = c3.b;

        offset_color += 9;

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces4[f]];

        vertexColors = face.vertexColors;
        faceColor = face.color;

        if (vertexColors.length == 4 && (material.vertexColors == VertexColors)) {

          c1 = vertexColors[0];
          c2 = vertexColors[1];
          c3 = vertexColors[2];
          c4 = vertexColors[3];

        } else {

          c1 = faceColor;
          c2 = faceColor;
          c3 = faceColor;
          c4 = faceColor;

        }

        colorArray[offset_color] = c1.r;
        colorArray[offset_color + 1] = c1.g;
        colorArray[offset_color + 2] = c1.b;

        colorArray[offset_color + 3] = c2.r;
        colorArray[offset_color + 4] = c2.g;
        colorArray[offset_color + 5] = c2.b;

        colorArray[offset_color + 6] = c3.r;
        colorArray[offset_color + 7] = c3.g;
        colorArray[offset_color + 8] = c3.b;

        colorArray[offset_color + 9] = c4.r;
        colorArray[offset_color + 10] = c4.g;
        colorArray[offset_color + 11] = c4.b;

        offset_color += 12;

      }

      if (offset_color > 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglColorBuffer);
        _gl.bufferDataTyped(gl.ARRAY_BUFFER, colorArray, hint);

      }

    }

    if (dirtyTangents && geometry.hasTangents) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces3[f]];

        vertexTangents = face.vertexTangents;

        t1 = vertexTangents[0];
        t2 = vertexTangents[1];
        t3 = vertexTangents[2];

        tangentArray[offset_tangent] = t1.x;
        tangentArray[offset_tangent + 1] = t1.y;
        tangentArray[offset_tangent + 2] = t1.z;
        tangentArray[offset_tangent + 3] = t1.w;

        tangentArray[offset_tangent + 4] = t2.x;
        tangentArray[offset_tangent + 5] = t2.y;
        tangentArray[offset_tangent + 6] = t2.z;
        tangentArray[offset_tangent + 7] = t2.w;

        tangentArray[offset_tangent + 8] = t3.x;
        tangentArray[offset_tangent + 9] = t3.y;
        tangentArray[offset_tangent + 10] = t3.z;
        tangentArray[offset_tangent + 11] = t3.w;

        offset_tangent += 12;

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces4[f]];

        vertexTangents = face.vertexTangents;

        t1 = vertexTangents[0];
        t2 = vertexTangents[1];
        t3 = vertexTangents[2];
        t4 = vertexTangents[3];

        tangentArray[offset_tangent] = t1.x;
        tangentArray[offset_tangent + 1] = t1.y;
        tangentArray[offset_tangent + 2] = t1.z;
        tangentArray[offset_tangent + 3] = t1.w;

        tangentArray[offset_tangent + 4] = t2.x;
        tangentArray[offset_tangent + 5] = t2.y;
        tangentArray[offset_tangent + 6] = t2.z;
        tangentArray[offset_tangent + 7] = t2.w;

        tangentArray[offset_tangent + 8] = t3.x;
        tangentArray[offset_tangent + 9] = t3.y;
        tangentArray[offset_tangent + 10] = t3.z;
        tangentArray[offset_tangent + 11] = t3.w;

        tangentArray[offset_tangent + 12] = t4.x;
        tangentArray[offset_tangent + 13] = t4.y;
        tangentArray[offset_tangent + 14] = t4.z;
        tangentArray[offset_tangent + 15] = t4.w;

        offset_tangent += 16;

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, tangentArray, hint);

    }

    if (dirtyNormals && (normalType != NoShading)) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces3[f]];

        vertexNormals = face.vertexNormals;
        faceNormal = face.normal;

        if (vertexNormals.length == 3 && needsSmoothNormals) {

          for (i = 0; i < 3; i++) {

            vn = vertexNormals[i];

            normalArray[offset_normal] = vn.x;
            normalArray[offset_normal + 1] = vn.y;
            normalArray[offset_normal + 2] = vn.z;

            offset_normal += 3;

          }

        } else {

          for (i = 0; i < 3; i++) {

            normalArray[offset_normal] = faceNormal.x;
            normalArray[offset_normal + 1] = faceNormal.y;
            normalArray[offset_normal + 2] = faceNormal.z;

            offset_normal += 3;

          }

        }

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        face = obj_faces[chunk_faces4[f]];

        vertexNormals = face.vertexNormals;
        faceNormal = face.normal;

        if (vertexNormals.length == 4 && needsSmoothNormals) {

          for (i = 0; i < 4; i++) {

            vn = vertexNormals[i];

            normalArray[offset_normal] = vn.x;
            normalArray[offset_normal + 1] = vn.y;
            normalArray[offset_normal + 2] = vn.z;

            offset_normal += 3;

          }

        } else {

          for (i = 0; i < 4; i++) {

            normalArray[offset_normal] = faceNormal.x;
            normalArray[offset_normal + 1] = faceNormal.y;
            normalArray[offset_normal + 2] = faceNormal.z;

            offset_normal += 3;

          }

        }

      }

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, normalArray, hint);

    }

    if (dirtyUvs && !obj_uvs.isEmpty && uvType) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        fi = chunk_faces3[f];

        uv = obj_uvs[fi];

        if (uv == null) continue;

        for (i = 0; i < 3; i++) {

          uvi = uv[i];

          uvArray[offset_uv] = uvi.u;
          uvArray[offset_uv + 1] = uvi.v;

          offset_uv += 2;

        }

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        fi = chunk_faces4[f];

        uv = obj_uvs[fi];

        if (uv == null) continue;

        for (i = 0; i < 4; i++) {

          uvi = uv[i];

          uvArray[offset_uv] = uvi.u;
          uvArray[offset_uv + 1] = uvi.v;

          offset_uv += 2;

        }

      }

      if (offset_uv > 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUVBuffer);
        _gl.bufferDataTyped(gl.ARRAY_BUFFER, uvArray, hint);

      }

    }

    if (dirtyUvs && (obj_uvs2 != null) && uvType) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        fi = chunk_faces3[f];

        uv2 = obj_uvs2[fi];

        if (uv2 == null) continue;

        for (i = 0; i < 3; i++) {

          uv2i = uv2[i];

          uv2Array[offset_uv2] = uv2i.u;
          uv2Array[offset_uv2 + 1] = uv2i.v;

          offset_uv2 += 2;

        }

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        fi = chunk_faces4[f];

        uv2 = obj_uvs2[fi];

        if (uv2 == null) continue;

        for (i = 0; i < 4; i++) {

          uv2i = uv2[i];

          uv2Array[offset_uv2] = uv2i.u;
          uv2Array[offset_uv2 + 1] = uv2i.v;

          offset_uv2 += 2;

        }

      }

      if (offset_uv2 > 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer);
        _gl.bufferDataTyped(gl.ARRAY_BUFFER, uv2Array, hint);

      }

    }

    if (dirtyElements) {

      fl = chunk_faces3.length;
      for (f = 0; f < fl; f++) {

        faceArray[offset_face] = vertexIndex;
        faceArray[offset_face + 1] = vertexIndex + 1;
        faceArray[offset_face + 2] = vertexIndex + 2;

        offset_face += 3;

        lineArray[offset_line] = vertexIndex;
        lineArray[offset_line + 1] = vertexIndex + 1;

        lineArray[offset_line + 2] = vertexIndex;
        lineArray[offset_line + 3] = vertexIndex + 2;

        lineArray[offset_line + 4] = vertexIndex + 1;
        lineArray[offset_line + 5] = vertexIndex + 2;

        offset_line += 6;

        vertexIndex += 3;

      }

      fl = chunk_faces4.length;
      for (f = 0; f < fl; f++) {

        faceArray[offset_face] = vertexIndex;
        faceArray[offset_face + 1] = vertexIndex + 1;
        faceArray[offset_face + 2] = vertexIndex + 3;

        faceArray[offset_face + 3] = vertexIndex + 1;
        faceArray[offset_face + 4] = vertexIndex + 2;
        faceArray[offset_face + 5] = vertexIndex + 3;

        offset_face += 6;

        lineArray[offset_line] = vertexIndex;
        lineArray[offset_line + 1] = vertexIndex + 1;

        lineArray[offset_line + 2] = vertexIndex;
        lineArray[offset_line + 3] = vertexIndex + 3;

        lineArray[offset_line + 4] = vertexIndex + 1;
        lineArray[offset_line + 5] = vertexIndex + 2;

        lineArray[offset_line + 6] = vertexIndex + 2;
        lineArray[offset_line + 7] = vertexIndex + 3;

        offset_line += 8;

        vertexIndex += 4;

      }

      _gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer);
      _gl.bufferDataTyped(gl.ELEMENT_ARRAY_BUFFER, faceArray, hint);

      _gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer);
      _gl.bufferDataTyped(gl.ELEMENT_ARRAY_BUFFER, lineArray, hint);

    }

    if (customAttributes != null) {

      il = customAttributes.length;
      for (i = 0; i < il; i++) {

        customAttribute = customAttributes[i];

        if (!customAttribute.__original.needsUpdate) continue;

        offset_custom = 0;
        offset_customSrc = 0;

        if (customAttribute.size == 1) {

          if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces3[f]];

              customAttribute.array[offset_custom] = customAttribute.value[face.a];
              customAttribute.array[offset_custom + 1] = customAttribute.value[face.b];
              customAttribute.array[offset_custom + 2] = customAttribute.value[face.c];

              offset_custom += 3;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces4[f]];

              customAttribute.array[offset_custom] = customAttribute.value[face.a];
              customAttribute.array[offset_custom + 1] = customAttribute.value[face.b];
              customAttribute.array[offset_custom + 2] = customAttribute.value[face.c];
              customAttribute.array[offset_custom + 3] = customAttribute.value[face.d];

              offset_custom += 4;

            }

          } else if (customAttribute.boundTo == "faces") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces3[f]];

              customAttribute.array[offset_custom] = value;
              customAttribute.array[offset_custom + 1] = value;
              customAttribute.array[offset_custom + 2] = value;

              offset_custom += 3;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces4[f]];

              customAttribute.array[offset_custom] = value;
              customAttribute.array[offset_custom + 1] = value;
              customAttribute.array[offset_custom + 2] = value;
              customAttribute.array[offset_custom + 3] = value;

              offset_custom += 4;

            }

          }

        } else if (customAttribute.size == 2) {

          if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces3[f]];

              v1 = customAttribute.value[face.a];
              v2 = customAttribute.value[face.b];
              v3 = customAttribute.value[face.c];

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;

              customAttribute.array[offset_custom + 2] = v2.x;
              customAttribute.array[offset_custom + 3] = v2.y;

              customAttribute.array[offset_custom + 4] = v3.x;
              customAttribute.array[offset_custom + 5] = v3.y;

              offset_custom += 6;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces4[f]];

              v1 = customAttribute.value[face.a];
              v2 = customAttribute.value[face.b];
              v3 = customAttribute.value[face.c];
              v4 = customAttribute.value[face.d];

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;

              customAttribute.array[offset_custom + 2] = v2.x;
              customAttribute.array[offset_custom + 3] = v2.y;

              customAttribute.array[offset_custom + 4] = v3.x;
              customAttribute.array[offset_custom + 5] = v3.y;

              customAttribute.array[offset_custom + 6] = v4.x;
              customAttribute.array[offset_custom + 7] = v4.y;

              offset_custom += 8;

            }

          } else if (customAttribute.boundTo == "faces") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces3[f]];

              v1 = value;
              v2 = value;
              v3 = value;

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;

              customAttribute.array[offset_custom + 2] = v2.x;
              customAttribute.array[offset_custom + 3] = v2.y;

              customAttribute.array[offset_custom + 4] = v3.x;
              customAttribute.array[offset_custom + 5] = v3.y;

              offset_custom += 6;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces4[f]];

              v1 = value;
              v2 = value;
              v3 = value;
              v4 = value;

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;

              customAttribute.array[offset_custom + 2] = v2.x;
              customAttribute.array[offset_custom + 3] = v2.y;

              customAttribute.array[offset_custom + 4] = v3.x;
              customAttribute.array[offset_custom + 5] = v3.y;

              customAttribute.array[offset_custom + 6] = v4.x;
              customAttribute.array[offset_custom + 7] = v4.y;

              offset_custom += 8;

            }

          }

        } else if (customAttribute.size == 3) {

          var pp;

          if (customAttribute.type == "c") {

            pp = ["r", "g", "b"];

          } else {

            pp = ["x", "y", "z"];

          }

          if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces3[f]];

              v1 = customAttribute.value[face.a];
              v2 = customAttribute.value[face.b];
              v3 = customAttribute.value[face.c];

              customAttribute.array[offset_custom] = v1[pp[0]];
              customAttribute.array[offset_custom + 1] = v1[pp[1]];
              customAttribute.array[offset_custom + 2] = v1[pp[2]];

              customAttribute.array[offset_custom + 3] = v2[pp[0]];
              customAttribute.array[offset_custom + 4] = v2[pp[1]];
              customAttribute.array[offset_custom + 5] = v2[pp[2]];

              customAttribute.array[offset_custom + 6] = v3[pp[0]];
              customAttribute.array[offset_custom + 7] = v3[pp[1]];
              customAttribute.array[offset_custom + 8] = v3[pp[2]];

              offset_custom += 9;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces4[f]];

              v1 = customAttribute.value[face.a];
              v2 = customAttribute.value[face.b];
              v3 = customAttribute.value[face.c];
              v4 = customAttribute.value[face.d];

              customAttribute.array[offset_custom] = v1[pp[0]];
              customAttribute.array[offset_custom + 1] = v1[pp[1]];
              customAttribute.array[offset_custom + 2] = v1[pp[2]];

              customAttribute.array[offset_custom + 3] = v2[pp[0]];
              customAttribute.array[offset_custom + 4] = v2[pp[1]];
              customAttribute.array[offset_custom + 5] = v2[pp[2]];

              customAttribute.array[offset_custom + 6] = v3[pp[0]];
              customAttribute.array[offset_custom + 7] = v3[pp[1]];
              customAttribute.array[offset_custom + 8] = v3[pp[2]];

              customAttribute.array[offset_custom + 9] = v4[pp[0]];
              customAttribute.array[offset_custom + 10] = v4[pp[1]];
              customAttribute.array[offset_custom + 11] = v4[pp[2]];

              offset_custom += 12;

            }

          } else if (customAttribute.boundTo == "faces") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces3[f]];

              v1 = value;
              v2 = value;
              v3 = value;

              customAttribute.array[offset_custom] = v1[pp[0]];
              customAttribute.array[offset_custom + 1] = v1[pp[1]];
              customAttribute.array[offset_custom + 2] = v1[pp[2]];

              customAttribute.array[offset_custom + 3] = v2[pp[0]];
              customAttribute.array[offset_custom + 4] = v2[pp[1]];
              customAttribute.array[offset_custom + 5] = v2[pp[2]];

              customAttribute.array[offset_custom + 6] = v3[pp[0]];
              customAttribute.array[offset_custom + 7] = v3[pp[1]];
              customAttribute.array[offset_custom + 8] = v3[pp[2]];

              offset_custom += 9;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces4[f]];

              v1 = value;
              v2 = value;
              v3 = value;
              v4 = value;

              customAttribute.array[offset_custom] = v1[pp[0]];
              customAttribute.array[offset_custom + 1] = v1[pp[1]];
              customAttribute.array[offset_custom + 2] = v1[pp[2]];

              customAttribute.array[offset_custom + 3] = v2[pp[0]];
              customAttribute.array[offset_custom + 4] = v2[pp[1]];
              customAttribute.array[offset_custom + 5] = v2[pp[2]];

              customAttribute.array[offset_custom + 6] = v3[pp[0]];
              customAttribute.array[offset_custom + 7] = v3[pp[1]];
              customAttribute.array[offset_custom + 8] = v3[pp[2]];

              customAttribute.array[offset_custom + 9] = v4[pp[0]];
              customAttribute.array[offset_custom + 10] = v4[pp[1]];
              customAttribute.array[offset_custom + 11] = v4[pp[2]];

              offset_custom += 12;

            }

          } else if (customAttribute.boundTo == "faceVertices") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces3[f]];

              v1 = value[0];
              v2 = value[1];
              v3 = value[2];

              customAttribute.array[offset_custom] = v1[pp[0]];
              customAttribute.array[offset_custom + 1] = v1[pp[1]];
              customAttribute.array[offset_custom + 2] = v1[pp[2]];

              customAttribute.array[offset_custom + 3] = v2[pp[0]];
              customAttribute.array[offset_custom + 4] = v2[pp[1]];
              customAttribute.array[offset_custom + 5] = v2[pp[2]];

              customAttribute.array[offset_custom + 6] = v3[pp[0]];
              customAttribute.array[offset_custom + 7] = v3[pp[1]];
              customAttribute.array[offset_custom + 8] = v3[pp[2]];

              offset_custom += 9;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces4[f]];

              v1 = value[0];
              v2 = value[1];
              v3 = value[2];
              v4 = value[3];

              customAttribute.array[offset_custom] = v1[pp[0]];
              customAttribute.array[offset_custom + 1] = v1[pp[1]];
              customAttribute.array[offset_custom + 2] = v1[pp[2]];

              customAttribute.array[offset_custom + 3] = v2[pp[0]];
              customAttribute.array[offset_custom + 4] = v2[pp[1]];
              customAttribute.array[offset_custom + 5] = v2[pp[2]];

              customAttribute.array[offset_custom + 6] = v3[pp[0]];
              customAttribute.array[offset_custom + 7] = v3[pp[1]];
              customAttribute.array[offset_custom + 8] = v3[pp[2]];

              customAttribute.array[offset_custom + 9] = v4[pp[0]];
              customAttribute.array[offset_custom + 10] = v4[pp[1]];
              customAttribute.array[offset_custom + 11] = v4[pp[2]];

              offset_custom += 12;

            }

          }

        } else if (customAttribute.size == 4) {

          if (customAttribute.boundTo == null || customAttribute.boundTo == "vertices") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces3[f]];

              v1 = customAttribute.value[face.a];
              v2 = customAttribute.value[face.b];
              v3 = customAttribute.value[face.c];

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;
              customAttribute.array[offset_custom + 2] = v1.z;
              customAttribute.array[offset_custom + 3] = v1.w;

              customAttribute.array[offset_custom + 4] = v2.x;
              customAttribute.array[offset_custom + 5] = v2.y;
              customAttribute.array[offset_custom + 6] = v2.z;
              customAttribute.array[offset_custom + 7] = v2.w;

              customAttribute.array[offset_custom + 8] = v3.x;
              customAttribute.array[offset_custom + 9] = v3.y;
              customAttribute.array[offset_custom + 10] = v3.z;
              customAttribute.array[offset_custom + 11] = v3.w;

              offset_custom += 12;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              face = obj_faces[chunk_faces4[f]];

              v1 = customAttribute.value[face.a];
              v2 = customAttribute.value[face.b];
              v3 = customAttribute.value[face.c];
              v4 = customAttribute.value[face.d];

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;
              customAttribute.array[offset_custom + 2] = v1.z;
              customAttribute.array[offset_custom + 3] = v1.w;

              customAttribute.array[offset_custom + 4] = v2.x;
              customAttribute.array[offset_custom + 5] = v2.y;
              customAttribute.array[offset_custom + 6] = v2.z;
              customAttribute.array[offset_custom + 7] = v2.w;

              customAttribute.array[offset_custom + 8] = v3.x;
              customAttribute.array[offset_custom + 9] = v3.y;
              customAttribute.array[offset_custom + 10] = v3.z;
              customAttribute.array[offset_custom + 11] = v3.w;

              customAttribute.array[offset_custom + 12] = v4.x;
              customAttribute.array[offset_custom + 13] = v4.y;
              customAttribute.array[offset_custom + 14] = v4.z;
              customAttribute.array[offset_custom + 15] = v4.w;

              offset_custom += 16;

            }

          } else if (customAttribute.boundTo == "faces") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces3[f]];

              v1 = value;
              v2 = value;
              v3 = value;

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;
              customAttribute.array[offset_custom + 2] = v1.z;
              customAttribute.array[offset_custom + 3] = v1.w;

              customAttribute.array[offset_custom + 4] = v2.x;
              customAttribute.array[offset_custom + 5] = v2.y;
              customAttribute.array[offset_custom + 6] = v2.z;
              customAttribute.array[offset_custom + 7] = v2.w;

              customAttribute.array[offset_custom + 8] = v3.x;
              customAttribute.array[offset_custom + 9] = v3.y;
              customAttribute.array[offset_custom + 10] = v3.z;
              customAttribute.array[offset_custom + 11] = v3.w;

              offset_custom += 12;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces4[f]];

              v1 = value;
              v2 = value;
              v3 = value;
              v4 = value;

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;
              customAttribute.array[offset_custom + 2] = v1.z;
              customAttribute.array[offset_custom + 3] = v1.w;

              customAttribute.array[offset_custom + 4] = v2.x;
              customAttribute.array[offset_custom + 5] = v2.y;
              customAttribute.array[offset_custom + 6] = v2.z;
              customAttribute.array[offset_custom + 7] = v2.w;

              customAttribute.array[offset_custom + 8] = v3.x;
              customAttribute.array[offset_custom + 9] = v3.y;
              customAttribute.array[offset_custom + 10] = v3.z;
              customAttribute.array[offset_custom + 11] = v3.w;

              customAttribute.array[offset_custom + 12] = v4.x;
              customAttribute.array[offset_custom + 13] = v4.y;
              customAttribute.array[offset_custom + 14] = v4.z;
              customAttribute.array[offset_custom + 15] = v4.w;

              offset_custom += 16;

            }

          } else if (customAttribute.boundTo == "faceVertices") {

            fl = chunk_faces3.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces3[f]];

              v1 = value[0];
              v2 = value[1];
              v3 = value[2];

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;
              customAttribute.array[offset_custom + 2] = v1.z;
              customAttribute.array[offset_custom + 3] = v1.w;

              customAttribute.array[offset_custom + 4] = v2.x;
              customAttribute.array[offset_custom + 5] = v2.y;
              customAttribute.array[offset_custom + 6] = v2.z;
              customAttribute.array[offset_custom + 7] = v2.w;

              customAttribute.array[offset_custom + 8] = v3.x;
              customAttribute.array[offset_custom + 9] = v3.y;
              customAttribute.array[offset_custom + 10] = v3.z;
              customAttribute.array[offset_custom + 11] = v3.w;

              offset_custom += 12;

            }

            fl = chunk_faces4.length;
            for (f = 0; f < fl; f++) {

              value = customAttribute.value[chunk_faces4[f]];

              v1 = value[0];
              v2 = value[1];
              v3 = value[2];
              v4 = value[3];

              customAttribute.array[offset_custom] = v1.x;
              customAttribute.array[offset_custom + 1] = v1.y;
              customAttribute.array[offset_custom + 2] = v1.z;
              customAttribute.array[offset_custom + 3] = v1.w;

              customAttribute.array[offset_custom + 4] = v2.x;
              customAttribute.array[offset_custom + 5] = v2.y;
              customAttribute.array[offset_custom + 6] = v2.z;
              customAttribute.array[offset_custom + 7] = v2.w;

              customAttribute.array[offset_custom + 8] = v3.x;
              customAttribute.array[offset_custom + 9] = v3.y;
              customAttribute.array[offset_custom + 10] = v3.z;
              customAttribute.array[offset_custom + 11] = v3.w;

              customAttribute.array[offset_custom + 12] = v4.x;
              customAttribute.array[offset_custom + 13] = v4.y;
              customAttribute.array[offset_custom + 14] = v4.z;
              customAttribute.array[offset_custom + 15] = v4.w;

              offset_custom += 16;

            }

          }

        }

        customAttribute.buffer.bind(gl.ARRAY_BUFFER);

        _gl.bufferDataTyped(gl.ARRAY_BUFFER, customAttribute.array, hint);

      }

    }

    if (dispose) {

      geometryGroup.__inittedArrays = false; //delete geometryGroup.__inittedArrays"];
      geometryGroup.__colorArray = null; //delete geometryGroup.__colorArray"];
      geometryGroup.__normalArray = null; //delete geometryGroup.__normalArray"];
      geometryGroup.__tangentArray = null; //delete geometryGroup.__tangentArray"];
      geometryGroup.__uvArray = null; //delete geometryGroup.__uvArray"];
      geometryGroup.__uv2Array = null; //delete geometryGroup.__uv2Array"];
      geometryGroup.__faceArray = null; //delete geometryGroup.__faceArray"];
      geometryGroup.__vertexArray = null; //delete geometryGroup.__vertexArray"];
      geometryGroup.__lineArray = null; //delete geometryGroup.__lineArray"];
      geometryGroup.__skinIndexArray = null; //delete geometryGroup.__skinIndexArray"];
      geometryGroup.__skinWeightArray = null; //delete geometryGroup.__skinWeightArray"];

    }

  }

  setDirectBuffers(BufferGeometry geometry, int hint, bool dispose) {

    var attributes = geometry.attributes;

    var index = geometry.aIndex;
    var position = geometry.aPosition;
    var normal = geometry.aNormal;
    var uv = geometry.aUV;
    var color = geometry.aColor;
    var tangent = geometry.aTangent;

    if (geometry.elementsNeedUpdate && index != null) {

      index.buffer.bind(gl.ELEMENT_ARRAY_BUFFER);
      _gl.bufferDataTyped(gl.ELEMENT_ARRAY_BUFFER, index.array, hint);

    }

    if (geometry.verticesNeedUpdate && position != null) {

      position.buffer.bind(gl.ARRAY_BUFFER);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, position.array, hint);

    }

    if (geometry.normalsNeedUpdate && normal != null) {

      normal.buffer.bind(gl.ARRAY_BUFFER);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, normal.array, hint);

    }

    if (geometry.uvsNeedUpdate && uv != null) {

      uv.buffer.bind(gl.ARRAY_BUFFER);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, uv.array, hint);

    }

    if (geometry.colorsNeedUpdate && color != null) {

      color.buffer.bind(gl.ARRAY_BUFFER);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, color.array, hint);

    }

    if (geometry.tangentsNeedUpdate && tangent != null) {

      tangent.buffer.bind(gl.ARRAY_BUFFER);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, tangent.array, hint);

    }

    if (dispose) {

      geometry.attributes.forEach((_, attribute) {
        attribute.array = null; //delete geometry.attributes[ i ].array;
      });

    }

  }

  // Buffer rendering

  renderBufferImmediate(Object3D object, program, material) {

    if (object.hasPositions && object.__webglVertexBuffer == null) object.__webglVertexBuffer = _gl.createBuffer();
    if (object.hasNormals && object.__webglNormalBuffer == null) object.__webglNormalBuffer = _gl.createBuffer();
    if (object.hasUvs && object.__webglUVBuffer == null) object.__webglUVBuffer = _gl.createBuffer();
    if (object.hasColors && object.__webglColorBuffer == null) object.__webglColorBuffer = _gl.createBuffer();

    if (object.hasPositions) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglVertexBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, object.positionArray, gl.DYNAMIC_DRAW);
      _gl.enableVertexAttribArray(program.attributes["position"]);
      _gl.vertexAttribPointer(program.attributes["position"], 3, gl.FLOAT, false, 0, 0);

    }

    if (object.hasNormals) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglNormalBuffer);

      if (material.shading == FlatShading) {

        var nx,
            ny,
            nz,
            nax,
            nbx,
            ncx,
            nay,
            nby,
            ncy,
            naz,
            nbz,
            ncz,
            normalArray,
            i,
            il = object.count * 3;

        for (i = 0; i < il; i += 9) {

          normalArray = object.normalArray;

          nax = normalArray[i];
          nay = normalArray[i + 1];
          naz = normalArray[i + 2];

          nbx = normalArray[i + 3];
          nby = normalArray[i + 4];
          nbz = normalArray[i + 5];

          ncx = normalArray[i + 6];
          ncy = normalArray[i + 7];
          ncz = normalArray[i + 8];

          nx = (nax + nbx + ncx) / 3;
          ny = (nay + nby + ncy) / 3;
          nz = (naz + nbz + ncz) / 3;

          normalArray[i] = nx;
          normalArray[i + 1] = ny;
          normalArray[i + 2] = nz;

          normalArray[i + 3] = nx;
          normalArray[i + 4] = ny;
          normalArray[i + 5] = nz;

          normalArray[i + 6] = nx;
          normalArray[i + 7] = ny;
          normalArray[i + 8] = nz;

        }

      }

      _gl.bufferDataTyped(gl.ARRAY_BUFFER, object.normalArray, gl.DYNAMIC_DRAW);
      _gl.enableVertexAttribArray(program.attributes["normal"]);
      _gl.vertexAttribPointer(program.attributes["normal"], 3, gl.FLOAT, false, 0, 0);

    }

    if (object.hasUvs && material.map) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglUVBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, object.uvArray, gl.DYNAMIC_DRAW);
      _gl.enableVertexAttribArray(program.attributes["uv"]);
      _gl.vertexAttribPointer(program.attributes["uv"], 2, gl.FLOAT, false, 0, 0);

    }

    if (object.hasColors && material.vertexColors != NoColors) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, object.__webglColorBuffer);
      _gl.bufferDataTyped(gl.ARRAY_BUFFER, object.colorArray, gl.DYNAMIC_DRAW);
      _gl.enableVertexAttribArray(program.attributes["color"]);
      _gl.vertexAttribPointer(program.attributes["color"], 3, gl.FLOAT, false, 0, 0);

    }

    _gl.drawArrays(gl.TRIANGLES, 0, object.count);

    object.count = 0;

  }

  renderBufferDirect(Camera camera, List<Light> lights, fog, Material material, BufferGeometry geometry,
      Object object) {

    if (!material.visible) return;

    var program, attributes, linewidth, primitives, a, attribute;

    program = setProgram(camera, lights, fog, material, object);

    attributes = program.attributes;

    var updateBuffers = false,
        wireframeBit = ((material is Wireframe) && (material as Wireframe).wireframe) ? 1 : 0,
        geometryHash = (geometry.id * 0xffffff) + (program.id * 2) + wireframeBit;

    if (geometryHash != _currentGeometryGroupHash) {

      _currentGeometryGroupHash = geometryHash;
      updateBuffers = true;

    }

    if (updateBuffers) {

      disableAttributes();

    }

    // render mesh

    if (object is Mesh) {

      var index = geometry.aIndex;

      // indexed triangles

      if (index != null) {

        var offsets = geometry.offsets;

        // if there is more than 1 chunk
        // must set attribute pointers to use new offsets for each chunk
        // even if geometry and materials didn't change

        if (offsets.length > 1) updateBuffers = true;

        for (var i = 0,
            il = offsets.length; i < il; i++) {

          var startIndex = offsets[i].index;

          if (updateBuffers) {

            // vertices

            var position = geometry.attributes["position"];
            var positionSize = position.itemSize;

            position.buffer.bind(gl.ARRAY_BUFFER);
            enableAttribute(attributes["position"]);
            _gl.vertexAttribPointer(
                attributes["position"],
                positionSize,
                gl.FLOAT,
                false,
                0,
                startIndex * positionSize * 4); // 4 bytes per Float32

            // normals

            var normal = geometry.attributes["normal"];

            if (attributes["normal"] >= 0 && normal != null) {

              var normalSize = normal.itemSize;

              normal.buffer.bind(gl.ARRAY_BUFFER);
              enableAttribute(attributes["normal"]);
              _gl.vertexAttribPointer(
                  attributes["normal"],
                  normalSize,
                  gl.FLOAT,
                  false,
                  0,
                  startIndex * normalSize * 4);

            }

            // uvs

            var uv = geometry.attributes["uv"];

            if (attributes["uv"] >= 0 && uv != null) {

              var uvSize = uv.itemSize;

              uv.buffer.bind(gl.ARRAY_BUFFER);
              enableAttribute(attributes["uv"]);
              _gl.vertexAttribPointer(attributes["uv"], uvSize, gl.FLOAT, false, 0, startIndex * uvSize * 4);

            }

            // colors

            var color = geometry.attributes["color"];

            if (attributes["color"] >= 0 && color != null) {

              var colorSize = color.itemSize;

              color.buffer.bind(gl.ARRAY_BUFFER);
              enableAttribute(attributes["color"]);
              _gl.vertexAttribPointer(attributes["color"], colorSize, gl.FLOAT, false, 0, startIndex * colorSize * 4);

            }

            // tangents

            var tangent = geometry.attributes["tangent"];

            if (attributes["tangent"] >= 0 && tangent != null) {

              var tangentSize = tangent.itemSize;

              tangent.buffer.bind(gl.ARRAY_BUFFER);
              enableAttribute(attributes["tangent"]);
              _gl.vertexAttribPointer(
                  attributes["tangent"],
                  tangentSize,
                  gl.FLOAT,
                  false,
                  0,
                  startIndex * tangentSize * 4);

            }

            // indices

            index.buffer.bind(gl.ELEMENT_ARRAY_BUFFER);

          }

          // render indexed triangles

          _gl.drawElements(
              gl.TRIANGLES,
              offsets[i].count,
              gl.UNSIGNED_SHORT,
              offsets[i].start * 2); // 2 bytes per Uint16

          info.render.calls++;
          info.render.vertices += offsets[i].count; // not really true, here vertices can be shared
          info.render.faces += offsets[i].count ~/ 3;

        }

        // non-indexed triangles

      } else {

        GeometryAttribute<Float32List> position = geometry.aPosition;

        if (updateBuffers) {

          // vertices


          var positionSize = position.itemSize;

          position.buffer.bind(gl.ARRAY_BUFFER);
          enableAttribute(attributes["position"]);
          _gl.vertexAttribPointer(attributes["position"], positionSize, gl.FLOAT, false, 0, 0);

          // normals

          GeometryAttribute<Float32List> normal = geometry.aNormal;

          if (attributes["normal"] >= 0 && normal != null) {

            var normalSize = normal.itemSize;

            normal.buffer.bind(gl.ARRAY_BUFFER);
            enableAttribute(attributes["normal"]);
            _gl.vertexAttribPointer(attributes["normal"], normalSize, gl.FLOAT, false, 0, 0);

          }

          // uvs

          GeometryAttribute<Float32List> uv = geometry.aUV;

          if (attributes["uv"] >= 0 && uv != null) {

            var uvSize = uv.itemSize;

            uv.buffer.bind(gl.ARRAY_BUFFER);
            enableAttribute(attributes["uv"]);
            _gl.vertexAttribPointer(attributes["uv"], uvSize, gl.FLOAT, false, 0, 0);

          }

          // colors

          GeometryAttribute<Float32List> color = geometry.aColor;

          if (attributes["color"] >= 0 && color != null) {

            var colorSize = color.itemSize;

            color.buffer.bind(gl.ARRAY_BUFFER);
            enableAttribute(attributes["color"]);
            _gl.vertexAttribPointer(attributes["color"], colorSize, gl.FLOAT, false, 0, 0);

          }

          // tangents

          GeometryAttribute<Float32List> tangent = geometry.aTangent;

          if (attributes["tangent"] >= 0 && tangent != null) {

            var tangentSize = tangent.itemSize;

            tangent.buffer.bind(gl.ARRAY_BUFFER);
            enableAttribute(attributes["tangent"]);
            _gl.vertexAttribPointer(attributes["tangent"], tangentSize, gl.FLOAT, false, 0, 0);

          }
        }

        // render non-indexed triangles

        _gl.drawArrays(gl.TRIANGLES, 0, position.numItems ~/ 3);

        info.render.calls++;
        info.render.vertices += position.numItems ~/ 3;
        info.render.faces += position.numItems ~/ 3 ~/ 3;

      }

      // render particles

    } else if (object is ParticleSystem) {

      if (updateBuffers) {

        // vertices

        var position = geometry.attributes["position"];
        var positionSize = position.itemSize;

        position.buffer.bind(gl.ARRAY_BUFFER);
        enableAttribute(attributes["position"]);
        _gl.vertexAttribPointer(attributes["position"], positionSize, gl.FLOAT, false, 0, 0);

        // colors

        var color = geometry.attributes["color"];

        if (attributes["color"] >= 0 && color != null) {

          var colorSize = color.itemSize;

          color.buffer.bind(gl.ARRAY_BUFFER);
          enableAttribute(attributes["color"]);
          _gl.vertexAttribPointer(attributes["color"], colorSize, gl.FLOAT, false, 0, 0);

        }

        // render particles

        _gl.drawArrays(gl.POINTS, 0, position.numItems ~/ 3);

        info.render.calls++;
        info.render.points += position.numItems ~/ 3;

      }

    }

  }

  renderBuffer(Camera camera, List<Light> lights, Fog fog, Material material, WebGLGeometry geometryGroup,
      Object3D object) {


    if (!material.visible) return;

    var program, attributes, linewidth, primitives, a, attribute, i, il;

    program = setProgram(camera, lights, fog, material, object);

    attributes = program.attributes;

    var updateBuffers = false,
        wireframeBit = ((material is Wireframe) && (material as Wireframe).wireframe) ? 1 : 0,
        geometryGroupHash = (geometryGroup.id * 0xffffff) + (program.id * 2) + wireframeBit;

    if (geometryGroupHash != _currentGeometryGroupHash) {

      _currentGeometryGroupHash = geometryGroupHash;
      updateBuffers = true;

    }

    if (updateBuffers) {

      disableAttributes();

    }
    // vertices

    if (((material is! Morphing) || ((material is Morphing) && !(material as Morphing).morphTargets)) &&
        attributes["position"] >= 0) {

      if (updateBuffers) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
        enableAttribute(attributes["position"]);
        _gl.vertexAttribPointer(attributes["position"], 3, gl.FLOAT, false, 0, 0);

      }

    } else {

      if ((object is Mesh) && object.morphTargetBase != 0) {

        setupMorphTargets(material, geometryGroup, object);

      }

    }


    if (updateBuffers) {

      // custom attributes

      // Use the per-geometryGroup custom attribute arrays which are setup in initMeshBuffers

      if (geometryGroup.__webglCustomAttributesList != null) {

        il = geometryGroup.__webglCustomAttributesList.length;
        for (i = 0; i < il; i++) {

          attribute = geometryGroup.__webglCustomAttributesList[i];

          if (attributes[attribute.buffer.belongsToAttribute] >= 0) {

            attribute.buffer.bind(gl.ARRAY_BUFFER);
            enableAttribute(attributes[attribute.buffer.belongsToAttribute]);
            _gl.vertexAttribPointer(
                attributes[attribute.buffer.belongsToAttribute],
                attribute.size,
                gl.FLOAT,
                false,
                0,
                0);

          }

        }

      }


      // colors

      if (attributes["color"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglColorBuffer);
        enableAttribute(attributes["color"]);
        _gl.vertexAttribPointer(attributes["color"], 3, gl.FLOAT, false, 0, 0);

      }

      // normals

      if (attributes["normal"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglNormalBuffer);
        enableAttribute(attributes["normal"]);
        _gl.vertexAttribPointer(attributes["normal"], 3, gl.FLOAT, false, 0, 0);

      }

      // tangents

      if (attributes["tangent"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglTangentBuffer);
        enableAttribute(attributes["tangent"]);
        _gl.vertexAttribPointer(attributes["tangent"], 4, gl.FLOAT, false, 0, 0);

      }

      // uvs

      if (attributes["uv"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUVBuffer);
        enableAttribute(attributes["uv"]);
        _gl.vertexAttribPointer(attributes["uv"], 2, gl.FLOAT, false, 0, 0);


      }

      if (attributes["uv2"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglUV2Buffer);
        enableAttribute(attributes["uv2"]);
        _gl.vertexAttribPointer(attributes["uv2"], 2, gl.FLOAT, false, 0, 0);

      }

      if ((material is Skinning) &&
          (material as Skinning).skinning &&
          attributes["skinIndex"] >= 0 &&
          attributes["skinWeight"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinIndicesBuffer);
        enableAttribute(attributes["skinIndex"]);
        _gl.vertexAttribPointer(attributes["skinIndex"], 4, gl.FLOAT, false, 0, 0);

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglSkinWeightsBuffer);
        enableAttribute(attributes["skinWeight"]);
        _gl.vertexAttribPointer(attributes["skinWeight"], 4, gl.FLOAT, false, 0, 0);

      }

      // line distances

      if (attributes["lineDistance"] >= 0) {

        _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglLineDistanceBuffer);
        enableAttribute(attributes["lineDistance"]);
        _gl.vertexAttribPointer(attributes["lineDistance"], 1, gl.FLOAT, false, 0, 0);

      }
    }

    // render mesh

    if (object is Mesh) {

      // wireframe

      if (material is Wireframe && (material as Wireframe).wireframe) {

        setLineWidth((material as Wireframe).wireframeLinewidth);

        if (updateBuffers) _gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglLineBuffer);
        _gl.drawElements(gl.LINES, geometryGroup.__webglLineCount, gl.UNSIGNED_SHORT, 0);

        // triangles

      } else {

        if (updateBuffers) _gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, geometryGroup.__webglFaceBuffer);
        _gl.drawElements(gl.TRIANGLES, geometryGroup.__webglFaceCount, gl.UNSIGNED_SHORT, 0);

      }

      info.render.calls++;
      info.render.vertices += geometryGroup.__webglFaceCount;
      info.render.faces += geometryGroup.__webglFaceCount ~/ 3;

      // render lines

    } else if (object is Line) {

      primitives = (object.type == LineStrip) ? gl.LINE_STRIP : gl.LINES;

      setLineWidth((material is LineBasicMaterial) ? material.linewidth : 0);

      _gl.drawArrays(primitives, 0, geometryGroup.__webglLineCount);

      info.render.calls++;

      // render particles

    } else if (object is ParticleSystem) {

      _gl.drawArrays(gl.POINTS, 0, geometryGroup.__webglParticleCount);

      info.render.calls++;
      info.render.points += geometryGroup.__webglParticleCount;

      // render ribbon

    } else if (object is Ribbon) {

      _gl.drawArrays(gl.TRIANGLE_STRIP, 0, geometryGroup.__webglVertexCount);

      info.render.calls++;

    }

  }

  enableAttribute(attribute) {

    var k = attribute.toString();

    if (_enabledAttributes[k] == null || !_enabledAttributes[k]) {

      _gl.enableVertexAttribArray(attribute);
      _enabledAttributes[k] = true;

    }

  }

  disableAttributes() {

    _enabledAttributes.forEach((attribute, enabled) {

      if (enabled) {

        _gl.disableVertexAttribArray(int.parse(attribute));
        _enabledAttributes[attribute] = false;

      }

    });

  }

  setupMorphTargets(Material material, WebGLGeometry geometryGroup, Mesh object) {

    // set base

    var attributes = material._program.attributes;

    if (object.morphTargetBase != -1 && attributes["position"] >= 0) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[object.morphTargetBase]);
      enableAttribute(attributes["position"]);
      _gl.vertexAttribPointer(attributes["position"], 3, gl.FLOAT, false, 0, 0);

    } else if (attributes["position"] >= 0) {

      _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglVertexBuffer);
      enableAttribute(attributes["position"]);
      _gl.vertexAttribPointer(attributes["position"], 3, gl.FLOAT, false, 0, 0);

    }

    if ((material is Morphing) && object.morphTargetForcedOrder.length > 0) {

      // set forced order

      var m = 0;
      var order = object.morphTargetForcedOrder;
      var influences = object.morphTargetInfluences;

      while (m < (material as Morphing).numSupportedMorphTargets && m < order.length) {

        if (attributes["morphTarget" + m] >= 0) {
          _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[order[m]]);
          enableAttribute(attributes["morphTarget" + m]);
          _gl.vertexAttribPointer(attributes["morphTarget$m"], 3, gl.FLOAT, false, 0, 0);
        }

        if (attributes["morphNormal" + m] >= 0 && (material as Morphing).morphNormals) {

          _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[order[m]]);
          enableAttribute(attributes["morphNormal" + m]);
          _gl.vertexAttribPointer(attributes["morphNormal$m"], 3, gl.FLOAT, false, 0, 0);

        }

        object.__webglMorphTargetInfluences[m] = influences[order[m]].toDouble();

        m++;
      }

    } else {

      // find the most influencing

      var influence;
      List<List> activeInfluenceIndices = [];
      var influences = (object is Mesh) ? object.morphTargetInfluences : 0;
      var i,
          il = influences.length;

      for (i = 0; i < il; i++) {

        influence = influences[i];

        if (influence > 0) {

          activeInfluenceIndices.add([i, influence]);

        }

      }

      if (activeInfluenceIndices.length > (material as Morphing).numSupportedMorphTargets) {

        activeInfluenceIndices.sort(numericalSort);
        activeInfluenceIndices.length = (material as Morphing).numSupportedMorphTargets;

      } else if (activeInfluenceIndices.length > (material as Morphing).numSupportedMorphNormals) {

        activeInfluenceIndices.sort(numericalSort);

      } else if (activeInfluenceIndices.length == 0) {

        activeInfluenceIndices.add([0, 0]);

      }

      var influenceIndex,
          m = 0;

      if (material is Morphing) {
        while (m < (material as Morphing).numSupportedMorphTargets) {

          if (m < activeInfluenceIndices.length &&
              activeInfluenceIndices[m] != null &&
              !activeInfluenceIndices[m].isEmpty) {

            influenceIndex = activeInfluenceIndices[m][0];

            _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphTargetsBuffers[influenceIndex]);
            enableAttribute(attributes["morphTarget$m"]);
            _gl.vertexAttribPointer(attributes["morphTarget$m"], 3, gl.FLOAT, false, 0, 0);

            if ((material as Morphing).morphNormals) {

              _gl.bindBuffer(gl.ARRAY_BUFFER, geometryGroup.__webglMorphNormalsBuffers[influenceIndex]);
              enableAttribute(attributes["morphNormal$m"]);
              _gl.vertexAttribPointer(attributes["morphNormal$m"], 3, gl.FLOAT, false, 0, 0);

            }

            object.__webglMorphTargetInfluences[m] = influences[influenceIndex].toDouble();

          } else {

            object.__webglMorphTargetInfluences[m] = 0.0;

          }

          m++;

        }
      }

    }

    // load updated influences uniform

    if (material._program.uniforms["morphTargetInfluences"] != null) {

      _gl.uniform1fv(material._program.uniforms["morphTargetInfluences"], object.__webglMorphTargetInfluences);

    }

  }

  // Sorting

  painterSort(a, b) => (a.z.isNaN || b.z.isNaN || a.z.isInfinite || b.z.isInfinite) ? 0 : (b.z - a.z).toInt();

  numericalSort(a, b) => (b[0] - a[0]).toInt();


  // Rendering

  @override
  render(Scene scene, Camera camera) => _render(scene, camera);

  void renderToTarget(Scene scene, Camera camera, WebGLRenderTarget renderTarget, [forceClear = false]) {
    _render(scene, camera, renderTarget: renderTarget, forceClear: forceClear);
  }

  _render(Scene scene, Camera camera, {renderTarget: null, forceClear: false}) {

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

    if (autoUpdateScene) scene.updateMatrixWorld();

    // update camera matrices and frustum

    if (camera.parent == null) camera.updateMatrixWorld();

    camera.matrixWorldInverse.copyInverse(camera.matrixWorld);

    _projScreenMatrix.setFrom(camera.projectionMatrix).multiply(camera.matrixWorldInverse);
    _frustum.setFromMatrix(_projScreenMatrix);

    // update WebGL objects

    if (autoUpdateObjects) initWebGLObjects(scene);

    // custom render plugins (pre pass)

    renderPlugins(renderPluginsPre, scene, camera);

    //

    info.render.calls = 0;
    info.render.vertices = 0;
    info.render.faces = 0;
    info.render.points = 0;

    setRenderTarget(renderTarget);

    if (autoClear || forceClear) {

      clear(autoClearColor, autoClearDepth, autoClearStencil);

    }

    // set matrices for regular objects (frustum culled)

    renderList = scene.__webglObjects;

    il = renderList.length;

    for (i = 0; i < il; i++) {

      webglObject = renderList[i];
      object = webglObject.object;

      webglObject.render = false;

      if (object.visible) {

        if (!(object is Mesh || object is ParticleSystem) || !(object.frustumCulled) || _frustum.contains(object)) {

          setupMatrices(object, camera);

          unrollBufferMaterial(webglObject);

          webglObject.render = true;

          if (sortObjects) {

            if (object.renderDepth != null) {

              webglObject.z = object.renderDepth;

            } else {
              _vector3 = object.matrixWorld.getTranslation();
              _vector3.applyProjection(_projScreenMatrix);

              webglObject.z = _vector3.z;

            }

          }

        }

      }

    }

    if (sortObjects) {

      renderList.sort(painterSort);

    }

    // set matrices for immediate objects

    renderList = scene.__webglObjectsImmediate;

    il = renderList.length;

    for (i = 0; i < il; i++) {

      webglObject = renderList[i];
      object = webglObject.object;

      if (object.visible) {

        setupMatrices(object, camera);

        unrollImmediateBufferMaterial(webglObject);

      }

    }

    if (scene.overrideMaterial != null) {

      var material = scene.overrideMaterial;

      setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);
      setDepthTest(material.depthTest);
      setDepthWrite(material.depthWrite);
      setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);

      renderObjects(scene.__webglObjects, false, "", camera, lights, fog, true, material);
      renderObjectsImmediate(scene.__webglObjectsImmediate, "", camera, lights, fog, false, material);

    } else {

      var material = null;

      // opaque pass (front-to-back order)

      setBlending(NoBlending);

      renderObjects(scene.__webglObjects, true, "opaque", camera, lights, fog, false, material);
      renderObjectsImmediate(scene.__webglObjectsImmediate, "opaque", camera, lights, fog, false, material);

      // transparent pass (back-to-front order)

      renderObjects(scene.__webglObjects, false, "transparent", camera, lights, fog, true, material);
      renderObjectsImmediate(scene.__webglObjectsImmediate, "transparent", camera, lights, fog, true, material);

    }

    // custom render plugins (post pass)

    renderPlugins(renderPluginsPost, scene, camera);


    // Generate mipmap if we're using any kind of mipmap filtering

    if ((renderTarget != null) &&
        renderTarget.generateMipmaps &&
        renderTarget.minFilter != NearestFilter &&
        renderTarget.minFilter != LinearFilter) {

      updateRenderTargetMipmap(renderTarget);

    }

    // Ensure depth buffer writing is enabled so it can be cleared on next render

    setDepthTest(true);
    setDepthWrite(true);

    // _gl.finish();

  }

  renderPlugins(List plugins, Scene scene, Camera camera) {

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

      plugin.render(scene, camera, _currentWidth, _currentHeight);

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

  renderObjects(List<WebGLObject> renderList, bool reverse, String materialType, Camera camera, List<Light> lights, fog,
      useBlending, [overrideMaterial = null]) {

    WebGLObject webglObject;
    var object, buffer, material;
    num start, end, delta;

    if (reverse) {

      start = renderList.length - 1;
      end = -1;
      delta = -1;

    } else {

      start = 0;
      end = renderList.length;
      delta = 1;
    }

    for (var i = start; i != end; i += delta) {

      webglObject = renderList[i];

      if (webglObject.render) {

        object = webglObject.object;
        buffer = webglObject.buffer;

        if (overrideMaterial != null) {

          material = overrideMaterial;

        } else {

          material = (materialType == "opaque") ? webglObject.opaque : webglObject.transparent;

          if (material == null) continue;

          if (useBlending) setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);

          setDepthTest(material.depthTest);
          setDepthWrite(material.depthWrite);
          setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);

        }

        setMaterialFaces(material);

        if (buffer is BufferGeometry) {

          renderBufferDirect(camera, lights, fog, material, buffer, object);

        } else {

          renderBuffer(camera, lights, fog, material, buffer, object);

        }

      }

    }

  }

  renderObjectsImmediate(renderList, materialType, camera, lights, fog, useBlending, [overrideMaterial]) {

    var webglObject, object, material, program, il;

    il = renderList.length;

    for (var i = 0; i < il; i++) {

      webglObject = renderList[i];
      object = webglObject.object;

      if (object.visible) {

        if (overrideMaterial) {

          material = overrideMaterial;

        } else {

          material = webglObject[materialType];

          if (!material) continue;

          if (useBlending) setBlending(material.blending, material.blendEquation, material.blendSrc, material.blendDst);

          setDepthTest(material.depthTest);
          setDepthWrite(material.depthWrite);
          setPolygonOffset(material.polygonOffset, material.polygonOffsetFactor, material.polygonOffsetUnits);

        }

        renderImmediateObject(camera, lights, fog, material, object);

      }

    }

  }

  renderImmediateObject(Camera camera, List<Light> lights, Fog fog, Material material, object) {

    var program = setProgram(camera, lights, fog, material, object);

    _currentGeometryGroupHash = -1;

    setMaterialFaces(material);

    if (object.immediateRenderCallback) {

      object.immediateRenderCallback(program, _gl, _frustum);

    } else {

      object.render((object) {
        renderBufferImmediate(object, program, material);
      });

    }

  }

  unrollImmediateBufferMaterial(WebGLObject webglobject) {

    var object = webglobject.object,
        material = object.material;

    if (material.transparent) {

      webglobject.transparent = material;
      webglobject.opaque = null;

    } else {

      webglobject.opaque = material;
      webglobject.transparent = null;

    }

  }

  unrollBufferMaterial(WebGLObject webglobject) {

    Object3D object = webglobject.object;
    WebGLGeometry buffer = webglobject.buffer;
    Material meshMaterial = object.material;
    int materialIndex;
    Material material;


    if (meshMaterial is MeshFaceMaterial) {

      materialIndex = buffer.materialIndex;

      if (materialIndex >= 0) {

        material = meshMaterial.materials[materialIndex];

        if (material.transparent) {

          webglobject.transparent = material;
          webglobject.opaque = null;

        } else {

          webglobject.opaque = material;
          webglobject.transparent = null;

        }

      }

    } else {

      material = meshMaterial;

      if (material != null) {

        if (material.transparent != null) {

          webglobject.transparent = material;
          webglobject.opaque = null;

        } else {

          webglobject.opaque = material;
          webglobject.transparent = null;

        }

      }

    }

  }

  // Geometry splitting

  sortFacesByMaterial(Geometry geometry, Material material) {

    var f, fl, face, materialIndex, vertices, materialHash, groupHash;

    Map<String, Map> hash_map = {};

    var numMorphTargets = geometry.morphTargets.length;
    var numMorphNormals = geometry.morphNormals.length;

    var usesFaceMaterial = material is MeshFaceMaterial;

    geometry.geometryGroups = {};

    fl = geometry.faces.length;
    for (f = 0; f < fl; f++) {

      face = geometry.faces[f];
      materialIndex = usesFaceMaterial ? face.materialIndex.toString() : "0";

      if (hash_map[materialIndex] == null) {

        hash_map[materialIndex] = {
          'hash': materialIndex,
          'counter': 0
        };

      }

      groupHash = "${hash_map[ materialIndex ]["hash"]}_${hash_map[ materialIndex ]["counter"]}";

      if (geometry.geometryGroups[groupHash] == null) {

        geometry.geometryGroups[groupHash] = new WebGLGeometry()
            ..faces3 = []
            ..faces4 = []
            ..materialIndex = int.parse(materialIndex)
            ..verticesCount = 0
            ..numMorphTargets = numMorphTargets
            ..numMorphNormals = numMorphNormals;
      }

      vertices = face.size;

      if (geometry.geometryGroups[groupHash].verticesCount + vertices > 65535) {

        hash_map[materialIndex]["counter"] += 1;
        groupHash = "${hash_map[ materialIndex ]["hash"]}_${hash_map[ materialIndex ]["counter"]}";

        if (geometry.geometryGroups[groupHash] == null) {

          geometry.geometryGroups[groupHash] = new WebGLGeometry()
              ..faces3 = []
              ..faces4 = []
              ..materialIndex = int.parse(materialIndex)
              ..verticesCount = 0
              ..numMorphTargets = numMorphTargets
              ..numMorphNormals = numMorphNormals;

        }

      }

      if (face.size == 3) {

        geometry.geometryGroups[groupHash].faces3.add(f);

      } else {

        geometry.geometryGroups[groupHash].faces4.add(f);

      }

      geometry.geometryGroups[groupHash].verticesCount += vertices;

    }

    geometry.geometryGroupsList = [];

    geometry.geometryGroups.forEach((k, g) {

      g.id = _geometryGroupCounter++;

      geometry.geometryGroupsList.add(g);

    });

    return;

  }

  // Objects refresh

  initWebGLObjects(Scene scene) {

    if (scene.__webglObjects == null) {

      scene.__webglObjects = [];
      scene.__webglObjectsImmediate = [];
      scene.__webglSprites = [];
      scene.__webglFlares = [];

    }

    while (scene.__objectsAdded.length > 0) {

      addObject(scene.__objectsAdded[0], scene);
      scene.__objectsAdded.removeAt(0);

    }

    while (scene.__objectsRemoved.length > 0) {

      removeObject(scene.__objectsRemoved[0], scene);
      scene.__objectsRemoved.removeAt(0);

    }

    // update must be called after objects adding / removal

    for (var o = 0,
        ol = scene.__webglObjects.length; o < ol; o++) {

      updateObject(scene.__webglObjects[o].object);

    }

  }

  // Objects adding

  addObject(Object3D object, Scene scene) {

    Geometry geometry = object.geometry;

    var material;

    if (!object.__webglInit) {

      object.__webglInit = true;

      object._modelViewMatrix = new Matrix4.identity();
      object._normalMatrix = new Matrix3.zero();

      if (geometry != null && !geometry.__webglInit) {

        geometry.__webglInit = true;
        //geometry.addEventListener( 'dispose', onGeometryDispose );

      }

      if (object is Mesh) {

        material = object.material;

        if ((object.geometry is Geometry) && (object.geometry is! BufferGeometry)) {

          if (geometry.geometryGroups == null) {

            sortFacesByMaterial(geometry, material);

          }

          // create separate VBOs per geometry chunk

          geometry.geometryGroups.forEach((k, geometryGroup) {

            // initialise VBO on the first access

            if (geometryGroup.__webglVertexBuffer == null) {

              createMeshBuffers(geometryGroup);
              initMeshBuffers(geometryGroup, object);

              geometry.verticesNeedUpdate = true;
              geometry.morphTargetsNeedUpdate = true;
              geometry.elementsNeedUpdate = true;
              geometry.uvsNeedUpdate = true;
              geometry.normalsNeedUpdate = true;
              geometry.tangentsNeedUpdate = true;
              geometry.colorsNeedUpdate = true;

            }

          });

        } else if (object.geometry is BufferGeometry) {

          initDirectBuffers(object.geometry);

        }

      } else if (object is Ribbon) {

        if (geometry.__webglVertexBuffer == null) {

          createRibbonBuffers(geometry);
          initRibbonBuffers(geometry, object);

          geometry.verticesNeedUpdate = true;
          geometry.colorsNeedUpdate = true;
          geometry.normalsNeedUpdate = true;

        }

      } else if (object is Line) {

        if (geometry.__webglVertexBuffer == null) {

          createLineBuffers(geometry);
          initLineBuffers(geometry, object);

          geometry.verticesNeedUpdate = true;
          geometry.colorsNeedUpdate = true;
          geometry.lineDistancesNeedUpdate = true;

        }

      } else if (object is ParticleSystem) {

        if (geometry.__webglVertexBuffer == null) {

          if ((object.geometry is Geometry) && (object.geometry is! BufferGeometry)) {
            createParticleBuffers(geometry);
            initParticleBuffers(geometry, object);

            geometry.verticesNeedUpdate = true;
            geometry.colorsNeedUpdate = true;

          } else if (object.geometry is BufferGeometry) {

            initDirectBuffers(object.geometry);

          }

        }

      }
    }

    if (!object.__webglActive) {

      if (object is Mesh) {

        if (object.geometry is BufferGeometry) {

          addBuffer(scene.__webglObjects, geometry, object);

        } else {

          geometry.geometryGroups.forEach((k, geometryGroup) {

            addBuffer(scene.__webglObjects, geometryGroup, object);

          });

        }

      } else if (object is Ribbon || object is Line || object is ParticleSystem) {

        addBuffer(scene.__webglObjects, geometry, object);

      } else if (object is ImmediateRenderObject || (object.immediateRenderCallback != null)) {

        addBufferImmediate(scene.__webglObjectsImmediate, object);

      } else if (object is Sprite) {

        scene.__webglSprites.add(object);

      } else if (object is LensFlare) {

        scene.__webglFlares.add(object);

      }

      object.__webglActive = true;

    }

  }

  addBuffer(List objlist, WebGLGeometry buffer, Object3D object) {

    var o = new WebGLObject(object, null, null, buffer);
    objlist.add(o);

  }

  addBufferImmediate(List objlist, Object3D object) {

    var o = new WebGLObject(object, null, null, null);

    objlist.add(o);

  }

  // Objects updates

  updateObject(Object3D object) {

    Geometry geometry = object.geometry;
    WebGLGeometry geometryGroup;
    var customAttributesDirty;

    Material material;

    bool hasAttributes = ((material is ShaderMaterial) && (material as ShaderMaterial).attributes != null);

    if (object is Mesh) {

      if (object.geometry is BufferGeometry) {

        if (geometry.verticesNeedUpdate ||
            geometry.elementsNeedUpdate ||
            geometry.uvsNeedUpdate ||
            geometry.normalsNeedUpdate ||
            geometry.colorsNeedUpdate ||
            geometry.tangentsNeedUpdate) {

          setDirectBuffers(geometry, gl.DYNAMIC_DRAW, !geometry.isDynamic);

        }

        geometry.verticesNeedUpdate = false;
        geometry.elementsNeedUpdate = false;
        geometry.uvsNeedUpdate = false;
        geometry.normalsNeedUpdate = false;
        geometry.colorsNeedUpdate = false;
        geometry.tangentsNeedUpdate = false;

      } else {

        // check all geometry groups

        for (var i = 0,
            il = geometry.geometryGroupsList.length; i < il; i++) {

          geometryGroup = geometry.geometryGroupsList[i];

          material = getBufferMaterial(object, geometryGroup);

          if (geometry.buffersNeedUpdate) {

            initMeshBuffers(geometryGroup, object);

          }

          customAttributesDirty = hasAttributes && areCustomAttributesDirty(material);

          if (geometry.verticesNeedUpdate ||
              geometry.morphTargetsNeedUpdate ||
              geometry.elementsNeedUpdate ||
              geometry.uvsNeedUpdate ||
              geometry.normalsNeedUpdate ||
              geometry.colorsNeedUpdate ||
              geometry.tangentsNeedUpdate ||
              customAttributesDirty) {

            setMeshBuffers(geometryGroup, object, gl.DYNAMIC_DRAW, !geometry.isDynamic, material);

          }

        }

        geometry.verticesNeedUpdate = false;
        geometry.morphTargetsNeedUpdate = false;
        geometry.elementsNeedUpdate = false;
        geometry.uvsNeedUpdate = false;
        geometry.normalsNeedUpdate = false;
        geometry.colorsNeedUpdate = false;
        geometry.tangentsNeedUpdate = false;

        geometry.buffersNeedUpdate = false;

        if (hasAttributes) {
          clearCustomAttributes(material);
        }

      }

    } else if (object is Ribbon) {

      material = getBufferMaterial(object, geometry);

      customAttributesDirty = ((material is ShaderMaterial) && (material as ShaderMaterial).attributes != null) &&
          areCustomAttributesDirty(material);

      if (geometry.verticesNeedUpdate ||
          geometry.colorsNeedUpdate ||
          geometry.normalsNeedUpdate ||
          customAttributesDirty) {

        setRibbonBuffers(geometry, gl.DYNAMIC_DRAW);

      }

      geometry.verticesNeedUpdate = false;
      geometry.colorsNeedUpdate = false;
      geometry.normalsNeedUpdate = false;

      if (hasAttributes) {
        clearCustomAttributes(material);
      }

    } else if (object is Line) {

      material = getBufferMaterial(object, geometry);

      customAttributesDirty = (hasAttributes) && areCustomAttributesDirty(material);

      if (geometry.verticesNeedUpdate ||
          geometry.colorsNeedUpdate ||
          geometry.lineDistancesNeedUpdate ||
          customAttributesDirty) {

        setLineBuffers(geometry, gl.DYNAMIC_DRAW);

      }

      geometry.verticesNeedUpdate = false;
      geometry.colorsNeedUpdate = false;
      geometry.lineDistancesNeedUpdate = false;

      if (hasAttributes) clearCustomAttributes(material);

    } else if (object is ParticleSystem) {

      if (geometry is BufferGeometry) {

        if (geometry.verticesNeedUpdate || geometry.colorsNeedUpdate) {

          setDirectBuffers(geometry, gl.DYNAMIC_DRAW, !geometry.isDynamic);

        }

        geometry.verticesNeedUpdate = false;
        geometry.colorsNeedUpdate = false;

      } else {

        material = getBufferMaterial(object, geometryGroup);

        customAttributesDirty = (hasAttributes) && areCustomAttributesDirty(material);

        if (geometry.verticesNeedUpdate || geometry.colorsNeedUpdate || object.sortParticles || customAttributesDirty) {

          setParticleBuffers(geometry, gl.DYNAMIC_DRAW, object);

        }

        geometry.verticesNeedUpdate = false;
        geometry.colorsNeedUpdate = false;

        if (hasAttributes) clearCustomAttributes(material);
      }

    }

  }

  // Objects updates - custom attributes check

  areCustomAttributesDirty(material) => material.attributes.values.any((a) => a.needsUpdate);

  clearCustomAttributes(material) => material.attributes.forEach((_, a) {
    a.needsUpdate = false;
  });

  // Objects removal

  removeObject(Object3D object, Scene scene) {

    if (object is Mesh || object is ParticleSystem || object is Ribbon || object is Line) {

      removeInstances(scene.__webglObjects, object);

    } else if (object is Sprite) {

      removeInstancesDirect(scene.__webglSprites, object);

    } else if (object is LensFlare) {

      removeInstancesDirect(scene.__webglFlares, object);

    } else if (object is ImmediateRenderObject || (object.immediateRenderCallback != null)) {

      removeInstances(scene.__webglObjectsImmediate, object);

    }

    object.__webglActive = false;

  }

  removeInstances(List objlist, Object3D object) {

    for (var o = objlist.length - 1; o >= 0; o--) {

      if (objlist[o].object == object) {

        objlist.removeAt(o);

      }

    }

  }

  removeInstancesDirect(List objlist, Object3D object) {

    for (var o = objlist.length - 1; o >= 0; o--) {

      if (identical(objlist[o], object)) {

        objlist.removeAt(o);

      }

    }

  }

  // Materials

  initMaterial(Material material, List<Light> lights, Fog fog, Object3D object) {

    //material.addEventListener( 'dispose', onMaterialDispose );

    var u, a, identifiers, i, parameters, maxLightCount, maxBones, maxShadows, shaderID;

    if (material is MeshDepthMaterial) {

      shaderID = 'depth';

    } else if (material is MeshNormalMaterial) {

      shaderID = 'normal';

    } else if (material is MeshBasicMaterial) {

      shaderID = 'basic';

    } else if (material is MeshLambertMaterial) {

      shaderID = 'lambert';

    } else if (material is MeshPhongMaterial) {

      shaderID = 'phong';

    } else if (material is LineBasicMaterial) {

      shaderID = 'basic';

      // TODO - Added LineDashedMaterial
      // } else if ( material.isLineDashedMaterial ) {

      //  shaderID = 'dashed';

    } else if (material is ParticleBasicMaterial) {

      shaderID = 'particle_basic';

    }

    if (shaderID != null) {

      setMaterialShaders(material, ShaderLib[shaderID]);

    }

    // heuristics to create shader parameters according to lights in the scene
    // (not to blow over maxLights budget)

    maxLightCount = allocateLights(lights);

    maxShadows = allocateShadows(lights);

    maxBones = allocateBones(object);

    material._program = buildProgram(
        shaderID,
        material._fragmentShader,
        material._vertexShader,
        material._uniforms,
        (material is ShaderMaterial) ? material.attributes : {},
        (material is ShaderMaterial) ? material.defines : {},
        map: (material is TextureMapping) ? (material as TextureMapping).map : null,
        envMap: (material is EnvironmentMapping) ? (material as EnvironmentMapping).envMap : null,
        lightMap: (material is EnvironmentMapping) ? (material as EnvironmentMapping).lightMap : null,
        bumpMap: (material is BumpMapping) ? (material as BumpMapping).bumpMap : null,
        normalMap: (material is BumpMapping) ? (material as BumpMapping).normalMap : null,
        specularMap: (material is EnvironmentMapping) ? (material as EnvironmentMapping).specularMap : null,
        vertexColors: material.vertexColors,
        fog: fog,
        useFog: material.fog,
        fogExp: fog is FogExp2,
        sizeAttenuation: (material is ParticleBasicMaterial) ? material.sizeAttenuation : false,
        skinning: (material is Skinning) ? (material as Skinning).skinning : false,
        maxBones: maxBones,
        useVertexTexture: supportsBoneTextures && object != null && object is SkinnedMesh && object.useVertexTexture,
        boneTextureWidth: (object != null && object is SkinnedMesh) ? object.boneTextureWidth : 0,
        boneTextureHeight: (object != null && object is SkinnedMesh) ? object.boneTextureHeight : 0,
        morphTargets: (material is Morphing) ? (material as Morphing).morphTargets : false,
        morphNormals: (material is Morphing) ? (material as Morphing).morphNormals : false,
        maxMorphTargets: maxMorphTargets,
        maxMorphNormals: maxMorphNormals,
        maxDirLights: maxLightCount['directional'],
        maxPointLights: maxLightCount['point'],
        maxSpotLights: maxLightCount['spot'],
        maxHemiLights: maxLightCount['hemi'],
        maxShadows: maxShadows,
        shadowMapEnabled: shadowMapEnabled && object.receiveShadow,
        shadowMapType: shadowMapType,
        shadowMapDebug: shadowMapDebug,
        shadowMapCascade: shadowMapCascade,
        alphaTest: material.alphaTest,
        metal: (material is MeshPhongMaterial) ? material.metal : false,
        perPixel: (material is MeshPhongMaterial) ? material.perPixel : false,
        wrapAround: (material is Lighting) ? (material as Lighting).wrapAround : false,
        doubleSided: material.side == DoubleSide,
        flipSided: material.side == BackSide);

    var attributes = material._program.attributes;

    if ((material is Morphing) && (material as Morphing).morphTargets) {

      (material as Morphing).numSupportedMorphTargets = 0;

      var id,
          base = "morphTarget";

      for (i = 0; i < maxMorphTargets; i++) {

        id = "$base$i";

        if (attributes[id] >= 0) {

          (material as Morphing).numSupportedMorphTargets++;

        }

      }

    }

    if ((material is Morphing) && (material as Morphing).morphNormals) {

      (material as Morphing).numSupportedMorphNormals = 0;

      var id,
          base = "morphNormal";

      for (i = 0; i < maxMorphNormals; i++) {

        id = "$base$i";

        if (attributes[id] >= 0) {

          (material as Morphing).numSupportedMorphNormals++;

        }

      }

    }

    material._uniformsList = [];

    material._uniforms.forEach((k, u) => material._uniformsList.add([u, k]));

  }

  setMaterialShaders(Material material, Map shaders) {

    material._uniforms = UniformsUtils.clone(shaders["uniforms"]);
    material._vertexShader = shaders["vertexShader"];
    material._fragmentShader = shaders["fragmentShader"];

  }

  setProgram(Camera camera, List<Light> lights, Fog fog, Material material, Object3D object) {

    _usedTextureUnits = 0;

    if (material.needsUpdate) {

      if (material._program != null) deallocateMaterial(material);

      initMaterial(material, lights, fog, object);
      material.needsUpdate = false;

    }

    if ((material is Morphing) && (material as Morphing).morphTargets) {

      if ((object as Mesh).__webglMorphTargetInfluences == null) {

        (object as Mesh).__webglMorphTargetInfluences = new Float32List(maxMorphTargets);

      }

    }

    var refreshMaterial = false;

    var program = material._program,
        p_uniforms = program.uniforms,
        m_uniforms = material._uniforms;

    if (!identical(program, _currentProgram)) {

      _gl.useProgram(program.glProgram);
      _currentProgram = program;

      refreshMaterial = true;

    }

    if (material.id != _currentMaterialId) {

      _currentMaterialId = material.id;
      refreshMaterial = true;

    }

    if (refreshMaterial || !identical(camera, _currentCamera)) {

      _gl.uniformMatrix4fv(p_uniforms["projectionMatrix"], false, camera.projectionMatrix.storage);

      if (!identical(camera, _currentCamera)) _currentCamera = camera;

    }


    // skinning uniforms must be set even if material didn't change
    // auto-setting of texture unit for bone texture must go before other textures
    // not sure why, but otherwise weird things happen

    if ((object is SkinnedMesh) && (material is Skinning) && (material as Skinning).skinning) {

      if (supportsBoneTextures && object.useVertexTexture) {

        if (p_uniforms.boneTexture != null) {

          var textureUnit = getTextureUnit();

          _gl.uniform1i(p_uniforms.boneTexture, textureUnit);
          setTexture(object.boneTexture, textureUnit);

        }

      } else {

        if (p_uniforms.boneGlobalMatrices != null) {

          _gl.uniformMatrix4fv(p_uniforms.boneGlobalMatrices, false, object.boneMatrices);

        }

      }

    }

    if (refreshMaterial) {

      // refresh uniforms common to several materials

      if ((fog != null) && material.fog) {

        refreshUniformsFog(m_uniforms, fog);

      }

      if ((material is MeshPhongMaterial) ||
          (material is MeshLambertMaterial) ||
          ((material is ShaderMaterial) && material.lights)) {

        if (_lightsNeedUpdate) {

          setupLights(program, lights);
          _lightsNeedUpdate = false;

        }

        refreshUniformsLights(m_uniforms, _lights);

      }

      if ((material is MeshBasicMaterial) || (material is MeshLambertMaterial) || (material is MeshPhongMaterial)) {

        refreshUniformsCommon(m_uniforms, material);

      }

      // refresh single material specific uniforms

      if (material is LineBasicMaterial) {

        refreshUniformsLine(m_uniforms, material);

        // TODO - Implement LineDashedMaterial
        //} else if ( material instanceof THREE.LineDashedMaterial ) {

        //  refreshUniformsLine( m_uniforms, material );
        //  refreshUniformsDash( m_uniforms, material );

      } else if (material is ParticleBasicMaterial) {

        refreshUniformsParticle(m_uniforms, material);

      } else if (material is MeshPhongMaterial) {

        refreshUniformsPhong(m_uniforms, material);

      } else if (material is MeshLambertMaterial) {

        refreshUniformsLambert(m_uniforms, material);

      } else if (material is MeshDepthMaterial) {

        m_uniforms["mNear"].value = camera.near;
        m_uniforms["mFar"].value = camera.far;
        m_uniforms["opacity"].value = material.opacity;

      } else if (material is MeshNormalMaterial) {

        m_uniforms["opacity"].value = material.opacity;

      }

      if (object.receiveShadow && !material.shadowPass) {

        refreshUniformsShadow(m_uniforms, lights);

      }

      // load common uniforms

      loadUniformsGeneric(program, material._uniformsList);

      // load material specific uniforms
      // (shader material also gets them for the sake of genericity)

      if ((material is ShaderMaterial) ||
          (material is MeshPhongMaterial) ||
          ((material is EnvironmentMapping) && (material as EnvironmentMapping).envMap != null)) {

        if (p_uniforms["cameraPosition"] != null) {

          _vector3 = camera.matrixWorld.getTranslation();
          _gl.uniform3f(p_uniforms["cameraPosition"], _vector3.x, _vector3.y, _vector3.z);

        }

      }

      if ((material is MeshPhongMaterial) ||
          (material is MeshLambertMaterial) ||
          (material is ShaderMaterial) ||
          ((material is Skinning) && (material as Skinning).skinning)) {

        if (p_uniforms["viewMatrix"] != null) {

          _gl.uniformMatrix4fv(p_uniforms["viewMatrix"], false, camera.matrixWorldInverse.storage);

        }

      }

    }

    loadUniformsMatrices(p_uniforms, object);

    if (p_uniforms["modelMatrix"] != null) {

      _gl.uniformMatrix4fv(p_uniforms["modelMatrix"], false, object.matrixWorld.storage);

    }

    return program;

  }

  // Uniforms (refresh uniforms objects)

  refreshUniformsCommon(Map<String, Uniform> uniforms, Material material) {

    uniforms["opacity"].value = material.opacity;

    if (gammaInput) {

      uniforms["diffuse"].value.copyGammaToLinear(material.color);

    } else {

      uniforms["diffuse"].value = material.color;

    }

    if (material is TextureMapping) {
      uniforms["map"].value = (material as TextureMapping).map;
    }

    if (material is EnvironmentMapping) {
      uniforms["lightMap"].value = (material as EnvironmentMapping).lightMap;
      uniforms["specularMap"].value = (material as EnvironmentMapping).specularMap;
    }

    if ((material is BumpMapping) && (material as BumpMapping).bumpMap != null) {

      uniforms["bumpMap"].value = (material as BumpMapping).bumpMap;
      uniforms["bumpScale"].value = (material as BumpMapping).bumpScale;

    }

    if ((material is BumpMapping) && (material as BumpMapping).normalMap != null) {

      uniforms["normalMap"].value = (material as BumpMapping).normalMap;
      uniforms["normalScale"].value.copy((material as BumpMapping).normalScale);

    }

    // uv repeat and offset setting priorities
    //  1. color map
    //  2. specular map
    //  3. normal map
    //  4. bump map

    var uvScaleMap;

    if ((material is TextureMapping) && (material as TextureMapping).map != null) {

      uvScaleMap = (material as TextureMapping).map;

    } else if ((material is EnvironmentMapping) && (material as EnvironmentMapping).specularMap != null) {

      uvScaleMap = (material as EnvironmentMapping).specularMap;

    } else if ((material is BumpMapping) && (material as BumpMapping).normalMap != null) {

      uvScaleMap = (material as BumpMapping).normalMap;

    } else if ((material is BumpMapping) && (material as BumpMapping).bumpMap != null) {

      uvScaleMap = (material as BumpMapping).bumpMap;

    }

    if (uvScaleMap != null) {

      var offset = uvScaleMap.offset;
      var repeat = uvScaleMap.repeat;

      uniforms["offsetRepeat"].value.setValues(offset.x, offset.y, repeat.x, repeat.y);

    }

    if (material is EnvironmentMapping) {
      EnvironmentMapping envMat = material as EnvironmentMapping;

      uniforms["envMap"].value = envMat.envMap;
      uniforms["flipEnvMap"].value = (envMat.envMap is WebGLRenderTargetCube) ? 1 : -1;


      if (gammaInput) {

        //uniforms["reflectivity"].value = material.reflectivity * material.reflectivity;
        uniforms["reflectivity"].value = envMat.reflectivity;

      } else {

        uniforms["reflectivity"].value = envMat.reflectivity;

      }

      uniforms["refractionRatio"].value = envMat.refractionRatio;
      uniforms["combine"].value = envMat.combine;
      uniforms["useRefract"].value =
          ((envMat.envMap != null) && (envMat.envMap.mapping is CubeRefractionMapping)) ? 1 : 0;
    }
  }

  refreshUniformsLine(Map<String, Uniform> uniforms, LineBasicMaterial material) {

    uniforms["diffuse"].value = material.color;
    uniforms["opacity"].value = material.opacity;

  }

  refreshUniformsDash(Map<String, Uniform> uniforms, material) {

    uniforms["dashSize"].value = material.dashSize;
    uniforms["totalSize"].value = material.dashSize + material.gapSize;
    uniforms["scale"].value = material.scale;

  }

  refreshUniformsParticle(Map<String, Uniform> uniforms, material) {

    uniforms["psColor"].value = material.color;
    uniforms["opacity"].value = material.opacity;
    uniforms["size"].value = material.size;
    uniforms["scale"].value = canvas.height / 2.0; // TODO: Cache

    uniforms["map"].value = material.map;

  }

  refreshUniformsFog(Map<String, Uniform> uniforms, Fog fog) {

    uniforms["fogColor"].value = fog.color;

    if (fog is FogLinear) {

      uniforms["fogNear"].value = fog.near;
      uniforms["fogFar"].value = fog.far;

    } else if (fog is FogExp2) {

      uniforms["fogDensity"].value = fog.density;

    }

  }

  refreshUniformsPhong(Map<String, Uniform> uniforms, MeshPhongMaterial material) {

    uniforms["shininess"].value = material.shininess;

    if (gammaInput) {

      uniforms["ambient"].value.copyGammaToLinear(material.ambient);
      uniforms["emissive"].value.copyGammaToLinear(material.emissive);
      uniforms["specular"].value.copyGammaToLinear(material.specular);

    } else {

      uniforms["ambient"].value = material.ambient;
      uniforms["emissive"].value = material.emissive;
      uniforms["specular"].value = material.specular;

    }

    if (material.wrapAround) {

      uniforms["wrapRGB"].value.copy(material.wrapRGB);

    }

  }

  refreshUniformsLambert(Map<String, Uniform> uniforms, MeshLambertMaterial material) {

    if (gammaInput) {

      uniforms["ambient"].value.copyGammaToLinear(material.ambient);
      uniforms["emissive"].value.copyGammaToLinear(material.emissive);

    } else {

      uniforms["ambient"].value = material.ambient;
      uniforms["emissive"].value = material.emissive;

    }

    if (material.wrapAround) {

      uniforms["wrapRGB"].value.copy(material.wrapRGB);

    }

  }

  refreshUniformsLights(Map<String, Uniform> uniforms, Map lights) {

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
    uniforms["spotLightAngleCos"].value = lights["spot"]["anglesCos"];
    uniforms["spotLightExponent"].value = lights["spot"]["exponents"];

    uniforms["hemisphereLightSkyColor"].value = lights["hemi"]["skyColors"];
    uniforms["hemisphereLightGroundColor"].value = lights["hemi"]["groundColors"];
    uniforms["hemisphereLightDirection"].value = lights["hemi"]["positions"];
  }

  refreshUniformsShadow(Map<String, Uniform> uniforms, lights) {

    if (uniforms.containsKey("shadowMatrix")) {

      var j = 0;

      for (var i = 0,
          il = lights.length; i < il; i++) {

        var light = lights[i];

        if (!light.castShadow) continue;

        if (light is SpotLight || (light is DirectionalLight && !light.shadowCascade)) {

          // Grow the arrays
          if (uniforms["shadowMap"].value.length < j + 1) {
            uniforms["shadowMap"].value.length = j + 1;
            uniforms["shadowMapSize"].value.length = j + 1;
            uniforms["shadowMatrix"].value.length = j + 1;
            uniforms["shadowDarkness"].value.length = j + 1;
            uniforms["shadowBias"].value.length = j + 1;
          }

          uniforms["shadowMap"].value[j] = light.shadowMap;
          uniforms["shadowMapSize"].value[j] = light.shadowMapSize;

          uniforms["shadowMatrix"].value[j] = light.shadowMatrix;

          uniforms["shadowDarkness"].value[j] = light.shadowDarkness;
          uniforms["shadowBias"].value[j] = light.shadowBias;

          j++;

        }

      }

    }

  }

  // Uniforms (load to GPU)

  loadUniformsMatrices(Map uniforms, Object3D object) {

    _gl.uniformMatrix4fv(uniforms["modelViewMatrix"], false, object._modelViewMatrix.storage);

    if (uniforms["normalMatrix"] != null) {

      _gl.uniformMatrix3fv(uniforms["normalMatrix"], false, object._normalMatrix.storage);

    }

  }

  int getTextureUnit() {

    var unit = _usedTextureUnits;

    if (unit >= maxTextures) {
      print("WebGLRenderer: trying to use $unit texture units while this GPU supports only $maxTextures");
    }

    _usedTextureUnits += 1;

    return unit;

  }

  loadUniformsGeneric(Program program, List<List<Uniform>> uniforms) {

    var uniform, value, type, location, texture, textureUnit, i, il, j, jl, offset;

    jl = uniforms.length;
    for (j = 0; j < jl; j++) {

      location = program.uniforms[uniforms[j][1]];
      if (location == null) continue;

      uniform = uniforms[j][0];

      type = uniform.type;
      value = uniform.typedValue; // Get the value properly typed

      if (type == "i") { // single integer

        _gl.uniform1i(location, value);

      } else if (type == "f") { // single float

        _gl.uniform1f(location, value);

      } else if (type == "v2") { // single THREE.Vector2

        _gl.uniform2f(location, value.x, value.y);

      } else if (type == "v3") { // single THREE.Vector3

        _gl.uniform3f(location, value.x, value.y, value.z);

      } else if (type == "v4") { // single THREE.Vector4

        _gl.uniform4f(location, value.x, value.y, value.z, value.w);

      } else if (type == "c") { // single THREE.Color

        _gl.uniform3f(location, value.r, value.g, value.b);

      } else if (type == "iv1") { // flat array of integers (JS or typed array)

        _gl.uniform1iv(location, value);

      } else if (type == "iv") { // flat array of integers with 3 x N size (JS or typed array)

        _gl.uniform3iv(location, value);

      } else if (type == "fv1") { // flat array of floats (JS or typed array)

        _gl.uniform1fv(location, value);

      } else if (type == "fv") { // flat array of floats with 3 x N size (JS or typed array)

        _gl.uniform3fv(location, value);

      } else if (type == "v2v") { // array of THREE.Vector2

        _gl.uniform2fv(location, value);

      } else if (type == "v3v") { // array of THREE.Vector3

        _gl.uniform3fv(location, value);

      } else if (type == "v4v") { // array of THREE.Vector4

        _gl.uniform4fv(location, value);

      } else if (type == "m2") { // single THREE.Matrix2

        _gl.uniformMatrix2fv(location, false, value);

      } else if (type == "m3") { // single THREE.Matrix3

        _gl.uniformMatrix3fv(location, false, value);

      } else if (type == "m4") { // single THREE.Matrix4

        _gl.uniformMatrix4fv(location, false, value);

      } else if (type == "m4v") { // array of THREE.Matrix4

        _gl.uniformMatrix4fv(location, false, value);

      } else if (type == "t") { // single THREE.Texture (2d or cube)

        texture = uniform.value;
        textureUnit = getTextureUnit();

        _gl.uniform1i(location, textureUnit);

        if (texture == null) continue;

        if ((texture.image is List) && texture.image.length == 6) {

          setCubeTexture(texture, textureUnit);

        } else if (texture is WebGLRenderTargetCube) {

          setCubeTextureDynamic(texture, textureUnit);

        } else {

          setTexture(texture, textureUnit);

        }

      } else if (type == "tv") { // array of THREE.Texture (2d)

        List<Texture> textures = uniform.value;

        uniform._array = new Int32List.fromList(textures.map((_) => getTextureUnit()).toList());

        _gl.uniform1iv(location, uniform._array);

        il = textures.length;
        for (i = 0; i < il; i++) {

          texture = uniform.value[i];
          textureUnit = uniform._array[i];

          if (texture == null) continue;

          setTexture(texture, textureUnit);

        }

      }

    }

  }

  setColorGamma(List<double> array, int offset, Color color, double intensitySq) {

    array[offset] = color.r * color.r * intensitySq;
    array[offset + 1] = color.g * color.g * intensitySq;
    array[offset + 2] = color.b * color.b * intensitySq;

  }

  setColorLinear(List<double> array, int offset, Color color, double intensity) {

    array[offset] = color.r * intensity;
    array[offset + 1] = color.g * intensity;
    array[offset + 2] = color.b * intensity;

  }

  setupMatrices(Object3D object, Camera camera) {

    object._modelViewMatrix = camera.matrixWorldInverse * object.matrixWorld;

    object._normalMatrix = calcInverse(object._modelViewMatrix);
    object._normalMatrix.transpose();

  }

  setupLights(Program program, List<Light> lights) {

    var l,
        ll,
        light,
        n,
        r = 0.0,
        g = 0.0,
        b = 0.0,
        color,
        skyColor,
        groundColor,
        intensity,
        intensitySq,
        position,
        distance,

        zlights = _lights;

    List dirColors = zlights["directional"]["colors"],
        dirPositions = zlights["directional"]["positions"],

        pointColors = zlights["point"]["colors"],
        pointPositions = zlights["point"]["positions"],
        pointDistances = zlights["point"]["distances"],

        spotColors = zlights["spot"]["colors"],
        spotPositions = zlights["spot"]["positions"],
        spotDistances = zlights["spot"]["distances"],
        spotDirections = zlights["spot"]["directions"],
        spotAnglesCos = zlights["spot"]["anglesCos"],
        spotExponents = zlights["spot"]["exponents"],

        hemiSkyColors = zlights["hemi"]["skyColors"],
        hemiGroundColors = zlights["hemi"]["groundColors"],
        hemiPositions = zlights["hemi"]["positions"];

    var dirLength = 0,
        pointLength = 0,
        spotLength = 0,
        hemiLength = 0,

        dirCount = 0,
        pointCount = 0,
        spotCount = 0,
        hemiCount = 0,

        dirOffset = 0,
        pointOffset = 0,
        spotOffset = 0,
        hemiOffset = 0;

    ll = lights.length;
    for (l = 0; l < ll; l++) {

      light = lights[l];

      // TODO - Setup proper interfaces for Light to avoid type checks
      if ((((light is DirectionalLight) || (light is SpotLight)) && (light as dynamic).onlyShadow) || !light.visible) {
        continue;
      }

      color = light.color;

      if ((light is DirectionalLight) || (light is SpotLight) || (light is PointLight)) {
        intensity = (light as dynamic).intensity;
        distance = (light as dynamic).distance;
      } else if (light is HemisphereLight) {
        intensity = (light as dynamic).intensity;
      }

      if (light is AmbientLight) {

        if (!light.visible) continue;

        if (gammaInput) {

          r += color.r * color.r;
          g += color.g * color.g;
          b += color.b * color.b;

        } else {

          r += color.r;
          g += color.g;
          b += color.b;

        }

      } else if (light is DirectionalLight) {

        dirCount += 1;

        if (!light.visible) continue;

        _direction = light.matrixWorld.getTranslation();
        _vector3 = light.target.matrixWorld.getTranslation();
        _direction.sub(_vector3);
        _direction.normalize();

        // skip lights with undefined direction
        // these create troubles in OpenGL (making pixel black)

        if (_direction.x == 0 && _direction.y == 0 && _direction.z == 0) continue;

        dirOffset = dirLength * 3;

        // Grow the lists
        dirColors.length = dirOffset + 3;
        dirPositions.length = dirOffset + 3;

        dirPositions[dirOffset] = _direction.x;
        dirPositions[dirOffset + 1] = _direction.y;
        dirPositions[dirOffset + 2] = _direction.z;


        if (gammaInput) {

          setColorGamma(dirColors, dirOffset, color, intensity * intensity);

        } else {

          setColorLinear(dirColors, dirOffset, color, intensity);

        }

        dirLength += 1;

      } else if (light is PointLight) {

        pointCount += 1;

        if (!light.visible) continue;

        pointOffset = pointLength * 3;

        // Grow the lists
        pointColors.length = pointOffset + 3;
        pointPositions.length = pointOffset + 3;

        if (gammaInput) {

          setColorGamma(pointColors, pointOffset, color, intensity * intensity);

        } else {

          setColorLinear(pointColors, pointOffset, color, intensity);

        }

        position = light.matrixWorld.getTranslation();

        pointPositions[pointOffset] = position.x;
        pointPositions[pointOffset + 1] = position.y;
        pointPositions[pointOffset + 2] = position.z;

        if (pointDistances == null) {
          pointDistances = new List();
          pointDistances.add(0);
        }
        while (pointDistances.length <= pointLength) {
          pointDistances.add(0);
        }
        pointDistances[pointLength] = distance;

        pointLength += 1;

      } else if (light is SpotLight) {

        spotCount += 1;

        spotOffset = spotLength * 3;

        if (!light.visible) continue;

        // Grow the lists
        spotColors.length = spotOffset + 3;
        spotPositions.length = spotOffset + 3;
        spotDirections.length = spotOffset + 3;
        spotDistances.length = spotLength + 1;

        if (gammaInput) {

          setColorGamma(spotColors, spotOffset, color, intensity * intensity);

        } else {

          setColorLinear(spotColors, spotOffset, color, intensity);

        }

        position = light.matrixWorld.getTranslation();

        spotPositions[spotOffset] = position.x;
        spotPositions[spotOffset + 1] = position.y;
        spotPositions[spotOffset + 2] = position.z;

        spotDistances[spotLength] = distance;

        _direction.setFrom(position);
        _direction.sub(light.target.matrixWorld.getTranslation());
        _direction.normalize();

        spotDirections[spotOffset] = _direction.x;
        spotDirections[spotOffset + 1] = _direction.y;
        spotDirections[spotOffset + 2] = _direction.z;

        // grow the arrays
        spotAnglesCos.length = spotLength + 1;
        spotExponents.length = spotLength + 1;

        spotAnglesCos[spotLength] = Math.cos(light.angle);
        spotExponents[spotLength] = light.exponent;

        spotLength += 1;

      } else if (light is HemisphereLight) {

        hemiCount += 1;

        if (!light.visible) continue;

        position = light.matrixWorld.getTranslation();
        _direction.setFrom(position);
        _direction.normalize();

        // skip lights with undefined direction
        // these create troubles in OpenGL (making pixel black)

        if (_direction.x == 0 && _direction.y == 0 && _direction.z == 0) continue;

        hemiOffset = hemiLength * 3;

        // Grow the lists
        hemiSkyColors.length = hemiOffset + 3;
        hemiGroundColors.length = hemiOffset + 3;
        hemiPositions.length = hemiOffset + 3;

        hemiPositions[hemiOffset] = _direction.x;
        hemiPositions[hemiOffset + 1] = _direction.y;
        hemiPositions[hemiOffset + 2] = _direction.z;

        skyColor = light.color;
        groundColor = light.groundColor;

        if (gammaInput) {

          intensitySq = intensity * intensity;

          setColorGamma(hemiSkyColors, hemiOffset, skyColor, intensitySq);
          setColorGamma(hemiGroundColors, hemiOffset, groundColor, intensitySq);

        } else {

          setColorLinear(hemiSkyColors, hemiOffset, skyColor, intensity);
          setColorLinear(hemiGroundColors, hemiOffset, groundColor, intensity);

        }

        hemiLength += 1;

      }

    }

    // null eventual remains from removed lights
    // (this is to avoid if in shader)

    ll = Math.max(dirColors.length, dirCount * 3);
    for (l = dirLength * 3; l < ll; l++) dirColors[l] = 0.0;
    ll = Math.max(pointColors.length, pointCount * 3);
    for (l = pointLength * 3; l < ll; l++) pointColors[l] = 0.0;
    ll = Math.max(spotColors.length, spotCount * 3);
    for (l = spotLength * 3; l < ll; l++) spotColors[l] = 0.0;
    ll = Math.max(hemiSkyColors.length, hemiCount * 3);
    for (l = hemiLength * 3; l < ll; l++) hemiSkyColors[l] = 0.0;
    ll = Math.max(hemiGroundColors.length, hemiCount * 3);
    for (l = hemiLength * 3; l < ll; l++) hemiGroundColors[l] = 0.0;

    zlights["directional"]["length"] = dirLength;
    zlights["point"]["length"] = pointLength;
    zlights["spot"]["length"] = spotLength;
    zlights["hemi"]["length"] = hemiLength;

    zlights["ambient"][0] = r;
    zlights["ambient"][1] = g;
    zlights["ambient"][2] = b;

  }

  // GL state setting

  setFaceCulling(int cullFace, int frontFaceDirection) {

    if (cullFace == CullFaceNone) {

      _gl.disable(gl.CULL_FACE);

    } else {

      if (frontFaceDirection == FrontFaceDirectionCW) {

        _gl.frontFace(gl.CW);

      } else {

        _gl.frontFace(gl.CCW);

      }

      if (cullFace == CullFaceBack) {

        _gl.cullFace(gl.BACK);

      } else if (cullFace == CullFaceFront) {

        _gl.cullFace(gl.FRONT);

      } else {

        _gl.cullFace(gl.FRONT_AND_BACK);

      }

      _gl.enable(gl.CULL_FACE);

    }

  }

  setMaterialFaces(Material material) {

    var doubleSided = material.side == DoubleSide;
    var flipSided = material.side == BackSide;

    if (_oldDoubleSided != doubleSided) {

      if (doubleSided) {

        _gl.disable(gl.CULL_FACE);

      } else {

        _gl.enable(gl.CULL_FACE);

      }

      _oldDoubleSided = doubleSided;

    }

    if (_oldFlipSided != flipSided) {

      if (flipSided) {

        _gl.frontFace(gl.CW);

      } else {

        _gl.frontFace(gl.CCW);

      }

      _oldFlipSided = flipSided;

    }

  }

  setDepthTest(bool depthTest) {

    if (_oldDepthTest != depthTest) {

      if (depthTest) {

        _gl.enable(gl.DEPTH_TEST);

      } else {

        _gl.disable(gl.DEPTH_TEST);

      }

      _oldDepthTest = depthTest;

    }

  }

  setDepthWrite(bool depthWrite) {

    if (_oldDepthWrite != depthWrite) {

      _gl.depthMask(depthWrite);
      _oldDepthWrite = depthWrite;

    }

  }

  setLineWidth(num width) {

    if (width != _oldLineWidth) {

      _gl.lineWidth(width);

      _oldLineWidth = width;

    }

  }

  setPolygonOffset(bool polygonoffset, num factor, num units) {

    if (_oldPolygonOffset != polygonoffset) {

      if (polygonoffset) {

        _gl.enable(gl.POLYGON_OFFSET_FILL);

      } else {

        _gl.disable(gl.POLYGON_OFFSET_FILL);

      }

      _oldPolygonOffset = polygonoffset;

    }

    if (polygonoffset && (_oldPolygonOffsetFactor != factor || _oldPolygonOffsetUnits != units)) {

      _gl.polygonOffset(factor, units);

      _oldPolygonOffsetFactor = factor;
      _oldPolygonOffsetUnits = units;

    }

  }

  setBlending(int blending, [blendEquation, blendSrc, blendDst]) {

    if (blending != _oldBlending) {

      if (blending == NoBlending) {

        _gl.disable(gl.BLEND);

      } else if (blending == AdditiveBlending) {

        _gl.enable(gl.BLEND);
        _gl.blendEquation(gl.FUNC_ADD);
        _gl.blendFunc(gl.SRC_ALPHA, gl.ONE);

      } else if (blending == SubtractiveBlending) {

        // TODO: Find blendFuncSeparate() combination
        _gl.enable(gl.BLEND);
        _gl.blendEquation(gl.FUNC_ADD);
        _gl.blendFunc(gl.ZERO, gl.ONE_MINUS_SRC_COLOR);

      } else if (blending == MultiplyBlending) {

        // TODO: Find blendFuncSeparate() combination
        _gl.enable(gl.BLEND);
        _gl.blendEquation(gl.FUNC_ADD);
        _gl.blendFunc(gl.ZERO, gl.SRC_COLOR);

      } else if (blending == CustomBlending) {

        _gl.enable(gl.BLEND);

      } else {

        _gl.enable(gl.BLEND);
        _gl.blendEquationSeparate(gl.FUNC_ADD, gl.FUNC_ADD);
        _gl.blendFuncSeparate(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE_MINUS_SRC_ALPHA);

      }

      _oldBlending = blending;

    }

    if (blending == CustomBlending) {

      if (blendEquation != _oldBlendEquation) {

        _gl.blendEquation(paramThreeToGL(blendEquation));

        _oldBlendEquation = blendEquation;

      }

      if (blendSrc != _oldBlendSrc || blendDst != _oldBlendDst) {

        _gl.blendFunc(paramThreeToGL(blendSrc), paramThreeToGL(blendDst));

        _oldBlendSrc = blendSrc;
        _oldBlendDst = blendDst;

      }

    } else {

      _oldBlendEquation = null;
      _oldBlendSrc = null;
      _oldBlendDst = null;

    }

  }

  // Defines

  String generateDefines(Map defines) {

    var chunk,
        chunks = [];

    defines.forEach((d, value) {

      if (value != false) {
        chunk = "#define $d $value";
        chunks.add(chunk);
      }

    });

    return chunks.join("\n");

  }

  // Shaders

  Program buildProgram(String shaderID, String fragmentShader, String vertexShader, Map uniforms, Map attributes,
      Map defines, {int maxDirLights: 0, int maxPointLights: 0, int maxSpotLights: 0, int maxHemiLights: 0, int maxShadows: 0,
      int maxBones: 0, Texture map: null, Texture envMap: null, Texture lightMap: null, Texture bumpMap: null,
      Texture normalMap: null, Texture specularMap: null, var vertexColors: NoColors, bool skinning: false,
      bool useVertexTexture: false, num boneTextureWidth: null, num boneTextureHeight: null, bool morphTargets: false,
      bool morphNormals: false, bool perPixel: false, bool wrapAround: false, bool doubleSided: false, bool flipSided: false,
      bool shadowMapEnabled: false, int shadowMapType, bool shadowMapDebug: false, bool shadowMapCascade: false,
      bool sizeAttenuation: false, Fog fog: null, bool useFog: false, bool fogExp: false, int maxMorphTargets: 8,
      int maxMorphNormals: 4, num alphaTest: 0, bool metal: false}) {

    var p, pl, glprogram, code;
    var chunks = [];

    // Generate code

    if (shaderID != null) {

      chunks.add(shaderID);

    } else {

      chunks.add(fragmentShader);
      chunks.add(vertexShader);

    }

    defines.forEach((d, define) {
      chunks.add(d);
      chunks.add(define);
    });

    code =
        "${chunks.join()}" "maxDirLights$maxDirLights" "maxPointLights$maxPointLights" "maxSpotLights$maxSpotLights"
            "maxHemiLights$maxHemiLights" "maxShadows$maxShadows" "maxBones$maxBones" "map$map" "envMap$envMap" "lightMap$lightMap"
            "bumpMap$bumpMap" "normalMap$normalMap" "specularMap$specularMap" "vertexColors$vertexColors" "fog$fog" "useFog$useFog"
            "fogExp$fogExp" "skinning$skinning" "useVertexTexture$useVertexTexture" "boneTextureWidth$boneTextureWidth"
            "boneTextureHeight$boneTextureHeight" "morphTargets$morphTargets" "morphNormals$morphNormals" "perPixel$perPixel"
            "wrapAround$wrapAround" "doubleSided$doubleSided" "flipSided$flipSided" "shadowMapEnabled$shadowMapEnabled"
            "shadowMapType$shadowMapType" "shadowMapDebug$shadowMapDebug" "shadowMapCascade$shadowMapCascade"
            "sizeAttenuation$sizeAttenuation";


    // Check if code has been already compiled

    pl = _programs.length;
    for (p = 0; p < pl; p++) {

      Program program = _programs[p];

      // TODO - why do we need identical here ?!
      if (program.code == code) {

        //print( "Code already compiled: $program$code" );

        program.usedTimes++;

        return program;

      }

    }

    var shadowMapTypeDefine = "SHADOWMAP_TYPE_BASIC";

    if (shadowMapType == PCFShadowMap) {

      shadowMapTypeDefine = "SHADOWMAP_TYPE_PCF";

    } else if (shadowMapType == PCFSoftShadowMap) {

      shadowMapTypeDefine = "SHADOWMAP_TYPE_PCF_SOFT";

    }

    //print( "building new program " );

    //

    var customDefines = generateDefines(defines);

    glprogram = _gl.createProgram();

    var prefix_vertex = [
        "precision $precision float;",
        customDefines,
        supportsVertexTextures ? "#define VERTEX_TEXTURES" : "",
        gammaInput ? "#define GAMMA_INPUT" : "",
        gammaOutput ? "#define GAMMA_OUTPUT" : "",
        physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",
        "#define MAX_DIR_LIGHTS $maxDirLights",
        "#define MAX_POINT_LIGHTS $maxPointLights",
        "#define MAX_SPOT_LIGHTS $maxSpotLights",
        "#define MAX_HEMI_LIGHTS $maxHemiLights",
        "#define MAX_SHADOWS $maxShadows",
        "#define MAX_BONES $maxBones",
        (map != null) ? "#define USE_MAP" : "",
        (envMap != null) ? "#define USE_ENVMAP" : "",
        (lightMap != null) ? "#define USE_LIGHTMAP" : "",
        (bumpMap != null) ? "#define USE_BUMPMAP" : "",
        (normalMap != null) ? "#define USE_NORMALMAP" : "",
        (specularMap != null) ? "#define USE_SPECULARMAP" : "",
        (((vertexColors is bool) && vertexColors) || ((vertexColors is int) && (vertexColors != NoColors))) ?
            "#define USE_COLOR" :
            "",
        skinning ? "#define USE_SKINNING" : "",
        useVertexTexture ? "#define BONE_TEXTURE" : "",
        (boneTextureWidth != null) ? "#define N_BONE_PIXEL_X ${boneTextureWidth.toStringAsFixed(1)}" : "",
        (boneTextureHeight != null) ? "#define N_BONE_PIXEL_Y ${boneTextureHeight.toStringAsFixed( 1 )}" : "",
        morphTargets ? "#define USE_MORPHTARGETS" : "",
        morphNormals ? "#define USE_MORPHNORMALS" : "",
        perPixel ? "#define PHONG_PER_PIXEL" : "",
        wrapAround ? "#define WRAP_AROUND" : "",
        doubleSided ? "#define DOUBLE_SIDED" : "",
        flipSided ? "#define FLIP_SIDED" : "",
        shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
        shadowMapEnabled ? "#define $shadowMapTypeDefine" : "",
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
        "attribute vec4 skinIndex;",
        "attribute vec4 skinWeight;",
        "#endif",
        ""].join("\n");

    var prefix_fragment = [
        "precision $precision float;",
        (bumpMap != null || normalMap != null) ? "#extension GL_OES_standard_derivatives : enable" : "",
        customDefines,
        (bumpMap != null) ? "#extension GL_OES_standard_derivatives : enable" : "",
        "#define MAX_DIR_LIGHTS $maxDirLights",
        "#define MAX_POINT_LIGHTS $maxPointLights",
        "#define MAX_SPOT_LIGHTS $maxSpotLights",
        "#define MAX_HEMI_LIGHTS $maxHemiLights",
        "#define MAX_SHADOWS $maxShadows",
        (alphaTest != 0) ? "#define ALPHATEST $alphaTest" : "",
        gammaInput ? "#define GAMMA_INPUT" : "",
        gammaOutput ? "#define GAMMA_OUTPUT" : "",
        physicallyBasedShading ? "#define PHYSICALLY_BASED_SHADING" : "",
        (useFog && (fog != null)) ? "#define USE_FOG" : "",
        (useFog && (fog is FogExp2)) ? "#define FOG_EXP2" : "",
        (map != null) ? "#define USE_MAP" : "",
        (envMap != null) ? "#define USE_ENVMAP" : "",
        (lightMap != null) ? "#define USE_LIGHTMAP" : "",
        (bumpMap != null) ? "#define USE_BUMPMAP" : "",
        (normalMap != null) ? "#define USE_NORMALMAP" : "",
        (specularMap != null) ? "#define USE_SPECULARMAP" : "",
        (((vertexColors is bool) && vertexColors) || ((vertexColors is int) && (vertexColors != NoColors))) ?
            "#define USE_COLOR" :
            "",
        metal ? "#define METAL" : "",
        perPixel ? "#define PHONG_PER_PIXEL" : "",
        wrapAround ? "#define WRAP_AROUND" : "",
        doubleSided ? "#define DOUBLE_SIDED" : "",
        flipSided ? "#define FLIP_SIDED" : "",
        shadowMapEnabled ? "#define USE_SHADOWMAP" : "",
        shadowMapEnabled ? "#define $shadowMapTypeDefine" : "",
        shadowMapDebug ? "#define SHADOWMAP_DEBUG" : "",
        shadowMapCascade ? "#define SHADOWMAP_CASCADE" : "",
        "uniform mat4 viewMatrix;",
        "uniform vec3 cameraPosition;",
        ""].join("\n");

    var glFragmentShader = getShader("fragment", "$prefix_fragment$fragmentShader");
    var glVertexShader = getShader("vertex", "$prefix_vertex$vertexShader");

    _gl.attachShader(glprogram, glVertexShader);
    _gl.attachShader(glprogram, glFragmentShader);

    _gl.linkProgram(glprogram);

    if (!_gl.getProgramParameter(glprogram, gl.LINK_STATUS)) {

      var status = _gl.getProgramParameter(glprogram, gl.VALIDATE_STATUS);
      var error = _gl.getError();
      print("Could not initialise shader\nVALIDATE_STATUS: $status, gl error [$error]");

    }

    // clean up

    _gl.deleteShader(glFragmentShader);
    _gl.deleteShader(glVertexShader);

    //print( prefix_fragment + fragmentShader );
    //print( prefix_vertex + vertexShader );

    //program.uniforms = {};
    //program.attributes = {};

    var program = new Program(_programs_counter++, glprogram, code, usedTimes: 1);

    var identifiers, u, a, i;

    // cache uniform locations

    identifiers = [
        'viewMatrix',
        'modelViewMatrix',
        'projectionMatrix',
        'normalMatrix',
        'modelMatrix',
        'cameraPosition',
        'morphTargetInfluences'];

    if (useVertexTexture) {

      identifiers.add('boneTexture');

    } else {

      identifiers.add('boneGlobalMatrices');

    }

    uniforms.forEach((u, _) => identifiers.add(u));

    cacheUniformLocations(program, identifiers);

    // cache attributes locations

    identifiers = ["position", "normal", "uv", "uv2", "tangent", "color", "skinIndex", "skinWeight", "lineDistance"];

    for (i = 0; i < maxMorphTargets; i++) {

      identifiers.add("morphTarget$i");

    }

    for (i = 0; i < maxMorphNormals; i++) {

      identifiers.add("morphNormal$i");

    }

    if (attributes != null) {
      attributes.forEach((a, _) => identifiers.add(a));
    }

    cacheAttributeLocations(program, identifiers);

    _programs.add(program);

    info.memory.programs = _programs.length;

    return program;

  }

  // Shader parameters cache

  cacheUniformLocations(Program program, List<String> identifiers) {

    var i, l, id;

    l = identifiers.length;
    for (i = 0; i < l; i++) {

      id = identifiers[i];
      program.uniforms[id] = _gl.getUniformLocation(program.glProgram, id);

    }

  }

  cacheAttributeLocations(Program program, List<String> identifiers) {

    var i, l, id;

    l = identifiers.length;
    for (i = 0; i < l; i++) {

      id = identifiers[i];
      program.attributes[id] = _gl.getAttribLocation(program.glProgram, id);

    }

  }

  addLineNumbers(String string) {

    var chunks = string.split("\n");

    var il = chunks.length;
    for (var i = 0; i < il; i++) {

      // Chrome reports shader errors on lines
      // starting counting from 1

      chunks[i] = "${i + 1}:${chunks[i]}";

    }

    return chunks.join("\n");

  }

  gl.Shader getShader(String type, String string) {

    var shader;

    if (type == "fragment") {

      shader = _gl.createShader(gl.FRAGMENT_SHADER);

    } else if (type == "vertex") {

      shader = _gl.createShader(gl.VERTEX_SHADER);

    }

    _gl.shaderSource(shader, string);
    _gl.compileShader(shader);

    if (!_gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {

      print(_gl.getShaderInfoLog(shader));
      print(addLineNumbers(string));
      return null;

    }

    return shader;

  }

  // Textures


  bool isPowerOfTwo(int value) => (value & (value - 1)) == 0;

  setTextureParameters(int textureType, Texture texture, bool isImagePowerOfTwo) {

    if (isImagePowerOfTwo) {

      _gl.texParameteri(textureType, gl.TEXTURE_WRAP_S, paramThreeToGL(texture.wrapS));
      _gl.texParameteri(textureType, gl.TEXTURE_WRAP_T, paramThreeToGL(texture.wrapT));

      _gl.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, paramThreeToGL(texture.magFilter));
      _gl.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, paramThreeToGL(texture.minFilter));

    } else {

      _gl.texParameteri(textureType, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
      _gl.texParameteri(textureType, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

      _gl.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, filterFallback(texture.magFilter));
      _gl.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, filterFallback(texture.minFilter));

    }

    if ((_glExtensionTextureFilterAnisotropic != null) && texture.type != FloatType) {

      if (texture.anisotropy > 1 || (texture["__oldAnisotropy"] != null)) {

        _gl.texParameterf(
            textureType,
            gl.ExtTextureFilterAnisotropic.TEXTURE_MAX_ANISOTROPY_EXT,
            Math.min(texture.anisotropy, maxAnisotropy));
        texture["__oldAnisotropy"] = texture.anisotropy;

      }

    }

  }

  _checkGLError() {
    int error = _gl.getError();
    if (error != 0) {
      print("gl error [$error]");
    }
  }

  setTexture(Texture texture, int slot) {

    if (texture.needsUpdate) {

      if (texture["__webglInit"] == null) {

        texture["__webglInit"] = true;

        //texture.addEventListener( 'dispose', onTextureDispose );

        texture["__webglTexture"] = _gl.createTexture();

        info.memory.textures++;

      }

      _gl.activeTexture(gl.TEXTURE0 + slot);
      _gl.bindTexture(gl.TEXTURE_2D, texture["__webglTexture"]);

      _gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, (texture.flipY) ? 1 : 0);
      _gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, (texture.premultiplyAlpha) ? 1 : 0);
      _gl.pixelStorei(gl.UNPACK_ALIGNMENT, texture.unpackAlignment);

      var image = texture.image,
          isImagePowerOfTwo = isPowerOfTwo(image.width) && isPowerOfTwo(image.height),
          glFormat = paramThreeToGL(texture.format),
          glType = paramThreeToGL(texture.type);

      setTextureParameters(gl.TEXTURE_2D, texture, isImagePowerOfTwo);

      var mipmap,
          mipmaps = texture.mipmaps;

      if (texture is DataTexture) {

        // use manually created mipmaps if available
        // if there are no manual mipmaps
        // set 0 level mipmap and then use GL to generate other mipmap levels

        if (mipmaps.length > 0 && isImagePowerOfTwo) {

          for (var i = 0,
              il = mipmaps.length; i < il; i++) {

            mipmap = mipmaps[i];
            _gl.texImage2DTyped(
                gl.TEXTURE_2D,
                i,
                glFormat,
                mipmap.width,
                mipmap.height,
                0,
                glFormat,
                glType,
                mipmap.data);

          }

          texture.generateMipmaps = false;

        } else {

          _gl.texImage2DTyped(gl.TEXTURE_2D, 0, glFormat, image.width, image.height, 0, glFormat, glType, image.data);

        }

      } else if (texture is CompressedTexture) {

        // compressed textures can only use manually created mipmaps
        // WebGL can't generate mipmaps for DDS textures

        for (var i = 0,
            il = mipmaps.length; i < il; i++) {

          mipmap = mipmaps[i];
          _gl.compressedTexImage2D(gl.TEXTURE_2D, i, glFormat, mipmap.width, mipmap.height, 0, mipmap.data);

        }

      } else {// regular Texture (image, video, canvas)

        // use manually created mipmaps if available
        // if there are no manual mipmaps
        // set 0 level mipmap and then use GL to generate other mipmap levels

        if (mipmaps.length > 0 && isImagePowerOfTwo) {

          for (var i = 0,
              il = mipmaps.length; i < il; i++) {

            mipmap = mipmaps[i];
            _gl.texImage2D(gl.TEXTURE_2D, i, glFormat, glFormat, glType, mipmap);

          }

          texture.generateMipmaps = false;

        } else if (texture.image is ImageElement) {

          _gl.texImage2DImage(gl.TEXTURE_2D, 0, glFormat, glFormat, glType, texture.image);

        } else if (texture.image is CanvasElement) {

          _gl.texImage2DCanvas(gl.TEXTURE_2D, 0, glFormat, glFormat, glType, texture.image);

        } else if (texture.image is VideoElement) {

          _gl.texImage2DVideo(gl.TEXTURE_2D, 0, glFormat, glFormat, glType, texture.image);

        }

      }

      if (texture.generateMipmaps && isImagePowerOfTwo) _gl.generateMipmap(gl.TEXTURE_2D);

      texture.needsUpdate = false;

      if (texture.onUpdate != null) texture.onUpdate();

    } else {

      _gl.activeTexture(gl.TEXTURE0 + slot);
      _gl.bindTexture(gl.TEXTURE_2D, texture["__webglTexture"]);

    }

  }

  clampToMaxSize(image, num maxSize) {

    if (image.width <= maxSize && image.height <= maxSize) {

      return image;

    }

    // Warning: Scaling through the canvas will only work with images that use
    // premultiplied alpha.

    var maxDimension = Math.max(image.width, image.height);
    var newWidth = (image.width * maxSize / maxDimension).floor();
    var newHeight = (image.height * maxSize / maxDimension).floor();

    var canvas = new CanvasElement();
    canvas.width = newWidth;
    canvas.height = newHeight;

    var ctx = canvas.context2D;
    ctx.drawImageScaledFromSource(image, 0, 0, image.width, image.height, 0, 0, newWidth, newHeight);

    return canvas;

  }

  setCubeTexture(Texture texture, int slot) {

    if (texture.image.length == 6) {
      if (texture.needsUpdate) {

        if (texture.image.webglTextureCube == null) {

          texture.image.webglTextureCube = _gl.createTexture();
          info.memory.textures++;
        }

        _gl.activeTexture(gl.TEXTURE0 + slot);
        _gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.image.webglTextureCube);

        _gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, (texture.flipY) ? 1 : 0);

        var isCompressed = texture is CompressedTexture;

        var cubeImage = new List(6);

        for (var i = 0; i < 6; i++) {

          if (autoScaleCubemaps && !isCompressed) {

            cubeImage[i] = clampToMaxSize(texture.image[i], maxCubemapSize);

          } else {

            cubeImage[i] = texture.image[i];

          }

        }

        var image = cubeImage[0],
            isImagePowerOfTwo = isPowerOfTwo(image.width) && isPowerOfTwo(image.height),
            glFormat = paramThreeToGL(texture.format),
            glType = paramThreeToGL(texture.type);

        setTextureParameters(gl.TEXTURE_CUBE_MAP, texture, isImagePowerOfTwo);

        for (var i = 0; i < 6; i++) {

          if (isCompressed) {

            var mipmap,
                mipmaps = cubeImage[i].mipmaps;

            for (var j = 0,
                jl = mipmaps.length; j < jl; j++) {

              mipmap = mipmaps[j];
              _gl.compressedTexImage2D(
                  gl.TEXTURE_CUBE_MAP_POSITIVE_X + i,
                  j,
                  glFormat,
                  mipmap.width,
                  mipmap.height,
                  0,
                  mipmap.data);

            }

          } else {

            _gl.texImage2DImage(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, glFormat, glFormat, glType, cubeImage[i]);

          }

        }

        if (texture.generateMipmaps && isImagePowerOfTwo) {

          _gl.generateMipmap(gl.TEXTURE_CUBE_MAP);

        }

        texture.needsUpdate = false;

        if (texture.onUpdate != null) texture.onUpdate();


      } else {

        _gl.activeTexture(gl.TEXTURE0 + slot);
        _gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.image.webglTextureCube);

      }

    }

  }

  setCubeTextureDynamic(Texture texture, int slot) {

    _gl.activeTexture(gl.TEXTURE0 + slot);
    _gl.bindTexture(gl.TEXTURE_CUBE_MAP, texture.__webglTexture);

  }

  // Render targets

  setupFrameBuffer(gl.Framebuffer framebuffer, WebGLRenderTarget renderTarget, int textureTarget) {

    _gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
    _gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, textureTarget, renderTarget.__webglTexture, 0);

  }

  setupRenderBuffer(gl.Renderbuffer renderbuffer, WebGLRenderTarget renderTarget) {

    _gl.bindRenderbuffer(gl.RENDERBUFFER, renderbuffer);

    if (renderTarget.depthBuffer && !renderTarget.stencilBuffer) {

      _gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, renderTarget.width, renderTarget.height);
      _gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);

      /* For some reason this is not working. Defaulting to RGBA4.
    } else if( ! renderTarget.depthBuffer && renderTarget.stencilBuffer ) {

			_gl.renderbufferStorage( gl.RENDERBUFFER, gl.STENCIL_INDEX8,
			*  renderTarget.width, renderTarget.height );
			_gl.framebufferRenderbuffer( gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT,
			*  WebGLRenderingContext.RENDERBUFFER, renderbuffer );
		*/
    } else if (renderTarget.depthBuffer && renderTarget.stencilBuffer) {

      _gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_STENCIL, renderTarget.width, renderTarget.height);
      _gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);

    } else {

      _gl.renderbufferStorage(gl.RENDERBUFFER, gl.RGBA4, renderTarget.width, renderTarget.height);

    }

  }

  setRenderTarget(WebGLRenderTarget renderTarget) {

    if ((renderTarget != null) && (renderTarget.__webglFramebuffer == null)) {

      //renderTarget.addEventListener( 'dispose', onRenderTargetDispose );

      renderTarget.__webglTexture = _gl.createTexture();

      info.memory.textures++;

      // Setup texture, create render and frame buffers

      var isTargetPowerOfTwo = isPowerOfTwo(renderTarget.width) && isPowerOfTwo(renderTarget.height),
          glFormat = paramThreeToGL(renderTarget.format),
          glType = paramThreeToGL(renderTarget.type);

      if (renderTarget is WebGLRenderTargetCube) {

        renderTarget.__webglFramebuffer = [];
        renderTarget.__webglRenderbuffer = [];

        _gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
        setTextureParameters(gl.TEXTURE_CUBE_MAP, renderTarget, isTargetPowerOfTwo);

        for (var i = 0; i < 6; i++) {

          renderTarget.__webglFramebuffer[i] = _gl.createFramebuffer();
          renderTarget.__webglRenderbuffer[i] = _gl.createRenderbuffer();

          _gl.texImage2DTyped(
              gl.TEXTURE_CUBE_MAP_POSITIVE_X + i,
              0,
              glFormat,
              renderTarget.width,
              renderTarget.height,
              0,
              glFormat,
              glType,
              null);

          setupFrameBuffer(renderTarget.__webglFramebuffer[i], renderTarget, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i);
          setupRenderBuffer(renderTarget.__webglRenderbuffer[i], renderTarget);

        }

        if (isTargetPowerOfTwo) _gl.generateMipmap(gl.TEXTURE_CUBE_MAP);

      } else {

        renderTarget.__webglFramebuffer = _gl.createFramebuffer();

        if (renderTarget.shareDepthFrom != null) {

          renderTarget.__webglRenderbuffer = renderTarget.shareDepthFrom.__webglRenderbuffer;

        } else {

          renderTarget.__webglRenderbuffer = _gl.createRenderbuffer();

        }

        _gl.bindTexture(gl.TEXTURE_2D, renderTarget.__webglTexture);
        setTextureParameters(gl.TEXTURE_2D, renderTarget, isTargetPowerOfTwo);

        _gl.texImage2DTyped(
            gl.TEXTURE_2D,
            0,
            glFormat,
            renderTarget.width,
            renderTarget.height,
            0,
            glFormat,
            glType,
            null);

        setupFrameBuffer(renderTarget.__webglFramebuffer, renderTarget, gl.TEXTURE_2D);

        if (renderTarget.shareDepthFrom != null) {

          if (renderTarget.depthBuffer && !renderTarget.stencilBuffer) {

            _gl.framebufferRenderbuffer(
                gl.FRAMEBUFFER,
                gl.DEPTH_ATTACHMENT,
                gl.RENDERBUFFER,
                renderTarget.__webglRenderbuffer);

          } else if (renderTarget.depthBuffer && renderTarget.stencilBuffer) {

            _gl.framebufferRenderbuffer(
                gl.FRAMEBUFFER,
                gl.DEPTH_STENCIL_ATTACHMENT,
                gl.RENDERBUFFER,
                renderTarget.__webglRenderbuffer);

          }

        } else {

          setupRenderBuffer(renderTarget.__webglRenderbuffer, renderTarget);

        }

        if (isTargetPowerOfTwo) _gl.generateMipmap(gl.TEXTURE_2D);

      }

      // Release everything

      if (renderTarget is WebGLRenderTargetCube) {

        _gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);

      } else {

        _gl.bindTexture(gl.TEXTURE_2D, null);

      }

      _gl.bindRenderbuffer(gl.RENDERBUFFER, null);
      _gl.bindFramebuffer(gl.FRAMEBUFFER, null);

    }

    var framebuffer, width, height, vx, vy;

    if (renderTarget != null) {

      if (renderTarget is WebGLRenderTargetCube) {

        framebuffer = renderTarget.__webglFramebuffer[renderTarget.activeCubeFace];

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

    if (!identical(framebuffer, _currentFramebuffer)) {

      _gl.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
      _gl.viewport(vx, vy, width, height);

      _currentFramebuffer = framebuffer;

    }

    _currentWidth = width;
    _currentHeight = height;

  }

  updateRenderTargetMipmap(WebGLRenderTarget renderTarget) {

    if (renderTarget is WebGLRenderTargetCube) {

      _gl.bindTexture(gl.TEXTURE_CUBE_MAP, renderTarget.__webglTexture);
      _gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
      _gl.bindTexture(gl.TEXTURE_CUBE_MAP, null);

    } else {

      _gl.bindTexture(gl.TEXTURE_2D, renderTarget.__webglTexture);
      _gl.generateMipmap(gl.TEXTURE_2D);
      _gl.bindTexture(gl.TEXTURE_2D, null);

    }

  }

  // Fallback filters for non-power-of-2 textures

  int filterFallback(int f) {

    if (f == NearestFilter || f == NearestMipMapNearestFilter || f == NearestMipMapLinearFilter) {

      return gl.NEAREST;

    }

    return gl.LINEAR;

  }

  // Map three.js constants to WebGL constants

  int paramThreeToGL(int p) {

    if (p == RepeatWrapping) return gl.REPEAT;
    if (p == ClampToEdgeWrapping) return gl.CLAMP_TO_EDGE;
    if (p == MirroredRepeatWrapping) return gl.MIRRORED_REPEAT;

    if (p == NearestFilter) return gl.NEAREST;
    if (p == NearestMipMapNearestFilter) return gl.NEAREST_MIPMAP_NEAREST;
    if (p == NearestMipMapLinearFilter) return gl.NEAREST_MIPMAP_LINEAR;

    if (p == LinearFilter) return gl.LINEAR;
    if (p == LinearMipMapNearestFilter) return gl.LINEAR_MIPMAP_NEAREST;
    if (p == LinearMipMapLinearFilter) return gl.LINEAR_MIPMAP_LINEAR;

    if (p == UnsignedByteType) return gl.UNSIGNED_BYTE;
    if (p == UnsignedShort4444Type) return gl.UNSIGNED_SHORT_4_4_4_4;
    if (p == UnsignedShort5551Type) return gl.UNSIGNED_SHORT_5_5_5_1;
    if (p == UnsignedShort565Type) return gl.UNSIGNED_SHORT_5_6_5;

    if (p == ByteType) return gl.BYTE;
    if (p == ShortType) return gl.SHORT;
    if (p == UnsignedShortType) return gl.UNSIGNED_SHORT;
    if (p == IntType) return gl.INT;
    if (p == UnsignedIntType) return gl.UNSIGNED_INT;
    if (p == FloatType) return gl.FLOAT;

    if (p == AlphaFormat) return gl.ALPHA;
    if (p == RGBFormat) return gl.RGB;
    if (p == RGBAFormat) return gl.RGBA;
    if (p == LuminanceFormat) return gl.LUMINANCE;
    if (p == LuminanceAlphaFormat) return gl.LUMINANCE_ALPHA;

    if (p == AddEquation) return gl.FUNC_ADD;
    if (p == SubtractEquation) return gl.FUNC_SUBTRACT;
    if (p == ReverseSubtractEquation) return gl.FUNC_REVERSE_SUBTRACT;

    if (p == ZeroFactor) return gl.ZERO;
    if (p == OneFactor) return gl.ONE;
    if (p == SrcColorFactor) return gl.SRC_COLOR;
    if (p == OneMinusSrcColorFactor) return gl.ONE_MINUS_SRC_COLOR;
    if (p == SrcAlphaFactor) return gl.SRC_ALPHA;
    if (p == OneMinusSrcAlphaFactor) return gl.ONE_MINUS_SRC_ALPHA;
    if (p == DstAlphaFactor) return gl.DST_ALPHA;
    if (p == OneMinusDstAlphaFactor) return gl.ONE_MINUS_DST_ALPHA;

    if (p == DstColorFactor) return gl.DST_COLOR;
    if (p == OneMinusDstColorFactor) return gl.ONE_MINUS_DST_COLOR;
    if (p == SrcAlphaSaturateFactor) return gl.SRC_ALPHA_SATURATE;

    if (_glExtensionCompressedTextureS3TC != null) {

      if (p == RGB_S3TC_DXT1_Format) return gl.CompressedTextureS3TC.COMPRESSED_RGB_S3TC_DXT1_EXT;
      if (p == RGBA_S3TC_DXT1_Format) return gl.CompressedTextureS3TC.COMPRESSED_RGBA_S3TC_DXT1_EXT;
      if (p == RGBA_S3TC_DXT3_Format) return gl.CompressedTextureS3TC.COMPRESSED_RGBA_S3TC_DXT3_EXT;
      if (p == RGBA_S3TC_DXT5_Format) return gl.CompressedTextureS3TC.COMPRESSED_RGBA_S3TC_DXT5_EXT;

    }
    return 0;

  }

  // Allocations

  int allocateBones(Object3D object) {

    if (supportsBoneTextures && (object != null) && object is SkinnedMesh && object.useVertexTexture) {

      return 1024;

    } else {

      // default for when object is not specified
      // ( for example when prebuilding shader
      //   to be used with multiple objects )
      //
      //   - leave some extra space for other uniforms
      //  - limit here is ANGLE's 254 max uniform vectors
      //    (up to 54 should be safe)

      int nVertexUniforms = _gl.getParameter(gl.MAX_VERTEX_UNIFORM_VECTORS);
      int nVertexMatrices = ((nVertexUniforms - 20) / 4).floor().toInt();

      var maxBones = nVertexMatrices;

      if (object != null && object is SkinnedMesh) {

        maxBones = Math.min(object.bones.length, maxBones);

        if (maxBones < object.bones.length) {

          print(
              "WebGLRenderer: too many bones - ${object.bones.length} , this GPU supports just $maxBones  (try OpenGL instead of ANGLE)");

        }

      }

      return maxBones;

    }

  }

  Map<String, int> allocateLights(List<Light> lights) {

    var l, ll, light, dirLights, pointLights, spotLights, hemiLights;

    dirLights = pointLights = spotLights = hemiLights = 0;

    ll = lights.length;
    for (l = 0; l < ll; l++) {

      light = lights[l];

      if (((light is DirectionalLight) || (light is SpotLight)) && (light as dynamic).onlyShadow) {
        continue;
      }

      if (light is DirectionalLight) dirLights++;
      if (light is PointLight) pointLights++;
      if (light is SpotLight) spotLights++;
      if (light is HemisphereLight) hemiLights++;

    }

    return {
      'directional': dirLights,
      'point': pointLights,
      'spot': spotLights,
      'hemi': hemiLights
    };

  }

  int allocateShadows(List<Light> lights) {

    var l,
        ll,
        light,
        maxShadows = 0;

    ll = lights.length;
    for (l = 0; l < ll; l++) {

      light = lights[l];

      if (!light.castShadow) continue;

      if (light is SpotLight) maxShadows++;
      if (light is DirectionalLight && !light.shadowCascade) maxShadows++;

    }

    return maxShadows;

  }

  // Initialization

  initGL() {

    try {
      _gl = canvas.getContext3d(
          alpha: alpha,
          premultipliedAlpha: premultipliedAlpha,
          antialias: antialias,
          stencil: stencil,
          preserveDrawingBuffer: preserveDrawingBuffer);
      if (_gl == null) {

        throw 'Error creating WebGL context.';

      }
    } catch (error) {

      print(error);

    }
    _glExtensionTextureFloat = _gl.getExtension('OES_texture_float');
    _glExtensionStandardDerivatives = _gl.getExtension('OES_standard_derivatives');

    _glExtensionTextureFilterAnisotropic = _gl.getExtension('EXT_texture_filter_anisotropic');
    if (_glExtensionTextureFilterAnisotropic == null) {
      _glExtensionTextureFilterAnisotropic = _gl.getExtension('MOZ_EXT_texture_filter_anisotropic');
    }
    if (_glExtensionTextureFilterAnisotropic == null) {
      _glExtensionTextureFilterAnisotropic = _gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic');
    }
    if (_glExtensionCompressedTextureS3TC == null) {
      _glExtensionCompressedTextureS3TC = _gl.getExtension('WEBGL_compressed_texture_s3tc');
    }
    if (_glExtensionCompressedTextureS3TC == null) {
      _glExtensionCompressedTextureS3TC = _gl.getExtension('MOZ_WEBGL_compressed_texture_s3tc');
    }
    if (_glExtensionCompressedTextureS3TC == null) {
      _glExtensionCompressedTextureS3TC = _gl.getExtension('WEBKIT_WEBGL_compressed_texture_s3tc');
    }

    if (_glExtensionTextureFloat == null) {

      print('THREE.WebGLRenderer: Float textures not supported.');

    }

    if (_glExtensionStandardDerivatives == null) {

      print('THREE.WebGLRenderer: Standard derivatives not supported.');

    }

    if (_glExtensionTextureFilterAnisotropic == null) {

      print('THREE.WebGLRenderer: Anisotropic texture filtering not supported.');

    }

    if (_glExtensionCompressedTextureS3TC == null) {

      print('THREE.WebGLRenderer: S3TC compressed textures not supported.');

    }
  }

  setDefaultGLState() {

    _gl.clearColor(0, 0, 0, 1);
    _gl.clearDepth(1);
    _gl.clearStencil(0);

    _gl.enable(gl.DEPTH_TEST);
    _gl.depthFunc(gl.LEQUAL);

    _gl.frontFace(gl.CCW);
    _gl.cullFace(gl.BACK);
    _gl.enable(gl.CULL_FACE);

    _gl.enable(gl.BLEND);
    _gl.blendEquation(gl.FUNC_ADD);
    _gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

    _gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearAlpha);

  }


}

//
// Rendering Info classes by nelsonsilva
//

/// An object with a series of statistical information about the graphics board
/// memory and the rendering process.
///
/// Useful for debugging or just for the sake of curiosity.
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

  Program(this.id, this.glProgram, this.code, {this.usedTimes: 0})
      : uniforms = {},
        attributes = {};
}

class Buffer {
  gl.RenderingContext context;
  gl.Buffer _glbuffer;
  String belongsToAttribute;
  Buffer(this.context) {
    _glbuffer = context.createBuffer();
  }
  bind(int target) {
    context.bindBuffer(target, _glbuffer);
  }
}

class WebGLGeometry {
  int id;

  int verticesCount;


  List faces3, faces4;
  int numMorphTargets, numMorphNormals;

  int materialIndex = 0;

  Map<String, Geometry> geometryGroups;
  var geometryGroupsList;

  gl.Buffer __webglVertexBuffer, __webglNormalBuffer, __webglTangentBuffer, __webglColorBuffer,
      __webglLineDistanceBuffer, __webglUVBuffer, __webglUV2Buffer, __webglSkinVertexABuffer, __webglSkinVertexBBuffer,
      __webglSkinIndicesBuffer, __webglSkinWeightsBuffer, __webglFaceBuffer, __webglLineBuffer;

  List<gl.Buffer> __webglMorphTargetsBuffers, __webglMorphNormalsBuffers;

  bool __webglInit = false;

  bool __inittedArrays;
  Float32List __vertexArray, __normalArray, __tangentArray, __colorArray, __lineDistanceArray, __uvArray, __uv2Array,
      __skinVertexAArray, __skinVertexBArray, __skinIndexArray, __skinWeightArray;
  Uint16List __faceArray, __lineArray;
  List<Float32List> __morphTargetsArrays, __morphNormalsArrays;
  int __webglFaceCount, __webglLineCount, __webglParticleCount, __webglVertexCount;

  List __sortArray;

  var __webglCustomAttributesList;
}

class WebGLObject {

  WebGLGeometry buffer;
  Object3D object;
  Material opaque, transparent;
  bool render;
  var z;

  WebGLObject(this.object, this.opaque, this.transparent, this.buffer, [this.render = true, this.z = 0]);

}
