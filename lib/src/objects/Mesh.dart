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

class Mesh extends Object3D {
  Geometry geometry;
  Material material;

  num morphTargetBase = 0;
  List morphTargetForcedOrder;
  List morphTargetInfluences;
  Map _morphTargetDictionary;

  Mesh( this.geometry, [this.material] ) : super() {

    if (material == null) {
      material = new MeshBasicMaterial( color: new Math.Random().nextInt(0xffffff), wireframe: true );
    }
    if ( geometry != null ) {
      // calc bound radius
      if( geometry.boundingSphere == null ) {
        geometry.computeBoundingSphere();
      }

      boundRadius = geometry.boundingSphere.radius;


      // setup morph targets
      if( geometry.morphTargets.length != 0 ) {
        morphTargetBase = -1;
        morphTargetForcedOrder = [];
        morphTargetInfluences = [];
        _morphTargetDictionary = {};

        for( int m = 0; m < geometry.morphTargets.length; m ++ ) {
          morphTargetInfluences.add( 0 );
          _morphTargetDictionary[ geometry.morphTargets[ m ].name ] = m;
        }
      }
    }
  }

  /*
   * Get Morph Target Index by Name
   */
  num getMorphTargetIndexByName( name ) {
    if ( _morphTargetDictionary[ name ] != null ) {
      return _morphTargetDictionary[ name ];
    }

    print( "THREE.Mesh.getMorphTargetIndexByName: morph target $name does not exist. Returning 0." );
    return 0;
  }
}
