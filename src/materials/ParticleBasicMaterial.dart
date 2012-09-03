/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/  
 *
 * parameters = {
 *  color: <hex>,
 *  opacity: <float>,
 *  map: new THREE.Texture( <Image> ),
 *
 *  size: <float>,
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *
 *  vertexColors: <bool>,
 *
 *  fog: <bool>
 * }
 */

class ParticleBasicMaterial extends Material implements IParticleMaterial
{
  Color color;
  Dynamic map;
  num size;
  bool sizeAttenuation;
  
  int vertexColors;
  bool fog;
  
  ParticleBasicMaterial( [Map parameters] ) : super( parameters )
  {
    Map _parameters = parameters != null ? parameters : {};

    color = _parameters['color'] !== null ? new Color( _parameters['color'] ) : new Color( 0xffffff );

    map = _parameters['map'] !== null ? _parameters['map'] : null;

    size = _parameters['size'] !== null ? _parameters['size'] : 1;
    sizeAttenuation = _parameters['sizeAttenuation'] !== null ? _parameters['sizeAttenuation'] : true;

    vertexColors = _parameters['vertexColors'] !== null ? _parameters['vertexColors'] : Three.NoColors;;

    fog = _parameters['fog'] !== null ? _parameters['fog'] : true;    
  }
}





