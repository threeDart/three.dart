part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableLine implements IRenderable {
  num z = null;

  RenderableVertex v1;
  RenderableVertex v2;

  Material material = null;

  RenderableLine()
      : v1 = new RenderableVertex(),
        v2 = new RenderableVertex();
}
