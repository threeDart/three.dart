part of three;

abstract class Face {
  List<int> indices;
  Vector3 normal;
  List vertexNormals, vertexColors, vertexTangents;
  Color color;
  int materialIndex;
  Vector3 centroid;

  /// normalOrVertexNormals and colorOrVertexColors can be either a [Vector3] or a [List<Vector3>]
  Face( this.indices, normalOrVertexNormals, colorOrVertexColors, this.materialIndex ) {

    normal = normalOrVertexNormals is Vector3 ? normalOrVertexNormals :  new Vector3.zero();
    vertexNormals = normalOrVertexNormals is List ? normalOrVertexNormals : [];

    color = colorOrVertexColors is Color ? colorOrVertexColors : new Color();
    vertexColors = colorOrVertexColors is List ? colorOrVertexColors : [];

    vertexTangents = [];

    centroid = new Vector3.zero();
  }

  int get size => indices.length;

  clone() {

    var cm = reflectClass(this.runtimeType);

    Face face = cm.newInstance(new Symbol(""), this.indices).reflectee;

    face.normal.setFrom(this.normal);
    face.color.copy( this.color );
    face.centroid.setFrom(this.centroid);

    face.materialIndex = this.materialIndex;

    face.vertexNormals = vertexNormals.map((Vector3 v) => v.clone()).toList();
    face.vertexColors = vertexColors.map((Vector3 v) => v.clone()).toList();
    face.vertexTangents = vertexTangents.map((Vector3 v) => v.clone()).toList();

    return face;

  }
}
