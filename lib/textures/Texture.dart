/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author szimek / https://github.com/szimek/
 * 
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Texture 
{
  int _id;
  var image;
  var _mapping; //UVMapping appears to be missing..
  int wrapS, wrapT, magFilter, minFilter, format, type, anisotropy;
  Vector2 offset, repeat;
  bool generateMipmaps;
  bool premultiplyAlpha;
  
  bool needsUpdate;
  var onUpdate;
  
  bool flipY;
  
  Dynamic get mapping {  return _mapping;  }
  
  
  //TODO: resolve dynamic vars, find out what UVMapping is!
  Texture( [  this.image, 
              Dynamic mapping = null, 
              this.wrapS = Three.ClampToEdgeWrapping,
              this.wrapT = Three.ClampToEdgeWrapping,
              this.magFilter = Three.LinearFilter,
              this.minFilter = Three.LinearMipMapLinearFilter,
              this.format = Three.RGBAFormat,
              this.type = Three.UnsignedByteType,
              this.anisotropy = 1] )
  {
    _id = Three.TextureCount ++;

    //UVMapping _mapping = mapping !== null ? mapping : new UVMapping();
    _mapping = mapping !== null ? mapping : null;//new UVMapping();

    offset = new Vector2( 0, 0 );
    repeat = new Vector2( 1, 1 );

    generateMipmaps = true;
    premultiplyAlpha = false;
    flipY = true;
    
    needsUpdate = false;
    onUpdate = null;
  }

  Texture clone()
  {
    Texture clonedTexture = new Texture( image, _mapping, wrapS, wrapT, magFilter, minFilter, format, type, anisotropy );

    clonedTexture.offset.copy( offset );
    clonedTexture.repeat.copy( repeat );

    return clonedTexture;
  }
  
  // Quick hack to allow setting new properties (used by the renderer)
  Map __data;
  
  get _data {
    if (__data == null) {
      __data = {};
    }
    return __data;
  }
  
  operator [] (String key) => _data[key];
  operator []= (String key, value) => _data[key] = value;
  
/*
  THREE.TextureCount = 0;

  THREE.MultiplyOperation = 0;
  THREE.MixOperation = 1;

  // Mapping modes

  THREE.CubeReflectionMapping = function () {};
  THREE.CubeRefractionMapping = function () {};

  THREE.LatitudeReflectionMapping = function () {};
  THREE.LatitudeRefractionMapping = function () {};

  THREE.SphericalReflectionMapping = function () {};
  THREE.SphericalRefractionMapping = function () {};

  THREE.UVMapping = function () {};

  // Wrapping modes

  THREE.RepeatWrapping = 0;
  THREE.ClampToEdgeWrapping = 1;
  THREE.MirroredRepeatWrapping = 2;

  // Filters

  THREE.NearestFilter = 3;
  THREE.NearestMipMapNearestFilter = 4;
  THREE.NearestMipMapLinearFilter = 5;
  THREE.LinearFilter = 6;
  THREE.LinearMipMapNearestFilter = 7;
  THREE.LinearMipMapLinearFilter = 8;

  // Types

  THREE.ByteType = 9;
  THREE.UnsignedByteType = 10;
  THREE.ShortType = 11;
  THREE.UnsignedShortType = 12;
  THREE.IntType = 13;
  THREE.UnsignedIntType = 14;
  THREE.FloatType = 15;

  // Formats

  THREE.AlphaFormat = 16;
  THREE.RGBFormat = 17;
  THREE.RGBAFormat = 18;
  THREE.LuminanceFormat = 19;
  THREE.LuminanceAlphaFormat = 20;
*/
}
