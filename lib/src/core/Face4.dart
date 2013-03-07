part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Face4 implements IFace4 {
  num a, b, c, d;
  Vector3 normal;
  List vertexNormals, vertexColors, vertexTangents;
  Color color;
  int materialIndex;
  Vector3 centroid;

  /// normalOrVertexNormals and colorOrVertexColors can be either a [Vector3] or a [List<Vector3>]
  Face4( [this.a, this.b, this.c, this.d, normalOrVertexNormals, colorOrVertexColors, this.materialIndex] ) {
    normal = normalOrVertexNormals is Vector3 ? normalOrVertexNormals :  new Vector3();
    vertexNormals = normalOrVertexNormals is List ? normalOrVertexNormals : [];

    color = colorOrVertexColors is Color ? colorOrVertexColors : new Color();
    vertexColors = colorOrVertexColors is List ? colorOrVertexColors : [];

    vertexTangents = [];

    materialIndex = materialIndex;

    centroid = new Vector3();
  }

  clone() {

    var face = new Face4( a, b, c, d );

    face.normal.copy( this.normal );
    face.color.copy( this.color );
    face.centroid.copy( this.centroid );

    face.materialIndex = this.materialIndex;

    face.vertexNormals = vertexNormals.map((Vector3 v) => v.clone()).toList();
    face.vertexColors = vertexColors.map((Vector3 v) => v.clone()).toList();
    face.vertexTangents = vertexTangents.map((Vector3 v) => v.clone()).toList();

    return face;

  }
}
