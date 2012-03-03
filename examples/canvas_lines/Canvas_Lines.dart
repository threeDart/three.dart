#import('dart:html');
#import('../../src/ThreeD.dart');

class Canvas_Lines {
  Element container;
  PerspectiveCamera camera;
  Scene scene;
  CanvasRenderer renderer;
  IParticleMaterial material;
  Geometry geometry;
  
  var mouseX = 0, mouseY = 0;
  var windowHalfX = 0;
  var windowHalfY = 0;
  
  Canvas_Lines() {
  }

  init() {
    Particle particle; 
    windowHalfX = (window.innerWidth / 2).toInt();
    windowHalfY = (window.innerHeight / 2).toInt();
    
    container = new Element.tag('div');
    document.body.nodes.add( container );
    
    Element info = new Element.tag('div');
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = '<a href="http://github.com/robsilv/three.dart" target="_blank">three.dart</a> - clickable objects';
    container.nodes.add( info );
    
    camera = new PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 );
    camera.position.z = 100;
    
    scene = new Scene();
    scene.add( camera );
    
    renderer = new CanvasRenderer();
    //renderer.debug = true;
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.nodes.add( renderer.domElement );
    
    // particles
    var PI2 = Math.PI * 2;
    material = new ParticleCanvasMaterial( {
      'color': 0xffffff,
      'program': function (CanvasRenderingContext2D context ) {
        context.beginPath();
        context.arc( 0, 0, 1, 0, PI2, true );
        context.closePath();
        context.fill();
      }
    });
    
    geometry = new Geometry();

    for ( var i = 0; i < 100; i ++ ) {
      particle = new Particle( material );
      particle.position.x = Math.random() * 2 - 1;
      particle.position.y = Math.random() * 2 - 1;
      particle.position.z = Math.random() * 2 - 1;
      particle.position.normalize();
      particle.position.multiplyScalar( Math.random() * 10 + 450 );
      particle.scale.x = particle.scale.y = 5;
      scene.add( particle );

      geometry.vertices.add( new Vertex( particle.position ) );
    }
   
    // lines

    var line = new Line( geometry, new LineBasicMaterial( { 'color': 0xffffff, 'opacity': 0.5 } ) );
    scene.add( line );

    document.on.mouseMove.add(onDocumentMouseMove);
    document.on.touchStart.add(onDocumentTouchStart);
    document.on.touchMove.add(onDocumentTouchMove);
    
    window.setInterval(f() => animate(), 10);
  }
  
  onDocumentMouseMove(MouseEvent event) {
    mouseX = event.clientX - windowHalfX;
    mouseY = event.clientY - windowHalfY;
  }
  
  onDocumentTouchStart(TouchEvent event) {
    
  }
  
  onDocumentTouchMove(TouchEvent event) {
    
  }
  
  animate() {
    render();
  }
  
  render() {
    camera.position.x += ( mouseX - camera.position.x ) * .05;
    camera.position.y += ( - mouseY + 200 - camera.position.y ) * .05;
    camera.lookAt( scene.position );

    renderer.render( scene, camera );
  }
  
  void run() {
    init();
    animate(); 
  }

}

void main() {
  new Canvas_Lines().run();
}
