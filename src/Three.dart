/**
 * @author mr.doob / http://mrdoob.com/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Three {
  num lastTime;
  List<String> vendors;
  
  // from Geometry
  static int GeometryCount = 0;
  
  // from Object3D
  static int Object3DCount = 0;
  
  // from Material
  static int MaterialCount = 0;
  // think these ones are actually consts?
  static int NoShading = 0;
  static int FlatShading = 1;
  static int SmoothShading = 2;

  static int NoColors = 0;
  static int FaceColors = 1;
  static int VertexColors = 2;

  static int NormalBlending = 0;
  static int AdditiveBlending = 1;
  static int SubtractiveBlending = 2;
  static int MultiplyBlending = 3;
  static int AdditiveAlphaBlending = 4;
  
  // from MeshBasicMaterial
  //static var MultiplyOperation;
  
  // from Texture
  static int TextureCount = 0;

  static int MultiplyOperation = 0;
  static int MixOperation = 1;
  //TODO: figure out what needs to happen with these functions
  // Mapping modes
  static var CubeReflectionMapping;//();
  static var CubeRefractionMapping;//();

  static var LatitudeReflectionMapping;//();
  static var LatitudeRefractionMapping;//();

  static var SphericalReflectionMapping;//();
  static var SphericalRefractionMapping;//();

  static var UVMapping;//();

  // Wrapping modes
  static int RepeatWrapping = 0;
  static int ClampToEdgeWrapping = 1;
  static int MirroredRepeatWrapping = 2;

  // Filters
  static int NearestFilter = 3;
  static int NearestMipMapNearestFilter = 4;
  static int NearestMipMapLinearFilter = 5;
  static int LinearFilter = 6;
  static int LinearMipMapNearestFilter = 7;
  static int LinearMipMapLinearFilter = 8;

  // Types
  static int ByteType = 9;
  static int UnsignedByteType = 10;
  static int ShortType = 11;
  static int UnsignedShortType = 12;
  static int IntType = 13;
  static int UnsignedIntType = 14;
  static int FloatType = 15;

  // Formats
  static int AlphaFormat = 16;
  static int RGBFormat = 17;
  static int RGBAFormat = 18;
  static int LuminanceFormat = 19;
  static int LuminanceAlphaFormat = 20;  
  
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







