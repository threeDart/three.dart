library three;

import 'dart:html';
import 'dart:web_gl' as gl;
import 'dart:math' as Math;
import 'dart:json' as JSON;

import 'src/core/ThreeMath.dart' as ThreeMath;
export 'src/core/ThreeMath.dart';

// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
import 'extras/image_utils.dart' as ImageUtils;
import 'extras/scene_utils.dart' as SceneUtils;
import 'extras/font_utils.dart' as FontUtils;
import 'extras/geometry_utils.dart' as GeometryUtils;
import 'extras/shader_utils.dart' as ShaderUtils;

import 'extras/core/curve_utils.dart' as CurveUtils;
import 'extras/core/shape_utils.dart' as ShapeUtils;

part 'src/cameras/Camera.dart';
part 'src/cameras/PerspectiveCamera.dart';
part 'src/cameras/OrthographicCamera.dart';

part 'src/core/Vector3.dart';
part 'src/core/Matrix3.dart';
part 'src/core/Matrix4.dart';
part 'src/core/Quaternion.dart';
part 'src/core/Vector4.dart';
part 'src/core/Object3D.dart';
part 'src/core/Color.dart';
part 'src/core/Face3.dart';
part 'src/core/Face4.dart';
part 'src/core/Frustum.dart';
part 'src/core/MorphColors.dart';
part 'src/core/MorphTarget.dart';
part 'src/core/Geometry.dart';
part 'src/core/Vertex.dart';
part 'src/core/Projector.dart';
part 'src/core/Ray.dart';
part 'src/core/Vector2.dart';
part 'src/core/IVector3.dart';
part 'src/core/IVector2.dart';
part 'src/core/IVector4.dart';
part 'src/core/UV.dart';
part 'src/core/IFace3.dart';
part 'src/core/IFace4.dart';
part 'src/core/Rectangle.dart';
part 'src/core/BufferGeometry.dart';
part 'src/core/EventEmitter.dart';

part 'src/loaders/Loader.dart';
part 'src/loaders/JSONLoader.dart';
part 'src/loaders/ImageLoader.dart';

part 'extras/geometries/CircleGeometry.dart';
part 'extras/geometries/ConvexGeometry.dart';
part 'extras/geometries/CubeGeometry.dart';
part 'extras/geometries/CylinderGeometry.dart';
part 'extras/geometries/ExtrudeGeometry.dart';
part 'extras/geometries/IcosahedronGeometry.dart';
part 'extras/geometries/LatheGeometry.dart';
part 'extras/geometries/OctahedronGeometry.dart';
part 'extras/geometries/ParametricGeometry.dart';
part 'extras/geometries/PlaneGeometry.dart';
part 'extras/geometries/PolyhedronGeometry.dart';
part 'extras/geometries/SphereGeometry.dart';
part 'extras/geometries/TetrahedronGeometry.dart';
part 'extras/geometries/TextGeometry.dart';
part 'extras/geometries/TorusGeometry.dart';
part 'extras/geometries/TorusKnotGeometry.dart';
part 'extras/geometries/TubeGeometry.dart';

part 'extras/core/Curve.dart';
part 'extras/core/CurvePath.dart';
part 'extras/core/Path.dart';
part 'extras/core/Shape.dart';
part 'extras/core/LineCurve.dart';
part 'extras/core/QuadraticBezierCurve.dart';
part 'extras/core/CubicBezierCurve.dart';
part 'extras/core/SplineCurve.dart';
part 'extras/core/ArcCurve.dart';
part 'extras/core/EllipseCurve.dart';

part 'extras/core/LineCurve3.dart';
part 'extras/core/QuadraticBezierCurve3.dart';
part 'extras/core/CubicBezierCurve3.dart';
part 'extras/core/SplineCurve3.dart';
part 'extras/core/ClosedSplineCurve3.dart';

part 'extras/core/Gyroscope.dart';

part 'extras/objects/LensFlare.dart';
part 'extras/objects/ImmediateRenderObject.dart';

part 'extras/helpers/ArrowHelper.dart';
part 'extras/helpers/AxisHelper.dart';
part 'extras/helpers/CameraHelper.dart';

part 'extras/renderers/plugins/ShadowMapPlugin.dart';

part 'src/lights/AmbientLight.dart';
part 'src/lights/DirectionalLight.dart';
part 'src/lights/PointLight.dart';
part 'src/lights/SpotLight.dart';
part 'src/lights/Light.dart';
part 'src/lights/ShadowCaster.dart';

part 'src/materials/Material.dart';
part 'src/materials/MeshBasicMaterial.dart';
part 'src/materials/MeshFaceMaterial.dart';
part 'src/materials/ParticleBasicMaterial.dart';
part 'src/materials/ParticleCanvasMaterial.dart';
part 'src/materials/LineBasicMaterial.dart';
part 'src/materials/MeshLambertMaterial.dart';
part 'src/materials/MeshDepthMaterial.dart';
part 'src/materials/MeshNormalMaterial.dart';
part 'src/materials/ITextureMapMaterial.dart';
part 'src/materials/IParticleMaterial.dart';
part 'src/materials/IMaterial.dart';
part 'src/materials/MeshPhongMaterial.dart';
part 'src/materials/ShaderMaterial.dart';

part 'src/objects/Bone.dart';
part 'src/objects/Mesh.dart';
part 'src/objects/Line.dart';
part 'src/objects/Particle.dart';
part 'src/objects/ParticleSystem.dart';
part 'src/objects/Sprite.dart';
part 'src/objects/Ribbon.dart';
part 'src/objects/SkinnedMesh.dart';
part 'src/objects/LOD.dart';
part 'src/objects/MorphAnimMesh.dart';

part 'src/renderers/renderables/RenderableObject.dart';
part 'src/renderers/renderables/RenderableVertex.dart';
part 'src/renderers/renderables/RenderableFace3.dart';
part 'src/renderers/renderables/RenderableFace4.dart';
part 'src/renderers/renderables/RenderableLine.dart';
part 'src/renderers/renderables/RenderableParticle.dart';

part 'src/renderers/Renderer.dart';
part 'src/renderers/WebGLRenderer.dart';
part 'src/renderers/WebGLRenderTarget.dart';
part 'src/renderers/WebGLRenderTargetCube.dart';
part 'src/renderers/WebGLShaders.dart';
part 'src/renderers/CanvasRenderer.dart';
part 'src/renderers/CSS3DRenderer.dart';

part 'src/renderers/renderables/IRenderableObj.dart';
part 'src/renderers/renderables/IRenderableFace3.dart';
part 'src/renderers/renderables/IRenderableFace4.dart';

part 'src/scenes/Scene.dart';
part 'src/scenes/Fog.dart';
part 'src/scenes/FogLinear.dart';
part 'src/scenes/FogExp2.dart';

part 'src/textures/Texture.dart';
part 'src/textures/DataTexture.dart';
part 'src/textures/CompressedTexture.dart';

part 'src/UVMapping.dart';
part 'src/materials/Mappings.dart';

// from Geometry
int GeometryCount = 0;

// from Object3D
int Object3DCount = 0;

// from Material
int MaterialCount = 0;

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

// from MeshBasicMaterial

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
