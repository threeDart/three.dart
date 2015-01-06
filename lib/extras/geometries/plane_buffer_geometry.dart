part of three;

/**
 * @author mrdoob / http://mrdoob.com/
 * based on http://papervision3d.googlecode.com/svn/trunk/as3/trunk/src/org/papervision3d/objects/primitives/Plane.as
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class PlaneBufferGeometry extends BufferGeometry {

  PlaneBufferGeometry(int width, int height, [int widthSegments = 1,
      int heightSegments = 1]) {

    int widthHalf = width ~/ 2;
    int heightHalf = height ~/ 2;

    int gridX = widthSegments;
    int gridY = heightSegments;

    int gridX1 = gridX + 1;
    int gridY1 = gridY + 1;

    int segmentWidth = width ~/ gridX;
    int segmentHeight = height ~/ gridY;

    GeometryAttribute<Float32List> vertices =
        new GeometryAttribute.float32(gridX1 * gridY1 * 3);
    GeometryAttribute<Float32List> normals =
        new GeometryAttribute.float32(gridX1 * gridY1 * 3);
    GeometryAttribute<Float32List> uvs =
        new GeometryAttribute.float32(gridX1 * gridY1 * 2);

    int offset = 0;
    int offset2 = 0;

    for (int iy = 0; iy < gridY1; iy++) {

      var y = iy * segmentHeight - heightHalf;

      for (int ix = 0; ix < gridX1; ix++) {

        var x = ix * segmentWidth - widthHalf;

        vertices.array[offset] = x.toDouble();
        vertices.array[offset + 1] = (-y).toDouble();

        normals.array[offset + 2] = 1.toDouble();

        uvs.array[offset2] = ix / gridX;
        uvs.array[offset2 + 1] = 1 - (iy / gridY);

        offset += 3;
        offset2 += 2;
      }
    }

    offset = 0;

    GeometryAttribute<Int16List> indices =
        new GeometryAttribute.int16(gridX * gridY * 6);

    for (int iy = 0; iy < gridY; ++iy) {

      for (int ix = 0; ix < gridX; ++ix) {

        int a = ix + gridX1 * iy;
        int b = ix + gridX1 * (iy + 1);
        int c = (ix + 1) + gridX1 * (iy + 1);
        int d = (ix + 1) + gridX1 * iy;

        indices.array[offset] = a;
        indices.array[offset + 1] = b;
        indices.array[offset + 2] = d;

        indices.array[offset + 3] = b;
        indices.array[offset + 4] = c;
        indices.array[offset + 5] = d;

        offset += 6;
      }

      aPosition = vertices;
      aNormal = normals;
      aIndex = indices;
      aUV = uvs;
    }
  }

  GeometryAttribute<Float32List> get aPosition => super.aPosition;
  set aPosition(a) => super.aPosition = a;

  GeometryAttribute<Float32List> get aNormal => super.aNormal;
  set aNormal(a) => super.aNormal = a;

  GeometryAttribute<Int16List> get aIndex => super.aIndex;
  set aIndex(a) => super.aIndex = a;

  GeometryAttribute<Float32List> get aUV => super.aUV;
  set aUV(a) => super.aUV = a;

  GeometryAttribute<Float32List> get aTangent => super.aTangent;
  set aTangent(a) => super.aTangent = a;

  GeometryAttribute<Float32List> get aColor => super.aColor;
  set aColor(a) => super.aColor = a;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
