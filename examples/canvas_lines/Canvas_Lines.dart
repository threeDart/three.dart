#import('dart:html');
#import('../../src/ThreeD.dart');

class Canvas_Lines {
  Element container;
  PerspectiveCamera camera;
  Scene scene;
  CanvasRenderer renderer;
  IParticleMaterial material;
  Geometry geometry;
  
  int mouseX = 0, mouseY = 0;
  int windowHalfX = 0;
  int windowHalfY = 0;
  
  Canvas_Lines() {
  }

  init() {
    Particle particle; 
    windowHalfX = (window.innerWidth / 2).toInt();
    windowHalfY = (window.innerHeight / 2).toInt();
    
    container = new Element.tag('div');
    document.body.nodes.add( container );
    
    camera = new PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 );
    camera.position.z = 100;
    
    scene = new Scene();
    scene.add( camera );
    
    var options;
//    options = {"debug": true};
    renderer = new CanvasRenderer(options);
    renderer.setSize( window.innerWidth, window.innerHeight );
    container.nodes.add( renderer.domElement );
    
    //TODO: context.arc() "anticlockwise" has to = false in Chrome on Win7 in order to render particles.
    // Not sure why yet... Need to know whether this messes things up on a Mac.
    
    // particles
    final num Tau = Math.PI * 2;
    material = new ParticleCanvasMaterial( {
      'color': 0xffffff,
      'program': function (CanvasRenderingContext2D context ) {
        context.beginPath();
        context.arc( 0, 0, 1, 0, Tau, false );
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
    if ( event.touches.length > 1 ) {

      event.preventDefault();

      mouseX = event.touches[ 0 ].pageX - windowHalfX;
      mouseY = event.touches[ 0 ].pageY - windowHalfY;
    }    
  }
  
  onDocumentTouchMove(TouchEvent event) {
    if ( event.touches.length == 1 ) {

      event.preventDefault();

      mouseX = event.touches[ 0 ].pageX - windowHalfX;
      mouseY = event.touches[ 0 ].pageY - windowHalfY;
    }    
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
