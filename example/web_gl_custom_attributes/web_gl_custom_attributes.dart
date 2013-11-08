import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;

PerspectiveCamera camera;
Scene scene;
Renderer renderer;

Map<String, Uniform> uniforms;
Uniform<double> amplitude;
Uniform<Color> color;
Uniform<Texture> texture;

Map<String, Attribute> attributes;
Attribute<double> displacement;

Mesh sphere;

List<double> noise;

var rnd = new Math.Random();

var WIDTH = window.innerWidth,
    HEIGHT = window.innerHeight;

void main() {
  init();
  animate(0);
}

void init() {

  camera = new PerspectiveCamera( 30.0, WIDTH / HEIGHT, 1.0, 10000.0 )
  ..position.z = 300.0;

  scene = new Scene();

  displacement = new Attribute.float();
  attributes = {"displacement": displacement};

  amplitude = new Uniform.float(1.0);
  color = new Uniform.color( 0xff2200 );
  texture = new Uniform.texture(ImageUtils.loadTexture("textures/water.jpg"));

  uniforms = {"amplitude": amplitude,
              "color": color,
              "texture": texture};

  texture.value.wrapS = texture.value.wrapT = RepeatWrapping;

  var shaderMaterial = new ShaderMaterial(
    uniforms: uniforms,
    attributes: attributes,
    vertexShader: document.querySelector( '#vertexshader' ).text,
    fragmentShader: document.querySelector( '#fragmentshader' ).text);

  var radius = 50.0,
      segments = 128,
      rings = 64;

  var geometry = new SphereGeometry( radius, segments, rings )..isDynamic = true;

  sphere = new Mesh( geometry, shaderMaterial );

  scene.add( sphere );

  var vertices = sphere.geometry.vertices;

  noise = new List.generate(vertices.length, (_) => rnd.nextDouble() * 5);
  displacement.value.addAll(new List.filled(vertices.length, 0));

  renderer = new WebGLRenderer( clearColorHex: 0x050505, clearAlpha: 1 )
  ..setSize( WIDTH, HEIGHT );

  Element container = document.querySelector( '#container' )
  ..children.add( renderer.domElement );

  window.onResize.listen( onWindowResize );
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

  var time = new DateTime.now().millisecondsSinceEpoch * 0.01;

  sphere.rotation.y = sphere.rotation.z = 0.01 * time;

  amplitude.value = 2.5 * Math.sin( sphere.rotation.y * 0.125 );
  color.value.offsetHSL( 0.0005, 0, 0 );

  for ( var i = 0; i < displacement.value.length; i ++ ) {

    displacement.value[ i ] = Math.sin( 0.1 * i + time );

    noise[ i ] += 0.5 * ( 0.5 - rnd.nextDouble() );
    noise[ i ] = clamp( noise[ i ], -5, 5 );

    displacement.value[ i ] += noise[ i ];

  }

  displacement.needsUpdate = true;

  renderer.render( scene, camera );

}