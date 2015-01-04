part of three;

/// Triangle face.
class Face3 extends Face {

  Face3([int a = 0, int b = 0, int c = 0, normalOrVertexNormals, colorOrVertexColors, int materialIndex]) :
    super([a, b, c], normalOrVertexNormals, colorOrVertexColors, materialIndex);

  /// Vertex A index.
  int get a => indices[0];
  /// Set vertex A index.
  set a(int i) { indices[0] = i; }

  /// Vertex B index.
  int get b => indices[1];
  /// Set vertex B index.
  set b(int i) { indices[1] = i; }

  /// Vertex C index.
  int get c => indices[2];
  /// Set vertex C index.
  set c(int i) { indices[2] = i; }

  /// Make a copy of this Face3.
  clone() => new Face3(a, b, c).setFrom(this);

}
