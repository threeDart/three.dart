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

/// A material for drawing wireframe-style geometries.
class LineBasicMaterial extends Material {
  /// Controls line thickness. Default is 1.
  ///
  /// Due to limitations in the ANGLE layer, on Windows platforms linewidth
  /// will always be 1 regardless of the set value.
  num linewidth;
  /// Define appearance of line ends.
  ///
  /// Possible values are "butt", "round" and "square". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with
  /// the Canvas renderer.
  String linecap;
  /// Define appearance of line joints.
  ///
  /// Possible values are "round", "bevel" and "miter". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with
  /// the Canvas renderer.
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
