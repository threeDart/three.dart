part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Scene extends Object3D {
  Fog fog;
  Material overrideMaterial;
  //bool matrixAutoUpdate;
  List<Object3D> objects;
  List<Light> lights;
  List __objectsAdded;
  List __objectsRemoved;

  Scene() {
    // TODO: check how to call super constructor
    // super();

    fog = null;
    overrideMaterial = null;

    matrixAutoUpdate = false;

    objects = [];
    lights = [];

    __objectsAdded = [];
    __objectsRemoved = [];
  }

  void addObject( Object3D object ) {
    if ( object is Light ) {
      if ( lights.indexOf( object ) == - 1 ) {
        lights.add( object );
      }
    } else if ( !( object is Camera || object is Bone ) ) {
      if ( objects.indexOf( object ) == - 1 ) {
        objects.add( object );
        __objectsAdded.add( object );

        // check if previously removed
        int i = __objectsRemoved.indexOf( object );

        if ( i != -1 ) {
          __objectsRemoved.removeAt(i);
        }
      }
    }

    for ( int c = 0; c < object.children.length; c ++ ) {
      addObject( object.children[ c ] );
    }
  }

  void removeObject( Object3D object ) {
    //TODO: "instanceof" replaced by "is"?
    if ( object is Light ) {
      int i = lights.indexOf( object );

      if ( i != -1 ) {
        lights.removeAt(i);
      }
    } else if ( !( object is Camera ) ) {
      int i = objects.indexOf( object );

      if( i != -1 ) {
        objects.removeAt(i);
        __objectsRemoved.add( object );

        // check if previously added
        var ai = __objectsAdded.indexOf( object );

        if ( ai != -1 ) {
          __objectsAdded.removeAt(ai);
        }
      }
    }

    for ( int c = 0; c < object.children.length; c ++ ) {
      removeObject( object.children[ c ] );
    }
  }
}
