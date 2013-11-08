import 'dart:html';
import "dart:async";
import 'dart:convert' show JSON;
import 'package:three/three.dart';
import 'package:three/extras/font_utils.dart' as FontUtils;

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

Mesh fontmesh;

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

  scene = new Scene();

  camera = new PerspectiveCamera( 70.0, window.innerWidth / window.innerHeight, 1.0, 10000.0 );
  camera.position.z = 1200.0;

  scene.add(camera);

  var fontshapes = FontUtils.generateShapes("Hello world");

  MeshBasicMaterial fontmaterial = new MeshBasicMaterial(color: 0xff0000, side: DoubleSide);

  ShapeGeometry fontgeometry = new ShapeGeometry(fontshapes, curveSegments: 20);

  fontmesh = new Mesh(fontgeometry, fontmaterial);

  scene.add(fontmesh);

  renderer = new WebGLRenderer();
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.nodes.add( renderer.domElement );

  window.onResize.listen(onWindowResize);
}

onWindowResize(e) {

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );

}

animate(num time) {

  window.requestAnimationFrame( animate );

  fontmesh.rotation.x += 0.005;
  fontmesh.rotation.y += 0.01;

  renderer.render( scene, camera );

}