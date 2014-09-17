library periodic_table;

import 'dart:html';
import 'dart:math' as Math;

import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart' as THREE;
import 'package:three/extras/renderers/css3d_renderer.dart' as THREE;
import 'package:three/extras/controls/trackball_controls.dart';
import 'package:three/extras/tween.dart' as TWEEN;

part 'periodic_table.dart';

var camera, scene, renderer;
var geometry, material, mesh;

var controls;

var objects = [];

init() {

  var targets = { "table": [], "sphere": [], "helix": [], "grid": [] };

  camera = new THREE.PerspectiveCamera( 75.0, window.innerWidth / window.innerHeight, 1.0, 5000.0 );
  camera.position.z = 1800.0;

  scene = new THREE.Scene();

  for ( int i = 0; i < table.length; i ++ ) {

    var item = table[ i ];

    var number = new Element.tag( 'div' )
    ..text = (i + 1).toString()
    ..classes.add('number');

    var symbol = new Element.tag( 'div' )
    ..text = item[ 0 ]
    ..classes.add('symbol');

    var details = new Element.tag( 'div' )
    ..classes.add('details')
    ..innerHtml = '${item[ 1 ]}<br>${item[ 2 ]}';

    var element = new Element.tag( 'div' )
    ..classes.add('element')
    ..style.backgroundColor = 'rgba(0,127,127,${( new Math.Random().nextDouble() * 0.5 + 0.25 ) })'
    ..children.add( number )
    ..children.add( symbol )
    ..children.add( details );

    var object = new THREE.CSS3DObject( element )
    ..position.x = new Math.Random().nextDouble() * 4000 - 2000.0
    ..position.y = new Math.Random().nextDouble() * 4000 - 2000.0
    ..position.z = new Math.Random().nextDouble() * 4000 - 2000.0;

    scene.add( object );

    objects.add( object );

  }

  // table

  for ( int i = 0; i < objects.length; i ++ ) {

    var item = table[ i ];
    var object = objects[ i ];

    targets["table"].add( new THREE.Object3D()
    ..position.x = ( item[ 3 ] * 160.0 ) - 1540.0
    ..position.y = - ( item[ 4 ] * 200.0 ) + 1100.0
    );

  }

  // sphere

  var vector = new Vector3.zero();

  for ( int i = 0, l = objects.length; i < l; i ++ ) {

    var object = objects[ i ];

    var phi = Math.acos( -1 + ( 2 * i ) / l );
    var theta = Math.sqrt( l * Math.PI ) * phi;

    object = new THREE.Object3D()
    ..position.x = 1000.0 * Math.cos( theta ) * Math.sin( phi )
    ..position.y = 1000.0 * Math.sin( theta ) * Math.sin( phi )
    ..position.z = 1000.0 * Math.cos( phi );

    vector = object.position.clone().scale( 2.0 );

    object.lookAt( vector );

    targets["sphere"].add( object );

  }

  // helix

  vector = new Vector3.zero();

  for ( int i = 0, l = objects.length; i < l; i ++ ) {

    var object = objects[ i ];

    var phi = i * 0.175 + Math.PI;

    object = new THREE.Object3D()
    ..position.x = 1100.0 * Math.sin( phi )
    ..position.y = -(i * 8.0) + 450.0
    ..position.z = 1100.0 * Math.cos( phi );

    vector.setFrom(object.position);
    vector.x *= 2;
    vector.z *= 2;

    object.lookAt( vector );

    targets["helix"].add( object );

  }

  // grid

  for ( int i = 0; i < objects.length; i ++ ) {

    var object = objects[ i ];

    object = new THREE.Object3D()
    ..position.x = ( ( i % 5 ) * 400.0 ) - 800.0
    ..position.y = ( - ( ( i ~/ 5 ) % 5 ) * 400.0 ) + 800.0
    ..position.z = ( ( i ~/ 25 ) ) * 1000.0 - 2000.0;

    targets["grid"].add( object );

  }

  //

  renderer = new THREE.CSS3DRenderer()
  ..setSize( window.innerWidth, window.innerHeight )
  ..domElement.style.position = 'absolute'
  ..domElement.style.top = "0";
  document.querySelector( '#container' ).children.add( renderer.domElement );

  //

  controls = new TrackballControls( camera, renderer.domElement )
  ..rotateSpeed = 0.5
  ..addEventListener( 'change', (_) => render() );

  document.querySelector( '#table' ).onClick.listen((e) => transform( e.target, targets["table"], 2000 ));

  document.querySelector( '#sphere' ).onClick.listen((e) => transform( e.target, targets["sphere"], 2000 ));

  document.querySelector( '#helix' ).onClick.listen((e) => transform( e.target, targets["helix"], 2000 ));

  document.querySelector( '#grid' ).onClick.listen((e) => transform( e.target, targets["grid"], 2000 ));

  transform( window, targets["table"], 5000 );

  //

  window.onResize.listen(onWindowResize);

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

animate(num time) {

  window.requestAnimationFrame( animate );

  TWEEN.update();
  controls.update();

}

render() => renderer.render( scene, camera );

main() {
  init();
  animate(0);
}