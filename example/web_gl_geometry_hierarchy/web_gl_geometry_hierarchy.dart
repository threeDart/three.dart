import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

var windowHalfX, windowHalfY;
var mouseX = 0, mouseY = 0;

Object3D group;

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  document.onMouseMove.listen(onDocumentMouseMove);

  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 60.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.z = 500.0;

  scene = new Scene();
  scene.fog = new FogLinear( 0xffffff, 1.0, 10000.0 );
  scene.add(camera);

  var geometry = new CubeGeometry( 100.0, 100.0, 100.0 );
  var material = new MeshNormalMaterial();

  group = new Object3D();

  var rnd = new Math.Random();

  for ( var i = 0; i < 1000; i ++ ) {

    var mesh = new Mesh( geometry, material );
    mesh.position.x = rnd.nextInt(2000).toDouble() - 1000.0;
    mesh.position.y = rnd.nextInt(2000).toDouble() - 1000.0;
    mesh.position.z = rnd.nextInt(2000).toDouble() - 1000.0;

    mesh.rotation.x = rnd.nextDouble() * 360.0 * ( Math.PI / 180.0 );
    mesh.rotation.y = rnd.nextDouble() * 360.0 * ( Math.PI / 180.0 );

    mesh.matrixAutoUpdate = false;
    mesh.updateMatrix();

    group.add( mesh );

  }

  scene.add( group );

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  renderer.sortObjects = false;

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);
}

onWindowResize(event) {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

onDocumentMouseMove(MouseEvent event) {
  mouseX = ( event.client.x - windowHalfX ) * 10;
  mouseY = ( event.client.y - windowHalfY ) * 10;
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

render() {

  var time = new DateTime.now().millisecondsSinceEpoch * 0.001;

  var rx = Math.sin( time * 0.7 ) * 0.5,
      ry = Math.sin( time * 0.3 ) * 0.5,
      rz = Math.sin( time * 0.2 ) * 0.5;

  camera.position.x += ( mouseX - camera.position.x ) * .05;
  camera.position.y += ( - mouseY - camera.position.y ) * .05;

  camera.lookAt( scene.position );

  group.rotation.x = rx;
  group.rotation.y = ry;
  group.rotation.z = rz;

  renderer.render( scene, camera );

}