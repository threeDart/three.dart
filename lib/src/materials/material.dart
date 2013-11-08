part of three;

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
  num alphaTest;
  bool polygonOffset;
  int polygonOffsetFactor, polygonOffsetUnits;
  bool transparent, depthTest, depthWrite, overdraw;
  bool visible;

  bool needsUpdate;

  Material( { this.name: '',
              this.side: FrontSide,

              this.opacity: 1,
              this.transparent: false,

              this.blending: NormalBlending,
              this.blendSrc: SrcAlphaFactor,
              this.blendDst: OneMinusSrcAlphaFactor,
              this.blendEquation: AddEquation,

              this.depthTest: true,
              this.depthWrite: true,

              this.polygonOffset: false,
              this.polygonOffsetFactor: 0,
              this.polygonOffsetUnits:  0,

              this.alphaTest: 0,

              this.overdraw: false, // Boolean for fixing antialiasing gaps in CanvasRenderer

              this.visible: true })
      :

            id = MaterialCount ++,
            needsUpdate = true;

  // Quick hack to allow setting new properties (used by the renderer)
  Map __data;

  get _data {
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
