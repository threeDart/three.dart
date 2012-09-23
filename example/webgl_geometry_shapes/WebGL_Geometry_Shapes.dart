#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');
#import('package:three.dart/extras/SceneUtils.dart', prefix:'SceneUtils');
#import('package:three.dart/extras/GeometryUtils.dart', prefix:'GeometryUtils');

class WebGL_Geometry_Shapes  {
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

    camera = new PerspectiveCamera( 50, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.setValues( 0, 150, 500 );

    scene = new Scene();
    
    var light = new DirectionalLight( 0xffffff );
    light.position.setValues( 0, 0, 1 );
    scene.add( light );

    parent = new Object3D();
    parent.position.y = 50;
    scene.add( parent );

    var extrude_amount = 20,
        extrude_bevelEnabled = true, 
        extrude_bevelSegments = 2, 
        extrude_steps = 2; // bevelSegments: 2, steps: 2 , bevelSegments: 5, bevelsize: 8, bevelThickness:5,

    // California

    var californiaPts = [];

    californiaPts.add( new Vector2 ( 610, 320 ) );
    californiaPts.add( new Vector2 ( 450, 300 ) );
    californiaPts.add( new Vector2 ( 392, 392 ) );
    californiaPts.add( new Vector2 ( 266, 438 ) );
    californiaPts.add( new Vector2 ( 190, 570 ) );
    californiaPts.add( new Vector2 ( 190, 600 ) );
    californiaPts.add( new Vector2 ( 160, 620 ) );
    californiaPts.add( new Vector2 ( 160, 650 ) );
    californiaPts.add( new Vector2 ( 180, 640 ) );
    californiaPts.add( new Vector2 ( 165, 680 ) );
    californiaPts.add( new Vector2 ( 150, 670 ) );
    californiaPts.add( new Vector2 (  90, 737 ) );
    californiaPts.add( new Vector2 (  80, 795 ) );
    californiaPts.add( new Vector2 (  50, 835 ) );
    californiaPts.add( new Vector2 (  64, 870 ) );
    californiaPts.add( new Vector2 (  60, 945 ) );
    californiaPts.add( new Vector2 ( 300, 945 ) );
    californiaPts.add( new Vector2 ( 300, 743 ) );
    californiaPts.add( new Vector2 ( 600, 473 ) );
    californiaPts.add( new Vector2 ( 626, 425 ) );
    californiaPts.add( new Vector2 ( 600, 370 ) );
    californiaPts.add( new Vector2 ( 610, 320 ) );

    var californiaShape = new Shape( californiaPts );

    var california3d = new ExtrudeGeometry( [californiaShape], amount: 20 );
    var californiaPoints = californiaShape.createPointsGeometry();
    var californiaSpacedPoints = californiaShape.createSpacedPointsGeometry( 100 );

    // Triangle

    var triangleShape = new Shape();
    triangleShape.moveTo(  80, 20 );
    triangleShape.lineTo(  40, 80 );
    triangleShape.lineTo( 120, 80 );
    triangleShape.lineTo(  80, 20 ); // close path

    var triangle3d = triangleShape.extrude( 
        amount: extrude_amount,
        bevelSegments: extrude_bevelSegments,
        bevelEnabled: extrude_bevelEnabled,
        steps: extrude_steps); 
    var trianglePoints = triangleShape.createPointsGeometry();
    var triangleSpacedPoints = triangleShape.createSpacedPointsGeometry();


    // Heart

    var x = 0, y = 0;

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

    var sqLength = 80;

    var squareShape = new Shape();
    squareShape.moveTo( 0,0 );
    squareShape.lineTo( 0, sqLength );
    squareShape.lineTo( sqLength, sqLength );
    squareShape.lineTo( sqLength, 0 );
    squareShape.lineTo( 0, 0 );

    var square3d = squareShape.extrude( 
        amount: extrude_amount,
        bevelSegments: extrude_bevelSegments,
        bevelEnabled: extrude_bevelEnabled,
        steps: extrude_steps); 
    var squarePoints = squareShape.createPointsGeometry();
    var squareSpacedPoints = squareShape.createSpacedPointsGeometry();

    // Rectangle

    var rectLength = 120, rectWidth = 40;

    var rectShape = new Shape();
    rectShape.moveTo( 0,0 );
    rectShape.lineTo( 0, rectWidth );
    rectShape.lineTo( rectLength, rectWidth );
    rectShape.lineTo( rectLength, 0 );
    rectShape.lineTo( 0, 0 );

    var rect3d = rectShape.extrude( 
        amount: extrude_amount,
        bevelSegments: extrude_bevelSegments,
        bevelEnabled: extrude_bevelEnabled,
        steps: extrude_steps); 
    var rectPoints = rectShape.createPointsGeometry();
    var rectSpacedPoints = rectShape.createSpacedPointsGeometry();

    // Rounded rectangle

    var roundedRectShape = new Shape();
    roundedRect( roundedRectShape, 0, 0, 50, 50, 20 );

    var roundedRect3d = roundedRectShape.extrude( 
        amount: extrude_amount,
        bevelSegments: extrude_bevelSegments,
        bevelEnabled: extrude_bevelEnabled,
        steps: extrude_steps);
    var roundedRectPoints = roundedRectShape.createPointsGeometry();
    var roundedRectSpacedPoints = roundedRectShape.createSpacedPointsGeometry();

    // Circle

    var circleRadius = 40;
    var circleShape = new Shape();
    circleShape.moveTo( 0, circleRadius );
    circleShape.quadraticCurveTo( circleRadius, circleRadius, circleRadius, 0 );
    circleShape.quadraticCurveTo( circleRadius, -circleRadius, 0, -circleRadius );
    circleShape.quadraticCurveTo( -circleRadius, -circleRadius, -circleRadius, 0 );
    circleShape.quadraticCurveTo( -circleRadius, circleRadius, 0, circleRadius );

    var circle3d = circleShape.extrude( 
        amount: extrude_amount,
        bevelSegments: extrude_bevelSegments,
        bevelEnabled: extrude_bevelEnabled,
        steps: extrude_steps);
    var circlePoints = circleShape.createPointsGeometry();
    var circleSpacedPoints = circleShape.createSpacedPointsGeometry();

    // Fish

    x = y = 0;

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
    arcShape.moveTo( 50, 10 );
    arcShape.absarc( 10, 10, 40, 0, Math.PI*2, false );

    var holePath = new Path();
    holePath.moveTo( 20, 10 );
    holePath.absarc( 10, 10, 10, 0, Math.PI*2, true );
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
    smileyShape.moveTo( 80, 40 );
    smileyShape.absarc( 40, 40, 40, 0, Math.PI*2, false );

    var smileyEye1Path = new Path();
    smileyEye1Path.moveTo( 35, 20 );
    // smileyEye1Path.absarc( 25, 20, 10, 0, Math.PI*2, true );
    smileyEye1Path.absellipse( 25, 20, 10, 10, 0, Math.PI*2, true );
    
    smileyShape.holes.add( smileyEye1Path );

    var smileyEye2Path = new Path();
    smileyEye2Path.moveTo( 65, 20 );
    smileyEye2Path.absarc( 55, 20, 10, 0, Math.PI*2, true );
    smileyShape.holes.add( smileyEye2Path );

    var smileyMouthPath = new Path();
    // ugly box mouth
    // smileyMouthPath.moveTo( 20, 40 );
    // smileyMouthPath.lineTo( 60, 40 );
    // smileyMouthPath.lineTo( 60, 60 );
    // smileyMouthPath.lineTo( 20, 60 );
    // smileyMouthPath.lineTo( 20, 40 );

    smileyMouthPath.moveTo( 20, 40 );
    smileyMouthPath.quadraticCurveTo( 40, 60, 60, 40 );
    smileyMouthPath.bezierCurveTo( 70, 45, 70, 50, 60, 60 );
    smileyMouthPath.quadraticCurveTo( 40, 80, 20, 60 );
    smileyMouthPath.quadraticCurveTo( 5, 50, 20, 40 );

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
    splinepts.add( new Vector2 ( 350, 100 ) );
    splinepts.add( new Vector2 ( 400, 450 ) );
    splinepts.add( new Vector2 ( -140, 350 ) );
    splinepts.add( new Vector2 ( 0, 0 ) );

    var splineShape = new Shape(  );
    splineShape.moveTo( 0, 0 );
    splineShape.splineThru( splinepts );

    //splineShape.debug( document.getElementById("debug") );

    // TODO 3d path?

    var apath = new SplineCurve3();
    apath.points.add(new Vector3(-50, 150, 10));
    apath.points.add(new Vector3(-20, 180, 20));
    apath.points.add(new Vector3(40, 220, 50));
    apath.points.add(new Vector3(200, 290, 100));

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

    addGeometry( california3d, californiaPoints, californiaSpacedPoints,  0xffaa00, -300, -100, 0,     0, 0, 0, 0.25 );
    addGeometry( triangle3d, trianglePoints, triangleSpacedPoints,      0xffee00, -180,    0, 0,     0, 0, 0, 1 );
    addGeometry( roundedRect3d, roundedRectPoints, roundedRectSpacedPoints, 0x005500, -150,  150, 0,     0, 0, 0, 1 );
    addGeometry( square3d, squarePoints, squareSpacedPoints,        0x0055ff,  150,  100, 0,     0, 0, 0, 1 );
    addGeometry( heart3d, heartPoints, heartSpacedPoints,         0xff1100,    0,  100, 0,   Math.PI, 0, 0, 1 );
    addGeometry( circle3d, circlePoints, circleSpacedPoints,        0x00ff11,  120,  250, 0,     0, 0, 0, 1 );
    addGeometry( fish3d, fishPoints, fishSpacedPoints,            0x222222,  -60,  200, 0,     0, 0, 0, 1 );
    addGeometry( splineShape3d, splinePoints, splineSpacedPoints,     0x888888,  -50,  -100, -50,  0, 0, 0, 0.2 );
    addGeometry( arc3d, arcPoints, arcSpacedPoints,             0xbb4422,  150,    0, 0,     0, 0, 0, 1 );
    addGeometry( smiley3d, smileyPoints, smileySpacedPoints,        0xee00ff,  -270,    250, 0,  Math.PI, 0, 0, 1 );


    //
      
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
  new WebGL_Geometry_Shapes().run();
}
