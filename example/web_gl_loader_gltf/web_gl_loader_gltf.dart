import 'dart:html' hide Animation;
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' hide Ray;
import 'package:three/three.dart' as THREE;
import 'package:three/loaders/gltf.dart';
import 'package:three/extras/controls/trackball_controls.dart';

var loader;
Element container;
THREE.Scene scene;
THREE.Camera camera;
THREE.WebGLRenderer renderer;

var cameraIndex = 0;
var cameras = [];
var cameraNames = [];
THREE.Camera defaultCamera = null;
var gltf = null;

TrackballControls controls;

main() {

  document.querySelector("#scenes_list").onChange.listen(selectScene);
  document.querySelector("#cameras_list").onChange.listen(selectCamera);
  document.querySelector("#toggle_animations").onClick.listen(toggleAnimations);
  document.querySelector("#buffer_geometry_checkbox").onClick.listen(toggleBufferGeometry);

  window.onResize.listen(_onWindowResize);
  document.onKeyPress.listen(_onKeyPress);
  buildSceneList();
  switchScene(0);
  _animate(0);
}

initScene(index) {
  container = document.getElementById( 'container' );

  scene = new THREE.Scene();

  defaultCamera = new THREE.PerspectiveCamera( 45.0, container.offsetWidth / container.offsetHeight, 1.0, 20000.0 );

  //defaultCamera.up = new THREE.Vector3( 0, 1, 0 );
  scene.add( defaultCamera );
  camera = defaultCamera;

  var sceneInfo = sceneList[index];

  var spot1 = null;
  if (sceneInfo["addLights"]) {

    var ambient = new THREE.AmbientLight( 0x888888 );
    scene.add( ambient );

    var directionalLight = new THREE.DirectionalLight( 0xdddddd );
    directionalLight.position.setValues( 0.0, -1.0, 1.0 ).normalize();
    scene.add( directionalLight );

    spot1   = new THREE.SpotLight( 0xffffff, 1.0 );
    spot1.position.setValues( -100.0, 200.0, 100.0 );
    spot1.target.position.setValues( 0.0, 0.0, 0.0 );

    if (sceneInfo["shadows"]) {

      spot1.shadowCameraNear      = 1.0;
      spot1.shadowCameraFar      = 1024.0;
      spot1.castShadow            = true;
      spot1.shadowDarkness        = 0.3;
      spot1.shadowBias = 0.0001;
      spot1.shadowMapWidth = 2048;
      spot1.shadowMapHeight = 2048;
    }
    scene.add( spot1 );
  }

  // RENDERER

  renderer = new THREE.WebGLRenderer(antialias:true);
  renderer.setSize( container.offsetWidth, container.offsetHeight );

  if (sceneInfo["shadows"] != null) {
    renderer.shadowMapEnabled = true;
    //TODO(nfgs) - renderer.shadowMapSoft = true;
    renderer.shadowMapType = THREE.PCFSoftShadowMap;
  }

  container.append( renderer.domElement );

  var ground = null;
  if (sceneInfo["addGround"]) {
    var groundMaterial = new THREE.MeshPhongMaterial(
        color: 0xFFFFFF,
        ambient: 0x888888,
        shading: THREE.SmoothShading
    );
    ground = new THREE.Mesh( new THREE.PlaneGeometry(1024.0, 1024.0), groundMaterial);

    if (sceneInfo["shadows"]) {
      ground.receiveShadow = true;
    }

    if (sceneInfo["groundPos"] != null) {
      ground.position.copyFromArray(sceneInfo.groundPos);
    } else {
      ground.position.z = -70.0;
    }
    ground.rotation.x = -Math.PI / 2;

    scene.add(ground);
  }

  GLTFLoader.useBufferGeometry = useBufferGeometry;
  var loadStartTime = new DateTime.now().millisecondsSinceEpoch;
  var status = document.getElementById("status");
  status.innerHtml = "Loading...";

  loader = new GLTFLoader()
  ..load( sceneInfo["url"]).then((result) {

    gltf = result;

    var object = gltf.scene;

    var loadEndTime = new DateTime.now().millisecondsSinceEpoch;

    var loadTime = (loadEndTime - loadStartTime) / 1000;

    status.innerHtml = "Load time: " + loadTime.toStringAsFixed(2) + " seconds.";

    if (sceneInfo["cameraPos"] != null)
      defaultCamera.position.setFrom(sceneInfo["cameraPos"]);

    if (sceneInfo["center"] != null) {
      controls.center.setFrom(sceneInfo["center"]);
    }

    if (sceneInfo["objectPosition"] != null) {
      object.position.setFrom(sceneInfo["objectPosition"]);

      if (spot1 != null) {
        spot1.position.setValues(sceneInfo["objectPosition"].x - 100, sceneInfo["objectPosition"].y + 200, sceneInfo["objectPosition"].z - 100 );
        spot1.target.position.setFrom(sceneInfo["objectPosition"]);
      }
    }

    if (sceneInfo["objectRotation"] != null)
      object.rotation.setFrom(sceneInfo["objectRotation"]);

    if (sceneInfo["objectScale"] != null)
      object.scale.setFrom(sceneInfo["objectScale"]);

    cameraIndex = 0;
    cameras = [];
    cameraNames = [];
    if (gltf.cameras != null && gltf.cameras.isNotEmpty) {
      var i, len = gltf.cameras.length;
      for (i = 0; i < len; i++) {
        var addCamera = true;
        var cameraName = gltf.cameras[i].parent.name;
        if (sceneInfo["cameras"] != null && !(sceneInfo["cameras"].containsKey(cameraName))) {
          addCamera = false;
        }

        if (addCamera) {
          cameraNames.add(cameraName);
          cameras.add(gltf.cameras[i]);
        }
      }

      updateCamerasList();
      switchCamera(1);
    } else {
      updateCamerasList();
      switchCamera(0);
    }

    gltf.animations.forEach((GLTFAnimation animation) {
        animation.loop = true;
        // There's .3333 seconds junk at the tail of the Monster animation that
        // keeps it from looping cleanly. Clip it at 3 seconds
        if (sceneInfo["animationTime"] != null)
          animation.duration = sceneInfo["animationTime"];
        animation.play();
    });

    scene.add( object );
    _onWindowResize(null);

  });

  controls = new TrackballControls(defaultCamera, renderer.domElement);
}

_onWindowResize(_) {

  defaultCamera.aspect = container.offsetWidth / container.offsetHeight;
  defaultCamera.updateProjectionMatrix();

  var i, len = cameras.length;
  for (i = 0; i < len; i++) {
    cameras[i].aspect = container.offsetWidth / container.offsetHeight;
    cameras[i].updateProjectionMatrix();
  }

  renderer.setSize( container.offsetWidth, container.offsetHeight );

}

_animate(num time) {
  window.requestAnimationFrame( _animate );
  glTFAnimator.update();
  if (cameraIndex == 0)
    controls.update();
  render();
}

render() {
  renderer.render( scene, camera );
}

_onKeyPress(KeyboardEvent event) {
  if (event.keyCode == KeyCode.SPACE) {
    var index = cameraIndex + 1;
    if (index > cameras.length)
      index = 0;
    switchCamera(index);
  } else {
    var index = event.keyCode - KeyCode.ZERO;
    if (index <= cameras.length) {
      switchCamera(index);
    }
  }
}

var sceneList = [
    { "name" : "Duck", "url" : "./models/gltf/duck/duck.json",
      "cameraPos": new Vector3(0.0, 30.0, -50.0),
      "objectScale": new Vector3(0.1, 0.1, 0.1),
      "addLights": true,
      "addGround": true,
      "shadows": true },
    { "name" : "Monster", "url" : "./models/gltf/monster/monster.json",
      "cameraPos": new Vector3(30.0, 10.0, 70.0),
      "objectScale": new Vector3(0.01, 0.01, 0.01),
      "objectPosition": new Vector3(0.0, 1.0, 0.0),
      "objectRotation": new Quaternion.identity().setEuler(-Math.PI / 2, 0.0, -Math.PI / 2),
      "animationTime": 3,
      "addLights": true,
      "shadows": true,
      "addGround": true },
];

buildSceneList() {
  var elt = document.getElementById('scenes_list');
  while( elt.children.isNotEmpty ){
    elt.children.removeLast();
  }

  var i, len = sceneList.length;
  for (i = 0; i < len; i++) {
    var option = document.createElement("option");
    option.text=sceneList[i]["name"];
    elt.children.add(option);
  }
}

switchScene(index) {
  cleanup();
  initScene(index);
  var elt = document.getElementById('scenes_list');
  elt.selectedIndex = index;
}

selectScene([_]) {
  var select = document.getElementById("scenes_list");
  var index = select.selectedIndex;
  if (index >= 0) {
    switchScene(index);
  }
}

switchCamera(index) {
  cameraIndex = index;

  if (cameraIndex == 0) {
    camera = defaultCamera;
  }
  if (cameraIndex >= 1 && cameraIndex <= cameras.length) {
    camera = cameras[cameraIndex - 1];
  }

  var elt = document.getElementById('cameras_list');
  elt.selectedIndex = cameraIndex;
}

updateCamerasList() {
  var elt = document.getElementById('cameras_list');
  while( elt.children.isNotEmpty ){
    elt.children.removeLast();
  }

  var option = document.createElement("option");
  option.text="[default]";
  elt.children.add(option);

  var i, len = cameraNames.length;
  for (i = 0; i < len; i++) {
    option = document.createElement("option");
    option.text=cameraNames[i];
    elt.children.add(option);
  }
}

selectCamera([_]) {
  var select = document.getElementById("cameras_list");
  var index = select.selectedIndex;
  if (index >= 0) {
    switchCamera(index);
  }
}

toggleAnimations([_]) {
  var i, len = gltf.animations.length;
  for (i = 0; i < len; i++) {
    var animation = gltf.animations[i];
    if (animation.running) {
      animation.stop();
    } else {
      animation.play();
    }
  }
}

InputElement usebuf = document.getElementById("buffer_geometry_checkbox");
var useBufferGeometry = usebuf.checked;
toggleBufferGeometry([_]) {
  useBufferGeometry = !useBufferGeometry;
  selectScene();
}

cleanup() {

  if (container != null && renderer != null) {
    container.children.remove(renderer.domElement);
  }

  cameraIndex = 0;
  cameras = [];
  cameraNames = [];
  defaultCamera = null;

  if (gltf == null || gltf.animations == null)
    return;

  var i, len = gltf.animations.length;
  for (i = 0; i < len; i++) {
    var animation = gltf.animations[i];
    if (animation.running) {
      animation.stop();
    }
  }
}