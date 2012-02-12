/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */
//TODO: not extending a Face3 class for now in case we run into typing problems (i.e. "if (obj is Face3)" logic)
class Face4 implements IFace4
{
  num _a;
  num _b;
  num _c;
  num _d;
  
  Vector3 _normal;
  List _vertexNormals, _vertexColors, _vertexTangents;
  Color _color;
  int _materialIndex;
  Vector3 _centroid;
  
  Vector3 get centroid() {  return _centroid;  }
  Vector3 get normal() {  return _normal;  }
  List get vertexNormals() {  return _vertexNormals;  }
  List get vertexTangents() {  return _vertexTangents;  }
  
  set materialIndex( int value ) {  _materialIndex = value;  }
  int get materialIndex() {  return _materialIndex;  }
  
  num get a() {  return _a;  }
  set a( num value ) {  _a = value;  }
  num get b() {  return _b;  }
  set b( num value ) {  _b = value;  }
  num get c() {  return _c;  }
  set c( num value ) {  _c = value;  }
  num get d() {  return _d;  }
  set d( num value ) {  _d = value;  }
  
  Face4( num a, num b, num c, num d, [Dynamic normal, Dynamic color, int materialIndex] ) 
  {
    _a = a;
    _b = b;
    _c = c;
    _d = d;

    _normal = normal is Vector3 ? normal : new Vector3();
    _vertexNormals = normal is List ? normal : [ ];

    _color = color is Color ? color : new Color();
    _vertexColors = color is List ? color : [];

    _vertexTangents = [];

    _materialIndex = materialIndex;

    _centroid = new Vector3();
  }

}
