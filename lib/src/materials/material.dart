part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// Materials describe the appearance of objects.
///
/// They are defined in a (mostly) renderer-independent way, so you don't have
/// to rewrite materials if you decide to use a different renderer.
class Material {
  /// Material name. Default is an empty string.
  String name;
  /// Unique number for this material instance.
  int id;
  /// Defines which of the face sides will be rendered - front, back or both.
  ///
  /// Default is THREE.FrontSide. Other options are THREE.BackSide and THREE.DoubleSide.
  int side;

  /// Diffuse color of the material
  Color color;

  /// Float in the range of 0.0 - 1.0 indicating how transparent the material is.
  ///
  /// A value of 0.0 indicates fully transparent, 1.0 is fully opaque.
  /// If transparent is not set to true for the material, the material will
  /// remain fully opaque and this value will only affect its color.
  num opacity;
  /// Which blending to use when displaying objects with this material. Default is NormalBlending.
  int blending;
  /// Blending source.
  ///
  /// It's one of the blending mode constants defined in three.dart.
  /// Default is SrcAlphaFactor.
  int blendSrc;
  /// Blending destination.
  ///
  /// It's one of the blending mode constants defined in three.dart.
  /// Default is OneMinusSrcAlphaFactor.
  int blendDst;
  /// Blending equation to use when applying blending.
  ///
  /// It's one of the constants defined in three.dart. Default is AddEquation.
  int blendEquation;
  /// Sets the alpha value to be used when running an alpha test. Default is 0.
  num alphaTest;
  /// Whether to use polygon offset. Default is false.
  ///
  /// This corresponds to the POLYGON_OFFSET_FILL WebGL feature.
  bool polygonOffset;
  /// Sets the polygon offset factor. Default is 0.
  int polygonOffsetFactor;
  /// Sets the polygon offset units. Default is 0.
  int polygonOffsetUnits;
  bool transparent;
  // Whether to have depth test enabled when rendering this material. Default is true.
  bool depthTest;
  /// Whether rendering this material has any effect on the depth buffer. Default is true.
  ///
  /// When drawing 2D overlays it can be useful to disable the depth writing in
  /// order to layer several things together without creating z-index artifacts.
  bool depthWrite;
  /// Boolean for fixing antialiasing gaps in CanvasRenderer
  bool overdraw;
  /// Defines whether this material is visible. Default is true.
  bool visible;

  /// Specifies that the material needs to be updated at the WebGL level.
  ///
  /// Set it to true if you made changes that need to be reflected in WebGL.
  /// This property is automatically set to true when instancing a new material.
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

              this.overdraw: false,

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
