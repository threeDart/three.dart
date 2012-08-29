/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Frustum 
{
  List _planes;
  
  //TODO: where/how should this be instantiated?
  static Vector3 __v1;// = new Vector3();
  
  Frustum()
  {
    //TODO: not sure if this is the best place for this.
    if (__v1 == null) {
      __v1 = new Vector3();
    }
    
    _planes = [
      new Vector4(),
      new Vector4(),
      new Vector4(),
      new Vector4(),
      new Vector4(),
      new Vector4()
    ];
  }

  void setFromMatrix( Matrix4 m ) 
  {
    int i;
    Vector4 plane;
    List planes = _planes;

    plane = planes[0];
    plane.setValues( m.n41 - m.n11, m.n42 - m.n12, m.n43 - m.n13, m.n44 - m.n14 );
    
    plane = planes[1];
    plane.setValues( m.n41 + m.n11, m.n42 + m.n12, m.n43 + m.n13, m.n44 + m.n14 );
    
    plane = planes[2];
    plane.setValues( m.n41 + m.n21, m.n42 + m.n22, m.n43 + m.n23, m.n44 + m.n24 );
    
    plane = planes[3];
    plane.setValues( m.n41 - m.n21, m.n42 - m.n22, m.n43 - m.n23, m.n44 - m.n24 );
    
    plane = planes[4];
    plane.setValues( m.n41 - m.n31, m.n42 - m.n32, m.n43 - m.n33, m.n44 - m.n34 );
    
    plane = planes[5];
    plane.setValues( m.n41 + m.n31, m.n42 + m.n32, m.n43 + m.n33, m.n44 + m.n34 );

    for ( i = 0; i < 6; i ++ ) 
    {
      plane = planes[ i ];
      plane.divideScalar( Math.sqrt( plane.x * plane.x + plane.y * plane.y + plane.z * plane.z ) );
    }
  }
  
  // TODO: removed type annotation for now, mesh is no the only class that could be passed.
  // If we type annotate it as a Mesh, then when something like object.geometry gets called
  // the JS or Dart code will barf. Proper class and interface hierarchy should fix this issue. 
  
  bool contains( /*Mesh*/ object )
  {
    num distance;
    List planes = _planes;
    Matrix4 matrix = object.matrixWorld;
  
    Vector3 scale = __v1.setValues( matrix.getColumnX().length(), matrix.getColumnY().length(), matrix.getColumnZ().length() );
    num radius = - object.geometry.boundingSphere.radius * Math.max( scale.x, Math.max( scale.y, scale.z ) );
   
    for ( int i = 0; i < 6; i ++ ) 
    {
      distance = planes[ i ].x * matrix.n14 + planes[ i ].y * matrix.n24 + planes[ i ].z * matrix.n34 + planes[ i ].w;
      if ( distance <= radius ) return false;
    }

    return true;
  }
}
