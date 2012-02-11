interface IRenderableFace3 extends IRenderableObj
{
  RenderableVertex get v1();
  RenderableVertex get v2();
  RenderableVertex get v3();
  
  Vector3 get normalWorld();
  Vector3 get centroidWorld();
  Vector3 get centroidScreen();
  List get vertexNormalsWorld();
  List get uvs();
  Material get material();
  Material get faceMaterial();
  num get z();
}
