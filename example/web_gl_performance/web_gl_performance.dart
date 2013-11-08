import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

var windowHalfX, windowHalfY;
var mouseX = 0, mouseY = 0;

List objects = [];

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  document.onMouseMove.listen( onDocumentMouseMove );

  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 60.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.z = 3200.0;

  scene = new Scene();

  var material = new MeshNormalMaterial( shading: SmoothShading );

  var loader = new JSONLoader();
  loader.load( 'obj/Suzanne.js', ( geometry ) {

    geometry.computeVertexNormals();

    var rnd = new Math.Random();

    for ( int i = 0; i < 5000; i ++ ) {

      var mesh = new Mesh( geometry, material );

      mesh.position.x = rnd.nextDouble() * 8000 - 4000;
      mesh.position.y = rnd.nextDouble() * 8000 - 4000;
      mesh.position.z = rnd.nextDouble() * 8000 - 4000;
      mesh.rotation.x = rnd.nextDouble() * 360 * ( Math.PI / 180 );
      mesh.rotation.y = rnd.nextDouble() * 360 * ( Math.PI / 180 );
      mesh.scale.x = mesh.scale.y = mesh.scale.z = rnd.nextDouble() * 50 + 100;

      objects.add( mesh );

      scene.add( mesh );

    }

  } );

  renderer = new WebGLRenderer( clearColorHex: 0xffffff );
  renderer.setSize( window.innerWidth, window.innerHeight );
  container.children.add( renderer.domElement );

  window.onResize.listen( onWindowResize );
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

  camera.position.x += ( mouseX - camera.position.x ) * .05;
  camera.position.y += ( - mouseY - camera.position.y ) * .05;
  camera.lookAt( scene.position );

  for ( var i = 0, il = objects.length; i < il; i ++ ) {

    objects[ i ].rotation.x += 0.01;
    objects[ i ].rotation.y += 0.02;

  }


  renderer.render( scene, camera );

}
