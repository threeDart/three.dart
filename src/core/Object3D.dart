/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Object3D 
{
  String _name;
  int id;
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
  
  //TODO: is this meant to be here?
  //THREE.Object3DCount
  //static int Object3DCount = 0;
  
  String get name() {  return _name;  }
  
  Object3D() 
  {
    _name = '';

    id = Three.Object3DCount ++;

    parent = null;
    children = [];

    up = new Vector3();

    position = new Vector3();
    rotation = new Vector3();
    eulerOrder = 'XYZ';
    scale = new Vector3( 1, 1, 1 );

    _dynamic = false; // when true it retains arrays so they can be updated with __dirty*

    doubleSided = false;
    flipSided = false;

    renderDepth = null;

    rotationAutoUpdate = true;

    matrix = new Matrix4();
    matrixWorld = new Matrix4();
    matrixRotationWorld = new Matrix4();

    matrixAutoUpdate = true;
    matrixWorldNeedsUpdate = true;

    quaternion = new Quaternion();
    useQuaternion = false;

    boundRadius = 0.0;
    boundRadiusScale = 1.0;

    visible = true;

    castShadow = false;
    receiveShadow = false;

    frustumCulled = true;

    _vector = new Vector3();
  }

  bool get isDynamic => _dynamic;
  
  void translate( num distance, Vector3 axis ) 
  {
    matrix.rotateAxis( axis );
    position.addSelf( axis.multiplyScalar( distance ) );
  }

  void translateX( num distance )
  {
    translate( distance, _vector.setValues( 1, 0, 0 ) );
  }

  void translateY( num distance )
  {
    translate( distance, _vector.setValues( 0, 1, 0 ) );
  }

  void translateZ( num distance )
  {
    translate( distance, _vector.setValues( 0, 0, 1 ) );
  }

  void lookAt( Vector3 vector ) 
  {
    // TODO: Add hierarchy support.

    matrix.lookAt( vector, position, up );

    if ( rotationAutoUpdate ) {
      rotation.setRotationFromMatrix( matrix );
    }
  }

  void add( Object3D object ) 
  {
    if ( children.indexOf( object ) === - 1 )
    {
      if ( object.parent !== null ) {
        object.parent.remove( object );
      }

      object.parent = this;
      children.add( object );

      // add to scene
      Object3D scene = this;
      
      while ( scene.parent !== null ) {
        scene = scene.parent;
      }
      //TODO: "instanceof" equivalent to "is"?
      if ( scene is Scene ) {
        scene.addObject( object );
      }
    }
  }

  void remove( Object3D object )
  {
    int index = children.indexOf( object );

    if ( index !== - 1 )
    {
      object.parent = null;
      children.removeRange(index, 1);
      // children.splice( index, 1 );

      // remove from scene
      Object3D scene = this;

      while ( scene.parent !== null ) {
        scene = scene.parent;
      }
      //TODO: "instanceof" equivalent to "is"?
      if (scene is Scene ) {
        scene.removeObject( object );
      }
    }
  }

  Object3D getChildByName( String name, bool doRecurse ) 
  {
    int c;
    int cl = children.length;
    Object3D child, recurseResult;

    for ( c = 0; c < cl; c ++ ) 
    {
      child = children[ c ];

      if ( child.name === name ) {
        return child;
      }

      if ( doRecurse ) 
      {
        recurseResult = child.getChildByName( name, doRecurse );

        if ( recurseResult !== null ) {
          return recurseResult;
        }
      }
    }

    return null;
  }

  void updateMatrix() 
  {
    matrix.setPosition( position );

    if ( useQuaternion ) {
      matrix.setRotationFromQuaternion( quaternion );
    } else {
      matrix.setRotationFromEuler( rotation, eulerOrder );
    }

    if ( scale.x !== 1 || scale.y !== 1 || scale.z !== 1 ) 
    {
      matrix.scale( scale );
      boundRadiusScale = Math.max( scale.x, Math.max( scale.y, scale.z ) );
    }

    matrixWorldNeedsUpdate = true;
  }

  void updateMatrixWorld( [bool force=false] ) 
  {
    //TODO: figure out what was meant by this line...
   // matrixAutoUpdate && updateMatrix();
   if (matrixAutoUpdate) updateMatrix();

    // update matrixWorld
    if ( matrixWorldNeedsUpdate || force )
    {
      if ( parent !== null ) {
        matrixWorld.multiply( parent.matrixWorld, matrix );
      } else {
        matrixWorld.copy( matrix );
      }

      matrixWorldNeedsUpdate = false;

      force = true;
    }

    // update children
    for ( int i = 0, l = children.length; i < l; i ++ ) {
      children[ i ].updateMatrixWorld( force );
    }
  }
  
  // Quick hack to allow setting new properties (used by the renderer)
  Map __data;
  
  get _data() {
    if (__data == null) {
      __data = {};
    }
    return __data;
  }
  
  operator [] (String key) => _data[key];
  operator []= (String key, value) => _data[key] = value;
}
