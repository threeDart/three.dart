part of ThreeD;

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
 *  map: new THREE.Texture( <Image> ),
 *
 *  size: <float>,
 *
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *
 *  vertexColors: <bool>,
 *
 *  fog: <bool>
 * }
 */

class ParticleBasicMaterial extends Material implements IParticleMaterial
{
  Color color;
  var map;
  num size;
  bool sizeAttenuation;

  int vertexColors;
  bool fog;

  ParticleBasicMaterial( { // ParticleBasicMaterial

                       this.map,
                       num color: 0xffffff,
                       this.size: 1,
                       this.sizeAttenuation: true,
                       this.vertexColors: Three.NoColors,

                       this.fog: true,

                       // Material
                       name: '',
                       side: Three.FrontSide,

                       opacity: 1,
                       transparent: false,

                       blending: Three.NormalBlending,
                       blendSrc: Three.SrcAlphaFactor,
                       blendDst: Three.OneMinusSrcAlphaFactor,
                       blendEquation: Three.AddEquation,

                       depthTest: true,
                       depthWrite: true,

                       polygonOffset: false,
                       polygonOffsetFactor: 0,
                       polygonOffsetUnits: 0,

                       alphaTest: 0,

                       overdraw: false,

                       visible: true })
                       :
                         this.color = new Color(color),

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





