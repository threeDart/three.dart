#import('dart:html');
#import('dart:math', prefix:'Math');
#import('../../src/ThreeD.dart');

class WebGL_Geometry_Hierarchy  {
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;

  var windowHalfX, windowHalfY;
  var mouseX = 0, mouseY = 0;
  
  Object3D group;
  
  void run() {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
    document.on.mouseMove.add(onDocumentMouseMove, false );
    
    init();
    animate(0);
  }
  
  void init() {
    
    container = new Element.tag('div');
    document.body.nodes.add( container );

    camera = new PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 10000 );
    camera.position.z = 500;

    scene = new Scene();
    scene.fog = new Fog( 0xffffff, 1, 10000 );
    scene.add(camera);
    
    var geometry = new CubeGeometry( 100, 100, 100 );
    var material = new MeshNormalMaterial();

    group = new Object3D();

    var rnd = new Math.Random();
    
    for ( var i = 0; i < 1000; i ++ ) {

      var mesh = new Mesh( geometry, material );
      mesh.position.x = rnd.nextInt(2000) - 1000;
      mesh.position.y = rnd.nextInt(2000) - 1000;
      mesh.position.z = rnd.nextInt(2000) - 1000;

      mesh.rotation.x = rnd.nextDouble() * 360 * ( Math.PI / 180 );
      mesh.rotation.y = rnd.nextDouble() * 360 * ( Math.PI / 180 );

      mesh.matrixAutoUpdate = false;
      mesh.updateMatrix();

      group.add( mesh );

    }

    scene.add( group );

    renderer = new WebGLRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.sortObjects = false;
    
    container.nodes.add( renderer.domElement );
    
    window.on.resize.add(onWindowResize);
  }
  
  onWindowResize(event) {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );
  }

  onDocumentMouseMove(MouseEvent event) {
    mouseX = ( event.clientX - windowHalfX ) * 10;
    mouseY = ( event.clientY - windowHalfY ) * 10;
  }
  
  bool animate(int time) {
    window.requestAnimationFrame( animate );
    render();
  }
  
  render() {

    var time = new Date.now().millisecondsSinceEpoch * 0.001;

    var rx = Math.sin( time * 0.7 ) * 0.5,
        ry = Math.sin( time * 0.3 ) * 0.5,
        rz = Math.sin( time * 0.2 ) * 0.5;

    camera.position.x += ( mouseX - camera.position.x ) * .05;
    camera.position.y += ( - mouseY - camera.position.y ) * .05;

    camera.lookAt( scene.position );

    group.rotation.x = rx;
    group.rotation.y = ry;
    group.rotation.z = rz;

    renderer.render( scene, camera );

  }
  
}

void main() {
  new WebGL_Geometry_Hierarchy().run();
}
