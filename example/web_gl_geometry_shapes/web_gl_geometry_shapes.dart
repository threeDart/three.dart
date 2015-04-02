/*
 * Based on r70
 */

import 'dart:html' hide Path;
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

var windowHalfX, windowHalfY;
var mouseX = 0;
var mouseXOnMouseDown = 0;
var mouseEvts = [];

var targetRotation = 0;
var targetRotationOnMouseDown = 0;

Object3D group, text, plane;

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  init();
  animate(0);
}

void init() {
  container = new DivElement();
  document.body.append(container);

  scene = new Scene();
  
  camera = new PerspectiveCamera(50.0, window.innerWidth / window.innerHeight, 1.0, 1000.0)
    ..position.setValues(0.0, 150.0, 500.0);
  
  scene.add(camera);
  
  var light = new PointLight(0xffffff, intensity: 0.8);
  camera.add(light);
  
  group = new Object3D();
  group.position.y = 50.0;
  scene.add(group);
  
  addShape(Shape shape, color, x, y, z, rx, ry, rz, s, 
      {amount: 8, bevelEnabled: true, bevelSegments: 2, steps: 2, bevelSize: 1.0, bevelThickness: 1.0}) {
    x = x.toDouble(); y = y.toDouble(); z = z.toDouble(); rx = rx.toDouble(); ry = ry.toDouble(); rz = rz.toDouble(); s = s.toDouble();
    
    var points = shape.createPointsGeometry();
    var spacedPoints = shape.createSpacedPointsGeometry(50);
    // flat shape

    group.add(new Mesh(new ShapeGeometry(shape), new MeshPhongMaterial(color: color, side: DoubleSide))
     ..position.setValues(x, y, z - 125.0)
     ..rotation.setValues(rx, ry, rz)
     ..scale.setValues(s, s, s));
    
    // 3d shape
    group.add(new Mesh(new ExtrudeGeometry(shape, amount: amount, bevelEnabled: bevelEnabled, bevelSegments: bevelSegments, steps: steps, 
        bevelSize: bevelSize, bevelThickness: bevelThickness), new MeshPhongMaterial(color: color))
      ..position.setValues(x, y, z - 75.0)
      ..rotation.setValues(rx, ry, rz)
      ..scale.setValues(s, s, s));
    
    // solid line
    group.add(new Line(points, new LineBasicMaterial(color: color, linewidth: 3))
      ..position.setValues(x, y, z - 25.0)
      ..rotation.setValues(rx, ry, rz)
      ..scale.setValues(s, s, s));
    
    // vertices from real points
    group.add(new ParticleSystem(points.clone(), new ParticleBasicMaterial(color: color, size: 4))
     ..position.setValues(x, y, z + 25.0)
     ..rotation.setValues(rx, ry, rz)
     ..scale.setValues(s, s, s));
    
    // line from equidistance sampled points
    group.add(new Line(spacedPoints, new LineBasicMaterial(color: color, linewidth: 3))
      ..position.setValues(x, y, z + 75.0)
      ..rotation.setValues(rx, ry, rz)
      ..scale.setValues(s, s, s));
    
    // equidistance sampled points
    group.add(new ParticleSystem(spacedPoints.clone(), new ParticleBasicMaterial(color: color, size: 4))
      ..position.setValues(x, y, z + 125.0)
      ..rotation.setValues(rx, ry, rz)
      ..scale.setValues(s, s, s));
  }
  // California
  var californiaPts = [];
  californiaPts.add(new Vector2 (610.0, 320.0));
  californiaPts.add(new Vector2 (450.0, 300.0));
  californiaPts.add(new Vector2 (392.0, 392.0));
  californiaPts.add(new Vector2 (266.0, 438.0));
  californiaPts.add(new Vector2 (190.0, 570.0));
  californiaPts.add(new Vector2 (190.0, 600.0));
  californiaPts.add(new Vector2 (160.0, 620.0));
  californiaPts.add(new Vector2 (160.0, 650.0));
  californiaPts.add(new Vector2 (180.0, 640.0));
  californiaPts.add(new Vector2 (165.0, 680.0));
  californiaPts.add(new Vector2 (150.0, 670.0));
  californiaPts.add(new Vector2 ( 90.0, 737.0));
  californiaPts.add(new Vector2 ( 80.0, 795.0));
  californiaPts.add(new Vector2 ( 50.0, 835.0));
  californiaPts.add(new Vector2 ( 64.0, 870.0));
  californiaPts.add(new Vector2 ( 60.0, 945.0));
  californiaPts.add(new Vector2 (300.0, 945.0));
  californiaPts.add(new Vector2 (300.0, 743.0));
  californiaPts.add(new Vector2 (600.0, 473.0));
  californiaPts.add(new Vector2 (626.0, 425.0));
  californiaPts.add(new Vector2 (600.0, 370.0));
  californiaPts.add(new Vector2 (610.0, 320.0));
  for(var i = 0; i < californiaPts.length; i ++) { 
    californiaPts[i].scale(0.25); 
  }
  var californiaShape = new Shape(californiaPts);
  
  // Triangle
  var triangleShape = new Shape();
  triangleShape.moveTo( 80.0, 20.0);
  triangleShape.lineTo( 40.0, 80.0);
  triangleShape.lineTo(120.0, 80.0);
  triangleShape.lineTo( 80.0, 20.0); // close path
  
  // Heart
  var x = 0.0, y = 0.0;
  var heartShape = new Shape(); // From http://blog.burlock.org/html5/130-paths
  heartShape.moveTo(x + 25, y + 25);
  heartShape.bezierCurveTo(x + 25.0, y + 25.0, x + 20.0, y, x, y);
  heartShape.bezierCurveTo(x - 30.0, y, x - 30.0, y + 35.0, x - 30.0, y + 35.0);
  heartShape.bezierCurveTo(x - 30.0, y + 55.0, x - 10.0, y + 77.0, x + 25.0, y + 95.0);
  heartShape.bezierCurveTo(x + 60.0, y + 77.0, x + 80.0, y + 55.0, x + 80.0, y + 35.0);
  heartShape.bezierCurveTo(x + 80.0, y + 35.0, x + 80.0, y, x + 50.0, y);
  heartShape.bezierCurveTo(x + 35.0, y, x + 25.0, y + 25.0, x + 25.0, y + 25.0);
  
  // Square
  var sqLength = 80.0;
  var squareShape = new Shape();
  squareShape.moveTo(0.0, 0.0);
  squareShape.lineTo(0.0, sqLength);
  squareShape.lineTo(sqLength, sqLength);
  squareShape.lineTo(sqLength, 0.0);
  squareShape.lineTo(0.0, 0.0);
  
  // Rectangle
  var rectLength = 120.0, rectWidth = 40.0;
  var rectShape = new Shape();
  rectShape.moveTo(0.0, 0.0);
  rectShape.lineTo(0.0, rectWidth);
  rectShape.lineTo(rectLength, rectWidth);
  rectShape.lineTo(rectLength, 0.0);
  rectShape.lineTo(0.0, 0.0);
  
  // Rounded rectangle
  var roundedRectShape = new Shape();
  
  ((Shape ctx, x, y, width, height, radius) {
    ctx.moveTo(x, y + radius);
    ctx.lineTo(x, y + height - radius);
    ctx.quadraticCurveTo(x, y + height, x + radius, y + height);
    ctx.lineTo(x + width - radius, y + height) ;
    ctx.quadraticCurveTo(x + width, y + height, x + width, y + height - radius);
    ctx.lineTo(x + width, y + radius);
    ctx.quadraticCurveTo(x + width, y, x + width - radius, y);
    ctx.lineTo(x + radius, y);
    ctx.quadraticCurveTo(x, y, x, y + radius);
  })(roundedRectShape, 0.0, 0.0, 50.0, 50.0, 20.0);
  
  // Track
  var trackShape = new Shape();
  trackShape.moveTo(40.0, 40.0);
  trackShape.lineTo(40.0, 160.0);
  trackShape.absarc(60.0, 160.0, 20.0, Math.PI, 0, true);
  trackShape.lineTo(80.0, 40.0);
  trackShape.absarc(60.0, 40.0, 20.0, 2 * Math.PI, Math.PI, true);
  
  // Circle
  var circleRadius = 40.0;
  var circleShape = new Shape();
  circleShape.moveTo(0.0, circleRadius);
  circleShape.quadraticCurveTo(circleRadius, circleRadius, circleRadius, 0);
  circleShape.quadraticCurveTo(circleRadius, -circleRadius, 0, -circleRadius);
  circleShape.quadraticCurveTo(-circleRadius, -circleRadius, -circleRadius, 0);
  circleShape.quadraticCurveTo(-circleRadius, circleRadius, 0, circleRadius);
  
  // Fish
  var fishShape = new Shape();
  x = y = 0.0; 
  fishShape.moveTo(x, y);
  fishShape.quadraticCurveTo(x + 50.0, y - 80.0, x + 90.0, y - 10.0);
  fishShape.quadraticCurveTo(x + 100.0, y - 10.0, x + 115.0, y - 40.0);
  fishShape.quadraticCurveTo(x + 115.0, y, x + 115.0, y + 40.0);
  fishShape.quadraticCurveTo(x + 100.0, y + 10.0, x + 90.0, y + 10.0);
  fishShape.quadraticCurveTo(x + 50.0, y + 80.0, x, y);
  
  // Arc circle
  var arcShape = new Shape();
  arcShape.moveTo(50.0, 10.0);
  arcShape.absarc(10.0, 10.0, 40.0, 0.0, Math.PI*2, false);
  var holePath = new Path();
  holePath.moveTo(20.0, 10.0);
  holePath.absarc(10.0, 10.0, 10.0, 0.0, Math.PI*2, true);
  arcShape.holes.add(holePath);
  
  // Smiley
  var smileyShape = new Shape();
  smileyShape.moveTo(80.0, 40.0);
  smileyShape.absarc(40.0, 40.0, 40.0, 0.0, Math.PI*2, false);
  var smileyEye1Path = new Path();
  smileyEye1Path.moveTo(35.0, 20.0);
  smileyEye1Path.absellipse(25.0, 20.0, 10.0, 10.0, 0.0, Math.PI*2, true);
  smileyShape.holes.add(smileyEye1Path);  
  var smileyEye2Path = new Path();
  smileyEye2Path.moveTo(65.0, 20.0);
  smileyEye2Path.absarc(55.0, 20.0, 10.0, 0.0, Math.PI*2, true);
  smileyShape.holes.add(smileyEye2Path); 
  var smileyMouthPath = new Path();
  smileyMouthPath.moveTo(20.0, 40.0);
  smileyMouthPath.quadraticCurveTo(40.0, 60.0, 60.0, 40.0);
  smileyMouthPath.bezierCurveTo(70.0, 45.0, 70.0, 50.0, 60.0, 60.0);
  smileyMouthPath.quadraticCurveTo(40.0, 80.0, 20.0, 60.0);
  smileyMouthPath.quadraticCurveTo(5.0, 50.0, 20.0, 40.0);
  smileyShape.holes.add(smileyMouthPath);
  
  // Spline shape
  var splinepts = [];
  splinepts.add(new Vector2 (70.0, 20.0));
  splinepts.add(new Vector2 (80.0, 90.0));
  splinepts.add(new Vector2 (-30.0, 70.0));
  splinepts.add(new Vector2 (0.0, 0.0));
  var splineShape = new Shape();
  splineShape.moveTo(0.0, 0.0);
  splineShape.splineThru(splinepts);
  
  // addShape(shape, color, x, y, z, rx, ry,rz, s);
  addShape(californiaShape,  0xf08000, -300, -100, 0, 0, 0, 0, 1);
  addShape(triangleShape,    0x8080f0, -180,    0, 0, 0, 0, 0, 1);
  addShape(roundedRectShape, 0x008000, -150,  150, 0, 0, 0, 0, 1);
  addShape(trackShape,       0x008080,  200, -100, 0, 0, 0, 0, 1);
  addShape(squareShape,      0x0040f0,  150,  100, 0, 0, 0, 0, 1);
  addShape(heartShape,       0xf00000,   60,  100, 0, 0, 0, Math.PI, 1);
  addShape(circleShape,      0x00f000,  120,  250, 0, 0, 0, 0, 1);
  addShape(fishShape,        0x404040,  -60,  200, 0, 0, 0, 0, 1);
  addShape(smileyShape,      0xf000f0, -200,  250, 0, 0, 0, Math.PI, 1);
  addShape(arcShape,         0x804000,  150,    0, 0, 0, 0, 0, 1);
  addShape(splineShape,      0x808080,  -50, -100, 0, 0, 0, 0, 1);
  //

  renderer = new WebGLRenderer()
    ..setClearColorHex(0xf0f0f0, 1.0)
    ..setSize(window.innerWidth, window.innerHeight);

  container.nodes.add(renderer.domElement);

  mouseEvts = [
      document.onMouseDown.listen(onDocumentMouseDown),
      document.onTouchStart.listen(onDocumentTouchStart),
      document.onTouchMove.listen(onDocumentTouchMove)];


  window.onResize.listen(onWindowResize);
}

onWindowResize(event) {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

void cancelMouseEvts() {
  mouseEvts.forEach((s) => s.cancel());
  mouseEvts = [];
}

onDocumentMouseDown(MouseEvent event) {
  event.preventDefault();

  mouseEvts = [
      document.onMouseMove.listen(onDocumentMouseMove),
      document.onMouseUp.listen(onDocumentMouseUp),
      document.onMouseOut.listen(onDocumentMouseOut)];

  mouseXOnMouseDown = event.client.x - windowHalfX;
  targetRotationOnMouseDown = targetRotation;
}

onDocumentMouseMove(MouseEvent event) {
  mouseX = event.client.x - windowHalfX;
  targetRotation = targetRotationOnMouseDown + (mouseX - mouseXOnMouseDown) * 0.02;
}

onDocumentMouseUp(event) {
  cancelMouseEvts();
}

onDocumentMouseOut(event) {
  cancelMouseEvts();
}

onDocumentTouchStart(TouchEvent event) {
  if (event.touches.length == 1) {
    event.preventDefault();

    mouseXOnMouseDown = event.touches[0].page.x - windowHalfX;
    targetRotationOnMouseDown = targetRotation;
  }
}

onDocumentTouchMove(TouchEvent event) {
  if (event.touches.length == 1) {
    event.preventDefault();

    mouseX = event.touches[0].page.x - windowHalfX;
    targetRotation = targetRotationOnMouseDown + (mouseX - mouseXOnMouseDown) * 0.05;
  }
}

animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

render() {
  group.rotation.y += (targetRotation - group.rotation.y) * 0.05;

  renderer.render(scene, camera);
}
