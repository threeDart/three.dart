library SceneUtils;

import "package:three/three.dart";

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

    (object as MorphAnimMesh).duration = source.duration;
    (object as MorphAnimMesh).mirroredLoop = source.mirroredLoop;
    (object as MorphAnimMesh).time = source.time;

    (object as MorphAnimMesh).lastKeyframe = source.lastKeyframe;
    (object as MorphAnimMesh).currentKeyframe = source.currentKeyframe;

    (object as MorphAnimMesh).direction = source.direction;
    (object as MorphAnimMesh).directionBackwards = source.directionBackwards;

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
    (object as ParticleSystem).sortParticles = source.sortParticles;

  } else if ( source is Particle ) {

    object = new Particle( source.material );

  } else if ( source is Sprite ) {

    object = new Sprite();

    (object as Sprite).color.copy( source.color );
    (object as Sprite).map = source.map;
    (object as Sprite).blending = source.blending;

    (object as Sprite).useScreenCoordinates = source.useScreenCoordinates;
    (object as Sprite).mergeWith3D = source.mergeWith3D;
    (object as Sprite).affectedByDistance = source.affectedByDistance;
    (object as Sprite).scaleByViewport = source.scaleByViewport;
    (object as Sprite).alignment = source.alignment;

    (object as Sprite).rotation3d.copy( source.rotation3d );
    object.rotation = source.rotation;
    (object as Sprite).opacity = source.opacity;

    (object as Sprite).uvOffset.copy( source.uvOffset );
    (object as Sprite).uvScale.copy( source.uvScale);

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

  if ( object.rotation is Vector3 ) {
    object.rotation.copy( source.rotation );
  }

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
