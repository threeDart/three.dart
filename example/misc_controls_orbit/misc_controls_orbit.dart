import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:three/extras/controls/orbit_controls.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

OrbitControls controls;

void main() {
  init();
  animate(0);
}

void init() {
  container = new Element.tag('div');
  document.body.nodes.add(container);

  Element info = new Element.tag('div');
  info.style.position = 'absolute';
  info.style.top = '10px';
  info.style.width = '100%';
  info.style.textAlign = 'center';
  info.innerHtml = 'three.dart - misc controls orbit';
  container.nodes.add(info);

  camera = new PerspectiveCamera(60.0, window.innerWidth / window.innerHeight, 1.0, 1000.0);
  camera.position.z = 500.0;

  controls = new OrbitControls(camera);
  controls.addEventListener('change', (_) => render());

  scene = new Scene();
  scene.fog = new FogExp2(0xcccccc, 0.002);

  var geometry;
  var material;
  var light;

  // Pyramids

  geometry = new CylinderGeometry(0.0, 10.0, 30.0, 4, 1);
  material = new MeshLambertMaterial(color: 0xffffff, shading: FlatShading);

  var rnd = new Math.Random();

  for (var i = 0; i < 500; i++) {

    var mesh = new Mesh(geometry, material);
    mesh.position.x = (rnd.nextDouble() - 0.5) * 1000;
    mesh.position.y = (rnd.nextDouble() - 0.5) * 1000;
    mesh.position.z = (rnd.nextDouble() - 0.5) * 1000;
    mesh.updateMatrix();
    mesh.matrixAutoUpdate = false;
    scene.add(mesh);

  }

  // Lights

  light = new DirectionalLight(0xffffff);
  light.position.x = 1.0;
  light.position.y = 1.0;
  light.position.z = 1.0;
  scene.add(light);

  light = new DirectionalLight(0x002288);
  light.position.x = -1.0;
  light.position.y = -1.0;
  light.position.z = -1.0;
  scene.add(light);

  light = new AmbientLight(0x222222);
  scene.add(light);

  // Renderer

  renderer = new WebGLRenderer(antialias: false);
  renderer.setClearColor(scene.fog.color, 1);
  renderer.setSize(window.innerWidth, window.innerHeight);

  container.nodes.add(renderer.domElement);

  window.onResize.listen(onWindowResize);
}

onWindowResize(e) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);

}


animate(num time) {
  window.requestAnimationFrame(animate);

  controls.update();

  render();
}

void render() {
  renderer.render(scene, camera);
}
