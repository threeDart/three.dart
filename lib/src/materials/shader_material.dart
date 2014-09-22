part of three;

class ShaderMaterial extends Material implements Morphing, Skinning, Wireframe {

  int shading;

  // Wireframe
  bool wireframe;
  num wireframeLinewidth;
  String wireframeLinecap, wireframeLinejoin;

  bool lights; // set to use scene lights

  bool skinning; // set to use skinning attribute streams

  // Morphing
  bool morphTargets; // set to use morph targets
  bool morphNormals; // set to use morph normals
  num numSupportedMorphTargets = 0, numSupportedMorphNormals = 0;

  Map<String, Attribute> attributes;

  Map defines = {};

  ShaderMaterial( { // ShaderMaterial
                    this.attributes,
                    String fragmentShader: "void main() {}",
                    String vertexShader: "void main() {}",
                    Map uniforms,

                    this.shading: SmoothShading,

                    int vertexColors: NoColors,
                    bool fog: true,

                    this.wireframe: false,
                    this.wireframeLinewidth: 1,

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

                    visible: true,
                    this.lights: false})
                    : super(  name: name,
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
                              fog: fog,
                              vertexColors: vertexColors) {
                      this._uniforms = (uniforms != null) ? uniforms : {};
                      this._fragmentShader = fragmentShader;
                      this._vertexShader = vertexShader;
                    }

}
