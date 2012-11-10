part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Frustum {
  List<Vector4> planes;

  //TODO: where/how should this be instantiated?

  static Vector3 ___v1;// = new Vector3();

  static Vector3 get __v1 {
    if (___v1 == null) {
      ___v1 = new Vector3();
    }
    return ___v1;
  }

  Frustum()
      : planes = [
                  new Vector4(),
                  new Vector4(),
                  new Vector4(),
                  new Vector4(),
                  new Vector4(),
                  new Vector4()
                  ];

  void setFromMatrix( Matrix4 m ) {

    Vector4 plane;

    var me = m.elements;
    var me0 = me[0], me1 = me[1], me2 = me[2], me3 = me[3];
    var me4 = me[4], me5 = me[5], me6 = me[6], me7 = me[7];
    var me8 = me[8], me9 = me[9], me10 = me[10], me11 = me[11];
    var me12 = me[12], me13 = me[13], me14 = me[14], me15 = me[15];

    planes[ 0 ].setValues( me3 - me0, me7 - me4, me11 - me8, me15 - me12 );
    planes[ 1 ].setValues( me3 + me0, me7 + me4, me11 + me8, me15 + me12 );
    planes[ 2 ].setValues( me3 + me1, me7 + me5, me11 + me9, me15 + me13 );
    planes[ 3 ].setValues( me3 - me1, me7 - me5, me11 - me9, me15 - me13 );
    planes[ 4 ].setValues( me3 - me2, me7 - me6, me11 - me10, me15 - me14 );
    planes[ 5 ].setValues( me3 + me2, me7 + me6, me11 + me10, me15 + me14 );

    for ( var i = 0; i < 6; i ++ ) {

      plane = planes[ i ];
      plane.divideScalar( Math.sqrt( plane.x * plane.x + plane.y * plane.y + plane.z * plane.z ) );

    }
  }

  bool contains( Object3D object ) {
    num distance = 0.0;

    Matrix4 matrix = object.matrixWorld;
    var me = matrix.elements;
    num radius = - (object as dynamic).geometry.boundingSphere.radius * matrix.getMaxScaleOnAxis();

    for ( int i = 0; i < 6; i ++ ) {
      distance = planes[ i ].x * me[12] + planes[ i ].y * me[13] + planes[ i ].z * me[14] + planes[ i ].w;
      if ( distance <= radius ) return false;
    }

    return true;
  }
}
