library ThreeD;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:json';

import 'src/core/ThreeMath.dart' as ThreeMath;

// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
import 'extras/ImageUtils.dart' as ImageUtils;
import 'extras/SceneUtils.dart' as SceneUtils;
import 'extras/FontUtils.dart' as FontUtils;
import 'extras/GeometryUtils.dart' as GeometryUtils;
import 'extras/ShaderUtils.dart' as ShaderUtils;

import 'extras/core/CurveUtils.dart' as CurveUtils;
import 'extras/core/ShapeUtils.dart' as ShapeUtils;

part 'src/Three.dart';

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

part 'extras/objects/LensFlare.dart';
part 'extras/objects/ImmediateRenderObject.dart';

part 'extras/helpers/ArrowHelper.dart';
part 'extras/helpers/AxisHelper.dart';

part 'src/lights/AmbientLight.dart';
part 'src/lights/DirectionalLight.dart';
part 'src/lights/PointLight.dart';
part 'src/lights/SpotLight.dart';
part 'src/lights/Light.dart';

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
