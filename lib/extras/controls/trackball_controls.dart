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
import 'package:vector_math/vector_math.dart';
import "package:three/three.dart";

class STATE {
 static const NONE = -1;
 static const ROTATE =  0;
 static const ZOOM = 1;
 static const PAN = 2;
}

class TrackballControls extends EventEmitter {

  int _state, _prevState;
  Object3D object;
  Element domElement;
  bool enabled;
  Math.Rectangle screen;
  num rotateSpeed,
      zoomSpeed,
      panSpeed;
  bool noRotate,
       noZoom,
       noPan,
       noRoll;
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

    this.domElement = ( domElement != null) ? domElement : document;

    // API

    enabled = true;

    screen = new Math.Rectangle( 0, 0, 0, 0 );

    rotateSpeed = 1.0;
    zoomSpeed = 1.2;
    panSpeed = 0.3;

    noRotate = false;
    noZoom = false;
    noPan = false;
    noRoll = false;

    staticMoving = false;
    dynamicDampingFactor = 0.2;

    minDistance = 0;
    maxDistance = double.INFINITY;

    keys = [ 65 /*A*/, 83 /*S*/, 68 /*D*/ ];

    // internals

    target = new Vector3.zero();

    lastPosition = new Vector3.zero();

    _state = STATE.NONE;
    _prevState = STATE.NONE;

    _eye = new Vector3.zero();

    _rotateStart = new Vector3.zero();
    _rotateEnd = new Vector3.zero();

    _zoomStart = new Vector2.zero();
    _zoomEnd = new Vector2.zero();

    _panStart = new Vector2.zero();
    _panEnd = new Vector2.zero();

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
      if ( domElement == document ) {
        screen = new Math.Rectangle(0, 0, window.innerWidth, window.innerHeight);
      } else {
        screen = domElement.getBoundingClientRect();
      }
    }


    handleEvent( event ) {
      dispatchEvent(event);
    }

    getMouseOnScreen( clientX, clientY )
      => new Vector2(
          ( clientX - screen.left ) / screen.width,
          ( clientY - screen.top ) / screen.height
      );

    getMouseProjectionOnBall( clientX, clientY ) {

      var mouseOnBall = new Vector3(
          ( clientX - screen.width * 0.5 - screen.left ) / ( screen.width * 0.5 ),
          ( screen.height * 0.5 + screen.top - clientY ) / ( screen.height * 0.5 ),
          0.0
      );

      var length = mouseOnBall.length;

      if ( noRoll ) {

        if ( length < Math.SQRT1_2 ) {

          mouseOnBall.z = Math.sqrt( 1.0 - length * length );

        } else {

          mouseOnBall.z = 0.5 / length;

        }

      } else if ( length > 1.0 ) {

        mouseOnBall.normalize();

      } else {

        mouseOnBall.z = Math.sqrt( 1.0 - length * length );

      }

      _eye.setFrom(object.position ).sub( target );

      Vector3 projection = object.up.clone().normalize().scale( mouseOnBall.y );
      projection.add( object.up.cross( _eye ).normalize().scale( mouseOnBall.x ) );
      projection.add( _eye.normalize().scale( mouseOnBall.z ) );

      return projection;

    }

    rotateCamera() {

      var angle = Math.acos( _rotateStart.dot( _rotateEnd ) / _rotateStart.length / _rotateEnd.length );

      if ( !angle.isNaN && angle != 0) {

        Vector3 axis = _rotateStart.cross(_rotateEnd ).normalize();
        Quaternion quaternion = new Quaternion.identity();

        angle *= rotateSpeed;

        quaternion.setAxisAngle( axis, angle );

        quaternion.rotate( _eye );
        quaternion.rotate( object.up );

        quaternion.rotate( _rotateEnd );

        if ( staticMoving ) {

          _rotateStart.setFrom( _rotateEnd );

        } else {

          quaternion.setAxisAngle( axis, -angle * ( dynamicDampingFactor - 1.0 ) );
          quaternion.rotate( _rotateStart );

        }

      }

    }

    zoomCamera() {

      var factor = 1.0 + ( _zoomEnd.y - _zoomStart.y ) * zoomSpeed;

      if ( factor != 1.0 && factor > 0.0 ) {

        _eye.scale( factor );

        if ( staticMoving ) {

          _zoomStart.setFrom(_zoomEnd);

        } else {

          _zoomStart.y += ( _zoomEnd.y - _zoomStart.y ) * this.dynamicDampingFactor;

        }

      }

    }

    panCamera() {

      Vector2 mouseChange = _panEnd - _panStart;

      if ( mouseChange.length != 0.0) {

        mouseChange.scale( _eye.length * panSpeed );

        Vector3 pan = _eye.cross( object.up ).normalize().scale( mouseChange.x );
        pan += object.up.clone().normalize().scale( mouseChange.y );

        object.position.add( pan );
        target.add( pan );

        if ( staticMoving ) {

          _panStart = _panEnd;

        } else {

          _panStart += (_panEnd - _panStart).scale(dynamicDampingFactor);

        }

      }

    }

    checkDistances() {

      if ( !noZoom || !noPan ) {

        if ( object.position.length2 > maxDistance * maxDistance ) {

          object.position.normalize().scale( maxDistance );

        }

        if ( _eye.length2 < minDistance * minDistance ) {

          object.position = target + _eye.normalize().scale(minDistance);

        }

      }

    }

    update() {

      _eye.setFrom( object.position ).sub( target );

      if ( !noRotate ) {
        rotateCamera();
      }

      if ( !noZoom ) {
        zoomCamera();
      }

      if ( !noPan ) {
        panCamera();
      }

      object.position =  target + _eye;

      checkDistances();

      object.lookAt( target );

      // distanceToSquared
      if ( (lastPosition - object.position).length2 > 0.0 ) {
        //
        dispatchEvent( changeEvent );

        lastPosition.setFrom( object.position );

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

        _rotateEnd = getMouseProjectionOnBall( event.client.x, event.client.y );

      } else if ( _state == STATE.ZOOM && !noZoom ) {

        _zoomEnd = getMouseOnScreen( event.client.x, event.client.y );

      } else if ( _state == STATE.PAN && !noPan ) {

        _panEnd = getMouseOnScreen( event.client.x, event.client.y );

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
