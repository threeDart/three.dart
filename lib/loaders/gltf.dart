/**
 * r66
 */

library gltf_loader;

import 'dart:async' show Completer, Future;
import 'dart:math' as Math;
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as gl;

import 'package:three/three.dart' as THREE;
import 'package:vector_math/vector_math.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;

import 'gltf/gltf_loader_utils.dart' as GLTFLoaderUtils;
import 'gltf/gltf_parser.dart';

part 'gltf/gltf_animation.dart';

// Utilities
log(msg) => print(msg);

rgbArraytoHex(colorArray) {
  if (colorArray == null) return 0xFFFFFFFF;
  var r = (colorArray[0] * 255).floor(), g = (colorArray[1] * 255).floor(), b = (colorArray[2] * 255).floor(), a = 255;

  var color = (a << 24) + (r << 16) + (g << 8) + b;

  return color;
}

convertAxisAngleToQuaternion(rotations, count) {
  var q = new Quaternion.identity();
  var axis = new Vector3.zero();
  var euler = new Vector3.zero();

  var i;
  for (i = 0; i < count; i++) {
    axis.setValues(
        rotations[i * 4].toDouble(),
        rotations[i * 4 + 1].toDouble(),
        rotations[i * 4 + 2].toDouble()).normalize();
    var angle = rotations[i * 4 + 3].toDouble();
    q.setAxisAngle(axis, angle);
    rotations[i * 4] = q.x;
    rotations[i * 4 + 1] = q.y;
    rotations[i * 4 + 2] = q.z;
    rotations[i * 4 + 3] = q.w;
  }
}

componentsPerElementForGLType(glType) {
  switch (glType) {
    case gl.FLOAT :
    case gl.UNSIGNED_BYTE :
    case gl.UNSIGNED_SHORT :
      return 1;
    case gl.FLOAT_VEC2 :
      return 2;
    case gl.FLOAT_VEC3 :
      return 3;
    case gl.FLOAT_VEC4 :
      return 4;
    case gl.FLOAT_MAT4 :
      return 16;
    default:
      return null;
  }
}

loadTexture([src]) => (src == null) ? null : ImageUtils.loadTexture(src);

class GLTFLoaderResult {
  THREE.Object3D scene;
  List cameras;
  List animations;
}

class GLTFLoader extends GLTFParser { // implements THREE.Loader

  THREE.Object3D rootObj;

  static bool useBufferGeometry = false;
  int meshesRequested = 0,
      meshesLoaded = 0;
  List pendingMeshes = [];
  int animationsRequested = 0,
      animationsLoaded = 0;
  List animations = [];
  int shadersRequested = 0,
      shadersLoaded = 0;
  Map shaders = {};
  Resources resources;

  var cameras = []; // enumerable: true, writable: true,
  var lights = []; // enumerable: true, writable: true,
  var joints = {};
  var skeletons = {};
  Map<String, List<GLTFInterpolator>> nodeAnimationChannels = {};

  var indicesDelegate;
  var vertexAttributeDelegate;
  var animationParameterDelegate;
  var inverseBindMatricesDelegate;
  var shaderDelegate;

  GLTFLoader([bool showStatus = false]) : super();

  Completer<GLTFLoaderResult> completer;

  Future<GLTFLoaderResult> load(url) {

    indicesDelegate = new IndicesDelegate();
    vertexAttributeDelegate = new VertexAttributeDelegate();
    animationParameterDelegate = new AnimationParameterDelegate();
    inverseBindMatricesDelegate = new InverseBindMatricesDelegate();
    shaderDelegate = new ShaderDelegate(this);

    // Loader

    var rootObj = new THREE.Object3D();

    var self = this;

    resources = new Resources();
    cameras = [];
    lights = [];
    animations = [];
    joints = {};
    skeletons = {};
    GLTFLoaderUtils.init();

    initWithPath(url);
    doLoad(new Context(rootObj,(obj) {}), null);

    this.rootObj = rootObj;

    completer = new Completer<GLTFLoaderResult>();

    return completer.future;
  }

  // Implement WebGLTFLoader handlers

  handleBuffer(entryID, Map description, userInfo) {
    resources.setEntry(entryID, null, description);
    description["type"] = "ArrayBuffer";
    return true;
  }

  handleBufferView(entryID, Map description, userInfo) {
      resources.setEntry(entryID, null, description);

      var buffer = resources.getEntry(description["buffer"]);
      description["type"] = "ArrayBufferView";

      var bufferViewEntry = resources.getEntry(entryID);
      bufferViewEntry.buffer = buffer;
      return true;
  }

  handleVideo(entryID, Map description, userInfo) {
    log("UNIMPLEMENTED: handleVideo");
  }

  handleShader(entryID, Map description, userInfo) {
    resources.setEntry(entryID, null, description);
    var shaderRequest = new GLTFLoaderUtils.Request(
        id: entryID,
        path: description["path"]
    );

    var shaderContext = new ShaderContext(entryID, description["path"]);

    shadersRequested++;
    GLTFLoaderUtils.getFile(shaderRequest, shaderDelegate, shaderContext);

    return true;
  }

  handleProgram(entryID, Map description, userInfo) {
    resources.setEntry(entryID, null, description);
    return true;
  }

  handleTechnique(entryID, Map description, userInfo) {
    resources.setEntry(entryID, null, description);
    return true;
  }

  createShaderMaterial(material) {

    var fragmentShader = shaders[material.params.fragmentShader];
    if (!fragmentShader) {
            log("ERROR: Missing fragment shader definition: " + material.params.fragmentShader);
        return new THREE.MeshPhongMaterial();
    }

    var vertexShader = shaders[material.params.vertexShader];
    if (!fragmentShader) {
            log("ERROR: Missing vertex shader definition: " + material.params.vertexShader);
        return new THREE.MeshPhongMaterial();
    }

    var uniforms = {};
    var shaderMaterial = new THREE.ShaderMaterial(
      fragmentShader: fragmentShader,
      vertexShader: vertexShader,
      uniforms: uniforms
    );

    return threeJSPhongMaterialFactory(material.params);
  }

  createShaderParams(materialId, values, params, instanceProgram) {
      var program = resources.getEntry(instanceProgram.program);

      if (program) {
        params.fragmentShader = program.description.fragmentShader;
        params.vertexShader = program.description.vertexShader;
        params.attributes = instanceProgram.attributes;
        params.uniforms = instanceProgram.uniforms;
      }
    }

  threeJSBasicMaterialFactory(params) => new THREE.MeshBasicMaterial();
  threeJSPhongMaterialFactory(params) => new THREE.MeshPhongMaterial(
    map: params["map"], color: params["color"], opacity: params["opacity"], transparent: params["transparent"],
    shininess: params["shininess"], emissive: params["emissive"], specular: params["specular"]);
  threeJSLambertMaterialFactory(params) => new THREE.MeshLambertMaterial();

  threeJSMaterialFactory(materialId, ResourceEntry technique, Map values, Map params) {

    var materialFactory = threeJSPhongMaterialFactory;
    var defaultPass = null;
    if (technique != null && technique.description != null && technique.description["passes"] != null)
      defaultPass = technique.description["passes"]["defaultPass"];

    if (defaultPass != null) {
      if (defaultPass["details"] != null && defaultPass["details"]["commonProfile"] != null) {
          var profile = defaultPass["details"]["commonProfile"];
          if (profile != null) {
            switch (profile["lightingModel"]) {
              case 'Blinn' :
              case 'Phong' :
                materialFactory = threeJSPhongMaterialFactory;
                break;

              case 'Lambert' :
                materialFactory = threeJSLambertMaterialFactory;
                break;

              default :
                materialFactory = threeJSBasicMaterialFactory;
                break;
            }

            if (profile["extras"] != null && profile["extras"]["doubleSided"]) {
              params["side"] = THREE.DoubleSide;
            }
          }
      } else if (defaultPass["instanceProgram"] != null) {

        var instanceProgram = defaultPass["instanceProgram"];

        createShaderParams(materialId, values, params, instanceProgram);

        var loadshaders = true;

        if (loadshaders) {
          materialFactory = (params) => new Material(params);
        }
      }
    }

    var texturePath = null;
    var textureParams = null;
    var diffuse = values["diffuse"];
    if (diffuse != null) {
      var texture = diffuse;
      if (texture != null) {
          var textureEntry = resources.getEntry(texture);
          if (textureEntry != null) {

            var imageEntry = resources.getEntry(textureEntry.description["source"]);
            if (imageEntry != null) {
              texturePath = imageEntry.description["path"];
            }

            var samplerEntry = resources.getEntry(textureEntry.description["sampler"]);
            if (samplerEntry != null) {
              textureParams = samplerEntry.description;
            }

          }
      }
    }

    var texture = loadTexture(texturePath);
    if (texture != null && textureParams != null) {

      if (textureParams["wrapS"] == gl.REPEAT)
        texture.wrapS = THREE.RepeatWrapping;

      if (textureParams["wrapT"] == gl.REPEAT)
        texture.wrapT = THREE.RepeatWrapping;

      if (textureParams["magFilter"] == gl.LINEAR)
        texture.magFilter = THREE.LinearFilter;

//                	if (textureParams.minFilter == "LINEAR")
//               		texture.minFilter = THREE.LinearFilter;

        params["map"] = texture;
    }

    var envMapPath = null;
    var envMapParams = null;
    var reflective = values["reflective"];
    if (reflective != null) {
      var texture = reflective;
      if (texture != null) {
        var textureEntry = resources.getEntry(texture);
        if (textureEntry != null) {

          var imageEntry = resources.getEntry(textureEntry.description["source"]);
          if (imageEntry != null) {
            envMapPath = imageEntry.description["path"];
          }

          var samplerEntry = resources.getEntry(textureEntry.description["sampler"]);
          if (samplerEntry != null) {
            envMapParams = samplerEntry.description;
          }

        }
      }
    }

    texture = loadTexture(envMapPath);
    if (texture != null && envMapParams != null) {

      if (envMapParams["wrapS"] == gl.REPEAT)
        texture.wrapS = THREE.RepeatWrapping;

      if (envMapParams["wrapT"] == gl.REPEAT)
        texture.wrapT = THREE.RepeatWrapping;

      if (envMapParams["magFilter"] == gl.LINEAR)
        texture.magFilter = THREE.LinearFilter;

//                	if (envMapParams.minFilter == WebGLRenderingContext.LINEAR)
//               		texture.minFilter = THREE.LinearFilter;

        params["envMap"] = texture;
    }

    var shininess = values["shininess"]; //TODO(nfgs) || values.shininesss; // N.B.: typo in converter!

    var diffuseColor = (texturePath == null) ? diffuse : null;
    var opacity = 1.0;
    if (values.containsKey("transparency")) {
      var USE_A_ONE = true; // for now, hack because file format isn't telling us
      opacity =  USE_A_ONE ? values["transparency"] : (1.0 - values["transparency"]);
    }

    // if (diffuseColor) diffuseColor = [0, 1, 0];

    params["color"] = rgbArraytoHex(diffuseColor);
    params["opacity"] = opacity;
    params["transparent"] = opacity < 1.0;
    // hack hack hack
    if (texturePath != null && texturePath.toLowerCase().indexOf(".png") != -1)
      params["transparent"] = true;

    if (shininess != null) {
      params["shininess"] = shininess;
    }

    if (values["ambient"] != null && values["ambient"] is String) {
      params["ambient"] = rgbArraytoHex(values["ambient"]);
    }

    if (values["emission"] != null) {
      params["emissive"] = rgbArraytoHex(values["emission"]);
    }

    if (values["specular"] != null) {
      params["specular"] = rgbArraytoHex(values["specular"]);
    }

    return materialFactory;

  }

  handleMaterial(entryID, Map description, userInfo) {
      //this should be rewritten using the meta datas that actually create the shader.
      //here we will infer what needs to be pass to Three.js by looking inside the technique parameters.
      var technique = resources.getEntry(description["instanceTechnique"]["technique"]);
      var materialParams = {};
      var values = description["instanceTechnique"]["values"];

      var materialFactory = threeJSMaterialFactory(entryID, technique, values, materialParams);

      var material = materialFactory(materialParams);

      resources.setEntry(entryID, material, description);

      return true;
  }

  handleMesh(entryID, Map description, userInfo) {
    var mesh = new Mesh();
    resources.setEntry(entryID, mesh, description);
    var primitivesDescription = description["primitives"];
    if (primitivesDescription == null) {
        //FIXME: not implemented in delegate
        log("MISSING_PRIMITIVES for mesh:"+ entryID);
        return false;
    }

    for (var i = 0 ; i < primitivesDescription.length ; i++) {
        var primitiveDescription = primitivesDescription[i];

        if (primitiveDescription["primitive"] == gl.TRIANGLES) {

            var geometry = new ClassicGeometry(useBufferGeometry);
            var materialEntry = resources.getEntry(primitiveDescription["material"]);

            mesh.addPrimitive(geometry, materialEntry.object);

            var indices = resources.getEntry(primitiveDescription["indices"]);
            var bufferEntry = resources.getEntry(indices.description["bufferView"]);
            var indicesObject = new GLTFLoaderUtils.WrappedBufferView(
                bufferView : bufferEntry,
                byteOffset : indices.description["byteOffset"],
                count : indices.description["count"],
                id : indices.entryID,
                type : indices.description["type"]
            );

            var indicesContext = new IndicesContext(indicesObject, geometry);
            var alreadyProcessedIndices = GLTFLoaderUtils.getBuffer(indicesObject, indicesDelegate, indicesContext);
            /*if(alreadyProcessedIndices) {
                indicesDelegate.resourceAvailable(alreadyProcessedIndices, indicesContext);
            }*/

            // Load Vertex Attributes
            primitiveDescription["attributes"].forEach( (semantic, attributeID) {
                geometry.totalAttributes++;

                var attribute, bufferEntry;
                var attributeEntry = resources.getEntry(attributeID);
                if (attributeEntry == null) {
                    //let's just use an anonymous object for the attribute
                    attribute = description["attributes"][attributeID];
                    attribute.id = attributeID;
                    resources.setEntry(attributeID, attribute, attribute);

                    bufferEntry = resources.getEntry(attribute.bufferView);
                    attributeEntry = resources.getEntry(attributeID);

                } else {
                    attribute = attributeEntry.object;
                    attribute["id"] = attributeID;
                    bufferEntry = resources.getEntry(attribute["bufferView"]);
                }

                var attributeObject = new GLTFLoaderUtils.WrappedBufferView(
                    bufferView : bufferEntry,
                    byteOffset : attribute["byteOffset"],
                    byteStride : attribute["byteStride"],
                    count : attribute["count"],
                    max : attribute["max"],
                    min : attribute["min"],
                    type : attribute["type"],
                    id : attributeID
                );

                var attribContext = new VertexAttributeContext(attributeObject, semantic, geometry);

                var alreadyProcessedAttribute = GLTFLoaderUtils.getBuffer(attributeObject, vertexAttributeDelegate, attribContext);
                /*if(alreadyProcessedAttribute) {
                    vertexAttributeDelegate.resourceAvailable(alreadyProcessedAttribute, attribContext);
                }*/
            });
        }
    }
    return true;
  }

  handleCamera(entryID, Map description, userInfo) {
    var camera;
    if (description["type"] == "perspective") {
      var znear = description["perspective"]["znear"];
      var zfar = description["perspective"]["zfar"];
      var yfov = description["perspective"]["yfov"];
      var xfov = description["perspective"]["xfov"];
      var aspect_ratio = description["perspective"]["aspect_ratio"];

      if (aspect_ratio == null)
          aspect_ratio = 1.0;

      if (yfov == null) {
        if (xfov) {
          // According to COLLADA spec...
          // aspect_ratio = xfov / yfov
          yfov = xfov / aspect_ratio;
        }

      }

      if (yfov != null) {
        camera = new THREE.PerspectiveCamera(yfov.toDouble(), aspect_ratio.toDouble(), znear.toDouble(), zfar.toDouble());
      }
    } else {
      camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / - 2, znear, zfar );
    }

    if (camera != null) {
      resources.setEntry(entryID, camera, description);
    }

    return true;
  }

  handleLight(entryID, Map description, userInfo) {

      var light = null;
      var type = description["type"];
      if (type != null && description[type] != null) {
        var lparams = description[type];
          var color = rgbArraytoHex(lparams["color"]);

          switch (type) {
            case "directional" :
              light = new THREE.DirectionalLight(color);
              light.position.setValues(0.0, 0.0, 1.0);
            break;

            case "point" :
              light = new THREE.PointLight(color);
            break;

            case "spot " :
              light = new THREE.SpotLight(color);
              light.position.setValues(0.0, 0.0, 1.0);
            break;

            case "ambient" :
              light = new THREE.AmbientLight(color);
            break;
          }
      }

      if (light != null) {
        resources.setEntry(entryID, light, description);
      }

      return true;
  }

  addPendingMesh(mesh, threeNode) {
      pendingMeshes.add({
        "mesh": mesh,
        "node": threeNode
      });
    }

  handleNode(entryID, Map description, userInfo) {

    var threeNode = null;
    if (description["jointId"] != null) {
        threeNode = new THREE.Bone(null);
        threeNode["jointId"] = description["jointId"];
        this.joints[description["jointId"]] = entryID;
    } else {
        threeNode = new THREE.Object3D();
    }

      threeNode.name = description["name"];

      resources.setEntry(entryID, threeNode, description);

      var m = description["matrix"];
      if(m != null) {
          // Convert to doubles
          m = m.map((e) => e.toDouble()).toList();
          threeNode.applyMatrix(new Matrix4(
              m[0],  m[4],  m[8],  m[12],
              m[1],  m[5],  m[9],  m[13],
              m[2],  m[6],  m[10], m[14],
              m[3],  m[7],  m[11], m[15]
          ));
          threeNode.matrixAutoUpdate = false;
          threeNode.matrixWorldNeedsUpdate = true;
      }
      else {
        var t = description["translation"];
        var r = description["rotation"];
        var s = description["scale"];

        var position = (t != null) ? new Vector3(t[0].toDouble(), t[1].toDouble(), t[2].toDouble()) : new Vector3.zero();
        if (r != null) {
          convertAxisAngleToQuaternion(r, 1);
        }
        var rotation = (r != null) ? new Quaternion(r[0].toDouble(), r[1].toDouble(), r[2].toDouble(), r[3].toDouble()) : new Quaternion.identity();
        var scale = (s != null) ? new Vector3(s[0].toDouble(), s[1].toDouble(), s[2].toDouble()) : new Vector3.zero();

        var matrix = THREE.compose( new Matrix4.identity(), position, rotation, scale);

        threeNode.matrixAutoUpdate = false;
        threeNode.matrixWorldNeedsUpdate = true;
        threeNode.applyMatrix(matrix);
      }

      // Iterate through all node meshes and attach the appropriate objects
      //FIXME: decision needs to be made between these 2 ways, probably meshes will be discarded.
      var meshEntry;
      if (description["mesh"] != null) {
          meshEntry = resources.getEntry(description["mesh"]);
          meshesRequested++;
          meshEntry.object.onComplete((mesh) {
            addPendingMesh(mesh, threeNode);
            meshesLoaded++;
            checkComplete();
          });
      }

      if (description["meshes"] != null) {
          description["meshes"].forEach( (meshID) {
              meshEntry = resources.getEntry(meshID);
              meshesRequested++;
              meshEntry.object.onComplete((mesh) {
                addPendingMesh(mesh, threeNode);
                meshesLoaded++;
                checkComplete();
              });
          });
      }

      if (description["instanceSkin"] != null) {

        var skinEntry =  resources.getEntry(description["instanceSkin"]["skin"]);

        if (skinEntry != null) {

          var skin = skinEntry.object;
          description["instanceSkin"]["skin"] = skin;
          threeNode["instanceSkin"] = description["instanceSkin"];

          var sources = description["instanceSkin"]["sources"];
          skin["meshes"] = [];
          sources.forEach( (meshID) {
              meshEntry = resources.getEntry(meshID);
              meshesRequested++;
              meshEntry.object.onComplete((mesh) {

                skin["meshes"].add(mesh);
                meshesLoaded++;
                checkComplete();
              });
          });

        }
      }

      if (description["camera"] != null) {
          var cameraEntry = resources.getEntry(description["camera"]);
          if (cameraEntry != null) {
            threeNode.add(cameraEntry.object);
            cameras.add(cameraEntry.object);
          }
      }

      if (description["light"] != null) {
          var lightEntry = resources.getEntry(description["light"]);
          if (lightEntry != null) {
            threeNode.add(lightEntry.object);
            lights.add(lightEntry.object);
          }
      }

      return true;
  }

  buildNodeHirerachy(nodeEntryId, parentThreeNode) {
      var nodeEntry = resources.getEntry(nodeEntryId);
      var threeNode = nodeEntry.object;
      parentThreeNode.add(threeNode);

      var children = nodeEntry.description["children"];
      if (children != null) {
          children.forEach((childID) {
              buildNodeHirerachy(childID, threeNode);
          });
      }

      return threeNode;
  }

  buildSkin(node) {

    var skin = node["instanceSkin"]["skin"];
    if (skin == null) { return; }
    node["instanceSkin"]["skeletons"].forEach((skeleton) {
        var nodeEntry = resources.getEntry(skeleton);
        if (nodeEntry != null) {

          var rootSkeleton = nodeEntry.object;

            var dobones = true;

            skin["meshes"].forEach((Mesh mesh) {
              var threeMesh = null;
              mesh.primitives.forEach((primitive) {

                var material = primitive["material"];
                if (material is! THREE.Material) {
                  material = createShaderMaterial(material);
                }

                threeMesh = new THREE.SkinnedMesh(primitive["geometry"].geometry, material, useVertexTexture: false);
                threeMesh.add(rootSkeleton);

                var geometry = primitive["geometry"].geometry;
                var j;
                if ( geometry is! THREE.BufferGeometry) {
                  geometry.vertices.forEach((v) {
                    skin["bindShapeMatrix"].transform3(v);
                  });
                } else if (geometry.attributes[THREE.GeometryAttribute.POSITION]!= null) {
                  var a = geometry.attributes[THREE.GeometryAttribute.POSITION].array;
                  var v = new Vector3.zero();
                  for ( j = 0; j < a.length / 3; j++ ) {
                    v.setValues(a[j * 3], a[j * 3 + 1], a[j * 3 + 2]);
                    skin["bindShapeMatrix"].transform3(v);
                    a[j * 3] = v.x;
                    a[j * 3 + 1] = v.y;
                    a[j * 3 + 2] = v.z;
                  }
                }

                if (threeMesh != null && dobones) {

                    material.skinning = true;

                    threeMesh["boneInverses"] = [];
                    var jointsIds = skin["jointsIds"];
                    var joints = [];
                    var i = 0;
                    jointsIds.forEach((jointId) {
                      var nodeForJoint = this.joints[jointId];
                      var joint = resources.getEntry(nodeForJoint).object;
                      if (joint != null) {

                        joint.skin = threeMesh;
                        joints.add(joint);
                        threeMesh.bones.add(joint);

                        var m = skin["inverseBindMatrices"];
                        var mat = new Matrix4(
                                  m[i * 16 + 0],  m[i * 16 + 4],  m[i * 16 + 8],  m[i * 16 + 12],
                                  m[i * 16 + 1],  m[i * 16 + 5],  m[i * 16 + 9],  m[i * 16 + 13],
                                  m[i * 16 + 2],  m[i * 16 + 6],  m[i * 16 + 10], m[i * 16 + 14],
                                  m[i * 16 + 3],  m[i * 16 + 7],  m[i * 16 + 11], m[i * 16 + 15]
                              );
                          threeMesh["boneInverses"].add(mat);
                          threeMesh.pose();

                      } else {
                          log("WARNING: jointId:"+jointId+" cannot be found in skeleton:"+skeleton);
                      }
                      i++;
                    });
                  }

                  if (threeMesh != null) {
                    threeMesh.castShadow = true;
                    node.add(threeMesh);
                  }

              });
            });
        }

    });

  }

  buildSkins(node) {
      if (node["instanceSkin"] != null)
        buildSkin(node);
        var children = node.children.toList();
        children.forEach((child) {
            buildSkins(child);
        });
  }

  createMeshAnimations(root) {
    buildSkins(root);
  }

  handleScene(entryID, description, userInfo) {

      if (description["nodes"] == null) {
          log("ERROR: invalid file required nodes property is missing from scene");
          return false;
      }

      description["nodes"].forEach( (nodeUID) {
          buildNodeHirerachy(nodeUID, userInfo.rootObj);
      });

      if (delegate != null) {
          delegate.loadCompleted(userInfo.callback, userInfo.rootObj);
      }

      return true;
  }

  handleImage(entryID, description, userInfo) {
      resources.setEntry(entryID, null, description);
      return true;
  }

  addNodeAnimationChannel(name, channel, interp) {

      if (nodeAnimationChannels[name] == null) {
        nodeAnimationChannels[name] = [];
      }

      nodeAnimationChannels[name].add(interp);
    }

  createAnimations() {
    animations.clear(); // Let's reuse this array to store the animations
    this.nodeAnimationChannels.forEach((name, nodeAnimationChannels) {
      var i, len = nodeAnimationChannels.length;
      //console.log(" animation channels for node " + name);
      //for (i = 0; i < len; i++) {
      //	console.log(nodeAnimationChannels[i]);
      //}
        var anim = new GLTFAnimation(nodeAnimationChannels);
        anim.name = "animation_" + name;
        animations.add(anim);
    });
  }

  buildAnimation(Animation animation) {

    var interps = [];
    animation.channels.forEach((channel) {
      var sampler = animation.samplers[channel["sampler"]];
      if (sampler != null) {

        var input = animation.parameters[sampler["input"]];
        if (input != null && input.data != null) {

          var output = animation.parameters[sampler["output"]];
          if (output != null && output.data != null) {

            var target = channel["target"];
            var node = resources.getEntry(target["id"]);
            if (node != null) {

              var path = target["path"];

              if (path == "rotation") {
                convertAxisAngleToQuaternion(output.data, output.count);
              }

              var interp = new GLTFInterpolator(node.object,
                  keys : input.data,
                  values : output.data,
                  count : input.count,
                  path : path,
                  type : sampler["interpolation"]
              );

              addNodeAnimationChannel(target["id"], channel, interp);
              interps.add(interp);
            }
          }
        }
      }
    });
  }

  handleAnimation(entryID, description, userInfo) {

    animationsRequested++;
    var animation = new Animation();
    animation.name = entryID;
    animation.onload = () {
      // self.buildAnimation(animation);
      animationsLoaded++;
      animations.add(animation);
      checkComplete();
    };

    animation.channels = description["channels"];
    animation.samplers = description["samplers"];
    resources.setEntry(entryID, animation, description);
    var parameters = description["parameters"];
    if (parameters == null) {
        //FIXME: not implemented in delegate
        log("MISSING_PARAMETERS for animation:"+ entryID);
        return false;
    }

      // Load parameter buffers
      parameters.forEach( (parameterKey, parameter) {

        animation.totalParameters++;
          var resource = resources.getEntry(parameter);
          var accessor = resource.object;
          var bufferView = resources.getEntry(accessor["bufferView"]);
          var paramObject = new GLTFLoaderUtils.WrappedBufferView(
              bufferView : bufferView,
              byteOffset : accessor["byteOffset"],
              count : accessor["count"],
              type : accessor["type"],
              id : accessor["bufferView"],
              name : parameterKey
          );

          var paramContext = new AnimationParameterContext(paramObject, animation);

          var alreadyProcessedAttribute = GLTFLoaderUtils.getBuffer(paramObject, animationParameterDelegate, paramContext);
          /*if(alreadyProcessedAttribute) {
              vertexAttributeDelegate.resourceAvailable(alreadyProcessedAttribute, attribContext);
          }*/
      });

    return true;
  }

  handleAccessor(entryID, description, userInfo) {
    // Save attribute entry
    resources.setEntry(entryID, description, description);
    return true;
  }

  handleSkin(entryID, Map description, userInfo) {
    // Save skin entry

    var skin = {
    };

    var m = description["bindShapeMatrix"].map((e) => e.toDouble()).toList();
    skin["bindShapeMatrix"] = new Matrix4(
        m[0],  m[4],  m[8],  m[12],
        m[1],  m[5],  m[9],  m[13],
        m[2],  m[6],  m[10], m[14],
        m[3],  m[7],  m[11], m[15]
    );

    skin["jointsIds"] = description["joints"];
    var inverseBindMatricesDescription = description["inverseBindMatrices"];
    skin["inverseBindMatricesDescription"] = inverseBindMatricesDescription;
    skin["inverseBindMatricesDescription"]["id"] = "${entryID}_inverseBindMatrices";

    var bufferEntry = this.resources.getEntry(inverseBindMatricesDescription["bufferView"]);

    var paramObject = new GLTFLoaderUtils.WrappedBufferView(
        bufferView : bufferEntry,
        byteOffset : inverseBindMatricesDescription["byteOffset"],
        count : inverseBindMatricesDescription["count"],
        type : inverseBindMatricesDescription["type"],
        id : inverseBindMatricesDescription["bufferView"],
        name : skin["inverseBindMatricesDescription"]["id"]
    );

    var context = new InverseBindMatricesContext(paramObject, skin);

    var alreadyProcessedAttribute = GLTFLoaderUtils.getBuffer(paramObject, inverseBindMatricesDelegate, context);

    var bufferView = resources.getEntry(skin["inverseBindMatricesDescription"]["bufferView"]);
    skin["inverseBindMatricesDescription"]["bufferView"] = bufferView.object;
    resources.setEntry(entryID, skin, description);

    return true;
  }

  handleSampler(entryID, description, userInfo) {
    // Save attribute entry
    resources.setEntry(entryID, description, description);
    return true;
  }

  handleTexture(entryID, description, userInfo) {
    // Save attribute entry
    resources.setEntry(entryID, null, description);
    return true;
  }

  handleError(msg) {
    throw new Exception(msg);
    return true;
  }

  var delegate =  new LoadDelegate(); // writable: true

  checkComplete() {
    if (meshesLoaded == meshesRequested
    && shadersLoaded == shadersRequested
    && animationsLoaded == animationsRequested)
    {

      pendingMeshes.forEach((pending) {
        (pending["mesh"] as Mesh).attachToNode(pending["node"], createShaderMaterial);
      });

      for (var i = 0; i < animationsLoaded; i++) {
        var animation = animations[i];
        buildAnimation(animation);
      }

      createAnimations();
      createMeshAnimations(rootObj);

      // Return the result
      completer.complete(new GLTFLoaderResult()
                  ..scene = rootObj
                  ..cameras = cameras
                  ..animations = animations);

    }
  }
}


class Context {
  var rootObj, callback;
  Context(this.rootObj, this.callback);
}

class ClassicGeometry {

  THREE.Geometry geometry;
  int totalAttributes = 0;
  int loadedAttributes = 0;
  bool indicesLoaded = false;
  bool finished = false;
  bool useBufferGeometry;

  var onload = null;

  var uvs = null;
  var indexArray = null;

  ClassicGeometry(this.useBufferGeometry) {

    if (useBufferGeometry) {
      geometry = new THREE.BufferGeometry();
    } else {
      geometry = new THREE.Geometry();
    }

  }

  buildArrayGeometry() {

    // Build indexed mesh
    var normals = geometry.normals;
    var a, b, c;
    var i, l;
    var faceNormals = null;
    var faceTexcoords = null;

    var length = indexArray.length;
    for (i = 0; i < length; i += 3) {
      a = indexArray[i];
      b = indexArray[i + 1];
      c = indexArray[i + 2];
      if (normals.isNotEmpty) {
        faceNormals = [normals[a], normals[b], normals[c]];
      }
      geometry.faces.add(new THREE.Face3(a, b, c, faceNormals, null, null));
      if (uvs != null) {
        geometry.faceVertexUvs[0].add([uvs[a], uvs[b], uvs[c] ]);
      }
    }

    // Allow Three.js to calculate some values for us
    geometry.computeBoundingBox();
    geometry.computeBoundingSphere();
    geometry.computeFaceNormals();
    if (normals.isEmpty) {
      geometry.computeVertexNormals();
    }

  }

  buildBufferGeometry() {
    // Build indexed mesh

    (geometry as THREE.BufferGeometry).attributes[THREE.GeometryAttribute.INDEX] =
        new THREE.GeometryAttribute.uint16(indexArray.length)..array = indexArray;


    var offset = new THREE.Chunk(
        start: 0, index: 0, count: this.indexArray.length
    );

    (geometry as THREE.BufferGeometry).offsets.add(offset);

    geometry.computeBoundingSphere();
  }

  checkFinished() {
    if (indexArray != null && loadedAttributes == totalAttributes) {

      if (useBufferGeometry) {
        buildBufferGeometry();
      } else {
        buildArrayGeometry();
      }

      finished = true;

      if (onload != null) {
        onload();
      }
    }
  }
}

abstract class Delegate {
  handleError(error, info);
  convert(what, ctx);
  resourceAvailable(res, ctx);
}

// Delegate for processing index buffers
class IndicesDelegate implements Delegate {

  handleError(errorCode, info) {
    // FIXME: report error
    log("ERROR(IndicesDelegate): $errorCode : $info");
  }

  convert(ByteBuffer resource, IndicesContext ctx) {
    return new Uint16List.view(resource, 0, ctx.indices.count);
  }

  resourceAvailable(glResource, ctx) {
    var geometry = ctx.geometry;
    geometry.indexArray = glResource;
    geometry.checkFinished();
    return true;
  }
}


class IndicesContext {
  var indices, geometry;
  IndicesContext(this.indices, this.geometry);
}

// Delegate for processing vertex attribute buffers
class VertexAttributeDelegate implements Delegate {

  handleError(errorCode, info) {
    // FIXME: report error
    log("ERROR(VertexAttributeDelegate):" + errorCode + ":" + info);
  }

  convert(resource, ctx) {
    return resource;
  }

  arrayResourceAvailable(ByteBuffer glResource, ctx) {
    var geom = ctx.geometry;
    var attribute = ctx.attribute;
    var semantic = ctx.semantic;
    var floatArray;
    var i, l;
    //FIXME: Float32 is assumed here, but should be checked.

    if (semantic == "POSITION") {
      // TODO: Should be easy to take strides into account here
      floatArray = new Float32List.view(glResource, 0, attribute.count * componentsPerElementForGLType(attribute.type));
      l = floatArray.length;
      for (i = 0; i < l; i += 3) {
        geom.geometry.vertices.add(new Vector3(floatArray[i], floatArray[i + 1], floatArray[i + 2]));
      }
    } else if (semantic == "NORMAL") {
      geom.geometry.normals = [];
      floatArray = new Float32List.view(glResource, 0, attribute.count * componentsPerElementForGLType(attribute.type));
      l = floatArray.length;
      for (i = 0; i < l; i += 3) {
        geom.geometry.normals.add(new Vector3(floatArray[i], floatArray[i + 1], floatArray[i + 2]));
      }
    } else if ((semantic == "TEXCOORD_0") || (semantic == "TEXCOORD" )) {
      geom.uvs = [];
      floatArray = new Float32List.view(glResource, 0, attribute.count * componentsPerElementForGLType(attribute.type));
      l = floatArray.length;
      for (i = 0; i < l; i += 2) {
        geom.uvs.add(new THREE.UV(floatArray[i], 1.0 - floatArray[i + 1]));
      }
    } else if (semantic == "WEIGHT") {
      var nComponents = componentsPerElementForGLType(attribute.type);
      floatArray = new Float32List.view(glResource, 0, attribute.count * nComponents);
      l = floatArray.length;
      for (i = 0; i < l; i += 4) {
        geom.geometry.skinWeights.add(new Vector4(floatArray[i], floatArray[i + 1], floatArray[i + 2], floatArray[i + 3]));
      }
    } else if (semantic == "JOINT") {
      var nComponents = componentsPerElementForGLType(attribute.type);
      floatArray = new Float32List.view(glResource, 0, attribute.count * nComponents);
      l = floatArray.length;
      for (i = 0; i < l; i += 4) {
        geom.geometry.skinIndices.add(new Vector4(floatArray[i], floatArray[i + 1], floatArray[i + 2], floatArray[i + 3]));
      }
    }
  }

  bufferResourceAvailable(glResource, ctx) {
    ClassicGeometry geom = ctx.geometry;
    THREE.BufferGeometry geometry = geom.geometry;
    var attribute = ctx.attribute;
    var semantic = ctx.semantic;
    var floatArray;
    var i, l;
    var nComponents;
    //FIXME: Float32 is assumed here, but should be checked.

    if (semantic == "POSITION") {
      // TODO: Should be easy to take strides into account here
      floatArray = new Float32List.view(glResource, 0, attribute.count * componentsPerElementForGLType(attribute.type));
      geometry.attributes[THREE.GeometryAttribute.POSITION] = new THREE.GeometryAttribute.float32(attribute.count, 3)..array = floatArray;
    } else if (semantic == "NORMAL") {
      floatArray = new Float32List.view(glResource, 0, attribute.count * componentsPerElementForGLType(attribute.type));
      geometry.attributes[THREE.GeometryAttribute.NORMAL] = new THREE.GeometryAttribute.float32(attribute.count, 3)..array = floatArray;
    } else if ((semantic == "TEXCOORD_0") || (semantic == "TEXCOORD" )) {

      nComponents = componentsPerElementForGLType(attribute.type);
      floatArray = new Float32List.view(glResource, 0, attribute.count * nComponents);
      // N.B.: flip Y value... should we just set texture.flipY everywhere?
      for (i = 0; i < floatArray.length / 2; i++) {
        floatArray[i * 2 + 1] = 1.0 - floatArray[i * 2 + 1];
      }
      geometry.attributes[THREE.GeometryAttribute.UV] = new THREE.GeometryAttribute.float32(attribute.count, nComponents)..array = floatArray;
    } else if (semantic == "WEIGHT") {
      nComponents = componentsPerElementForGLType(attribute.type);
      floatArray = new Float32List.view(glResource, 0, attribute.count * nComponents);
      geometry.attributes["skinIndex"] = new THREE.GeometryAttribute.float32(attribute.count, nComponents)..array = floatArray;
    } else if (semantic == "JOINT") {
      nComponents = componentsPerElementForGLType(attribute.type);
      floatArray = new Float32List.view(glResource, 0, attribute.count * nComponents);
      geometry.attributes["skinIndex"] = new THREE.GeometryAttribute.float32(attribute.count, nComponents)..array = floatArray;
    }
  }

  resourceAvailable(glResource, ctx) {
    if (GLTFLoader.useBufferGeometry) {
      bufferResourceAvailable(glResource, ctx);
    } else {
      arrayResourceAvailable(glResource, ctx);
    }

    var geom = ctx.geometry;
    geom.loadedAttributes++;
    geom.checkFinished();
    return true;
  }
}

class VertexAttributeContext {
  var attribute, semantic, geometry;
  VertexAttributeContext(this.attribute, this.semantic, this.geometry);
}

class Mesh {
  var primitives = [];
  var materialsPending = [];
  int loadedGeometry = 0;
  var onCompleteCallbacks = [];

  addPrimitive(geometry, material) {
      geometry.onload = () {
          loadedGeometry++;
          checkComplete();
      };

      primitives.add({
          "geometry": geometry,
          "material": material,
          "mesh": null
      });
  }

 onComplete(callback) {
      onCompleteCallbacks.add(callback);
      checkComplete();
  }

 checkComplete() {
      if(onCompleteCallbacks.isNotEmpty && primitives.length == loadedGeometry) {
          onCompleteCallbacks.forEach((callback) {
              callback(this);
          });
          onCompleteCallbacks = [];
      }
  }

  attachToNode(threeNode, createShaderMaterial) {
    // Assumes that the geometry is complete
    primitives.forEach((primitive) {
        /*if(!primitive.mesh) {
            primitive.mesh = new THREE.Mesh(primitive.geometry, primitive.material);
        }*/
      var material = primitive["material"];
      if (!(material is THREE.Material)) {
        material = createShaderMaterial(material);
      }

      var threeMesh = new THREE.Mesh(primitive["geometry"].geometry, material);
        threeMesh.castShadow = true;
        threeNode.add(threeMesh);
    });
  }
}

// Delayed-loaded material
class Material {
  var params;
  Material(this.params);
}

// Delegate for processing animation parameter buffers
class AnimationParameterDelegate implements Delegate {

  handleError(errorCode, info) {
      // FIXME: report error
      log("ERROR(AnimationParameterDelegate):"+errorCode+":"+info);
  }

  convert(resource, ctx) {
    var parameter = ctx.parameter;

    var glResource = null;
    switch (parameter.type) {
        case gl.FLOAT :
        case gl.FLOAT_VEC2 :
        case gl.FLOAT_VEC3 :
        case gl.FLOAT_VEC4 :
          glResource = new Float32List.view(resource, 0, parameter.count * componentsPerElementForGLType(parameter.type));
          break;
        default:
          break;
    }

      return glResource;
  }

  resourceAvailable(glResource, AnimationParameterContext ctx) {
    var animation = ctx.animation;
    var parameter = ctx.parameter;
    parameter.data = glResource;
    animation.handleParameterLoaded(parameter);
    return true;
  }
}


class AnimationParameterContext {
    var parameter;
    Animation animation;
    AnimationParameterContext(this.parameter, this.animation);
  }

// Animations
class Animation {
  var name, channels, samplers;
  // create Three.js keyframe here
  int totalParameters = 0;
  int loadedParameters = 0;
  var parameters = {};
  bool finishedLoading = false;
  var onload = null;

  Animation();

  handleParameterLoaded(parameter) {
  	parameters[parameter.name] = parameter;
  	loadedParameters++;
  	checkFinished();
  }

  checkFinished() {
      if(loadedParameters == totalParameters) {
          // Build animation
          finishedLoading = true;

          if (onload != null) {
              onload();
          }
      }
  }
}

/// Delegate for processing inverse bind matrices buffer
class InverseBindMatricesDelegate implements Delegate {

    handleError(errorCode, info) {
        // FIXME: report error
        log("ERROR(InverseBindMatricesDelegate):"+errorCode+":"+info);
    }

    convert(resource, InverseBindMatricesContext ctx) {
    	var parameter = ctx.param;

    	var glResource = null;
    	switch (parameter.type) {
	        case gl.FLOAT_MAT4 :
	        	glResource = new Float32List.view(resource, 0, parameter.count * componentsPerElementForGLType(parameter.type));
	        	break;
	        default:
	        	break;
    	}

        return glResource;
    }

    resourceAvailable(glResource, ctx) {
    	var skin = ctx.skin;
    	skin["inverseBindMatrices"] = glResource;
      return true;
    }
}


class InverseBindMatricesContext {
  var param, skin;
  InverseBindMatricesContext(this.param, this.skin);
}

/// Delegate for processing shaders from external files
class ShaderDelegate implements Delegate {

  GLTFLoader loader;

  ShaderDelegate(this.loader);

  handleError(errorCode, info) {
    // FIXME: report error
    log("ERROR(ShaderDelegate): $errorCode : $info");
  }

  convert(resource, ShaderContext ctx) {
   return resource;
  }

  resourceAvailable(data, ctx) {
    loader.shadersLoaded++;
    loader.shaders[ctx.id] = data;
    return true;
  }
}


class ShaderContext  {
  var id, path;
  ShaderContext(this.id, this.path);
}

/// Resource management
class ResourceEntry {

String entryID;
var object, buffer;
Map description;

ResourceEntry(this.entryID, this.object, this.description);
}

class Resources {
  Map<String, ResourceEntry> _entries = {};


  setEntry(entryID, object, description) {
    if (entryID == null) {
      log("No EntryID provided, cannot store " + description);
      return;
    }

    if (_entries[entryID] != null) {
      log("entry["+entryID+"] is being overwritten");
    }

    _entries[entryID] = new ResourceEntry(entryID, object, description );
  }

  ResourceEntry getEntry(entryID) => _entries[entryID];

  clearEntries() {
    _entries = {};
  }
}

class LoadDelegate {

  loadCompleted(callback, obj) {
    	callback(obj);
    }
  }