library gltf_parser;

import 'dart:async' show Future;
import 'dart:convert' show JSON;
import 'dart:html' show HttpRequest;

typedef bool _EntryHandler(entryID, description, userInfo);

abstract class GLTFParser extends Object {
  var categoriesDepsOrder = ["buffers", "bufferViews", "images",  "videos", "samplers", "textures", "shaders", "programs", "techniques", "materials", "accessors", "meshes", "cameras", "lights", "skins", "nodes", "scenes", "animations"];

  Map rootDescription; // "writable": true

  String baseURL; // "writable": true

  Map<String, _EntryHandler> methodForType = {};

  GLTFParser() {
    methodForType = {
        "buffers" : handleBuffer,
        "bufferViews" : handleBufferView,
        "shaders" : handleShader,
        "programs" : handleProgram,
        "techniques" : handleTechnique,
        "materials" : handleMaterial,
        "meshes" : handleMesh,
        "cameras" : handleCamera,
        "lights" : handleLight,
        "nodes" : handleNode,
        "scenes" : handleScene,
        "images" : handleImage,
        "animations" : handleAnimation,
        "accessors" : handleAccessor,
        "skins" : handleSkin,
        "samplers" : handleSampler,
        "textures" : handleTexture,
        "videos" : handleVideo

        };
  }
  //detect absolute path following the same protocol than window.location
  bool _isAbsolutePath(String path) => path.startsWith("http://");

  resolvePathIfNeeded(path) {
    if (_isAbsolutePath(path)) {
        return path;
    }
    return baseURL + path;
   }

  _resolvePathsForCategories(categories) {
      categories.forEach( (category) {
          var descriptions = json[category];
          if (descriptions != null) {
              descriptions.forEach( (descriptionKey, description) {
                  description["path"] = resolvePathIfNeeded(description["path"]);
              });
          }
      });
  }

  var _json; // writable: true

  get json => _json;

  set json(value) {
    if (_json != value) {
      _json = value;
      _resolvePathsForCategories(["buffers", "shaders", "images", "videos"]);
    }
  }

  var _path; //writable: true

  getEntryDescription(entryID, entryType) {
      var entries = null;

      var category = entryType;
      entries = rootDescription[category];
      if (entries == null) {
          print("ERROR:CANNOT find expected category named:"+category);
          return null;
      }

      return (entries != null) ? entries[entryID] : null;
  }

  _stepToNextCategory() {
      _state["categoryIndex"] = getNextCategoryIndex(_state["categoryIndex"] + 1);
      if (_state["categoryIndex"] != -1) {
          _state["categoryState"]["index"] = 0;
          return true;
      }

      return false;
  }

  _stepToNextDescription() {
      var categoryState = _state["categoryState"];
      var keys = categoryState["keys"];
      if (keys == null) {
          print("INCONSISTENCY ERROR");
          return false;
      }

      categoryState["index"]++;
      categoryState["keys"] = null;
      if (categoryState["index"] >= keys.length) {
          return this._stepToNextCategory();
      }
      return false;
  }

  bool hasCategory(category) => rootDescription.containsKey(category);

  // Abstract methods to implement
  bool handleBuffer(centryID, Map description, userInfo);
  bool handleBufferView(entryID, Map description, userInfo);
  bool handleShader(entryID, Map description, userInfo);
  bool handleProgram(entryID, Map description, userInfo);
  bool handleTechnique(entryID, Map description, userInfo);
  bool handleMaterial(entryID, Map description, userInfo);
  bool handleMesh(entryID, Map description, userInfo);
  bool handleCamera(entryID, Map description, userInfo);
  bool handleLight(entryID, Map description, userInfo);
  bool handleNode(entryID, Map description, userInfo);
  bool handleScene(entryID, Map description, userInfo);
  bool handleImage(entryID, Map description, userInfo);
  bool handleAnimation(entryID, Map description, userInfo);
  bool handleAccessor(entryID, Map description, userInfo);
  bool handleSkin(entryID, Map description, userInfo);
  bool handleSampler(entryID, Map description, userInfo);
  bool handleTexture(entryID, Map description, userInfo);
  bool handleVideo(entryID, Map description, userInfo);

  bool _handleState() {

      var success = true;
      while (_state["categoryIndex"] != -1) {
          var category = categoriesDepsOrder[_state["categoryIndex"]];
          var categoryState = _state["categoryState"];
          var keys = categoryState["keys"];
          if (keys == null) {
              categoryState["keys"] = keys = rootDescription[category].keys.toList();
              if (keys != null) {
                  if (keys.length == 0) {
                      _stepToNextDescription();
                      continue;
                  }
              }
          }

          var type = category;
          var entryID = keys[categoryState["index"]];
          var description = getEntryDescription(entryID, type);
          if (description == null) {
              throw new Exception("INCONSISTENCY ERROR: no description found for entry $entryID");
          } else {

              if (methodForType[type] != null) {
                  if (!methodForType[type](entryID, description, _state["userInfo"])) {
                      success = false;
                      break;
                  }
              }

              _stepToNextDescription();
          }
      }

      return success;

  }

  Future _load() {
    //enumerable: true,
    if (_json != null) {
      return Future.value(_json);
    }

    var jsonPath = _path;
    var i = jsonPath.lastIndexOf("/");
    baseURL = (i != 0) ? jsonPath.substring(0, i + 1) : '';

    return HttpRequest.request(jsonPath).then((req) {
      json = JSON.decode(req.responseText);
      rootDescription = _json;
    });
  }

  var _state; // writable: true

  _getEntryType(entryID) {
      var rootKeys = categoriesDepsOrder;
      for (var i = 0 ;  i < rootKeys.length ; i++) {
          var rootValues = this.rootDescription[rootKeys[i]];
          if (rootValues) {
              return rootKeys[i];
          }
      }
      return null;
  }

  getNextCategoryIndex(currentIndex) {
      for (var i = currentIndex ; i < categoriesDepsOrder.length ; i++) {
          if (hasCategory(categoriesDepsOrder[i])) {
              return i;
          }
      }

      return -1;
  }

  doLoad(userInfo, options) { // enumerable: true
    _load().then((_) {
        var startCategory = getNextCategoryIndex(0);
        if (startCategory != -1) {
            _state = { "userInfo" : userInfo,
                        "options" : options,
                        "categoryIndex" : startCategory,
                        "categoryState" : { "index" : 0 } };
        return _handleState();
      }
    });
  }

  initWithPath(path) {
    _path = path;
    _json = null;
    return this;
  }

  //this is meant to be global and common for all instances
  var _knownURLs = {}; //writable: true

  //to be invoked by subclass, so that ids can be ensured to not overlap
  loaderContext() {
      if (_knownURLs[_path] == null) {
          _knownURLs[_path] = _knownURLs.length;
      }
      return "__${_knownURLs[_path]}";
  }

  initWithJSON(json, baseURL) {
      this.json = json;
      this.baseURL = baseURL;
      if (!baseURL) {
          print("WARNING: no base URL passed to Reader:initWithJSON");
      }
      return this;
  }

}