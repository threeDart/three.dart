import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;
Mesh mesh;
var cameraTarget;

void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 50.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.y = 300.0;
  cameraTarget = new Vector3( 0.0, 150.0, 0.0 );

  scene = new Scene();

  var light;

  light = new DirectionalLight( 0xefefff, 2 );
  light.position.setValues( 1.0, 1.0, 1.0 ).normalize();
  scene.add( light );

  light = new DirectionalLight( 0xffefef, 2 );
  light.position.setValues( -1.0, -1.0, -1.0 ).normalize();
  scene.add( light );

  var loader = new JSONLoader( showStatus: true );
  loader.load( "horse.js", ( geometry ) {

    mesh = new Mesh( geometry, new MeshLambertMaterial( color: 0x606060, morphTargets: true) );
    mesh.scale.setValues( 1.5, 1.5, 1.5 );
    scene.add( mesh );

  } );

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  renderer.sortObjects = false;

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);

}

onWindowResize(event) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

const radius = 600,
      duration = 1000,
      keyframes = 15,
      interpolation = duration / keyframes;

var theta = 0.0,
    lastKeyframe = 0,
    currentKeyframe = 0;

render() {

  theta += 0.1;

  camera.position.x = radius * Math.sin( degToRad( theta ) );
  camera.position.z = radius * Math.cos( degToRad( theta ) );

  camera.lookAt( cameraTarget );

  if ( mesh != null) {

    // Alternate morph targets

    var time = new DateTime.now().millisecondsSinceEpoch % duration;

    var keyframe = ( time / interpolation ).floor().toInt();

    if ( keyframe != currentKeyframe ) {

      mesh.morphTargetInfluences[ lastKeyframe ] = 0;
      mesh.morphTargetInfluences[ currentKeyframe ] = 1;
      mesh.morphTargetInfluences[ keyframe ] = 0;

      lastKeyframe = currentKeyframe;
      currentKeyframe = keyframe;

      // console.log( mesh.morphTargetInfluences );

    }

    mesh.morphTargetInfluences[ keyframe ] = ( time % interpolation ) / interpolation;
    mesh.morphTargetInfluences[ lastKeyframe ] = 1 - mesh.morphTargetInfluences[ keyframe ];

  }

  renderer.render( scene, camera );
}
