import 'dart:html';
import 'package:three/three.dart';

var container, stats;

var camera, cameraTarget, scene, renderer;

var mouseX = 0,
    mouseY = 0;
var windowHalfX = window.innerWidth / 2;
var windowHalfY = window.innerHeight / 2;

main() {
  init();
  animate(0);
}

init() {
  container = document.createElement('div');
  document.body.append(container);

  camera = new PerspectiveCamera(35.0, window.innerWidth / window.innerHeight, 1.0, 2000.0);
  camera.position.z = 100.0;

  // scene
  scene = new Scene();

  var ambient = new AmbientLight(0x101030);
  scene.add(ambient);

  var directionalLight = new DirectionalLight(0xffeedd);
  directionalLight.intensity = 1.0;
  directionalLight.position.setValues(0.0, 0.0, 1.0);
  scene.add(directionalLight);


  // model
  var loader = new OBJLoader();
  loader.load('obj/male02.obj').then((object) {
    object.position.y = -80.0;
    scene.add(object);
  });

  renderer = new WebGLRenderer(antialias: true, alpha: false);
  renderer.setSize(window.innerWidth, window.innerHeight);

  container.append(renderer.domElement);

  document.onMouseMove.listen(onDocumentMouseMove);
}

onDocumentMouseMove(MouseEvent event) {
  mouseX = (event.client.x - windowHalfX) / 2;
  mouseY = (event.client.y - windowHalfY) / 2;
}


animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

render() {
  camera.position.x += (mouseX - camera.position.x) * 0.05;
  camera.position.y += (-mouseY - camera.position.y) * 0.05;

  camera.lookAt(scene.position);

  renderer.render(scene, camera);
}
