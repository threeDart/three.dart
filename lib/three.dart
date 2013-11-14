library three;

import 'dart:async';
import 'dart:html' hide Path;
import 'dart:typed_data';
import 'dart:web_gl' as gl;
import 'dart:math' as Math;
import 'dart:convert' show JSON;

import 'src/core/three_math.dart' as ThreeMath;
export 'src/core/three_math.dart';

import 'package:vector_math/vector_math.dart';

// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
import 'extras/image_utils.dart' as ImageUtils;
import 'extras/font_utils.dart' as FontUtils;
import 'extras/shader_utils.dart' as ShaderUtils;

import 'extras/core/curve_utils.dart' as CurveUtils;
import 'extras/core/shape_utils.dart' as ShapeUtils;

part 'src/cameras/camera.dart';
part 'src/cameras/perspective_camera.dart';
part 'src/cameras/orthographic_camera.dart';

part 'src/core/vector_utils.dart';
part 'src/core/matrix_utils.dart';
part 'src/core/object3d.dart';
part 'src/core/color.dart';
part 'src/core/face.dart';
part 'src/core/face3.dart';
part 'src/core/face4.dart';
part 'src/core/frustum.dart';
part 'src/core/morph_colors.dart';
part 'src/core/morph_target.dart';
part 'src/core/geometry.dart';
part 'src/core/projector.dart';
part 'src/core/ray.dart';
part 'src/core/uv.dart';
part 'src/core/rectangle.dart';
part 'src/core/buffer_geometry.dart';
part 'src/core/event_emitter.dart';

part 'src/loaders/loader.dart';
part 'src/loaders/json_loader.dart';
part 'src/loaders/image_loader.dart';
part 'src/loaders/stl_loader.dart';

part 'extras/geometries/circle_geometry.dart';
part 'extras/geometries/convex_geometry.dart';
part 'extras/geometries/cube_geometry.dart';
part 'extras/geometries/cylinder_geometry.dart';
part 'extras/geometries/extrude_geometry.dart';
part 'extras/geometries/icosahedron_geometry.dart';
part 'extras/geometries/lathe_geometry.dart';
part 'extras/geometries/octahedron_geometry.dart';
part 'extras/geometries/parametric_geometry.dart';
part 'extras/geometries/plane_geometry.dart';
part 'extras/geometries/polyhedron_geometry.dart';
part 'extras/geometries/shape_geometry.dart';
part 'extras/geometries/sphere_geometry.dart';
part 'extras/geometries/tetrahedron_geometry.dart';
part 'extras/geometries/text_geometry.dart';
part 'extras/geometries/torus_geometry.dart';
part 'extras/geometries/torus_knot_geometry.dart';
part 'extras/geometries/tube_geometry.dart';

part 'extras/core/curve.dart';
part 'extras/core/curve_path.dart';
part 'extras/core/path.dart';
part 'extras/core/shape.dart';
part 'extras/core/line_curve.dart';
part 'extras/core/quadratic_bezier_curve.dart';
part 'extras/core/cubic_bezier_curve.dart';
part 'extras/core/spline_curve.dart';
part 'extras/core/arc_curve.dart';
part 'extras/core/ellipse_curve.dart';

part 'extras/core/line_curve3.dart';
part 'extras/core/quadratic_bezier_curve3.dart';
part 'extras/core/cubic_bezier_curve3.dart';
part 'extras/core/spline_curve3.dart';
part 'extras/core/closed_spline_curve3.dart';

part 'extras/core/gyroscope.dart';

part 'extras/objects/lens_flare.dart';
part 'extras/objects/immediate_render_object.dart';

part 'extras/helpers/arrow_helper.dart';
part 'extras/helpers/axis_helper.dart';
part 'extras/helpers/camera_helper.dart';

part 'extras/renderers/plugins/shadow_map_plugin.dart';

part 'src/lights/ambient_light.dart';
part 'src/lights/directional_light.dart';
part 'src/lights/point_light.dart';
part 'src/lights/spot_light.dart';
part 'src/lights/hemisphere_light.dart';
part 'src/lights/light.dart';
part 'src/lights/shadow_caster.dart';

part 'src/materials/material.dart';
part 'src/materials/mesh_basic_material.dart';
part 'src/materials/mesh_face_material.dart';
part 'src/materials/particle_basic_material.dart';
part 'src/materials/particle_canvas_material.dart';
part 'src/materials/line_basic_material.dart';
part 'src/materials/mesh_lambert_material.dart';
part 'src/materials/mesh_depth_material.dart';
part 'src/materials/mesh_normal_material.dart';
part 'src/materials/itexture_map_material.dart';
part 'src/materials/iparticle_material.dart';
part 'src/materials/imaterial.dart';
part 'src/materials/mesh_phong_material.dart';
part 'src/materials/shader_material.dart';

part 'src/objects/bone.dart';
part 'src/objects/mesh.dart';
part 'src/objects/line.dart';
part 'src/objects/particle.dart';
part 'src/objects/particle_system.dart';
part 'src/objects/sprite.dart';
part 'src/objects/ribbon.dart';
part 'src/objects/skinned_mesh.dart';
part 'src/objects/lod.dart';
part 'src/objects/morph_anim_mesh.dart';

part 'src/renderers/renderables/renderable_object.dart';
part 'src/renderers/renderables/renderable_vertex.dart';
part 'src/renderers/renderables/renderable_face.dart';
part 'src/renderers/renderables/renderable_face3.dart';
part 'src/renderers/renderables/renderable_face4.dart';
part 'src/renderers/renderables/renderable_line.dart';
part 'src/renderers/renderables/renderable_particle.dart';

part 'src/renderers/renderer.dart';
part 'src/renderers/web_gl_renderer.dart';
part 'src/renderers/web_gl_render_target.dart';
part 'src/renderers/web_gl_render_target_cube.dart';
part 'src/renderers/web_gl_shaders.dart';
part 'src/renderers/canvas_renderer.dart';
part 'src/renderers/css3d_renderer.dart';

part 'src/renderers/renderables/irenderable.dart';

part 'src/scenes/scene.dart';
part 'src/scenes/fog.dart';
part 'src/scenes/fog_linear.dart';
part 'src/scenes/fog_exp2.dart';

part 'src/textures/texture.dart';
part 'src/textures/data_texture.dart';
part 'src/textures/compressed_texture.dart';

part 'src/uv_mapping.dart';
part 'src/materials/mappings.dart';

// from _geometry
int GeometryCount = 0;

// from Object3D
int Object3DCount = 0;

// from _material
int MaterialCount = 0;

// GL STATE CONSTANTS

const int CullFaceNone = 0;
const int CullFaceBack = 1;
const int CullFaceFront = 2;
const int CullFaceFrontBack = 3;

const int FrontFaceDirectionCW = 0;
const int FrontFaceDirectionCCW = 1;

// SHADOWING TYPES

const int BasicShadowMap = 0;
const int PCFShadowMap = 1;
const int PCFSoftShadowMap = 2;


// MATERIAL CONSTANTS

// side
const int FrontSide = 0;
const int BackSide = 1;
const int DoubleSide = 2;

const int NoShading = 0;
const int FlatShading = 1;
const int SmoothShading = 2;

const int NoColors = 0;
const int FaceColors = 1;
const int VertexColors = 2;

// blending modes

const int NoBlending = 0;
const int NormalBlending = 1;
const int AdditiveBlending = 2;
const int SubtractiveBlending = 3;
const int MultiplyBlending = 4;
const int CustomBlending = 5;

// custom blending equations
// (numbers start from 100 not to clash with other
//  mappings to OpenGL constants defined in Texture.js)

const int AddEquation = 100;
const int SubtractEquation = 101;
const int ReverseSubtractEquation = 102;

// custom blending destination factors

const int ZeroFactor = 200;
const int OneFactor = 201;
const int SrcColorFactor = 202;
const int OneMinusSrcColorFactor = 203;
const int SrcAlphaFactor = 204;
const int OneMinusSrcAlphaFactor = 205;
const int DstAlphaFactor = 206;
const int OneMinusDstAlphaFactor = 207;

// custom blending source factors

const int DstColorFactor = 208;
const int OneMinusDstColorFactor = 209;
const int SrcAlphaSaturateFactor = 210;

// from MeshBasic_material

// from Texture
int TextureCount = 0;

const int MultiplyOperation = 0;
const int MixOperation = 1;

// Wrapping modes
const int RepeatWrapping = 0;
const int ClampToEdgeWrapping = 1;
const int MirroredRepeatWrapping = 2;

// Filters
const int NearestFilter = 3;
const int NearestMipMapNearestFilter = 4;
const int NearestMipMapLinearFilter = 5;
const int LinearFilter = 6;
const int LinearMipMapNearestFilter = 7;
const int LinearMipMapLinearFilter = 8;

// Data Types
const int ByteType = 9;
const int UnsignedByteType = 10;
const int ShortType = 11;
const int UnsignedShortType = 12;
const int IntType = 13;
const int UnsignedIntType = 14;
const int FloatType = 15;

// Pixel types
const int UnsignedShort4444Type = 1016;
const int UnsignedShort5551Type = 1017;
const int UnsignedShort565Type = 1018;

// Pixel Formats
const int AlphaFormat = 16;
const int RGBFormat = 17;
const int RGBAFormat = 18;
const int LuminanceFormat = 19;
const int LuminanceAlphaFormat = 20;

// Compressed texture formats
const int RGB_S3TC_DXT1_Format = 2001;
const int RGBA_S3TC_DXT1_Format = 2002;
const int RGBA_S3TC_DXT3_Format = 2003;
const int RGBA_S3TC_DXT5_Format = 2004;
