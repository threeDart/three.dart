part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author seguins
 *
 */

class OBJLoader extends Loader {

  OBJLoader() : super();

  Future<Object3D> load(url) =>
      HttpRequest.request(url, responseType: "String")
      .then((req) => _parse(req.response));

  _parseIndex(vertices, index) {
    index = int.parse(index);
    return index >= 0 ? index - 1 : index + vertices.length;
  }

  _create_face(a, b, c, vertices, [normals, normals_inds = null]) {
    var face = new Face3(
        vertices[_parseIndex(vertices, a)] - 1,
        vertices[_parseIndex(vertices, b)] - 1,
        vertices[_parseIndex(vertices, c)] - 1);

    if ( normals_inds != null ) {
      face.vertexNormals = [
          normals[_parseIndex(normals, normals_inds[ 0 ])],
          normals[_parseIndex(normals, normals_inds[ 1 ])],
          normals[_parseIndex(normals, normals_inds[ 2 ])]
      ];
    }
    return face;
  }

  _create_uvs(uvs, a, b, c) =>
      [
        uvs[_parseIndex(uvs, a)],
        uvs[_parseIndex(uvs, b)],
        uvs[_parseIndex(uvs, c)]
      ];

  _handle_face_line(geometry, vertices, normals, uvs, faces, [uvsLine = null, normals_inds = null]) {
    if (faces[ 3 ] == null)  {
      geometry.faces.add(_create_face(faces[0], faces[1], faces[2], vertices, normals, normals_inds));
      if (uvsLine != null && uvsLine.length > 0) {
        geometry.faceVertexUvs[0].add(_create_uvs(uvs, uvsLine[0], uvsLine[1], uvsLine[2] ));
      }
    } else {
      if (normals_inds != null && normals_inds.length > 0) {
        geometry.faces.add(_create_face(faces[0], faces[1], faces[3], vertices, normals, [normals_inds[0], normals_inds[1], normals_inds[3]]));
        geometry.faces.add(_create_face(faces[1], faces[2], faces[3], vertices, normals, [normals_inds[1], normals_inds[2], normals_inds[3]]));
      } else {
        geometry.faces.add(_create_face(faces[0], faces[1], faces[3], vertices));
        geometry.faces.add(_create_face(faces[1], faces[2], faces[3], vertices));
      }
      if (uvsLine != null && uvsLine.length > 0) {
        geometry.faceVertexUvs[0].add(_create_uvs(uvs, uvsLine[0], uvsLine[1], uvsLine[3]));
        geometry.faceVertexUvs[0].add(_create_uvs(uvs, uvsLine[1], uvsLine[2], uvsLine[3]));
      }
    }
  }


  _parse(text) {

    var object = new Object3D();

    var geometry, material, mesh;

    // create mesh if no objects in text

    if (text.contains(new RegExp(r"^o ", multiLine: true)) == false) {
      geometry = new Geometry();
      material = new MeshLambertMaterial();
      mesh = new Mesh(geometry, material);
      object.add(mesh);
    }

    var lines = text.split('\n');

    var vertices = new List();
    var normals = new List();
    var uvs = new List();

    // v float float float
    var vertex_pattern = new RegExp(r"v( +[\d|\.|\+|\-|e]+)( +[\d|\.|\+|\-|e]+)( +[\d|\.|\+|\-|e]+)");

    // vn float float float
    var normal_pattern = new RegExp(r"vn( +[\d|\.|\+|\-|e]+)( +[\d|\.|\+|\-|e]+)( +[\d|\.|\+|\-|e]+)");

    // vt float float
    var uv_pattern = new RegExp(r"vt( +[\d|\.|\+|\-|e]+)( +[\d|\.|\+|\-|e]+)");

    // f vertex vertex vertex ...
    var face_pattern1 = new RegExp(r"f( +-?\d+)( +-?\d+)( +-?\d+)( +-?\d+)?");

    // f vertex/uv vertex/uv vertex/uv ...
    var face_pattern2 = new RegExp(r"f( +(-?\d+)\/(-?\d+))( +(-?\d+)\/(-?\d+))( +(-?\d+)\/(-?\d+))( +(-?\d+)\/(-?\d+))?");

    // f vertex/uv/normal vertex/uv/normal vertex/uv/normal ...
    var face_pattern3 = new RegExp(r"f( +(-?\d+)\/(-?\d+)\/(-?\d+))( +(-?\d+)\/(-?\d+)\/(-?\d+))( +(-?\d+)\/(-?\d+)\/(-?\d+))( +(-?\d+)\/(-?\d+)\/(-?\d+))?");

    // f vertex//normal vertex//normal vertex//normal ...
    var face_pattern4 = new RegExp(r"f( +(-?\d+)\/\/(-?\d+))( +(-?\d+)\/\/(-?\d+))( +(-?\d+)\/\/(-?\d+))( +(-?\d+)\/\/(-?\d+))?");

    lines.forEach((line) {
      line = line.trim();
      var result;

      if (!(line.length == 0 || line.startsWith('#'))) {
        if ((result = vertex_pattern.firstMatch(line)) != null) {

          // ["v 1.0 2.0 3.0", "1.0", "2.0", "3.0"]
          geometry.vertices.add(new Vector3(double.parse(result[1]), double.parse(result[2]), double.parse(result[3])));
          vertices.add(geometry.vertices.length);

        } else if ((result = normal_pattern.firstMatch(line)) != null) {

          // ["vn 1.0 2.0 3.0", "1.0", "2.0", "3.0"]
          normals.add( new Vector3(double.parse(result[1]), double.parse(result[2]), double.parse(result[3])));

        } else if ((result = uv_pattern.firstMatch(line)) != null) {

          // ["vt 0.1 0.2", "0.1", "0.2"]
          uvs.add(new UV(double.parse(result[1]), double.parse(result[2])));

        } else if ((result = face_pattern1.firstMatch(line)) != null) {

          // ["f 1 2 3", "1", "2", "3", undefined]
          _handle_face_line(
              geometry, vertices, normals, uvs,
              [result[1], result[2], result[3], result[4]]
          );


        } else if ((result = face_pattern2.firstMatch(line)) != null) {

          // ["f 1/1 2/2 3/3", " 1/1", "1", "1", " 2/2", "2", "2", " 3/3", "3", "3", undefined, undefined, undefined]
          _handle_face_line(
              geometry, vertices, normals, uvs,
              [result[2], result[5], result[8], result[11]], //faces
              [result[3], result[6], result[9], result[12]] //uv
          );

        } else if ((result = face_pattern3.firstMatch(line)) != null) {

          // ["f 1/1/1 2/2/2 3/3/3", " 1/1/1", "1", "1", "1", " 2/2/2", "2", "2", "2", " 3/3/3", "3", "3", "3", undefined, undefined, undefined, undefined]
          _handle_face_line(
              geometry, vertices, normals, uvs,
              [result[2], result[6], result[10], result[14]], //faces
              [result[3], result[7], result[11], result[15]], //uv
              [result[4], result[8], result[12], result[16]] //normal
          );

        } else if ((result = face_pattern4.firstMatch(line)) != null) {

          // ["f 1//1 2//2 3//3", " 1//1", "1", "1", " 2//2", "2", "2", " 3//3", "3", "3", undefined, undefined, undefined]
          _handle_face_line(
            geometry, vertices, normals, uvs,
            [result[2], result[5], result[8], result[11]], //faces
            [], //uv
            [result[3], result[6], result[9], result[12]] //normal
          );

        } else if (line.contains(new RegExp(r"^o "))) {

          geometry = new Geometry();
          material = new MeshLambertMaterial();

          mesh = new Mesh(geometry, material );
          mesh.name = line.substring( 2 ).trim();
          object.add(mesh);


        } else if (line.contains(new RegExp(r"^g "))) {


        } else if (line.contains(new RegExp(r"^usemtl "))) {


        } else if (line.contains(new RegExp(r"^mtllib "))) {


        } else if (line.contains(new RegExp(r"^s "))) {


        }
      }
    });

    object.children.forEach((child) {
      child.geometry.computeFaceNormals();
      child.geometry.computeBoundingSphere();
    });

    return object;
  }

}