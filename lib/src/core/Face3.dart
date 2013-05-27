part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Face3 implements IFace3 {
  int a, b, c;
  Vector3 normal;
  List vertexNormals, vertexColors, vertexTangents;
  Color color;
  int materialIndex;
  Vector3 centroid;

  /// normalOrVertexNormals and colorOrVertexColors can be either a [Vector3] or a [List<Vector3>]
  Face3( [this.a, this.b, this.c, normalOrVertexNormals, colorOrVertexColors, this.materialIndex] ) {

    normal = normalOrVertexNormals is Vector3 ? normalOrVertexNormals :  new Vector3.zero();
    vertexNormals = normalOrVertexNormals is List ? normalOrVertexNormals : [];

    color = colorOrVertexColors is Color ? colorOrVertexColors : new Color();
    vertexColors = colorOrVertexColors is List ? colorOrVertexColors : [];

    vertexTangents = [];

    centroid = new Vector3.zero();
  }

  clone() {

    var face = new Face3( a, b, c );

    face.normal = this.normal.clone();
    face.color.copy( this.color );
    face.centroid = this.centroid.clone();

    face.materialIndex = this.materialIndex;

    face.vertexNormals = vertexNormals.map((Vector3 v) => v.clone()).toList();
    face.vertexColors = vertexColors.map((Vector3 v) => v.clone()).toList();
    face.vertexTangents = vertexTangents.map((Vector3 v) => v.clone()).toList();

    return face;

  }
}
