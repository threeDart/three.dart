/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 *
 * parameters = {
 *  opacity: <float>,
 
 *  shading: THREE.FlatShading,
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>
 * }
 */
class MeshNormalMaterial extends Material
{
  //Map _parameters;
  int _shading;
  bool _wireframe;
  num _wireframeLinewidth;
  String _wireframeLinecap;
  String _wireframeLinejoin;

  bool get wireframe() {  return _wireframe;  }
  num get wireframeLinewidth() {  return _wireframeLinewidth;  }
  String get wireframeLinecap() {  return _wireframeLinecap;  }
  String get wireframeLinejoin() {  return _wireframeLinejoin;  }
  int get shading() {  return _shading;  }
  
  MeshNormalMaterial( [Map parameters] ) : super( parameters )
  {
    //THREE.Material.call( this, parameters );

    Map _parameters = parameters != null ? parameters : {};

    _shading = (null != _parameters['shading']) ? _parameters['shading'] : Three.FlatShading;

    _wireframe = (null != _parameters['wireframe']) ? _parameters['wireframe'] : false;
    _wireframeLinewidth = (null != _parameters['wireframeLinewidth']) ? _parameters['wireframeLinewidth'] : 1;

  }
}
