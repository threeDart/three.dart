part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Object3D {

  int id;
  String name;
  Map properties;

  Object3D parent;
  List children;

  Vector3 up, position, rotation, scale;

  String eulerOrder;

  bool _dynamic, doubleSided, flipSided, rotationAutoUpdate;

  int renderDepth;

  Matrix4 matrix, matrixWorld, matrixRotationWorld;

  bool matrixAutoUpdate = false, matrixWorldNeedsUpdate = false;

  Quaternion quaternion;
  bool useQuaternion;

  num boundRadius, boundRadiusScale;

  bool visible = false, castShadow = false, receiveShadow = false, frustumCulled = false;

  Vector3 _vector;

  var customDepthMaterial;

  Object3D()
      : id = Object3DCount++,

        name = '',
        properties = {},

        parent = null,
        children = [],

        up = new Vector3( 0, 1, 0),

        position = new Vector3(),
        rotation = new Vector3(),
        eulerOrder = 'XYZ',
        scale = new Vector3( 1, 1, 1 ),

        renderDepth = null,

        rotationAutoUpdate = true,

        matrix = new Matrix4(),
        matrixWorld = new Matrix4(),
        matrixRotationWorld = new Matrix4(),

        matrixAutoUpdate = true,
        matrixWorldNeedsUpdate = true,

        quaternion = new Quaternion(),
        useQuaternion = false,

        boundRadius = 0.0,
        boundRadiusScale = 1.0,

        visible = true,

        castShadow = false,
        receiveShadow = false,

        frustumCulled = true,

        _vector = new Vector3();

        // TODO - These are not in three.js
        //_dynamic = false, // when true it retains arrays so they can be updated with __dirty*

        //doubleSided = false,
        //flipSided = false,

  // dynamic
  bool get isDynamic => _dynamic;
       set isDynamic(bool flag) => _dynamic = flag;

  void applyMatrix ( matrix ) {

    this.matrix.multiply(matrix, this.matrix);

    this.scale.getScaleFromMatrix( this.matrix );

    var mat = new Matrix4().extractRotation( this.matrix );
    this.rotation.setEulerFromRotationMatrix( mat, this.eulerOrder );

    this.position.getPositionFromMatrix( this.matrix );

  }

  void translate( num distance, Vector3 axis ) {
    matrix.rotateAxis( axis );
    position.addSelf( axis.multiplyScalar( distance ) );
  }

  void translateX( num distance ) => translate( distance, _vector.setValues( 1, 0, 0 ) );

  void translateY( num distance ) => translate( distance, _vector.setValues( 0, 1, 0 ) );

  void translateZ( num distance ) => translate( distance, _vector.setValues( 0, 0, 1 ) );

  void lookAt( Vector3 vector ) {
    // TODO: Add hierarchy support.

    matrix.lookAt( vector, position, up );

    if ( rotationAutoUpdate ) {
      rotation.setEulerFromRotationMatrix( matrix, eulerOrder );
    }
  }

  void add( Object3D object ) {
    if ( object == this ) {
      print( 'THREE.Object3D.add: An object can\'t be added as a child of itself.' );
      return;
    }


    if ( object.parent != null ) {
      object.parent.remove( object );
    }

    object.parent = this;
    children.add( object );

    // add to scene
    Object3D scene = this;

    while ( scene.parent != null ) {
      scene = scene.parent;
    }

    if ( scene is Scene ) {
      scene.addObject( object );
    }

  }

  void remove( Object3D object ) {

    int index = children.indexOf( object );

    if ( index != - 1 ){

      object.parent = null;
      children.removeAt(index);

      // remove from scene
      Object3D scene = this;

      while ( scene.parent != null ) {
        scene = scene.parent;
      }

      if (scene is Scene ) {
        scene.removeObject( object );
      }
    }
  }

  Object3D getChildByName( String name, bool doRecurse ) {
    int c;
    int cl = children.length;
    Object3D child, recurseResult;

    children.forEach((child){

      if ( child.name == name ) {
        return child;
      }

      if ( doRecurse ) {
        recurseResult = child.getChildByName( name, doRecurse );

        if ( recurseResult != null ) {
          return recurseResult;
        }
      }
    });

    return null;
  }

  void updateMatrix() {
    matrix.setPosition( position );

    if ( useQuaternion ) {
      matrix.setRotationFromQuaternion( quaternion );
    } else {
      matrix.setRotationFromEuler( rotation, eulerOrder );
    }

    if ( scale.x != 1 || scale.y != 1 || scale.z != 1 ) {
      matrix.scale( scale );
      boundRadiusScale = Math.max( scale.x, Math.max( scale.y, scale.z ) );
    }

    matrixWorldNeedsUpdate = true;
  }

  void updateMatrixWorld( {bool force: false} ) {

   if (matrixAutoUpdate) updateMatrix();

    // update matrixWorld
    if ( matrixWorldNeedsUpdate || force ) {
      if ( parent != null ) {
        matrixWorld.multiply( parent.matrixWorld, matrix );
      } else {
        matrixWorld.copy( matrix );
      }

      matrixWorldNeedsUpdate = false;

      force = true;
    }

    // update children
    children.forEach((c) => c.updateMatrixWorld( force: force ) );

  }

  worldToLocal( vector ) => __m1.getInverse( this.matrixWorld ).multiplyVector3( vector );

  localToWorld( vector ) => matrixWorld.multiplyVector3( vector );

  clone() {

    // TODO

  }

  static Matrix4 ___m1;
  static Matrix4 get __m1 {
    if (___m1 == null) {
      ___m1 = new Matrix4();
    }
    return ___m1;
  }

  // Quick hack to allow setting new properties (used by the renderer)
  Map __data;

  get _data {
    if (__data == null) {
      __data = {};
    }
    return __data;
  }

  operator [] (String key) => _data[key];
  operator []= (String key, value) => _data[key] = value;
}
