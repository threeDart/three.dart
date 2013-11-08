part of three;

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

class MeshDepthMaterial extends Material {
  Map _parameters;
  int shading;
  bool wireframe;
  num wireframeLinewidth;

  MeshDepthMaterial( { // MeshDepthMaterial
                       this.shading: SmoothShading, // doesn't really apply here, normals are not used
                       this.wireframe: false,
                       this.wireframeLinewidth: 1,


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
                       polygonOffsetUnits:  0,

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
                                 visible: visible );

}
