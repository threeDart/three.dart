#import('dart:html');
#import('../../src/ThreeD.dart');

class Canvas_Geometry_Cube 
{
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  CanvasRenderer renderer;

  Mesh cube;
  Mesh plane;

  num targetRotation;
  num targetRotationOnMouseDown;

  num mouseX;
  num mouseXOnMouseDown;

  num windowHalfX;
  num windowHalfY;
  
  Canvas_Geometry_Cube() 
  {
    
  }
  
  void run() 
  {
    init();
    animate();
  }
  
  void init()
  {
    targetRotation = 0;
    targetRotationOnMouseDown = 0;

    mouseX = 0;
    mouseXOnMouseDown = 0;

    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
    container = new Element.tag('div');
    //document.body.appendChild( container );
    document.body.nodes.add( container );

    Element info = new Element.tag('div');
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = 'Drag to spin the cube';
    //container.appendChild( info );
    container.nodes.add( info );

    scene = new Scene();

    camera = new PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.y = 150;
    camera.position.z = 500;
    scene.add( camera );

    // Cube

    List materials = [];

    for ( int i = 0; i < 6; i ++ ) {
      materials.add( new MeshBasicMaterial( { 'color' : Math.random() * 0xffffff } ) );
    }

    cube = new Mesh( new CubeGeometry( 200, 200, 200, 1, 1, 1, materials ), new MeshFaceMaterial());// { 'overdraw' : true }) );
    cube.position.y = 150;
    //cube.overdraw = true; //TODO where is this prop?
    scene.add( cube );

    // Plane

    plane = new Mesh( new PlaneGeometry( 200, 200 ), new MeshBasicMaterial( { 'color': 0xe0e0e0, 'overdraw' : true } ) );
    plane.rotation.x = - 90 * ( Math.PI / 180 );
    //plane.overdraw = true; //TODO where is this prop?
    scene.add( plane );

    renderer = new CanvasRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    
    
    //container.appendChild( renderer.domElement );
    container.nodes.add( renderer.domElement );
   
    document.on.mouseDown.add(onDocumentMouseDown);
    document.on.touchStart.add(onDocumentTouchStart);
    document.on.touchMove.add(onDocumentTouchMove);

    window.setInterval(f() => animate(), 10);
  }

  void onDocumentMouseDown( event )
  {
    event.preventDefault();
    
    document.on.mouseMove.add(onDocumentMouseMove);
    document.on.mouseUp.add(onDocumentMouseUp);
    document.on.mouseOut.add(onDocumentMouseOut);

    mouseXOnMouseDown = event.clientX - windowHalfX;
    targetRotationOnMouseDown = targetRotation;
    
    print('onMouseDown mouseX = $mouseXOnMouseDown targRot = $targetRotationOnMouseDown');
  }

  void onDocumentMouseMove( event ) 
  {
    mouseX = event.clientX - windowHalfX;

    targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.02;
    
    print('onMouseMove mouseX = $mouseX targRot = $targetRotation');
  }

  void onDocumentMouseUp( event )
  {
    print('onDocumentMouseUp');
    document.on.mouseMove.remove(onDocumentMouseMove);
    document.on.mouseUp.remove(onDocumentMouseUp);
    document.on.mouseOut.remove(onDocumentMouseOut);    
  }

  void onDocumentMouseOut( event ) 
  {
    document.on.mouseMove.remove(onDocumentMouseMove);
    document.on.mouseUp.remove(onDocumentMouseUp);
    document.on.mouseOut.remove(onDocumentMouseOut);  
  }

  void onDocumentTouchStart( event )
  {
    if ( event.touches.length == 1 ) 
    {
      event.preventDefault();

      mouseXOnMouseDown = event.touches[ 0 ].pageX - windowHalfX;
      targetRotationOnMouseDown = targetRotation;
    }
  }

  void onDocumentTouchMove( event )
  {
    if ( event.touches.length == 1 ) 
    {
      event.preventDefault();

      mouseX = event.touches[ 0 ].pageX - windowHalfX;
      targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.05;
    }
  }
  
  
  void animate()
  {
//    window.webkitRequestAnimationFrame(animate);
//    print('win dynamic ${window.dynamic['requestAnimationFrame']}');
//    if ( window.dynamic['requestAnimationFrame'] != null )
//      window.dynamic['requestAnimationFrame']( animate );

    render();
  }

  void render()
  {
    plane.rotation.z = cube.rotation.y += ( targetRotation - cube.rotation.y ) * 0.05;
    renderer.render( scene, camera );
  }
}

void main() {
  new Canvas_Geometry_Cube().run();
}
