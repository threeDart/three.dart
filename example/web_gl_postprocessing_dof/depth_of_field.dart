/*
 * Ported to Dart from JS by
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

import 'dart:html';
import 'package:three/three.dart';
import 'package:three/extras/postprocessing/postprocessing.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils;
import 'package:datgui/datgui.dart' as dat;
import 'package:stats/stats.dart';

const int GRID_M = 14;
const int GRID_N = 9;
const int GRID_P = 14;
const int NO_OBJECTS = GRID_M * GRID_N * GRID_P;
const int GRID_SPACING = 200;
const double SPHERE_SCALE = 60.0;
const int SPHERE_PARALLELS = 10;
const int SPHERE_MERIDIANS = 20;
const double FOCUS = 1.0;
const double APERTURE = 0.025;
const double MAX_BLUR = 1.0;

WebGLRenderer renderer;
Scene scene;
PerspectiveCamera camera;
Object3D container;
List<Material> materials;
EffectComposer composer;
BokehPass bokehPass;
Stats stats;

int winWidth = window.innerWidth;
int winHeight = window.innerHeight;
int winHalfWidth = winWidth ~/ 2;
int winHalfHeight = winHeight ~/ 2;
int mouseX = 0;
int mouseY = 0;

void main() {
  init();
  animate(0.0);
}

void init() {
  renderer = new WebGLRenderer(antialias: false)
      ..setSize(winWidth, winHeight)
      ..sortObjects = false;
  document.body.append(renderer.domElement);
  camera = new PerspectiveCamera(70.0, winWidth / winHeight, 1.0, 3000.0)
      ..position.z = 200.0;
  container = new Object3D();
  scene = new Scene();

  Texture cubeTexture = ImageUtils.loadTextureCube(
      ['px', 'nx', 'py', 'ny', 'pz', 'nz']
          .map((halfaxis) => "textures/" + halfaxis + ".jpg").toList());

  SphereGeometry geometry =
      new SphereGeometry(1.0, SPHERE_MERIDIANS, SPHERE_PARALLELS);

  materials = new List<Material>();

  for (int m = 0; m < GRID_M; ++m) //
  for (int n = 0; n < GRID_N; ++n) //
  for (int p = 0; p < GRID_P; ++p) {

    MeshBasicMaterial material = new MeshBasicMaterial(
        color: 0xff1100,
        envMap: cubeTexture,
        shading: FlatShading);
    materials.add(material);
    Mesh mesh = new Mesh(geometry, material);

    double x = GRID_SPACING * (m - GRID_M / 2);
    double y = GRID_SPACING * (n - GRID_N / 2);
    double z = GRID_SPACING * (p - GRID_P / 2);

    mesh.position.setValues(x, y, z);
    mesh.scale.splat(SPHERE_SCALE);
    mesh.matrixAutoUpdate = false;
    mesh.updateMatrix();
    container.add(mesh);
    scene.add(mesh);
  }

  scene.matrixAutoUpdate = false;
  renderer.autoClear = false;

  composer = new EffectComposer(renderer)
      ..addPass(new RenderPass(scene, camera));

  bokehPass = new BokehPass(scene, camera,
      focus: FOCUS,
      aperture: APERTURE,
      maxblur: MAX_BLUR,
      width: winWidth,
      height: winHeight)
      ..renderToScreen = true;
  composer.addPass(bokehPass);

  window.onResize.listen(onWindowResize);
  window.onMouseMove.listen(onMouseMove);
  window.onTouchStart.listen(onTouchStart);
  window.onTouchMove.listen(onTouchMove);

  dat.GUI gui = new dat.GUI();
  gui.add(effectController, "focus", 0.0, 3.0).onChange(matChanger);
  gui.add(effectController, "aperture", 0.001, 0.2).onChange(matChanger);
  gui.add(effectController, "maxblur", 0.0, 3.0).onChange(matChanger);
  gui.close();

  stats = new Stats();
  document.body.append(stats.container);
}

var effectController = {
  'focus': 1.0,
  'aperture': 0.025,
  'maxblur': 1.0
};

void matChanger(var value) {
  bokehPass.uniforms['focus'].value = effectController['focus'];
  bokehPass.uniforms['aperture'].value = effectController['aperture'];
  bokehPass.uniforms['maxblur'].value = effectController['maxblur'];
}

double oldTime = 0.0;

void render(double time) {
  camera.position.x += (mouseX - camera.position.x) * 0.036;
  camera.position.y += (-mouseY - camera.position.y) * 0.036;
  camera.lookAt(scene.position);

  for (int i = 0; i < NO_OBJECTS; ++i) {
    double h = (360 * (i / NO_OBJECTS + time * 0.00005) % 360) / 360;
    materials[i].color.setHSL(h, 1.0, 0.5);
  }

  composer.render(0.1);

  oldTime = time;
}

void animate(double time) {
  stats.begin();
  render(time);
  stats.end();
  window.requestAnimationFrame(animate);
}

void onMouseMove(MouseEvent event) {
  mouseX = event.client.x - winHalfWidth;
  mouseY = event.client.y - winHalfHeight;
}

onTouchStart(TouchEvent event) {
  if (event.touches.length == 1) {
    event.preventDefault();
    mouseX = event.touches.first.page.x - winHalfWidth;
    mouseY = event.touches.first.page.y - winHalfHeight;
  }
}

onTouchMove(TouchEvent event) {
  if (event.touches.length == 1) {
    event.preventDefault();
    mouseX = event.touches.first.page.x - winHalfWidth;
    mouseY = event.touches.first.page.y - winHalfHeight;
  }
}

void onWindowResize(Event event) {
  winWidth = window.innerWidth;
  winHeight = window.innerHeight;
  winHalfWidth = winWidth ~/ winWidth;
  winHalfHeight = winHeight ~/ winHeight;

  camera.aspect = winWidth / winHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(winWidth, winHeight);
  composer.reset(null, winWidth, winHeight);
}
