/// Port of http://alteredqualia.com/three/examples/webgl_cubes.html

import 'dart:html';
import 'dart:math' as Math;
import 'package:three/three.dart';
import 'package:vector_math/vector_math.dart';

// 150,000 cubes
// 12 triangles per cube (6 quads)

const TRIANGLES = 12 * 150000;

const D = 10.0;

Element container;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

Mesh mesh;
Map<String, Uniform> uniforms;

Color color = new Color();

Vector3 pA = new Vector3.zero(),
        pB = new Vector3.zero(),
        pC = new Vector3.zero();

Vector3 cb = new Vector3.zero();
Vector3 ab = new Vector3.zero();

Matrix4 m = new Matrix4.identity();
Matrix4 m2 = new Matrix4.identity();

Vector3 e = new Vector3( 0.0, 0.0, 0.0 );
Vector3 t = new Vector3.zero();
Vector3 tt = new Vector3.zero();
Vector3 u = new Vector3( 0.0, 1.0, 0.0 );

Vector3 v1 = new Vector3( 0.0, 0.0, 0.0 ),
        v2 = new Vector3(   D, 0.0, 0.0 ),
        v3 = new Vector3(   D,   D, 0.0 ),
        v4 = new Vector3( 0.0,   D, 0.0 );

Vector3 v1b = new Vector3( 0.0, 0.0, D ),
    v2b = new Vector3(   D, 0.0, D ),
    v3b = new Vector3(   D,   D, D ),
    v4b = new Vector3( 0.0,   D, D );

BufferGeometry geometry;

void main() {
  init();
  animate(0);
}

void init() {

  container = document.querySelector( '#container' );

  camera = new PerspectiveCamera( 37.0, window.innerWidth / window.innerHeight, 1.0, 8000.0 )
  ..position.z = 2750.0
  ..position.y = 1250.0;

  scene = new Scene();

  camera.lookAt( scene.position );


  // BufferGeometry with unindexed triangles
  // use vertex colors to store centers of rotations

  geometry = new BufferGeometry()
  ..aPosition =  new GeometryAttribute.float32(TRIANGLES * 3 * 3, 3)
  ..aNormal =  new GeometryAttribute.float32(TRIANGLES * 3 * 3, 3)
  ..aColor =  new GeometryAttribute.float32(TRIANGLES * 3 * 3, 3);

  // break geometry into
  // chunks of 20,000 triangles (3 unique vertices per triangle)
  // for indices to fit into 16 bit integer number

  var chunkSize = 20000;

  // Generate a single buffer with all the cubes

  var n = 8000; // triangles spread in the cube
  var d2 = D/2; // individual triangle size

  //

  var rnd = new Math.Random();

  for ( var i = 0; i < TRIANGLES; i += 12 ) {

    var x = randFloat( 0.1 * n, 0.2 * n ) * ( rnd.nextBool() ? 1 : -1 ) * randInt( 0.5, 2 );
    var y = randFloat( 0.1 * n, 0.2 * n ) * ( rnd.nextBool() ? 1 : -1 ) * randInt( 0.5, 2 );
    var z = randFloat( 0.1 * n, 0.2 * n ) * ( rnd.nextBool() ? 1 : -1 ) * randInt( 0.5, 2 );

    tt.setValues( rnd.nextDouble(), rnd.nextDouble(), rnd.nextDouble() );

    //

    _addTriangle( i,   x, y, z, v1, v2, v4 );
    _addTriangle( i + 1, x, y, z, v2, v3, v4 );

    _addTriangle( i + 2, x, y, z, v4b, v2b, v1b );
    _addTriangle( i + 3, x, y, z, v4b, v3b, v2b );

    //

    _addTriangle( i + 4, x, y, z, v1b, v2, v1 );
    _addTriangle( i + 5, x, y, z, v1b, v2b, v2 );


    _addTriangle( i + 6, x, y, z, v2b, v3, v2 );
    _addTriangle( i + 7, x, y, z, v2b, v3b, v3 );

    //

    _addTriangle( i + 8, x, y, z, v3b, v4, v3 );
    _addTriangle( i + 9, x, y, z, v3b, v4b, v4 );

    _addTriangle( i + 10, x, y, z, v1, v4, v1b );
    _addTriangle( i + 11, x, y, z, v4, v4b, v1b );


  }

  geometry.computeBoundingSphere();

  // Set up custom shader material

  uniforms = { "amplitude": new Uniform.float(0.0) };

  var material = new ShaderMaterial(
    uniforms: uniforms,
    vertexShader: document.querySelector( '#vertexShader' ).text,
    fragmentShader: document.querySelector( '#fragmentShader' ).text,
    vertexColors: VertexColors
  );

  //

  mesh = new Mesh( geometry, material );
  scene.add( mesh );

  //

  renderer = new WebGLRenderer( antialias: false, clearColorHex: 0x050505, clearAlpha: 1, alpha: false );
  renderer.setSize( window.innerWidth, window.innerHeight );

  container.children.add( renderer.domElement );

  //

  window.onResize.listen( onWindowResize );
}

_addTriangle( int k, double x, double y, double z, Vector3 vc, Vector3 vb, Vector3 va ) {

  var positions = geometry.aPosition.array,
      normals = geometry.aNormal.array,
      colors = geometry.aColor.array;

  // positions

  pA.setFrom( va );
  pB.setFrom( vb );
  pC.setFrom( vc );

  t.setValues( x, y, z );
  t.scale( 0.5 );

  makeLookAt(m, e, tt, u );

  m2.setIdentity().setTranslation( t );

  m2.multiply( m );

  m2.transform3( pA );
  m2.transform3( pB );
  m2.transform3( pC );

  var ax = pA.x;
  var ay = pA.y;
  var az = pA.z;

  var bx = pB.x;
  var by = pB.y;
  var bz = pB.z;

  var cx = pC.x;
  var cy = pC.y;
  var cz = pC.z;

  var j = k * 9;

  positions[ j ]     = ax;
  positions[ j + 1 ] = ay;
  positions[ j + 2 ] = az;

  positions[ j + 3 ] = bx;
  positions[ j + 4 ] = by;
  positions[ j + 5 ] = bz;

  positions[ j + 6 ] = cx;
  positions[ j + 7 ] = cy;
  positions[ j + 8 ] = cz;

  // flat face normals

  pA.setValues( ax, ay, az );
  pB.setValues( bx, by, bz );
  pC.setValues( cx, cy, cz );

  cb.setFrom( pC - pB );
  ab.setFrom( pA - pB );
  cb = cb.cross( ab );

  cb.normalize();

  var nx = cb.x;
  var ny = cb.y;
  var nz = cb.z;

  normals[ j ]     = nx;
  normals[ j + 1 ] = ny;
  normals[ j + 2 ] = nz;

  normals[ j + 3 ] = nx;
  normals[ j + 4 ] = ny;
  normals[ j + 5 ] = nz;

  normals[ j + 6 ] = nx;
  normals[ j + 7 ] = ny;
  normals[ j + 8 ] = nz;

  // colors

  color.setRGB( t.x, t.y, t.z );

  colors[ j ]     = color.r;
  colors[ j + 1 ] = color.g;
  colors[ j + 2 ] = color.b;

  colors[ j + 3 ] = color.r;
  colors[ j + 4 ] = color.g;
  colors[ j + 5 ] = color.b;

  colors[ j + 6 ] = color.r;
  colors[ j + 7 ] = color.g;
  colors[ j + 8 ] = color.b;

}

onWindowResize(event) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize( window.innerWidth, window.innerHeight );
}

animate(num time) {
  window.requestAnimationFrame( animate );
  render();
  //stats.update();
}

var _time = new DateTime.now().millisecondsSinceEpoch * 0.001;
render() {

  var time = new DateTime.now().millisecondsSinceEpoch * 0.001;
  var delta = time - _time;
  _time = time;

  //print(time);
  mesh.rotation
  ..x += (delta * 0.025)
  ..y += (delta * 0.05);

  uniforms["amplitude"].value += (2 * delta);

  renderer.render( scene, camera );

}
