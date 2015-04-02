/*
 * Based on r66
 */

part of three;


/// A convex hull generator using the incremental method. 
/// The complexity is O(n^2) where n is the number of vertices.
/// O(nlogn) algorithms do exist, but they are much more complicated.
class ConvexGeometry extends Geometry {
  List<Vector3> _vertices;
  List<List<int>> _faces = [[0, 1, 2], [0, 2, 1]];
  
  ConvexGeometry(this._vertices) : super() {
    for (var i = 3; i < _vertices.length; i++) {
      _addPoint(i);
    }
    
    // Push vertices into `this.vertices`, skipping those inside the hull
    var id = 0;
    var newId = new List(_vertices.length); // map from old vertex id to new id

    for (var i = 0; i < _faces.length; i++) {
      var face = _faces[i];
      for (var j = 0; j < 3; j++) {

        if (newId[face[j]] == null) {
          newId[face[j]] = id++;
          vertices.add(_vertices[face[j]]);
        }

        face[j] = newId[face[j]];
      }
    }
    
    // Convert faces into instances of Face3
    faces = new List.generate(_faces.length, (i) => 
        new Face3(_faces[i][0],
                  _faces[i][1],
                  _faces[i][2]));

    // Compute UVs
    faceVertexUvs[0] = new List.generate(faces.length, (i) =>
        [_vertexUv(vertices[(faces[i] as Face3).a]),
         _vertexUv(vertices[(faces[i] as Face3).b]),
         _vertexUv(vertices[(faces[i] as Face3).c])]);
  
    computeFaceNormals();
    computeVertexNormals();
  }
  
  void _addPoint(int vertexId) {
    var vertex = _vertices[vertexId].clone();

    var mag = vertex.length;
    vertex.x += mag * _randomOffset();
    vertex.y += mag * _randomOffset();
    vertex.z += mag * _randomOffset();

    var hole = [];

    for (var f = 0; f < _faces.length;) {
      var face = _faces[f];

      // for each face, if the vertex can see it,
      // then we try to add the face's edges into the hole.
      if (_visible(face, vertex)) {
        for ( var e = 0; e < 3; e++ ) {
          var edge = [face[e], face[(e + 1) % 3]];
          var boundary = true;

          // remove duplicated edges.
          for (var h = 0; h < hole.length; h++) {
            if (_equalEdge(hole[h], edge)) {
              hole[h] = hole[hole.length - 1];
              hole.removeLast();
              boundary = false;
              break;
            }
          }

          if (boundary) {
            hole.add(edge);
          }
        }

        _faces[f] = _faces[_faces.length - 1];
        _faces.removeLast();
      } else { // not visible
        f++;
      }
    }

    // construct the new faces formed by the edges of the hole and the vertex
    for (var h = 0; h < hole.length; h++) {
      _faces.add([hole[h][0],
                  hole[h][1],
                  vertexId]);
    }
  }
  
  // Whether the face is visible from the vertex.
  bool _visible(List<int> face, Vector3 vertex) {
    var va = _vertices[face[0]];
    var vb = _vertices[face[1]];
    var vc = _vertices[face[2]];

    var n = _normal(va, vb, vc);

    // distance from face to origin
    var dist = n.dot(va);

    return n.dot(vertex) >= dist; 
  }

  // Face normal
  Vector3 _normal(Vector3 va, Vector3 vb, Vector3 vc) =>
      (vc - vb).cross(va - vb).normalize();

  /*
   * Detect whether two edges are equal.
   * Note that when constructing the convex hull, two same edges can only
   * be of the negative direction.
   */
  bool _equalEdge(List<Face3> ea, List<Face3> eb) => ea[0] == eb[1] && ea[1] == eb[0]; 

  // Create a random offset between -1e-6 and 1e-6.
  double _randomOffset() => ThreeMath.randFloat(-1e-6, 1e-6);

  Vector2 _vertexUv(vertex) => new Vector2(vertex.x / vertex.length, vertex.y / vertex.length);
}