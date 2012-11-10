part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class RenderableFace4 implements IRenderableFace4 {
  RenderableVertex v1;
  RenderableVertex v2;
  RenderableVertex v3;
  RenderableVertex v4;

  Vector3 centroidWorld, centroidScreen, normalWorld;

  List vertexNormalsWorld;
  List<List> uvs;

  Material material;
  Material faceMaterial;

  num z;

  RenderableFace4()
      : v1 = new RenderableVertex(),
        v2 = new RenderableVertex(),
        v3 = new RenderableVertex(),
        v4 = new RenderableVertex(),

        centroidWorld = new Vector3(),
        centroidScreen = new Vector3(),

        normalWorld = new Vector3(),
        vertexNormalsWorld = [ new Vector3(), new Vector3(), new Vector3(), new Vector3() ],

        material = null,
        uvs = [[]],

        z = null;
}
