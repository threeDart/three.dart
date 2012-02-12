/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/ 
 */

class Vertex 
{
  Vector3 _position;
  
  Vector3 get position() {  return _position;  }
  
  Vertex( [Vector3 position] ) {
    _position = (position != null) ? position : new Vector3();
  }
}
