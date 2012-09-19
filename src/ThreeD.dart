#library("ThreeD");

#import('dart:html');
#import('dart:math', prefix:'Math');

#import('core/ThreeMath.dart', prefix:'ThreeMath');

// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
#import('extras/ImageUtils.dart', prefix:'ImageUtils');
#import('extras/SceneUtils.dart', prefix:'SceneUtils');
#import('extras/FontUtils.dart', prefix:'FontUtils');
#import('extras/GeometryUtils.dart', prefix:'GeometryUtils');

#import('extras/core/CurveUtils.dart', prefix:'CurveUtils');
#import('extras/core/ShapeUtils.dart', prefix:'ShapeUtils');

#source('Three.dart');

#source('cameras/Camera.dart');
#source('cameras/PerspectiveCamera.dart');
#source('cameras/OrthographicCamera.dart');

#source('core/Vector3.dart');
#source('core/Matrix3.dart');
#source('core/Matrix4.dart');
#source('core/Quaternion.dart');
#source('core/Vector4.dart');
#source('core/Object3D.dart');
#source('core/Color.dart');
#source('core/Face3.dart');
#source('core/Face4.dart');
#source('core/Frustum.dart');
#source('core/Geometry.dart');
#source('core/Vertex.dart');
#source('core/Projector.dart');
#source('core/Ray.dart');
#source('core/Vector2.dart');
#source('core/IVector3.dart');
#source('core/IVector2.dart');
#source('core/IVector4.dart');
#source('core/UV.dart');
#source('core/IFace3.dart');
#source('core/IFace4.dart');
#source('core/Rectangle.dart');
#source('core/BufferGeometry.dart');
#source('core/EventEmitter.dart');

#source('loaders/ImageLoader.dart');

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

#source('lights/AmbientLight.dart');
#source('lights/DirectionalLight.dart');
#source('lights/PointLight.dart');
#source('lights/SpotLight.dart');
#source('lights/Light.dart');

#source('materials/Material.dart');
#source('materials/MeshBasicMaterial.dart');
#source('materials/MeshFaceMaterial.dart');
#source('materials/ParticleBasicMaterial.dart');
#source('materials/ParticleCanvasMaterial.dart');
#source('materials/LineBasicMaterial.dart');
#source('materials/MeshLambertMaterial.dart');
#source('materials/MeshDepthMaterial.dart');
#source('materials/MeshNormalMaterial.dart');
#source('materials/ITextureMapMaterial.dart');
#source('materials/IParticleMaterial.dart');
#source('materials/IMaterial.dart');
#source('materials/MeshPhongMaterial.dart');
#source('materials/ShaderMaterial.dart');

#source('objects/Bone.dart');
#source('objects/Mesh.dart');
#source('objects/Line.dart');
#source('objects/Particle.dart');
#source('objects/ParticleSystem.dart');
#source('objects/Sprite.dart');
#source('objects/Ribbon.dart');
#source('objects/SkinnedMesh.dart');
#source('objects/LOD.dart');
#source('objects/MorphAnimMesh.dart');

#source('renderers/renderables/RenderableObject.dart');
#source('renderers/renderables/RenderableVertex.dart');
#source('renderers/renderables/RenderableFace3.dart');
#source('renderers/renderables/RenderableFace4.dart');
#source('renderers/renderables/RenderableLine.dart');
#source('renderers/renderables/RenderableParticle.dart');

#source('renderers/Renderer.dart');
#source('renderers/WebGLRenderer.dart');
#source('renderers/WebGLRenderTarget.dart');
#source('renderers/WebGLRenderTargetCube.dart');
#source('renderers/WebGLShaders.dart');
#source('renderers/CanvasRenderer.dart');

#source('renderers/renderables/IRenderableObj.dart');
#source('renderers/renderables/IRenderableFace3.dart');
#source('renderers/renderables/IRenderableFace4.dart');

#source('scenes/Scene.dart');
#source('scenes/Fog.dart');
#source('scenes/FogExp2.dart');

#source('textures/Texture.dart');
#source('textures/DataTexture.dart');

#source('UVMapping.dart');
#source('materials/Mappings.dart');
