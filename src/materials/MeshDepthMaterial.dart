/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 *
 * parameters = {
 *  opacity: <float>,
 
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>
 * } 
 */

class MeshDepthMaterial extends Material
{
  Map _parameters;
  int _shading;
  bool _wireframe;
  num _wireframeLinewidth;
  
  MeshDepthMaterial( Map parameters ) : super( parameters )
  {
    //THREE.Material.call( this, parameters );

    _parameters = parameters != null ? parameters : {};

    _shading = parameters['shading'] !== null ? parameters['shading'] : Three.SmoothShading; // doesn't really apply here, normals are not used

    _wireframe = parameters['wireframe'] !== null ? parameters['wireframe'] : false;
    _wireframeLinewidth = parameters['wireframeLinewidth'] !== null ? parameters['wireframeLinewidth'] : 1;
  }
}
