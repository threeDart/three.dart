import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart' as THREE;
import 'package:three/extras/scene_utils.dart' as SceneUtils;

Element container;

THREE.PerspectiveCamera camera;
THREE.Scene scene;
THREE.WebGLRenderer renderer;

var windowHalfX, windowHalfY;
var mouseX = 0;
var mouseXOnMouseDown = 0;
var mouseEvts = [];

var targetRotation = 0;
var targetRotationOnMouseDown = 0;

THREE.Object3D parent, text, plane;

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  init();
  animate(0);
}

_addGeometry( geometry, color, x, y, z, rx, ry, rz, s ) {

  // 3d shape

  var mesh = SceneUtils.createMultiMaterialObject( geometry,
      [ new THREE.MeshLambertMaterial( color: color, opacity: 0.2, transparent: true  ),
        new THREE.MeshBasicMaterial( color: 0x000000, wireframe: true,  opacity: 0.3  ) ] );

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

  camera = new THREE.PerspectiveCamera( 50.0, window.innerWidth / window.innerHeight, 1.0, 1000.0 );
  camera.position.setValues( 0.0, 150.0, 500.0 );

  scene = new THREE.Scene();

  var light = new THREE.DirectionalLight( 0xffffff );
  light.position.setValues( 0.0, 0.0, 1.0 );
  scene.add( light );

  parent = new THREE.Object3D();
  parent.position.y = 50.0;
  scene.add( parent );

  var extrudeAmount = 200,
      extrudeBevelEnabled = true,
      extrudeBevelSegments = 2;

  extrudeBevelEnabled = false;

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

  var starShape = new THREE.Shape( pts );

  var rnd = new Math.Random();

  var line = new THREE.LineCurve3(new Vector3.zero(), new Vector3(100.0, 0.0, 0.0));
  var line2 = new THREE.LineCurve3(new Vector3(100.0, 0.0, 0.0),new Vector3(200.0, 50.0, 0.0));

  var curvepath = new THREE.CurvePath();
  curvepath.add(line);
  curvepath.add(line2);


  var randomPoints = [new Vector3(200.0, 50.0, 0.0)];

  for ( var i = 0; i < 5; i ++ ) {

    randomPoints.add( new Vector3(rnd.nextDouble() * 200,rnd.nextDouble() * 200,rnd.nextDouble() * 200 ) );

  }

  var randomSpline =  new THREE.SplineCurve3( randomPoints );
  curvepath.add(randomSpline);



  var extrudeUSteps = new List();
  var curvepathLength = curvepath.length;
  var initU = 0;
  var curveSteps = 40;

  for(var curve in curvepath.curves){

    if(curve is THREE.LineCurve3){
      // Straight so we only need one step
      initU += (curve.length ~/ curvepathLength);
      extrudeUSteps.add(initU);

    } else {
      // Not Straight so we subdivide the curve steps in 'curve_steps' divisions
        for ( var d = 0; d <= curveSteps; d ++ ) {
          extrudeUSteps.add(initU + ((d / curveSteps) * (curve.length / curvepathLength)) );
        }
        initU = extrudeUSteps.last;
      }
  }
  print("[WebGL_Geometry_Extrude_By_U_Shapes] ${extrudeUSteps}");

  var extrude_extrudePath =  curvepath;

  // Circle

  var circleRadius = 4.0;
  var circleShape = new THREE.Shape();
  circleShape.moveTo( 0, circleRadius );
  circleShape.quadraticCurveTo( circleRadius, circleRadius, circleRadius, 0.0 );
  circleShape.quadraticCurveTo( circleRadius, -circleRadius, 0.0, -circleRadius );
  circleShape.quadraticCurveTo( -circleRadius, -circleRadius, -circleRadius, 0.0 );
  circleShape.quadraticCurveTo( -circleRadius, circleRadius, 0.0, circleRadius);

  var rectLength = 12.0, rectWidth = 4.0;

  var rectShape = new THREE.Shape();

  rectShape.moveTo( -rectLength/2, -rectWidth/2 );
  rectShape.lineTo( -rectLength/2, rectWidth/2 );
  rectShape.lineTo( rectLength/2, rectWidth/2 );
  rectShape.lineTo( rectLength/2, -rectLength/2 );
  rectShape.lineTo( -rectLength/2, -rectLength/2 );


  // Smiley

  var smileyShape = new THREE.Shape();
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
      amount: extrudeAmount,
      bevelSegments: extrudeBevelSegments,
      bevelEnabled: extrudeBevelEnabled,
      steps: extrudeUSteps,
      extrudePath: extrude_extrudePath ); //circleShape rectShape smileyShape starShape
  // var circle3d = new ExtrudeGeometry(circleShape, extrudeBend, extrudeSettings );

  var tube = new THREE.TubeGeometry(extrude_extrudePath, 40, 4.0, 5, false, true);
  // new TubeGeometry(extrudePath, segments, 2, radiusSegments, closed2, debug);


  _addGeometry( circle3d, 0xff1111,  -100,  0, 0,     0, 0, 0, 1 );
  _addGeometry( tube, 0x00ff11,  0,  0, 0,     0, 0, 0, 1 );

  renderer = new THREE.WebGLRenderer();
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
  document.onMouseUp.listen( onDocumentMouseUp ),
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

void animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

render() {

  parent.rotation.y += ( targetRotation - parent.rotation.y ) * 0.05;

  renderer.render( scene, camera );

}
