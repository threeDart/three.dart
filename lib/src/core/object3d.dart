part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

abstract class GeometryObject {

}
//get _hasGeometry => (object i;

/// Base class for scene graph objects.
class Object3D {
  /// unique number for this object instance.
  int id;
  /// Optional name of the object (doesn't need to be unique).
  String name;
  Map properties;

  ///  Object's parent in the scene graph.
  Object3D parent;
  /// Object's children.
  List children;

  /// Up direction.
  Vector3 up;
  /// Object's local position.
  Vector3 position;
  /// Object's local rotation (Euler angles), in radians.
  Vector3 rotation;
  /// Object's local scale.
  Vector3 scale;

  /// Order of axis for Euler angles.
  String eulerOrder;

  bool _dynamic, doubleSided, flipSided, rotationAutoUpdate;

  int renderDepth;

  /// Local transform.
  Matrix4 matrix;
  /// The global transform of the object. If the Object3d has no parent, then it's identical to the local transform.
  Matrix4 matrixWorld;
  Matrix4 matrixRotationWorld;

  /// When this is set, it calculates the matrix of position, (rotation or quaternion)
  /// and scale every frame and also recalculates the matrixWorld property.
  bool matrixAutoUpdate = false;
  /// When this is set, it calculates the matrixWorld in that frame and resets this property to false.
  bool matrixWorldNeedsUpdate = false;

  /// Object's local rotation as Quaternion.
  /// Only used when useQuaternion is set to true.
  Quaternion quaternion;
  /// Use quaternion instead of Euler angles for specifying local rotation.
  bool useQuaternion;

  num boundRadius, boundRadiusScale;

  /// Object gets rendered if true.
  bool visible = false;
  /// Gets rendered into shadow map.
  bool castShadow = false;
  /// Material gets baked in shadow receiving.
  bool receiveShadow = false;
  /// When this is set, it checks every frame if the object is in the frustum of the camera.
  /// Otherwise the object gets drawn every frame even if it isn't visible.
  bool frustumCulled = false;

  Vector3 _vector;

  Material customDepthMaterial;

  // TODO : Introduce a mixin for objects with Geometry
  Geometry geometry;

  // TODO : Introduce a mixin for objects with Material
  Material material;

  // WebGL
  bool __webglInit = false;
  bool __webglActive = false;
  var immediateRenderCallback;

  Matrix4 _modelViewMatrix;
  Matrix3 _normalMatrix;

  int count;
  bool hasPositions, hasNormals, hasUvs, hasColors;
  var positionArray, normalArray, uvArray, colorArray;
  gl.Buffer __webglVertexBuffer, __webglNormalBuffer, __webglUVBuffer, __webglColorBuffer;

  var __webglMorphTargetInfluences;

  Object3D()
      : id = Object3DCount++,

        name = '',
        properties = {},

        parent = null,
        children = [],

        up = new Vector3(0.0, 1.0, 0.0),

        position = new Vector3(0.0, 0.0, 0.0),
        rotation = new Vector3(0.0, 0.0, 0.0),
        eulerOrder = 'XYZ',
        scale = new Vector3(1.0, 1.0, 1.0),

        renderDepth = null,

        rotationAutoUpdate = true,

        matrix = new Matrix4.identity(),
        matrixWorld = new Matrix4.identity(),
        matrixRotationWorld = new Matrix4.identity(),

        matrixAutoUpdate = true,
        matrixWorldNeedsUpdate = true,

        quaternion = new Quaternion.identity(),
        useQuaternion = false,

        boundRadius = 0.0,
        boundRadiusScale = 1.0,

        visible = true,

        castShadow = false,
        receiveShadow = false,

        frustumCulled = true,

        _vector = new Vector3.zero();

  // TODO - These are not in three.js
  //_dynamic = false, // when true it retains arrays so they can be updated with __dirty*

  //doubleSided = false,
  //flipSided = false,

  // dynamic
  bool get isDynamic => _dynamic;
  set isDynamic(bool flag) => _dynamic = flag;

  /// This updates the position, rotation and scale with the matrix.
  void applyMatrix(Matrix4 matrix) {
    this.matrix = matrix * this.matrix;

    this.scale = getScaleFromMatrix(this.matrix);

    Matrix4 mat = extractRotation(new Matrix4.identity(), this.matrix);
    this.rotation = calcEulerFromRotationMatrix(mat, this.eulerOrder);

    this.position = this.matrix.getTranslation();
  }

  void translate(double distance, Vector3 axis) {
    matrix.rotate3(axis);
    axis.normalize();
    position.add(axis.scale(distance));
  }

  /// Translates object along x axis by distance.
  void translateX(double distance) => translate(distance, _vector.setValues(1.0, 0.0, 0.0));

  /// Translates object along y axis by distance.
  void translateY(double distance) => translate(distance, _vector.setValues(0.0, 1.0, 0.0));

  /// Translates object along z axis by distance.
  void translateZ(double distance) => translate(distance, _vector.setValues(0.0, 0.0, 1.0));

  /// Rotates object to face point in space.
  void lookAt(Vector3 vector) {
    // TODO: Add hierarchy support.

    makeLookAt(matrix, vector, position, up);

    if (rotationAutoUpdate) {
      if (useQuaternion) {
        quaternion = new Quaternion.fromRotation(matrix.getRotation());
      } else {
        rotation = calcEulerFromRotationMatrix(matrix, eulerOrder);
      }
    }
  }

  /// Adds object as child of this object.
  void add(Object3D object) {
    if (object == this) {
      print("THREE.Object3D.add: An object can't be added as a child of itself.");
      return;
    }


    if (object.parent != null) {
      object.parent.remove(object);
    }

    object.parent = this;
    children.add(object);

    // add to scene
    Object3D scene = this;

    while (scene.parent != null) {
      scene = scene.parent;
    }

    if (scene is Scene) {
      (scene as Scene).addObject(object);
    }

  }

  ///  Removes object as child of this object.
  void remove(Object3D object) {

    int index = children.indexOf(object);

    if (index != -1) {

      object.parent = null;
      children.removeAt(index);

      // remove from scene
      Object3D obj = this;

      while (obj.parent != null) {
        obj = obj.parent;
      }

      if (obj is Scene) {
        (obj as Scene).removeObject(object);
      }
    }
  }

  /// Searches through the object's children and returns the first with a matching name, optionally recursive.
  Object3D getChildByName(String name, bool doRecurse) {
    int c;
    int cl = children.length;
    Object3D child, recurseResult;

    children.forEach((child) {

      if (child.name == name) {
        return child;
      }

      if (doRecurse) {
        recurseResult = child.getChildByName(name, doRecurse);

        if (recurseResult != null) {
          return recurseResult;
        }
      }
    });

    return null;
  }

  traverse(Function callback(Object3D object)) {
    callback(this);
    children.forEach((child) => child.traverse(callback));
  }

  traverseVisible(Function callback(Object3D object)) {
    if (visible) {
      callback(this);
      children.forEach((child) => child.traverseVisible(callback));
    }
  }

  traverseAncestors(Function callback(Object3D object)) {
    if (parent != null) {
      callback(parent);
      parent.traverseAncestors(callback);
    }
  }

  /// Updates local transform.
  void updateMatrix() {

    if (useQuaternion) {
      setRotationFromQuaternion(matrix, quaternion);
    } else {
      setRotationFromEuler(matrix, rotation, eulerOrder);
    }

    matrix.setTranslation(position);

    if (scale.x != 1.0 || scale.y != 1.0 || scale.z != 1.0) {
      matrix.scale(scale);
      boundRadiusScale = Math.max(scale.x, Math.max(scale.y, scale.z));
    }

    matrixWorldNeedsUpdate = true;
  }

  /// Updates global transform of the object and its children.
  void updateMatrixWorld({bool force: false}) {

    if (matrixAutoUpdate) updateMatrix();

    // update matrixWorld
    if (matrixWorldNeedsUpdate || force) {
      if (parent != null) {
        matrixWorld = parent.matrixWorld * matrix;
      } else {
        matrixWorld = matrix.clone();
      }

      matrixWorldNeedsUpdate = false;

      force = true;
    }

    // update children
    children.forEach((c) => c.updateMatrixWorld(force: force));

  }

  /// Updates the vector from world space to local space.
  worldToLocal(Vector3 vector) {
    Matrix4 m = this.matrixWorld.clone();
    m.invert();
    m.transform3(vector);
  }

  localToWorld(Vector3 vector) => vector.applyProjection(matrixWorld);

  clone() {

    // TODO

  }

  static Matrix4 ___m1;
  static Matrix4 get __m1 {
    if (___m1 == null) {
      ___m1 = new Matrix4.identity();
    }
    return ___m1;
  }
}
