/*
 * Based on r70
 */

import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;
import 'package:three/extras/scene_utils.dart' as SceneUtils;
import 'package:three/extras/curve_extras.dart' as Curves;

DivElement container;
WebGLRenderer renderer;
PerspectiveCamera camera;
Scene scene;

void main() {
  init();
  animate(0);
}

void init() {
  container = new DivElement();
  document.body.append(container);
  
  camera = new PerspectiveCamera(45.0, window.innerWidth / window.innerHeight, 1.0, 2000.0)
    ..position.y = 400.0;
  
  scene = new Scene();

  var map = ImageUtils.loadTexture('UV_Grid_Sm.jpg');
  map.wrapS = map.wrapT = RepeatWrapping;
  map.anisotropy = 16;

  var materials = 
      [new MeshLambertMaterial(ambient: 0xbbbbbb, map: map, side: DoubleSide),
       new MeshBasicMaterial(color: 0xffffff, wireframe: true, transparent: true, opacity: 0.1, side: DoubleSide)];
  
  var torus2 = new ParametricGeometry.torusKnot(radius: 150.0, tube: 10.0, 
      segmentsR: 50, segmentsT: 20, p: 2.0 , q: 3.0, heightScale: 1.0);
  
  var sphere2 = new ParametricGeometry.sphere(75.0, 20, 10);
  var tube2 = new ParametricGeometry.tube(new Curves.GrannyKnot(), segments: 150, radius: 2.0, closed: true);
  
  scene.add(SceneUtils.createMultiMaterialObject(new ParametricGeometry.klein(20, 20), materials)
     ..position.setZero()
     ..scale.scale(10.0));
              
   scene.add(SceneUtils.createMultiMaterialObject(new ParametricGeometry.mobius(20, 20), materials)
     ..position.setValues(10.0, 0.0, 0.0)
     ..scale.scale(100.0));
              
   scene.add(SceneUtils.createMultiMaterialObject(new ParametricGeometry.plane(200.0, 200.0, 10, 20), materials));
   
   scene.add(SceneUtils.createMultiMaterialObject(torus2, materials)
     ..position.setValues(0.0, 100.0, 0.0));
   
   scene.add(SceneUtils.createMultiMaterialObject(sphere2, materials)
     ..position.setValues(200.0, 0.0, 0.0));
   
   scene.add(SceneUtils.createMultiMaterialObject(tube2, materials)
     ..position.setValues(100.0, 0.0, 0.0));

   scene.add(new AxisHelper(50.0)..position.setValues(200.0, 0.0, -200.0));
   
   scene.add(new ArrowHelper(new Vector3(0.0, 1.0, 0.0), new Vector3.zero(), 50.0)
     ..position.setValues(200.0, 0.0, 400.0));

   scene.add(new AmbientLight(0x404040));
   
   scene.add(new DirectionalLight(0xffffff)
     ..position = new Vector3(0.0, 0.0, 1.0));
  
  renderer = new WebGLRenderer()
    ..setSize(window.innerWidth, window.innerHeight);
  
  container.append(renderer.domElement);
  
  window.onResize.listen(onWindowResize);
}

void onWindowResize(Event e) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

void render() {
  var timer = new DateTime.now().millisecondsSinceEpoch * 0.0001;

  camera.position.x = Math.cos(timer) * 800.0;
  camera.position.z = Math.sin(timer) * 800.0;

  camera.lookAt(scene.position);

  scene.children.forEach((object) {
    object.rotation.x = timer * 5.0;
    object.rotation.y = timer * 2.5;
  });
  
  renderer.render(scene, camera);
}