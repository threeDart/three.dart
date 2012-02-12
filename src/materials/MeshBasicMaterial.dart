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
 *  lightMap: new THREE.Texture( <Image> ),
 *
 *  envMap: new THREE.TextureCube( [posx, negx, posy, negy, posz, negz] ),
 *  combine: THREE.Multiply,
 *  reflectivity: <float>,
 *  refractionRatio: <float>,
 *
 *  shading: THREE.SmoothShading,
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>,
 *
 *  vertexColors: false / THREE.VertexColors / THREE.FaceColors,
 *  skinning: <bool>,
 *
 *  fog: <bool>
 * }
 */

class MeshBasicMaterial extends Material implements ITextureMapMaterial
{
  Color _color;
  Texture _map;
  Texture _lightMap;
  var _envMap; // TextureCube?
  var _combine; // Three.Multiply?
  num _reflectivity;
  num _refractionRatio;
  bool _fog;
  int _shading;
  bool _wireframe;
  num _wireframeLinewidth;
  String _wireframeLinecap, _wireframeLinejoin;
  bool _vertexColors; //?
  bool _skinning, _morphTargets;
  
  Texture get map() {  return _map;  }
  Dynamic get envMap() {  return _envMap;  }
  Color get color() {  return _color;  }
  bool get wireframe() {  return _wireframe;  }
  num get wireframeLinewidth() {  return _wireframeLinewidth;  }
  String get wireframeLinecap() {  return _wireframeLinecap;  }
  String get wireframeLinejoin() {  return _wireframeLinejoin;  }
  
  MeshBasicMaterial( Map parameters ) : super( parameters )
  {
    //THREE.Material.call( this, parameters );

    parameters = parameters != null ? parameters : {};

    _color = parameters['color'] !== null ? new Color( parameters['color'] ) : new Color( 0xffffff );

    _map = parameters['map'] !== null ? parameters['map'] : null;

    _lightMap = parameters['lightMap'] !== null ? parameters['lightMap'] : null;

    _envMap = parameters['envMap'] !== null ? parameters['envMap'] : null;
    _combine = parameters['combine'] !== null ? parameters['combine'] : Three.MultiplyOperation;
    _reflectivity = parameters['reflectivity'] !== null ? parameters['reflectivity'] : 1;
    _refractionRatio = parameters['refractionRatio'] !== null ? parameters['refractionRatio'] : 0.98;

    _fog = parameters['fog'] !== null ? parameters['fog'] : true;

    _shading = parameters['shading'] !== null ? parameters['shading'] : Three.SmoothShading;

    _wireframe = parameters['wireframe'] !== null ? parameters['wireframe'] : false;
    _wireframeLinewidth = parameters['wireframeLinewidth'] !== null ? parameters['wireframeLinewidth'] : 1;
    _wireframeLinecap = parameters['wireframeLinecap'] !== null ? parameters['wireframeLinecap'] : 'round';
    _wireframeLinejoin = parameters['wireframeLinejoin'] !== null ? parameters['wireframeLinejoin'] : 'round';

    _vertexColors = parameters['vertexColors'] !== null ? parameters['vertexColors'] : false;

    _skinning = parameters['skinning'] !== null ? parameters['skinning'] : false;
    _morphTargets = parameters['morphTargets'] !== null ? parameters['morphTargets'] : false;
  }
}
