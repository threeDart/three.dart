#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');

class Canvas_Geometry_Hierarchy 
{
  Element container;// stats;

  PerspectiveCamera camera;
  Scene scene;
  CanvasRenderer renderer;

  CubeGeometry geometry;
  Object3D group;

  num mouseX = 0, mouseY = 0;

  num windowHalfX;
  num windowHalfY;
  
  Canvas_Geometry_Hierarchy() 
  {
    
  }

  void run() 
  {
    document.on.mouseMove.add( onDocumentMouseMove, false );

    init();
    animate();
  }
  

  void init()
  {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
//    container = document.createElement( 'div' );
//    document.body.appendChild( container );

    container = new Element.tag('div');
    document.body.nodes.add( container );
    
    scene = new Scene();

    camera = new PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 10000 );
    camera.position.z = 500;
  
    //camera.target = new Vector3(); //TODO: No such property?
    scene.add( camera );

    List materials = [];

    var rnd = new Math.Random();
    for ( int i = 0; i < 6; i ++ ) {
      materials.add( new MeshBasicMaterial( color:  rnd.nextDouble() * 0xffffff ) );
    }
    
    geometry = new CubeGeometry( 100, 100, 100 );
    MeshNormalMaterial material = new MeshNormalMaterial();
    
    group = new Object3D();

    for ( var i = 0; i < 200; i ++ ) 
    {
      Mesh mesh = new Mesh( geometry, material );
      //mesh.overdraw = true; //TODO: No such property?
      mesh.position.x = rnd.nextInt(2000) - 1000;
      mesh.position.y = rnd.nextInt(2000) - 1000;
      mesh.position.z = rnd.nextInt(2000) - 1000;
      mesh.rotation.x = rnd.nextInt(360) * ( Math.PI / 180 );
      mesh.rotation.y = rnd.nextInt(360) * ( Math.PI / 180 );
      mesh.matrixAutoUpdate = false;
      mesh.updateMatrix();
      group.add( mesh );
    }
    
    scene.add( group );

    var options;
//    options = {"debug": true};
    renderer = new CanvasRenderer(options);
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.sortObjects = false;
    //container.appendChild( renderer.domElement );
    container.nodes.add( renderer.domElement );

//    stats = new Stats();
//    stats.domElement.style.position = 'absolute';
//    stats.domElement.style.top = '0px';
//    stats.domElement.style.zIndex = 100;
//    container.appendChild( stats.domElement );

    window.setInterval(f() => animate(), 10);
  }

  void onDocumentMouseMove(event) 
  {
    mouseX = ( event.clientX - windowHalfX ) * 10;
    mouseY = ( event.clientY - windowHalfY ) * 10;
  }

  void animate() 
  {
    //requestAnimationFrame( animate );
   //window.webkitRequestAnimationFrame(callback)
    
    render();
    //stats.update();
  }

  void render() 
  {
    camera.position.x += ( mouseX - camera.position.x ) * .05;
    camera.position.y += ( - mouseY - camera.position.y ) * .05;
    camera.lookAt( scene.position );

    //TODO describe how this oscillation affects the example
    num t = new Date.now().millisecondsSinceEpoch;
    var oscillate = (num rate) => Math.sin(t * rate) * 0.5;
    group.rotation.x = oscillate( 0.0007 );
    group.rotation.y = oscillate( 0.0003 );
    group.rotation.z = oscillate( 0.0002 );

    renderer.render( scene, camera );
  }
}

void main() {
  new Canvas_Geometry_Hierarchy().run();
}
