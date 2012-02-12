/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/ 
 */

class RenderableFace4 implements IRenderableFace4
{
  RenderableVertex _v1;
  RenderableVertex _v2;
  RenderableVertex _v3;
  RenderableVertex _v4;
  
  Vector3 _centroidWorld, _centroidScreen, _normalWorld;
  
  List _vertexNormalsWorld; 
  List<List> _uvs;
  
  Material _material, _faceMaterial;
  
  num _z;
  
  RenderableVertex get v1() {  return _v1;  }
  RenderableVertex get v2() {  return _v2;  }
  RenderableVertex get v3() {  return _v3;  }
  RenderableVertex get v4() {  return _v4;  }
  
  Vector3 get normalWorld() {  return _normalWorld;  }
  Vector3 get centroidWorld() {  return _centroidWorld;  }
  Vector3 get centroidScreen() {  return _centroidScreen;  }
  List get vertexNormalsWorld() {  return _vertexNormalsWorld;  }
  List<List> get uvs() {  return _uvs;  }
  
  Material get material() {  return _material;  }
  set material( Material value ) {  _material = value;  }
  
  Material get faceMaterial() {  return _faceMaterial;  }
  set faceMaterial( Material value) {  _faceMaterial = value;  }
  
  num get z() {  return _z;  }
  set z( num value ) {  _z = value;  }

  RenderableFace4() 
  {
    _v1 = new RenderableVertex();
    _v2 = new RenderableVertex();
    _v3 = new RenderableVertex();
    _v4 = new RenderableVertex();

    _centroidWorld = new Vector3();
    _centroidScreen = new Vector3();

    _normalWorld = new Vector3();
    _vertexNormalsWorld = [ new Vector3(), new Vector3(), new Vector3(), new Vector3() ];

    _material = null;
    _faceMaterial = null;
    _uvs = [];//[]];
    _uvs.add(new List());

    _z = null;
  }
}
