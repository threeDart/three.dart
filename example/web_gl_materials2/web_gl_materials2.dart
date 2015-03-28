import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;

DivElement container;

WebGLRenderer renderer;
PerspectiveCamera camera;

List objects = [];

Mesh particleLight;
PointLight pointLight;

Scene scene;

var rnd = new Math.Random().nextDouble;

void main() {
  init();
  animate(0);
}

void init() {
  container = new DivElement();
  document.body.append(container);
  
  camera = new PerspectiveCamera(40.0, window.innerWidth / window.innerHeight, 1.0, 2000.0)
    ..position.y = 200.0;
  
  scene = new Scene();

  var imgTexture2 = ImageUtils.loadTexture("moon.jpg");
  imgTexture2.wrapS = imgTexture2.wrapT = RepeatWrapping;
  imgTexture2.anisotropy = 16;

  var imgTexture = ImageUtils.loadTexture("lava.jpg");
  imgTexture.repeat.setValues(4.0, 2.0);
  imgTexture.wrapS = imgTexture.wrapT = RepeatWrapping;
  imgTexture.anisotropy = 16;

  var materials = 
      [new MeshPhongMaterial(map: imgTexture, bumpMap: imgTexture, bumpScale: 1.0, color: 0xffffff, ambient: 0x777777, specular: 0x333333, shininess: 50.0, shading: SmoothShading),
       new MeshPhongMaterial(map: imgTexture, bumpMap: imgTexture, bumpScale: 1.0, color: 0x00ff00, ambient: 0x777777, specular: 0x333333, shininess: 50.0, shading: SmoothShading),
       new MeshPhongMaterial(map: imgTexture, bumpMap: imgTexture, bumpScale: 1.0, color: 0x00ff00, ambient: 0x007700, specular: 0x333333, shininess: 50.0, shading: SmoothShading),
       new MeshPhongMaterial(map: imgTexture, bumpMap: imgTexture, bumpScale: 1.0, color: 0x000000, ambient: 0x00ff00, specular: 0x333333, shininess: 50.0, shading: SmoothShading),
       
       new MeshLambertMaterial(map: imgTexture, color: 0xffffff, ambient: 0x777777, shading: SmoothShading),
       new MeshLambertMaterial(map: imgTexture, color: 0xff0000, ambient: 0x777777, shading: SmoothShading),
       new MeshLambertMaterial(map: imgTexture, color: 0xff0000, ambient: 0x770000, shading: SmoothShading),
       new MeshLambertMaterial(map: imgTexture, color: 0x000000, ambient: 0xff0000, shading: SmoothShading),

       new MeshPhongMaterial(map: imgTexture2, bumpMap: imgTexture2, bumpScale: 1.0, color: 0x000000, ambient: 0x000000, specular: 0xffaa00, shininess: 15.0, metal: true, shading: SmoothShading),
       new MeshPhongMaterial(map: imgTexture2, bumpMap: imgTexture2, bumpScale: 1.0, color: 0x000000, ambient: 0x000000, specular: 0xaaff00, shininess: 15.0, metal: true, shading: SmoothShading),
       new MeshPhongMaterial(map: imgTexture2, bumpMap: imgTexture2, bumpScale: 1.0, color: 0x000000, ambient: 0x000000, specular: 0x00ffaa, shininess: 15.0, metal: true, shading: SmoothShading),
       new MeshPhongMaterial(map: imgTexture2, bumpMap: imgTexture2, bumpScale: 1.0, color: 0x000000, ambient: 0x000000, specular: 0x00aaff, shininess: 15.0, metal: true, shading: SmoothShading)];

  // Spheres geometry

  var geometry_smooth = new SphereGeometry(70.0, 32, 16);
  var geometry_flat = new SphereGeometry(70.0, 32, 16);


  for (var i = 0; i < materials.length; i++) {
    var material = materials[i];

    var geometry = material.shading == FlatShading ? geometry_flat : geometry_smooth;

    var sphere = new Mesh(geometry, material)
        ..position.x = (i % 4) * 200.0 - 200.0
        ..position.z = (i / 4).floor() * 200.0 - 200.0;

    objects.add(sphere);

    scene.add(sphere);
  }
  
  particleLight = new Mesh( new SphereGeometry( 4.0, 8, 8 ), new MeshBasicMaterial(color: 0xffffff) );
  scene.add( particleLight );

  // Lights
  
  scene.add(new AmbientLight(0x444444));
  
  scene.add(new DirectionalLight(0xffffff, 1.0)..position.setValues(1.0, 1.0, 1.0).normalize());
  

  var directionalLight = new DirectionalLight( 0xffffff, 1.0 );
  directionalLight.position.setValues( 1.0, 1.0, 1.0 ).normalize();
  scene.add(directionalLight);
  
  var pointLight = new PointLight( 0xffffff, intensity: 2.0, distance: 800.0 );
  particleLight.add(pointLight);
  
  //
  
  renderer = new WebGLRenderer(antialias: true)
    ..setSize(window.innerWidth, window.innerHeight)
    ..setClearColorHex(0x0a0a0a, 1)
    ..sortObjects = true
 
    ..gammaInput = true
    ..gammaOutput = true;

  container.append(renderer.domElement);
  
  window.onResize.listen(onWindowResize);
}

void onWindowResize(Event e) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  render();
}

void render() {
  var timer = new DateTime.now().millisecondsSinceEpoch * 0.0001;

  camera.position.x = Math.cos(timer) * 800;
  camera.position.z = Math.sin(timer) * 800;

  camera.lookAt(scene.position);

  objects.forEach((object) => object.rotation.y += 0.005);

  particleLight.position.x = Math.sin(timer * 7) * 300;
  particleLight.position.y = Math.cos(timer * 5) * 400;
  particleLight.position.z = Math.cos(timer * 3) * 300;

  renderer.render(scene, camera);
}