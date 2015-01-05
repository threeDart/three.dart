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
 *  ambient: <hex>,
 *  opacity: <float>,
 *
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
 *  vertexColors: false / THREE.NoColors  / THREE.VertexColors / THREE.FaceColors,
 *  skinning: <bool>,
 *
 *  fog: <bool>
 * }
 */

/// A material for non-shiny (Lambertian) surfaces, evaluated per vertex.
class MeshLambertMaterial extends Material
  implements Lighting,
       TextureMapping,
       EnvironmentMapping,
       Skinning,
       Morphing,
       Wireframe {
  Map _parameters;

  // Lighting

  /// Diffuse color of the material. Default is white.
  Color color;
  /// Ambient color of the material, multiplied by the color of the AmbientLight. Default is white.
  Color ambient;
  /// Emissive (light) color of the material, essentially a solid color unaffected by other lighting. Default is black.
  Color emissive;
  Color specular;

  bool wrapAround;
  Vector3 wrapRGB;
  Texture map;
  Texture lightMap;
  Texture specularMap;
  var envMap; //TODO: TextureCube?
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
  /// Due to limitations in the ANGLE layer, on Windows platforms linewidth
  /// will always be 1 regardless of the set value.
  num wireframeLinewidth;
  /// Define appearance of line ends.
  ///
  /// Possible values are "butt", "round" and "square". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with the Canvas renderer.
  String wireframeLinecap;
  /// Define appearance of line joints.
  ///
  /// Possible values are "round", "bevel" and "miter". Default is 'round'.
  ///
  /// This setting might not have any effect when used with certain renderers.
  /// For example, it is ignored with the WebGL renderer, but does work with the Canvas renderer.
  String wireframeLinejoin;

  /// Define whether the material uses skinning. Default is false.
  bool skinning;

  // Morphing
  /// Define whether the material uses morphTargets. Default is false.
  bool morphTargets;
  bool morphNormals;
  num numSupportedMorphTargets = 0, numSupportedMorphNormals = 0;

  MeshLambertMaterial( { // MeshLambertMaterial

                         this.map,

                         num color: 0xffffff, //emissive
                         num ambient: 0xffffff,
                         num emissive: 0x000000,

                         this.wrapAround: false,
                         Vector3 wrapRGB,

                         this.lightMap,
                         this.specularMap,
                         this.envMap,

                         this.combine: MultiplyOperation,
                         this.reflectivity: 1,
                         this.refractionRatio: 0.98,

                         this.shading: SmoothShading,

                         int vertexColors: NoColors,

                         bool fog: true,

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
                         polygonOffsetUnits: 0,

                         alphaTest: 0,

                         overdraw: false,

                         visible: true })
                         :
                           this.color = new Color(color),
                           this.ambient = new Color(ambient),
                           this.emissive = new Color(emissive),

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
                                   visible: visible,
                                   color: color,
                                   fog: fog,
                                   vertexColors: vertexColors );

}
