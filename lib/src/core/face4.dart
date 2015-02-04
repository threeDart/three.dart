part of three;

/// Quadrilateral face.
class Face4 extends Face {

  Face4([int a = 0, int b = 0, int c = 0, int d = 0, normalOrVertexNormals, colorOrVertexColors, int materialIndex])
      : super([a, b, c, d], normalOrVertexNormals, colorOrVertexColors, materialIndex);

  int get a => indices[0];
  set a(int i) {
    indices[0] = i;
  }

  int get b => indices[1];
  set b(int i) {
    indices[1] = i;
  }

  int get c => indices[2];
  set c(int i) {
    indices[2] = i;
  }

  int get d => indices[3];
  set d(int i) {
    indices[3] = i;
  }

  /// Clone this Face.
  clone() => new Face4(a, b, c, d).setFrom(this);
}
