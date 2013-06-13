part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class CanvasRenderer implements Renderer {
  Element domElement;

  bool _autoClear, _sortObjects, _sortElements;
  num _canvasWidth, _canvasHeight, _canvasWidthHalf, _canvasHeightHalf;

  Color _clearColor;
  num _clearOpacity;

  Camera _camera;

  CanvasElement _canvas;
  CanvasRenderingContext2D _context;

  num _contextGlobalAlpha, _contextGlobalCompositeOperation;

  var _contextStrokeStyle, _contextFillStyle;
  String _contextLineCap, _contextLineJoin;
  num _contextLineWidth;

  Rectangle _clipRect, _clearRect, _bboxRect;

  CanvasRenderData _info;

  ProjectorRenderData _renderData;
  List _elements, _lights;
  Projector _projector;

//  IRenderableObj _v1, _v2, _v3, _v4,

  RenderableVertex _v5, _v6;

  num _v1x, _v1y, _v2x, _v2y, _v3x, _v3y,
  _v4x, _v4y, _v5x, _v5y, _v6x, _v6y;

  Color _color, _color1, _color2, _color3, _color4;

  List _patterns, _imagedatas;

  num _near, _far;

  var _image;

  List _uvs;
  num _uv1x, _uv1y, _uv2x, _uv2y, _uv3x, _uv3y;

  bool _enableLighting;
  Color _ambientLight, _directionalLights, _pointLights;

  final num _pi2 = Math.PI * 2;
  Vector3 _vector3; // Needed for PointLight

  var _pixelMapImage, _pixelMapData;
  num _gradientMapQuality;

  CanvasElement _pixelMap;
  CanvasRenderingContext2D _pixelMapContext;

  CanvasElement _gradientMap;
  CanvasRenderingContext2D _gradientMapContext;

//  get domElement() {  _domElement;  }

  bool debug;

  set sortObjects( bool value ) {  _sortObjects = value;  }

  CanvasRenderer( [Map parameters] ) {
    parameters = parameters != null ? parameters : {};

    _projector = new Projector();

    _canvas = parameters['canvas'] != null ? parameters['canvas'] : new Element.tag('canvas');
    _context = _canvas.getContext( '2d' );

    debug = parameters['debug'] != null ? parameters['debug'] : false;

    _clearColor = new Color( 0x000000 );
    _clearOpacity = 0;

    _contextGlobalAlpha = 1;
    _contextGlobalCompositeOperation = 0;
    _contextStrokeStyle = null;
    _contextFillStyle = null;
    _contextLineWidth = null;
    _contextLineCap = null;
    _contextLineJoin = null;

    _v5 = new RenderableVertex();
    _v6 = new RenderableVertex();

    _color = new Color();
    _color1 = new Color();
    _color2 = new Color();
    _color3 = new Color();
    _color4 = new Color();

    _patterns = [];
    _imagedatas = [];

    _clipRect = new Rectangle();
    _clearRect = new Rectangle();
    _bboxRect = new Rectangle();

    _enableLighting = false;
    _ambientLight = new Color();
    _directionalLights = new Color();
    _pointLights = new Color();

    _vector3 = new Vector3.zero(); // Needed for PointLight

    _gradientMapQuality = 16;

    //_pixelMap = document.createElement( 'canvas' );
    _pixelMap = new Element.tag('canvas');
    _pixelMap.width = _pixelMap.height = 2;

    _pixelMapContext = _pixelMap.getContext( '2d' );
    _pixelMapContext.fillStyle = 'rgba(0,0,0,1)';
    _pixelMapContext.fillRect( 0, 0, 2, 2 );

    _pixelMapImage = _pixelMapContext.getImageData( 0, 0, 2, 2 );
    _pixelMapData = _pixelMapImage.data;

    //_gradientMap = document.createElement( 'canvas' );
    _gradientMap = new Element.tag('canvas');
    _gradientMap.width = _gradientMap.height = _gradientMapQuality;

    _gradientMapContext = _gradientMap.getContext( '2d' );
    _gradientMapContext.translate( - _gradientMapQuality / 2, - _gradientMapQuality / 2 );
    _gradientMapContext.scale( _gradientMapQuality, _gradientMapQuality );

    _gradientMapQuality --; // Fix UVs

    domElement = _canvas;

    _autoClear = true;
    _sortObjects = true;
    _sortElements = true;

    _info = new CanvasRenderData();
    /*
    _info = {
      "render": {
        "vertices": 0,
        "faces": 0
      }
    };
    */
  }

  void setSize( num width, num height ) {
    _canvasWidth = width;
    _canvasHeight = height;
    _canvasWidthHalf = ( _canvasWidth / 2 ).floor();
    _canvasHeightHalf = ( _canvasHeight / 2 ).floor();

    _canvas.width = _canvasWidth;
    _canvas.height = _canvasHeight;

    _clipRect.setValues( - _canvasWidthHalf, - _canvasHeightHalf, _canvasWidthHalf, _canvasHeightHalf );
    _clearRect.setValues( - _canvasWidthHalf, - _canvasHeightHalf, _canvasWidthHalf, _canvasHeightHalf );

    _contextGlobalAlpha = 1;
    _contextGlobalCompositeOperation = 0;
    _contextStrokeStyle = null;
    _contextFillStyle = null;
    _contextLineWidth = null;
    _contextLineCap = null;
    _contextLineJoin = null;
  }

  void setClearColor( Color color, num opacity ) {
    _clearColor.copy( color );
    _clearOpacity = opacity;

    _clearRect.setValues( - _canvasWidthHalf, - _canvasHeightHalf, _canvasWidthHalf, _canvasHeightHalf );
  }

  void setClearColorHex( num hex, num opacity ) {
    _clearColor.setHex( hex );
    _clearOpacity = opacity;

    _clearRect.setValues( - _canvasWidthHalf, - _canvasHeightHalf, _canvasWidthHalf, _canvasHeightHalf );
  }

  void clear() {
    _context.setTransform( 1, 0, 0, - 1, _canvasWidthHalf, _canvasHeightHalf );

    if ( !_clearRect.isEmpty ) {
      _clearRect.minSelf( _clipRect );
      _clearRect.inflate( 2 );

      if ( _clearOpacity < 1 ) {
        _context.clearRect( ( _clearRect.getX() ).floor(), ( _clearRect.getY() ).floor(), ( _clearRect.getWidth() ).floor(), ( _clearRect.getHeight() ).floor() );
      }

      if ( _clearOpacity > 0 ) {
        setBlending( NormalBlending );
        setOpacity( 1 );

        setFillStyle( 'rgba(${( _clearColor.r * 255 ).floor()}, ${( _clearColor.g * 255 ).floor()},${( _clearColor.b * 255 ).floor()},${_clearOpacity})' );

        _context.fillRect( ( _clearRect.getX() ).floor(), ( _clearRect.getY() ).floor(), ( _clearRect.getWidth() ).floor(), ( _clearRect.getHeight() ).floor() );
      }

      _clearRect.empty();
    }
  }

  void render( Scene scene, Camera camera ) {
    num e, el;
    var element;
    Material material;

    _camera = camera;

    if (_autoClear) {
      clear();
    } else {
      _context.setTransform( 1, 0, 0, - 1, _canvasWidthHalf, _canvasHeightHalf );
    }
    //TODO: these are ints not lists?
    //_info['render']['vertices'] = 0;
    //_info['render']['faces'] = 0;
    _info.render.reset();

    _renderData = _projector.projectScene( scene, camera, _sortElements );
    _elements = _renderData.elements;
    _lights = _renderData.lights;

    if ( debug ) {
      _context.fillStyle = 'rgba( 0, 255, 255, 0.5 )';
      _context.fillRect( _clipRect.getX(), _clipRect.getY(), _clipRect.getWidth(), _clipRect.getHeight() );
    }

    _enableLighting = _lights.length > 0;

    if ( _enableLighting ) {
       calculateLights( _lights );
    }

    el = _elements.length;
    for ( e = 0; e < el; e++ ) {
      element = _elements[ e ];

      material = element.material;
      material = material is MeshFaceMaterial ? element.faceMaterial : material;

      if ( material == null || material.opacity == 0 ) continue;

      _bboxRect.empty();

      RenderableVertex _v1, _v2, _v3, _v4;

      //TODO: Replaced non type-safe references to _v1 - _v4 here, hopefully that's ok.
      if (debug) {
        print("$element");
      }
      if ( element is RenderableParticle ) {
//        _v1 = element;
        RenderableParticle rp = element;
        rp.x *= _canvasWidthHalf; rp.y *= _canvasHeightHalf;

        renderParticle( rp, element, material, scene );
        
      } else if ( element is RenderableLine ) {
        _v1 = element.v1; _v2 = element.v2;

        _v1.positionScreen.x *= _canvasWidthHalf; _v1.positionScreen.y *= _canvasHeightHalf;
        _v2.positionScreen.x *= _canvasWidthHalf; _v2.positionScreen.y *= _canvasHeightHalf;

        _bboxRect.addPoint( _v1.positionScreen.x, _v1.positionScreen.y );
        _bboxRect.addPoint( _v2.positionScreen.x, _v2.positionScreen.y );

        if ( _clipRect.intersects( _bboxRect ) ) {
          renderLine( _v1, _v2, element, material, scene );
        }
        
      } else if ( element is RenderableFace3 ) {
        _v1 = element.v1; _v2 = element.v2; _v3 = element.v3;

        _v1.positionScreen.x *= _canvasWidthHalf; _v1.positionScreen.y *= _canvasHeightHalf;
        _v2.positionScreen.x *= _canvasWidthHalf; _v2.positionScreen.y *= _canvasHeightHalf;
        _v3.positionScreen.x *= _canvasWidthHalf; _v3.positionScreen.y *= _canvasHeightHalf;

        if ( material.overdraw ) {
          expand( _v1.positionScreen, _v2.positionScreen );
          expand( _v2.positionScreen, _v3.positionScreen );
          expand( _v3.positionScreen, _v1.positionScreen );
        }

        _bboxRect.add3Points( _v1.positionScreen.x, _v1.positionScreen.y,
                  _v2.positionScreen.x, _v2.positionScreen.y,
                  _v3.positionScreen.x, _v3.positionScreen.y );

        if ( _clipRect.intersects( _bboxRect ) ) {
          renderFace3( _v1, _v2, _v3, 0, 1, 2, element, material, scene );
        }
        
      } else if ( element is RenderableFace4 ) {
        _v1 = element.v1; _v2 = element.v2; _v3 = element.v3; _v4 = element.v4;

        _v1.positionScreen.x *= _canvasWidthHalf; _v1.positionScreen.y *= _canvasHeightHalf;
        _v2.positionScreen.x *= _canvasWidthHalf; _v2.positionScreen.y *= _canvasHeightHalf;
        _v3.positionScreen.x *= _canvasWidthHalf; _v3.positionScreen.y *= _canvasHeightHalf;
        _v4.positionScreen.x *= _canvasWidthHalf; _v4.positionScreen.y *= _canvasHeightHalf;

        _v5.positionScreen.setFrom( _v2.positionScreen );
        _v6.positionScreen.setFrom( _v4.positionScreen );

        if ( material.overdraw ) {
          expand( _v1.positionScreen, _v2.positionScreen );
          expand( _v2.positionScreen, _v4.positionScreen );
          expand( _v4.positionScreen, _v1.positionScreen );

          expand( _v3.positionScreen, _v5.positionScreen );
          expand( _v3.positionScreen, _v6.positionScreen );
        }

        _bboxRect.addPoint( _v1.positionScreen.x, _v1.positionScreen.y );
        _bboxRect.addPoint( _v2.positionScreen.x, _v2.positionScreen.y );
        _bboxRect.addPoint( _v3.positionScreen.x, _v3.positionScreen.y );
        _bboxRect.addPoint( _v4.positionScreen.x, _v4.positionScreen.y );

        if ( _clipRect.intersects( _bboxRect ) ) {
          renderFace4( _v1, _v2, _v3, _v4, _v5, _v6, element, material, scene );
        }
      }

      if ( debug ) {
        _context.lineWidth = 1;
        _context.strokeStyle = 'rgba( 0, 255, 0, 0.5 )';
        _context.strokeRect( _bboxRect.getX(), _bboxRect.getY(), _bboxRect.getWidth(), _bboxRect.getHeight() );
      }

      _clearRect.addRectangle( _bboxRect );
    }

    if ( debug ) {
      _context.lineWidth = 1;
      _context.strokeStyle = 'rgba( 255, 0, 0, 0.5 )';
      _context.strokeRect( _clearRect.getX(), _clearRect.getY(), _clearRect.getWidth(), _clearRect.getHeight() );
    }

    _context.setTransform( 1, 0, 0, 1, 0, 0 );

    //
  }

  void calculateLights( List lights ) {
    num l, ll;
    Light light;
    Color lightColor;

    _ambientLight.setRGB( 0, 0, 0 );
    _directionalLights.setRGB( 0, 0, 0 );
    _pointLights.setRGB( 0, 0, 0 );

    ll = lights.length;
    for ( l = 0; l < ll; l ++ ) {
      light = lights[ l ];
      lightColor = light.color;

      if ( light is AmbientLight ) {
        _ambientLight.r += lightColor.r;
        _ambientLight.g += lightColor.g;
        _ambientLight.b += lightColor.b;
      } else if ( light is DirectionalLight ) {
        // for particles

        _directionalLights.r += lightColor.r;
        _directionalLights.g += lightColor.g;
        _directionalLights.b += lightColor.b;
      } else if ( light is PointLight ) {
        // for particles

        _pointLights.r += lightColor.r;
        _pointLights.g += lightColor.g;
        _pointLights.b += lightColor.b;
      }
    }
  }

  void calculateLight( List lights, Vector3 position, Vector3 normal, Color color ) {
    int l, ll;
    Light light;
    Color lightColor;
    Vector3 lightPosition;
    num amount;

    ll = lights.length;
    for ( l = 0; l < ll; l ++ ) {

      light = lights[ l ];
      lightColor = light.color;

      if ( light is DirectionalLight ) {
        DirectionalLight dLight = light;
        lightPosition = light.matrixWorld.getTranslation();

        amount = normal.dot( lightPosition );

        if ( amount <= 0 ) continue;

        amount *= dLight.intensity;

        color.r += lightColor.r * amount;
        color.g += lightColor.g * amount;
        color.b += lightColor.b * amount;

      } else if ( light is PointLight ) {
        PointLight pLight = light;

        lightPosition = light.matrixWorld.getTranslation();

        _vector3 = (lightPosition -position).normalize();
        amount = normal.dot(_vector3);

        if ( amount <= 0 ) continue;

        amount *= pLight.distance == 0 ? 1 : 1 - Math.min( position.absoluteError( lightPosition ) / pLight.distance, 1 );

        if ( amount == 0 ) continue;

        amount *= pLight.intensity;

        color.r += lightColor.r * amount;
        color.g += lightColor.g * amount;
        color.b += lightColor.b * amount;

      }

    }

  }

  void renderParticle ( RenderableParticle v1, RenderableParticle element, IMaterial material, Scene scene ) {
    setOpacity( material.opacity );
    setBlending( material.blending );

    num width, height, scaleX, scaleY, bitmapWidth, bitmapHeight;
    var bitmap;

    if ( material is ParticleBasicMaterial ) {
      ParticleBasicMaterial pbMaterial = material;
      if ( pbMaterial.map ) {
        bitmap = pbMaterial.map.image;
        bitmapWidth = bitmap.width >> 1;
        bitmapHeight = bitmap.height >> 1;

        scaleX = element.scale.x * _canvasWidthHalf;
        scaleY = element.scale.y * _canvasHeightHalf;

        width = scaleX * bitmapWidth;
        height = scaleY * bitmapHeight;

        // TODO: Rotations break this...
        _bboxRect.setValues( v1.x - width, v1.y - height, v1.x  + width, v1.y + height );

        if ( !_clipRect.intersects( _bboxRect ) ) {
          return;
        }

        _context.save();
        _context.translate( v1.x, v1.y );
        _context.rotate( - element.rotation );
        _context.scale( scaleX, - scaleY );

        _context.translate( - bitmapWidth, - bitmapHeight );
        _context.drawImage( bitmap, 0, 0 );

        _context.restore();
      }

      if ( debug ) {
        _context.beginPath();
        _context.moveTo( v1.x - 10, v1.y );
        _context.lineTo( v1.x + 10, v1.y );
        _context.moveTo( v1.x, v1.y - 10 );
        _context.lineTo( v1.x, v1.y + 10 );
        _context.closePath();
        _context.strokeStyle = 'rgb(255,255,0)';
        _context.stroke();
        if (debug) {
          print("renderParticle $v1 at (${v1.x}, ${v1.y})");
        }
      }

    } else if ( material is ParticleCanvasMaterial ) {
      ParticleCanvasMaterial pcMaterial = material;

      width = element.scale.x * _canvasWidthHalf;
      height = element.scale.y * _canvasHeightHalf;

      _bboxRect.setValues( v1.x - width, v1.y - height, v1.x + width, v1.y + height );

      if ( !_clipRect.intersects( _bboxRect ) ) {
        return;
      }

      setStrokeStyle( pcMaterial.color.getContextStyle() );
      setFillStyle( pcMaterial.color.getContextStyle() );

      _context.save();
      _context.translate( v1.x, v1.y );
      _context.rotate( - element.rotation );
      _context.scale( width, height );

      pcMaterial.program( _context );

      _context.restore();
    }
  }

  void renderLine( RenderableVertex v1, RenderableVertex v2, RenderableLine element, Material material, Scene scene ) {
    setOpacity( material.opacity );
    setBlending( material.blending );

    _context.beginPath();
    _context.moveTo( v1.positionScreen.x, v1.positionScreen.y );
    _context.lineTo( v2.positionScreen.x, v2.positionScreen.y );
    _context.closePath();

    if ( material is LineBasicMaterial ) {
      LineBasicMaterial lbMaterial = material;

      setLineWidth( lbMaterial.linewidth );
      setLineCap( lbMaterial.linecap );
      setLineJoin( lbMaterial.linejoin );
      setStrokeStyle( lbMaterial.color.getContextStyle() );

      _context.stroke();
      _bboxRect.inflate( lbMaterial.linewidth * 2 );
    }
    if (debug) {
      print("renderLine $element at (${v1.positionScreen.x}, ${v1.positionScreen.y}) to (${v2.positionScreen.x}, ${v2.positionScreen.y})");
    }

  }

  void renderFace3( RenderableVertex v1, RenderableVertex v2, RenderableVertex v3, num uv1, num uv2, num uv3, element, Material material, Scene scene ) {
    //_info['render']['vertices'] += 3;
    //_info['render']['faces'] ++;
    _info.render.vertices += 3;
    _info.render.faces ++;

    setOpacity( material.opacity );
    setBlending( material.blending );

    _v1x = v1.positionScreen.x; _v1y = v1.positionScreen.y;
    _v2x = v2.positionScreen.x; _v2y = v2.positionScreen.y;
    _v3x = v3.positionScreen.x; _v3y = v3.positionScreen.y;

    drawTriangle( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y );

    if ( material is MeshBasicMaterial ) {
      MeshBasicMaterial mbMaterial = material;
      if ( mbMaterial.map != null /* && !material.wireframe*/ ) {
        //TODO: UVMapping is not implemented
        if ( mbMaterial.map.mapping is UVMapping ) {
          _uvs = element.uvs[ 0 ];
          patternPath( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _uvs[ uv1 ].u, _uvs[ uv1 ].v, _uvs[ uv2 ].u, _uvs[ uv2 ].v, _uvs[ uv3 ].u, _uvs[ uv3 ].v, mbMaterial.map );

        }
      } else if ( null != mbMaterial.envMap ) {
        if ( mbMaterial.envMap.mapping is SphericalReflectionMapping ) {
          Matrix4 cameraMatrix = _camera.matrixWorldInverse;

          _vector3.setFrom( element.vertexNormalsWorld[ uv1 ] );
          _uv1x = ( _vector3.x * cameraMatrix[0] + _vector3.y * cameraMatrix[4] + _vector3.z * cameraMatrix[8] ) * 0.5 + 0.5;
          _uv1y = - ( _vector3.x * cameraMatrix[1] + _vector3.y * cameraMatrix[5] + _vector3.z * cameraMatrix[9] ) * 0.5 + 0.5;

          _vector3.setFrom( element.vertexNormalsWorld[ uv2 ] );
          _uv2x = ( _vector3.x * cameraMatrix[0] + _vector3.y * cameraMatrix[4] + _vector3.z * cameraMatrix[8] ) * 0.5 + 0.5;
          _uv2y = - ( _vector3.x * cameraMatrix[1] + _vector3.y * cameraMatrix[5] + _vector3.z * cameraMatrix[9] ) * 0.5 + 0.5;

          _vector3.setFrom( element.vertexNormalsWorld[ uv3 ] );
          _uv3x = ( _vector3.x * cameraMatrix[0] + _vector3.y * cameraMatrix[4] + _vector3.z * cameraMatrix[8] ) * 0.5 + 0.5;
          _uv3y = - ( _vector3.x * cameraMatrix[1] + _vector3.y * cameraMatrix[5] + _vector3.z * cameraMatrix[9] ) * 0.5 + 0.5;

          patternPath( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _uv1x, _uv1y, _uv2x, _uv2y, _uv3x, _uv3y, mbMaterial.envMap );

        }/* else if ( material.envMap.mapping == THREE.SphericalRefractionMapping ) {

        }*/
      } else {
        if (mbMaterial.wireframe) {
          strokePath( mbMaterial.color, mbMaterial.wireframeLinewidth, mbMaterial.wireframeLinecap, mbMaterial.wireframeLinejoin );
        } else {
          fillPath( mbMaterial.color );
        }
      }

    } else if ( material is MeshLambertMaterial ) {
      MeshLambertMaterial mlMaterial = material;
      if ( mlMaterial.map != null && !mlMaterial.wireframe ) {
        //TODO: UVMapping not implemented
        if ( mlMaterial.map.mapping is UVMapping ) {
          _uvs = element.uvs[ 0 ];
          patternPath( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _uvs[ uv1 ].u, _uvs[ uv1 ].v, _uvs[ uv2 ].u, _uvs[ uv2 ].v, _uvs[ uv3 ].u, _uvs[ uv3 ].v, mlMaterial.map );
        }

        setBlending( SubtractiveBlending );
      }

      if ( _enableLighting ) {
        if ( !mlMaterial.wireframe && mlMaterial.shading == SmoothShading && element.vertexNormalsWorld.length == 3 ) {
          _color1.r = _color2.r = _color3.r = _ambientLight.r;
          _color1.g = _color2.g = _color3.g = _ambientLight.g;
          _color1.b = _color2.b = _color3.b = _ambientLight.b;

          calculateLight( _lights, element.v1.positionWorld, element.vertexNormalsWorld[ 0 ], _color1 );
          calculateLight( _lights, element.v2.positionWorld, element.vertexNormalsWorld[ 1 ], _color2 );
          calculateLight( _lights, element.v3.positionWorld, element.vertexNormalsWorld[ 2 ], _color3 );

          _color1.r = Math.max( 0, Math.min( mlMaterial.color.r * _color1.r, 1 ) );
          _color1.g = Math.max( 0, Math.min( mlMaterial.color.g * _color1.g, 1 ) );
          _color1.b = Math.max( 0, Math.min( mlMaterial.color.b * _color1.b, 1 ) );

          _color2.r = Math.max( 0, Math.min( mlMaterial.color.r * _color2.r, 1 ) );
          _color2.g = Math.max( 0, Math.min( mlMaterial.color.g * _color2.g, 1 ) );
          _color2.b = Math.max( 0, Math.min( mlMaterial.color.b * _color2.b, 1 ) );

          _color3.r = Math.max( 0, Math.min( mlMaterial.color.r * _color3.r, 1 ) );
          _color3.g = Math.max( 0, Math.min( mlMaterial.color.g * _color3.g, 1 ) );
          _color3.b = Math.max( 0, Math.min( mlMaterial.color.b * _color3.b, 1 ) );

          _color4.r = ( _color2.r + _color3.r ) * 0.5;
          _color4.g = ( _color2.g + _color3.g ) * 0.5;
          _color4.b = ( _color2.b + _color3.b ) * 0.5;

          _image = getGradientTexture( _color1, _color2, _color3, _color4 );

          clipImage( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, 0, 0, 1, 0, 0, 1, _image );
        } else {
          _color.r = _ambientLight.r;
          _color.g = _ambientLight.g;
          _color.b = _ambientLight.b;

          calculateLight( _lights, element.centroidWorld, element.normalWorld, _color );

          _color.r = Math.max( 0, Math.min( mlMaterial.color.r * _color.r, 1 ) );
          _color.g = Math.max( 0, Math.min( mlMaterial.color.g * _color.g, 1 ) );
          _color.b = Math.max( 0, Math.min( mlMaterial.color.b * _color.b, 1 ) );

          if (mlMaterial.wireframe) {
            strokePath( _color, mlMaterial.wireframeLinewidth, mlMaterial.wireframeLinecap, mlMaterial.wireframeLinejoin );
          } else {
            fillPath( _color );
          }
        }
      } else  {
        if (mlMaterial.wireframe) {
          strokePath( mlMaterial.color, mlMaterial.wireframeLinewidth, mlMaterial.wireframeLinecap, mlMaterial.wireframeLinejoin );
        } else {
          fillPath( mlMaterial.color );
        }
      }
    } else if ( material is MeshDepthMaterial ) {
      _near = _camera.near;
      _far = _camera.far;

      _color1.r = _color1.g = _color1.b = 1 - smoothstep( v1.positionScreen.z, _near, _far );
      _color2.r = _color2.g = _color2.b = 1 - smoothstep( v2.positionScreen.z, _near, _far );
      _color3.r = _color3.g = _color3.b = 1 - smoothstep( v3.positionScreen.z, _near, _far );

      _color4.r = ( _color2.r + _color3.r ) * 0.5;
      _color4.g = ( _color2.g + _color3.g ) * 0.5;
      _color4.b = ( _color2.b + _color3.b ) * 0.5;

      _image = getGradientTexture( _color1, _color2, _color3, _color4 );

      clipImage( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, 0, 0, 1, 0, 0, 1, _image );

    } else if ( material is MeshNormalMaterial ) {
      MeshNormalMaterial mnMaterial = material;

      _color.r = normalToComponent( element.normalWorld.x );
      _color.g = normalToComponent( element.normalWorld.y );
      _color.b = normalToComponent( element.normalWorld.z );

      //TODO
      if (mnMaterial.wireframe) {
        strokePath( _color, mnMaterial.wireframeLinewidth, mnMaterial.wireframeLinecap, mnMaterial.wireframeLinejoin );
      } else {
        fillPath( _color );
      }
    }
  }

  void renderFace4( RenderableVertex v1, RenderableVertex v2, RenderableVertex v3, RenderableVertex v4, RenderableVertex v5, RenderableVertex v6, element, Material material, Scene scene ) {

    //_info['render']['vertices'] += 4;
    //_info['render']['faces'] ++;
    _info.render.vertices += 4;
    _info.render.faces ++;

    setOpacity( material.opacity );
    setBlending( material.blending );

    //TODO: make sure all relevant materials implement ITextureMapMaterial
//    if ( material.map != null || material.envMap != null )
    if (material is ITextureMapMaterial) {
      // Let renderFace3() handle this

      renderFace3( v1, v2, v4, 0, 1, 3, element, material, scene );
      renderFace3( v5, v3, v6, 1, 2, 3, element, material, scene );

      return;
    }

    _v1x = v1.positionScreen.x; _v1y = v1.positionScreen.y;
    _v2x = v2.positionScreen.x; _v2y = v2.positionScreen.y;
    _v3x = v3.positionScreen.x; _v3y = v3.positionScreen.y;
    _v4x = v4.positionScreen.x; _v4y = v4.positionScreen.y;
    _v5x = v5.positionScreen.x; _v5y = v5.positionScreen.y;
    _v6x = v6.positionScreen.x; _v6y = v6.positionScreen.y;

    if ( material is MeshBasicMaterial ) {
      MeshBasicMaterial mbMaterial = material;

      drawQuad( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _v4x, _v4y );

      if (mbMaterial.wireframe) {
        strokePath( mbMaterial.color, mbMaterial.wireframeLinewidth, mbMaterial.wireframeLinecap, mbMaterial.wireframeLinejoin );
      } else {
        fillPath( mbMaterial.color );
      }
    } else if ( material is MeshLambertMaterial ) {
      MeshLambertMaterial mlMaterial = material;

      if ( _enableLighting ) {
        if ( !mlMaterial.wireframe && mlMaterial.shading == SmoothShading && element.vertexNormalsWorld.length == 4 ) {
          _color1.r = _color2.r = _color3.r = _color4.r = _ambientLight.r;
          _color1.g = _color2.g = _color3.g = _color4.g = _ambientLight.g;
          _color1.b = _color2.b = _color3.b = _color4.b = _ambientLight.b;

          calculateLight( _lights, element.v1.positionWorld, element.vertexNormalsWorld[ 0 ], _color1 );
          calculateLight( _lights, element.v2.positionWorld, element.vertexNormalsWorld[ 1 ], _color2 );
          calculateLight( _lights, element.v4.positionWorld, element.vertexNormalsWorld[ 3 ], _color3 );
          calculateLight( _lights, element.v3.positionWorld, element.vertexNormalsWorld[ 2 ], _color4 );

          _color1.r = Math.max( 0, Math.min( mlMaterial.color.r * _color1.r, 1 ) );
          _color1.g = Math.max( 0, Math.min( mlMaterial.color.g * _color1.g, 1 ) );
          _color1.b = Math.max( 0, Math.min( mlMaterial.color.b * _color1.b, 1 ) );

          _color2.r = Math.max( 0, Math.min( mlMaterial.color.r * _color2.r, 1 ) );
          _color2.g = Math.max( 0, Math.min( mlMaterial.color.g * _color2.g, 1 ) );
          _color2.b = Math.max( 0, Math.min( mlMaterial.color.b * _color2.b, 1 ) );

          _color3.r = Math.max( 0, Math.min( mlMaterial.color.r * _color3.r, 1 ) );
          _color3.g = Math.max( 0, Math.min( mlMaterial.color.g * _color3.g, 1 ) );
          _color3.b = Math.max( 0, Math.min( mlMaterial.color.b * _color3.b, 1 ) );

          _color4.r = Math.max( 0, Math.min( mlMaterial.color.r * _color4.r, 1 ) );
          _color4.g = Math.max( 0, Math.min( mlMaterial.color.g * _color4.g, 1 ) );
          _color4.b = Math.max( 0, Math.min( mlMaterial.color.b * _color4.b, 1 ) );

          _image = getGradientTexture( _color1, _color2, _color3, _color4 );

          // TODO: UVs are incorrect, v4->v3?

          drawTriangle( _v1x, _v1y, _v2x, _v2y, _v4x, _v4y );
          clipImage( _v1x, _v1y, _v2x, _v2y, _v4x, _v4y, 0, 0, 1, 0, 0, 1, _image );

          drawTriangle( _v5x, _v5y, _v3x, _v3y, _v6x, _v6y );
          clipImage( _v5x, _v5y, _v3x, _v3y, _v6x, _v6y, 1, 0, 1, 1, 0, 1, _image );

        } else {
          _color.r = _ambientLight.r;
          _color.g = _ambientLight.g;
          _color.b = _ambientLight.b;

          calculateLight( _lights, element.centroidWorld, element.normalWorld, _color );

          _color.r = Math.max( 0, Math.min( mlMaterial.color.r * _color.r, 1 ) );
          _color.g = Math.max( 0, Math.min( mlMaterial.color.g * _color.g, 1 ) );
          _color.b = Math.max( 0, Math.min( mlMaterial.color.b * _color.b, 1 ) );

          drawQuad( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _v4x, _v4y );

          if (mlMaterial.wireframe) {
            strokePath( _color, mlMaterial.wireframeLinewidth, mlMaterial.wireframeLinecap, mlMaterial.wireframeLinejoin );
          } else {
            fillPath( _color );
          }
        }
      } else {
        drawQuad( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _v4x, _v4y );

        if (mlMaterial.wireframe) {
          strokePath( mlMaterial.color, mlMaterial.wireframeLinewidth, mlMaterial.wireframeLinecap, mlMaterial.wireframeLinejoin );
        } else {
          fillPath( mlMaterial.color );
        }
      }
    } else if ( material is MeshNormalMaterial ) {
      MeshNormalMaterial mnMaterial = material;

      _color.r = normalToComponent( element.normalWorld.x );
      _color.g = normalToComponent( element.normalWorld.y );
      _color.b = normalToComponent( element.normalWorld.z );

      drawQuad( _v1x, _v1y, _v2x, _v2y, _v3x, _v3y, _v4x, _v4y );

      if (mnMaterial.wireframe) {
        strokePath( _color, mnMaterial.wireframeLinewidth, mnMaterial.wireframeLinecap, mnMaterial.wireframeLinejoin );
      } else {
        fillPath( _color );
      }
    } else if ( material is MeshDepthMaterial ) {
      MeshDepthMaterial mdMaterial = material;

      _near = _camera.near;
      _far = _camera.far;

      _color1.r = _color1.g = _color1.b = 1 - smoothstep( v1.positionScreen.z, _near, _far );
      _color2.r = _color2.g = _color2.b = 1 - smoothstep( v2.positionScreen.z, _near, _far );
      _color3.r = _color3.g = _color3.b = 1 - smoothstep( v4.positionScreen.z, _near, _far );
      _color4.r = _color4.g = _color4.b = 1 - smoothstep( v3.positionScreen.z, _near, _far );

      _image = getGradientTexture( _color1, _color2, _color3, _color4 );

      // TODO: UVs are incorrect, v4->v3?

      drawTriangle( _v1x, _v1y, _v2x, _v2y, _v4x, _v4y );
      clipImage( _v1x, _v1y, _v2x, _v2y, _v4x, _v4y, 0, 0, 1, 0, 0, 1, _image );

      drawTriangle( _v5x, _v5y, _v3x, _v3y, _v6x, _v6y );
      clipImage( _v5x, _v5y, _v3x, _v3y, _v6x, _v6y, 1, 0, 1, 1, 0, 1, _image );
    }
  }

  //

  void drawTriangle( num x0, num y0, num x1, num y1, num x2, num y2 ) {
    _context.beginPath();
    _context.moveTo( x0, y0 );
    _context.lineTo( x1, y1 );
    _context.lineTo( x2, y2 );
    _context.lineTo( x0, y0 );
    _context.closePath();
  }

  void drawQuad( num x0, num y0, num x1, num y1, num x2, num y2, num x3, num y3 ) {
    _context.beginPath();
    _context.moveTo( x0, y0 );
    _context.lineTo( x1, y1 );
    _context.lineTo( x2, y2 );
    _context.lineTo( x3, y3 );
    _context.lineTo( x0, y0 );
    _context.closePath();
  }

  void strokePath( Color color, num linewidth, String linecap, String linejoin ) {
    setLineWidth( linewidth );
    setLineCap( linecap );
    setLineJoin( linejoin );
    setStrokeStyle( color.getContextStyle() );

    _context.stroke();

    _bboxRect.inflate( linewidth * 2 );
  }

  void fillPath( Color color ) {
    setFillStyle( color.getContextStyle() );
    _context.fill();
  }

  //TODO: MeshBasicMaterial/MeshLambertMaterial map/envMap WHAT IS ENV MAP?!
  void patternPath( num x0, num y0, num x1, num y1, num x2, num y2, num u0, num v0, num u1, num v1, num u2, num v2, texture ) {
    if ( texture.image.width == 0 ) return;

    if ( texture.needsUpdate == true || _patterns.length <= texture.id || _patterns[ texture.id ] == null ) {

      var repeatX = texture.wrapS == RepeatWrapping;
      var repeatY = texture.wrapT == RepeatWrapping;

      // Let's grow the array as needed
      if (_patterns.length <= texture.id) {
        _patterns.length = texture.id + 1;
      }
      
      _patterns[ texture.id ] = _context.createPattern( texture.image, repeatX && repeatY ? 'repeat' : repeatX && !repeatY ? 'repeat-x' : !repeatX && repeatY ? 'repeat-y' : 'no-repeat' );

      texture.needsUpdate = false;

    }

    setFillStyle( _patterns[ texture.id ] );

    // http://extremelysatisfactorytotalitarianism.com/blog/?p=2120

    num a, b, c, d, e, f, det, idet,
    offsetX = texture.offset.x / texture.repeat.x,
    offsetY = texture.offset.y / texture.repeat.y,
    width = texture.image.width * texture.repeat.x,
    height = texture.image.height * texture.repeat.y;

    u0 = ( u0 + offsetX ) * width;
    v0 = ( v0 + offsetY ) * height;

    u1 = ( u1 + offsetX ) * width;
    v1 = ( v1 + offsetY ) * height;

    u2 = ( u2 + offsetX ) * width;
    v2 = ( v2 + offsetY ) * height;

    x1 -= x0; y1 -= y0;
    x2 -= x0; y2 -= y0;

    u1 -= u0; v1 -= v0;
    u2 -= u0; v2 -= v0;

    det = u1 * v2 - u2 * v1;

    if ( det == 0 ) {
      if ( _imagedatas[ texture.id ] == null ) {
        CanvasElement canvas = new Element.tag('canvas');
        canvas.width = texture.image.width;
        canvas.height = texture.image.height;

        CanvasRenderingContext2D context = canvas.getContext( '2d' );
        context.drawImage( texture.image, 0, 0 );

        _imagedatas[ texture.id ] = context.getImageData( 0, 0, texture.image.width, texture.image.height ).data;

        // variables cannot be deleted in ES5 strict mode
        //delete canvas;

      }

      List data = _imagedatas[ texture.id ];
      int index = ( u0.floor() + v0.floor() * texture.image.width ) * 4;

      _color.setRGB( data[ index ] / 255, data[ index + 1 ] / 255, data[ index + 2 ] / 255 );
      fillPath( _color );

      return;

    }

    idet = 1 / det;

    a = ( v2 * x1 - v1 * x2 ) * idet;
    b = ( v2 * y1 - v1 * y2 ) * idet;
    c = ( u1 * x2 - u2 * x1 ) * idet;
    d = ( u1 * y2 - u2 * y1 ) * idet;

    e = x0 - a * u0 - c * v0;
    f = y0 - b * u0 - d * v0;

    _context.save();
    _context.transform( a, b, c, d, e, f );
    _context.fill();
    _context.restore();
  }

  void clipImage( num x0, num y0, num x1, num y1, num x2, num y2, num u0, num v0, num u1, num v1, num u2, num v2, image ) {
    // http://extremelysatisfactorytotalitarianism.com/blog/?p=2120

    num a, b, c, d, e, f, det, idet,
    width = image.width - 1,
    height = image.height - 1;

    u0 *= width; v0 *= height;
    u1 *= width; v1 *= height;
    u2 *= width; v2 *= height;

    x1 -= x0; y1 -= y0;
    x2 -= x0; y2 -= y0;

    u1 -= u0; v1 -= v0;
    u2 -= u0; v2 -= v0;

    det = u1 * v2 - u2 * v1;

    idet = 1 / det;

    a = ( v2 * x1 - v1 * x2 ) * idet;
    b = ( v2 * y1 - v1 * y2 ) * idet;
    c = ( u1 * x2 - u2 * x1 ) * idet;
    d = ( u1 * y2 - u2 * y1 ) * idet;

    e = x0 - a * u0 - c * v0;
    f = y0 - b * u0 - d * v0;

    _context.save();
    _context.transform( a, b, c, d, e, f );
    _context.clip();
    _context.drawImage( image, 0, 0 );
    _context.restore();
  }

  CanvasElement getGradientTexture( Color color1, Color color2, Color color3, Color color4 ) {
    // http://mrdoob.com/blog/post/710

    num c1r = color1._rr, c1g = color1._gg, c1b = color1._bb,
    c2r = color2._rr, c2g = color2._gg, c2b = color2._bb,
    c3r = color3._rr, c3g = color3._gg, c3b = color3._bb,
    c4r = color4._rr, c4g = color4._gg, c4b = color4._bb;

    _pixelMapData[ 0 ] = c1r < 0 ? 0 : c1r > 255 ? 255 : c1r;
    _pixelMapData[ 1 ] = c1g < 0 ? 0 : c1g > 255 ? 255 : c1g;
    _pixelMapData[ 2 ] = c1b < 0 ? 0 : c1b > 255 ? 255 : c1b;

    _pixelMapData[ 4 ] = c2r < 0 ? 0 : c2r > 255 ? 255 : c2r;
    _pixelMapData[ 5 ] = c2g < 0 ? 0 : c2g > 255 ? 255 : c2g;
    _pixelMapData[ 6 ] = c2b < 0 ? 0 : c2b > 255 ? 255 : c2b;

    _pixelMapData[ 8 ] = c3r < 0 ? 0 : c3r > 255 ? 255 : c3r;
    _pixelMapData[ 9 ] = c3g < 0 ? 0 : c3g > 255 ? 255 : c3g;
    _pixelMapData[ 10 ] = c3b < 0 ? 0 : c3b > 255 ? 255 : c3b;

    _pixelMapData[ 12 ] = c4r < 0 ? 0 : c4r > 255 ? 255 : c4r;
    _pixelMapData[ 13 ] = c4g < 0 ? 0 : c4g > 255 ? 255 : c4g;
    _pixelMapData[ 14 ] = c4b < 0 ? 0 : c4b > 255 ? 255 : c4b;

    _pixelMapContext.putImageData( _pixelMapImage, 0, 0 );
    _gradientMapContext.drawImage( _pixelMap, 0, 0 );

    return _gradientMap;
  }

  num smoothstep( num value, num min, num max ) {
    var x = ( value - min ) / ( max - min );
    return x * x * ( 3 - 2 * x );
  }

  num normalToComponent( num normal ) {
    num component = ( normal + 1 ) * 0.5;
    return component < 0 ? 0 : ( component > 1 ? 1 : component );
  }

  // Hide anti-alias gaps

  void expand( Vector4 v1, Vector4 v2 ) {
    num x = v2.x - v1.x, y =  v2.y - v1.y,
    det = x * x + y * y, idet;

    if ( det == 0 ) return;

    idet = 1 / Math.sqrt( det );

    x *= idet; y *= idet;

    v2.x += x; v2.y += y;
    v1.x -= x; v1.y -= y;
  }

  // Context cached methods.

  void setOpacity( num value ) {
    if ( _contextGlobalAlpha != value ) {
      _context.globalAlpha = _contextGlobalAlpha = value;
    }
  }

  void setBlending( int value ) {
    if ( _contextGlobalCompositeOperation != value ) {
      switch ( value ) {
        case NormalBlending:

          _context.globalCompositeOperation = 'source-over';

          break;

        case AdditiveBlending:

          _context.globalCompositeOperation = 'lighter';

          break;

        case SubtractiveBlending:

          _context.globalCompositeOperation = 'darker';

          break;
      }

      _contextGlobalCompositeOperation = value;
    }
  }

  void setLineWidth( num value ) {
    if ( _contextLineWidth != value ) {
      _context.lineWidth = _contextLineWidth = value;
    }
  }

  void setLineCap( String value ) {
    // "butt", "round", "square"
    if ( _contextLineCap != value ) {
      _context.lineCap = _contextLineCap = value;
    }
  }

  void setLineJoin( String value ) {
    // "round", "bevel", "miter"
    if ( _contextLineJoin != value ) {
      _context.lineJoin = _contextLineJoin = value;
    }
  }

  void setStrokeStyle( dynamic style ) {
    if ( _contextStrokeStyle != style ) {
      _context.strokeStyle = _contextStrokeStyle = style;
    }
  }

  void setFillStyle( dynamic style ) {
    if ( _contextFillStyle != style ) {
      _contextFillStyle = style;
      _context.fillStyle = _contextFillStyle;
    }
  }
}

// Data obj class to replace Map _info
class CanvasRenderData {
  RenderInts render;

  CanvasRenderData() {
    render = new RenderInts();
  }
}

class RenderInts {
  int vertices;
  int faces;

  RenderInts() {
    reset();
  }

  void reset() {
    vertices = 0;
    faces = 0;
  }
}
/*
_info = {
         "render": {
           "vertices": 0,
           "faces": 0
         }
*/



