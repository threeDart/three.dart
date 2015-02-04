import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:three/extras/controls/orthographic_trackball_controls.dart';

Element container;

OrthographicCamera camera;
Scene scene;
WebGLRenderer renderer;

num windowHalfX;
num windowHalfY;

OrthographicTrackballControls controls;

void main() {
  init();
  animate(0);
}

void init() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  container = new Element.tag('div');
  document.body.nodes.add(container);

  Element info = new Element.tag('div');
  info.style.position = 'absolute';
  info.style.top = '10px';
  info.style.width = '100%';
  info.style.textAlign = 'center';
  info.innerHtml = '''
                    three.dart - misc controls orthographic trackball<br />
                    MOVE mouse &amp; press LEFT/A: rotate, MIDDLE/S: zoom, RIGHT/D: pan
                  ''';
  container.nodes.add(info);

  camera = new OrthographicCamera(-windowHalfX, windowHalfX, windowHalfY, -windowHalfY, -2000.0, 1000.0);
  camera.position.x = 200.0;
  camera.position.y = 100.0;
  camera.position.z = 200.0;

  controls = new OrthographicTrackballControls(camera);

  controls.rotateSpeed = 1.0;
  controls.zoomSpeed = 1.2;
  controls.panSpeed = 0.8;

  controls.noZoom = false;
  controls.noPan = false;

  controls.staticMoving = true;
  controls.dynamicDampingFactor = 0.3;

  controls.keys = [65, 83, 68];

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

  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.left = -windowHalfX;
  camera.right = windowHalfX;
  camera.top = windowHalfY;
  camera.bottom = -windowHalfY;

  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);

  controls.handleResize();

}


animate(num time) {
  window.requestAnimationFrame(animate);

  controls.update();

  render();
}

void render() {
  renderer.render(scene, camera);
}
