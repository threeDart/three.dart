import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'dart:convert' show JSON;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/geometry_utils.dart' as GeometryUtils;
import 'package:three/extras/font_utils.dart' as FontUtils;

var container, camera, scene, renderer, object;
var uniforms, amplitude, opacity, color;
var attributes, displacement, customColor;

var text = "three.dart",
    height = 15.0,
    size = 50,
    
    curveSegments = 10,
    steps = 40,
    
    bevelThickness = 5,
    bevelSize = 1.5,
    bevelSegments = 10,
    bevelEnabled = true,

    font = "helvetiker", // helvetiker, optimer, gentilis, droid sans, droid serif
    weight = "normal", // normal bold
    style = "normal"; // normal italic

var rnd = new Math.Random();

Future loadFonts() => Future.wait(
    ["fonts/helvetiker_regular.json"]
    .map((path) => HttpRequest.getString(path).then((data) {
      FontUtils.loadFace(JSON.decode(data));
    })));

void main() {
  loadFonts().then((_) {
    init();
    animate(0);
  });
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 30.0, window.innerWidth / window.innerHeight, 1.0, 10000.00 )
  ..position.z = 400.0;

  scene = new Scene();

  displacement = new Attribute.vector3();
  customColor = new Attribute.color();

  attributes = { "displacement" : displacement,
                 "customColor"  : customColor };
  
  amplitude = new Uniform.float(5.0);
  opacity = new Uniform.float(0.3);
  color = new Uniform.color(0xff0000);

  uniforms = { "amplitude" : amplitude,
               "opacity"   : opacity,
               "color"     : color };

  var shaderMaterial = new ShaderMaterial(
      uniforms:       uniforms,
      attributes:     attributes,
      vertexShader:   querySelector('#vertexshader').text,
      fragmentShader: querySelector('#fragmentshader').text,
      blending:       AdditiveBlending,
      depthTest:      false,
      transparent:    true);

  var geometry = new TextGeometry( 
      text,
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
  geometry.isDynamic = true;
  
  GeometryUtils.center( geometry );

  object = new Line(geometry, shaderMaterial, LineStrip);
  
  var vertices = object.geometry.vertices;
  
  for( var v = 0; v < vertices.length; v ++ ) {

    displacement.value.add(new Vector3.zero());

    customColor.value.add(new Color( 0xffffff));
    customColor.value[ v ].setHSL( v / vertices.length, 0.5, 0.5 );
  }

  object.rotation.x = 0.2;

  scene.add( object );

  renderer = new WebGLRenderer(antialias: true, alpha: false)
  ..setSize( window.innerWidth, window.innerHeight )
  ..setClearColorHex(0x050505, 1);

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

var start_time = null;

render() {
  if (start_time == null) {
    start_time = new DateTime.now().millisecondsSinceEpoch;
  }
  var delta = new DateTime.now().millisecondsSinceEpoch - start_time,
      delta_in_sec = delta * 0.001;

  object.rotation.y = 0.25 * delta_in_sec;

  amplitude.value = 0.5 * Math.sin( 0.5 * delta_in_sec );
  color.value.offsetHSL( 0.0005, 0, 0 );

  var nx, ny, nz, value;
  
  var il = displacement.value.length;
  for( var i = 0; i < il; i ++ ) {

    nx = 0.3 * ( 0.5 - rnd.nextDouble() );
    ny = 0.3 * ( 0.5 - rnd.nextDouble() );
    nz = 0.3 * ( 0.5 - rnd.nextDouble() );

    value = displacement.value[ i ];

    value.x += nx;
    value.y += ny;
    value.z += nz;

  }

  displacement.needsUpdate = true;

  renderer.render( scene, camera );
}