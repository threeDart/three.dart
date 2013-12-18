import 'dart:html';
import 'dart:math' show Random, PI;
import 'package:vector_math/vector_math.dart';
import 'package:three/three.dart';
import 'package:three/extras/controls/first_person_controls.dart';
import 'package:three/extras/geometry_utils.dart' as GeometryUtils;
import 'package:three/extras/image_utils.dart' as ImageUtils;
import 'improved_noise.dart';

Element container;

PerspectiveCamera camera;
FirstPersonControls controls;
Scene scene;
WebGLRenderer renderer;

var worldWidth = 128,
    worldDepth = 128,
    worldHalfWidth = worldWidth ~/ 2,
    worldHalfDepth = worldDepth ~/ 2,
    data = _generateHeight( worldWidth, worldDepth );

void main() {
  init();
  animate(0);
}

void init() {

  container = new Element.tag('div');
  document.body.nodes.add( container );

  camera = new PerspectiveCamera( 60.0, window.innerWidth / window.innerHeight, 1.0, 20000.0 )
  ..position.y = _getY( worldHalfWidth, worldHalfDepth ) * 100 + 100;

  controls = new FirstPersonControls( camera )
  ..movementSpeed = 1000
  ..lookSpeed = 0.125
  ..lookVertical = true;


  scene = new Scene();
  scene.add(camera);

// sides

  var pxGeometry = new PlaneGeometry( 100.0, 100.0 );
  pxGeometry.faceVertexUvs[ 0 ][ 0 ][ 0 ].v = 0.5;
  pxGeometry.faceVertexUvs[ 0 ][ 0 ][ 3 ].v = 0.5;
  pxGeometry.applyMatrix( new Matrix4.rotationY( PI / 2 ) );
  pxGeometry.applyMatrix( new Matrix4.translationValues( 50.0, 0.0, 0.0 ) );

  var nxGeometry = new PlaneGeometry( 100.0, 100.0 );
  nxGeometry.faceVertexUvs[ 0 ][ 0 ][ 0 ].v = 0.5;
  nxGeometry.faceVertexUvs[ 0 ][ 0 ][ 3 ].v = 0.5;
  nxGeometry.applyMatrix( new Matrix4.rotationY( - PI / 2 ) );
  nxGeometry.applyMatrix( new Matrix4.translationValues( - 50.0, 0.0, 0.0 ) );

  var pyGeometry = new PlaneGeometry( 100.0, 100.0 );
  pyGeometry.faceVertexUvs[ 0 ][ 0 ][ 1 ].v = 0.5;
  pyGeometry.faceVertexUvs[ 0 ][ 0 ][ 2 ].v = 0.5;
  pyGeometry.applyMatrix( new Matrix4.rotationX( - PI / 2 ) );
  pyGeometry.applyMatrix( new Matrix4.translationValues( 0.0, 50.0, 0.0 ) );

  var pzGeometry = new PlaneGeometry( 100.0, 100.0 );
  pzGeometry.faceVertexUvs[ 0 ][ 0 ][ 0 ].v = 0.5;
  pzGeometry.faceVertexUvs[ 0 ][ 0 ][ 3 ].v = 0.5;
  pzGeometry.applyMatrix( new Matrix4.translationValues( 0.0, 0.0, 50.0 ) );

  var nzGeometry = new PlaneGeometry( 100.0, 100.0 );
  nzGeometry.faceVertexUvs[ 0 ][ 0 ][ 0 ].v = 0.5;
  nzGeometry.faceVertexUvs[ 0 ][ 0 ][ 3 ].v = 0.5;
  nzGeometry.applyMatrix( new Matrix4.rotationY( PI ) );
  nzGeometry.applyMatrix( new Matrix4.translationValues( 0.0, 0.0, -50.0 ) );

  //

  var geometry = new Geometry();
  var dummy = new Mesh(null);

  for ( var z = 0; z < worldDepth; z ++ ) {

    for ( var x = 0; x < worldWidth; x ++ ) {

      var h = _getY( x, z );

      dummy.position.x = x * 100.0 - worldHalfWidth * 100;
      dummy.position.y = h * 100.0;
      dummy.position.z = z * 100.0 - worldHalfDepth * 100;

      var px = _getY( x + 1, z );
      var nx = _getY( x - 1, z );
      var pz = _getY( x, z + 1 );
      var nz = _getY( x, z - 1 );

      dummy.geometry = pyGeometry;
      GeometryUtils.merge( geometry, dummy );

      if ( ( px != h && px != h + 1 ) || x == 0 ) {

        dummy.geometry = pxGeometry;
        GeometryUtils.merge( geometry, dummy );

      }

      if ( ( nx != h && nx != h + 1 ) || x == worldWidth - 1 ) {

        dummy.geometry = nxGeometry;
        GeometryUtils.merge( geometry, dummy );

      }

      if ( ( pz != h && pz != h + 1 ) || z == worldDepth - 1 ) {

        dummy.geometry = pzGeometry;
        GeometryUtils.merge( geometry, dummy );

      }

      if ( ( nz != h && nz != h + 1 ) || z == 0 ) {

        dummy.geometry = nzGeometry;
        GeometryUtils.merge( geometry, dummy );

      }

    }

  }

  var texture = ImageUtils.loadTexture( 'atlas.png' );
  texture.magFilter = NearestFilter;
  texture.minFilter = LinearMipMapLinearFilter;

  var mesh = new Mesh( geometry, new MeshLambertMaterial( map: texture, ambient: 0xbbbbbb ) );
  scene.add( mesh );

  var ambientLight = new AmbientLight( 0xcccccc );
  scene.add( ambientLight );

  var directionalLight = new DirectionalLight( 0xffffff, 2 );
  directionalLight.position.setValues( 1.0, 1.0, 0.5 ).normalize();
  scene.add( directionalLight );

  renderer = new WebGLRenderer(alpha: false, clearColorHex: 0xbfd1e5);
  renderer.setSize( window.innerWidth, window.innerHeight );

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

var _time = new DateTime.now().millisecondsSinceEpoch;

render() {

  var now = new DateTime.now().millisecondsSinceEpoch;
  var delta = new DateTime.now().millisecondsSinceEpoch - _time;
  _time = now;

  controls.update( 0.01 );
  renderer.render( scene, camera );

}

_getY( x, z ) {
  var idx = x + z * worldWidth;
  if (idx < 0 || idx >= data.length) return 0;
  return data[ idx ] * 0.2;
}

_generateHeight( width, height ) {

  var size = width * height,
      data = new List(size),
      perlin = new ImprovedNoise(),
      quality = 2.0,
      z = new Random().nextInt(100).toDouble();

  for ( var j = 0; j < 4; j ++ ) {

    if ( j == 0 ) for ( var i = 0; i < size; i ++ ) data[ i ] = 0;

    for ( var i = 0; i < size; i ++ ) {

      var x = i % width,
          y = i / width;
      data[ i ] += perlin.noise( x / quality, y / quality, z ) * quality;


    }

    quality *= 4;

  }

  return data;

}