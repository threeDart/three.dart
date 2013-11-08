import 'dart:html';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;

var container, camera, scene, renderer, sphere;
var uniforms, amplitude, color;
var attributes, size, customColor;

var rnd = new Math.Random();

void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 40.0, window.innerWidth / window.innerHeight, 1.0, 10000.00 )
  ..position.z = 300.0;

  scene = new Scene();

  size = new Attribute.float();
  customColor = new Attribute.color();

  attributes = { "size"        : size,
                 "customColor" : customColor };

  amplitude = new Uniform.float(1.0);
  color = new Uniform.color(0xffffff);

  uniforms = { "amplitude" : amplitude,
               "color"     : color,
               "texture"   : new Uniform.texture(ImageUtils.loadTexture("spark1.png")) };

  var shaderMaterial = new ShaderMaterial(uniforms:       uniforms,
                                          attributes:     attributes,
                                          vertexShader:   querySelector('#vertexshader').text,
                                          fragmentShader: querySelector('#fragmentshader').text,
                                          blending:       AdditiveBlending,
                                          depthTest:      false,
                                          transparent:    true);



  var radius = 200.0;
  var geometry = new Geometry();

  for ( var i = 0; i < 100000; i++ ) {

    var vertex = new Vector3.zero();
    vertex.x = rnd.nextDouble() * 2 - 1;
    vertex.y = rnd.nextDouble() * 2 - 1;
    vertex.z = rnd.nextDouble() * 2 - 1;
    vertex.scale(radius);

    geometry.vertices.add( vertex );

  }

  sphere = new ParticleSystem( geometry, shaderMaterial );

  sphere.isDynamic = true;
  //sphere.sortParticles = true;

  var vertices = sphere.geometry.vertices;

  for( var v = 0; v < vertices.length; v++ ) {

    size.value.add(10.0);
    customColor.value.add(new Color( 0xffaa00 ));

    if ( vertices[ v ].x < 0 ) {
      customColor.value[ v ].setHSL( 0.5 + 0.1 * ( v / vertices.length ), 0.7, 0.5 );
    } else {
      customColor.value[ v ].setHSL( 0.0 + 0.1 * ( v / vertices.length ), 0.9, 0.5 );
    }

  }

  scene.add( sphere );

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );
  //renderer.sortObjects = false;

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

  sphere.rotation.z =  delta_in_sec * 0.05;

  for( var i = 0; i < size.value.length; i++ ) {

    size.value[ i ] = 14 + 13 * Math.sin( 0.1 * i + (delta_in_sec * 5) );
  }

  size.needsUpdate = true;

  renderer.render( scene, camera );

}