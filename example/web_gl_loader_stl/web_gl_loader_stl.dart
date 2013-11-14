import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' hide Ray;
import 'package:three/three.dart';

var container, stats;

var camera, cameraTarget, scene, renderer;

main() {
  init();
  animate(0);
}

init() {

  container = document.createElement( 'div' );
  document.body.append( container );

  camera = new PerspectiveCamera( 35.0, window.innerWidth / window.innerHeight, 1.0, 15.0 );
  camera.position.setValues( 3.0, 0.15, 3.0 );

  cameraTarget = new Vector3( 0.0, -0.25, 0.0 );

  scene = new Scene();
  scene.fog = new FogLinear( 0x72645b, 2.0, 15.0 );

  // Ground

  var plane = new Mesh( new PlaneGeometry( 40.0, 40.0 ), new MeshPhongMaterial( ambient: 0x999999, color: 0x999999, specular: 0x101010 ) );
  plane.rotation.x = -Math.PI/2;
  plane.position.y = -0.5;
  scene.add( plane );

  plane.receiveShadow = true;


  // ASCII file

  var loader = new STLLoader();

  loader.load( 'models/stl/ascii/slotted_disk.stl').then((geometry) {

    var material = new MeshPhongMaterial( ambient: 0xff5533, color: 0xff5533, specular: 0x111111, shininess: 200 );
    var mesh = new Mesh( geometry, material );

    mesh.position.setValues( 0.0, - 0.25, 0.6 );
    mesh.rotation.setValues( 0.0, - Math.PI / 2, 0.0 );
    mesh.scale.setValues( 0.5, 0.5, 0.5 );

    mesh.castShadow = true;
    mesh.receiveShadow = true;

    scene.add( mesh );
  });


  // Binary files

  var material = new MeshPhongMaterial( ambient: 0x555555, color: 0xAAAAAA, specular: 0x111111, shininess: 200 );

  loader = new STLLoader();

  loader.load( './models/stl/binary/pr2_head_pan.stl').then((geometry) {
    var mesh = new Mesh( geometry, material );

    mesh.position.setValues( 0.0, - 0.37, - 0.6 );
    mesh.rotation.setValues( - Math.PI / 2, 0.0, 0.0 );
    mesh.scale.setValues( 2.0, 2.0, 2.0 );

    mesh.castShadow = true;
    mesh.receiveShadow = true;

    scene.add( mesh );
  });

  loader = new STLLoader();
  loader.load( './models/stl/binary/pr2_head_tilt.stl' ).then((geometry) {

    var mesh = new Mesh( geometry, material );

    mesh.position.setValues( 0.136, - 0.37, - 0.6 );
    mesh.rotation.setValues( - Math.PI / 2, 0.3, 0.0 );
    mesh.scale.setValues( 2.0, 2.0, 2.0 );

    mesh.castShadow = true;
    mesh.receiveShadow = true;

    scene.add( mesh );

  } );


  // Lights

  scene.add( new AmbientLight( 0x777777 ) );

  addShadowedLight( 1.0, 1.0, 1.0, 0xffffff, 1.35 );
  addShadowedLight( 0.5, 1.0, -1.0, 0xffaa00, 1.0 );

  // renderer

  renderer = new WebGLRenderer( antialias: true, alpha: false );
  renderer.setSize( window.innerWidth, window.innerHeight );

  renderer.setClearColor( scene.fog.color, 1 );

  renderer.gammaInput = true;
  renderer.gammaOutput = true;
  renderer.physicallyBasedShading = true;

  renderer.shadowMapEnabled = true;
  //renderer.shadowMapCullFace = CullFaceBack;

  container.append( renderer.domElement );


  window.onResize.listen(onWindowResize);

}

addShadowedLight( x, y, z, color, intensity ) {

  var directionalLight = new DirectionalLight( color, intensity );
  directionalLight.position.setValues( x, y, z );
  scene.add( directionalLight );

  directionalLight.castShadow = true;
  // directionalLight.shadowCameraVisible = true;

  var d = 1.0;
  directionalLight.shadowCameraLeft = -d;
  directionalLight.shadowCameraRight = d;
  directionalLight.shadowCameraTop = d;
  directionalLight.shadowCameraBottom = -d;

  directionalLight.shadowCameraNear = 1.0;
  directionalLight.shadowCameraFar = 4.0;

  directionalLight.shadowMapWidth = 1024;
  directionalLight.shadowMapHeight = 1024;

  directionalLight.shadowBias = -0.005;
  directionalLight.shadowDarkness = 0.15;

}

onWindowResize(_) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

animate(num time) {

  window.requestAnimationFrame( animate );

  render();

}

var start_time = null;

render() {
  if (start_time == null) {
    start_time = new DateTime.now().millisecondsSinceEpoch;
  }
  var delta = new DateTime.now().millisecondsSinceEpoch - start_time,
      delta_in_sec = delta * 0.001;

  var timer = delta_in_sec * 0.5;

  camera.position.x = Math.cos( timer ) * 3;
  camera.position.z = Math.sin( timer ) * 3;

  camera.lookAt( cameraTarget );

  renderer.render( scene, camera );

}