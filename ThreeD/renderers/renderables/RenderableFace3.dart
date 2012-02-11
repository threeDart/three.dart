/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableFace3 implements IRenderableFace3
{
  RenderableVertex _v1;
  RenderableVertex _v2;
  RenderableVertex _v3;
  
  Vector3 _centroidWorld, _centroidScreen, _normalWorld;
  
  List _vertexNormalsWorld, _uvs;
  
  Material _material, _faceMaterial;
  
  num _z;
  
  RenderableVertex get v1() {  return _v1;  }
  RenderableVertex get v2() {  return _v2;  }
  RenderableVertex get v3() {  return _v3;  }
  
  Vector3 get normalWorld() {  return _normalWorld;  }
  Vector3 get centroidWorld() {  return _centroidWorld;  }
  Vector3 get centroidScreen() {  return _centroidScreen;  }
  List get vertexNormalsWorld() {  return _vertexNormalsWorld;  }
  List get uvs() {  return _uvs;  }
  Material get material() {  return _material;  }
  Material get faceMaterial() {  return _faceMaterial;  }
  num get z() {  return _z;  }
  
  RenderableFace3() 
  {
    _v1 = new RenderableVertex();
    _v2 = new RenderableVertex();
    _v3 = new RenderableVertex();

    _centroidWorld = new Vector3();
    _centroidScreen = new Vector3();

    _normalWorld = new Vector3();
    _vertexNormalsWorld = [ new Vector3(), new Vector3(), new Vector3() ];

    _material = null;
    _faceMaterial = null;
    _uvs = [[]];

    _z = null;
  }
}
