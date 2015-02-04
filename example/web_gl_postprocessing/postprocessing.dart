import 'dart:math' show Random;
import 'dart:html' show window, document;
import 'package:three/three.dart';
import 'package:three/extras/shaders/shaders.dart';
import 'package:three/extras/postprocessing/postprocessing.dart';
import 'package:stats/stats.dart';

const double DOT_SCALE = 2.0;
const double RGB_SHIFT_AMOUNT = 0.009;

EffectComposer composer;
Object3D spheres;
Stats stats;

void main() {
  init();
  animate(0.0);
}

void init() {
  WebGLRenderer renderer = new WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.append(renderer.domElement);

  Scene scene = new Scene();
  PerspectiveCamera camera = new PerspectiveCamera(70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0);
  camera.position.z = 400.0;
  spheres = new Object3D();
  scene.add(spheres);
  SphereGeometry geometry = new SphereGeometry(1.0, 4, 4);
  MeshPhongMaterial material = new MeshPhongMaterial(color: 0xaaaaaa, shading: FlatShading);
  Random random = new Random();
  for (var i = 0; i < 100; ++i) {
    var mesh = new Mesh(geometry, material);
    mesh.position.setValues(
        random.nextDouble() - 0.5,
        random.nextDouble() - 0.5,
        random.nextDouble() - 0.5).normalize();
    mesh.position.scale(random.nextDouble() * 400);
    mesh.rotation.setValues(random.nextDouble() * 2, random.nextDouble() * 2, random.nextDouble() * 2);
    mesh.scale.x = mesh.scale.y = mesh.scale.z = random.nextDouble() * 50;
    spheres.add(mesh);
  }

  scene.add(new AmbientLight(0x222222));
  scene.add(new DirectionalLight(0xffffff)..position.setValues(1.0, 1.0, 1.0));


  // postprocessing
  composer = new EffectComposer(renderer);
  composer.addPass(new RenderPass(scene, camera));

  ShaderPass effect1 = new ShaderPass(new ShaderProgram.fromThreeish(DotScreenShader));
  effect1.uniforms['scale'].value = DOT_SCALE;
  composer.addPass(effect1);

  ShaderPass effect2 = new ShaderPass(new ShaderProgram.fromThreeish(RGBShiftShader));
  effect2.uniforms['amount'].value = RGB_SHIFT_AMOUNT;
  effect2.renderToScreen = true;
  composer.addPass(effect2);

  stats = new Stats();
  document.body.append(stats.container);

  window.onResize.listen((event) {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
  });
}

double oldTime = 0.0;
void animate(double time) {
  stats.begin();
  spheres.rotation.x += 0.005;
  spheres.rotation.y += 0.01;
  composer.render(time - oldTime);
  oldTime = time;
  stats.end();
  window.requestAnimationFrame(animate);
}
