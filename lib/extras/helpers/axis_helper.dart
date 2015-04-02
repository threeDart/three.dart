/*
 * @author sroucheray / http://sroucheray.org/
 * @author mrdoob / http://mrdoob.com/
 * 
 * based on r63
 */


part of three;

class AxisHelper extends Line {
  factory AxisHelper([double size = 1.0]) {
    var geometry = new Geometry()
      ..vertices.addAll(
          [new Vector3.zero(), new Vector3(size, 0.0, 0.0),
           new Vector3.zero(), new Vector3(0.0, size, 0.0),
           new Vector3.zero(), new Vector3(0.0, 0.0, size)])
      ..colors.addAll(
          [new Color(0xff0000), new Color(0xffaa00),
           new Color(0x00ff00), new Color(0xaaff00),
           new Color(0x0000ff), new Color(0x00aaff)]);

    var material = new LineBasicMaterial(vertexColors: VertexColors);
    
    return new AxisHelper._internal(geometry, material, LinePieces);
  }
  
  AxisHelper._internal(Geometry geometry, LineBasicMaterial material, int type) : super(geometry, material, type);
}
