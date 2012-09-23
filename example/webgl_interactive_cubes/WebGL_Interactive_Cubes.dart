#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');

class WebGL_Interactive_Cubes  {
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;
  Projector projector;
  
  var mouseX = 0, mouseY = 0;
  
  Mesh INTERSECTED;
  
  void run() {
    init();
    animate(0);
  }
  
  void init() {
    
    container = new Element.tag('div');
    
    document.body.nodes.add( container );

    camera = new PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.setValues( 0, 300, 500 );

    scene = new Scene();
    scene.add(camera);
    
    var light;
    
    light = new DirectionalLight( 0xffffff, 2 );
    light.position.setValues( 1, 1, 1 ).normalize();
    scene.add( light );

    light = new DirectionalLight( 0xffffff );
    light.position.setValues( -1, -1, -1 ).normalize();
    scene.add( light );
    
    
    var geometry = new CubeGeometry( 20, 20, 20 );
    
    var rnd = new Math.Random();
    
    for ( var i = 0; i < 500; i ++ ) {

      var object = new Mesh( geometry, new MeshLambertMaterial( color: rnd.nextInt(0xffffff) ) );

      object.position.x = rnd.nextInt(800) - 400;
      object.position.y = rnd.nextInt(800) - 400;
      object.position.z = rnd.nextInt(800) - 400;

      object.rotation.x = ( rnd.nextDouble() * 360 ) * Math.PI / 180;
      object.rotation.y = ( rnd.nextDouble() * 360 ) * Math.PI / 180;
      object.rotation.z = ( rnd.nextDouble() * 360 ) * Math.PI / 180;

      object.scale.x = rnd.nextDouble() * 2 + 1;
      object.scale.y = rnd.nextDouble() * 2 + 1;
      object.scale.z = rnd.nextDouble() * 2 + 1;

      scene.add( object );

    }
    
    projector = new Projector();
    
    renderer = new WebGLRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    
    container.nodes.add( renderer.domElement );
    
    document.on.mouseMove.add(onDocumentMouseMove, false);
    
    window.on.resize.add(onWindowResize);
  }
  
  onWindowResize(_) {

    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );

  }

  onDocumentMouseMove( event ) {

    event.preventDefault();

    mouseX = ( event.clientX / window.innerWidth ) * 2 - 1;
    mouseY = - ( event.clientY / window.innerHeight ) * 2 + 1;

  }
  
  bool animate(int time) {

    window.requestAnimationFrame( animate );

    render();

  }
  
  var radius = 100;
  num theta = 0;

  render() {

    theta += 0.2;

    camera.position.x = radius * Math.sin( theta * Math.PI / 360 );
    camera.position.y = radius * Math.sin( theta * Math.PI / 360 );
    camera.position.z = radius * Math.cos( theta * Math.PI / 360 );

    camera.lookAt( scene.position );

    // find intersections

    var vector = new Vector3( mouseX, mouseY, 1 );
    projector.unprojectVector( vector, camera );

    var ray = new Ray( camera.position, vector.subSelf( camera.position ).normalize() );

    var intersects = ray.intersectObjects( scene.children );

    if ( intersects.length > 0 ) {

      if ( INTERSECTED != intersects[ 0 ].object ) {
        
        if ( INTERSECTED != null ) (INTERSECTED.material as MeshLambertMaterial).color.setHex( INTERSECTED["currentHex"] );

        INTERSECTED = intersects[ 0 ].object;
        MeshLambertMaterial material = INTERSECTED.material;
        INTERSECTED["currentHex"] = material.color.getHex();
        material.color.setHex( 0xff0000 );

      }

    } else {

      if ( INTERSECTED != null ) (INTERSECTED.material as MeshLambertMaterial).color.setHex( INTERSECTED["currentHex"] );

      INTERSECTED = null;

    }

    renderer.render( scene, camera );

  }
  
}

void main() {
  new WebGL_Interactive_Cubes().run();
}
