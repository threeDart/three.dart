part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableVertex {
  Vector3 positionWorld;
  Vector4 positionScreen;

  bool visible = true;

  RenderableVertex()
      : positionWorld = new Vector3.zero(),
        positionScreen = new Vector4(0.0, 0.0, 0.0, 1.0);

  copy( RenderableVertex vertex ) {
    positionWorld.setFrom( vertex.positionWorld );
    positionScreen.setFrom( vertex.positionScreen );
  }
  
  clone() => new RenderableVertex()..copy(this);
}
