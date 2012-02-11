/**
 * @author mr.doob / http://mrdoob.com/
 * @author mikael emtinger / http://gomo.se
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Camera extends Object3D
{
  Matrix4 matrixWorldInverse;
  Matrix4 projectionMatrix;
  Matrix4 projectionMatrixInverse;
  
  Camera() 
  {
//    if ( arguments.length ) 
//    {
       //TODO: figure out what's supposed to be happening here.. Quirk of JS inheritance?
//      console.warn( 'DEPRECATED: Camera() is now PerspectiveCamera() or OrthographicCamera().' );
//      return new PerspectiveCamera( arguments[ 0 ], arguments[ 1 ], arguments[ 2 ], arguments[ 3 ] );
//    }

//    super();
//    THREE.Object3D.call( this );

    matrixWorldInverse = new Matrix4();

    projectionMatrix = new Matrix4();
    projectionMatrixInverse = new Matrix4();
  }

  void lookAt( vector ) 
  {
    // TODO: Add hierarchy support.

    matrix.lookAt( position, vector, up );

    if ( rotationAutoUpdate ) {
      rotation.setRotationFromMatrix( matrix );
    }
  }
}
