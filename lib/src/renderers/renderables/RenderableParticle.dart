part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableParticle implements IRenderableObj {
    num x = null;
    num y = null;
    num z = null;

    num rotation = null;
    Vector2 scale;

    Material material = null;

    RenderableParticle()
      : scale = new Vector2();

}
