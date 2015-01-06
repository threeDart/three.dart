import 'dart:math' as Math;
import 'dart:html';
import 'package:three/three.dart';
import 'package:three/extras/shaders/shaders.dart';
import 'package:three/extras/postprocessing/postprocessing.dart';

WebGLRenderer renderer;
Scene scene;
PerspectiveCamera camera;
EffectComposer composer;
Object3D object;
DirectionalLight light;
Math.Random random = new Math.Random();

void main() {
  init();
  animate(0.0);
}

void init() {
  renderer = new WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.append(renderer.domElement);

  camera = new PerspectiveCamera(
      70.0,
      window.innerWidth / window.innerHeight,
      1.0,
      1000.0);
  camera.position.z = 400.0;

  scene = new Scene();
  scene.fog = new Fog(new Color(0x000000));
  object = new Object3D();
  scene.add(object);

  var geometry = new SphereGeometry(1.0, 4, 4);
  var material = new MeshPhongMaterial(color: 0xffffff, shading: FlatShading);

  for (var i = 0; i < 100; ++i) {
    var mesh = new Mesh(geometry, material);
    mesh.position.setValues(
        random.nextDouble() - 0.5,
        random.nextDouble() - 0.5,
        random.nextDouble() - 0.5).normalize();
    mesh.position.scale(random.nextDouble() * 400);
    mesh.rotation.setValues(
        random.nextDouble() * 2,
        random.nextDouble() * 2,
        random.nextDouble() * 2);
    mesh.scale.x = mesh.scale.y = mesh.scale.z = random.nextDouble() * 50;
    object.add(mesh);
  }
  scene.add(new AmbientLight(0x222222));
  light = new DirectionalLight(0xffffff);
  light.position.setValues(1.0, 1.0, 1.0);
  scene.add(light);

  // postprocessing
  composer = new EffectComposer(renderer);
  composer.addPass(new RenderPass(scene, camera));
  var effect1 = new ShaderPass(new ShaderProgram.fromThreeish(DotScreenShader));
  effect1.uniforms['scale'].value = 4;
  composer.addPass(effect1);
  //var effect2 = new ShaderPass(new ShaderProgram.fromThreeish(RGBShiftShader));
  //effect2.uniforms['amount'].value = 0.0015;
  //effect2.renderToScreen = true;
  //composer.addPass(effect2);

  window.onResize.listen(onWindowResize);
}

void onWindowResize(Event event) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
}

double oldTime = 0.0;
void animate(double time) {
  window.requestAnimationFrame(animate);
  object.rotation.x += 0.005;
  object.rotation.y += 0.01;
  composer.render(time - oldTime);
  //renderer.render(scene, camera);
  oldTime = time;
}
