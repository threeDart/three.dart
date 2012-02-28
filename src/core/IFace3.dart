interface IFace3 
{
  Vector3 get centroid();
  Vector3 get normal();
  
  List get vertexNormals();
  set vertexNormals( List value );
  
  List get vertexTangents();
  num get materialIndex();
  num get a();
  set a( num value );
  num get b();
  set b( num value );
  num get c();
  set c( num value );
}
