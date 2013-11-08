import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

var particleSystem;

var rnd = new Math.Random();

void main() {
  init();
  animate(0);
}

void init() {

  container = document.querySelector( '#container' );

  camera = new PerspectiveCamera( 27.0, window.innerWidth / window.innerHeight, 5.0, 3500.0 )
  ..position.z = 2750.0;

  scene = new Scene()
  ..fog = new FogLinear(0x050505, 2000.0, 3500.0);

  var particles =  500000;

  var positions = new GeometryAttribute.float32(particles * 3, 3);
  var colors     = new GeometryAttribute.float32(particles * 3, 3);

  var geometry = new BufferGeometry();
  geometry.attributes = {
     "position" : positions,
     "color"    : colors
  };

  var color = new Color();

  var n = 1000, n2 = n / 2; // particles spread in the cube

  for ( var i = 0; i < positions.array.length; i += 3 ) {

    // positions
    var x = rnd.nextDouble() * n - n2;
    var y = rnd.nextDouble() * n - n2;
    var z = rnd.nextDouble() * n - n2;

    positions.array[ i     ] = x;
    positions.array[ i + 1 ] = y;
    positions.array[ i + 2 ] = z;

    // colors
    var vx = ( x / n ) + 0.5;
    var vy = ( y / n ) + 0.5;
    var vz = ( z / n ) + 0.5;

    color.setRGB( vx, vy, vz );

    colors.array[ i ]     = color.r;
    colors.array[ i + 1 ] = color.g;
    colors.array[ i + 2 ] = color.b;
  }

  geometry.computeBoundingSphere();
  var material = new ParticleBasicMaterial( size: 15, vertexColors: 2 );

  particleSystem = new ParticleSystem( geometry, material );
  scene.add( particleSystem );

  renderer = new WebGLRenderer()
  ..setClearColor(scene.fog.color, 1)
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

  particleSystem.rotation.x += 0.0025;
  particleSystem.rotation.y += 0.005;

  renderer.render( scene, camera );

}