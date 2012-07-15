#import('dart:html');
#import('../../src/ThreeD.dart');

class Canvas_Interactive_Cubes 
{
  Element container;//, stats;
  PerspectiveCamera camera;
  Scene scene;
  Projector projector;
  CanvasRenderer renderer;
  IParticleMaterial particleMaterial;

  List<Mesh> objects;
  
  final num radius = 600;
  num theta = 0;

  Canvas_Interactive_Cubes() 
  {
    
  }

  void run() 
  {
    init();
    animate(); 
  }
  
  void init()
  {
    objects = [];
    
    container = new Element.tag('div');
    document.body.nodes.add( container );
    
    Element info = new Element.tag('div');
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = '<a href="http://github.com/robsilv/three.dart" target="_blank">three.dart</a> - clickable objects';
    container.nodes.add( info );

    camera = new PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 10000 );
    camera.position.setValues( 0, 300, 500 );

    scene = new Scene();

    scene.add( camera );

    CubeGeometry geometry = new CubeGeometry( 100, 100, 100 );

    for ( int i = 0; i < 10; i ++ )
    {
      Particle particle = new Particle( particleMaterial );
      particle.position.x = Math.random() * 800 - 400;
      particle.position.y = Math.random() * 800 - 400;
      particle.position.z = Math.random() * 800 - 400;
      particle.scale.x = particle.scale.y = 8;
      scene.add( particle );
      
      Mesh object = new Mesh( geometry, new MeshBasicMaterial( { 'color': Math.random() * 0xffffff, 'opacity': 0.5 } ) );
      object.position.x = Math.random() * 800 - 400;
      object.position.y = Math.random() * 800 - 400;
      object.position.z = Math.random() * 800 - 400;

      object.scale.x = Math.random() * 2 + 1;
      object.scale.y = Math.random() * 2 + 1;
      object.scale.z = Math.random() * 2 + 1;

      object.rotation.x = ( Math.random() * 360 ) * Math.PI / 180;
      object.rotation.y = ( Math.random() * 360 ) * Math.PI / 180;
      object.rotation.z = ( Math.random() * 360 ) * Math.PI / 180;

      scene.add( object );

      objects.add( object );
    }

    
    particleMaterial = new ParticleCanvasMaterial( {

      'color': 0x000000,
      'program': function( CanvasRenderingContext2D context ) {
        context.beginPath();
        context.arc( 0, 0, 1, 0, Math.PI * 2, false );
        context.closePath();
        context.fill();
      }

    } );
    
    projector = new Projector();

    var options;
//    options = {"debug" : true};
    renderer = new CanvasRenderer(options);
    //renderer.debug = true;
    renderer.setSize( window.innerWidth, window.innerHeight );

    container.nodes.add( renderer.domElement );

    //stats = new Stats();
    //stats.domElement.style.position = 'absolute';
    //stats.domElement.style.top = '0px';
    //container.appendChild( stats.domElement );

    document.on.mouseDown.add(onDocumentMouseDown, false);
    
    window.setInterval(f() => animate(), 10);
  }

  void onDocumentMouseDown( event ) 
  {
    event.preventDefault();

    Vector3 vector = new Vector3( ( event.clientX / window.innerWidth ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1, 0.5 );
    projector.unprojectVector( vector, camera );

    Ray ray = new Ray( camera.position, vector.subSelf( camera.position ).normalize() );

    List<Intersect> intersects = ray.intersectObjects( objects );

    if ( intersects.length > 0 ) 
    {
      Intersect intersect = intersects[0];
      Mesh mesh = intersect.object;
      MeshBasicMaterial material = mesh.material;
      material.color.setHex( Math.random() * 0xffffff );

      Particle particle = new Particle( particleMaterial );
      particle.position = intersect.point;
      particle.scale.x = particle.scale.y = 8;
      scene.add( particle );   
    }

    /*
    // Parse all the faces
    for ( var i in intersects ) {
      Intersect intersect = intersects[ i ];
      //intersects[ i ].
      intersects[ i ].face.material[ 0 ].color.setHex( Math.random() * 0xffffff | 0x80000000 );
    }
    */
  }

  //

  void animate() 
  {
    //requestAnimationFrame( animate );

    render();
    //stats.update()
  }

  void render() 
  {
    theta += 0.2;

    camera.position.x = radius * Math.sin( theta * Math.PI / 360 );
    camera.position.y = radius * Math.sin( theta * Math.PI / 360 );
    camera.position.z = radius * Math.cos( theta * Math.PI / 360 );
    camera.lookAt( scene.position );

    renderer.render( scene, camera );
  }

}

void main() {
  new Canvas_Interactive_Cubes().run();
}
