part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableFace3 extends RenderableFace {

  RenderableFace3() : super(3);

  RenderableVertex get v1 => vertices[0];
  RenderableVertex get v2 => vertices[1];
  RenderableVertex get v3 => vertices[2];

}
