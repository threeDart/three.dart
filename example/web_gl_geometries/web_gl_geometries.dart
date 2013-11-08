import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;
import 'package:three/extras/scene_utils.dart' as SceneUtils;

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;


void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 45.0, window.innerWidth / window.innerHeight, 1.0, 2000.00 );
  camera.position.y = 400.0;

  scene = new Scene();

  scene.add( new AmbientLight( 0x404040 ) );

  var light = new DirectionalLight( 0xffffff );
  light.position.setValues( 0.0, 1.0, 0.0 );
  scene.add( light );

  Texture map = ImageUtils.loadTexture( 'textures/ash_uvgrid01.jpg' );
  map.wrapS = map.wrapT = RepeatWrapping;
  map.anisotropy = 16;

  var materials = [
               new MeshLambertMaterial( ambient: 0xbbbbbb, map: map, side: DoubleSide ),
               new MeshBasicMaterial( color: 0xffffff, wireframe: true, transparent: true, opacity: 0.1, side: DoubleSide )
               ];

  var object = SceneUtils.createMultiMaterialObject( new CubeGeometry( 100.0, 100.0, 100.0, 4, 4, 4 ), materials );
  object.position.setValues( -200.0, 0.0, 400.0 );
  scene.add( object );


  object = SceneUtils.createMultiMaterialObject( new CylinderGeometry( 25.0, 75.0, 100.0, 40, 5 ), materials );
  object.position.setValues( 0.0, 0.0, 400.0 );
  scene.add( object );

  object = SceneUtils.createMultiMaterialObject( new IcosahedronGeometry( 75.0, 1 ), materials );
  object.position.setValues( -200.0, 0.0, 200.0 );
  scene.add( object );

  object = SceneUtils.createMultiMaterialObject( new OctahedronGeometry( 75.0, 2 ), materials );
  object.position.setValues( 0.0, 0.0, 200.0 );
  scene.add( object );


  object = SceneUtils.createMultiMaterialObject( new TetrahedronGeometry( 75.0, 0 ), materials );
  object.position.setValues( 200.0, 0.0, 200.0 );
  scene.add( object );

  object = SceneUtils.createMultiMaterialObject( new PlaneGeometry( 100.0, 100.0, 4, 4 ), materials );
  object.position.setValues( -200.0, 0.0, 0.0 );
  scene.add( object );

  var object2 = SceneUtils.createMultiMaterialObject( new CircleGeometry( 50, 10, 0, Math.PI ), materials );
  object2.rotation.x = Math.PI/2;
  object.add( object2 );

  object = SceneUtils.createMultiMaterialObject( new SphereGeometry( 75.0, 20, 10 ), materials );
  object.position.setValues( 0.0, 0.0, 0.0 );
  scene.add( object );


  var points = [];

  for ( var i = 0; i < 50; i ++ ) {

    points.add( new Vector3( Math.sin( i * 0.2 ) * 15.0 + 50.0, 0.0, ( i - 5 ) * 2.0 ) );

  }

  object = SceneUtils.createMultiMaterialObject( new LatheGeometry( points, 20 ), materials );
  object.position.setValues( 200.0, 0.0, 0.0 );
  scene.add( object );

  object = SceneUtils.createMultiMaterialObject( new TorusGeometry( 50, 20, 20, 20 ), materials );
  object.position.setValues( -200.0, 0.0, -200.0 );
  scene.add( object );

  object = SceneUtils.createMultiMaterialObject( new TorusKnotGeometry( 50, 10, 50, 20 ), materials );
  object.position.setValues( 0.0, 0.0, -200.0 );
  scene.add( object );

  object = new AxisHelper();
  object.position.setValues( 200.0, 0.0, -200.0 );
  object.scale.x = object.scale.y = object.scale.z = 0.5;
  scene.add( object );


  object = new ArrowHelper(new Vector3(0.0, 1.0, 0.0), new Vector3.zero(), 50.0);
  object.position.setValues( 200.0, 0.0, 400.0 );
  scene.add( object );

  renderer = new WebGLRenderer(); // TODO - {antialias: true}
  renderer.setSize( window.innerWidth, window.innerHeight );
  renderer.sortObjects = false;

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);
}

onWindowResize(event) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

render() {

  var timer = new DateTime.now().millisecondsSinceEpoch * 0.0001;

  camera.position.x = Math.cos( timer ) * 800.0;
  camera.position.z = Math.sin( timer ) * 800.0;

  camera.lookAt( scene.position );

  scene.children.forEach((object) {
    object.rotation.x = timer * 5.0;
    object.rotation.y = timer * 2.5;
  });

  renderer.render( scene, camera );

}
