part of three;

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
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *
 *  linewidth: <float>,
 *  linecap: "round",
 *  linejoin: "round",
 *
 *  vertexColors: <bool>
 *
 *  fog: <bool>
 * }
 */

class LineBasicMaterial extends Material {

  num linewidth;
  String linecap;
  String linejoin;


  LineBasicMaterial({ // LineBasicMaterial

                      num color: 0xffffff,

                      this.linewidth: 1,
                      this.linecap: 'round',
                      this.linejoin: 'round',

                      int vertexColors: NoColors,
                      bool fog: true,

                      // Material
                      name: '',
                      side: FrontSide,

                      opacity: 1,
                      transparent: false,

                      blending: NormalBlending,
                      blendSrc: SrcAlphaFactor,
                      blendDst: OneMinusSrcAlphaFactor,
                      blendEquation: AddEquation,

                      depthTest: true,
                      depthWrite: true,

                      polygonOffset: false,
                      polygonOffsetFactor: 0,
                      polygonOffsetUnits: 0,

                      alphaTest: 0,

                      overdraw: false,

                      visible: true })
      :

                      super(  name: name,
                              side: side,
                              opacity: opacity,
                              transparent: transparent,
                              blending: blending,
                              blendSrc: blendSrc,
                              blendDst: blendDst,
                              blendEquation: blendEquation,
                              depthTest: depthTest,
                              depthWrite: depthWrite,
                              polygonOffset: polygonOffset,
                              polygonOffsetFactor: polygonOffsetFactor,
                              polygonOffsetUnits: polygonOffsetUnits,
                              alphaTest: alphaTest,
                              overdraw: overdraw,
                              visible: visible,
                              color: color,
                              fog: fog,
                              vertexColors: vertexColors);
}
