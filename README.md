three.dart
========

#### Dart 3D Engine ####

This project aims to port the [three.js](https://github.com/mrdoob/three.js) JavaScript 3D engine to [Dart](http://www.dartlang.org/).

Starting at three.js revision 47.0, the aim is to recreate all of the existing three.js [examples](http://mrdoob.github.com/three.js/), until parity is reached with this version. Beyond this point, further revisions to three.js will be closely followed and matched in three.dart.

[Contributors](http://github.com/robsilv/three.dart/contributors)

#### Canvas (Context 2D) ####


<a href="http://robsilv.github.com/three.dart/examples/canvas_geometry_cube/Canvas_Geometry_Cube.html"><img src="http://robsilv.github.com/three.dart/examples/canvas_geometry_cube/thumb_small.png" width="104" height="78" alt="canvas_geometry_cube"></a>
<a href="http://robsilv.github.com/three.dart/examples/canvas_geometry_heirarchy/Canvas_Geometry_Heirarchy.html"><img src="http://robsilv.github.com/three.dart/examples/canvas_geometry_heirarchy/thumb_small.png" width="104" height="78" alt="canvas_geometry_heirarchy"></a>
<a href="http://robsilv.github.com/three.dart/examples/canvas_interactive_cubes/Canvas_Interactive_Cubes.html"><img src="http://robsilv.github.com/three.dart/examples/canvas_interactive_cubes/thumb_small.png" width="104" height="78" alt="canvas_interactive_cubes"></a>
<a href="http://robsilv.github.com/three.dart/examples/canvas_lines/Canvas_Lines.html"><img src="http://robsilv.github.com/three.dart/examples/canvas_lines/thumb_small.png"></a>

### Change Log ###

2012 03 05 - **v 0.1.1**

* README.md 
	* Contributors link added
	* Canvas Lines example added
* Canvas_Lines.dart
	* div removed (not in three.js example)
	* vars changed to ints
	* PI2 changed to TAU (http://en.wikipedia.org/wiki/Tau_(2%CF%80))
	* context.arc() "anticlockwise" changed to "false" for Win7 publishing
	* Body of Touch Events introduced
* Three.dart
	* "final" keyword introduced for constants
	* Constants moved from Line.dart
* Line.dart
	* Authors text introduced
	* Constants moved to Three.dart
* ParticleBasicMaterial.dart/CanvasRenderer.dart CTEs resolved


2012 02 28 - **v 0.1.0**

* Project upgraded to run with DartBuild 4577 (compile-time errors resolved)
* All HTML examples now use Dart -> JS dynamic replacement code
* Canvas_Interactive_Cubes example implemented
* IMaterial and IParticleMaterial interfaces introduced
* Particle and ParticleCanvasMaterial classes implemented
* Debug mode flag introduced for CanvasRenderer


2012 02 23 - **v 0.0.4**

* Canvas_Geometry_Heirarchy example implemented
* Color: r,g,b getters and setters removed for brevity (properties are read/write)
* Vector3: divideScalar()  "if ( s !== null )" error resolved


2012 02 23 - **v 0.0.3**

* Multiple frame rendering bug fixed!
* Canvas_Geometry_Cube example now draggable
* Default values added to Quaternion, Vector2, Vector4
* Change Log updated from "revision" to "version" numbers (where "version 1" will demonstrate all of the functionality of three.js revision 47.0)


2012 02 12 - **v 0.0.2**

* Project restructuring:
  * "ThreeD" renamed to "src"
  * "examples" folder introduced

2012 02 11 - **v 0.0.1**

* Pre-alpha release (I can see a cube!! :D - Tested in Google Chrome Browser on Windows 7)
* This code is not currently ready to be used in a project
* Canvas_Geometry_Cube example partially implemented
* Only code essential to Canvas_Geometry_Cube has been ported (e.g. CanvasRenderer, but not WebGLRenderer)