part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Vertex extends Vector3 {

  Vector3 position;

  Vertex( this.position ) { print('THREE.Vertex has been DEPRECATED. Use THREE.Vector3 instead.'); }

  get x => position.x;
  get y => position.y;
  get z => position.z;
}
