import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:three/extras/scene_utils.dart' as SceneUtils;

DivElement container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

DirectionalLight light;

int mouseX = 0, mouseY = 0;

int windowHalfX = window.innerWidth ~/ 2;
int windowHalfY = window.innerHeight ~/ 2;

void main() {
  init();
  animate(0);
}

void init() {
  container = new DivElement();
  document.body.append(container);
  
  camera = new PerspectiveCamera(20.0, window.innerWidth / window.innerHeight, 1.0, 10000.0)
    ..position.z = 1800.0;
  
  scene = new Scene();
  
  light = new DirectionalLight(0xffffff)
    ..position.setValues(0.0, 0.0, 1.0);
  scene.add(light);
  
  // shadow
  var canvas = new CanvasElement()
    ..width = 128
    ..height = 128;

  var context = canvas.context2D;
  var gradient = context.createRadialGradient(canvas.width / 2, canvas.height / 2, 0, canvas.width / 2, 
      canvas.height / 2, canvas.width / 2)
    ..addColorStop(0.1, "rgba(210, 210, 210, 1)")
    ..addColorStop(1, "rgba(255, 255, 255, 1)");

  context.fillStyle = gradient;
  context.fillRect(0, 0, canvas.width, canvas.height);

  var shadowTexture = new Texture(canvas)..needsUpdate = true;

  var shadowMaterial = new MeshBasicMaterial(map: shadowTexture);
  var shadowGeo = new PlaneGeometry(300.0, 300.0, 1, 1);

  scene.add(new Mesh(shadowGeo, shadowMaterial)
    ..position.y = -250.0
    ..rotation.x = -Math.PI / 2);

  scene.add(new Mesh(shadowGeo, shadowMaterial)
    ..position.y = -250.0
    ..position.x = -400.0
    ..rotation.x = -Math.PI / 2);

  scene.add(new Mesh(shadowGeo, shadowMaterial)
    ..position.y = -250.0
    ..position.x = 400.0
    ..rotation.x = - Math.PI / 2);

  var radius = 200.0;

  var geometry  = new IcosahedronGeometry(radius, 1),
      geometry2 = new IcosahedronGeometry(radius, 1),
      geometry3 = new IcosahedronGeometry(radius, 1);

  for (var i = 0; i < geometry.faces.length; i++) {
    var f  = geometry.faces[i];
    var f2 = geometry2.faces[i];
    var f3 = geometry3.faces[i];

    for (var j = 0; j < 3; j++) {
      var vertexIndex = f.indices[j];

      var p = geometry.vertices[vertexIndex];

      f.vertexColors.add(new Color()..setHSL((p.y / radius + 1) / 2, 1.0, 0.5));
      f2.vertexColors.add(new Color()..setHSL(0.0, (p.y / radius + 1) / 2, 0.5));
      f3.vertexColors.add(new Color()..setHSL(0.125 * vertexIndex / geometry.vertices.length, 1.0, 0.5));
    }
  }

  var materials = 
      [new MeshLambertMaterial(color: 0xffffff, shading: FlatShading, vertexColors: VertexColors),
       new MeshBasicMaterial(color: 0x000000, shading: FlatShading, wireframe: true, transparent: true)];

  scene.add(SceneUtils.createMultiMaterialObject(geometry, materials)
    ..position.x = -400.0
    ..rotation.x = -1.87);

  scene.add(SceneUtils.createMultiMaterialObject(geometry2, materials)
    ..position.x = 400.0
    ..rotation.x = 0.0);

  scene.add(SceneUtils.createMultiMaterialObject(geometry3, materials)
    ..position.x = 0.0
    ..rotation.x = 0.0);
  
  renderer = new WebGLRenderer(antialias: true)
    ..setClearColorHex(0xffffff, 1)
    ..setSize(window.innerWidth, window.innerHeight);
  
  container.append(renderer.domElement);
  
  document.onMouseMove.listen(onDocumentMouseMove);
  window.onResize.listen(onWindowResize);
}

void onDocumentMouseMove(MouseEvent e) {
  mouseX = e.client.x - windowHalfX;
  mouseY = e.client.y - windowHalfY;
}

void onWindowResize(Event e) {
  windowHalfX = window.innerWidth ~/ 2;
  windowHalfY = window.innerHeight ~/ 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

void render() {
  camera.position.x += (mouseX - camera.position.x) * 0.05;
  camera.position.y += (-mouseY - camera.position.y) * 0.05;

  camera.lookAt(scene.position);

  renderer.render(scene, camera);
}