#library("ThreeD");

#import('dart:html');
#import('dart:math', prefix:'Math');

#import('src/core/ThreeMath.dart', prefix:'ThreeMath');

// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
#import('extras/ImageUtils.dart', prefix:'ImageUtils');
#import('extras/SceneUtils.dart', prefix:'SceneUtils');
#import('extras/FontUtils.dart', prefix:'FontUtils');
#import('extras/GeometryUtils.dart', prefix:'GeometryUtils');

#import('extras/core/CurveUtils.dart', prefix:'CurveUtils');
#import('extras/core/ShapeUtils.dart', prefix:'ShapeUtils');

#source('src/Three.dart');

#source('src/cameras/Camera.dart');
#source('src/cameras/PerspectiveCamera.dart');
#source('src/cameras/OrthographicCamera.dart');

#source('src/core/Vector3.dart');
#source('src/core/Matrix3.dart');
#source('src/core/Matrix4.dart');
#source('src/core/Quaternion.dart');
#source('src/core/Vector4.dart');
#source('src/core/Object3D.dart');
#source('src/core/Color.dart');
#source('src/core/Face3.dart');
#source('src/core/Face4.dart');
#source('src/core/Frustum.dart');
#source('src/core/Geometry.dart');
#source('src/core/Vertex.dart');
#source('src/core/Projector.dart');
#source('src/core/Ray.dart');
#source('src/core/Vector2.dart');
#source('src/core/IVector3.dart');
#source('src/core/IVector2.dart');
#source('src/core/IVector4.dart');
#source('src/core/UV.dart');
#source('src/core/IFace3.dart');
#source('src/core/IFace4.dart');
#source('src/core/Rectangle.dart');
#source('src/core/BufferGeometry.dart');
#source('src/core/EventEmitter.dart');

#source('src/loaders/ImageLoader.dart');

#source('extras/geometries/CircleGeometry.dart');
#source('extras/geometries/ConvexGeometry.dart');
#source('extras/geometries/CubeGeometry.dart');
#source('extras/geometries/CylinderGeometry.dart');
#source('extras/geometries/ExtrudeGeometry.dart');
#source('extras/geometries/IcosahedronGeometry.dart');
#source('extras/geometries/LatheGeometry.dart');
#source('extras/geometries/OctahedronGeometry.dart');
#source('extras/geometries/ParametricGeometry.dart');
#source('extras/geometries/PlaneGeometry.dart');
#source('extras/geometries/PolyhedronGeometry.dart');
#source('extras/geometries/SphereGeometry.dart');
#source('extras/geometries/TetrahedronGeometry.dart');
#source('extras/geometries/TextGeometry.dart');
#source('extras/geometries/TorusGeometry.dart');
#source('extras/geometries/TorusKnotGeometry.dart');
#source('extras/geometries/TubeGeometry.dart');

#source('extras/core/Curve.dart');
#source('extras/core/CurvePath.dart');
#source('extras/core/Path.dart');
#source('extras/core/Shape.dart');
#source('extras/core/LineCurve.dart');
#source('extras/core/QuadraticBezierCurve.dart');
#source('extras/core/CubicBezierCurve.dart');
#source('extras/core/SplineCurve.dart');
#source('extras/core/ArcCurve.dart');
#source('extras/core/EllipseCurve.dart');

#source('extras/core/LineCurve3.dart');
#source('extras/core/QuadraticBezierCurve3.dart');
#source('extras/core/CubicBezierCurve3.dart');
#source('extras/core/SplineCurve3.dart');
#source('extras/core/ClosedSplineCurve3.dart');

#source('extras/objects/LensFlare.dart');
#source('extras/objects/ImmediateRenderObject.dart');

#source('extras/helpers/ArrowHelper.dart');
#source('extras/helpers/AxisHelper.dart');

#source('src/lights/AmbientLight.dart');
#source('src/lights/DirectionalLight.dart');
#source('src/lights/PointLight.dart');
#source('src/lights/SpotLight.dart');
#source('src/lights/Light.dart');

#source('src/materials/Material.dart');
#source('src/materials/MeshBasicMaterial.dart');
#source('src/materials/MeshFaceMaterial.dart');
#source('src/materials/ParticleBasicMaterial.dart');
#source('src/materials/ParticleCanvasMaterial.dart');
#source('src/materials/LineBasicMaterial.dart');
#source('src/materials/MeshLambertMaterial.dart');
#source('src/materials/MeshDepthMaterial.dart');
#source('src/materials/MeshNormalMaterial.dart');
#source('src/materials/ITextureMapMaterial.dart');
#source('src/materials/IParticleMaterial.dart');
#source('src/materials/IMaterial.dart');
#source('src/materials/MeshPhongMaterial.dart');
#source('src/materials/ShaderMaterial.dart');

#source('src/objects/Bone.dart');
#source('src/objects/Mesh.dart');
#source('src/objects/Line.dart');
#source('src/objects/Particle.dart');
#source('src/objects/ParticleSystem.dart');
#source('src/objects/Sprite.dart');
#source('src/objects/Ribbon.dart');
#source('src/objects/SkinnedMesh.dart');
#source('src/objects/LOD.dart');
#source('src/objects/MorphAnimMesh.dart');

#source('src/renderers/renderables/RenderableObject.dart');
#source('src/renderers/renderables/RenderableVertex.dart');
#source('src/renderers/renderables/RenderableFace3.dart');
#source('src/renderers/renderables/RenderableFace4.dart');
#source('src/renderers/renderables/RenderableLine.dart');
#source('src/renderers/renderables/RenderableParticle.dart');

#source('src/renderers/Renderer.dart');
#source('src/renderers/WebGLRenderer.dart');
#source('src/renderers/WebGLRenderTarget.dart');
#source('src/renderers/WebGLRenderTargetCube.dart');
#source('src/renderers/WebGLShaders.dart');
#source('src/renderers/CanvasRenderer.dart');

#source('src/renderers/renderables/IRenderableObj.dart');
#source('src/renderers/renderables/IRenderableFace3.dart');
#source('src/renderers/renderables/IRenderableFace4.dart');

#source('src/scenes/Scene.dart');
#source('src/scenes/Fog.dart');
#source('src/scenes/FogExp2.dart');

#source('src/textures/Texture.dart');
#source('src/textures/DataTexture.dart');

#source('src/UVMapping.dart');
#source('src/materials/Mappings.dart');
