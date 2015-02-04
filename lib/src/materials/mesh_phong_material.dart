part of three;

/// A material for shiny surfaces, evaluated per pixel.
class MeshPhongMaterial extends Material implements Lighting, TextureMapping, EnvironmentMapping, Skinning, Morphing {

  /// Ambient color of the material, multiplied by the color of the AmbientLight. Default is white.
  Color ambient;
  /// Emissive (light) color of the material, essentially a solid color
  /// unaffected by other lighting. Default is black.
  Color emissive;
  /// Specular color of the material, i.e., how shiny the material is and the
  /// color of its shine.
  ///
  /// Setting this the same color as the diffuse value (times some intensity)
  /// makes the material more metallic-looking; setting this to some gray makes
  /// the material look more plastic. Default is dark gray.
  Color specular;
  /// How shiny the specular highlight is; a higher value gives a sharper highlight. Default is 30.
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

  /// How the triangles of a curved surface are rendered: as a smooth surface,
  /// as flat separate facets, or no shading at all.
  ///
  /// Options are SmoothShading (default), FlatShading, NoShading.
  int shading;

  /// Whether the triangles' edges are displayed instead of surfaces. Default is false.
  bool wireframe;
  /// Line thickness for wireframe mode. Default is 1.0.
  ///
  /// Due to limitations in the ANGLE layer, on Windows platforms linewidth will
  /// always be 1 regardless of the set value.
  num wireframeLinewidth;
  /// Define appearance of line ends.
  ///
  /// Possible values are "butt", "round" and "square". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with the
  /// Canvas renderer.
  var wireframeLinecap;
  /// Define appearance of line joints.
  ///
  /// Possible values are "round", "bevel" and "miter". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with the
  /// Canvas renderer.
  var wireframeLinejoin;

  /// Define whether the material uses skinning. Default is false.
  bool skinning;

  // Morphing
  /// Define whether the material uses morphTargets. Default is false.
  bool morphTargets;
  bool morphNormals;
  num numSupportedMorphTargets = 0,
      numSupportedMorphNormals = 0;

  MeshPhongMaterial({ // MeshLambertMaterial

  num color: 0xffffff, //emissive
  num ambient: 0xffffff, num emissive: 0x000000, num specular: 0x111111, this.map, this.shininess: 30, this.metal:
      false, this.perPixel: false, this.wrapAround: false, Vector3 wrapRGB, this.lightMap, this.specularMap, this.envMap,
      this.bumpMap, this.bumpScale: 1, this.normalMap: null, this.normalScale, this.combine: MultiplyOperation,
      this.reflectivity: 1, this.refractionRatio: 0.98, this.shading: SmoothShading, int vertexColors: NoColors, bool fog:
      true, this.wireframe: false, this.wireframeLinewidth: 1, this.wireframeLinecap: 'round', this.wireframeLinejoin:
      'round', this.skinning: false, this.morphTargets: false, this.morphNormals: false, // Material
  name: '', side: FrontSide, opacity: 1, transparent: false, blending: NormalBlending, blendSrc: SrcAlphaFactor,
      blendDst: OneMinusSrcAlphaFactor, blendEquation: AddEquation, depthTest: true, depthWrite: true, polygonOffset: false,
      polygonOffsetFactor: 0, polygonOffsetUnits: 0, alphaTest: 0, overdraw: false, visible: true})
      : this.ambient = new Color(ambient),
        this.emissive = new Color(emissive),
        this.specular = new Color(specular),

        this.wrapRGB = wrapRGB == null ? new Vector3(1.0, 1.0, 1.0) : wrapRGB,

        super(
          name: name,
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
          vertexColors: vertexColors) {

    if (normalScale == null) {
      normalScale = new Vector2(1.0, 1.0);
    }

  }

}
