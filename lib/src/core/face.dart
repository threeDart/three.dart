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

  Face setFrom(Face other) {
    normal.setFrom(other.normal);
    color.copy( other.color );
    centroid.setFrom(other.centroid);

    materialIndex = other.materialIndex;

    vertexNormals = other.vertexNormals.map((Vector3 v) => v.clone()).toList();
    vertexColors = other.vertexColors.map((Vector3 v) => v.clone()).toList();
    vertexTangents = other.vertexTangents.map((Vector3 v) => v.clone()).toList();

    return this;
  }

  Face clone();
}
