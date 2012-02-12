/** 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Matrix3 
{
  List _m;
  
  get m() {  return _m;  }
  
  Matrix3()
  {
    _m = [];
  }
  
  Matrix3 transpose() 
  {
    List tmp, m = _m;

    tmp = m[1]; m[1] = m[3]; m[3] = tmp;
    tmp = m[2]; m[2] = m[6]; m[6] = tmp;
    tmp = m[5]; m[5] = m[7]; m[7] = tmp;

    return this;
  }
  
  Matrix3 transposeIntoArray( List r ) 
  {
    var m = _m;

    r[ 0 ] = m[ 0 ];
    r[ 1 ] = m[ 3 ];
    r[ 2 ] = m[ 6 ];
    r[ 3 ] = m[ 1 ];
    r[ 4 ] = m[ 4 ];
    r[ 5 ] = m[ 7 ];
    r[ 6 ] = m[ 2 ];
    r[ 7 ] = m[ 5 ];
    r[ 8 ] = m[ 8 ];

    return this;
  } 
}