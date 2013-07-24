import 'dart:html';
import 'dart:json';
import 'package:three/three.dart';
import 'package:three/extras/image_utils.dart' as ImageUtils; // TODO - Use Re-export
import 'package:three/extras/font_utils.dart' as FontUtils; 

var helvetiker_regular = { }; 

class WebGL_Text  {
  Element container;

  PerspectiveCamera camera;
  Scene scene;
  WebGLRenderer renderer;

  Mesh fontmesh;

  void run() {
  
    var path = "fonts/helvetiker_regular.json";
    
    HttpRequest.getString(path).then((String responseText) {
      
      helvetiker_regular = parse(responseText);
      
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

    FontUtils.loadFace(helvetiker_regular);
    
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

}

void main() {
  new WebGL_Text().run();
}
