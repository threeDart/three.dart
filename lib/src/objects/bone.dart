part of three;

/// A bone which is part of a SkinnedMesh.
class Bone extends Object3D {
  /// The skin that contains this bone.
  SkinnedMesh skin;
  /// The matrix of the bone.
  Matrix4 skinMatrix;

  Bone(this.skin) : skinMatrix = new Matrix4.identity(), super();

  /// This updates the matrix of the bone and the matrices of its children.
  update( [Matrix4 parentSkinMatrix, bool forceUpdate = false] ) {

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
