#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');
#import('package:three.dart/extras/SceneUtils.dart', prefix:'SceneUtils');

class WebGL_Geometry_Extrude_Shapes  {
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;

  var windowHalfX, windowHalfY;
  var mouseX = 0;
  var mouseXOnMouseDown = 0;
  
  var targetRotation = 0;
  var targetRotationOnMouseDown = 0;
  
  Object3D parent, text, plane;
  
  void run() {
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

    mesh.position.setValues( x, y, z - 75 );
    // mesh.rotation.set( rx, ry, rz );
    mesh.scale.setValues( s, s, s );

    // if ( geometry.debug ) mesh.add( geometry.debug );

    parent.add( mesh );

  }
  
  void init() {
    
    container = new Element.tag('div');
    document.body.nodes.add( container );

    camera = new PerspectiveCamera( 50, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.setValues( 0, 150, 500 );

    scene = new Scene();
    
    var light = new DirectionalLight( 0xffffff );
    light.position.setValues( 0, 0, 1 );
    scene.add( light );

    parent = new Object3D();
    parent.position.y = 50;
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

          new Vector3( 30, 12, 83),
          new Vector3( 40, 20, 67),
          new Vector3( 60, 40, 99),
          new Vector3( 10, 60, 49),
          new Vector3( 25, 80, 40)

        ]);

    var pipeSpline = new SplineCurve3([
      new Vector3(0, 10, -10), 
      new Vector3(10, 0, -10), 
      new Vector3(20, 0, 0), 
      new Vector3(30, 0, 10), 
      new Vector3(30, 0, 20), 
      new Vector3(20, 0, 30), 
      new Vector3(10, 0, 30), 
      new Vector3(0, 0, 30), 
      new Vector3(-10, 10, 30), 
      new Vector3(-10, 20, 30), 
      new Vector3(0, 30, 30), 
      new Vector3(10, 30, 30), 
      new Vector3(20, 30, 15), 
      new Vector3(10, 30, 10), 
      new Vector3(0, 30, 10), 
      new Vector3(-10, 20, 10), 
      new Vector3(-10, 10, 10), 
      new Vector3(0, 0, 10), 
      new Vector3(10, -10, 10), 
      new Vector3(20, -15, 10), 
      new Vector3(30, -15, 10), 
      new Vector3(40, -15, 10), 
      new Vector3(50, -15, 10), 
      new Vector3(60, 0, 10), 
      new Vector3(70, 0, 0), 
      new Vector3(80, 0, 0), 
      new Vector3(90, 0, 0), 
      new Vector3(100, 0, 0)]
    );

    var sampleClosedSpline = new ClosedSplineCurve3([
      new Vector3(0, -40, -40),
      new Vector3(0, 40, -40),
      new Vector3(0, 140, -40),
      new Vector3(0, 40, 40),
      new Vector3(0, -40, 40),
    ]);

    var randomPoints = [];
    var rnd = new Math.Random();
    
    for ( var i = 0; i < 10; i ++ ) {

      randomPoints.add( new Vector3(rnd.nextDouble() * 200, rnd.nextDouble() * 200, rnd.nextDouble() * 200 ) );

    }

    var randomSpline =  new SplineCurve3( randomPoints );

    var extrude_extrudePath = randomSpline; // extrudeBend sampleClosedSpline pipeSpline randomSpline

    // Circle

    var circleRadius = 4;
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

    var tube = new TubeGeometry(extrude_extrudePath, 150, 4, 5, false, true);
    // new TubeGeometry(extrudePath, segments, 2, radiusSegments, closed2, debug);


    _addGeometry( circle3d, 0xff1111,  -100,  0, 0,     0, 0, 0, 1 );
    _addGeometry( tube, 0x00ff11,  0,  0, 0,     0, 0, 0, 1 );
      
    renderer = new WebGLRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.sortObjects = false;
    
    container.nodes.add( renderer.domElement );
    
    document.on.mouseDown.add(onDocumentMouseDown, false);
    document.on.touchStart.add(onDocumentTouchStart, false);
    document.on.touchMove.add(onDocumentTouchMove, false);
    
    window.on.resize.add(onWindowResize);
  }
  
  onWindowResize(event) {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );
  }

  onDocumentMouseDown(MouseEvent event) {
    event.preventDefault();

    document.on.mouseMove.add(onDocumentMouseMove, false );
    document.on.mouseUp.add(onDocumentMouseUp, false );
    document.on.mouseOut.add( onDocumentMouseOut, false );

    mouseXOnMouseDown = event.clientX - windowHalfX;
    targetRotationOnMouseDown = targetRotation;
  }
  
  onDocumentMouseMove(MouseEvent event) {
    mouseX = event.clientX - windowHalfX;
    targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.02;
  }
  
  onDocumentMouseUp( event ) {
    document.on.mouseMove.remove(onDocumentMouseMove, false );
    document.on.mouseUp.remove(onDocumentMouseUp, false );
    document.on.mouseOut.remove(onDocumentMouseOut, false );

  }

  onDocumentMouseOut( event ) {

    document.on.mouseMove.remove(onDocumentMouseMove, false );
    document.on.mouseUp.remove(onDocumentMouseUp, false );
    document.on.mouseOut.remove(onDocumentMouseOut, false );

  }

  onDocumentTouchStart( TouchEvent event ) {

    if ( event.touches.length == 1 ) {

      event.preventDefault();

      mouseXOnMouseDown = event.touches[ 0 ].pageX - windowHalfX;
      targetRotationOnMouseDown = targetRotation;

    }

  }

  onDocumentTouchMove( TouchEvent event ) {

    if ( event.touches.length == 1 ) {

      event.preventDefault();

      mouseX = event.touches[ 0 ].pageX - windowHalfX;
      targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.05;

    }

  }
  
  bool animate(int time) {
    window.requestAnimationFrame( animate );
    render();
  }
  
  render() {

    parent.rotation.y += ( targetRotation - parent.rotation.y ) * 0.05;

    renderer.render( scene, camera );

  }
  
}

void main() {
  new WebGL_Geometry_Extrude_Shapes().run();
}
