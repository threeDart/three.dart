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
  Dynamic _map;
  num _size;
  bool sizeAttenuation;
  
  int vertexColors;
  bool fog;
  
  Dynamic get map() { return _map; }
  
  ParticleBasicMaterial( [Map parameters] ) : super( parameters )
  {
    Map _parameters = parameters != null ? parameters : {};

    color = _parameters['color'] !== null ? new Color( _parameters['color'] ) : new Color( 0xffffff );

    _map = _parameters['map'] !== null ? _parameters['map'] : null;

    _size = _parameters['size'] !== null ? _parameters['size'] : 1;
    sizeAttenuation = _parameters['sizeAttenuation'] !== null ? _parameters['sizeAttenuation'] : true;

    vertexColors = _parameters['vertexColors'] !== null ? _parameters['vertexColors'] : false;

    fog = _parameters['fog'] !== null ? _parameters['fog'] : true;    
  }
}





