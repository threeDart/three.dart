part of three;

class MeshPhongMaterial extends Material implements ITextureMapMaterial {

  Color color;
  Color ambient;
  Color emissive;
  Color specular;
  num shininess;

  bool metal;
  bool perPixel;

  bool wrapAround;
  Vector3 wrapRGB;

  Texture map;

  var lightMap;

  var bumpMap;
  num bumpScale;

  var normalMap = null;
  var normalScale;

  var specularMap;

  var envMap;
  int combine;
  num reflectivity;
  num refractionRatio;

  int shading;

  bool wireframe;
  num wireframeLinewidth;
  var wireframeLinecap;
  var wireframeLinejoin;

  bool skinning;
  bool morphTargets;
  bool morphNormals;

  int vertexColors;
  bool fog;

  MeshPhongMaterial( { // MeshLambertMaterial

                       num color: 0xffffff, //emissive
                       num ambient: 0xffffff,
                       num emissive: 0x000000,
                       num specular: 0x111111,

                       this.map,

                       this.shininess: 30,

                       this.metal: false,
                       this.perPixel: false,

                       this.wrapAround: false,
                       Vector3 wrapRGB,

                       this.lightMap,
                       this.specularMap,
                       this.envMap,

                       this.bumpMap,
                       this.bumpScale: 1,

                       this.normalMap: null,
                       this.normalScale,

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
                       this.morphNormals: false,

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
                         this.color = new Color(color),
                         this.ambient = new Color(ambient),
                         this.emissive = new Color(emissive),
                         this.specular = new Color(specular),

                         this.wrapRGB = wrapRGB == null ? new Vector3( 1.0, 1.0, 1.0 ) : wrapRGB,

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
                                 visible: visible ) {
                           if (normalScale == null) { normalScale = new Vector2( 1.0, 1.0 ); }
                         }

}
