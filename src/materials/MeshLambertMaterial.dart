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

  Color color;
  Color _ambient;
  bool _wrapAround;
  Vector3 _wrapRGB;
  Texture map;
  Texture lightMap;
  Dynamic envMap; //TODO: TextureCube?
  int _combine;
  num _reflectivity;
  num _refractionRatio;
  
  int shading;
  bool wireframe;
  num wireframeLinewidth;
  String wireframeLinecap;
  String wireframeLinejoin;

  bool skinning;
  bool morphTargets;
  
  int vertexColors;
  bool fog;
  
  MeshLambertMaterial( Map parameters ) : super( parameters ) 
  {
    //THREE.Material.call( this, parameters );

    _parameters = parameters != null ? parameters : {};

    color = parameters['color'] !== null ? new Color( parameters['color'] ) : new Color( 0xffffff );
    _ambient = parameters['ambient'] !== null ? new Color( parameters['ambient'] ) : new Color( 0x050505 );

    _wrapAround = parameters['wrapAround'] !== null ? parameters['wrapAround'] : false;
    _wrapRGB = new Vector3( 1, 1, 1 );

    map = parameters['map'] !== null ? parameters['map'] : null;

    lightMap = parameters['lightMap'] !== null ? parameters['lightMap'] : null;

    envMap = parameters['envMap'] !== null ? parameters['envMap'] : null;
    _combine = parameters['combine'] !== null ? parameters['combine'] : Three.MultiplyOperation;
    _reflectivity = parameters['reflectivity'] !== null ? parameters['reflectivity'] : 1;
    _refractionRatio = parameters['refractionRatio'] !== null ? parameters['refractionRatio'] : 0.98;

    fog = parameters['fog'] !== null ? parameters['fog'] : true;

    shading = parameters['shading'] !== null ? parameters['shading'] : Three.SmoothShading;

    wireframe = parameters['wireframe'] !== null ? parameters['wireframe'] : false;
    wireframeLinewidth = parameters['wireframeLinewidth'] !== null ? parameters['wireframeLinewidth'] : 1;
    wireframeLinecap = parameters['wireframeLinecap'] !== null ? parameters['wireframeLinecap'] : 'round';
    wireframeLinejoin = parameters['wireframeLinejoin'] !== null ? parameters['wireframeLinejoin'] : 'round';

    vertexColors = parameters['vertexColors'] !== null ? parameters['vertexColors'] : Three.NoColors;

    skinning = parameters['skinning'] !== null ? parameters['skinning'] : false;
    morphTargets = parameters['morphTargets'] !== null ? parameters['morphTargets'] : false;
  }
}
