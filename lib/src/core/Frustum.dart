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

  static Vector3 ___v1;// = new Vector3.zero();

  static Vector3 get __v1 {
    if (___v1 == null) {
      ___v1 = new Vector3.zero();
    }
    return ___v1;
  }

  Frustum()
      : planes = [
                  new Vector4(0.0, 0.0, 0.0, 1.0),
                  new Vector4(0.0, 0.0, 0.0, 1.0),
                  new Vector4(0.0, 0.0, 0.0, 1.0),
                  new Vector4(0.0, 0.0, 0.0, 1.0),
                  new Vector4(0.0, 0.0, 0.0, 1.0),
                  new Vector4(0.0, 0.0, 0.0, 1.0)
                  ];

  void setFromMatrix( Matrix4 m ) {

    var me0 = m[0], me1 = m[1], me2 = m[2], me3 = m[3];
    var me4 = m[4], me5 = m[5], me6 = m[6], me7 = m[7];
    var me8 = m[8], me9 = m[9], me10 = m[10], me11 = m[11];
    var me12 = m[12], me13 = m[13], me14 = m[14], me15 = m[15];

    planes[ 0 ].setValues( me3 - me0, me7 - me4, me11 - me8, me15 - me12 );
    planes[ 1 ].setValues( me3 + me0, me7 + me4, me11 + me8, me15 + me12 );
    planes[ 2 ].setValues( me3 + me1, me7 + me5, me11 + me9, me15 + me13 );
    planes[ 3 ].setValues( me3 - me1, me7 - me5, me11 - me9, me15 - me13 );
    planes[ 4 ].setValues( me3 - me2, me7 - me6, me11 - me10, me15 - me14 );
    planes[ 5 ].setValues( me3 + me2, me7 + me6, me11 + me10, me15 + me14 );

    for ( var i = 0; i < 6; i ++ ) {

      Vector4 plane = planes[ i ];
      double divisor = Math.sqrt( plane.x * plane.x + plane.y * plane.y + plane.z * plane.z );
      if (divisor > 0.0) {
        plane.scale( 1.0 / divisor);
      }

    }
  }

  bool contains( Object3D object ) {
    num distance = 0.0;

    Matrix4 m = object.matrixWorld;
    num radius = - (object as dynamic).geometry.boundingSphere.radius * calcMaxScaleOnAxis(m);

    for ( int i = 0; i < 6; i ++ ) {
      distance = planes[ i ].x * m[12] + planes[ i ].y * m[13] + planes[ i ].z * m[14] + planes[ i ].w;
      if ( distance <= radius ) return false;
    }

    return true;
  }
}
