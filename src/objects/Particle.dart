/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/  
 */

class Particle extends Object3D 
{
  IParticleMaterial material;
  
  Particle( IParticleMaterial material ) : super()
  {
    this.material = material;
  }
}
