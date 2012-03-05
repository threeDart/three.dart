/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author adam smith / http://financecoding.wordpress.com/
 */

class Line extends Object3D {

  Geometry _geometry;
  Material _material;
  int _type = 0;
  
  Geometry get geometry() {  return _geometry;  }
  IMaterial get material() {  return _material;  }
  int get type() { return _type; }
  
  Line(Geometry geometry, LineBasicMaterial material, [int ltype=0]) : super() {
    _geometry = geometry;
    _material = material;
    
    this._type = ltype;
    
    if ( _geometry != null ) 
    {
      // calc bound radius
      if( _geometry.boundingSphere == null ) {
        _geometry.computeBoundingSphere();
      }
    }
  }
}
