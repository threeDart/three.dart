/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Face3 implements IFace3
{
  num _a;
  num _b;
  num _c;
  
  Vector3 _normal;
  List _vertexNormals, _vertexColors, _vertexTangents;
  Color _color;
  int _materialIndex;
  Vector3 _centroid;
  
  Vector3 get centroid() {  return _centroid;  }
  Vector3 get normal() {  return _normal;  }
  List get vertexNormals() {  return _vertexNormals;  }
  List get vertexTangents() {  return _vertexTangents;  }
  int get materialIndex() {  return _materialIndex;  }
  num get a() {  return _a;  }
  num get b() {  return _b;  }
  num get c() {  return _c;  }
  
  //TODO: "instanceof" replaced by "is"?
  Face3( num a, num b, num c,  Dynamic normal, Dynamic color, materialIndex ) 
  {
    _a = a;
    _b = b;
    _c = c;

    _normal = normal is Vector3 ? normal : new Vector3();
    _vertexNormals = normal is List ? normal : [ ];

    _color = color is Color ? color : new Color();
    _vertexColors = color is List ? color : [];

    _vertexTangents = [];

    _materialIndex = materialIndex;

    _centroid = new Vector3();
  }
}
