/**
 * @author qiao / https://github.com/qiao
 * @author mrdoob / http://mrdoob.com
 * @author alteredq / http://alteredqualia.com/
 * @author WestLangley / http://github.com/WestLangley
 * @author erich666 / http://erichaines.com
 *
 * Ported to Dart from JS by:
 * @author Adam Joseph Cook / https://github.com/adamjcook
 *
 * @overview
 * [OrbitControls] is a set of controls performs orbiting, dollying (zooming) 
 * and panning. It maintains the "up" direction as +Y, unlike [TrackballControls].
 * Touch events on tablet and phone form-factors are also supported.
 * 
 * * Orbit - left mouse / touch: one finger move
 * * Zoom  - middle mouse, or mousewheel / touch: two finger spread or squish
 * * Pan   - right mouse, or arrow keys / touch: three finger swipe
 * 
 * [OrbitControls] is a drop-in replacement for most of the examples which use
 * [TrackballControls].
 * 
 * Only [PerspectiveCamera] and [OrthographicCamera] are supported with this 
 * control.
 **/
library OrbitControls;

import "dart:html";
import "dart:async";
import "dart:math" as Math;
import 'package:vector_math/vector_math.dart';
import "package:three/three.dart";

class STATE {
  static const NONE = -1;
  static const ROTATE = 0;
  static const DOLLY = 1;
  static const PAN = 2;
  static const TOUCH_ROTATE = 3;
  static const TOUCH_DOLLY = 4;
  static const TOUCH_PAN = 5;
}

// Key mappings for directional controls.
class KEYS {
  static const LEFT = 37;
  static const UP = 38;
  static const RIGHT = 39;
  static const BOTTOM = 40;
}

class OrbitControls extends EventEmitter {

  int _state;
  Object3D object;
  dynamic domElement;
  bool enabled;
  Math.Rectangle screen;
  num rotateSpeed, zoomSpeed, keyPanSpeed;
  bool noZoom, noRotate, noPan;
  bool autoRotate;
  num autoRotateSpeed;
  num minPolarAngle, maxPolarAngle;
  bool noKeys;
  bool staticMoving;
  num dynamicDampingFactor;
  num minDistance, maxDistance;

  double EPS;

  Vector3 target;

  Vector3 lastPosition;
  Quaternion lastQuaternion;

  Vector2 _rotateStart, _rotateEnd, _rotateDelta;
  Vector2 _panStart, _panEnd, _panDelta;
  Vector3 _panOffset;

  Vector3 _offset;

  Vector2 _dollyStart, _dollyEnd, _dollyDelta;

  num _phiDelta, _thetaDelta, _scale;
  Vector3 _pan;

  Vector3 target0, position0;

  Quaternion quaternion, quaternionInverse;

  StreamSubscription<MouseEvent> mouseMoveStream;
  StreamSubscription<MouseEvent> mouseUpStream;
  StreamSubscription<KeyboardEvent> keydownStream;

  EventEmitterEvent changeEvent;
  EventEmitterEvent startEvent;
  EventEmitterEvent endEvent;


  OrbitControls(this.object, [Element domElement]) {

    this.domElement = (domElement != null) ? domElement : document;

    // API

    // Set to false to disable this control
    enabled = true;

    EPS = 0.000001;

    // Location of focus. This is where the control orbits around and where it
    // pans with respect to.
    target = new Vector3.zero();

    // Enables/disables dollying in and out.
    noZoom = false;
    zoomSpeed = 1.0;

    // Limits the dollying in and out range.
    minDistance = 0;
    maxDistance = double.INFINITY;

    // Enables/disables rotation.
    noRotate = false;
    rotateSpeed = 1.0;

    // Enables/disabled panning.
    noPan = false;
    keyPanSpeed = 7.0;

    // Enables/disables automatic rotation around the target.
    autoRotate = false;
    autoRotateSpeed = 2.0;

    // Determines the vertical orbit limit - upper and lower limits.
    // The default range is 0.0 to Math.PI radians.
    minPolarAngle = 0; // in radians
    maxPolarAngle = Math.PI; // in radians

    // Enables/disables the ability to use the keyboard to interact with this
    // control.
    noKeys = false;


    // Internals

    target = new Vector3.zero();

    lastPosition = new Vector3.zero();
    lastQuaternion = new Quaternion.identity();

    _state = STATE.NONE;

    _rotateStart = new Vector2.zero();
    _rotateEnd = new Vector2.zero();
    _rotateDelta = new Vector2.zero();

    _panStart = new Vector2.zero();
    _panEnd = new Vector2.zero();
    _panDelta = new Vector2.zero();
    _panOffset = new Vector3.zero();

    _offset = new Vector3.zero();

    _dollyStart = new Vector2.zero();
    _dollyEnd = new Vector2.zero();
    _dollyDelta = new Vector2.zero();

    _phiDelta = 0;
    _thetaDelta = 0;
    _scale = 1;
    _pan = new Vector3.zero();

    // For reset

    target0 = target.clone();
    position0 = this.object.position.clone();

    // Establish that camera.up is the orbit axis.
    quaternion = setFromUnitVectors(object.up, new Vector3(0.0, 1.0, 0.0));
    quaternionInverse = quaternion.clone().inverse();

    changeEvent = new EventEmitterEvent(type: 'change');
    startEvent = new EventEmitterEvent(type: 'start');
    endEvent = new EventEmitterEvent(type: 'end');

    this.domElement
        ..onContextMenu.listen((event) => event.preventDefault())
        ..onMouseDown.listen(mousedown)
        ..onMouseWheel.listen(mousewheel)
        ..onTouchStart.listen(touchstart)
        ..onTouchEnd.listen(touchend)
        ..onTouchMove.listen(touchmove);

    keydownStream = window.onKeyDown.listen(keydown);

    update();
  }

  rotateLeft(angle) {

    if (angle == null) {

      angle = getAutoRotationAngle();

    }

    _thetaDelta -= angle;

  }

  rotateUp(angle) {

    if (angle == null) {

      angle = getAutoRotationAngle();

    }

    _phiDelta -= angle;

  }

  panLeft(double distance) {

    var te = object.matrix;

    // Get the X column of the object transform matrix.
    _panOffset = new Vector3(te[0], te[1], te[2]);
    _panOffset = _panOffset * -distance;

    _pan.add(_panOffset);

  }

  panUp(double distance) {

    var te = object.matrix;

    // Get the Y column of the object transform matrix.
    _panOffset = new Vector3(te[4], te[5], te[6]);
    _panOffset = _panOffset * distance;

    _pan.add(_panOffset);
  }


  pan(double deltaX, double deltaY) {

    var element = (domElement == document) ? document.body : domElement;

    if (object is PerspectiveCamera) {

      // For [PerspectiveCamera]
      var position = object.position;
      var offset = position.clone().sub(target);
      var targetDistance = offset.length;

      // Half of the FOV is the distance from the center to the top of the screen.
      targetDistance *= Math.tan(((object as PerspectiveCamera).fov / 2) * Math.PI / 180.0);

      // screenWidth is not used since [PerspectiveCamera] is fixed to screen height.
      panLeft(2.0 * deltaX * targetDistance / element.clientHeight);
      panUp(2.0 * deltaY * targetDistance / element.clientHeight);

    } else if (object is OrthographicCamera) {

      // For [OrthographicCamera]
      panLeft(
          deltaX * ((object as OrthographicCamera).right - (object as OrthographicCamera).left) / element.clientWidth);
      panUp(
          deltaY * ((object as OrthographicCamera).top - (object as OrthographicCamera).bottom) / element.clientHeight);

    } else {

      // Object is neither [PerspectiveCamera] or [OrthographicCamera]
      throw new ArgumentError('camera must be PerspectiveCamera or OrthographicCamera');
    }
  }

  dollyIn({dollyScale}) {

    if (dollyScale == null) {

      dollyScale = getZoomScale();

    }

    _scale /= dollyScale;

  }

  dollyOut({dollyScale}) {

    if (dollyScale == null) {

      dollyScale = getZoomScale();

    }

    _scale *= dollyScale;

  }

  update() {

    var position = object.position;

    _offset.setFrom(position).sub(target);

    // Rotate offset to 'Y-axis is up' space.
    quaternion.rotate(_offset);

    // Angle from Z-axis around Y-axis
    var theta = Math.atan2(_offset.x, _offset.z);

    // Angle from Y-axis
    var phi = Math.atan2(Math.sqrt(_offset.x * _offset.x + _offset.z * _offset.z), _offset.y);

    if (autoRotate) {

      rotateLeft(getAutoRotationAngle());

    }

    theta += _thetaDelta;

    phi += _phiDelta;

    // Restrict phi to be between the desired limits
    phi = Math.max(minPolarAngle, Math.min(maxPolarAngle, phi));

    // Restrict phi to be between EPS and PI-EPS
    phi = Math.max(EPS, Math.min(Math.PI - EPS, phi));

    var radius = _offset.length * _scale;

    // Restrict radius to be between desired limits
    radius = Math.max(minDistance, Math.min(maxDistance, radius));

    // Move target to panned location
    target.add(_pan);

    _offset.x = radius * Math.sin(phi) * Math.sin(theta);
    _offset.y = radius * Math.cos(phi);
    _offset.z = radius * Math.sin(phi) * Math.cos(theta);

    // Rotate offset back to 'camera-up-vector-is-up' space
    quaternionInverse.rotate(_offset);

    position.setFrom(target).add(_offset);

    object.lookAt(target);

    _thetaDelta = 0;
    _phiDelta = 0;
    _scale = 1;
    _pan = new Vector3.zero();

    // Update condition is the following:
    // * min( camera displacement, camera rotation in radians )^2 > EPS
    // * using small-angle approximation cos(x/2) = 1 - x^2 / 8
    if (lastPosition.distanceToSquared(object.position) > EPS ||
        8 * (1 - dotProductQuaternion(lastQuaternion, object.quaternion)) > EPS) {

      dispatchEvent(changeEvent);

      lastPosition.setFrom(object.position);
      lastQuaternion = object.quaternion;

    }

  }

  reset() {

    _state = STATE.NONE;

    target = target0;
    object.position = position0;

    update();

  }

  getAutoRotationAngle() {

    return 2 * Math.PI / 60 / 60 * autoRotateSpeed;

  }

  getZoomScale() {

    return Math.pow(0.95, zoomSpeed);

  }

  mousedown(event) {

    if (enabled == false) return;

    event.preventDefault();

    if (event.button == 0) {

      if (noRotate == true) return;

      _state = STATE.ROTATE;

      _rotateStart = new Vector2(event.client.x.toDouble(), event.client.y.toDouble());

    } else if (event.button == 1) {

      if (noZoom == true) return;

      _state = STATE.DOLLY;

      _dollyStart = new Vector2(event.client.x.toDouble(), event.client.y.toDouble());

    } else if (event.button == 2) {

      if (noPan == true) return;

      _state = STATE.PAN;

      _panStart = new Vector2(event.client.x.toDouble(), event.client.y.toDouble());

    }

    mouseMoveStream = document.onMouseMove.listen(mousemove);
    mouseUpStream = document.onMouseUp.listen(mouseup);
    dispatchEvent(startEvent);

  }

  mousemove(event) {

    if (enabled == false) return;

    event.preventDefault();

    var element = (domElement == document) ? document.body : domElement;

    if (_state == STATE.ROTATE) {

      if (noRotate == true) return;

      _rotateEnd = new Vector2(event.client.x.toDouble(), event.client.y.toDouble());
      _rotateDelta = _rotateEnd - _rotateStart;

      // Rotating across the whole screen is 360 degrees around.
      rotateLeft(2 * Math.PI * _rotateDelta.x / element.clientWidth * rotateSpeed);

      // Rotating up and down along the whole screen attempts to go to 360,
      // but it is limited to 180 degrees.
      rotateUp(2 * Math.PI * _rotateDelta.y / element.clientHeight * rotateSpeed);

      _rotateStart.setFrom(_rotateEnd);

    } else if (_state == STATE.DOLLY) {

      if (noZoom == true) return;

      _dollyEnd = new Vector2(event.client.x.toDouble(), event.client.y.toDouble());
      _dollyDelta = _dollyEnd - _dollyStart;

      if (_dollyDelta.y > 0) {

        dollyIn();

      } else {

        dollyOut();

      }

      _dollyStart.setFrom(_dollyEnd);

    } else if (_state == STATE.PAN) {

      if (noPan == true) return;

      _panEnd = new Vector2(event.client.x.toDouble(), event.client.y.toDouble());
      _panDelta = _panEnd - _panStart;

      pan(_panDelta.x.toDouble(), _panDelta.y.toDouble());

      _panStart.setFrom(_panEnd);

    }

    update();

  }

  mouseup(event) {

    if (enabled == false) return;

    mouseMoveStream.cancel();
    mouseUpStream.cancel();

    dispatchEvent(endEvent);

    _state = STATE.NONE;

  }

  mousewheel(event) {

    if (enabled == false || noZoom == true) return;

    event.preventDefault();
    event.stopPropagation();

    var delta = 0;

    if (event.wheelDeltaY != 0) {

      // WebKit / Opera / Internet Explorer 9
      delta = event.wheelDeltaY;

    } else if (event.detail != 0) {

      // Firefox
      delta = -event.detail;

    }

    if (delta > 0) {

      dollyOut();

    } else {

      dollyIn();

    }

    update();
    dispatchEvent(startEvent);
    dispatchEvent(endEvent);

  }

  keydown(event) {

    if (enabled == false || noKeys == true || noPan == true) return;

    switch (event.keyCode) {

      case KEYS.UP:
        pan(0.0, keyPanSpeed);
        update();
        break;

      case KEYS.BOTTOM:
        pan(0.0, -keyPanSpeed);
        update();
        break;

      case KEYS.LEFT:
        pan(keyPanSpeed, 0.0);
        update();
        break;

      case KEYS.RIGHT:
        pan(-keyPanSpeed, 0.0);
        update();
        break;
    }

  }

  touchstart(event) {

    if (enabled == false) return;

    switch (event.touches.length) {

      case 1:
        // Single finger touch - rotate
        if (noRotate == true) return;

        _state = STATE.TOUCH_ROTATE;

        _rotateStart = new Vector2(event.touches[0].pageX.toDouble(), event.touches[0].pageY.toDouble());
        break;

      case 2:
        // Two-finger touch - dolly
        if (noZoom == true) return;

        _state = STATE.TOUCH_DOLLY;

        var dx = event.touches[0].pageX.toDouble() - event.touches[1].pageX.toDouble();

        var dy = event.touches[0].pageY.toDouble() - event.touches[1].pageY.toDouble();

        var distance = Math.sqrt(dx * dx + dy * dy);

        _dollyStart = new Vector2(0.0, distance);
        break;

      case 3:
        // Three-finger touch - pan
        if (noPan == true) return;

        _state = STATE.TOUCH_PAN;

        _panStart = new Vector2(event.touches[0].pageX, event.touches[0].pageY);
        break;

      default:
        _state = STATE.NONE;
    }

    dispatchEvent(startEvent);

  }

  touchmove(event) {

    if (enabled == true) return;

    event.preventDefault();
    event.stopPropagation();

    var element = (domElement == document) ? document.body : domElement;

    switch (event.touches.length) {

      case 1:
        // Single finger touch - rotate
        if (noRotate == true) return;
        if (_state != STATE.TOUCH_ROTATE) return;

        _rotateEnd = new Vector2(event.touches[0].pageX.toDouble(), event.touches[0].pageY.toDouble());

        _rotateDelta = _rotateEnd - _rotateStart;

        // Rotating across the whole screen is 360 degrees around.
        rotateLeft(2 * Math.PI * _rotateDelta.x / element.clientWidth * rotateSpeed);

        // Rotating up and down along the whole screen attempts to go to 360,
        // but it is limited to 180 degrees.
        rotateUp(2 * Math.PI * _rotateDelta.y / element.clientHeight * rotateSpeed);

        _rotateStart = _rotateEnd;

        update();
        break;

      case 2:
        // Two-finger touch - dolly
        if (noZoom == true) return;
        if (_state != STATE.TOUCH_DOLLY) return;

        var dx = event.touches[0].pageX.toDouble() - event.touches[1].pageX.toDouble();

        var dy = event.touches[0].pageY.toDouble() - event.touches[1].pageY.toDouble();

        var distance = Math.sqrt(dx * dx + dy * dy);

        _dollyEnd = new Vector2(0.0, distance);
        _dollyDelta = _dollyEnd - _dollyStart;

        if (_dollyDelta.y > 0) {

          dollyOut();

        } else {

          dollyIn();

        }

        _dollyStart = _dollyEnd;

        update();
        break;

      case 3:
        // Three-finger touch - pan
        if (noPan == true) return;
        if (_state = STATE.TOUCH_PAN) return;

        _panEnd = new Vector2(event.touches[0].pageX.toDouble(), event.touches[0].pageY.toDouble());

        _panDelta = _panEnd - _panStart;

        pan(_panDelta.x, _panDelta.y);

        _panStart = _panEnd;

        update();
        break;

      default:
        _state = STATE.NONE;
    }

  }

  touchend(event) {

    if (enabled == false) return;

    dispatchEvent(endEvent);

    _state = STATE.NONE;

  }

  // TODO(adamjcook): Move into vector_math library? Perhaps a method of quaternion.dart?
  Quaternion setFromUnitVectors(Vector3 from, Vector3 to) {

    // Reference: http://lolengine.net/blog/2014/02/24/quaternion-from-two-vectors-final
    // Assumes that direction vectors `from` and `to` are normalized.

    var r;
    var EPS = 0.000001;
    Vector3 v1 = new Vector3.zero();

    r = from.dot(to) + 1;

    if (r < EPS) {

      r = 0;

      if ((from.x).abs() > (from.z).abs()) {

        v1 = new Vector3(-from.y, from.x, 0.0);

      } else {

        v1 = new Vector3(0.0, -from.z, from.y);
      }

    } else {

      v1 = from.cross(to);
    }

    return new Quaternion(v1.x, v1.y, v1.z, r).normalize();

  }

  // TODO(adamjcook): Move into vector_math library? Perhaps a method of quaternion.dart?
  double dotProductQuaternion(Quaternion q1, Quaternion q2) {

    return q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w;

  }

}
