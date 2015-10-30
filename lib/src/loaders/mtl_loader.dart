part of three;

/**
 * Loads a Wavefront .mtl file specifying materials
 *
 * @author angelxuanchang
 * Ported to Dart from JS by:
 * @author seguins
 */
class MTLLoader {

  String _baseUrl = '';
  HashMap _options = {};
  String _crossOrigin = '';

  /// Creates a new MTLLoader
  ///
  /// Options are the same of [MaterialCreator]
  MTLLoader([String this._baseUrl, HashMap this._options, String this._crossOrigin]);

  /// Loads MTL from an url;
  Future<MaterialCreator> load(String url) {
    if (!url.startsWith('/')) {
      url = this._baseUrl + url;
    }
    return HttpRequest.request(url, responseType: "String").then((req) => parse(req.response));
  }

  /// Parses [text] loaded MTL file
  MaterialCreator parse(String text) {
    List<String> lines = text.split("\n");
    HashMap info = {};
    var delimiter_pattern = new RegExp(r"\s+");
    var materialsInfo = {};

    lines.forEach((String line) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) {
        // Blank line or comment ignore
        return;
      }
      var pos = line.indexOf(' ');
      String key = (pos >= 0) ? line.substring(0, pos) : line;
      key = key.toLowerCase();

      String value = (pos >= 0) ? line.substring(pos + 1).trim() : "";

      if (key == "newmtl") {
        // New material
        info = new HashMap();
        info["name"] = value;
        materialsInfo[value] = info;
      } else if (info.isNotEmpty) {
        if (key == "ka" || key == "kd" || key == "ks") {
          List<String> ss = value.split(delimiter_pattern);
          info[key] = [double.parse(ss[0]), double.parse(ss[1]), double.parse(ss[2])];
        } else {
          info[key] = value;
        }
      }
    });

    var materialCreator = new MaterialCreator(_baseUrl, _options, _crossOrigin);
    materialCreator.materials = materialsInfo;
    return materialCreator;
  }

}

class MaterialCreator {

  String _baseUrl = "";
  HashMap _options;
  String _crossOrigin = "";
  HashMap _materialsInfo;
  HashMap _materials;
  List _materialsArray;
  HashMap _nameLookup;

  int _side = FrontSide;
  int _wrap = RepeatWrapping;

  /// Creates a new MaterialCreator
  ///
  /// [options] is a set of options on how to construct the materials :
  ///       side: Which side to apply the material
  ///         [FrontSide] (default), [BackSide],  [DoubleSide]
  ///       wrap: What type of wrapping to apply for textures
  ///         [RepeatWrapping] (default), [ClampToEdgeWrapping], [MirroredRepeatWrapping]
  ///       normalizeRGB: RGBs need to be normalized to 0-1 from 0-255
  ///         Default: false, assumed to be already normalized
  ///       ignoreZeroRGBs: Ignore values of RGBs (Ka,Kd,Ks) that are all 0's
  ///         Default: false
  ///       invertTransparency: If transparency need to be inverted (inversion is needed if d = 0 is fully opaque)
  ///         Default: false (d = 1 is fully opaque)
  MaterialCreator(String this._baseUrl, [HashMap this._options, String this._crossOrigin]) {

    if (_options != null) {
      if (_options.containsKey("side")) {
        _side = _options["side"];
      }
      if (_options.containsKey("wrap")) {
        _wrap = _options["wrap"];
      }
    }
  }

  /// Inits [MaterialCreator]
  void set materials(HashMap materialsInfo) {
    this._materialsInfo = _convert(materialsInfo);
    this._materials = {};
    this._materialsArray = [];
    this._nameLookup = {};
  }

  HashMap _convert(HashMap materialsInfo) {
    if (this._options == null) {
      return materialsInfo;
    }
    HashMap converted = {};

    for (var mn in materialsInfo.keys) {
      // Convert materials info into normalized form based on options
      HashMap mat = materialsInfo[mn];
      HashMap covmat = {};

      converted[mn] = covmat;
      for (String prop in mat.keys) {
        var save = true;
        var value = mat[prop];
        var lprop = prop.toLowerCase();

        if (_options != null) {
          switch (lprop) {
            case 'kd':
            case 'ka':
            case 'ks':
              // Diffuse color (color under white light) using RGB values
              if (_options.containsKey("normalizeRGB") && _options["normalizeRGB"]) {
                value = [value[0] / 255, value[1] / 255, value[2] / 255];
              }

              if (_options.containsKey("ignoreZeroRGBs") && _options["ignoreZeroRGBs"]) {
                if (value[0] == 0 && value[1] == 0 && value[1] == 0) {
                  // ignore
                  save = false;
                }
              }
              break;
            case 'd':
              // According to MTL format (http://paulbourke.net/dataformats/mtl/):
              //   d is dissolve for current material
              //   factor of 1.0 is fully opaque, a factor of 0 is fully dissolved (completely transparent)
              if (_options.containsKey("invertTransparency") && _options["invertTransparency"]) {
                value = 1 - value;
              }
              break;
            default:
              break;
          }
        }
        if (save) {
          covmat[lprop] = value;
        }
      }
    }
    return converted;
  }

  /// Creates in cache all creation for this material.
  Future preload() {
    var futures = new List();
    for (var mn in this._materialsInfo.keys) {
      futures.add(create(mn));
    }
    return Future.wait(futures);
  }

  Material _getIndex(String materialName) {
    return this._nameLookup[materialName];
  }

  List _getAsArray() {
    var index = 0;
    for (var mn in this._materialsInfo) {
      this._materialsArray[index] = create(mn);
      this._nameLookup[mn] = index;
      index++;
    }
    return this._materialsArray;
  }

  /// Creates a [Material] from a name.
  ///
  /// This method caches creation.
  Future<Material> create(String materialName) {
    if (!_materials.containsKey(materialName)) {
      return _createMaterial(materialName);
    }
    var completer = new Completer();
    completer.complete(_materials[materialName]);
    return completer.future;
  }

  Future<Material> _createMaterial(String materialName) {
    // Create material
    var mat = this._materialsInfo[materialName];
    var params = {
      "name": materialName,
      "side": this._side
    };

    var mapLoaded;

    for (var prop in mat.keys) {
      var value = mat[prop];
      switch (prop.toLowerCase()) {
        // Ns is material specular exponent
        case 'kd':
          // Diffuse color (color under white light) using RGB values
          params['diffuse'] = new Color.fromArray(value);
          break;

        case 'ka':
          // Ambient color (color under shadow) using RGB values
          params['ambient'] = new Color.fromArray(value);
          break;

        case 'ks':
          // Specular color (color when light is reflected from shiny surface) using RGB values
          params['specular'] = new Color.fromArray(value);
          break;

        case 'map_kd':
          // Diffuse texture map
          mapLoaded = this._loadTexture(_baseUrl + value);
          break;

        case 'ns':
          // The specular exponent (defines the focus of the specular highlight)
          // A high exponent results in a tight, concentrated highlight. Ns values normally range from 0 to 1000.
          params['shininess'] = double.parse(value).toInt();
          break;

        case 'd':
          // According to MTL format (http://paulbourke.net/dataformats/mtl/):
          //   d is dissolve for current material
          //   factor of 1.0 is fully opaque, a factor of 0 is fully dissolved (completely transparent)
          if (double.parse(value) < 1.0) {
            params['transparent'] = true;
            params['opacity'] = double.parse(value);
          }
          break;
        default:
          break;
      }
    }

    if (params.containsKey('diffuse')) {
      if (!params.containsKey('ambient')) {
        params['ambient'] = params['diffuse'];
      }
      params['color'] = params['diffuse'];
    }

    var completer = new Completer();
    if (mapLoaded != null) {
      mapLoaded.then((e) {
        params['map'] = e;
        params['map'].wrapS = this._wrap;
        params['map'].wrapT = this._wrap;
        var material = _createMeshPhongMaterial(params);
        _materials[materialName] = material;
        completer.complete(material);
      });
    } else {
      var material = _createMeshPhongMaterial(params);
      _materials[materialName] = material;
      completer.complete(material);
    }
    return completer.future;
  }

  MeshPhongMaterial _createMeshPhongMaterial(params) =>
      new MeshPhongMaterial(
          name: params['name'],
          side: params['side'],
          color: params.containsKey('color') ? (params['color'] as Color).getHex() : 0xffffff,
          ambient: params.containsKey('ambient') ? (params['ambient'] as Color).getHex() : 0xffffff,
          transparent: params.containsKey('transparent') ? params['transparent'] : false,
          opacity: params.containsKey('opacity') ? params['opacity'] : 1,
          shininess: params.containsKey('shininess') ? params['shininess'] : 30,
          map: params.containsKey('map') ? params['map'] : null);

  Future<Texture> _loadTexture(String url, [mapping]) {

    var imageLoader = new ImageLoader();
    imageLoader.crossOrigin = _crossOrigin;

    var completer = new Completer();
    var texture = new Texture();
    imageLoader.addEventListener("load", (EventEmitterEvent image) {
      texture.image = _ensurePowerOfTwo(image.content);
      texture.needsUpdate = true;
      completer.complete(texture);
    });
    imageLoader.load(url);
    texture.mapping = mapping;
    return completer.future;
  }

  ImageElement _ensurePowerOfTwo(ImageElement image) {
    if (!_isPowerOfTwo(image.width) || !_isPowerOfTwo(image.height)) {
      var canvas = document.createElement("canvas");
      canvas.width = _nextHighestPowerOfTwo(image.width);
      canvas.height = _nextHighestPowerOfTwo(image.height);

      final CanvasRenderingContext2D ctx = canvas.getContext("2d");
      ctx.drawImageScaledFromSource(image, 0, 0, image.width, image.height, 0, 0, canvas.width, canvas.height);
      return canvas;
    }
    return image;
  }

  bool _isPowerOfTwo(int value) => (value & (value - 1)) == 0;

  int _nextHighestPowerOfTwo(int x) {
    --x;
    for (var i = 1; i < 32; i <<= 1) {
      x = x | x >> i;
    }
    return x + 1;
  }

}
