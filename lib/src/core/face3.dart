part of three;

class Face3 extends Face {

  Face3([int a = 0, int b = 0, int c = 0, normalOrVertexNormals, colorOrVertexColors, materialIndex]) :
    super([a, b, c], normalOrVertexNormals, colorOrVertexColors, materialIndex);

  get a => indices[0];
  set a(int i) { indices[0] = i; }

  get b => indices[1];
  set b(int i) { indices[1] = i; }

  get c => indices[2];
  set c(int i) { indices[2] = i; }

  clone() => new Face3(a, b, c).setFrom(this);

}
