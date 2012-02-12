/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author mikael emtinger / http://gomo.se/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Mesh extends Object3D
{
  Geometry _geometry;
  Material _material;
  num _boundRadius;
  
  num _morphTargetBase;
  List _morphTargetForcedOrder;
  List _morphTargetInfluences;
  Map _morphTargetDictionary;
 
  Geometry get geometry() {  return _geometry;  }
  Material get material() {  return _material;  }
  
  //TODO: material currently set to Dynamic due to MeshFaceMaterial
  Mesh( Geometry geometry, Dynamic material ) : super()
  {
//    THREE.Object3D.call( this );

    _geometry = geometry;
    _material = material;
    
    if ( material is List ) {
      //console.warn( 'DEPRECATED: Mesh material can no longer be an Array. Using material at index 0...' );
      //_material = material[ 0 ];
    }

    if ( _geometry != null ) 
    {
      // calc bound radius
      if( _geometry.boundingSphere == null ) {
        _geometry.computeBoundingSphere();
      }

      _boundRadius = geometry.boundingSphere['radius'];


      // setup morph targets
      if( _geometry.morphTargets.length != 0 ) 
      {
        _morphTargetBase = -1;
        _morphTargetForcedOrder = [];
        _morphTargetInfluences = [];
        _morphTargetDictionary = {};

        for( int m = 0; m < _geometry.morphTargets.length; m ++ ) {
          _morphTargetInfluences.add( 0 );
          _morphTargetDictionary[ _geometry.morphTargets[ m ].name ] = m;
        }
      }
    }
  }


  /*
   * Get Morph Target Index by Name
   */
  num getMorphTargetIndexByName( name ) 
  {
    if ( _morphTargetDictionary[ name ] !== null ) {
      return _morphTargetDictionary[ name ];
    }

    //console.log( "THREE.Mesh.getMorphTargetIndexByName: morph target " + name + " does not exist. Returning 0." );
    return 0;
  }
}
