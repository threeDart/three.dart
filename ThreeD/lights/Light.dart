/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Light extends Object3D 
{   
  Color color;
  
  Light( num hex ) : super()
  {
    //THREE.Object3D.call( this );

    color = new Color( hex );
  }
}
