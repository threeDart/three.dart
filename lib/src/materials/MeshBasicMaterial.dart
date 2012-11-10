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
 *  map: new THREE.Texture( <Image> ),
 *
 *  lightMap: new THREE.Texture( <Image> ),
 *
 *  envMap: new THREE.TextureCube( [posx, negx, posy, negy, posz, negz] ),
 *  combine: THREE.Multiply,
 *  reflectivity: <float>,
 *  refractionRatio: <float>,
 *
 *  shading: THREE.SmoothShading,
 *  blending: THREE.NormalBlending,
 *  depthTest: <bool>,
 *
 *  wireframe: <boolean>,
 *  wireframeLinewidth: <float>,
 *
 *  vertexColors: false / THREE.VertexColors / THREE.FaceColors,
 *  skinning: <bool>,
 *
 *  fog: <bool>
 * }
 */

class MeshBasicMaterial extends Material implements ITextureMapMaterial
{
  Color color;

  Texture map;
  Texture lightMap;
  Texture specularMap;
  var envMap; // TextureCube?
  var combine; // Multiply?
  num reflectivity;
  num refractionRatio;

  int shading;
  bool wireframe;
  num wireframeLinewidth;
  String wireframeLinecap, wireframeLinejoin;

  bool skinning, morphTargets;

  int vertexColors;
  bool fog;

  MeshBasicMaterial( { // MeshBasicMaterial

                       this.map,

                       num color: 0xffffff, //emissive

                       this.lightMap,
                       this.specularMap,

                       this.envMap,
                       this.combine: MultiplyOperation,
                       this.reflectivity: 1,
                       this.refractionRatio: 0.98,

                       this.shading: SmoothShading,

                       this.vertexColors: NoColors,

                       this.fog: true,

                       this.wireframe: false,
                       this.wireframeLinewidth: 1,
                       this.wireframeLinecap: 'round',
                       this.wireframeLinejoin: 'round',

                       this.skinning: false,
                       this.morphTargets: false,

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
