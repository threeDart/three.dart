import 'dart:html';
import 'package:three/three.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;
Mesh mesh;
num windowHalfX = window.innerWidth / 2,
    windowHalfY = window.innerHeight / 2;
num mouseX = 0, mouseY = 0;

void main() {
  init();
  animate(0);
}

void init() {

  var idx = 0;
  querySelectorAll("input[type='range']").forEach((InputElement input) {
    var n = idx++;
    input.onChange.listen((_) => mesh.morphTargetInfluences[ n ] = input.valueAsNumber / 100 );
  });

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 45.0, window.innerWidth / window.innerHeight, 1.0, 15000.0 );
  camera.position.z = 500.0;

  scene = new Scene();

  var light = new PointLight( 0xff2200 );
  light.position.setValues( 100.0, 100.0, 100.0 );
  scene.add( light );

  scene.add( new AmbientLight( 0x111111 ) );

  var geometry = new CubeGeometry( 100.0, 100.0, 100.0 );
  var material = new MeshLambertMaterial( color: 0xffffff, morphTargets: true );

  // construct 8 blend shapes
  for ( var i = 0; i < geometry.vertices.length; i ++ ) {

    var vertices = [];

    for ( var v = 0; v < geometry.vertices.length; v ++ ) {

      vertices.add( geometry.vertices[ v ].clone() );

      if ( v == i ) {

        vertices[ vertices.length - 1 ].x *= 2;
        vertices[ vertices.length - 1 ].y *= 2;
        vertices[ vertices.length - 1 ].z *= 2;

      }

    }

    geometry.morphTargets.add( new MorphTarget( name: "target$i", vertices: vertices ));

  }

  mesh = new Mesh( geometry, material );

  scene.add( mesh );


  renderer = new WebGLRenderer(clearColorHex: 0x222222, clearAlpha: 1);
  renderer.setSize( window.innerWidth, window.innerHeight );
  renderer.sortObjects = false;

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);
  document.onMouseMove.listen(onDocumentMouseMove);

}

onWindowResize(event) {

  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

onDocumentMouseMove(event) {
  mouseX = ( event.client.x - windowHalfX );
  mouseY = ( event.client.y - windowHalfY ) * 2;
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

render() {

  mesh.rotation.y += 0.01;

  camera.position.y += ( - mouseY - camera.position.y ) * .01;

  camera.lookAt( scene.position );

  renderer.render( scene, camera );
}