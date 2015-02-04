part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author mikael emtinger / http://gomo.se/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 * @author nelson silva / http://www.inevo.pt/
 */

/// Base class for Mesh objects, such as MorphAnimMesh and SkinnedMesh.
class Mesh extends Object3D {
  /// Defines the object's appearance.
  ///
  /// Default is a MeshBasicMaterial with wireframe mode enabled and randomised colour.
  Material material;

  num morphTargetBase = 0;
  List morphTargetForcedOrder;
  List morphTargetInfluences;
  Map _morphTargetDictionary;

  Mesh(Geometry geometry, [this.material]) : super() {

    if (material == null) {
      material = new MeshBasicMaterial(color: new Math.Random().nextInt(0xffffff), wireframe: true);
    }
    if (geometry != null) {
      // calc bound radius
      if (geometry.boundingSphere == null) {
        geometry.computeBoundingSphere();
      }

      boundRadius = geometry.boundingSphere.radius;


      // setup morph targets
      if (geometry.morphTargets.length != 0) {
        morphTargetBase = -1;
        morphTargetForcedOrder = [];
        morphTargetInfluences = [];
        _morphTargetDictionary = {};

        for (int m = 0; m < geometry.morphTargets.length; m++) {
          morphTargetInfluences.add(0.0);
          _morphTargetDictionary[geometry.morphTargets[m].name] = m;
        }
      }

      this.geometry = geometry;
    }
  }


  /// Returns the index of a morph target defined by name.
  num getMorphTargetIndexByName(name) {
    if (_morphTargetDictionary[name] != null) {
      return _morphTargetDictionary[name];
    }

    print("THREE.Mesh.getMorphTargetIndexByName: morph target $name does not exist. Returning 0.");
    return 0;
  }
}
