import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' hide Ray;
import 'package:three/three.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;
Projector projector;

double mouseX = 0.0, mouseY = 0.0;

Mesh INTERSECTED;
num currentHex;

void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');

  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0 );
  camera.position.setValues( 0.0, 300.0, 500.0 );

  scene = new Scene();
  scene.add(camera);

  var light;

  light = new DirectionalLight( 0xffffff, 2 );
  light.position.setValues( 1.0, 1.0, 1.0 ).normalize();
  scene.add( light );

  light = new DirectionalLight( 0xffffff );
  light.position.setValues( -1.0, -1.0, -1.0 ).normalize();
  scene.add( light );


  var geometry = new CubeGeometry( 20.0, 20.0, 20.0 );

  var rnd = new Math.Random();

  for ( var i = 0; i < 500; i ++ ) {

    var object = new Mesh( geometry, new MeshLambertMaterial( color: rnd.nextInt(0xffffff) ) );

    object.position.x = rnd.nextInt(800) - 400.0;
    object.position.y = rnd.nextInt(800) - 400.0;
    object.position.z = rnd.nextInt(800) - 400.0;

    object.rotation.x = ( rnd.nextDouble() * 360 ) * Math.PI / 180;
    object.rotation.y = ( rnd.nextDouble() * 360 ) * Math.PI / 180;
    object.rotation.z = ( rnd.nextDouble() * 360 ) * Math.PI / 180;

    object.scale.x = rnd.nextDouble() * 2 + 1;
    object.scale.y = rnd.nextDouble() * 2 + 1;
    object.scale.z = rnd.nextDouble() * 2 + 1;

    scene.add( object );

  }

  projector = new Projector();

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );

  document.onMouseMove.listen(onDocumentMouseMove);

  window.onResize.listen(onWindowResize);
}

onWindowResize(_) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

onDocumentMouseMove( event ) {

  event.preventDefault();

  mouseX = ( event.client.x / window.innerWidth ) * 2 - 1;
  mouseY = - ( event.client.y / window.innerHeight ) * 2 + 1;

}

animate(num time) {

  window.requestAnimationFrame( animate );

  render();

}

var radius = 100;
num theta = 0;

render() {

  theta += 0.2;

  camera.position.x = radius * Math.sin( theta * Math.PI / 360 );
  camera.position.y = radius * Math.sin( theta * Math.PI / 360 );
  camera.position.z = radius * Math.cos( theta * Math.PI / 360 );

  camera.lookAt( scene.position );

  // find intersections

  var vector = new Vector3( mouseX, mouseY, 1.0 );
  projector.unprojectVector( vector, camera );

  var ray = new Ray( camera.position, vector.sub( camera.position ).normalize() );

  var intersects = ray.intersectObjects( scene.children );

  if ( intersects.length > 0 ) {

    if ( INTERSECTED != intersects[ 0 ].object ) {

      if ( INTERSECTED != null ) (INTERSECTED.material as MeshLambertMaterial).emissive.setHex( currentHex );

      INTERSECTED = intersects[ 0 ].object;
      MeshLambertMaterial material = INTERSECTED.material;
      currentHex = material.emissive.getHex();
      material.emissive.setHex( 0xff0000 );

    }

  } else {

    if ( INTERSECTED != null ) (INTERSECTED.material as MeshLambertMaterial).emissive.setHex( currentHex );

    INTERSECTED = null;

  }

  renderer.render( scene, camera );

}