import 'dart:html';
import "dart:async";
import 'dart:math' as Math;
import 'dart:convert' show JSON;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/font_utils.dart' as FontUtils;
import 'package:three/extras/geometry_utils.dart' as GeometryUtils;

var container, stats, permalink, hex, color;

var camera, cameraTarget, scene, renderer;

var composer;
var effectFXAA;

var textMesh1, textMesh2, textGeo, material, parent;

var firstLetter = true,
    text = "three.dart",
    height = 20.0,
    size = 70,
    hover = 30.0,

    curveSegments = 4,

    bevelThickness = 2,
    bevelSize = 1.5,
    bevelSegments = 3,
    bevelEnabled = true,

    font = "helvetiker", // helvetiker, optimer, gentilis, droid sans, droid serif
    weight = "normal", // normal bold
    style = "normal", // normal italic

    mirror = true,

    targetRotation = 0,
    targetRotationOnMouseDown = 0,

    mouseX = 0,
    mouseXOnMouseDown = 0,

    glow = 0.9;

var windowHalfX;
var windowHalfY;

List<StreamSubscription> _mouseSubscriptions = [];

Future loadFonts() => Future.wait(
    ["fonts/helvetiker_regular.json"]
    .map((path) => HttpRequest.getString(path).then((data) {
      FontUtils.loadFace(JSON.decode(data));
    })));

void main() {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  loadFonts().then((_) {
    init();
    animate(0);
  });
}

capitalize( txt ) {

  return txt.substring( 0, 1 ).toUpperCase() + txt.substring( 1 );
}

void init() {

  container = new Element.tag('div');

  document.body.nodes.add( container );

  // CAMERA

  camera = new PerspectiveCamera( 30.0, window.innerWidth / window.innerHeight, 1.0, 1500.0 )
  ..position.setValues( 0.0, 400.0, 700.0 );

  cameraTarget = new Vector3( 0.0, 150.0, 0.0 );

  // SCENE

  scene = new Scene()
  ..fog = new FogLinear ( 0x000000, 250.0, 1400.0 );

  // LIGHTS

  var dirLight = new DirectionalLight( 0xffffff, 0.125 )
  ..position.setValues( 0.0, 0.0, 1.0 ).normalize();
  scene.add( dirLight );

  var pointLight = new PointLight( 0xffffff, intensity: 1.5 )
  ..position.setValues( 0.0, 100.0, 90.0 );
  scene.add( pointLight );

  //text = capitalize( font ) + " " + capitalize( weight );
  //text = "abcdefghijklmnopqrstuvwxyz0123456789";
  //text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

   pointLight.color.setHSL( new Math.Random().nextDouble(), 1, 0.5 );

   material = new MeshFaceMaterial( [
     new MeshPhongMaterial( color: 0xffffff, shading: FlatShading ), // front
     new MeshPhongMaterial( color: 0xffffff, shading: SmoothShading ) // side
   ] );

  parent = new Object3D()..position.y = 100.0;

  scene.add( parent );

  createText();

  var plane = new Mesh(
      new PlaneGeometry( 10000.0, 10000.0 ),
      new MeshBasicMaterial( color: 0xffffff, opacity: 0.5, transparent: true ))
  ..position.y = 100.0
  ..rotation.x = - Math.PI / 2.0;
  scene.add( plane );

  // RENDERER

  renderer = new WebGLRenderer( antialias: true )
  ..setSize( window.innerWidth, window.innerHeight )
  ..setClearColor( new Color(0x000000), 1 );

  container.nodes.add( renderer.domElement );

  // EVENTS

  document
  ..onMouseDown.listen( onDocumentMouseDown )
  ..onTouchStart.listen( onDocumentTouchStart )
  ..onTouchMove.listen( onDocumentTouchMove )
  ..onKeyPress.listen( onDocumentKeyPress )
  ..onKeyDown.listen( onDocumentKeyDown );

  window.onResize.listen( onWindowResize );

}

onWindowResize(e) {

  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

onDocumentKeyDown( event ) {

  if ( firstLetter ) {

    firstLetter = false;
    text = "";

  }

  var keyCode = event.keyCode;

  // backspace

  if ( keyCode == 8 ) {

    event.preventDefault();

    text = text.substring( 0, text.length - 1 );
    refreshText();

    return false;

  }

}

onDocumentKeyPress( event ) {

  var keyCode = event.which;

  // backspace

  if ( keyCode == 8 ) {

    event.preventDefault();

  } else {

    var ch = new String.fromCharCode( keyCode );
    text += ch;

    refreshText();

  }

}

createText() {

  textGeo = new TextGeometry( text,

    height,
    false,
    bevelThickness,
    bevelSize,
    3,
    bevelEnabled,
    curveSegments,
    1,
    null,
    null,
    0,
    1,
    size,
    font,
    weight,
    style
  );

  textGeo.materials = material.materials;

  textGeo.computeBoundingBox();
  textGeo.computeVertexNormals();

  // "fix" side normals by removing z-component of normals for side faces
  // (this doesn't work well for beveled geometry as then we lose nice curvature around z-axis)

  if ( ! bevelEnabled ) {

    var triangleAreaHeuristics = 0.1 * ( height * size );

    textGeo.faces.forEach((face) {

      if ( face.materialIndex == 1 ) {

        face.vertexNormals.forEach((normal) {

          normal
          ..z = 0.0
          ..normalize();

        });

        var va = textGeo.vertices[ face.a ],
            vb = textGeo.vertices[ face.b ],
            vc = textGeo.vertices[ face.c ];

        var s = GeometryUtils.triangleArea( va, vb, vc );

        if ( s > triangleAreaHeuristics ) {

          for ( var j = 0; j < face.vertexNormals.length; j ++ ) {

            face.vertexNormals[ j ].setFrom( face.normal );

          }

        }

      }

    });

  }

  var centerOffset = -0.5 * ( textGeo.boundingBox.max.x - textGeo.boundingBox.min.x );

  textMesh1 = new Mesh( textGeo, material )

  ..position.x = centerOffset
  ..position.y = hover
  ..position.z = 0.0

  ..rotation.x = 0.0
  ..rotation.y = Math.PI * 2.0;

  parent.add( textMesh1 );

  if ( mirror ) {

    textMesh2 = new Mesh( textGeo, material )

    ..position.x = centerOffset
    ..position.y = -hover
    ..position.z = height

    ..rotation.x = Math.PI
    ..rotation.y = Math.PI * 2.0;

    parent.add( textMesh2 );

  }

}

refreshText() {

  // updatePermalink();

  parent.remove( textMesh1 );
  if ( mirror ) parent.remove( textMesh2 );

  if ( !text ) return;

  createText();

}

onDocumentMouseDown( event ) {

  event.preventDefault();

  _mouseSubscriptions = [
    document.onMouseMove.listen( onDocumentMouseMove ),
    document.onMouseUp.listen( onDocumentMouseUp ),
    document.onMouseOut.listen( onDocumentMouseOut )];

  mouseXOnMouseDown = event.client.x - windowHalfX;
  targetRotationOnMouseDown = targetRotation;

}

onDocumentMouseMove( event ) {

  mouseX = event.client.x - windowHalfX;

  targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.02;

}

onDocumentMouseUp( event ) {
  _mouseSubscriptions.forEach((s) { s.cancel(); });

}

onDocumentMouseOut( event ) {
  _mouseSubscriptions.forEach((s) { s.cancel(); });
}

onDocumentTouchStart( event ) {

  if ( event.touches.length == 1 ) {

    event.preventDefault();

    mouseXOnMouseDown = event.touches[ 0 ].pageX - windowHalfX;
    targetRotationOnMouseDown = targetRotation;

  }

}

onDocumentTouchMove( event ) {

  if ( event.touches.length == 1 ) {

    event.preventDefault();

    mouseX = event.touches[ 0 ].pageX - windowHalfX;
    targetRotation = targetRotationOnMouseDown + ( mouseX - mouseXOnMouseDown ) * 0.05;

  }

}

//

animate(num time) {

  window.requestAnimationFrame( animate );

  render();

}

render() {

  parent.rotation.y += ( targetRotation - parent.rotation.y ) * 0.05;

  camera.lookAt( cameraTarget );

  renderer.clear();

  renderer.render( scene, camera );

}
