part of three;

class RenderableFace implements IRenderable {
  List<RenderableVertex> vertices;

  Vector3 centroidWorld, centroidScreen, normalWorld;

  List vertexNormalsWorld, uvs;

  Material material;
  Material faceMaterial;

  num z;

  RenderableFace(int size) :
    centroidWorld = new Vector3.zero(),
    centroidScreen = new Vector3.zero(),

    normalWorld = new Vector3.zero(),
    vertexNormalsWorld = [ new Vector3.zero(), new Vector3.zero(), new Vector3.zero(), new Vector3.zero() ],

    material = null,
    uvs = [[]],

    z = null {
    vertices = new List.generate(size, (_) => new RenderableVertex(), growable: false);
  }
}