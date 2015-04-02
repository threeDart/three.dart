/*
 * Based on r70
 */

import 'dart:html' hide Path;
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/controls/trackball_controls.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

TrackballControls controls;

var windowHalfX, windowHalfY;
var mouseX = 0;
var mouseXOnMouseDown = 0;
var mouseEvts = [];

var targetRotation = 0;
var targetRotationOnMouseDown = 0;

Object3D parent, text, plane;

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  init();
  animate(0);
}

void init() {
  container = new Element.tag('div');
  document.body.append(container);

  renderer = new WebGLRenderer()
    ..setClearColorHex(0x222222, 1.0)
    ..setSize(window.innerWidth, window.innerHeight);
  container.append(renderer.domElement);
  
  scene = new Scene();
  
  camera = new PerspectiveCamera(45.0, window.innerWidth / window.innerHeight, 1.0, 1000.0)
    ..position.setValues(0.0, 0.0, 500.0);
  
  controls = new TrackballControls(camera, renderer.domElement);
  controls.minDistance = 200.0;
  controls.maxDistance = 500.0;
  
  scene.add(new AmbientLight(0x222222));
  var light = new PointLight(0xffffff);
  light.position.setFrom(camera.position);
  
  scene.add(light);
  
  //
  
  var pts, geometry, material, mesh, shape;
 
  var closedSpline = new ClosedSplineCurve3(
      [new Vector3(-60.0, -100.0,  60.0),
       new Vector3(-60.0,   20.0,  60.0),
       new Vector3(-60.0,  120.0,  60.0),
       new Vector3( 60.0,   20.0, -60.0),
       new Vector3( 60.0, -100.0, -60.0)]);

  pts = []; var count = 3;
  for (var i = 0; i < count; i++) {
    var l = 20;
    var a = 2 * i / count * Math.PI;
    pts.add(new Vector2 (Math.cos(a) * l, Math.sin(a) * l));
  }
  
  shape = new Shape(pts);
  geometry = new ExtrudeGeometry(shape, steps: 100, bevelEnabled: false, extrudePath: closedSpline);
  material = new MeshLambertMaterial(color: 0xb00000, wireframe: false);
  mesh = new Mesh(geometry, material);
  scene.add(mesh);
  //
  var randomPoints = [];
  for (var i = 0; i < 10; i ++) {
    randomPoints.add(new Vector3((i - 4.5) * 50, randFloat(- 50, 50), randFloat(- 50, 50)));
  }
  var randomSpline =  new SplineCurve3(randomPoints);
  
  //
  
  pts = []; var numPts = 5;
  for (var i = 0; i < numPts * 2; i++) {
    var l = i % 2 == 1 ? 10 : 20;
    var a = i / numPts * Math.PI;
    pts.add(new Vector2(Math.cos(a) * l, Math.sin(a) * l));
  }
  
  shape = new Shape(pts);
  geometry = new ExtrudeGeometry(shape, steps: 200, bevelEnabled: false, extrudePath: randomSpline);
  var material2 = new MeshLambertMaterial(color: 0xff8000, wireframe: false);
  mesh = new Mesh(geometry, material2);
  scene.add(mesh);
  
  //
  
  var materials = [material, material2];

  geometry = new ExtrudeGeometry(shape, amount: 20, steps: 1, material: 1, extrudeMaterial: 0, 
      bevelEnabled: true, bevelThickness: 2.0, bevelSize: 4.0, bevelSegments: 1);
  mesh = new Mesh(geometry, new MeshFaceMaterial(materials));
  mesh.position.setValues(50.0, 100.0, 50.0);
  scene.add(mesh);

  window.onResize.listen(onWindowResize);
}

onWindowResize(event) {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

animate(num time) {
  window.requestAnimationFrame(animate);
  controls.update();
  renderer.render(scene, camera);
}