ThreeD
========

#### Dart 3D Engine ####

This project aims to port the [Three.js](https://github.com/mrdoob/three.js) JavaScript 3D engine to [Dart](http://www.dartlang.org/). The Dart language provides Classes, strict typing, compile-time checking and an Eclipse based editor with autocomplete, as well as the facility to publish to JavaScript. These features will (for some) make the language an appealing alternative to JavaScript, especially when building larger projects. ThreeD intends to make full use of strict typing, applying it wherever possible, with the intent of improving code legibility (in a way which is currently beyond the capabilities of JavaScript).

Starting at three.js revision 47.0, the aim is to recreate all of the existing three.js [examples](https://github.com/mrdoob/three.js/tree/master/examples), until parity is reached with this version. Beyond this point, further revisions to three.js will be closely followed and matched in ThreeD.

### Change Log ###

2012 02 11 - **r1**

* Pre-alpha release (I can see a cube!! :D)
* This code is not currently ready to be used in a project, it has been released to gauge interest in it's further development.
* Canvas_Geometry_Cube example partially implemented
* Only code essential to Canvas_Geometry_Cube has been ported (e.g. CanvasRenderer, but not WebGLRenderer)