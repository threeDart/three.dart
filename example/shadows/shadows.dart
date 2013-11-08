import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';
import 'package:three/extras/controls/trackball_controls.dart';
import 'package:three/extras/image_utils.dart';

var stats, scene, renderer;
var camera, cameraControls, spot1, spot2, dirLight, mainObj, sunDial;

// init the scene
init(){

  renderer = new WebGLRenderer(antialias: true);
  renderer.shadowMapEnabled = true;
  renderer.shadowMapType    = PCFSoftShadowMap;
  renderer.setClearColorHex( 0x000000, 1 );

  renderer.setSize( window.innerWidth, window.innerHeight );
  document.body.append(renderer.domElement);

  // create a scene
  scene = new Scene();

  // put a camera in the scene
  camera = new PerspectiveCamera(70.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.setValues(0.0, 2.0, 14.0);
  scene.add(camera);

  // create a camera contol
  cameraControls  = new TrackballControls(camera, renderer.domElement);
  cameraControls.target = new Vector3(0.0, 2.0, 0.0);

  // init the lights

  var ambient = new AmbientLight( 0x444444 );
  scene.add( ambient );

  dirLight = new DirectionalLight( 0x4444cc );
  dirLight.position.setValues( 1.0, -1.0, 1.0 ).normalize();
  scene.add( dirLight);

  spot1 = new SpotLight( 0x8888FF, 2.0 );
  spot1.target.position.setValues( 0.0, 2.0, 0.0 );
  spot1.shadowCameraNear    = 0.01;
  spot1.castShadow    = true;
  spot1.shadowDarkness    = 0.5;
  //light.shadowCameraVisible = true;
  scene.add( spot1 );


  spot2 = new SpotLight( 0xFFAA88, 2.0 );
  spot2.target.position.setValues( 0.0, 2.0, 0.0 );
  spot2.shadowCameraNear    = 0.01;
  spot2.castShadow    = true;
  spot2.shadowDarkness    = 0.5;
  spot2.shadowCameraVisible = true;
  scene.add( spot2);

  // create the sundial

  var sundial = new Object3D();
  sundial.position.y  = -1.0;
  scene.add(sundial);

  // var geometry  = new TorusGeometry( 2, 1, 16, 32 );
  var geometry  = new TorusKnotGeometry(25, 8, 75, 20);
  //var geometry  = new THREE.OctahedronGeometry( 1, 1 );
  //var geometry  = new THREE.CubeGeometry( 3, 3, 3 );
  //var geometry  = new THREE.SphereGeometry( 3, 32,16 );
  //var geometry  = new THREE.CylinderGeometry(1, 1, 4, 16)

  var texture = loadTexture( "images/water.jpg" );
  texture.repeat.setValues( 0.7, 1.0 );
  texture.wrapS = texture.wrapT = RepeatWrapping;
  var material  = new MeshPhongMaterial(
    ambient   : 0x444444,
    color   : 0x8844AA,
    shininess : 300,
    specular  : 0x33AA33,
    shading   : SmoothShading,
    map   : texture
  );
  var mesh  = new Mesh( geometry, material );
  mesh.scale.scale(1.0/18.0);
  mesh.castShadow   = true;
  mesh.receiveShadow  = false;
  mesh.position.y   = 4.0;
  sundial.add( mesh );
  mainObj  = mesh;

  // Add the ground cube
  geometry  = new CubeGeometry( 10.0, 0.5, 10.0);
  texture = loadTexture( "images/water.jpg" );
  texture.repeat.setValues( 0.5, 0.8 );
  texture.wrapS = texture.wrapT = RepeatWrapping;
  material  = new MeshPhongMaterial(
        ambient   : 0x444444,
        color   : 0x66aa66,
        shininess : 150,
        specular  : 0x888888,
        shading   : SmoothShading,
        map   : texture);
  mesh    = new Mesh( geometry, material );
  mesh.scale.scale(3.0);
  mesh.flipSided    = false;
  mesh.castShadow   = false;
  mesh.receiveShadow  = true;
  mesh.position.y   = -0.5/2.0;
  scene.add( mesh );
}

// animation loop
animate(time) {
  window.requestAnimationFrame( animate );
  render();
}

// render the scene
render() {

  var seconds   = new DateTime.now().millisecondsSinceEpoch / 1000;
  var piPerSeconds  = seconds * Math.PI;

  spot1.position.x  = Math.cos(piPerSeconds*0.05)*12;
  spot1.position.y  = 10.0;
  spot1.position.z  = Math.sin(piPerSeconds*0.05)*12;

  spot2.position.x  = Math.cos(piPerSeconds*-0.1)*15;
  spot2.position.y  = 8 + Math.sin(piPerSeconds*0.5)*4;
  spot2.position.z  = Math.sin(piPerSeconds*-0.1)*15;

  mainObj.rotation.x += 0.005;
  mainObj.rotation.y += 0.03;
  mainObj.rotation.z += 0.02;

  // update camera controls
  cameraControls.update();
  // limit camera position to avoid showing shadow on backface
  camera.position.y = Math.max(camera.position.y, 3.0);

  // actually render the scene
  renderer.render( scene, camera );
}

void main() {
  init();
  animate(0);
}

