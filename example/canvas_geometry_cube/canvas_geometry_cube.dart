import 'dart:html';
import 'dart:math' as Math;

import 'package:three/three.dart';
import 'package:three/extras/renderers/canvas_renderer.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
CanvasRenderer renderer;

Mesh cube;
Mesh plane;

num targetRotation;
num targetRotationOnMouseDown;

num mouseX;
num mouseXOnMouseDown;

num windowHalfX;
num windowHalfY;

var evtSubscriptions = [];

void main() {
  init();
  animate(0);
}

void init() {
  targetRotation = 0;
  targetRotationOnMouseDown = 0;

  mouseX = 0;
  mouseXOnMouseDown = 0;

  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  container = new Element.tag('div');
  //document.body.appendChild( container );
  document.body.nodes.add( container );

  Element info = new Element.tag('div');
  info.style.position = 'absolute';
  info.style.top = '10px';
  info.style.width = '100%';
  info.style.textAlign = 'center';
  info.innerHtml = 'Drag to spin the cube';
  //container.appendChild( info );
  container.nodes.add( info );

  scene = new Scene();

  camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0 );
  camera.position.y = 150.0;
  camera.position.z = 500.0;
  scene.add( camera );

  // Cube

  List materials = [];

  var rnd = new Math.Random();
  for ( int i = 0; i < 6; i ++ ) {
    materials.add( new MeshBasicMaterial( color: rnd.nextDouble() * 0xffffff ) );
  }

  cube = new Mesh( new CubeGeometry( 200.0, 200.0, 200.0, 1, 1, 1, materials ), new MeshFaceMaterial(materials));// { 'overdraw' : true }) );
  cube.position.y = 150.0;
  //cube.overdraw = true; //TODO where is this prop?
  scene.add( cube );

  // Plane

  plane = new Mesh( new PlaneGeometry( 200.0, 200.0 ), new MeshBasicMaterial( color: 0xe0e0e0, overdraw: true ) );
  plane.rotation.x = - 90.0 * ( Math.PI / 180.0 );
  //plane.overdraw = true; //TODO where is this prop?
  scene.add( plane );

  renderer = new CanvasRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );


  //container.appendChild( renderer.domElement );
  container.nodes.add( renderer.domElement );

  evtSubscriptions = [
    document.onMouseDown.listen(onDocumentMouseDown),
    document.onTouchStart.listen(onDocumentTouchStart),
    document.onTouchMove.listen(onDocumentTouchMove)
    ];

}

void onDocumentMouseDown( event ) {
  event.preventDefault();

  evtSubscriptions = [
    document.onMouseMove.listen(onDocumentMouseMove),
    document.onMouseUp.listen(onDocumentMouseUp),
    document.onMouseOut.listen(onDocumentMouseOut)
    ];

  mouseXOnMouseDown = event.client.x - windowHalfX;
  targetRotationOnMouseDown = targetRotation;

  print('onMouseDown mouseX = $mouseXOnMouseDown targRot = $targetRotationOnMouseDown');
}

void onDocumentMouseMove( event ) {
  mouseX = event.client.x - windowHalfX;

  targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.02;

  print('onMouseMove mouseX = $mouseX targRot = $targetRotation');
}

void cancelEvtSubscriptions() {
  evtSubscriptions.forEach((s) => s.cancel());
  evtSubscriptions = [];
}

void onDocumentMouseUp( event ){
  cancelEvtSubscriptions();
}

void onDocumentMouseOut( event ) {
  cancelEvtSubscriptions();
}

void onDocumentTouchStart( event ) {
  if ( event.touches.length == 1 ) {
    event.preventDefault();

    mouseXOnMouseDown = event.touches[ 0 ].page.x - windowHalfX;
    targetRotationOnMouseDown = targetRotation;
  }
}

void onDocumentTouchMove( event ) {
  if ( event.touches.length == 1 ) {
    event.preventDefault();

    mouseX = event.touches[ 0 ].page.x - windowHalfX;
    targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.05;
  }
}

animate(num time) {
  window.requestAnimationFrame(animate);

  render();
}

void render() {
  plane.rotation.z = cube.rotation.y += ( targetRotation - cube.rotation.y ) * 0.05;
  renderer.render( scene, camera );
}
