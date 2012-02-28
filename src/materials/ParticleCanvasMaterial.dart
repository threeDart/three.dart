/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/ 
 *
 * parameters = {
 *  color: <hex>,
 *  program: <function>,
 *  opacity: <float>,
 *  blending: THREE.NormalBlending
 * }
 */

class ParticleCanvasMaterial extends Material implements IParticleMaterial
{
  Color color;
  Function program;
  
  ParticleCanvasMaterial( [Map parameters] ) : super( parameters ) 
  {
    Map _parameters = parameters !== null ? parameters : {};

    color = _parameters['color'] !== null ? new Color( _parameters['color'] ) : new Color( 0xffffff );
    program = _parameters['program'] !== null ? _parameters['program'] : function ( CanvasRenderingContext2D context, num newColor ) {};
  }
}
