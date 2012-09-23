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
  static final int LineStrip = 0;
  static final int LinePieces = 1;
  
  // from Geometry
  static int GeometryCount = 0;
  
  // from Object3D
  static int Object3DCount = 0;
  
  // from Material
  static int MaterialCount = 0;

  // MATERIAL CONSTANTS

  // side
  static final int FrontSide = 0;
  static final int BackSide = 1;
  static final int DoubleSide = 2;

  static final int NoShading = 0;
  static final int FlatShading = 1;
  static final int SmoothShading = 2;

  static final int NoColors = 0;
  static final int FaceColors = 1;
  static final int VertexColors = 2;

  // blending modes

 static final int NoBlending = 0;
 static final int NormalBlending = 1;
 static final int AdditiveBlending = 2;
 static final int SubtractiveBlending = 3;
 static final int MultiplyBlending = 4;
 static final int CustomBlending = 5;
  
  // custom blending equations
// (numbers start from 100 not to clash with other
//  mappings to OpenGL constants defined in Texture.js)

 static final int AddEquation = 100;
 static final int SubtractEquation = 101;
 static final int ReverseSubtractEquation = 102;

 // custom blending destination factors

 static final int ZeroFactor = 200;
 static final int OneFactor = 201;
 static final int SrcColorFactor = 202;
 static final int OneMinusSrcColorFactor = 203;
 static final int SrcAlphaFactor = 204;
 static final int OneMinusSrcAlphaFactor = 205;
 static final int DstAlphaFactor = 206;
 static final int OneMinusDstAlphaFactor = 207;

// custom blending source factors

 static final int DstColorFactor = 208;
 static final int OneMinusDstColorFactor = 209;
 static final int SrcAlphaSaturateFactor = 210;

  // from MeshBasicMaterial
  
  // from Texture
  static int TextureCount = 0;

  static final int MultiplyOperation = 0;
  static final int MixOperation = 1;

  static var UVMapping;//();

  // Wrapping modes
  static final int RepeatWrapping = 0;
  static final int ClampToEdgeWrapping = 1;
  static final int MirroredRepeatWrapping = 2;

  // Filters
  static final int NearestFilter = 3;
  static final int NearestMipMapNearestFilter = 4;
  static final int NearestMipMapLinearFilter = 5;
  static final int LinearFilter = 6;
  static final int LinearMipMapNearestFilter = 7;
  static final int LinearMipMapLinearFilter = 8;

  // Types
  static final int ByteType = 9;
  static final int UnsignedByteType = 10;
  static final int ShortType = 11;
  static final int UnsignedShortType = 12;
  static final int IntType = 13;
  static final int UnsignedIntType = 14;
  static final int FloatType = 15;

  static final int UnsignedShort4444Type = 1016;
  static final int UnsignedShort5551Type = 1017;
  static final int UnsignedShort565Type = 1018;

  // Formats
  static final int AlphaFormat = 16;
  static final int RGBFormat = 17;
  static final int RGBAFormat = 18;
  static final int LuminanceFormat = 19;
  static final int LuminanceAlphaFormat = 20;  
  
  Three()
  {
    GeometryCount = 0;
    Object3DCount = 0;
    // Material
    MaterialCount = 0;

    int _lastTime = 0;
    int _timeToCall;
    int _currTime;
//    var _callback;
    /*
    vendors = new List();
    vendors.addAll(['ms', 'moz', 'webkit', 'o']);
    
    int requestAnimationFrame;
    int cancelAnimationFrame;
    
    // loop through browser vendors checking for requestAnimationFrame or cancelAnimationFrame properties

    for(int x = 0; x < vendors.length && !window.dynamic['requestAnimationFrame']; ++x) 
    {
      window.dynamic['requestAnimationFrame'] = window.dynamic[vendors[x]+'RequestAnimationFrame'];
      window.dynamic['cancelAnimationFrame'] = window.dynamic[vendors[x]+'CancelAnimationFrame'] 
                                 || window.dynamic[vendors[x]+'RequestCancelAnimationFrame'];
    };
   
    if (!window.dynamic['requestAnimationFrame'])
        window.dynamic['requestAnimationFrame'] = function(callback, element) {
            var currTime = new Date.now().value;
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var func = function() { callback(currTime + timeToCall); };
            var id = window.setTimeout(func, timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };
 
    if (!window.dynamic['cancelAnimationFrame'])
        window.dynamic['cancelAnimationFrame'] = function(id) {
            window.clearTimeout(id);
        };
        */
    /*
    if ( ! window.dynamic['requestAnimationFrame'] )
    {
      window.dynamic['requestAnimationFrame'] = ( function () 
      {
        int no = (1000 / 60).toInt();
        var func = function ( callback, element ) {
          window.setTimeout( callback, no );
        };
        return window.dynamic['webkitRequestAnimationFrame'] ||
        window.dynamic['mozRequestAnimationFrame'] ||
        window.dynamic['oRequestAnimationFrame'] ||
        window.dynamic['msRequestAnimationFrame'] ||
        func;
      } )();
    }
    */
  }
}





