/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Material implements IMaterial
{
  String name;
  int id;
  int side;
  
  num opacity; 
  int blending, blendSrc, blendDst, blendEquation;
  int alphaTest;
  bool polygonOffset;
  int polygonOffsetFactor, polygonOffsetUnits;
  bool transparent, depthTest, depthWrite, overdraw;
  bool visible;
  
  bool needsUpdate;
  
  Material( [Map parameters] ) 
  {
    Map _parameters = parameters != null ? parameters : {};

    name = '';

    id = Three.MaterialCount ++;

    side = _parameters['side'] !== null ? _parameters['side'] : Three.FrontSide;
    
    opacity = _parameters['opacity'] !== null ? _parameters['opacity'] : 1;
    transparent = _parameters['transparent'] !== null ? _parameters['transparent'] : false;

    blending = _parameters['blending'] !== null ? _parameters['blending'].toInt() : Three.NormalBlending;
    blendSrc = _parameters['blendSrc'] !== null ? _parameters['blendSrc'].toInt() : Three.SrcAlphaFactor;
    blendDst = _parameters['blendDst'] !== null ? _parameters['blendDst'].toInt() : Three.OneMinusSrcAlphaFactor;
    blendEquation = _parameters['blendEquation'] !== null ? _parameters['blendEquation'].toInt() : Three.AddEquation;
    
    depthTest = _parameters['depthTest'] !== null ? _parameters['depthTest'] : true;
    depthWrite = _parameters['depthWrite'] !== null ? _parameters['depthWrite'] : true;

    polygonOffset = _parameters['polygonOffset'] !== null ? _parameters['polygonOffset'] : false;
    polygonOffsetFactor = _parameters['polygonOffsetFactor'] !== null ? _parameters['polygonOffsetFactor'].toInt() : 0;
    polygonOffsetUnits = _parameters['polygonOffsetUnits'] !== null ? _parameters['polygonOffsetUnits'].toInt() : 0;

    alphaTest = _parameters['alphaTest'] !== null ? _parameters['alphaTest'].toInt() : 0;
    
    overdraw = _parameters['overdraw'] !== null ? _parameters['overdraw'] : false; // Boolean for fixing antialiasing gaps in CanvasRenderer

    visible = _parameters['visible'] !== null ? _parameters['visible'] : true;
    
    needsUpdate = true;
  }
  
  // Quick hack to allow setting new properties (used by the renderer)
  Map __data;
  
  get _data() {
    if (__data == null) {
      __data = {};
    }
    return __data;
  }
  
  operator [] (String key) => _data[key];
  operator []= (String key, value) => _data[key] = value;
  
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
