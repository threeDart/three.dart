import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';

DivElement container;

Scene scene;
WebGLRenderer renderer;
Mesh mesh;

PerspectiveCamera camera;
PerspectiveCamera cameraPerspective;
OrthographicCamera cameraOrtho;

CameraHelper cameraPerspectiveHelper;
CameraHelper cameraOrthoHelper;

Camera activeCamera;
CameraHelper activeHelper;

Object3D cameraRig;

void main() {
  init();
  animate(0);
}

void init() { 
  container = new DivElement();
  document.body.append(container);
  
  scene = new Scene();
  
  camera = new PerspectiveCamera(50.0, 0.5 * window.innerWidth / window.innerHeight, 1.0, 10000.0)
    ..position.z = 2500.0;
  
  cameraPerspective = new PerspectiveCamera(
      50.0, 0.5 * window.innerWidth / window.innerHeight, 150.0, 1000.0);
  
  cameraPerspectiveHelper = new CameraHelper(cameraPerspective);
  scene.add(cameraPerspectiveHelper);
  
  //
  
  cameraOrtho = new OrthographicCamera(0.5 * window.innerWidth / -2, 0.5 * window.innerWidth / 2, 
      window.innerHeight / 2, window.innerHeight / -2, 150.0, 1000.0);
  
  cameraOrthoHelper = new CameraHelper(cameraOrtho);
  scene.add(cameraOrthoHelper);
  
  //
  
  activeCamera = cameraPerspective;
  activeHelper = cameraPerspectiveHelper;
  
  // counteract different front orientation of cameras vs rig
  
  cameraOrtho.rotation.y = Math.PI;
  cameraPerspective.rotation.y = Math.PI;

  cameraRig = new Object3D()
    ..add(cameraPerspective)
    ..add(cameraOrtho);
  
  scene.add(cameraRig);

  //
  
  mesh = new Mesh( new SphereGeometry( 100.0, 16, 8 ), new MeshBasicMaterial(color: 0xffffff, wireframe: true));
  scene.add( mesh );
  
  var mesh2 = new Mesh( new SphereGeometry( 50.0, 16, 8 ), new MeshBasicMaterial(color: 0x00ff00, wireframe: true));
  mesh2.position.y = 150.0;
  mesh.add( mesh2 );
  
  var mesh3 = new Mesh( new SphereGeometry( 5.0, 16, 8 ), new MeshBasicMaterial(color: 0x0000ff, wireframe: true));
  mesh3.position.z = 150.0;
  cameraRig.add( mesh3 );
  
  
  var geometry = new Geometry()
    ..vertices = new List.generate(10000, (i) => 
        new Vector3(randFloat(-1000.0, 1000.0), randFloat(-1000.0, 1000.0), randFloat(-1000.0, 1000.0)));

  scene.add(new ParticleSystem(geometry, new ParticleBasicMaterial(color: 0x888888)));
  
  
  renderer = new WebGLRenderer(antialias: true)
    ..setSize(window.innerWidth, window.innerHeight)
    ..domElement.style.position = "relative"
    ..autoClear = false;
  
  container.append(renderer.domElement);
  
  window.onResize.listen(onWindowResize);
  document.onKeyDown.listen(onDocumentKeyDown);
}

void onDocumentKeyDown(KeyboardEvent event) {
  switch (event.keyCode) {
    case KeyCode.O:
      activeCamera = cameraOrtho;
      activeHelper = cameraOrthoHelper;
      break;
    case KeyCode.P:
      activeCamera = cameraPerspective;
      activeHelper = cameraPerspectiveHelper;
      break;
  }
}

void onWindowResize(Event e) {
  renderer.setSize(window.innerWidth, window.innerHeight);

  camera.aspect = 0.5 * window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  cameraPerspective.aspect = 0.5 * window.innerWidth / window.innerHeight;
  cameraPerspective.updateProjectionMatrix();

  cameraOrtho
    ..left   = -0.5 * window.innerWidth / 2
    ..right  =  0.5 * window.innerWidth / 2
    ..top    =  window.innerHeight / 2
    ..bottom = -window.innerHeight / 2
    ..updateProjectionMatrix();
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

void render() {
  var r = new DateTime.now().millisecondsSinceEpoch * 0.0005;

  mesh.position.x = 700 * Math.cos(r);
  mesh.position.z = 700 * Math.sin(r);
  mesh.position.y = 700 * Math.sin(r);

  mesh.children[0].position.x = 70 * Math.cos(2 * r);
  mesh.children[0].position.z = 70 * Math.sin(r);

  if (activeCamera == cameraPerspective) {
    cameraPerspective.fov = 35 + 30 * Math.sin(0.5 * r);
    cameraPerspective.far = mesh.position.length;
    cameraPerspective.updateProjectionMatrix();

    cameraPerspectiveHelper.update();
    cameraPerspectiveHelper.visible = true;

    cameraOrthoHelper.visible = false;
  } else {
    cameraOrtho.far = mesh.position.length;
    cameraOrtho.updateProjectionMatrix();

    cameraOrthoHelper.update();
    cameraOrthoHelper.visible = true;

    cameraPerspectiveHelper.visible = false;
  }

  cameraRig.lookAt(mesh.position);

  renderer.clear();

  activeHelper.visible = false;

  renderer.setViewport(0, 0, window.innerWidth ~/ 2, window.innerHeight);
  renderer.render(scene, activeCamera);

  activeHelper.visible = true;

  renderer.setViewport(window.innerWidth ~/ 2, 0, window.innerWidth ~/ 2, window.innerHeight);
  renderer.render(scene, camera);
}
