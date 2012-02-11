/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 *
 * parameters = {
 *  color: <hex>,
 *  ambient: <hex>,
 *  opacity: <float>,
 *
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

class MeshLambertMaterial extends Material implements ITextureMapMaterial
{
  Map _parameters;
  Color _color;
  Color _ambient;
  bool _wrapAround;
  Vector3 _wrapRGB;
  Texture _map;
  Texture _lightMap;
  Dynamic _envMap; //TODO: TextureCube?
  int _combine;
  num _reflectivity;
  num _refractionRatio;
  
  bool _fog;
  int _shading;
  bool _wireframe;
  num _wireframeLinewidth;
  String _wireframeLinecap;
  String _wireframeLinejoin;
  bool _vertexColors;
  bool _skinning;
  bool _morphTargets;
  
  Texture get map() {  return _map;  }
  Dynamic get envMap() {  return _envMap;  }
  Color get color() {  return _color;  }
  bool get wireframe() {  return _wireframe;  }
  num get wireframeLinewidth() {  return _wireframeLinewidth;  }
  String get wireframeLinecap() {  return _wireframeLinecap;  }
  String get wireframeLinejoin() {  return _wireframeLinejoin;  }
  int get shading() {  return _shading;  }
  
  MeshLambertMaterial( Map parameters ) : super( parameters ) 
  {
    //THREE.Material.call( this, parameters );

    _parameters = parameters != null ? parameters : {};

    _color = parameters['color'] !== null ? new Color( parameters['color'] ) : new Color( 0xffffff );
    _ambient = parameters['ambient'] !== null ? new Color( parameters['ambient'] ) : new Color( 0x050505 );

    _wrapAround = parameters['wrapAround'] !== null ? parameters['wrapAround'] : false;
    _wrapRGB = new Vector3( 1, 1, 1 );

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
