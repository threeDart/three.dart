part of three;

class CSS3DObject extends Object3D {

  Element element;

  CSS3DObject( this.element ) : super() {
    element.style.position = "absolute";
    element.style.transformStyle = "preserve-3d";
  }
}

class CSS3DRenderer implements Renderer {
  Projector _projector;
  Element domElement;
  Element cameraElement;
  num _width, _height, _widthHalf, _heightHalf;

  CSS3DRenderer() {

     _projector = new Projector();

    domElement = new Element.tag( 'div' )
    ..style.overflow = 'hidden'
    ..style.transformStyle = 'preserve-3d'
    ..style.perspectiveOrigin = '50% 50%';

    // TODO: Shouldn't it be possible to remove cameraElement?

    cameraElement = new Element.tag( 'div' )
    ..style.transformStyle = 'preserve-3d';

    domElement.children.add( cameraElement );
  }

  setSize( num width, num height ) {

    _width = width;
    _height = height;

    _widthHalf = _width / 2;
    _heightHalf = _height / 2;

    domElement.style
    ..width = '${width}px'
    ..height = '${height}px';

    cameraElement.style
    ..width = '${width}px'
    ..height = '${height}px';

  }

  epsilon( num value ) => ( value.abs() < 0.000001 ) ? 0 : value;

  getCameraCSSMatrix( matrix ) {

    var elements = matrix.elements;

    return 'matrix3d('
          '${epsilon( elements[ 0 ] )},'
          '${epsilon( - elements[ 1 ] )},'
          '${epsilon( elements[ 2 ] )},'
          '${epsilon( elements[ 3 ] )},'
          '${epsilon( elements[ 4 ] )},'
          '${epsilon( - elements[ 5 ] )},'
          '${epsilon( elements[ 6 ] )},'
          '${epsilon( elements[ 7 ] )},'
          '${epsilon( elements[ 8 ] )},'
          '${epsilon( - elements[ 9 ] )},'
          '${epsilon( elements[ 10 ] )},'
          '${epsilon( elements[ 11 ] )},'
          '${epsilon( elements[ 12 ] )},'
          '${epsilon( - elements[ 13 ] )},'
          '${epsilon( elements[ 14 ] )},'
          '${epsilon( elements[ 15 ] )}'
          ')';
  }

  getObjectCSSMatrix( matrix ) {

    var elements = matrix.elements;

    return 'translate3d(-50%,-50%,0px) matrix3d('
          '${epsilon( elements[ 0 ] )},'
          '${epsilon( elements[ 1 ] )},'
          '${epsilon( elements[ 2 ] )},'
          '${epsilon( elements[ 3 ] )},'
          '${epsilon( elements[ 4 ] )},'
          '${epsilon( elements[ 5 ] )},'
          '${epsilon( elements[ 6 ] )},'
          '${epsilon( elements[ 7 ] )},'
          '${epsilon( elements[ 8 ] )},'
          '${epsilon( elements[ 9 ] )},'
          '${epsilon( elements[ 10 ] )},'
          '${epsilon( elements[ 11 ] )},'
          '${epsilon( elements[ 12 ] )},'
          '${epsilon( elements[ 13 ] )},'
          '${epsilon( elements[ 14 ] )},'
          '${epsilon( elements[ 15 ] )}'
          ') scale3d(1,-1,1)';

  }

  render( scene, camera ) {

    var fov = 0.5 / Math.tan( camera.fov * Math.PI / 360 ) * _height;

    domElement.style.perspective = "${fov}px";

    var style = "translate3d(0,0,${fov}px)${getCameraCSSMatrix( camera.matrixWorldInverse )} translate3d(${_widthHalf}px,${_heightHalf}px, 0)";

    cameraElement.style.transform = style;

    var objects = _projector.projectScene( scene, camera, false ).objects;

    var il = objects.length;

    for ( var i = 0; i < il; i ++ ) {

      var object = objects[ i ].object;

      if ( object is CSS3DObject ) {

        var element = object.element;

        style = getObjectCSSMatrix( object.matrixWorld );

        element.style.transform = style;

        if ( element.parent != cameraElement ) {
          cameraElement.children.add( element );
        }
      }
    }
  }

}
