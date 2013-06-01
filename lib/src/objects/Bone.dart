part of three;

class Bone extends Object3D {

  var skin;
  Matrix4 skinMatrix;

  Bone(this.skin) : skinMatrix = new Matrix4.identity(), super();

  update( [Matrix4 parentSkinMatrix, forceUpdate = false] ) {

    // update local
    if ( matrixAutoUpdate ) {

      // This should be <=> forceUpdate |= updateMatrix();
      if (forceUpdate) updateMatrix();
    }

    // update skin matrix

    if ( forceUpdate || matrixWorldNeedsUpdate ) {

      if( parentSkinMatrix != null) {

        skinMatrix = parentSkinMatrix * matrix;

      } else {

        skinMatrix = matrix.clone();

      }

      matrixWorldNeedsUpdate = false;
      forceUpdate = true;

    }

    // update children
    children.forEach((c) => c.update(skinMatrix, forceUpdate));

  }
}
