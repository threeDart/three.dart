import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';

Element container;
PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

List<Object3D> objects;
var particleLight, pointLight;

var materials = [];

main() {
  init();
  animate(0);
}

init() {
  container = new DivElement();
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 45.0, window.innerWidth / window.innerHeight, 1.0, 2000.0 );
  camera.position.setValues( 0.0, 200.0, 800.0 );

  scene = new Scene();

  // Grid

  var line_material = new LineBasicMaterial( color: 0x303030 );
  Geometry geometry = new Geometry();
  double floor = -75.0;
  double step = 25.0;

  for ( int i = 0; i <= 40; i ++ ) {

    geometry.vertices
    ..add( new Vector3( - 500.0, floor, i * step - 500.0 ) )
    ..add( new Vector3(   500.0, floor, i * step - 500.0 ) )
    ..add( new Vector3( i * step - 500.0, floor, -500.0 ) )
    ..add( new Vector3( i * step - 500.0, floor,  500.0 ) );

  }

  var line = new Line( geometry, line_material, LinePieces );
  scene.add( line );

  // Materials

  var texture = new Texture( generateTexture() )
  ..needsUpdate = true;

  materials
  ..add( new MeshLambertMaterial( map: texture, transparent: true ) )
  ..add( new MeshLambertMaterial( color: 0xdddddd, shading: FlatShading ) )
  ..add( new MeshPhongMaterial( ambient: 0x030303, color: 0xdddddd, specular: 0x009900, shininess: 30, shading: FlatShading ) )
  ..add( new MeshNormalMaterial( ) )
  ..add( new MeshBasicMaterial( color: 0xffaa00, transparent: true, blending: AdditiveBlending ) )
  //materials.push( new THREE.MeshBasicMaterial( { color: 0xff0000, blending: THREE.SubtractiveBlending } ) );

  ..add( new MeshLambertMaterial( color: 0xdddddd, shading: SmoothShading ) )
  ..add( new MeshPhongMaterial( ambient: 0x030303, color: 0xdddddd, specular: 0x009900, shininess: 30, shading: SmoothShading, map: texture, transparent: true ) )
  ..add( new MeshNormalMaterial( shading: SmoothShading ) )
  ..add( new MeshBasicMaterial( color: 0xffaa00, wireframe: true ) )

  ..add( new MeshDepthMaterial() )

  ..add( new MeshLambertMaterial( color: 0x666666, emissive: 0xff0000, ambient: 0x000000, shading: SmoothShading ) )
  ..add( new MeshPhongMaterial( color: 0x000000, specular: 0x666666, emissive: 0xff0000, ambient: 0x000000, shininess: 10, shading: SmoothShading, opacity: 0.9, transparent: true ) )

  ..add( new MeshBasicMaterial( map: texture, transparent: true ) );

  // Spheres geometry

  var geometry_smooth = new SphereGeometry( 70.0, 32, 16 );
  var geometry_flat = new SphereGeometry( 70.0, 32, 16 );
  var geometry_pieces = new SphereGeometry( 70.0, 32, 16 ); // Extra geometry to be broken down for MeshFaceMaterial

  var rnd = new Math.Random();
  geometry_pieces.faces.forEach((face) {
    face.materialIndex = rnd.nextInt(materials.length);
  });

  geometry_pieces.materials = materials;

  materials.add( new MeshFaceMaterial( materials ) );

  objects = [];

  var sphere, material;

  for ( var i = 0, l = materials.length; i < l; i ++ ) {

    material = materials[ i ];

    geometry = material is MeshFaceMaterial ? geometry_pieces :
           ( material.shading == FlatShading ? geometry_flat : geometry_smooth );

    sphere = new Mesh( geometry, material )
    ..position.x = ( i % 4 ) * 200.0 - 400.0
    ..position.z = ( i / 4 ).floor() * 200.0 - 200.0

    ..rotation.x = rnd.nextInt(200) - 100.0
    ..rotation.y = rnd.nextInt(200) - 100.0
    ..rotation.z = rnd.nextInt(200) - 100.0;

    objects.add( sphere );

    scene.add( sphere );

  }

  particleLight = new Mesh( new SphereGeometry( 4.0, 8, 8 ), new MeshBasicMaterial( color: 0xffffff ) );
  scene.add( particleLight );

  // Lights

  scene.add( new AmbientLight( 0x111111 ) );

  var directionalLight = new DirectionalLight( /*Math.random() * */ 0xffffff, 0.125 );

  directionalLight.position.x = rnd.nextDouble() - 0.5;
  directionalLight.position.y = rnd.nextDouble() - 0.5;
  directionalLight.position.z = rnd.nextDouble() - 0.5;

  directionalLight.position.normalize();

  scene.add( directionalLight );

  pointLight = new PointLight( 0xffffff );
  scene.add( pointLight );

  //

  renderer = new WebGLRenderer( antialias: true );
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );
  //

  window.onResize.listen(onWindowResize);

}

onWindowResize(_) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

generateTexture() {

  var canvas = new CanvasElement();
  canvas.width = 256;
  canvas.height = 256;

  var context = canvas.context2D;
  var image = context.getImageData( 0, 0, 256, 256 );

  var x = 0, y = 0;

  for ( var i = 0, j = 0, l = image.data.length; i < l; i += 4, j ++ ) {

    x = j % 256;
    y = x == 0 ? y + 1 : y;

    image.data[ i ] = 255;
    image.data[ i + 1 ] = 255;
    image.data[ i + 2 ] = 255;
    image.data[ i + 3 ] = ( x ^ y ).floor();

  }

  context.putImageData( image, 0, 0 );

  return canvas;

}

//

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}


render() {

  var timer = 0.0001 * new DateTime.now().millisecondsSinceEpoch;

  camera.position.x = Math.cos( timer ) * 1000;
  camera.position.z = Math.sin( timer ) * 1000;

  camera.lookAt( scene.position );

  objects.forEach((object) {

    object
    ..rotation.x += 0.01
    ..rotation.y += 0.005;

  });

  materials[ materials.length - 3 ].emissive.setHSV( 0.54, 1, 0.7 * ( 0.5 + 0.5 * Math.sin( 35 * timer ) ) );
  materials[ materials.length - 4 ].emissive.setHSV( 0.04, 1, 0.7 * ( 0.5 + 0.5 * Math.cos( 35 * timer ) ) );

  particleLight.position
  ..x = Math.sin( timer * 7 ) * 300
  ..y = Math.cos( timer * 5 ) * 400
  ..z = Math.cos( timer * 3 ) * 300;

  pointLight.position
  ..x = particleLight.position.x
  ..y = particleLight.position.y
  ..z = particleLight.position.z;

  renderer.render( scene, camera );

}