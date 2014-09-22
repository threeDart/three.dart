part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 *
 * parameters = {
 *  color: <hex>,
 *  program: <function>,
 *  opacity: <float>,
 *  blending: THREE.NormalBlending
 * }
 */

typedef ParticleCanvasMaterialProgram(context);

class ParticleCanvasMaterial extends Material {

  ParticleCanvasMaterialProgram program;

  ParticleCanvasMaterial( { // ParticleCanvasMaterial

                             num color: 0xffffff,
                             this.program,
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
                                   color: color) {

          if (this.program == null) this.program = (context) {};


  }
}
