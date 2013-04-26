/**
  * @author mrdoob / http://mrdoob.com/
  * @author alteredq / http://alteredqualia.com/
  * @author paulirish / http://paulirish.com/
  *
  * Ported to Dart from JS by:
  * @author jessevogt / http://jvogt.net/
  *
  * based on rev 04b652ae26e228796f67838c0ec4d555e8b16528
  */
library FirstPersonControls;

import "dart:html";
import "dart:math" as Math;
import "package:three/three.dart" as THREE;
import 'package:three/src/core/ThreeMath.dart' as THREEMath;

class FirstPersonControls {
  THREE.Object3D object;
  THREE.Vector3 target = new THREE.Vector3( 0, 0, 0 );

  Element domElement;

  num movementSpeed = 1.0;
  num lookSpeed = 0.005;

  bool lookVertical = true;
  bool autoForward = false;
  // bool invertVertical = false;

  bool activeLook = true;

  bool heightSpeed = false;
  num heightCoef = 1.0;
  num heightMin = 0.0;
  num heightMax = 1.0;

  bool constrainVertical = false;
  num verticalMin = 0;
  num verticalMax = Math.PI;

  num autoSpeedFactor = 0.0;

  num mouseX = 0;
  num mouseY = 0;

  num lat = 0;
  num lon = 0;
  num phi = 0;
  num theta = 0;

  bool moveForward = false;
  bool moveBackward = false;
  bool moveLeft = false;
  bool moveRight = false;
  bool moveUp = false;
  bool moveDown = false;
  bool freeze = false;

  bool mouseDragOn = false;

  num viewHalfX = 0;
  num viewHalfY = 0;

  FirstPersonControls(this.object, [Element domElement]) {
    this.domElement = (?domElement) ? domElement : document.body;

    if ( this.domElement != document.body ) {
      this.domElement.tabIndex = -1;
    }

    this.domElement.onContextMenu.listen((event) => event.preventDefault());

    this.domElement.onMouseMove.listen(this.onMouseMove);
    this.domElement.onMouseDown.listen(this.onMouseDown);
    this.domElement.onMouseUp.listen(this.onMouseUp);
    this.domElement.onKeyDown.listen(this.onKeyDown);
    this.domElement.onKeyUp.listen(this.onKeyUp);

    this.handleResize();
  }

   void handleResize() {
    if ( this.domElement == document.body ) {
      this.viewHalfX = window.innerWidth / 2;
      this.viewHalfY = window.innerHeight / 2;
    } else {
      this.viewHalfX = this.domElement.offsetWidth / 2;
      this.viewHalfY = this.domElement.offsetHeight / 2;
    }
  }

  void onMouseDown(event) {

    if ( this.domElement != document.body ) {
      this.domElement.focus();
    }

    event.preventDefault();
    event.stopPropagation();

    if ( this.activeLook ) {
      switch ( event.button ) {
        case 0: this.moveForward = true; break;
        case 2: this.moveBackward = true; break;
      }
    }

    this.mouseDragOn = true;
  }

  void onMouseUp(event) {
    event.preventDefault();
    event.stopPropagation();

    if ( this.activeLook ) {
      switch ( event.button ) {
        case 0: this.moveForward = false; break;
        case 2: this.moveBackward = false; break;
      }
    }
    this.mouseDragOn = false;
  }

  void onMouseMove(event) {
    if ( this.domElement == document.body ) {
      this.mouseX = event.pageX - this.viewHalfX;
      this.mouseY = event.pageY - this.viewHalfY;
    } else {
      this.mouseX = event.pageX - this.domElement.offsetLeft - this.viewHalfX;
      this.mouseY = event.pageY - this.domElement.offsetTop - this.viewHalfY;
    }
  }

  void onKeyDown(event) {

    //event.preventDefault();

    switch ( event.keyCode ) {
      case 38: /*up*/
      case 87: /*W*/ this.moveForward = true; break;

      case 37: /*left*/
      case 65: /*A*/ this.moveLeft = true; break;

      case 40: /*down*/
      case 83: /*S*/ this.moveBackward = true; break;

      case 39: /*right*/
      case 68: /*D*/ this.moveRight = true; break;

      case 82: /*R*/ this.moveUp = true; break;
      case 70: /*F*/ this.moveDown = true; break;

      case 81: /*Q*/ this.freeze = !this.freeze; break;
    }
  }

  void onKeyUp(event) {

    switch( event.keyCode ) {

      case 38: /*up*/
      case 87: /*W*/ this.moveForward = false; break;

      case 37: /*left*/
      case 65: /*A*/ this.moveLeft = false; break;

      case 40: /*down*/
      case 83: /*S*/ this.moveBackward = false; break;

      case 39: /*right*/
      case 68: /*D*/ this.moveRight = false; break;

      case 82: /*R*/ this.moveUp = false; break;
      case 70: /*F*/ this.moveDown = false; break;
    }
  }

  void update(delta) {
    var actualMoveSpeed = 0;
    var actualLookSpeed = 0;
    if ( this.freeze ) {

      return;

    } else {

      if ( this.heightSpeed ) {
        var y = THREEMath.clamp( this.object.position.y, this.heightMin, this.heightMax );
        var heightDelta = y - this.heightMin;

        this.autoSpeedFactor = delta * ( heightDelta * this.heightCoef );
      } else {
        this.autoSpeedFactor = 0.0;
      }

      actualMoveSpeed = delta * this.movementSpeed;

      if ( this.moveForward || ( this.autoForward && !this.moveBackward ) ) this.object.translateZ( - ( actualMoveSpeed + this.autoSpeedFactor ) );
      if ( this.moveBackward ) this.object.translateZ( actualMoveSpeed );

      if ( this.moveLeft ) this.object.translateX( - actualMoveSpeed );
      if ( this.moveRight ) this.object.translateX( actualMoveSpeed );

      if ( this.moveUp ) this.object.translateY( actualMoveSpeed );
      if ( this.moveDown ) this.object.translateY( - actualMoveSpeed );

      var actualLookSpeed = delta * this.lookSpeed;

      if ( !this.activeLook ) {

        actualLookSpeed = 0;

      }

      this.lon += this.mouseX * actualLookSpeed;
      if( this.lookVertical ) this.lat -= this.mouseY * actualLookSpeed; // * this.invertVertical?-1:1;

      this.lat = Math.max( - 85, Math.min( 85, this.lat ) );
      this.phi = ( 90 - this.lat ) * Math.PI / 180;
      this.theta = this.lon * Math.PI / 180;

      var targetPosition = this.target,
          position = this.object.position;

      targetPosition.x = position.x + 100 * Math.sin( this.phi ) * Math.cos( this.theta );
      targetPosition.y = position.y + 100 * Math.cos( this.phi );
      targetPosition.z = position.z + 100 * Math.sin( this.phi ) * Math.sin( this.theta );
    }

    var verticalLookRatio = 1;

    if ( this.constrainVertical ) {
      verticalLookRatio = Math.PI / ( this.verticalMax - this.verticalMin );
    }

    this.lon += this.mouseX * actualLookSpeed;
    if( this.lookVertical ) this.lat -= this.mouseY * actualLookSpeed * verticalLookRatio;

    this.lat = Math.max( - 85, Math.min( 85, this.lat ) );
    this.phi = ( 90 - this.lat ) * Math.PI / 180;

    this.theta = this.lon * Math.PI / 180;

    if ( this.constrainVertical ) {
      this.phi = THREEMath.mapLinear( this.phi, 0, Math.PI, this.verticalMin, this.verticalMax );
    }

    var targetPosition = this.target,
        position = this.object.position;

    targetPosition.x = position.x + 100 * Math.sin( this.phi ) * Math.cos( this.theta );
    targetPosition.y = position.y + 100 * Math.cos( this.phi );
    targetPosition.z = position.z + 100 * Math.sin( this.phi ) * Math.sin( this.theta );

    this.object.lookAt( targetPosition );
  }
}
