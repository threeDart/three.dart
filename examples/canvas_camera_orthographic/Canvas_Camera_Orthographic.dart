#import('dart:html');
#import('dart:math', prefix:'Math');
#import('../../src/ThreeD.dart');

class Canvas_Camera_Orthographic {
  Element container;

  OrthographicCamera camera;
  Scene scene;
  CanvasRenderer renderer;

  num windowHalfX;
  num windowHalfY;
  
  void run() {
    init();
    animate(0);
  }
  
  void init() {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
    container = new Element.tag('div');
    document.body.nodes.add( container );

    Element info = new Element.tag('div');
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = 'three.dart - orthographic view';
    container.nodes.add( info );

    camera = new OrthographicCamera( -windowHalfX, windowHalfX, windowHalfY, -windowHalfY, - 2000, 1000);
    camera.position.x = 200;
    camera.position.y = 100;
    camera.position.z = 200;
    
    scene = new Scene();
    
    var geometry, material;
    
    // Grid
    geometry = new Geometry();
    geometry.vertices.add( new Vertex(new Vector3( - 500, 0, 0 )) );
    geometry.vertices.add( new Vertex(new Vector3( 500, 0, 0 )) );

    for ( var i = 0; i <= 20; i ++ ) {

      var line = new Line( geometry, new LineBasicMaterial( { "color": 0x000000, "opacity": 0.2 } ) );
      line.position.z = ( i * 50 ) - 500;
      scene.add( line );

      line = new Line( geometry, new LineBasicMaterial( { "color": 0x000000, "opacity": 0.2 } ) );
      line.position.x = ( i * 50 ) - 500;
      line.rotation.y = 90 * Math.PI / 180;
      scene.add( line );

    }
    
    // Cubes

    geometry = new CubeGeometry( 50, 50, 50 );
    material = new MeshLambertMaterial( { "color": 0xffffff, "overdraw": true} );

    var rnd = new Math.Random();
    
    for ( var i = 0; i < 100; i ++ ) {

      var cube = new Mesh( geometry, material );

      cube.scale.y = rnd.nextInt(2) + 1;

      cube.position.x = ( ( rnd.nextInt(1000) - 500 ) / 50 ).floor() * 50 + 25;
      cube.position.y = ( cube.scale.y * 50 ) / 2;
      cube.position.z = ( ( rnd.nextInt(1000) - 500 ) / 50 ).floor() * 50 + 25;

      scene.add( cube );

    }
    

    // Lights

    var ambientLight = new AmbientLight( rnd.nextDouble() * 0x10 );
    scene.add( ambientLight );

    var directionalLight = new DirectionalLight( rnd.nextDouble() * 0xffffff );
    directionalLight.position.x = rnd.nextDouble() - 0.5;
    directionalLight.position.y = rnd.nextDouble() - 0.5;
    directionalLight.position.z = rnd.nextDouble() - 0.5;
    directionalLight.position.normalize();
    scene.add( directionalLight );

    directionalLight = new DirectionalLight( rnd.nextDouble() * 0xffffff );
    directionalLight.position.x = rnd.nextDouble() - 0.5;
    directionalLight.position.y = rnd.nextDouble() - 0.5;
    directionalLight.position.z = rnd.nextDouble() - 0.5;
    directionalLight.position.normalize();
    scene.add( directionalLight );

    renderer = new CanvasRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    
    container.nodes.add( renderer.domElement );
   
    window.on.resize.add(onWindowResize);
  }

  onWindowResize(e) {

    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    
    camera.left = -windowHalfX;
    camera.right = windowHalfX;
    camera.top = windowHalfY;
    camera.bottom = -windowHalfY;

    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

  }
  
  
  bool animate(int time)
  {
    window.requestAnimationFrame(animate);

    render();
  }

  void render()
  {

    var timer = new Date.now().millisecondsSinceEpoch * 0.0001;

    camera.position.x = Math.cos( timer ) * 200;
    camera.position.z = Math.sin( timer ) * 200;
    camera.lookAt( scene.position );

    renderer.render( scene, camera );
  }
}

void main() {
  new Canvas_Camera_Orthographic().run();
}
