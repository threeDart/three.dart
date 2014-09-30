part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Material {
  String name;
  int id;
  int side;

  /// Diffuse color of the material
  Color color;

  num opacity;
  int blending, blendSrc, blendDst, blendEquation;
  num alphaTest;
  bool polygonOffset;
  int polygonOffsetFactor, polygonOffsetUnits;
  bool transparent, depthTest, depthWrite, overdraw;
  bool visible;

  bool needsUpdate = true;

  bool fog = false;

  int vertexColors;

  // WebGL
  var _program;
  String _fragmentShader;
  String _vertexShader;
  Map<String, Uniform> _uniforms;
  var _uniformsList;

  // Used by ShadowMapPlugin
  bool shadowPass = false;

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

              num color,

              this.overdraw: false, // Boolean for fixing antialiasing gaps in CanvasRenderer

              this.visible: true,

              this.fog: false,

              this.vertexColors: NoColors})
      :

            id = MaterialCount ++,
            this.color = new Color(color);

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

abstract class TextureMapping {
  /// color texture map
  Texture map;
}

abstract class EnvironmentMapping {
  Texture envMap;

  /// Since this material does not have a specular component, the specular value affects only how much of the environment map affects the surface.
  Texture specularMap;
  Texture lightMap;

  double reflectivity, refractionRatio;

  /// How to combine the result of the surface's color with the environment map, if any
  int combine;
}

abstract class BumpMapping {
  var bumpMap;
  num bumpScale;

  Texture normalMap;
  var normalScale;
}

abstract class Lighting {
  /// Ambient color of the material, multiplied by the color of the AmbientLight
  Color ambient;
  /// Emissive (light) color of the material, essentially a solid color unaffected by other lighting
  Color emissive;
  Color specular;

  bool wrapAround = false;
  Vector3 wrapRGB;
}

/** [Material] that uses skinning **/
abstract class Morphing {
  bool morphTargets = false, morphNormals = false;
  num numSupportedMorphTargets = 0, numSupportedMorphNormals = 0;
}

abstract class Skinning {
  bool skinning;
}

abstract class Wireframe {
  bool wireframe;
  num wireframeLinewidth;
  String wireframeLinecap, wireframeLinejoin;
}
