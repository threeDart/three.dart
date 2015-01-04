part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// A Material to define multiple materials for the same geometry.
///
/// The geometry decides which material is used for which faces by the face's
/// materialindex.
/// The materialindex corresponds with the index of the material in the materials array.
class MeshFaceMaterial extends Material {
  /// Get or set the materials for the geometry.
  List materials = [];

  /// Creates a MeshFaceMaterial with the correct materials.
  MeshFaceMaterial([this.materials]);

}
