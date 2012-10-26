part of ThreeD;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Three {
  num lastTime;
  List<String> vendors;

  // from Line
  static const int LineStrip = 0;
  static const int LinePieces = 1;

  // from Geometry
  static int GeometryCount = 0;

  // from Object3D
  static int Object3DCount = 0;

  // from Material
  static int MaterialCount = 0;

  // MATERIAL CONSTANTS

  // side
  static const int FrontSide = 0;
  static const int BackSide = 1;
  static const int DoubleSide = 2;

  static const int NoShading = 0;
  static const int FlatShading = 1;
  static const int SmoothShading = 2;

  static const int NoColors = 0;
  static const int FaceColors = 1;
  static const int VertexColors = 2;

  // blending modes

 static const int NoBlending = 0;
 static const int NormalBlending = 1;
 static const int AdditiveBlending = 2;
 static const int SubtractiveBlending = 3;
 static const int MultiplyBlending = 4;
 static const int CustomBlending = 5;

  // custom blending equations
// (numbers start from 100 not to clash with other
//  mappings to OpenGL constants defined in Texture.js)

 static const int AddEquation = 100;
 static const int SubtractEquation = 101;
 static const int ReverseSubtractEquation = 102;

 // custom blending destination factors

 static const int ZeroFactor = 200;
 static const int OneFactor = 201;
 static const int SrcColorFactor = 202;
 static const int OneMinusSrcColorFactor = 203;
 static const int SrcAlphaFactor = 204;
 static const int OneMinusSrcAlphaFactor = 205;
 static const int DstAlphaFactor = 206;
 static const int OneMinusDstAlphaFactor = 207;

// custom blending source factors

 static const int DstColorFactor = 208;
 static const int OneMinusDstColorFactor = 209;
 static const int SrcAlphaSaturateFactor = 210;

  // from MeshBasicMaterial

  // from Texture
  static int TextureCount = 0;

  static const int MultiplyOperation = 0;
  static const int MixOperation = 1;

  static var UVMapping;//();

  // Wrapping modes
  static const int RepeatWrapping = 0;
  static const int ClampToEdgeWrapping = 1;
  static const int MirroredRepeatWrapping = 2;

  // Filters
  static const int NearestFilter = 3;
  static const int NearestMipMapNearestFilter = 4;
  static const int NearestMipMapLinearFilter = 5;
  static const int LinearFilter = 6;
  static const int LinearMipMapNearestFilter = 7;
  static const int LinearMipMapLinearFilter = 8;

  // Data Types
  static const int ByteType = 9;
  static const int UnsignedByteType = 10;
  static const int ShortType = 11;
  static const int UnsignedShortType = 12;
  static const int IntType = 13;
  static const int UnsignedIntType = 14;
  static const int FloatType = 15;

  // Pixel types
  static const int UnsignedShort4444Type = 1016;
  static const int UnsignedShort5551Type = 1017;
  static const int UnsignedShort565Type = 1018;

  // Pixel Formats
  static const int AlphaFormat = 16;
  static const int RGBFormat = 17;
  static const int RGBAFormat = 18;
  static const int LuminanceFormat = 19;
  static const int LuminanceAlphaFormat = 20;

  // Compressed texture formats
  static const int RGB_S3TC_DXT1_Format = 2001;
  static const int RGBA_S3TC_DXT1_Format = 2002;
  static const int RGBA_S3TC_DXT3_Format = 2003;
  static const int RGBA_S3TC_DXT5_Format = 2004;


  Three() {
    GeometryCount = 0;
    Object3DCount = 0;
    // Material
    MaterialCount = 0;

    int _lastTime = 0;
    int _timeToCall;
    int _currTime;
  }
}





