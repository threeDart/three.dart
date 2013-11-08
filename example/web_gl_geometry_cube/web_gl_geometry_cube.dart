import 'dart:html';
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils; // TODO - Use Re-export

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

Mesh cube;

void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');

  document.body.nodes.add( container );

  scene = new Scene();

  camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0 );
  camera.position.z = 400.0;

  scene.add(camera);

  var geometry = new CubeGeometry( 200.0, 200.0, 200.0 );
  var material = new MeshBasicMaterial( map: ImageUtils.loadTexture( 'textures/crate.gif' ));

  cube = new Mesh( geometry, material);
  scene.add( cube );

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);
}

onWindowResize(e) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

animate(num time) {

  window.requestAnimationFrame( animate );

  cube.rotation.x += 0.005;
  cube.rotation.y += 0.01;

  renderer.render( scene, camera );

}
