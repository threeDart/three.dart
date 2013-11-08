import 'dart:html' hide Path;
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/scene_utils.dart' as SceneUtils;

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

_addGeometry( geometry, color, x, y, z, rx, ry, rz, s ) {

  // 3d shape

  var mesh = SceneUtils.createMultiMaterialObject( geometry,
      [ new MeshLambertMaterial( color: color, opacity: 0.2, transparent: true  ),
        new MeshBasicMaterial( color: 0x000000, wireframe: true,  opacity: 0.3  ) ] );

  mesh.position.setValues( x.toDouble(), y.toDouble(), z.toDouble() - 75 );
  // mesh.rotation.set( rx, ry, rz );
  double ds = s.toDouble();
  mesh.scale.setValues( ds, ds, ds );

  // if ( geometry.debug ) mesh.add( geometry.debug );

  parent.add( mesh );

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

  var extrude_amount = 200,
      extrude_bevelEnabled = true,
      extrude_bevelSegments = 2,
      extrude_steps = 150; // bevelSegments: 2, steps: 2 , bevelSegments: 5, bevelSize: 8, bevelThickness:5,

  // var extrudePath = new Path();

  // extrudePath.moveTo( 0, 0 );
  // extrudePath.lineTo( 10, 10 );
  // extrudePath.quadraticCurveTo( 80, 60, 160, 10 );
  // extrudePath.quadraticCurveTo( 240, -40, 320, 10 );


  extrude_bevelEnabled = false;

  var extrudeBend = new SplineCurve3( //Closed
      [

        new Vector3( 30.0, 12.0, 83.0),
        new Vector3( 40.0, 20.0, 67.0),
        new Vector3( 60.0, 40.0, 99.0),
        new Vector3( 10.0, 60.0, 49.0),
        new Vector3( 25.0, 80.0, 40.0)

      ]);

  var pipeSpline = new SplineCurve3([
    new Vector3(0.0, 10.0, -10.0),
    new Vector3(10.0, 0.0, -10.0),
    new Vector3(20.0, 0.0, 0.0),
    new Vector3(30.0, 0.0, 10.0),
    new Vector3(30.0, 0.0, 20.0),
    new Vector3(20.0, 0.0, 30.0),
    new Vector3(10.0, 0.0, 30.0),
    new Vector3(0.0, 0.0, 30.0),
    new Vector3(-10.0, 10.0, 30.0),
    new Vector3(-10.0, 20.0, 30.0),
    new Vector3(0.0, 30.0, 30.0),
    new Vector3(10.0, 30.0, 30.0),
    new Vector3(20.0, 30.0, 15.0),
    new Vector3(10.0, 30.0, 10.0),
    new Vector3(0.0, 30.0, 10.0),
    new Vector3(-10.0, 20.0, 10.0),
    new Vector3(-10.0, 10.0, 10.0),
    new Vector3(0.0, 0.0, 10.0),
    new Vector3(10.0, -10.0, 10.0),
    new Vector3(20.0, -15.0, 10.0),
    new Vector3(30.0, -15.0, 10.0),
    new Vector3(40.0, -15.0, 10.0),
    new Vector3(50.0, -15.0, 10.0),
    new Vector3(60.0, 0.0, 10.0),
    new Vector3(70.0, 0.0, 0.0),
    new Vector3(80.0, 0.0, 0.0),
    new Vector3(90.0, 0.0, 0.0),
    new Vector3(100.0, 0.0, 0.0)]
  );

  var sampleClosedSpline = new ClosedSplineCurve3([
    new Vector3(0.0, -40.0, -40.0),
    new Vector3(0.0, 40.0, -40.0),
    new Vector3(0.0, 140.0, -40.0),
    new Vector3(0.0, 40.0, 40.0),
    new Vector3(0.0, -40.0, 40.0),
  ]);

  var randomPoints = [];
  var rnd = new Math.Random();

  for ( var i = 0; i < 10; i ++ ) {

    randomPoints.add( new Vector3(rnd.nextDouble() * 200, rnd.nextDouble() * 200, rnd.nextDouble() * 200 ) );

  }

  var randomSpline =  new SplineCurve3( randomPoints );

  var extrude_extrudePath = randomSpline; // extrudeBend sampleClosedSpline pipeSpline randomSpline

  // Circle

  var circleRadius = 4.0;
  var circleShape = new Shape();
  circleShape.moveTo( 0, circleRadius );
  circleShape.quadraticCurveTo( circleRadius, circleRadius, circleRadius, 0 );
  circleShape.quadraticCurveTo( circleRadius, -circleRadius, 0, -circleRadius );
  circleShape.quadraticCurveTo( -circleRadius, -circleRadius, -circleRadius, 0 );
  circleShape.quadraticCurveTo( -circleRadius, circleRadius, 0, circleRadius);

  var rectLength = 12, rectWidth = 4;

  var rectShape = new Shape();

  rectShape.moveTo( -rectLength/2, -rectWidth/2 );
  rectShape.lineTo( -rectLength/2, rectWidth/2 );
  rectShape.lineTo( rectLength/2, rectWidth/2 );
  rectShape.lineTo( rectLength/2, -rectLength/2 );
  rectShape.lineTo( -rectLength/2, -rectLength/2 );


  var pts = [], starPoints = 5, l;

  for ( var i = 0; i < starPoints * 2; i ++ ) {

    if ( i % 2 == 1 ) {

      l = 5;

    } else {

      l = 10;

    }

    var a = i / starPoints * Math.PI;
    pts.add( new Vector2 ( Math.cos( a ) * l, Math.sin( a ) * l ) );

  }

  var starShape = new Shape( pts );

  // Smiley

  var smileyShape = new Shape();
  smileyShape.moveTo( 80, 40 );
  smileyShape.arc( 40, 40, 40, 0, Math.PI*2, false );

  var smileyEye1Path = new Path();
  smileyEye1Path.moveTo( 35, 20 );
  smileyEye1Path.arc( 25, 20, 10, 0, Math.PI*2, true );
  smileyShape.holes.add( smileyEye1Path );

  var smileyEye2Path = new Path();
  smileyEye2Path.moveTo( 65, 20 );
  smileyEye2Path.arc( 55, 20, 10, 0, Math.PI*2, true );
  smileyShape.holes.add( smileyEye2Path );

  var smileyMouthPath = new Path();

  smileyMouthPath.moveTo( 20, 40 );
  smileyMouthPath.quadraticCurveTo( 40, 60, 60, 40 );
  smileyMouthPath.bezierCurveTo( 70, 45, 70, 50, 60, 60 );
  smileyMouthPath.quadraticCurveTo( 40, 80, 20, 60 );
  smileyMouthPath.quadraticCurveTo( 5, 50, 20, 40 );

  smileyShape.holes.add( smileyMouthPath );

  var circle3d = starShape.extrude(
      amount: extrude_amount,
      bevelSegments: extrude_bevelSegments,
      bevelEnabled: extrude_bevelEnabled,
      steps: extrude_steps,
      extrudePath: extrude_extrudePath ); //circleShape rectShape smileyShape starShape
  // var circle3d = new ExtrudeGeometry(circleShape, extrudeBend, extrudeSettings );

  var tube = new TubeGeometry(extrude_extrudePath, 150, 4.0, 5, false, true);
  // new TubeGeometry(extrudePath, segments, 2, radiusSegments, closed2, debug);


  _addGeometry( circle3d, 0xff1111,  -100,  0, 0,     0, 0, 0, 1 );
  _addGeometry( tube, 0x00ff11,  0,  0, 0,     0, 0, 0, 1 );

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
