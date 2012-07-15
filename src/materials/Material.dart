/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Material implements IMaterial
{
  String _name;
  int _id;
  num _opacity; 
  int _blending, _alphaTest, _polygonOffsetFactor, _polygonOffsetUnits;
  bool _transparent, _depthTest, _depthWrite, _polygonOffset, _overdraw;
  
  num get opacity() {  return _opacity;  }
  bool get overdraw() {  return _overdraw;  }
  int get blending() {  return _blending;  }
  
  Material( [Map parameters] ) 
  {
    Map _parameters = parameters != null ? parameters : {};

    _name = '';

    _id = Three.MaterialCount ++;

    _opacity = _parameters['opacity'] !== null ? _parameters['opacity'] : 1;
    _transparent = _parameters['transparent'] !== null ? _parameters['transparent'] : false;

    _blending = _parameters['blending'] !== null ? _parameters['blending'].toInt() : Three.NormalBlending;

    _depthTest = _parameters['depthTest'] !== null ? _parameters['depthTest'] : true;
    _depthWrite = _parameters['depthWrite'] !== null ? _parameters['depthWrite'] : true;

    _polygonOffset = _parameters['polygonOffset'] !== null ? _parameters['polygonOffset'] : false;
    _polygonOffsetFactor = _parameters['polygonOffsetFactor'] !== null ? _parameters['polygonOffsetFactor'].toInt() : 0;
    _polygonOffsetUnits = _parameters['polygonOffsetUnits'] !== null ? _parameters['polygonOffsetUnits'].toInt() : 0;

    _alphaTest = _parameters['alphaTest'] !== null ? _parameters['alphaTest'].toInt() : 0;

    _overdraw = _parameters['overdraw'] !== null ? _parameters['overdraw'] : false; // Boolean for fixing antialiasing gaps in CanvasRenderer

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
