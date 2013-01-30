three.dart
========

#### Dart 3D Engine ####

This project aims to port the [three.js](https://github.com/mrdoob/three.js) JavaScript 3D engine to [Dart](http://www.dartlang.org/).

Starting at three.js revision 47.0, the aim is to recreate all of the existing three.js [examples](http://mrdoob.github.com/three.js/), until parity is reached with this version. Beyond this point, further revisions to three.js will be closely followed and matched in three.dart.

[Contributors](http://github.com/threedart/three.dart/contributors)

#### WebGL examples ####

[![nyan_cat](http://threedart.github.com/three.dart/example/webgl_nyan_cat/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_nyan_cat/nyan_cat.html)
[![webgl_geometries](http://threedart.github.com/three.dart/example/webgl_geometries/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_geometries/WebGL_Geometries.html)
[![webgl_geometry_cube](http://threedart.github.com/three.dart/example/webgl_geometry_cube/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_geometry_cube/WebGL_Geometry_Cube.html)
[![webgl_geometry_extrude_shapes](http://threedart.github.com/three.dart/example/webgl_geometry_extrude_shapes/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_geometry_extrude_shapes/WebGL_Geometry_Extrude_Shapes.html)
[![webgl_geometry_hierarchy](http://threedart.github.com/three.dart/example/webgl_geometry_hierarchy/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_geometry_hierarchy/WebGL_Geometry_Hierarchy.html)
[![webgl_geometry_shapes](http://threedart.github.com/three.dart/example/webgl_geometry_shapes/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_geometry_shapes/WebGL_Geometry_Shapes.html)
[![webgl_interactive_cubes](http://threedart.github.com/three.dart/example/webgl_interactive_cubes/thumb_small.png)](http://threedart.github.com/three.dart/example/webgl_interactive_cubes/WebGL_Interactive_Cubes.html)

#### Canvas examples ####

[![canvas_geometry_cube](http://threedart.github.com/three.dart/example/canvas_geometry_cube/thumb_small.png)](http://threedart.github.com/three.dart/example/canvas_geometry_cube/Canvas_Geometry_Cube.html)
[![canvas_geometry_hierarchy](http://threedart.github.com/three.dart/example/canvas_geometry_hierarchy/thumb_small.png)](http://threedart.github.com/three.dart/example/canvas_geometry_hierarchy/Canvas_Geometry_Hierarchy.html)
[![canvas_interactive_cubes](http://threedart.github.com/three.dart/example/canvas_interactive_cubes/thumb_small.png)](http://threedart.github.com/three.dart/example/canvas_interactive_cubes/Canvas_Interactive_Cubes.html)
[![canvas_lines](http://threedart.github.com/three.dart/example/canvas_lines/thumb_small.png)](http://threedart.github.com/three.dart/example/canvas_lines/Canvas_Lines.html)
[![canvas_camera_orthographic](http://threedart.github.com/three.dart/example/canvas_camera_orthographic/thumb_small.png)](http://threedart.github.com/three.dart/example/canvas_camera_orthographic/Canvas_Camera_Orthographic.html)
[![controls_firstperson](http://threedart.github.com/three.dart/example/controls_firstperson/thumb_small.png)](http://threedart.github.com/three.dart/example/controls_firstperson/Controls_FirstPerson.html)


### Change Log ###
2013 01 30 - **v 0.2.4**

* Minor refactoring to M3 ([adam](https://github.com/financeCoding))
  * Updated Streams for events
* WebGL added MorphTargets ([nelsonsilva](https://github.com/nelsonsilva))
  * Including examples
  
2012 10 01 - **v 0.2.3** 
* Nyan Cat example added ([adam](https://github.com/financeCoding))

2012 09 23 - **v 0.2.2** 
* Major refactor to pub ([adam](https://github.com/financeCoding))
  * Minor refactors of getters and exceptions
  * Regenerating javascript examples

2012 08 30 - **v 0.2.1**

* Orthographic camera added ([nelsonsilva](https://github.com/nelsonsilva))
  * Canvas_Camera_Orthographic

2012 08 29 - **v 0.2.0**

* WebGL renderer and examples added ([nelsonsilva](https://github.com/nelsonsilva))
  * WebGL_Geometry_Cube
  * WebGL_Geometry_Hierarchy
  * WebGL_Interactive_Cubes

2012 07 14 - **v 0.1.2**

* Adaptation to Dart SDK build 9474 ([jwb](https://github.com/jwb))

2012 03 05 - **v 0.1.1** ([robsilv](https://github.com/robsilv))

* README.md 
	* Contributors link added
	* Canvas Lines example added
* Canvas_Lines.dart
	* div removed (not in three.js example)
	* vars changed to ints
	* PI2 changed to TAU http://en.wikipedia.org/wiki/Tau_(2%CF%80)
	* context.arc() "anticlockwise" changed to "false" for Win7 publishing
	* Body of Touch Events introduced
* Three.dart
	* "final" keyword introduced for constants
	* Constants moved from Line.dart
* Line.dart
	* Authors text introduced
	* Constants moved to Three.dart
* ParticleBasicMaterial.dart/CanvasRenderer.dart CTEs resolved


2012 02 28 - **v 0.1.0** ([robsilv](https://github.com/robsilv))

* Project upgraded to run with DartBuild 4577 (compile-time errors resolved)
* All HTML examples now use Dart -> JS dynamic replacement code
* Canvas_Interactive_Cubes example implemented
* IMaterial and IParticleMaterial interfaces introduced
* Particle and ParticleCanvasMaterial classes implemented
* Debug mode flag introduced for CanvasRenderer


2012 02 23 - **v 0.0.4** ([robsilv](https://github.com/robsilv))

* Canvas_Geometry_Heirarchy example implemented
* Color: r,g,b getters and setters removed for brevity (properties are read/write)
* Vector3: divideScalar()  "if ( s !== null )" error resolved


2012 02 23 - **v 0.0.3** ([robsilv](https://github.com/robsilv))

* Multiple frame rendering bug fixed!
* Canvas_Geometry_Cube example now draggable
* Default values added to Quaternion, Vector2, Vector4
* Change Log updated from "revision" to "version" numbers (where "version 1" will demonstrate all of the functionality of three.js revision 47.0)


2012 02 12 - **v 0.0.2** ([robsilv](https://github.com/robsilv))

* Project restructuring:
  * "ThreeD" renamed to "src"
  * "examples" folder introduced

2012 02 11 - **v 0.0.1** ([robsilv](https://github.com/robsilv))

* Pre-alpha release (I can see a cube!! :D - Tested in Google Chrome Browser on Windows 7)
* This code is not currently ready to be used in a project
* Canvas_Geometry_Cube example partially implemented
* Only code essential to Canvas_Geometry_Cube has been ported (e.g. CanvasRenderer, but not WebGLRenderer)
