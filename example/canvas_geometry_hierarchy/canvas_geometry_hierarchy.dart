import 'dart:html';
import 'dart:math' as Math;

import 'package:three/three.dart';
import 'package:three/extras/renderers/canvas_renderer.dart';

Element container;// stats;

PerspectiveCamera camera;
Scene scene;
CanvasRenderer renderer;

CubeGeometry geometry;
Object3D group;

num mouseX = 0, mouseY = 0;

num windowHalfX;
num windowHalfY;

void main() {
  document.onMouseMove.listen( onDocumentMouseMove);

  init();
  animate(0);
}


void init() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  container = new Element.tag('div');
  document.body.nodes.add( container );

  scene = new Scene();

  camera = new PerspectiveCamera( 60.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.z = 500.0;

  scene.add( camera );

  List materials = [];

  var rnd = new Math.Random();
  for ( int i = 0; i < 6; i ++ ) {
    materials.add( new MeshBasicMaterial( color:  rnd.nextDouble() * 0xffffff ) );
  }

  geometry = new CubeGeometry( 100.0, 100.0, 100.0 );
  MeshNormalMaterial material = new MeshNormalMaterial();

  group = new Object3D();

  for ( var i = 0; i < 200; i ++ ) {
    Mesh mesh = new Mesh( geometry, material );
    //mesh.overdraw = true; //TODO: No such property?
    mesh.position.x = rnd.nextInt(2000).toDouble() - 1000.0;
    mesh.position.y = rnd.nextInt(2000).toDouble() - 1000.0;
    mesh.position.z = rnd.nextInt(2000).toDouble() - 1000.0;
    mesh.rotation.x = rnd.nextInt(360).toDouble() * ( Math.PI / 180.0 );
    mesh.rotation.y = rnd.nextInt(360).toDouble() * ( Math.PI / 180.0 );
    mesh.matrixAutoUpdate = false;
    mesh.updateMatrix();
    group.add( mesh );
  }

  scene.add( group );

  var options;

  renderer = new CanvasRenderer(options);
  renderer.setSize( window.innerWidth, window.innerHeight );
  renderer.sortObjects = false;
  //container.appendChild( renderer.domElement );
  container.nodes.add( renderer.domElement );

}

void onDocumentMouseMove(event) {
  mouseX = ( event.client.x - windowHalfX ) * 10;
  mouseY = ( event.client.y - windowHalfY ) * 10;
}

void animate(num time) {
  window.requestAnimationFrame(animate);

  render();
}

void render() {
  camera.position.x += ( mouseX - camera.position.x ) * .05;
  camera.position.y += ( - mouseY - camera.position.y ) * .05;
  camera.lookAt( scene.position );

  //TODO describe how this oscillation affects the example
  num t = new DateTime.now().millisecondsSinceEpoch;
  var oscillate = (num rate) => Math.sin(t * rate) * 0.5;
  group.rotation.x = oscillate( 0.0007 );
  group.rotation.y = oscillate( 0.0003 );
  group.rotation.z = oscillate( 0.0002 );

  renderer.render( scene, camera );
}
