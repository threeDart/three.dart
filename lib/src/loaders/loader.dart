part of three;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author nelson silva / http://www.inevo.pt/
 *
 * based on r51
 */

typedef void LoadStartCallback();
typedef void LoadCompleteCallback();
typedef void LoadProgressCallback(data);
typedef void LoadedCallback(Geometry geometry);

class Loader {

  Element statusDomElement;

  LoadStartCallback onLoadStart;
  LoadProgressCallback onLoadProgress;
  LoadCompleteCallback onLoadComplete;

  String crossOrigin = 'anonymous';

  Loader( [bool showStatus = false] ) :
    statusDomElement = showStatus ? Loader.addStatusElement() : null {
    onLoadStart = () {};
    onLoadProgress = (data) {};
    onLoadComplete = () {};
  }

  static addStatusElement() {
    var e = new Element.tag('div');
    e.style
      ..position = "absolute"
      ..right = "0px"
      ..top = "0px"
      ..fontSize = "0.8em"
      ..textAlign = "left"
      ..background = "rgba(0,0,0,0.25)"
      ..color = "#fff"
      ..width = "120px"
      ..padding = "0.5em 0.5em 0.5em 0.5em"
      ..zIndex = "1000";

    e.innerHtml = "Loading ...";

    return e;
  }

  _updateProgress( progress ) {

    var message = "Loaded ";

    if ( progress.total ) {

      message = "$message${ ( 100 * progress.loaded / progress.total ).toStringAsFixed(0)}%";


    } else {

      message = "$message${ ( progress.loaded / 1000 ).toFixed(2)} KB";

    }

    statusDomElement.innerHtml = message;

  }

  static _extractUrlBase( url ) {
    var parts = url.split( '/' );
    parts.removeLast();
    return "${( parts.length < 1 ? '.' : parts.join('/' ) )}/";
  }

  _initMaterials( Geometry geometry, List materials, String texturePath ) {

    geometry.materials = [];

    for ( var i = 0; i < materials.length; ++ i ) {
      geometry.materials.add( _createMaterial( materials[ i ], texturePath ));
    }

  }

  _hasNormals( Geometry geometry ) {

    var m, i, il = geometry.materials.length;

    for( i = 0; i < il; i ++ ) {

      m = geometry.materials[ i ];

      if ( m is ShaderMaterial ) return true;

    }

    return false;

  }

  _is_pow2( n ) {
    var l = Math.log( n ) / Math.LN2;
    return l.floor() == l;
  }

  _nearest_pow2( n ) {
    var l = Math.log( n ) / Math.LN2;
    return Math.pow( 2, l.round() );
  }

  _load_image( where, url ) {

    var image = new ImageElement();

    image.onLoad.listen((Event evt) {

      if ( !_is_pow2( image.width ) || !_is_pow2( image.height ) ) {

        var width = _nearest_pow2( image.width );
        var height = _nearest_pow2( image.height );

        where.image.width = width;
        where.image.height = height;
        where.image.getContext( '2d' ).drawImage( this, 0, 0, width, height );

      } else {

        where.image = this;

      }

      where.needsUpdate = true;

    });

    image.crossOrigin = crossOrigin;
    image.src = url;

  }

  _create_texture( texturePath, sourceFile, repeat, offset, wrap, anisotropy ) {

    var isCompressed = sourceFile.toLowerCase().endsWith( ".dds" );
    var fullPath = texturePath + "/" + sourceFile;
    var result;
    var texture;

    if ( isCompressed ) {

      texture = ImageUtils.loadCompressedTexture( fullPath );
      result = texture;

    } else {

      var texture = new Element.tag('canvas' );

      result = new Texture( texture );

    }

    // TODO(nelsonsilva) - do whe need this?
    // result.sourceFile = sourceFile;

    if( repeat ) {

      result.repeat.setValues( repeat[ 0 ], repeat[ 1 ] );

      if ( repeat[ 0 ] != 1 ) result.wrapS = RepeatWrapping;
      if ( repeat[ 1 ] != 1 ) result.wrapT = RepeatWrapping;

    }

    if ( offset ) {

      result.offset.setValues( offset[ 0 ], offset[ 1 ] );

    }

    if ( wrap ) {

      var wrapMap = {
                     "repeat": RepeatWrapping,
                     "mirror": MirroredRepeatWrapping
      };

      if ( wrapMap.containsKey( wrap[ 0 ] ) ) { result.wrapS = wrapMap[ wrap[ 0 ] ]; }
      if ( wrapMap.containsKey( wrap[ 1 ] ) ) { result.wrapT = wrapMap[ wrap[ 1 ] ]; }

    }

    if ( anisotropy ) {

      result.anisotropy = anisotropy;

    }

    if ( ! isCompressed ) {

      _load_image( result, fullPath );

    }

    return result;

  }

  _rgb2hex( rgb ) =>
      ( (rgb[ 0 ] * 255).toInt() << 16 ) +
      ( (rgb[ 1 ] * 255).toInt() << 8 ) +
      rgb[ 2 ].toInt() * 255;


  _createMaterial( Map m, String texturePath ) {
    IMaterial material;

    // defaults

    var mtype = "MeshLambertMaterial";

    // mpars
    var color = 0xeeeeee,
        opacity = 1.0,
        map = null,
        wireframe = false,
        vertexColors = null,
        blending = NormalBlending,
        transparent = false,
        depthTest = true,
        depthWrite = true,
        visible = true,
        side = FrontSide,
        specular = 0x111111,
        ambient = 0xffffff,
        shininess = null,
        lightMap = null,
        bumpMap = null,
        normalMap = null,
        specularMap = null,
        bumpScale = null;

    // parameters from model file

    if ( m.containsKey("shading") ) {

      var shading = m["shading"].toLowerCase();

      if ( shading == "phong" ) {
        mtype = "MeshPhongMaterial";
      } else if ( shading == "basic" ) {
        mtype = "MeshBasicMaterial";
      }

    }

    if ( m.containsKey("blending") ) { // TODO - && THREE[ m.blending ] != undefined ) {
      // TODO - Check if we're missing some blend modes or come up with a better way to make this work
      var blendmodes = {
        "NoBlending": NoBlending,
        "NormalBlending": NormalBlending,
        "AdditiveBlending": AdditiveBlending,
        "SubtractiveBlending": SubtractiveBlending,
        "MultiplyBlending": MultiplyBlending,
        "CustomBlending": CustomBlending
      };
      blending = blendmodes[ m["blending"] ];
    }

    if ( m.containsKey("transparent") || ( m.containsKey("opacity") && m["opacity"] < 1.0) ) {
      transparent = m["transparent"];
    }

    if ( m.containsKey("depthTest") ) {
      depthTest = m["depthTest"];
    }

    if ( m.containsKey("depthWrite") ) {
      depthWrite = m["depthWrite"];
    }

    if ( m.containsKey("visible") ) {
      visible = m["visible"];
    }

    if ( m.containsKey("flipSided") ) {
      side = BackSide;
    }

    if ( m.containsKey("doubleSided") ) {
      side = DoubleSide;
    }

    if ( m.containsKey("wireframe") ) {
      wireframe = m["wireframe"];
    }

    if ( m.containsKey("vertexColors") ) {
      if ( m["vertexColors"] == "face" ) {
        vertexColors = FaceColors;
      } else if ( !m["vertexColors"] ) {
        vertexColors = VertexColors;
      }
    }

    // colors

    if ( m.containsKey("colorDiffuse") ) {
      color = _rgb2hex( m["colorDiffuse"] );
    } else if ( m.containsKey("DbgColor") ) {
      color = m["DbgColor"];
    }

    if ( m.containsKey("colorSpecular") ) {
      specular = _rgb2hex( m["colorSpecular"] );
    }

    if ( m.containsKey("colorAmbient") ) {
      ambient = _rgb2hex( m["colorAmbient"] );
    }

    // modifiers

    if ( m.containsKey("transparency") ) {
      opacity = m["transparency"];
    }

    if ( m.containsKey("specularCoef") ) {
      shininess = m["specularCoef"];
    }

    // textures

    if ( m.containsKey("mapDiffuse") && (texturePath != null) ) {
      map = _create_texture( texturePath, m["mapDiffuse"], m["mapDiffuseRepeat"], m["mapDiffuseOffset"], m["mapDiffuseWrap"], m["mapDiffuseAnisotropy"] );
    }

    if ( m.containsKey("mapLight") && (texturePath != null) ) {
      lightMap = _create_texture( texturePath, m["mapLight"], m["mapLightRepeat"], m["mapLightOffset"], m["mapLightWrap"], m["mapLightAnisotropy"] );
    }

    if ( m.containsKey("mapBump") && (texturePath != null) ) {
      bumpMap = _create_texture( texturePath, m["mapBump"], m["mapBumpRepeat"], m["mapBumpOffset"], m["mapBumpWrap"], m["mapBumpAnisotropy"] );
    }

    if ( m.containsKey("mapNormal") && (texturePath != null) ) {
      normalMap = _create_texture( texturePath, m["mapNormal"], m["mapNormalRepeat"], m["mapNormalOffset"], m["mapNormalWrap"], m["mapNormalAnisotropy"] );
    }

    if ( m.containsKey("mapSpecular") && (texturePath != null) ) {
      specularMap = _create_texture( texturePath, m["mapSpecular"], m["mapSpecularRepeat"], m["mapSpecularOffset"], m["mapSpecularWrap"], m["mapSpecularAnisotropy"] );
    }

    //

    if ( m.containsKey("mapBumpScale") ) {
      bumpScale = m["mapBumpScale"];
    }

    // special case for normal mapped material

    if ( m.containsKey("mapNormal") ) {

      var shader = ShaderUtils.lib[ "normal" ];
      var uniforms = UniformsUtils.clone( shader.uniforms );

      uniforms[ "tNormal" ].value = normalMap;

      if ( m.containsKey("mapNormalFactor") ) {
        uniforms[ "uNormalScale" ].value.setValues( m["mapNormalFactor"], m["mapNormalFactor"] );
      }

      if ( map != null ) {
        uniforms[ "tDiffuse" ].value = map;
        uniforms[ "enableDiffuse" ].value = true;
      }

      if ( specularMap != null) {
        uniforms[ "tSpecular" ].value = specularMap;
        uniforms[ "enableSpecular" ].value = true;
      }

      if ( lightMap != null ) {
        uniforms[ "tAO" ].value = lightMap;
        uniforms[ "enableAO" ].value = true;
      }

      // for the moment don't handle displacement texture

      uniforms[ "uDiffuseColor" ].value.setHex( color );
      uniforms[ "uSpecularColor" ].value.setHex( specular );
      uniforms[ "uAmbientColor" ].value.setHex( ambient );

      uniforms[ "uShininess" ].value = shininess;

      if ( opacity != null ) {
        uniforms[ "uOpacity" ].value = opacity;
      }

      material = new ShaderMaterial(
                        fragmentShader: shader.fragmentShader,
                        vertexShader: shader.vertexShader,
                        uniforms: uniforms
                        //lights: true,
                        //fog: true
                        );

    } else {

      switch (mtype) {
        case "MeshLambertMaterial" :
          material = new MeshLambertMaterial(
                                 map: map,
                                 color: color,
                                 ambient: ambient,
                                 lightMap: lightMap,
                                 specularMap: specularMap,
                                 vertexColors: vertexColors,
                                 wireframe: wireframe,
                                 side: FrontSide,
                                 opacity: opacity,
                                 transparent: transparent,
                                 blending: blending,
                                 depthTest: depthTest,
                                 depthWrite: depthWrite,
                                 visible: visible);
          break;

        case "MeshPhongMaterial":
          material = new MeshPhongMaterial(
              map: map,
              color: color,
              ambient: ambient,
              shininess: shininess,
              lightMap: lightMap,
              bumpMap: bumpMap,
              bumpScale: bumpScale,
              specularMap: specularMap,
              vertexColors: vertexColors,
              wireframe: wireframe,
              side: FrontSide,
              opacity: opacity,
              transparent: transparent,
              blending: blending,
              depthTest: depthTest,
              depthWrite: depthWrite,
              visible: visible);
          break;

        case "MeshBasicMaterial":
          material = new MeshBasicMaterial(
              map: map,
              color: color,
              lightMap: lightMap,
              specularMap: specularMap,
              vertexColors: vertexColors,
              wireframe: wireframe,
              side: FrontSide,
              opacity: opacity,
              transparent: transparent,
              blending: blending,
              depthTest: depthTest,
              depthWrite: depthWrite,
              visible: visible);
          break;

        default:
          print("Unknow material type!");
      }


    }

    if ( m.containsKey("DbgName") ) {
      material.name = m["DbgName"];
    }

    return material;
  }
}

