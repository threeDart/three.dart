#library("ThreeD");

#import('dart:html');
#import('dart:math', prefix:'Math');

//#import('src/core/ThreeMath.dart', prefix:'ThreeMath');
//
//// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
//#import('src/extras/ImageUtils.dart', prefix:'ImageUtils');
//#import('src/extras/SceneUtils.dart', prefix:'SceneUtils');
//#import('src/extras/FontUtils.dart', prefix:'FontUtils');
//#import('src/extras/GeometryUtils.dart', prefix:'GeometryUtils');
//
//#import('src/extras/core/CurveUtils.dart', prefix:'CurveUtils');
//#import('src/extras/core/ShapeUtils.dart', prefix:'ShapeUtils');

#import('ThreeMath.dart', prefix:'ThreeMath');

// TODO - Use M1 Re-export ( see: http://code.google.com/p/dart/issues/detail?id=760)
#import('ImageUtils.dart', prefix:'ImageUtils');
#import('SceneUtils.dart', prefix:'SceneUtils');
#import('FontUtils.dart', prefix:'FontUtils');
#import('GeometryUtils.dart', prefix:'GeometryUtils');

#import('CurveUtils.dart', prefix:'CurveUtils');
#import('ShapeUtils.dart', prefix:'ShapeUtils');


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

#source('src/extras/geometries/CircleGeometry.dart');
#source('src/extras/geometries/ConvexGeometry.dart');
#source('src/extras/geometries/CubeGeometry.dart');
#source('src/extras/geometries/CylinderGeometry.dart');
#source('src/extras/geometries/ExtrudeGeometry.dart');
#source('src/extras/geometries/IcosahedronGeometry.dart');
#source('src/extras/geometries/LatheGeometry.dart');
#source('src/extras/geometries/OctahedronGeometry.dart');
#source('src/extras/geometries/ParametricGeometry.dart');
#source('src/extras/geometries/PlaneGeometry.dart');
#source('src/extras/geometries/PolyhedronGeometry.dart');
#source('src/extras/geometries/SphereGeometry.dart');
#source('src/extras/geometries/TetrahedronGeometry.dart');
#source('src/extras/geometries/TextGeometry.dart');
#source('src/extras/geometries/TorusGeometry.dart');
#source('src/extras/geometries/TorusKnotGeometry.dart');
#source('src/extras/geometries/TubeGeometry.dart');

#source('src/extras/core/Curve.dart');
#source('src/extras/core/CurvePath.dart');
#source('src/extras/core/Path.dart');
#source('src/extras/core/Shape.dart');
#source('src/extras/core/LineCurve.dart');
#source('src/extras/core/QuadraticBezierCurve.dart');
#source('src/extras/core/CubicBezierCurve.dart');
#source('src/extras/core/SplineCurve.dart');
#source('src/extras/core/ArcCurve.dart');
#source('src/extras/core/EllipseCurve.dart');

#source('src/extras/core/LineCurve3.dart');
#source('src/extras/core/QuadraticBezierCurve3.dart');
#source('src/extras/core/CubicBezierCurve3.dart');
#source('src/extras/core/SplineCurve3.dart');
#source('src/extras/core/ClosedSplineCurve3.dart');

#source('src/extras/objects/LensFlare.dart');
#source('src/extras/objects/ImmediateRenderObject.dart');

#source('src/extras/helpers/ArrowHelper.dart');
#source('src/extras/helpers/AxisHelper.dart');

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
