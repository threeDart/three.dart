part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author nelson silva / http://www.inevo.pt/
 *
 * based on r51
 */
class JSONLoader extends Loader {

  JSONLoader({bool showStatus: false}) : super(showStatus);

  void load(url, LoadedCallback callback, {texturePath: null}) {
    if (texturePath == null) {
      texturePath = Loader._extractUrlBase(url);
    }

    onLoadStart();

    _loadAjaxJSON(url, callback, texturePath);
  }

  void _loadAjaxJSON(String url, LoadedCallback callback, String texturePath, {LoadProgressCallback callbackProgress}) {
    var xhr = new HttpRequest();

    var length = 0;

    xhr.onReadyStateChange.listen((Event e) {
      if (xhr.readyState == HttpRequest.DONE) {
        if (xhr.status == 200 || xhr.status == 0) {
          if (!xhr.responseText.isEmpty) {
            var json = JSON.decode(xhr.responseText);
            _createModel(json, callback, texturePath);
          } else {
            print("JSONLoader: [$url] seems to be unreachable or file there is empty");
          }

          // in context of more complex asset initialization
          // do not block on single failed file
          // maybe should go even one more level up
          onLoadComplete();
        } else {
          print("JSONLoader: Couldn't load [$url] [${xhr.status}]");
        }
      } else if (xhr.readyState == HttpRequest.LOADING) {
        if (callbackProgress != null) {
          if (length == 0) {
            length = xhr.getResponseHeader("Content-Length");
          }

          callbackProgress({
            "total": length,
            "loaded": xhr.responseText.length
          });
        }
      } else if (xhr.readyState == HttpRequest.HEADERS_RECEIVED) {
        length = xhr.getResponseHeader("Content-Length");
      }
    });

    xhr.open("GET", url);
    xhr.send(null);
  }

  bool _isBitSet(value, position) => (value & (1 << position)) > 0;

  void _createModel(Map json, LoadedCallback callback, String texturePath) {
    var geometry = new Geometry(),
        scale = (json.containsKey("scale")) ? 1.0 / json["scale"] : 1.0;

    _initMaterials(geometry, json["materials"], texturePath);

    _parseModel(json, geometry, scale);

    _parseSkin(json, geometry);
    _parseMorphing(json, geometry, scale);

    geometry.computeCentroids();
    geometry.computeFaceNormals();

    if (_hasNormals(geometry)) geometry.computeTangents();

    callback(geometry);
  }

  void _parseModel(Map json, Geometry geometry, num scale) {
    var faces = json["faces"],
        vertices = json["vertices"],
        normals = json["normals"],
        colors = json["colors"],

        nUvLayers = 0;

    // disregard empty arrays

    for (var i = 0; i < json["uvs"].length; i++) {
      if (!json["uvs"][i].isEmpty) nUvLayers++;
    }

    geometry.faceUvs = new List(nUvLayers);
    geometry.faceVertexUvs = new List(nUvLayers);

    for (var i = 0; i < nUvLayers; i++) {
      geometry.faceUvs[i] = new List(faces.length);
      geometry.faceVertexUvs[i] = new List(faces.length);
    }

    var offset = 0;
    var zLength = vertices.length;

    while (offset < zLength) {
      var vertex = new Vector3.zero();

      vertex.x = vertices[offset++] * scale;
      vertex.y = vertices[offset++] * scale;
      vertex.z = vertices[offset++] * scale;

      geometry.vertices.add(vertex);
    }

    offset = 0;
    zLength = faces.length;

    while (offset < zLength) {
      var type = faces[offset++];

      var isQuad = _isBitSet(type, 0);
      var hasMaterial = _isBitSet(type, 1);
      var hasFaceUv = _isBitSet(type, 2);
      var hasFaceVertexUv = _isBitSet(type, 3);
      var hasFaceNormal = _isBitSet(type, 4);
      var hasFaceVertexNormal = _isBitSet(type, 5);
      var hasFaceColor = _isBitSet(type, 6);
      var hasFaceVertexColor = _isBitSet(type, 7);
      
      if (isQuad) {
        var faceA = new Face3();
        faceA.a = faces[offset];
        faceA.b = faces[offset + 1];
        faceA.c = faces[offset + 3];

        var faceB = new Face3();
        faceB.a = faces[offset + 1];
        faceB.b = faces[offset + 2];
        faceB.c = faces[offset + 3];

        offset += 4;

        if (hasMaterial) {
          var materialIndex = faces[offset ++];
          faceA.materialIndex = materialIndex;
          faceB.materialIndex = materialIndex;
        }

        // to get face <=> uv index correspondence

        var fi = geometry.faces.length;

        if (hasFaceVertexUv) {
          for (var  i = 0; i < nUvLayers; i ++) {
            var uvLayer = json['uvs'][i];

            geometry.faceVertexUvs[i][fi] = [];
            geometry.faceVertexUvs[i][fi + 1] = [];

            for (var j = 0; j < 4; j ++) {

              var uvIndex = faces[offset ++];

              var u = uvLayer[uvIndex * 2];
              var v = uvLayer[uvIndex * 2 + 1];

              var uv = new Vector2(u, v);

              if (j != 2) geometry.faceVertexUvs[i][fi].add(uv);
              if (j != 0) geometry.faceVertexUvs[i][fi + 1].add(uv);
            }
          }
        }

        if (hasFaceNormal) {
          var normalIndex = faces[offset ++] * 3;

          faceA.normal.setValues(
            normals[normalIndex++].toDouble(),
            normals[normalIndex++].toDouble(),
            normals[normalIndex].toDouble()
         );

          faceB.normal.setFrom(faceA.normal);
        }

        if (hasFaceVertexNormal) {
          for (var i = 0; i < 4; i ++) {
            var normalIndex = faces[offset ++] * 3;

            var normal = new Vector3(
              normals[normalIndex++].toDouble(),
              normals[normalIndex++].toDouble(),
              normals[normalIndex].toDouble()
           );


            if (i != 2) faceA.vertexNormals.add(normal);
            if (i != 0) faceB.vertexNormals.add(normal);
          }
        }


        if (hasFaceColor) {
          var colorIndex = faces[offset ++];
          var hex = colors[colorIndex];

          faceA.color.setHex(hex);
          faceB.color.setHex(hex);
        }


        if (hasFaceVertexColor) {
          for (var i = 0; i < 4; i ++) {
            var colorIndex = faces[offset ++];
            var hex = colors[colorIndex];

            if (i != 2) faceA.vertexColors.add(new Color(hex));
            if (i != 0) faceB.vertexColors.add(new Color(hex));

          }
        }

        geometry.faces.add(faceA);
        geometry.faces.add(faceB);

      } else {
        var face = new Face3();
        face.a = faces[offset ++];
        face.b = faces[offset ++];
        face.c = faces[offset ++];

        if (hasMaterial) {
          var materialIndex = faces[offset ++];
          face.materialIndex = materialIndex;
        }

        // to get face <=> uv index correspondence

        var fi = geometry.faces.length;

        if (hasFaceVertexUv) {
          for (var i = 0; i < nUvLayers; i ++) {
            var uvLayer = json['uvs'][i];

            geometry.faceVertexUvs[i][fi] = [];

            for (var j = 0; j < 3; j ++) {
              var uvIndex = faces[offset ++];

              var u = uvLayer[uvIndex * 2];
              var v = uvLayer[uvIndex * 2 + 1];

              var uv = new Vector2(u, v);

              geometry.faceVertexUvs[i][fi].add(uv);
            }
          }
        }

        if (hasFaceNormal) {
          var normalIndex = faces[offset ++] * 3;

          face.normal.setValues(
            normals[normalIndex ++],
            normals[normalIndex ++],
            normals[normalIndex]
         );
        }

        if (hasFaceVertexNormal) {
          for (var i = 0; i < 3; i ++) {
            var normalIndex = faces[offset ++] * 3;

            var normal = new Vector3(
              normals[normalIndex ++],
              normals[normalIndex ++],
              normals[normalIndex]
           );

            face.vertexNormals.add(normal);
          }
        }


        if (hasFaceColor) {
          var colorIndex = faces[offset ++];
          face.color.setHex(colors[colorIndex]);
        }

        if (hasFaceVertexColor) {
          for (var i = 0; i < 3; i ++) {
            var colorIndex = faces[offset ++];
            face.vertexColors.add(new Color(colors[colorIndex]));
          }
        }

        geometry.faces.add(face);
      }
    }
  }

  void _parseSkin(Map json, Geometry geometry) {
    if (json.containsKey("skinWeights")) {
      var l = json["skinWeights"].length;
      for (var i = 0; i < l; i += 2) {
        var x = json["skinWeights"][i];
        var y = json["skinWeights"][i + 1];
        var z = 0.0;
        var w = 0.0;

        geometry.skinWeights.add(new Vector4(x.toDouble(), y.toDouble(), z.toDouble(), w.toDouble()));
      }
    }

    if (json.containsKey("skinIndices")) {
      var l = json["skinIndices"].length;
      for (var i = 0; i < l; i += 2) {
        var a = json["skinIndices"][i];
        var b = json["skinIndices"][i + 1];
        var c = 0.0;
        var d = 0.0;

        geometry.skinIndices.add(new Vector4(a.toDouble(), b.toDouble(), c.toDouble(), d.toDouble()));
      }
    }

    geometry.bones = json["bones"];
    geometry.animation = json["animation"];
  }

  void _parseMorphing(Map json, Geometry geometry, num scale) {
    if (json.containsKey("morphTargets")) {
      geometry.morphTargets = new List(json["morphTargets"].length);

      for (var i = 0; i < geometry.morphTargets.length; i++) {
        geometry.morphTargets[i] = new MorphTarget(name: json["morphTargets"][i]["name"], vertices: []);

        var dstVertices = geometry.morphTargets[i].vertices;
        var srcVertices = json["morphTargets"][i]["vertices"];

        var vl = srcVertices.length;
        for (var v = 0; v < vl; v += 3) {
          var vertex = new Vector3.zero();
          vertex.x = srcVertices[v] * scale;
          vertex.y = srcVertices[v + 1] * scale;
          vertex.z = srcVertices[v + 2] * scale;

          dstVertices.add(vertex);
        }
      }
    }

    if (json.containsKey("morphColors")) {
      geometry.morphColors = new List(json["morphColors"].length);

      for (var i = 0; i < geometry.morphColors.length; i++) {
        var dstColors = [];
        var srcColors = json["morphColors"][i]["colors"];

        var cl = srcColors.length;
        for (var c = 0; c < cl; c += 3) {
          var color = new Color(0xffaa00);
          color.setRGB(srcColors[c], srcColors[c + 1], srcColors[c + 2]);
          dstColors.add(color);
        }

        geometry.morphColors[i] = new MorphColors(name: json["morphColors"][i]["name"], colors: dstColors);
      }
    }
  }

}
