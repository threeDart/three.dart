part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author seguins
 *
 */

class OBJLoader extends Loader {

  bool _useMtl;
  
  OBJLoader({useMtl: true}) : super() {
    this._useMtl = useMtl;
  }

  Future<Object3D> load(url) =>
      HttpRequest.request(url, responseType: "String")
      .then((req) => _parse(req.response));

  void _addFace(Geometry geometry, int face_offset,
                String a, String b, String c,
                [List normals, List normals_inds]) {
    var normalOrVertexNormals;
    
    if (normals != null && normals_inds != null) {
          normalOrVertexNormals = [
              normals[int.parse(normals_inds[0]) - 1].clone(),
              normals[int.parse(normals_inds[1]) - 1].clone(),
              normals[int.parse(normals_inds[2]) - 1].clone()
            ];
        }
    
    geometry.faces.add(new Face3(
        int.parse(a) - (face_offset + 1),
        int.parse(b) - (face_offset + 1),
        int.parse(c) - (face_offset + 1),
        normalOrVertexNormals
      ));
  }

  _addUvs(Geometry geometry, List uvs, String a, String b, String c) =>
      geometry.faceVertexUvs[0].add( [
        uvs[int.parse(a) - 1].clone(),
        uvs[int.parse(b) - 1].clone(),
        uvs[int.parse(c) - 1].clone()
      ]);
  
  _handle_face_line(Geometry geometry, int faceOffset, normals, List uvs, List<String> faces, [List<String> uvsLine = null, normals_inds = null]) {    
    if (faces[ 3 ] == null)  {
      _addFace(geometry, faceOffset, faces[0], faces[1], faces[2], normals, normals_inds);
      if (uvsLine != null && uvsLine.length > 0) {
        _addUvs(geometry, uvs, uvsLine[0], uvsLine[1], uvsLine[2]);
      }
    } else {
      if (normals_inds != null && normals_inds.length > 0) {
        _addFace(geometry, faceOffset, faces[0], faces[1], faces[3], normals, [normals_inds[0], normals_inds[1], normals_inds[3]]);
        _addFace(geometry, faceOffset, faces[1], faces[2], faces[3], normals, [normals_inds[1], normals_inds[2], normals_inds[3]]);
      } else {
        _addFace(geometry, faceOffset, faces[0], faces[1], faces[3]);
        _addFace(geometry, faceOffset, faces[1], faces[2], faces[3]);
      }
      
      if (uvsLine != null && uvsLine.length > 0) {
        _addUvs(geometry, uvs, uvsLine[0], uvsLine[1], uvsLine[3]);
        _addUvs(geometry, uvs, uvsLine[1], uvsLine[2], uvsLine[3]);
      }
    }
  }


  _parse(text) {

    Object3D group = new Object3D();
    Object3D object = group;
    
    Geometry geometry = new Geometry();
    Material material = new MeshLambertMaterial();
    Mesh mesh = new Mesh(geometry, material);

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

    var face_offset = 0;
    
    //MTL
    StreamController<Mesh> controllerMtl;
    
    var lines = text.split('\n');
    lines.forEach((line) {
      line = line.trim();
      var result;

      if (!(line.length == 0 || line.startsWith('#'))) {
        if ((result = vertex_pattern.firstMatch(line)) != null) {

          // ["v 1.0 2.0 3.0", "1.0", "2.0", "3.0"]
          vertices.add(new Vector3(double.parse(result[1]), double.parse(result[2]), double.parse(result[3])));

        } else if ((result = normal_pattern.firstMatch(line)) != null) {

          // ["vn 1.0 2.0 3.0", "1.0", "2.0", "3.0"]
          normals.add( new Vector3(double.parse(result[1]), double.parse(result[2]), double.parse(result[3])));

        } else if ((result = uv_pattern.firstMatch(line)) != null) {

          // ["vt 0.1 0.2", "0.1", "0.2"]
          uvs.add(new UV(double.parse(result[1]), double.parse(result[2])));

        } else if ((result = face_pattern1.firstMatch(line)) != null) {

          // ["f 1 2 3", "1", "2", "3", undefined]
          _handle_face_line(
              geometry, face_offset, normals, uvs,
              [result[1], result[2], result[3], result[4]]
          );


        } else if ((result = face_pattern2.firstMatch(line)) != null) {

          // ["f 1/1 2/2 3/3", " 1/1", "1", "1", " 2/2", "2", "2", " 3/3", "3", "3", undefined, undefined, undefined]
          _handle_face_line(
              geometry, face_offset, normals, uvs,
              [result[2], result[5], result[8], result[11]], //faces
              [result[3], result[6], result[9], result[12]] //uv
          );

        } else if ((result = face_pattern3.firstMatch(line)) != null) {

          // ["f 1/1/1 2/2/2 3/3/3", " 1/1/1", "1", "1", "1", " 2/2/2", "2", "2", "2", " 3/3/3", "3", "3", "3", undefined, undefined, undefined, undefined]
          _handle_face_line(
              geometry, face_offset, normals, uvs,
              [result[2], result[6], result[10], result[14]], //faces
              [result[3], result[7], result[11], result[15]], //uv
              [result[4], result[8], result[12], result[16]] //normal
          );

        } else if ((result = face_pattern4.firstMatch(line)) != null) {

          // ["f 1//1 2//2 3//3", " 1//1", "1", "1", " 2//2", "2", "2", " 3//3", "3", "3", undefined, undefined, undefined]
          _handle_face_line(
            geometry, face_offset, normals, uvs,
            [result[2], result[5], result[8], result[11]], //faces
            [], //uv
            [result[3], result[6], result[9], result[12]] //normal
          );

        } else if (line.contains(new RegExp(r"^o "))) {

          if (_editGeometry(vertices, geometry)) {
            object.add(mesh);
            geometry = new Geometry();
            mesh = new Mesh(geometry, material);
          }

          
          face_offset = face_offset + vertices.length;
          vertices = new List();
          object = new Object3D();
          object.name = line.substring(2).trim();
          group.add(object);

        } else if (line.contains(new RegExp(r"^g "))) {
          if (_editGeometry(vertices, geometry)) {
            object.add(mesh);
            geometry = new Geometry();
            mesh = new Mesh(geometry, material);            
          }
        } else if (line.contains(new RegExp(r"^usemtl "))) {          
          if (controllerMtl != null || _useMtl) {
            material = new MeshLambertMaterial();
            material.name = line.substring(7).trim();
            mesh.material = material;
            controllerMtl.add(mesh);
          }
        } else if (line.contains(new RegExp(r"^mtllib "))) {
          if (_useMtl) {
            var loaderMTL = new MTLLoader("obj/", {}, "");
            if (controllerMtl != null) {
              controllerMtl.close();
            }
            controllerMtl = _createStreamMTL(loaderMTL.load("obj/" + line.substring(7).trim()));
          }
        } else if (line.contains(new RegExp(r"^s "))) {
          // Smooth shading
        }
      }
    });

    if (_editGeometry(vertices, geometry)) {
      object.add(mesh);
    }
    if (controllerMtl != null) {
      controllerMtl.close();
    }
    
    return group;
  }
  
  bool _editGeometry(List vertices, Geometry geometry) {
      if (vertices.length > 0) {
        geometry.vertices = vertices;
        geometry.mergeVertices();
        geometry.computeFaceNormals();
        geometry.computeBoundingSphere();
        return true;
      }
      return false;
  }

  StreamController<Mesh> _createStreamMTL(Future<MaterialCreator> future) {
    var controller = new StreamController<Mesh>();
    
    future.then((materialCreator) {
      controller.stream.listen((Mesh e) {
        if (e.material is MeshLambertMaterial && e.material.name.isNotEmpty) { 
          materialCreator.create(e.material.name).then((material) {
            if ( material != null) {
              e.geometry.buffersNeedUpdate = true;
              e.geometry.uvsNeedUpdate = true;
              e.material = material;
            }
          });
        }
      });
    });
    
    return controller;
  }
  
}