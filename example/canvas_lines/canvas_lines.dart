import 'dart:html';
import 'dart:math' as Math;

import 'package:three/three.dart';
import 'package:three/extras/renderers/canvas_renderer.dart';

Element container;
PerspectiveCamera camera;
Scene scene;
CanvasRenderer renderer;
Material material;
Geometry geometry;

int mouseX = 0, mouseY = 0;
int windowHalfX = 0;
int windowHalfY = 0;

init() {
  Particle particle;
  windowHalfX = window.innerWidth ~/ 2;
  windowHalfY = window.innerHeight ~/ 2;

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 75.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.z = 100.0;

  scene = new Scene();
  scene.add( camera );

  var options;

  renderer = new CanvasRenderer(options);
  renderer.setSize( window.innerWidth, window.innerHeight );
  container.nodes.add( renderer.domElement );

  //TODO: context.arc() "anticlockwise" has to = false in Chrome on Win7 in order to render particles.
  // Not sure why yet... Need to know whether this messes things up on a Mac.

  // particles
  final num Tau = Math.PI * 2;
  material = new ParticleCanvasMaterial(
    color: 0xffffff,
    program: (CanvasRenderingContext2D context ) {
      context.beginPath();
      context.arc( 0, 0, 1, 0, Tau, false );
      context.closePath();
      context.fill();
    }
  );

  geometry = new Geometry();

  var rnd = new Math.Random();
  for ( int i = 0; i < 100; i ++ ) {
    particle = new Particle( material );
    particle.position.x = rnd.nextDouble() * 2.0 - 1.0;
    particle.position.y = rnd.nextDouble() * 2.0 - 1.0;
    particle.position.z = rnd.nextDouble() * 2.0 - 1.0;
    particle.position.normalize();
    particle.position.scale( rnd.nextDouble() * 10.0 + 450.0 );
    particle.scale.x = 5.0;
    particle.scale.y = 5.0;
    scene.add( particle );

    geometry.vertices.add( particle.position );
  }

  // lines

  var line = new Line( geometry, new LineBasicMaterial( color: 0xffffff, opacity: 0.5 ) );
  scene.add( line );

  document.onMouseMove.listen(onDocumentMouseMove);
  document.onTouchStart.listen(onDocumentTouchStart);
  document.onTouchMove.listen(onDocumentTouchMove);

}

onDocumentMouseMove(MouseEvent event) {
  mouseX = event.client.x - windowHalfX;
  mouseY = event.client.y - windowHalfY;
}

onDocumentTouchStart(TouchEvent event) {
  if ( event.touches.length > 1 ) {

    event.preventDefault();

    mouseX = event.touches[ 0 ].page.x - windowHalfX;
    mouseY = event.touches[ 0 ].page.y - windowHalfY;
  }
}

onDocumentTouchMove(TouchEvent event) {
  if ( event.touches.length == 1 ) {

    event.preventDefault();

    mouseX = event.touches[ 0 ].page.x - windowHalfX;
    mouseY = event.touches[ 0 ].page.y - windowHalfY;
  }
}

void animate(num time) {
  window.requestAnimationFrame(animate);

  render();
}

render() {
  camera.position.x += ( mouseX - camera.position.x ) * .05;
  camera.position.y += ( - mouseY + 200.0 - camera.position.y ) * .05;
  camera.lookAt( scene.position );

  renderer.render( scene, camera );
}

void main() {
  init();
  animate(0);
}