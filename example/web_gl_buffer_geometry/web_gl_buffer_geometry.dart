import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';

const TRIANGLES = 500;

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

Mesh mesh;

void main() {
  init();
  animate(0);
}

void init() {

  container = document.querySelector( '#container' );

  camera = new PerspectiveCamera( 20.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 )
  ..position.z = 1800.0;

  scene = new Scene();

  var geometry = new BufferGeometry()
  ..aIndex = new GeometryAttribute.int16( TRIANGLES * 3 * 3)
  ..aPosition =  new GeometryAttribute.float32(TRIANGLES * 3 * 3, 3);

  var indices = geometry.aIndex.array;
  var i = 0;
  indices.forEach((_) { indices[ i ] = i++; });

  var rnd = new Math.Random();
  var positions = geometry.aPosition.array;

  for ( var i = 0; i < positions.length; i += 9 ) {

    var x = rnd.nextDouble() * 400 - 200;
    var y = rnd.nextDouble() * 400 - 200;
    var z = rnd.nextDouble() * 400 - 200;

    positions[ i ] = x + rnd.nextDouble() * 40 - 20;
    positions[ i + 1 ] = y + rnd.nextDouble() * 40 - 20;
    positions[ i + 2 ] = z + rnd.nextDouble() * 40 - 20;

    positions[ i + 3 ] = x + rnd.nextDouble() * 40 - 20;
    positions[ i + 4 ] = y + rnd.nextDouble() * 40 - 20;
    positions[ i + 5 ] = z + rnd.nextDouble() * 40 - 20;

    positions[ i + 6 ] = x + rnd.nextDouble() * 40 - 20;
    positions[ i + 7 ] = y + rnd.nextDouble() * 40 - 20;
    positions[ i + 8 ] = z + rnd.nextDouble() * 40 - 20;

  }

  geometry.offsets = [new Chunk(
    start: 0,
    count: TRIANGLES * 3,
    index: 0
  )];

  geometry.computeBoundingSphere();
  geometry.computeVertexNormals();

  var material = new MeshLambertMaterial( color: 0x000000, side: DoubleSide );

  mesh = new Mesh( geometry, material );
  scene.add( mesh );

  renderer = new WebGLRenderer( antialias: true )
  ..setSize( window.innerWidth, window.innerHeight );

  container.children.add( renderer.domElement );


  window.onResize.listen( onWindowResize );
}

onWindowResize(event) {
  camera
  ..aspect = window.innerWidth / window.innerHeight
  ..updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

render() {

  mesh.rotation
  ..x += 0.01
  ..y += 0.02;

  renderer.render( scene, camera );

}