#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:three.dart/ThreeD.dart');
#import('package:three.dart/extras/ImageUtils.dart', prefix:'ImageUtils');
#import('package:three.dart/extras/SceneUtils.dart', prefix:'SceneUtils');

class WebGL_Geometries  {
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;

  
  void run() {   
    init();
    animate(0);
  }
  
  void init() {
    
    container = new Element.tag('div');
    document.body.nodes.add( container );

    camera = new PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 1, 2000 );
    camera.position.y = 400;

    scene = new Scene();
    
    scene.add( new AmbientLight( 0x404040 ) );

    var light = new DirectionalLight( 0xffffff );
    light.position.setValues( 0, 1, 0 );
    scene.add( light );

    var map = ImageUtils.loadTexture( 'textures/ash_uvgrid01.jpg' );
    map.wrapS = map.wrapT = Three.RepeatWrapping;
    map.anisotropy = 16;

    var materials = [
                 new MeshLambertMaterial( ambient: 0xbbbbbb, map: map, side: Three.DoubleSide ),
                 new MeshBasicMaterial( color: 0xffffff, wireframe: true, transparent: true, opacity: 0.1, side: Three.DoubleSide )
                 ];

    var object;
    
    object = SceneUtils.createMultiMaterialObject( new CubeGeometry( 100, 100, 100, 4, 4, 4 ), materials );
    object.position.setValues( -200, 0, 400 );
    scene.add( object );

    
    object = SceneUtils.createMultiMaterialObject( new CylinderGeometry( 25, 75, 100, 40, 5 ), materials );
    object.position.setValues( 0, 0, 400 );
    scene.add( object );
    
    object = SceneUtils.createMultiMaterialObject( new IcosahedronGeometry( 75, 1 ), materials );
    object.position.setValues( -200, 0, 200 );
    scene.add( object );

    object = SceneUtils.createMultiMaterialObject( new OctahedronGeometry( 75, 2 ), materials );
    object.position.setValues( 0, 0, 200 );
    scene.add( object );


    object = SceneUtils.createMultiMaterialObject( new TetrahedronGeometry( 75, 0 ), materials );
    object.position.setValues( 200, 0, 200 );
    scene.add( object );

    object = SceneUtils.createMultiMaterialObject( new PlaneGeometry( 100, 100, 4, 4 ), materials );
    object.position.setValues( -200, 0, 0 );
    scene.add( object );

    var object2 = SceneUtils.createMultiMaterialObject( new CircleGeometry( 50, 10, 0, Math.PI ), materials );
    object2.rotation.x = Math.PI/2;
    object.add( object2 );

    object = SceneUtils.createMultiMaterialObject( new SphereGeometry( 75, 20, 10 ), materials );
    object.position.setValues( 0, 0, 0 );
    scene.add( object );


    var points = [];

    for ( var i = 0; i < 50; i ++ ) {

      points.add( new Vector3( Math.sin( i * 0.2 ) * 15 + 50, 0, ( i - 5 ) * 2 ) );

    }

    object = SceneUtils.createMultiMaterialObject( new LatheGeometry( points, 20 ), materials );
    object.position.setValues( 200, 0, 0 );
    scene.add( object );

    object = SceneUtils.createMultiMaterialObject( new TorusGeometry( 50, 20, 20, 20 ), materials );
    object.position.setValues( -200, 0, -200 );
    scene.add( object );

    object = SceneUtils.createMultiMaterialObject( new TorusKnotGeometry( 50, 10, 50, 20 ), materials );
    object.position.setValues( 0, 0, -200 );
    scene.add( object );

    object = new AxisHelper();
    object.position.setValues( 200, 0, -200 );
    object.scale.x = object.scale.y = object.scale.z = 0.5;
    scene.add( object );


    object = new ArrowHelper( new Vector3( 0, 1, 0 ), new Vector3( 0, 0, 0 ), 50 );
    object.position.setValues( 200, 0, 400 );
    scene.add( object );
    
    renderer = new WebGLRenderer(); // TODO - {antialias: true}
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.sortObjects = false;
    
    container.nodes.add( renderer.domElement );
    
    window.on.resize.add(onWindowResize);
  }
  
  onWindowResize(event) {
    
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( window.innerWidth, window.innerHeight );
  }
  
  bool animate(int time) {
    window.requestAnimationFrame( animate );
    render();
  }
  
  render() {

    var timer = new Date.now().millisecondsSinceEpoch * 0.0001;

    camera.position.x = Math.cos( timer ) * 800;
    camera.position.z = Math.sin( timer ) * 800;

    camera.lookAt( scene.position );

    scene.children.forEach((object) {
      object.rotation.x = timer * 5;
      object.rotation.y = timer * 2.5;
    });

    renderer.render( scene, camera );

  }
  
}

void main() {
  new WebGL_Geometries().run();
}
