part of three;
/**
 * @author alteredq / http://alteredqualia.com/
 */

class Gyroscope extends Object3D {
  Vector3 translationWorld, translationObject;
  Quaternion rotationWorld, rotationObject;
  Vector3 scaleWorld, scaleObject;

  Gyroscope() :
    translationWorld = new Vector3(),
    translationObject = new Vector3(),
    rotationWorld = new Quaternion(),
    rotationObject = new Quaternion(),
    scaleWorld = new Vector3(),
    scaleObject = new Vector3(),
    super();

  updateMatrixWorld( {bool force: false} ) {

    if (matrixAutoUpdate) {
      updateMatrix();
    }

    // update matrixWorld

    if ( matrixWorldNeedsUpdate || force ) {

      if ( parent != null ) {

        matrixWorld.multiply( parent.matrixWorld, matrix );

        matrixWorld.decompose( translationWorld, rotationWorld, scaleWorld );
        matrix.decompose( translationObject, rotationObject, scaleObject );

        matrixWorld.compose( translationWorld, rotationObject, scaleWorld );


      } else {

        matrixWorld.copy( matrix );

      }


      matrixWorldNeedsUpdate = false;

      force = true;

    }

    // update children
    var l = this.children.length;
    for ( var i = 0; i < l; i ++ ) {

      children[ i ].updateMatrixWorld( force );

    }

  }
}


