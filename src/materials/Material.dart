/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Material
{
  String _name;
  int _id;
  int _opacity, _blending, _alphaTest, _polygonOffsetFactor, _polygonOffsetUnits;
  bool _transparent, _depthTest, _depthWrite, _polygonOffset, _overdraw;
  
  int get opacity() {  return _opacity;  }
  bool get overdraw() {  return _overdraw;  }
  int get blending() {  return _blending;  }
  
  Material( [Map parameters] ) 
  {
    parameters = parameters != null ? parameters : {};

    _name = '';

    _id = Three.MaterialCount ++;

    _opacity = parameters['opacity'] !== null ? parameters['opacity'] : 1;
    _transparent = parameters['transparent'] !== null ? parameters['transparent'] : false;

    _blending = parameters['blending'] !== null ? parameters['blending'] : Three.NormalBlending;

    _depthTest = parameters['depthTest'] !== null ? parameters['depthTest'] : true;
    _depthWrite = parameters['depthWrite'] !== null ? parameters['depthWrite'] : true;

    _polygonOffset = parameters['polygonOffset'] !== null ? parameters['polygonOffset'] : false;
    _polygonOffsetFactor = parameters['polygonOffsetFactor'] !== null ? parameters['polygonOffsetFactor'] : 0;
    _polygonOffsetUnits = parameters['polygonOffsetUnits'] !== null ? parameters['polygonOffsetUnits'] : 0;

    _alphaTest = parameters['alphaTest'] !== null ? parameters['alphaTest'] : 0;

    _overdraw = parameters['overdraw'] !== null ? parameters['overdraw'] : false; // Boolean for fixing antialiasing gaps in CanvasRenderer

  }
/*
  THREE.MaterialCount = 0;

  THREE.NoShading = 0;
  THREE.FlatShading = 1;
  THREE.SmoothShading = 2;

  THREE.NoColors = 0;
  THREE.FaceColors = 1;
  THREE.VertexColors = 2;

  THREE.NormalBlending = 0;
  THREE.AdditiveBlending = 1;
  THREE.SubtractiveBlending = 2;
  THREE.MultiplyBlending = 3;
  THREE.AdditiveAlphaBlending = 4;
*/
}
