import 'dart:html';
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;
import 'package:vector_math/vector_math.dart';

DivElement container;

WebGLRenderer renderer;
PerspectiveCamera camera;
Scene scene;

void main() {
  init();
  animate(0);
}

void init() {
  container = new DivElement();
  document.body.append(container);
  
  camera = new PerspectiveCamera(70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0)
    ..position.z = 600.0;
  
  scene = new Scene();
 
  // BACKGROUND
  
  var x = new CanvasElement()
    ..width = 128
    ..height = 128;
  
  x.context2D
    ..fillStyle = "#ddd"
    ..fillRect(0, 0, 128, 128)
    ..fillStyle = "#555"
    ..fillRect(0, 0, 64, 64)
    ..fillStyle = "#999"
    ..fillRect(32, 32, 32, 32)
    ..fillStyle = "#555"
    ..fillRect(64, 64, 64, 64)
    ..fillStyle = "#777"
    ..fillRect(96, 96, 32, 32);

  var mapBg = new Texture(x);
  mapBg.wrapS = mapBg.wrapT = RepeatWrapping;
  mapBg.repeat.setValues(128.0, 64.0);
  mapBg.needsUpdate = true;

  var materialBg = new MeshBasicMaterial(map: mapBg);

  var meshBg = new Mesh(new PlaneGeometry(4000.0, 2000.0), materialBg);
  meshBg.position = new Vector3(0.0, 0.0, -1.0);
  scene.add(meshBg);

  // OBJECTS

  var blendings = 
      [NoBlending, NormalBlending, AdditiveBlending, 
       SubtractiveBlending, MultiplyBlending]; // AdditiveAlphaBlending];
  
  var blendingNames = ["No", "Normal", "Additive", "Subtractive", "Multiply"];

  var map0 = ImageUtils.loadTexture('textures/UV_Grid_Sm.jpg');
  var map1 = ImageUtils.loadTexture('textures/sprite0.jpg');
  var map2 = ImageUtils.loadTexture('textures/sprite0.png');
  var map3 = ImageUtils.loadTexture('textures/lensflare0.png');
  var map4 = ImageUtils.loadTexture('textures/lensflare0_alpha.png');

  var geo1 = new PlaneGeometry(100.0, 100.0);
  var geo2 = new PlaneGeometry(100.0, 25.0);
  
  addImageRow(map, y) {
    for (var i = 0; i < blendings.length; i++) {
      var material = new MeshBasicMaterial(map: map)
        ..transparent = true
        ..blending = blendings[i];

      var x = (i - blendings.length / 2) * 110;
      var z = 0.0;

      scene.add(new Mesh(geo1, material)
        ..position.setValues(x, y, z));

      scene.add(new Mesh(geo2, generateLabelMaterial(blendingNames[i]))
        ..position.setValues(x, y - 75, z));
    }
  }

  addImageRow(map0, 300.0);
  addImageRow(map1, 150.0);
  addImageRow(map2, 0.0);
  addImageRow(map3, -150.0);
  addImageRow(map4, -300.0);
  
  renderer = new WebGLRenderer()
    ..setSize(window.innerWidth, window.innerHeight);
  
  container.append(renderer.domElement);

  window.onResize.listen(onWindowResize);
}

void onWindowResize(Event e) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

generateLabelMaterial(String text) {
  var x = new CanvasElement()
    ..width = 128
    ..height = 32;
  
  x.context2D
    ..fillStyle = "rgba(0, 0, 0, 0.95)"
    ..fillRect(0, 0, 128, 32)
  
    ..fillStyle = "white"
    ..font = "12pt arial bold"
    ..fillText(text, 10, 22);

  var map = new Texture(x)..needsUpdate = true;
  
  return new MeshBasicMaterial(map: map, transparent: true);
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

void render() {
  renderer.render(scene, camera);
}