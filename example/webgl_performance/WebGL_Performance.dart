#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');
//#import('package:stats/stats.dart');

class WebGL_Performance  {
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;

  //Stats stats;
  
  var windowHalfX, windowHalfY;
  var mouseX = 0, mouseY = 0;
  
  List objects = [];
  
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
    camera.position.z = 3200;

    scene = new Scene();

    var material = new MeshNormalMaterial( shading: Three.SmoothShading );

    var loader = new JSONLoader();
    loader.load( 'obj/Suzanne.js', ( geometry ) {

      geometry.computeVertexNormals();

      var rnd = new Math.Random();
      
      for ( var i = 0; i < 5000; i ++ ) {

        var mesh = new Mesh( geometry, material );

        mesh.position.x = rnd.nextDouble() * 8000 - 4000;
        mesh.position.y = rnd.nextDouble() * 8000 - 4000;
        mesh.position.z = rnd.nextDouble() * 8000 - 4000;
        mesh.rotation.x = rnd.nextDouble() * 360 * ( Math.PI / 180 );
        mesh.rotation.y = rnd.nextDouble() * 360 * ( Math.PI / 180 );
        mesh.scale.x = mesh.scale.y = mesh.scale.z = rnd.nextDouble() * 50 + 100;

        objects.add( mesh );

        scene.add( mesh );

      }

    } );

    renderer = new WebGLRenderer( clearColorHex: 0xffffff );
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.elements.add( renderer.domElement );

    /*
    stats = new Stats();
    stats.container.style.position = 'absolute';
    stats.container.style.top = '0px';
    stats.container.style.zIndex = '100';
    container.elements.add( stats.container );
    */

    window.on.resize.add( onWindowResize, false );
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
    //stats.update();
  }
  
  render() {

    camera.position.x += ( mouseX - camera.position.x ) * .05;
    camera.position.y += ( - mouseY - camera.position.y ) * .05;
    camera.lookAt( scene.position );

    for ( var i = 0, il = objects.length; i < il; i ++ ) {

      objects[ i ].rotation.x += 0.01;
      objects[ i ].rotation.y += 0.02;

    }


    renderer.render( scene, camera );

  }
  
}

void main() {
  new WebGL_Performance().run();
}
