/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author nelson silva / http://www.inevo.pt/
 *
 * based on rev 5816003656
 **/
library TrackballControls;

import "dart:html";
import "dart:async";
import "dart:math" as Math;
import "package:three/three.dart";

class STATE {
 static const NONE = -1;
 static const ROTATE =  0;
 static const ZOOM = 1;
 static const PAN = 2;
}

class Screen {
  num width, height, offsetLeft, offsetTop;
  Screen({this.width, this.height, this.offsetLeft, this.offsetTop});
}
class TrackballControls extends EventEmitter {

  int _state, _prevState;
  Object3D object;
  Element domElement;
  bool enabled;
  Screen screen;
  num radius;
  num rotateSpeed,
      zoomSpeed,
      panSpeed;
  bool noRotate,
       noZoom,
       noPan;
  bool staticMoving;
  num dynamicDampingFactor;
  num minDistance, maxDistance;
  List keys;
  Vector3 target;

  Vector3 _eye;

  Vector3 _rotateStart, _rotateEnd;
  Vector2 _zoomStart, _zoomEnd;
  Vector2 _panStart, _panEnd;
  Vector3 lastPosition;

  StreamSubscription<MouseEvent> mouseMoveStream;
  StreamSubscription<MouseEvent> mouseUpStream;
  StreamSubscription<KeyboardEvent> keydownStream;

  EventEmitterEvent changeEvent;

  TrackballControls( this.object, [Element domElement] ) {

    this.domElement = ( ?domElement ) ? domElement : document;

    // API

    enabled = true;

    screen = new Screen( width: 0, height: 0, offsetLeft: 0, offsetTop: 0 );
    radius = ( screen.width + screen.height ) / 4;

    rotateSpeed = 1.0;
    zoomSpeed = 1.2;
    panSpeed = 0.3;

    noRotate = false;
    noZoom = false;
    noPan = false;

    staticMoving = false;
    dynamicDampingFactor = 0.2;

    minDistance = 0;
    maxDistance = double.INFINITY;

    keys = [ 65 /*A*/, 83 /*S*/, 68 /*D*/ ];

    // internals

    target = new Vector3();

    lastPosition = new Vector3();

    _state = STATE.NONE;
    _prevState = STATE.NONE;

    _eye = new Vector3();

    _rotateStart = new Vector3();
    _rotateEnd = new Vector3();

    _zoomStart = new Vector2();
    _zoomEnd = new Vector2();

    _panStart = new Vector2();
    _panEnd = new Vector2();

    changeEvent = new EventEmitterEvent(type: 'change');

    domElement
    ..onContextMenu.listen(( event ) => event.preventDefault())
    ..onMouseDown.listen(mousedown)
    ..onMouseWheel.listen(mousewheel)
    ..onTouchStart.listen(touchstart)
    ..onTouchEnd.listen(touchstart)
    ..onTouchMove.listen(touchmove);

    //this.domElement.addEventListener( 'DOMMouseScroll', mousewheel, false ); // firefox

    keydownStream = window.onKeyDown.listen(keydown);
    window.onKeyUp.listen(keyup);


    handleResize();
  }


    // methods
   handleResize () {
      screen
      ..width = window.innerWidth
      ..height = window.innerHeight
      ..offsetLeft = 0
      ..offsetTop = 0;

      radius = ( screen.width + screen.height ) / 4;
    }

    handleEvent( event ) {
      dispatchEvent(event);
    }

    getMouseOnScreen( clientX, clientY )
      => new Vector2(
          ( clientX - screen.offsetLeft ) / radius * 0.5,
          ( clientY - screen.offsetTop ) / radius * 0.5
      );

    getMouseProjectionOnBall( clientX, clientY ) {

      var mouseOnBall = new Vector3(
          ( clientX - screen.width * 0.5 - screen.offsetLeft ) / radius,
          ( screen.height * 0.5 + screen.offsetTop - clientY ) / radius,
          0.0
      );

      var length = mouseOnBall.length();

      if ( length > 1.0 ) {

        mouseOnBall.normalize();

      } else {

        mouseOnBall.z = Math.sqrt( 1.0 - length * length );

      }

      _eye.copy( object.position ).subSelf( target );

      var projection = object.up.clone().setLength( mouseOnBall.y );
      projection.addSelf( object.up.clone().crossSelf( _eye ).setLength( mouseOnBall.x ) );
      projection.addSelf( _eye.setLength( mouseOnBall.z ) );

      return projection;

    }

    rotateCamera() {

      var angle = Math.acos( _rotateStart.dot( _rotateEnd ) / _rotateStart.length() / _rotateEnd.length() );

      if ( !angle.isNaN && angle != 0) {

        var axis = ( new Vector3() ).cross( _rotateStart, _rotateEnd ).normalize(),
            quaternion = new Quaternion();

        angle *= rotateSpeed;

        quaternion.setFromAxisAngle( axis, -angle );

        quaternion.multiplyVector3( _eye );
        quaternion.multiplyVector3( object.up );

        quaternion.multiplyVector3( _rotateEnd );

        if ( staticMoving ) {

          _rotateStart.copy( _rotateEnd );

        } else {

          quaternion.setFromAxisAngle( axis, angle * ( dynamicDampingFactor - 1.0 ) );
          quaternion.multiplyVector3( _rotateStart );

        }

      }

    }

    zoomCamera() {

      var factor = 1.0 + ( _zoomEnd.y - _zoomStart.y ) * zoomSpeed;

      if ( factor != 1.0 && factor > 0.0 ) {

        _eye.multiplyScalar( factor );

        if ( staticMoving ) {

          _zoomStart.copy( _zoomEnd );

        } else {

          _zoomStart.y += ( _zoomEnd.y - _zoomStart.y ) * this.dynamicDampingFactor;

        }

      }

    }

    panCamera() {

      var mouseChange = _panEnd.clone().subSelf( _panStart );

      if ( mouseChange.lengthSq() != 0) {

        mouseChange.multiplyScalar( _eye.length() * panSpeed );

        var pan = _eye.clone().crossSelf( object.up ).setLength( mouseChange.x );
        pan.addSelf( object.up.clone().setLength( mouseChange.y ) );

        object.position.addSelf( pan );
        target.addSelf( pan );

        if ( staticMoving ) {

          _panStart = _panEnd;

        } else {

          _panStart.addSelf( mouseChange.sub( _panEnd, _panStart ).multiplyScalar( dynamicDampingFactor ) );

        }

      }

    }

    checkDistances() {

      if ( !noZoom || !noPan ) {

        if ( object.position.lengthSq() > maxDistance * maxDistance ) {

          object.position.setLength( maxDistance );

        }

        if ( _eye.lengthSq() < minDistance * minDistance ) {

          object.position.add( target, _eye.setLength( minDistance ) );

        }

      }

    }

    update() {

      _eye.copy( object.position ).subSelf( target );

      if ( !noRotate ) {
        rotateCamera();
      }

      if ( !noZoom ) {
        zoomCamera();
      }

      if ( !noPan ) {
        panCamera();
      }

      object.position.add( target, _eye );

      checkDistances();

      object.lookAt( target );

      if ( lastPosition.distanceToSquared( object.position ) > 0 ) {

        dispatchEvent( changeEvent );

        lastPosition.copy( object.position );

      }

    }

    // listeners

    keydown( KeyboardEvent event ) {

      if ( !enabled ) return;

      keydownStream.cancel();

      _prevState = _state;

      if ( _state != STATE.NONE ) {

        return;

      } else if ( event.keyCode == keys[ STATE.ROTATE ] && !noRotate ) {

        _state = STATE.ROTATE;

      } else if ( event.keyCode == keys[ STATE.ZOOM ] && !noZoom ) {

        _state = STATE.ZOOM;

      } else if ( event.keyCode == keys[ STATE.PAN ] && !noPan ) {

        _state = STATE.PAN;

      }

    }

    keyup( KeyboardEvent event ) {

      if ( !enabled ) { return; }

      _state = _prevState;

      keydownStream = window.onKeyDown.listen( keydown );

    }

    mousedown( MouseEvent event ) {

      if ( !enabled ) { return; }

      event.preventDefault();
      event.stopPropagation();

      if ( _state == STATE.NONE ) {

        _state = event.button;
      }

      if ( _state == STATE.ROTATE && !noRotate ) {

        _rotateStart = getMouseProjectionOnBall( event.client.x, event.client.y );
        _rotateEnd = _rotateStart;

      } else if ( _state == STATE.ZOOM && !noZoom ) {

        _zoomStart = getMouseOnScreen( event.client.x, event.client.y );
        _zoomEnd = _zoomStart;

      } else if ( _state == STATE.PAN && !noPan ) {

        _panStart = getMouseOnScreen( event.client.x, event.client.y );
        _panEnd = _panStart;

      }

      mouseMoveStream = document.onMouseMove.listen( mousemove );
      mouseUpStream = document.onMouseUp.listen( mouseup );

    }

    mousemove( MouseEvent event ) {

      if ( !enabled ) { return; }

      if ( _state == STATE.ROTATE && !noRotate ) {

        _rotateEnd = getMouseProjectionOnBall( event.clientX, event.clientY );

      } else if ( _state == STATE.ZOOM && !noZoom ) {

        _zoomEnd = getMouseOnScreen( event.clientX, event.clientY );

      } else if ( _state == STATE.PAN && !noPan ) {

        _panEnd = getMouseOnScreen( event.clientX, event.clientY );

      }

    }

    mouseup( MouseEvent event ) {

      if ( !enabled ) { return; }

      event.preventDefault();
      event.stopPropagation();

      _state = STATE.NONE;

      mouseMoveStream.cancel();
      mouseUpStream.cancel();

    }

    mousewheel( WheelEvent event ) {

      if ( !enabled ) { return; }

      event.preventDefault();
      event.stopPropagation();

      var delta = 0;

      // TODO(nelsonsilva) - check this!
      if ( event.deltaY != 0 ) { // WebKit / Opera / Explorer 9

        delta = event.deltaY / 40;

      } else if ( event.detail != 0 ) { // Firefox

        delta = - event.detail / 3;

      }

      _zoomStart.y += ( 1 / delta ) * 0.05;

    }

    touchstart( TouchEvent event ) {

      if ( !enabled ) { return; }

      event.preventDefault();

      switch ( event.touches.length ) {

        case 1:
          _rotateStart = _rotateEnd = getMouseProjectionOnBall( event.touches[ 0 ].page.x, event.touches[ 0 ].page.y );
          break;
        case 2:
          _zoomStart = _zoomEnd = getMouseOnScreen( event.touches[ 0 ].page.x, event.touches[ 0 ].page.y );
          break;
        case 3:
          _panStart = _panEnd = getMouseOnScreen( event.touches[ 0 ].page.x, event.touches[ 0 ].page.y );
          break;

      }

    }

    touchmove( TouchEvent event ) {

      if ( !enabled ) { return; }

      event.preventDefault();

      switch ( event.touches.length ) {

        case 1:
          _rotateEnd = getMouseProjectionOnBall( event.touches[ 0 ].page.x, event.touches[ 0 ].page.y );
          break;
        case 2:
          _zoomEnd = getMouseOnScreen( event.touches[ 0 ].page.x, event.touches[ 0 ].page.y );
          break;
        case 3:
          _panEnd = getMouseOnScreen( event.touches[ 0 ].page.x, event.touches[ 0 ].page.y );
          break;

      }

    }
}
