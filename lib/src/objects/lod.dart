part of three;

class LOD extends Object3D {
  List LODs;

  LOD() : LODs = [], super();

  addLevel(Object3D object3D, [num visibleAtDistance = 0]) {

    visibleAtDistance = visibleAtDistance.abs();

    var l;
    for ( l = 0; l < LODs.length; l ++ ) {
      if ( visibleAtDistance < this.LODs[l].visibleAtDistance ) {
        break;
      }
    }

    LODs.insert(l, { "visibleAtDistance": visibleAtDistance, "object3D": object3D } );
    add( object3D );
  }

  update(Camera camera) {

    if ( LODs.length > 1 ) {

      camera.matrixWorldInverse.copyInverse(camera.matrixWorld);

      var inverse  = camera.matrixWorldInverse;
      var distance = -( inverse[2] * matrixWorld[12] + inverse[6] * matrixWorld[13] + inverse[10] * matrixWorld[14] + inverse[14] );

      LODs[ 0 ].object3D.visible = true;

      var l;

      for ( l = 1; l < LODs.length; l ++ ) {

        if( distance >= LODs[ l ].visibleAtDistance ) {

          LODs[ l - 1 ].object3D.visible = false;
          LODs[ l     ].object3D.visible = true;

        } else {

          break;

        }

      }

      for( ; l < this.LODs.length; l ++ ) {

        LODs[ l ].object3D.visible = false;

      }

    }
  }

}
