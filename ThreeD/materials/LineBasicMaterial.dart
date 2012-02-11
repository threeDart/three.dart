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
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *
 *  linewidth: <float>,
 *  linecap: "round",
 *  linejoin: "round",
 *
 *  vertexColors: <bool>
 *
 *  fog: <bool>
 * }
 */

class LineBasicMaterial extends Material
{
  Color _color;
  num _linewidth;
  String _linecap;
  String _linejoin;
  bool _vertexColors;
  bool _fog;
  
  num get linewidth() {  return _linewidth;  }
  String get linecap() {  return _linecap;  }
  String get linejoin() {  return _linejoin;  }
  Color get color() {  return _color;  }
  
  LineBasicMaterial( [Map parameters] ) : super( parameters )
  {
    //THREE.Material.call( this, parameters );

    parameters = parameters != null ? parameters : {};

    _color = parameters['color'] !== null ? new Color( parameters['color'] ) : new Color( 0xffffff );

    _linewidth = parameters['linewidth'] !== null ? parameters['linewidth'] : 1;
    _linecap = parameters['linecap'] !== null ? parameters['linecap'] : 'round';
    _linejoin = parameters['linejoin'] !== null ? parameters['linejoin'] : 'round';

    _vertexColors = parameters['vertexColors'] ? parameters['vertexColors'] : false;

    _fog = parameters['fog'] !== null ? parameters['fog'] : true;
  }
}
