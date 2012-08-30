#library("ThreeD");

#import('dart:html');
#import('dart:math', prefix:'Math');

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
#source('core/ThreeMath.dart');
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

#source('extras/ImageUtils.dart');
#source('extras/geometries/CubeGeometry.dart');
#source('extras/geometries/PlaneGeometry.dart');

#source('extras/objects/LensFlare.dart');
#source('extras/objects/ImmediateRenderObject.dart');

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
