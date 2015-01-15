/*
 * @author Thibaut 'BKcore' Despoulain <http://bkcore.com>
 *
 * Ported to Dart from JS by
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

import 'dart:math';
import 'dart:html';
import 'package:three/three.dart';
import 'package:three/extras/shaders/shaders.dart';
import 'package:three/extras/postprocessing/postprocessing.dart';
//import 'package:datgui/datgui.dart' as dat;
import 'package:stats/stats.dart';

const int COLOR1 = 0x77bbff;
const int COLOR11 = 0x99ddff;
const int COLOR2 = 0x8ec5e5;
const int COLOR3 = 0x97a8ba;
const double BLURINESS = 10.0;

double mouseX = 0.0;
double mouseY = 0.0;
WebGLRenderer renderer;
Scene scene, oclscene;
PerspectiveCamera camera, oclcamera;
EffectComposer oclcomposer, finalComposer;
ShaderPass hblur, vblur;
PointLight pointLight;
Mesh vlight;
ShaderPass godrayPass;
Stats stats;

void main() {
  init();
  animate(0.0);
}

void init() {
  // renderer init
  renderer = new WebGLRenderer()
      ..autoClear = false
      //..sortObjects = true
      ..setSize(window.innerWidth, window.innerHeight);
  document.body.append(renderer.domElement);

  // scenes init
  scene = new Scene();
  oclscene = new Scene();

  // cameras init
  camera = new PerspectiveCamera(
      70.0,
      window.innerWidth / window.innerHeight,
      1.0,
      100000.0)
      ..position.z = 280.0
      ..lookAt(scene.position);
  oclcamera = new PerspectiveCamera(
      70.0,
      window.innerWidth / window.innerHeight,
      1.0,
      100000.0)
      ..position = camera.position
      ..lookAt(scene.position);

  //lights init
  scene.add(new AmbientLight(0xffffff)); // primary scene lights
  pointLight = new PointLight(COLOR3)..position.setValues(0.0, 100.0, 0.0);
  scene.add(pointLight);
  PointLight cameraLight = new PointLight(0x666666);
  camera.add(cameraLight);

  oclscene.add(new AmbientLight(0xffffff)); // ocl scene lights
  vlight = new Mesh(
      new IcosahedronGeometry(50.0, 3),
      new MeshBasicMaterial(color: COLOR11));
  vlight.position = pointLight.position;
  oclscene.add(vlight);

  JSONLoader loader = new JSONLoader();

  void callback(Geometry data) {
    createScene(data);
  }
  loader.load('trondisk.json', callback);

  // postprocessing
  oclcomposer = new EffectComposer(renderer); // ocl composer
  RenderPass oclrenderPass = new RenderPass(oclscene, oclcamera);
  oclcomposer.addPass(oclrenderPass);

  hblur = new ShaderPass(new ShaderProgram.fromThreeish(HorizontalBlurShader));
  hblur.uniforms['h'].value = BLURINESS / window.innerWidth;
  //hblur.renderToScreen = true;
  oclcomposer.addPass(hblur);

  vblur = new ShaderPass(new ShaderProgram.fromThreeish(VerticalBlurShader));
  vblur.uniforms['v'].value = BLURINESS / window.innerHeight;
  //vblur.renderToScreen = true;
  oclcomposer.addPass(vblur);

  oclcomposer.addPass(hblur);
  oclcomposer.addPass(vblur);

  godrayPass = new ShaderPass(new ShaderProgram.fromThreeish(GodraysShader));
  //grPass.renderToScreen = true;
  oclcomposer.addPass(godrayPass);


  finalComposer = new EffectComposer(renderer);
  RenderPass renderModel = new RenderPass(scene, camera);
  finalComposer.addPass(renderModel);

  ShaderPass fxaaPass =
      new ShaderPass(new ShaderProgram.fromThreeish(FXAAShader));
  fxaaPass.uniforms['resolution'].value.setValues(
      1 / window.innerWidth,
      1 / window.innerHeight);
  finalComposer.addPass(fxaaPass);

  ShaderPass finalPass =
      new ShaderPass(new ShaderProgram.fromThreeish(AdditiveShader));
  finalPass.uniforms['tAdd'].value = oclcomposer.readTarget;
  finalPass.renderToScreen = true;
  finalComposer.addPass(finalPass);

  /*
  dat.GUI gui = new dat.GUI();
  gui.add(effectController, "vblur", 1.0, 10.0).onChange(matChanger);
  gui.add(effectController, "hblur", 1.0, 10.0).onChange(matChanger);
  gui.addColor(effectController, 'color').onChange(matChanger);
  gui.close();
   */

  stats = new Stats();
  document.body.append(stats.container);

  window.onResize.listen(onWindowResize);
  document.onMouseMove.listen(onDocumentMouseMove);
}

/*
var effectController = {
  'vblur': BLURINESS,
  'hblur': BLURINESS,
  'color': COLOR11
};

void matChanger(var value) {
  vblur.uniforms['v'].value =
      effectController['vblur'] * 2.0 / window.innerHeight;
  hblur.uniforms['h'].value =
      effectController['hblur'] * 2.0 / window.innerWidth;
  vlight.material.color.setHex(effectController['color']);
  vlight.material.needsUpdate = true;
}
 */

void onDocumentMouseMove(MouseEvent event) {
  mouseX = event.client.x - window.innerWidth.toDouble();
  mouseY = event.client.y - window.innerHeight.toDouble();
}

void onWindowResize(Event event) {
  int winWidth = window.innerWidth;
  int winHeight = window.innerHeight;

  camera.aspect = winWidth / winHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(winWidth, winHeight);
}

void createScene(Geometry geometry) {
  double x = 0.0,
      y = -15.0,
      z = 0.0,
      b = 0.0;

  MeshBasicMaterial zmat = new MeshBasicMaterial();
  Mesh zmesh = new Mesh(geometry, zmat)
      ..position.setValues(x, y, z)
      ..scale.setValues(3.0, 3.0, 3.0);
  scene.add(zmesh);

  MeshBasicMaterial gmat = new MeshBasicMaterial(color: 0x000000);
  Mesh gmesh = new Mesh(geometry, gmat)
      ..position.setValues(x, y / 2, z)
      ..rotation = zmesh.rotation
      ..scale.setValues(1.5, 1.5, 1.5);
  oclscene.add(gmesh);

  // extra fancy
  Mesh m = new Mesh(geometry, zmat);
  m.position.setValues(0.0, 50.0 + y, 0.0);
  m.scale = zmesh.scale;
  scene.add(m);

  m = new Mesh(geometry, zmat);
  m.position.setValues(0.0, -50.0 + y, 0.0);
  m.scale = zmesh.scale;
  scene.add(m);

  m = new Mesh(geometry, gmat);
  m.position.setValues(0.0, 50.0 + y, 0.0);
  m.scale = zmesh.scale;
  oclscene.add(m);

  m = new Mesh(geometry, gmat);
  m.position.setValues(0.0, -50.0 + y, 0.0);
  m.scale = zmesh.scale;
  oclscene.add(m);
}

double t = 0.0;
double oldTime = 0.0;
render(double time) {
  t += 0.1;

  double delta = time - oldTime;

  //camera.position.x += (mouseX / 2 - camera.position.x) * 0.05;
  //camera.position.y += (mouseY / 2 - camera.position.y) * 0.05;

  pointLight.position.setValues(0.0, cos(t / 10) * 65.0, 0.0);
  vlight.updateMatrixWorld();


  oclcomposer.render(delta);
  finalComposer.render(delta);
  oldTime = time;
}

void animate(double time) {
  stats.begin();
  render(time);
  stats.end();
  window.requestAnimationFrame(animate);
}
