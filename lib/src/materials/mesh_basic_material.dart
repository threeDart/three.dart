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
 *  vertexColors: false / THREE.NoColors / THREE.VertexColors / THREE.FaceColors,
 *  skinning: <bool>,
 *
 *  fog: <bool>
 * }
 */

/// A material for drawing geometries in a simple shaded (flat or wireframe) way.
///
/// The default will render as flat polygons. To draw the mesh as wireframe,
/// simply set the 'wireframe' property to true.
class MeshBasicMaterial extends Material implements TextureMapping, EnvironmentMapping, Skinning, Morphing, Wireframe {

  Texture map;
  Texture lightMap;
  Texture specularMap;
  var envMap; // TextureCube?
  var combine; // Multiply?
  num reflectivity;
  num refractionRatio;

  int shading;
  /// Render geometry as wireframe. Default is false (i.e. render as flat polygons).
  bool wireframe;
  /// Controls wireframe thickness. Default is 1.
  ///
  /// Due to limitations in the ANGLE layer, on Windows platforms linewidth will
  /// always be 1 regardless of the set value.
  num wireframeLinewidth;
  /// Define appearance of line ends.
  ///
  /// Possible values are "butt", "round" and "square". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with
  /// the Canvas renderer.
  String wireframeLinecap;
  /// Define appearance of line joints.
  ///
  /// Possible values are "round", "bevel" and "miter". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with
  /// the Canvas renderer.
  String wireframeLinejoin;

  /// Define whether the material uses skinning. Default is false.
  bool skinning;

  /// Define whether the material uses morphTargets. Default is false.
  bool morphTargets;
  bool morphNormals = false;
  num numSupportedMorphTargets = 0,
      numSupportedMorphNormals = 0;

  MeshBasicMaterial({ // MeshBasicMaterial

  this.map, num color: 0xffffff, //emissive

  this.lightMap, this.specularMap, this.envMap, this.combine: MultiplyOperation, this.reflectivity: 1,
      this.refractionRatio: 0.98, this.shading: SmoothShading, int vertexColors: NoColors, bool fog: true, this.wireframe:
      false, this.wireframeLinewidth: 1, this.wireframeLinecap: 'round', this.wireframeLinejoin: 'round', this.skinning:
      false, this.morphTargets: false, // Material
  name: '', side: FrontSide, opacity: 1, transparent: false, blending: NormalBlending, blendSrc: SrcAlphaFactor,
      blendDst: OneMinusSrcAlphaFactor, blendEquation: AddEquation, depthTest: true, depthWrite: true, polygonOffset: false,
      polygonOffsetFactor: 0, polygonOffsetUnits: 0, alphaTest: 0, overdraw: false, visible: true})
      : super(
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
          vertexColors: vertexColors);

}
