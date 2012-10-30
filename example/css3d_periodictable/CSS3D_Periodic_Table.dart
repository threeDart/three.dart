
import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart' as THREE;
import 'package:three/extras/controls/trackball.dart';
import 'package:three/extras/tween.dart' as TWEEN;

part 'periodic_table.dart';

var camera, scene, renderer;
var geometry, material, mesh;

var controls;

var objects = [];

init() {

  var targets = { "table": [], "sphere": [], "helix": [], "grid": [] };

  camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 5000 );
  camera.position.z = 1800;

  scene = new THREE.Scene();

  for ( var i = 0; i < table.length; i ++ ) {

    var item = table[ i ];

    var number = new Element.tag( 'div' )
    ..text = (i + 1).toString()
    ..classes.add('number');

    var symbol = new Element.tag( 'div' )
    ..text = item[ 0 ]
    ..classes.add('symbol');

    var details = new Element.tag( 'div' )
    ..classes.add('details')
    ..innerHTML = '${item[ 1 ]}<br>${item[ 2 ]}';

    var element = new Element.tag( 'div' )
    ..classes.add('element')
    ..style.backgroundColor = 'rgba(0,127,127,${( new Math.Random().nextDouble() * 0.5 + 0.25 ) })'
    ..elements.add( number )
    ..elements.add( symbol )
    ..elements.add( details );

    var object = new THREE.CSS3DObject( element )
    ..position.x = new Math.Random().nextInt(4000) - 2000
    ..position.y = new Math.Random().nextInt(4000) - 2000
    ..position.z = new Math.Random().nextInt(4000) - 2000;

    scene.add( object );

    objects.add( object );

  }

  // table

  for ( var i = 0; i < objects.length; i ++ ) {

    var item = table[ i ];
    var object = objects[ i ];

    targets["table"].add( new THREE.Object3D()
    ..position.x = ( item[ 3 ] * 160 ) - 1540
    ..position.y = - ( item[ 4 ] * 200 ) + 1100
    );

  }

  // sphere

  var vector = new THREE.Vector3();

  for ( var i = 0, l = objects.length; i < l; i ++ ) {

    var object = objects[ i ];

    var phi = Math.acos( -1 + ( 2 * i ) / l );
    var theta = Math.sqrt( l * Math.PI ) * phi;

    object = new THREE.Object3D()
    ..position.x = 1000 * Math.cos( theta ) * Math.sin( phi )
    ..position.y = 1000 * Math.sin( theta ) * Math.sin( phi )
    ..position.z = 1000 * Math.cos( phi );

    vector.copy( object.position ).multiplyScalar( 2 );

    object.lookAt( vector );

    targets["sphere"].add( object );

  }

  // helix

  vector = new THREE.Vector3();

  for ( var i = 0, l = objects.length; i < l; i ++ ) {

    var object = objects[ i ];

    var phi = i * 0.2 + Math.PI;

    object = new THREE.Object3D()
    ..position.x = 1000 * Math.sin( phi )
    ..position.y = i * 10 - 600
    ..position.z = 1000 * Math.cos( phi );

    vector.copy( object.position );
    vector.x *= 2;
    vector.z *= 2;

    object.lookAt( vector );

    targets["helix"].add( object );

  }

  // grid

  for ( var i = 0; i < objects.length; i ++ ) {

    var object = objects[ i ];

    object = new THREE.Object3D()
    ..position.x = ( ( i % 5 ) * 400 ) - 800
    ..position.y = ( - ( ( i ~/ 5 ) % 5 ) * 400 ) + 800
    ..position.z = ( ( i ~/ 25 ) ) * 1000 - 2000;

    targets["grid"].add( object );

  }

  //

  renderer = new THREE.CSS3DRenderer()
  ..setSize( window.innerWidth, window.innerHeight )
  ..domElement.style.position = 'absolute'
  ..domElement.style.top = "0";
  document.query( '#container' ).elements.add( renderer.domElement );

  //

  controls = new TrackballControls( camera, renderer.domElement )
  ..rotateSpeed = 0.5
  ..addEventListener( 'change', (_) => render() );

  document.query( '#table' ).on.click.add((e) => transform( e.target, targets["table"], 2000 ));

  document.query( '#sphere' ).on.click.add((e) => transform( e.target, targets["sphere"], 2000 ));

  document.query( '#helix' ).on.click.add((e) => transform( e.target, targets["helix"], 2000 ));

  document.query( '#grid' ).on.click.add((e) => transform( e.target, targets["grid"], 2000 ));

  transform( window, targets["table"], 5000 );

  //

  window.on.resize.add(onWindowResize);

}

transform( target, targets, duration ) {

  TWEEN.removeAll();

  for ( var i = 0; i < objects.length; i ++ ) {

    var object = objects[ i ];
    var target = targets[ i ];

    new TWEEN.Tween( object.position )
    ..to( { "x": target.position.x, "y": target.position.y, "z": target.position.z }, new Math.Random().nextDouble() * duration + duration )
    ..easing = TWEEN.Easing.Exponential.InOut
    ..start();

    new TWEEN.Tween( object.rotation )
    ..to( { "x": target.rotation.x, "y": target.rotation.y, "z": target.rotation.z }, new Math.Random().nextDouble() * duration + duration )
    ..easing = TWEEN.Easing.Exponential.InOut
    ..start();

  }

  new TWEEN.Tween( target )
  ..to( {}, duration * 2 )
  ..onUpdate = (object, value) { render(); }
  ..start();
}

onWindowResize(_) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

animate(int time) {

  window.requestAnimationFrame( animate );

  TWEEN.update();
  controls.update();

}

render() => renderer.render( scene, camera );

main() {
  init();
  animate(0);
}