part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Camera extends Object3D {
  Matrix4 matrixWorldInverse;
  Matrix4 projectionMatrix;
  Matrix4 projectionMatrixInverse;

  num near;
  num far;

  Camera(this.near, this.far)
    : matrixWorldInverse = new Matrix4(),
      projectionMatrix = new Matrix4(),
      projectionMatrixInverse = new Matrix4(),
      super();

  void lookAt( vector ) {
    // TODO: Add hierarchy support.

    matrix.lookAt( position, vector, up );

    if ( rotationAutoUpdate ) {
      rotation.setEulerFromRotationMatrix( matrix, eulerOrder );
    }
  }
}
