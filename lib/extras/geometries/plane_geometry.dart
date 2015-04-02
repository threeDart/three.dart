/*
 * @author mr.doob / http://mrdoob.com/
 * based on http://papervision3d.googlecode.com/svn/trunk/as3/trunk/src/org/papervision3d/objects/primitives/Plane.as
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 * 
 * based on r66
 */

part of three;

/** 
 * A class for generating plane geometries.
 *   
 *     var geometry = new PlaneGeometry(5.0, 20.0);
 *     var material = new MeshBasicMaterial(color: 0xffff00, side: DOUBLE_SIDE);
 *     var plane = new Mesh(geometry, material);
 *     scene.add(plane);
 */ 
class PlaneGeometry extends Geometry {
  /// Creates a new plane geometry.
  PlaneGeometry(double width, double height, [int widthSegments = 1, int heightSegments = 1]) : super() {
    var width_half = width / 2;
    var height_half = height / 2;

    var gridX = widthSegments;
    var gridZ = heightSegments;

    var gridX1 = gridX + 1;
    var gridZ1 = gridZ + 1;

    var segment_width = width / gridX;
    var segment_height = height / gridZ;

    var normal = new Vector3(0.0, -1.0, 0.0);

    for (var iz = 0; iz < gridZ1; iz++) {
      for (var ix = 0; ix < gridX1; ix++) {
        var x = ix * segment_width - width_half;
        var y = iz * segment_height - height_half;

        vertices.add(new Vector3(x, -y, 0.0));
      }
    }

    for (var iz = 0; iz < gridZ; iz++) {
      for (var ix = 0; ix < gridX; ix++) {
        var a = ix + gridX1 * iz;
        var b = ix + gridX1 * (iz + 1);
        var c = (ix + 1) + gridX1 * (iz + 1);
        var d = (ix + 1) + gridX1 * iz;

        var uva = new Vector2(ix / gridX, 1 - iz / gridZ);
        var uvb = new Vector2(ix / gridX, 1 - (iz + 1) / gridZ);
        var uvc = new Vector2((ix + 1) / gridX, 1 - (iz + 1) / gridZ);
        var uvd = new Vector2((ix + 1) / gridX, 1 - iz / gridZ);

        faces.add(new Face3(a, b, d, [normal.clone(), normal.clone(), normal.clone()]));
        faceVertexUvs[0].add([uva, uvb, uvd]);

        faces.add(new Face3(b, c, d, [normal.clone(), normal.clone(), normal.clone()]));            
        faceVertexUvs[0].add([uvb.clone(), uvc, uvd.clone()]);
      }
    }
  }
}