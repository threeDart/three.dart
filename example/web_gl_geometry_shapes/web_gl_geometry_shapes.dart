import 'dart:html' hide Path;
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/scene_utils.dart' as SceneUtils;
import 'package:three/extras/geometry_utils.dart' as GeometryUtils;

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

Object3D parent, text, plane;

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  init();
  animate(0);
}

addGeometry( geometry, points, spacedPoints, color, x, y, z, rx, ry, rz, s ) {

  // 3d shape

  var mesh = SceneUtils.createMultiMaterialObject( geometry,
      [ new MeshLambertMaterial( color: color ),
        new MeshBasicMaterial( color: 0x000000, wireframe: true, transparent: true )]);
  mesh.position.setValues( x, y, z - 75 );
  mesh.rotation.setValues( rx, ry, rz );
  mesh.scale.setValues( s, s, s );
  parent.add( mesh );

  // solid line

  var line = new Line( points, new LineBasicMaterial( color: color, linewidth: 2 ) );
  line.position.setValues( x, y, z + 25 );
  line.rotation.setValues( rx, ry, rz );
  line.scale.setValues( s, s, s );
  parent.add( line );

  // transparent line from real points

  line = new Line( points, new LineBasicMaterial( color: color, opacity: 0.5 ) );
  line.position.setValues( x, y, z + 75 );
  line.rotation.setValues( rx, ry, rz );
  line.scale.setValues( s, s, s );
  parent.add( line );

  // vertices from real points

  var pgeo = GeometryUtils.clone( points );
  var particles = new ParticleSystem( pgeo, new ParticleBasicMaterial( color: color, size: 2, opacity: 0.75 ) );
  particles.position.setValues( x, y, z + 75 );
  particles.rotation.setValues( rx, ry, rz );
  particles.scale.setValues( s, s, s );
  parent.add( particles );

  // transparent line from equidistance sampled points

  line = new Line( spacedPoints, new LineBasicMaterial( color: color, opacity: 0.2) );
  line.position.setValues( x, y, z + 100 );
  line.rotation.setValues( rx, ry, rz );
  line.scale.setValues( s, s, s );
  parent.add( line );

  // equidistance sampled points

  pgeo = GeometryUtils.clone( spacedPoints );
  var particles2 = new ParticleSystem( pgeo, new ParticleBasicMaterial( color: color, size: 2, opacity: 0.5 ) );
  particles2.position.setValues( x, y, z + 100 );
  particles2.rotation.setValues( rx, ry, rz );
  particles2.scale.setValues( s, s, s );
  parent.add( particles2 );

}

roundedRect( ctx, x, y, width, height, radius ){

  ctx.moveTo( x, y + radius );
  ctx.lineTo( x, y + height - radius );
  ctx.quadraticCurveTo( x, y + height, x + radius, y + height );
  ctx.lineTo( x + width - radius, y + height) ;
  ctx.quadraticCurveTo( x + width, y + height, x + width, y + height - radius );
  ctx.lineTo( x + width, y + radius );
  ctx.quadraticCurveTo( x + width, y, x + width - radius, y );
  ctx.lineTo( x + radius, y );
  ctx.quadraticCurveTo( x, y, x, y + radius );

}
void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 50.0, window.innerWidth / window.innerHeight, 1.0, 1000.0 );
  camera.position.setValues( 0.0, 150.0, 500.0 );

  scene = new Scene();

  var light = new DirectionalLight( 0xffffff );
  light.position.setValues( 0.0, 0.0, 1.0 );
  scene.add( light );

  parent = new Object3D();
  parent.position.y = 50.0;
  scene.add( parent );

  var extrude_amount = 20,
      extrude_bevelEnabled = true,
      extrude_bevelSegments = 2,
      extrude_steps = 2; // bevelSegments: 2, steps: 2 , bevelSegments: 5, bevelsize: 8, bevelThickness:5,

  // California

  var californiaPts = [];

  californiaPts.add( new Vector2 ( 610.0, 320.0 ) );
  californiaPts.add( new Vector2 ( 450.0, 300.0 ) );
  californiaPts.add( new Vector2 ( 392.0, 392.0 ) );
  californiaPts.add( new Vector2 ( 266.0, 438.0 ) );
  californiaPts.add( new Vector2 ( 190.0, 570.0 ) );
  californiaPts.add( new Vector2 ( 190.0, 600.0 ) );
  californiaPts.add( new Vector2 ( 160.0, 620.0 ) );
  californiaPts.add( new Vector2 ( 160.0, 650.0 ) );
  californiaPts.add( new Vector2 ( 180.0, 640.0 ) );
  californiaPts.add( new Vector2 ( 165.0, 680.0 ) );
  californiaPts.add( new Vector2 ( 150.0, 670.0 ) );
  californiaPts.add( new Vector2 (  90.0, 737.0 ) );
  californiaPts.add( new Vector2 (  80.0, 795.0 ) );
  californiaPts.add( new Vector2 (  50.0, 835.0 ) );
  californiaPts.add( new Vector2 (  64.0, 870.0 ) );
  californiaPts.add( new Vector2 (  60.0, 945.0 ) );
  californiaPts.add( new Vector2 ( 300.0, 945.0 ) );
  californiaPts.add( new Vector2 ( 300.0, 743.0 ) );
  californiaPts.add( new Vector2 ( 600.0, 473.0 ) );
  californiaPts.add( new Vector2 ( 626.0, 425.0 ) );
  californiaPts.add( new Vector2 ( 600.0, 370.0 ) );
  californiaPts.add( new Vector2 ( 610.0, 320.0 ) );

  var californiaShape = new Shape( californiaPts );

  var california3d = new ExtrudeGeometry( [californiaShape], amount: 20 );
  var californiaPoints = californiaShape.createPointsGeometry();
  var californiaSpacedPoints = californiaShape.createSpacedPointsGeometry( 100 );

  // Triangle

  var triangleShape = new Shape();
  triangleShape.moveTo(  80.0, 20.0 );
  triangleShape.lineTo(  40.0, 80.0 );
  triangleShape.lineTo( 120.0, 80.0 );
  triangleShape.lineTo(  80.0, 20.0 ); // close path

  var triangle3d = triangleShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var trianglePoints = triangleShape.createPointsGeometry();
  var triangleSpacedPoints = triangleShape.createSpacedPointsGeometry();


  // Heart

  var x = 0.0, y = 0.0;

  var heartShape = new Shape(); // From http://blog.burlock.org/html5/130-paths

  heartShape.moveTo( x + 25, y + 25 );
  heartShape.bezierCurveTo( x + 25, y + 25, x + 20, y, x, y );
  heartShape.bezierCurveTo( x - 30, y, x - 30, y + 35,x - 30,y + 35 );
  heartShape.bezierCurveTo( x - 30, y + 55, x - 10, y + 77, x + 25, y + 95 );
  heartShape.bezierCurveTo( x + 60, y + 77, x + 80, y + 55, x + 80, y + 35 );
  heartShape.bezierCurveTo( x + 80, y + 35, x + 80, y, x + 50, y );
  heartShape.bezierCurveTo( x + 35, y, x + 25, y + 25, x + 25, y + 25 );

  var heart3d = heartShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var heartPoints = heartShape.createPointsGeometry();
  var heartSpacedPoints = heartShape.createSpacedPointsGeometry();

  //heartShape.debug( document.getElementById("debug") );

  // Square

  var sqLength = 80.0;

  var squareShape = new Shape();
  squareShape.moveTo( 0.0, 0.0 );
  squareShape.lineTo( 0.0, sqLength );
  squareShape.lineTo( sqLength, sqLength );
  squareShape.lineTo( sqLength, 0.0 );
  squareShape.lineTo( 0.0, 0.0 );

  var square3d = squareShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var squarePoints = squareShape.createPointsGeometry();
  var squareSpacedPoints = squareShape.createSpacedPointsGeometry();

  // Rectangle

  var rectLength = 120.0, rectWidth = 40.0;

  var rectShape = new Shape();
  rectShape.moveTo( 0.0, 0.0 );
  rectShape.lineTo( 0.0, rectWidth );
  rectShape.lineTo( rectLength, rectWidth );
  rectShape.lineTo( rectLength, 0.0 );
  rectShape.lineTo( 0.0, 0.0 );

  var rect3d = rectShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var rectPoints = rectShape.createPointsGeometry();
  var rectSpacedPoints = rectShape.createSpacedPointsGeometry();

  // Rounded rectangle

  var roundedRectShape = new Shape();
  roundedRect( roundedRectShape, 0.0, 0.0, 50.0, 50.0, 20.0 );

  var roundedRect3d = roundedRectShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var roundedRectPoints = roundedRectShape.createPointsGeometry();
  var roundedRectSpacedPoints = roundedRectShape.createSpacedPointsGeometry();

  // Circle

  var circleRadius = 40.0;
  var circleShape = new Shape();
  circleShape.moveTo( 0.0, circleRadius );
  circleShape.quadraticCurveTo( circleRadius, circleRadius, circleRadius, 0.0 );
  circleShape.quadraticCurveTo( circleRadius, -circleRadius, 0.0, -circleRadius );
  circleShape.quadraticCurveTo( -circleRadius, -circleRadius, -circleRadius, 0.0 );
  circleShape.quadraticCurveTo( -circleRadius, circleRadius, 0.0, circleRadius );

  var circle3d = circleShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var circlePoints = circleShape.createPointsGeometry();
  var circleSpacedPoints = circleShape.createSpacedPointsGeometry();

  // Fish

  x = y = 0.0;

  var fishShape = new Shape();

  fishShape.moveTo(x,y);
  fishShape.quadraticCurveTo(x + 50, y - 80, x + 90, y - 10);
  fishShape.quadraticCurveTo(x + 100, y - 10, x + 115, y - 40);
  fishShape.quadraticCurveTo(x + 115, y, x + 115, y + 40);
  fishShape.quadraticCurveTo(x + 100, y + 10, x + 90, y + 10);
  fishShape.quadraticCurveTo(x + 50, y + 80, x, y);

  var fish3d = fishShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var fishPoints = fishShape.createPointsGeometry();
  var fishSpacedPoints = fishShape.createSpacedPointsGeometry();

  // Arc circle

  var arcShape = new Shape();
  arcShape.moveTo( 50.0, 10.0 );
  arcShape.absarc( 10.0, 10.0, 40.0, 0.0, Math.PI*2, false );

  var holePath = new Path();
  holePath.moveTo( 20.0, 10.0 );
  holePath.absarc( 10.0, 10.0, 10.0, 0.0, Math.PI*2, true );
  arcShape.holes.add( holePath );

  var arc3d = arcShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var arcPoints = arcShape.createPointsGeometry();
  var arcSpacedPoints = arcShape.createSpacedPointsGeometry();


  // Smiley

  var smileyShape = new Shape();
  smileyShape.moveTo( 80.0, 40.0 );
  smileyShape.absarc( 40.0, 40.0, 40.0, 0.0, Math.PI*2, false );

  var smileyEye1Path = new Path();
  smileyEye1Path.moveTo( 35.0, 20.0 );
  // smileyEye1Path.absarc( 25, 20, 10, 0, Math.PI*2, true );
  smileyEye1Path.absellipse( 25.0, 20.0, 10.0, 10.0, 0.0, Math.PI*2, true );

  smileyShape.holes.add( smileyEye1Path );

  var smileyEye2Path = new Path();
  smileyEye2Path.moveTo( 65.0, 20.0 );
  smileyEye2Path.absarc( 55.0, 20.0, 10.0, 0.0, Math.PI*2, true );
  smileyShape.holes.add( smileyEye2Path );

  var smileyMouthPath = new Path();
  // ugly box mouth
  // smileyMouthPath.moveTo( 20, 40 );
  // smileyMouthPath.lineTo( 60, 40 );
  // smileyMouthPath.lineTo( 60, 60 );
  // smileyMouthPath.lineTo( 20, 60 );
  // smileyMouthPath.lineTo( 20, 40 );

  smileyMouthPath.moveTo( 20.0, 40.0 );
  smileyMouthPath.quadraticCurveTo( 40.0, 60.0, 60.0, 40.0 );
  smileyMouthPath.bezierCurveTo( 70.0, 45.0, 70.0, 50.0, 60.0, 60.0 );
  smileyMouthPath.quadraticCurveTo( 40.0, 80.0, 20.0, 60.0 );
  smileyMouthPath.quadraticCurveTo( 5.0, 50.0, 20.0, 40.0 );

  smileyShape.holes.add( smileyMouthPath );


  var smiley3d = smileyShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps);
  var smileyPoints = smileyShape.createPointsGeometry();
  var smileySpacedPoints = smileyShape.createSpacedPointsGeometry();

  // Spline shape + path extrusion

  var splinepts = [];
  splinepts.add( new Vector2 ( 350.0, 100.0 ) );
  splinepts.add( new Vector2 ( 400.0, 450.0 ) );
  splinepts.add( new Vector2 ( -140.0, 350.0 ) );
  splinepts.add( new Vector2.zero() );

  var splineShape = new Shape(  );
  splineShape.moveTo( 0.0, 0.0 );
  splineShape.splineThru( splinepts );

  //splineShape.debug( document.getElementById("debug") );

  // TODO 3d path?

  var apath = new SplineCurve3();
  apath.points.add(new Vector3(-50.0, 150.0, 10.0));
  apath.points.add(new Vector3(-20.0, 180.0, 20.0));
  apath.points.add(new Vector3(40.0, 220.0, 50.0));
  apath.points.add(new Vector3(200.0, 290.0, 100.0));

  var extrude_extrudePath = apath;
  extrude_bevelEnabled = false;
  extrude_steps = 20;

  var splineShape3d = splineShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps,
      extrudePath: extrude_extrudePath);
  var splinePoints = splineShape.createPointsGeometry( );
  var splineSpacedPoints = splineShape.createSpacedPointsGeometry( );

  addGeometry( california3d, californiaPoints, californiaSpacedPoints, 0xffaa00, -300.0, -100.0, 0.0, 0.0, 0.0, 0.0, 0.25 );
  addGeometry( triangle3d, trianglePoints, triangleSpacedPoints, 0xffee00, -180.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 );
  addGeometry( roundedRect3d, roundedRectPoints, roundedRectSpacedPoints, 0x005500, -150.0, 150.0, 0.0, 0.0, 0.0, 0.0, 1.0 );
  addGeometry( square3d, squarePoints, squareSpacedPoints, 0x0055ff, 150.0, 100.0, 0.0, 0.0, 0.0, 0.0, 1.0 );
  addGeometry( heart3d, heartPoints, heartSpacedPoints, 0xff1100, 0.0, 100.0, 0.0, Math.PI, 0.0, 0.0, 1.0 );
  addGeometry( circle3d, circlePoints, circleSpacedPoints, 0x00ff11, 120.0, 250.0, 0.0, 0.0, 0.0, 0.0, 1.0 );
  addGeometry( fish3d, fishPoints, fishSpacedPoints, 0x222222, -60.0, 200.0, 0.0, 0.0, 0.0, 0.0, 1.0 );
  addGeometry( splineShape3d, splinePoints, splineSpacedPoints, 0x888888, -50.0, -100.0, -50.0, 0.0, 0.0, 0.0, 0.2 );
  addGeometry( arc3d, arcPoints, arcSpacedPoints, 0xbb4422, 150.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0 );
  addGeometry( smiley3d, smileyPoints, smileySpacedPoints, 0xee00ff, -270.0, 250.0, 0.0, Math.PI, 0.0, 0.0, 1.0 );


  //

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  renderer.sortObjects = false;

  container.nodes.add( renderer.domElement );

  mouseEvts = [
               document.onMouseDown.listen(onDocumentMouseDown),
               document.onTouchStart.listen(onDocumentTouchStart),
               document.onTouchMove.listen(onDocumentTouchMove)
               ];


  window.onResize.listen(onWindowResize);
}

onWindowResize(event) {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

void cancelMouseEvts() {
  mouseEvts.forEach((s) => s.cancel());
  mouseEvts = [];
}

onDocumentMouseDown(MouseEvent event) {
  event.preventDefault();

  mouseEvts = [
               document.onMouseMove.listen(onDocumentMouseMove ),
               document.onMouseUp.listen(onDocumentMouseUp ),
               document.onMouseOut.listen( onDocumentMouseOut )
               ];

  mouseXOnMouseDown = event.client.x - windowHalfX;
  targetRotationOnMouseDown = targetRotation;
}

onDocumentMouseMove(MouseEvent event) {
  mouseX = event.client.x - windowHalfX;
  targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.02;
}

onDocumentMouseUp( event ) {
  cancelMouseEvts();
}

onDocumentMouseOut( event ) {
  cancelMouseEvts();
}

onDocumentTouchStart( TouchEvent event ) {

  if ( event.touches.length == 1 ) {

    event.preventDefault();

    mouseXOnMouseDown = event.touches[ 0 ].page.x - windowHalfX;
    targetRotationOnMouseDown = targetRotation;

  }

}

onDocumentTouchMove( TouchEvent event ) {

  if ( event.touches.length == 1 ) {

    event.preventDefault();

    mouseX = event.touches[ 0 ].page.x - windowHalfX;
    targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.05;

  }

}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

render() {

  parent.rotation.y += ( targetRotation - parent.rotation.y ) * 0.05;

  renderer.render( scene, camera );

}
