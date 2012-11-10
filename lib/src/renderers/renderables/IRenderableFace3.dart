part of three;

abstract class IRenderableFace3 extends IRenderableObj {
  RenderableVertex v1;
  RenderableVertex v2;
  RenderableVertex v3;

  Vector3 centroidWorld, centroidScreen, normalWorld;

  List vertexNormalsWorld, uvs;

  Material material;
  Material faceMaterial;

  num z;
}
