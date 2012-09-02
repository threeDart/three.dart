#library("SceneUtils");

#import("../ThreeD.dart");

showHierarchy( root, visible ) => traverseHierarchy( root, (node) => node.visible = visible);

void traverseHierarchy( root, callback(node) ) {
  root.children.forEach((n) {
    callback(n);
    traverseHierarchy( n, callback );
  });
}

Object3D createMultiMaterialObject( geometry, materials ) {
  var group = new Object3D();

  materials.forEach((material) {
    group.add(new Mesh(geometry, material));
  });

  return group;

}

cloneObject(Object3D source) {

  Object3D object;

  // subclass specific properties
  // (must process in order from more specific subclasses to more abstract classes)

  if ( source is MorphAnimMesh ) {

    object = new MorphAnimMesh( source.geometry, source.material );

    object.duration = source.duration;
    object.mirroredLoop = source.mirroredLoop;
    object.time = source.time;

    object.lastKeyframe = source.lastKeyframe;
    object.currentKeyframe = source.currentKeyframe;

    object.direction = source.direction;
    object.directionBackwards = source.directionBackwards;

  } else if ( source is SkinnedMesh ) {

    object = new SkinnedMesh( source.geometry, source.material );

  } else if ( source is Mesh ) {

    object = new Mesh( source.geometry, source.material );

  } else if ( source is Line ) {

    object = new Line( source.geometry, source.material, source.type );

  } else if ( source is Ribbon ) {

    object = new Ribbon( source.geometry, source.material );

  } else if ( source is ParticleSystem ) {

    object = new ParticleSystem( source.geometry, source.material );
    object.sortParticles = source.sortParticles;

  } else if ( source is Particle ) {

    object = new Particle( source.material );

  } else if ( source is Sprite ) {

    object = new Sprite();

    object.color.copy( source.color );
    object.map = source.map;
    object.blending = source.blending;

    object.useScreenCoordinates = source.useScreenCoordinates;
    object.mergeWith3D = source.mergeWith3D;
    object.affectedByDistance = source.affectedByDistance;
    object.scaleByViewport = source.scaleByViewport;
    object.alignment = source.alignment;

    object.rotation3d.copy( source.rotation3d );
    object.rotation = source.rotation;
    object.opacity = source.opacity;

    object.uvOffset.copy( source.uvOffset );
    object.uvScale.copy( source.uvScale);

  } else if ( source is LOD ) {

    object = new LOD();

  /*
  } else if ( source instanceof THREE.MarchingCubes ) {

    object = new THREE.MarchingCubes( source.resolution, source.material );
    object.field.set( source.field );
    object.isolation = source.isolation;
  */

  } else if ( source is Object3D ) {

    object = new Object3D();

  }

  // base class properties

  object.name = source.name;

  object.parent = source.parent;

  object.up.copy( source.up );

  object.position.copy( source.position );

  // because of Sprite madness

  if ( object.rotation is Vector3 )
    object.rotation.copy( source.rotation );

  object.eulerOrder = source.eulerOrder;

  object.scale.copy( source.scale );

  object.isDynamic = source.isDynamic;

  object.renderDepth = source.renderDepth;

  object.rotationAutoUpdate = source.rotationAutoUpdate;

  object.matrix.copy( source.matrix );
  object.matrixWorld.copy( source.matrixWorld );
  object.matrixRotationWorld.copy( source.matrixRotationWorld );

  object.matrixAutoUpdate = source.matrixAutoUpdate;
  object.matrixWorldNeedsUpdate = source.matrixWorldNeedsUpdate;

  object.quaternion.copy( source.quaternion );
  object.useQuaternion = source.useQuaternion;

  object.boundRadius = source.boundRadius;
  object.boundRadiusScale = source.boundRadiusScale;

  object.visible = source.visible;

  object.castShadow = source.castShadow;
  object.receiveShadow = source.receiveShadow;

  object.frustumCulled = source.frustumCulled;

  // children

  for ( var i = 0; i < source.children.length; i ++ ) {

    var child = cloneObject( source.children[ i ] );
    object.children[ i ] = child;

    child.parent = object;

  }

  // LODs need to be patched separately to use cloned children

  if ( source is LOD ) {

    for ( var i = 0; i < source.LODs.length; i ++ ) {

      var slod = source.LODs[ i ];
      var tlod = object as LOD;
      tlod.LODs[ i ] = { "visibleAtDistance": slod.visibleAtDistance, "object3D": tlod.children[ i ] };

    }

  }

  return object;

}

detach( child, parent, scene ) {
  child.applyMatrix( parent.matrixWorld );
  parent.remove( child );
  scene.add( child );
}

attach( child, scene, parent ) {

  var matrixWorldInverse = new Matrix4();
  matrixWorldInverse.getInverse( parent.matrixWorld );
  child.applyMatrix( matrixWorldInverse );

  scene.remove( child );
  parent.add( child );
}
