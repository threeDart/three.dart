part of three;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 *  - shows frustum, line of sight and up of the camera
 *  - suitable for fast updates
 *  - based on frustum visualization in lightgl.js shadowmap example
 *    http://evanw.github.com/lightgl.js/tests/shadowmap.html
 */

class CameraHelper extends Line {

  static Projector __projector = new Projector();
  static Vector3 __v = new Vector3();
  static Camera __c = new Camera(0 ,0);

  Camera camera;

  Matrix4 matrixWorld;
  bool matrixAutoUpdate;
  Map pointMap;

  CameraHelper( this.camera ) :
    matrixAutoUpdate = false,
    pointMap = {},
    super(
        new Geometry(),
        new LineBasicMaterial( color: 0xffffff, vertexColors: FaceColors ),
        LinePieces) {

    matrixWorld = camera.matrixWorld;
    // colors

    var hexFrustum = 0xffaa00;
    var hexCone = 0xff0000;
    var hexUp = 0x00aaff;
    var hexTarget = 0xffffff;
    var hexCross = 0x333333;

    // near

    addLine( "n1", "n2", hexFrustum );
    addLine( "n2", "n4", hexFrustum );
    addLine( "n4", "n3", hexFrustum );
    addLine( "n3", "n1", hexFrustum );

    // far

    addLine( "f1", "f2", hexFrustum );
    addLine( "f2", "f4", hexFrustum );
    addLine( "f4", "f3", hexFrustum );
    addLine( "f3", "f1", hexFrustum );

    // sides

    addLine( "n1", "f1", hexFrustum );
    addLine( "n2", "f2", hexFrustum );
    addLine( "n3", "f3", hexFrustum );
    addLine( "n4", "f4", hexFrustum );

    // cone

    addLine( "p", "n1", hexCone );
    addLine( "p", "n2", hexCone );
    addLine( "p", "n3", hexCone );
    addLine( "p", "n4", hexCone );

    // up

    addLine( "u1", "u2", hexUp );
    addLine( "u2", "u3", hexUp );
    addLine( "u3", "u1", hexUp );

    // target

    addLine( "c", "t", hexTarget );
    addLine( "p", "c", hexCross );

    // cross

    addLine( "cn1", "cn2", hexCross );
    addLine( "cn3", "cn4", hexCross );

    addLine( "cf1", "cf2", hexCross );
    addLine( "cf3", "cf4", hexCross );

    update();
  }

  addLine( a, b, hex ) {

    addPoint( a, hex );
    addPoint( b, hex );

  }

  addPoint( id, hex ) {

    geometry.vertices.add( new Vector3() );
    geometry.colors.add( new Color( hex ) );

    if ( !pointMap.containsKey( id )) {
      pointMap[ id ] = [];
    }

    pointMap[ id ].add( geometry.vertices.length - 1 );

  }

  setPoint( point, x, y, z ) {

    __v.setValues( x, y, z );
    __projector.unprojectVector( __v, __c );

    var points = pointMap[ point ];

    if ( points != null ) {

      var il = points.length;
      for ( var i = 0; i < il; i ++ ) {

        geometry.vertices[ points[ i ] ].copy( __v );

      }

    }

  }
  update() {

    var w = 1, h = 1;

    // we need just camera projection matrix
    // world matrix must be identity

    __c.projectionMatrix.copy( camera.projectionMatrix );

    // center / target

    setPoint( "c", 0, 0, -1 );
    setPoint( "t", 0, 0,  1 );

    // near

    setPoint( "n1", -w, -h, -1 );
    setPoint( "n2",  w, -h, -1 );
    setPoint( "n3", -w,  h, -1 );
    setPoint( "n4",  w,  h, -1 );

    // far

    setPoint( "f1", -w, -h, 1 );
    setPoint( "f2",  w, -h, 1 );
    setPoint( "f3", -w,  h, 1 );
    setPoint( "f4",  w,  h, 1 );

    // up

    setPoint( "u1",  w * 0.7, h * 1.1, -1 );
    setPoint( "u2", -w * 0.7, h * 1.1, -1 );
    setPoint( "u3",        0, h * 2,   -1 );

    // cross

    setPoint( "cf1", -w,  0, 1 );
    setPoint( "cf2",  w,  0, 1 );
    setPoint( "cf3",  0, -h, 1 );
    setPoint( "cf4",  0,  h, 1 );

    setPoint( "cn1", -w,  0, -1 );
    setPoint( "cn2",  w,  0, -1 );
    setPoint( "cn3",  0, -h, -1 );
    setPoint( "cn4",  0,  h, -1 );



    geometry["verticesNeedUpdate"] = true;

  }

}


