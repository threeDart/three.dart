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
  Color color;
  
  Texture map;
  Texture lightMap;
  Texture specularMap;
  var envMap; // TextureCube?
  var combine; // Three.Multiply?
  num reflectivity;
  num refractionRatio;

  int shading;
  bool wireframe;
  num wireframeLinewidth;
  String wireframeLinecap, wireframeLinejoin;

  bool skinning, morphTargets;
  
  int vertexColors;
  bool fog;
  
  MeshBasicMaterial( Map parameters ) : super( parameters )
  {
    //THREE.Material.call( this, parameters );

    parameters = parameters != null ? parameters : {};

    map = parameters['map'] !== null ? parameters['map'] : null;

    color = parameters['color'] !== null ? new Color( parameters['color'] ) : new Color( 0xffffff ); //emissive
    
    lightMap = parameters['lightMap'] !== null ? parameters['lightMap'] : null;
    specularMap = parameters['specularMap'] !== null ? parameters['specularMap'] : null;
    
    envMap = parameters['envMap'] !== null ? parameters['envMap'] : null;
    combine = parameters['combine'] !== null ? parameters['combine'] : Three.MultiplyOperation;
    reflectivity = parameters['reflectivity'] !== null ? parameters['reflectivity'] : 1;
    refractionRatio = parameters['refractionRatio'] !== null ? parameters['refractionRatio'] : 0.98;

    shading = parameters['shading'] !== null ? parameters['shading'] : Three.SmoothShading;

    vertexColors = (null != parameters['vertexColors']) ? parameters['vertexColors'] : Three.NoColors;

    fog = parameters['fog'] !== null ? parameters['fog'] : true;
    
    wireframe = parameters['wireframe'] !== null ? parameters['wireframe'] : false;
    wireframeLinewidth = parameters['wireframeLinewidth'] !== null ? parameters['wireframeLinewidth'] : 1;
    wireframeLinecap = parameters['wireframeLinecap'] !== null ? parameters['wireframeLinecap'] : 'round';
    wireframeLinejoin = parameters['wireframeLinejoin'] !== null ? parameters['wireframeLinejoin'] : 'round';

    skinning = parameters['skinning'] !== null ? parameters['skinning'] : false;
    morphTargets = parameters['morphTargets'] !== null ? parameters['morphTargets'] : false;
  }
}
