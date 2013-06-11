import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;

class WebGL_Custom_Attributes  {
  PerspectiveCamera camera;
  Scene scene;
  Renderer renderer;

  Map<String, Uniform> uniforms;
  Map<String, Attribute> attributes;
  Mesh sphere;

  var noise = [];

  var WIDTH = window.innerWidth,
      HEIGHT = window.innerHeight;

  void run() {
    init();
    animate(0);
  }

  void init() {

    camera = new PerspectiveCamera( 30.0, WIDTH / HEIGHT, 1.0, 10000.0 );
    camera.position.z = 300.0;

    scene = new Scene();

    attributes = {
                  "displacement": new Attribute.float()
    };

    uniforms = {
                "amplitude": new Uniform.float(1.0),
                "color": new Uniform.color( 0xff2200 ),
                "texture": new Uniform.texture(ImageUtils.loadTexture("textures/water.jpg")),

    };

    uniforms["texture"].value.wrapS = uniforms["texture"].value.wrapT = RepeatWrapping;

    var shaderMaterial = new ShaderMaterial(
      uniforms:     uniforms,
      attributes:     attributes,
      vertexShader:   document.query( '#vertexshader' ).text,
      fragmentShader: document.query( '#fragmentshader' ).text
    );


    var radius = 50.0, segments = 128, rings = 64;
    var geometry = new SphereGeometry( radius, segments, rings );
    geometry.isDynamic = true;

    sphere = new Mesh( geometry, shaderMaterial );

    var vertices = sphere.geometry.vertices;

    var values = attributes["displacement"].value;

    var rnd = new Math.Random();

    vertices.forEach((_) {
      values.add(0);
      noise.add(rnd.nextDouble() * 5);
    });

    scene.add( sphere );

    renderer = new WebGLRenderer( clearColorHex: 0x050505, clearAlpha: 1 )
    ..setSize( WIDTH, HEIGHT );

    Element container = document.query( '#container' )
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

    uniforms["amplitude"].value = 2.5 * Math.sin( sphere.rotation.y * 0.125 );
    uniforms["color"].value.offsetHSL( 0.0005, 0, 0 );

    var rnd = new Math.Random();

    for ( var i = 0; i < attributes["displacement"].value.length; i ++ ) {

      attributes["displacement"].value[ i ] = Math.sin( 0.1 * i + time );

      noise[ i ] += 0.5 * ( 0.5 - rnd.nextDouble() );
      noise[ i ] = clamp( noise[ i ], -5, 5 );

      attributes["displacement"].value[ i ] += noise[ i ];

    }

    attributes["displacement"].needsUpdate = true;

    renderer.render( scene, camera );

  }

}

void main() {
  new WebGL_Custom_Attributes().run();
}
