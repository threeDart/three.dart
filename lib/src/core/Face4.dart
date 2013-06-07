part of three;

class Face4 extends Face {

  Face4([List<int> indices, normalOrVertexNormals, colorOrVertexColors, materialIndex]) :
    super(4, indices, normalOrVertexNormals, colorOrVertexColors, materialIndex);

  get a => indices[0];
  set a(int i) { indices[0] = i; }

  get b => indices[1];
  set b(int i) { indices[1] = i; }

  get c => indices[2];
  set c(int i) { indices[2] = i; }

  get d => indices[3];
  set d(int i) { indices[3] = i; }
}
