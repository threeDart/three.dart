part of three;

class ShaderMaterial extends Material {

  String fragmentShader;
  String vertexShader;
  Map uniforms;

  //var attributes; - Moved to Material

  int shading;

  bool wireframe;
  num wireframeLinewidth;


  bool lights; // set to use scene lights

  bool skinning; // set to use skinning attribute streams

  bool morphTargets; // set to use morph targets
  bool morphNormals; // set to use morph normals

  int vertexColors;
  bool fog;

  Map attributes;

  ShaderMaterial( { // ShaderMaterial
                    this.attributes,
                    this.fragmentShader: "void main() {}",
                    this.vertexShader: "void main() {}",
                    Map uniforms,

                    this.shading: SmoothShading,

                    this.vertexColors: NoColors,

                    this.fog: true,

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
                              visible: visible ) {
                      this.uniforms = (uniforms != null) ? uniforms : {};
                    }

}
