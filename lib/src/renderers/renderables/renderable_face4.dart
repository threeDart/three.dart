part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableFace4 extends RenderableFace {

  RenderableFace4() : super(4);

  RenderableVertex get v1 => vertices[0];
  RenderableVertex get v2 => vertices[1];
  RenderableVertex get v3 => vertices[2];
  RenderableVertex get v4 => vertices[3];

}
