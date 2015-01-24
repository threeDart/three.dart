part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

/// Affects objects using MeshLambertMaterial or MeshPhongMaterial.
class PointLight extends Light
{
  Vector3 _position;
  /// Light's intensity.
  double intensity;
  /// If non-zero, light will attenuate linearly from maximum intensity at light position down to zero at distance.
  double distance;

  /// Creates a light at a specific position in the scene.
  ///
  /// The light shines in all directions (roughly similar to a light bulb.)
  PointLight( num hex, {this.intensity: 1.0, this.distance: 0.0} ) : super( hex )
  {
    //THREE.Light.call( this, hex );

    _position = new Vector3.zero();
  }
}
