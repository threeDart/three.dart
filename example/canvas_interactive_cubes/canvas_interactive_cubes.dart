import 'dart:html';
import 'dart:math' as Math;

import 'package:vector_math/vector_math.dart' hide Ray;
import 'package:three/three.dart';
import 'package:three/extras/renderers/canvas_renderer.dart';

Element container;//, stats;
PerspectiveCamera camera;
Scene scene;
Projector projector;
CanvasRenderer renderer;
Material particleMaterial;

List<Mesh> objects;

final num radius = 600;
num theta = 0;

void main() {
  init();
  animate(0);
}

void init() {
  objects = [];

  container = new Element.tag('div');
  document.body.nodes.add( container );

  Element info = new Element.tag('div');
  info.style.position = 'absolute';
  info.style.top = '10px';
  info.style.width = '100%';
  info.style.textAlign = 'center';
  info.innerHtml = '<a href="http://github.com/robsilv/three.dart" target="_blank">three.dart</a> - clickable objects';
  container.nodes.add( info );

  camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight.toDouble(), 1.0, 10000.0 );
  camera.position.setValues( 0.0, 300.0, 500.0 );

  scene = new Scene();

  scene.add( camera );

  CubeGeometry geometry = new CubeGeometry( 100.0, 100.0, 100.0 );

  var rnd = new Math.Random();
  for ( int i = 0; i < 10; i ++ ) {
    Particle particle = new Particle( particleMaterial );
    particle.position.x = rnd.nextInt(800) - 400.0;
    particle.position.y = rnd.nextInt(800) - 400.0;
    particle.position.z = rnd.nextInt(800) - 400.0;
    particle.scale.x = particle.scale.y = 8.0;
    scene.add( particle );

    Mesh object = new Mesh( geometry, new MeshBasicMaterial( color: rnd.nextDouble() * 0xffffff, opacity: 0.5 ) );
    object.position.x = rnd.nextInt(800) - 400.0;
    object.position.y = rnd.nextInt(800) - 400.0;
    object.position.z = rnd.nextInt(800) - 400.0;

    object.scale.x = rnd.nextDouble() * 2 + 1.0;
    object.scale.y = rnd.nextDouble() * 2 + 1.0;
    object.scale.z =  rnd.nextDouble() * 2 + 1.0;

    object.rotation.x = ( rnd.nextDouble() * 360.0 ) * Math.PI / 180;
    object.rotation.y = ( rnd.nextDouble() * 360.0 ) * Math.PI / 180;
    object.rotation.z = ( rnd.nextDouble() * 360.0 ) * Math.PI / 180;

    scene.add( object );

    objects.add( object );
  }


  particleMaterial = new ParticleCanvasMaterial(

    color: 0x000000,
    program: ( CanvasRenderingContext2D context) {
      context.beginPath();
      context.arc( 0, 0, 1, 0, Math.PI * 2, false );
      context.closePath();
      context.fill();
    }

  );

  projector = new Projector();

  var options;

  renderer = new CanvasRenderer(options);
  //renderer.debug = true;
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );

  //stats = new Stats();
  //stats.domElement.style.position = 'absolute';
  //stats.domElement.style.top = '0px';
  //container.appendChild( stats.domElement );

  document.onMouseDown.listen(onDocumentMouseDown);
}

void onDocumentMouseDown( event ) {
  event.preventDefault();

  Vector3 vector = new Vector3( ( event.client.x / window.innerWidth ) * 2 - 1, - ( event.client.y / window.innerHeight ) * 2 + 1, 0.5 );
  projector.unprojectVector( vector, camera );

  Ray ray = new Ray( camera.position, vector.sub( camera.position ).normalize() );

  List<Intersect> intersects = ray.intersectObjects( objects );

  if ( intersects.length > 0 ) {
    Intersect intersect = intersects[0];
    Mesh mesh = intersect.object;
    MeshBasicMaterial material = mesh.material;
    material.color.setHex( new Math.Random().nextDouble() * 0xffffff );

    Particle particle = new Particle( particleMaterial );
    particle.position = intersect.point;
    particle.scale.x = particle.scale.y = 8.0;
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

void animate(num time) {
  window.requestAnimationFrame(animate);

  render();
}

void render() {
  theta += 0.2;

  camera.position.x = radius * Math.sin( theta * Math.PI / 360 );
  camera.position.y = radius * Math.sin( theta * Math.PI / 360 );
  camera.position.z = radius * Math.cos( theta * Math.PI / 360 );
  camera.lookAt( scene.position );

  renderer.render( scene, camera );
}
