import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/scene_utils.dart' as SceneUtils;

var container, camera, scene, renderer;
var mesh, group1, group2, group3, light;

var mouseX = 0, 
    mouseY = 0;

var windowHalfX = window.innerWidth / 2;
var windowHalfY = window.innerHeight / 2;

var rnd = new Math.Random();

void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 20.0, window.innerWidth / window.innerHeight, 1.0, 10000.00 )
  ..position.z = 1800.0;

  scene = new Scene();

  light = new DirectionalLight( 0xffffff )
  ..position.setValues( 0.0, 0.0, 1.0 );
  scene.add( light );

  // shadow

  var canvas = new Element.tag('canvas' );
  canvas.width = 128;
  canvas.height = 128;

  var context = canvas.getContext( '2d' );
  var gradient = context.createRadialGradient( canvas.width / 2, canvas.height / 2, 0, canvas.width / 2, canvas.height / 2, canvas.width / 2 );
  gradient.addColorStop( 0.1, 'rgba(210,210,210,1)' );
  gradient.addColorStop( 1  , 'rgba(255,255,255,1)' );

  context.fillStyle = gradient;
  context.fillRect( 0, 0, canvas.width, canvas.height );

  var shadowTexture = new Texture( canvas )
  ..needsUpdate = true;

  var shadowMaterial = new MeshBasicMaterial( map: shadowTexture );
  var shadowGeo = new PlaneGeometry( 300.0, 300.0, 1, 1 );

  mesh = new Mesh( shadowGeo, shadowMaterial )
  ..position.y = -250.0
  ..rotation.x = -Math.PI / 2;
  scene.add( mesh );

  mesh = new Mesh( shadowGeo, shadowMaterial )
  ..position.y = -250.0
  ..position.x = -400.0
  ..rotation.x = -Math.PI / 2;
  scene.add( mesh );

  mesh = new Mesh( shadowGeo, shadowMaterial )
  ..position.y = -250.0
  ..position.x = 400.0
  ..rotation.x = -Math.PI / 2;
  scene.add( mesh );

  var faceIndices = [ 'a', 'b', 'c'];

  var color, f, f2, f3, p, n, vertexIndex,

  radius = 200.0,

  geometry  = new IcosahedronGeometry( radius, 1 ),
  geometry2 = new IcosahedronGeometry( radius, 1 ),
  geometry3 = new IcosahedronGeometry( radius, 1 );

  for ( var i = 0; i < geometry.faces.length; i ++ ) {

    f  = geometry.faces[ i ];
    f2 = geometry2.faces[ i ];
    f3 = geometry3.faces[ i ];

    for( var j = 0; j < 3; j++ ) {

      vertexIndex = f.indices[j];

      p = geometry.vertices[ vertexIndex ];

      color = new Color( 0xffffff );
      color.setHSL( ( p.y / radius + 1 ) / 2, 1.0, 0.5 );

      f.vertexColors.add(color);

      color = new Color( 0xffffff );
      color.setHSL( 0.0, ( p.y / radius + 1 ) / 2, 0.5 );

      f2.vertexColors.add(color);

      color = new Color( 0xffffff );
      color.setHSL( 0.125 * vertexIndex/geometry.vertices.length, 1.0, 0.5 );

      f3.vertexColors.add(color);

    }

  }


  var materials = [ new MeshLambertMaterial(color: 0xffffff, shading: FlatShading, vertexColors: VertexColors ),
                    new MeshBasicMaterial( color: 0x000000, shading: FlatShading, wireframe: true, transparent: true ) ];

  group1 = SceneUtils.createMultiMaterialObject( geometry, materials )
  ..position.x = -400.0
  ..rotation.x = -1.87;
  scene.add( group1 );

  group2 = SceneUtils.createMultiMaterialObject( geometry2, materials )
  ..position.x = 400.0
  ..rotation.x = 0.0;
  scene.add( group2 );

  group3 = SceneUtils.createMultiMaterialObject( geometry3, materials )
  ..position.x = 0.0
  ..rotation.x = 0.0;
  scene.add( group3 );
  

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  //renderer.sortObjects = false;

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);
  window.onMouseMove.listen(onDocumentMouseMove);
}

onWindowResize(event) {

  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;
  
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

onDocumentMouseMove(event) {
  mouseX = ( event.client.x - windowHalfX );
  mouseY = ( event.client.y - windowHalfY );
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
}

var start_time = null;

render() {
  if (start_time == null) {
    start_time = new DateTime.now().millisecondsSinceEpoch;
  }
  var delta = new DateTime.now().millisecondsSinceEpoch - start_time,
      delta_in_sec = delta * 0.001;
  
  camera.position.x += ( mouseX - camera.position.x ) * 0.05;
  camera.position.y += ( - mouseY - camera.position.y ) * 0.05;
  
  camera.lookAt(scene.position);

  renderer.render( scene, camera );

}