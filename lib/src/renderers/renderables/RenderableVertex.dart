part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableVertex implements IRenderableObj {
  Vector3 positionWorld;
  Vector4 positionScreen;

  bool visible = true;

  RenderableVertex()
      : positionWorld = new Vector3(),
        positionScreen = new Vector4();

  copy( RenderableVertex vertex ) {
    positionWorld.copy( vertex.positionWorld );
    positionScreen.copy( vertex.positionScreen );
  }
}
