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
  var _image;
  var _mapping; //UVMapping appears to be missing..
  int _wrapS, _wrapT, _magFilter, _minFilter, _format, _type;
  Vector2 _offset, _repeat;
  bool _generateMipmaps, _needsUpdate;
  var _onUpdate;
  
  Vector2 get offset() {  return _offset;  }
  Vector2 get repeat() {  return _repeat;  }
  Dynamic get mapping() {  return _mapping;  }
  
  
  //TODO: resolve dynamic vars, find out what UVMapping is!
  Texture( Dynamic image, Dynamic mapping, int wrapS, int wrapT, int magFilter, int minFilter, int format, int type )
  {
    _id = Three.TextureCount ++;

    _image = image;

    //UVMapping _mapping = mapping !== null ? mapping : new UVMapping();
    _mapping = mapping !== null ? mapping : null;//new UVMapping();
    
    _wrapS = wrapS !== null ? wrapS : Three.ClampToEdgeWrapping;
    _wrapT = wrapT !== null ? wrapT : Three.ClampToEdgeWrapping;

    _magFilter = magFilter !== null ? magFilter : Three.LinearFilter;
    _minFilter = minFilter !== null ? minFilter : Three.LinearMipMapLinearFilter;

    _format = format !== null ? format : Three.RGBAFormat;
    _type = type !== null ? type : Three.UnsignedByteType;

    _offset = new Vector2( 0, 0 );
    _repeat = new Vector2( 1, 1 );

    _generateMipmaps = true;

    _needsUpdate = false;
    _onUpdate = null;
  }

  Texture clone()
  {
    Texture clonedTexture = new Texture( _image, _mapping, _wrapS, _wrapT, _magFilter, _minFilter, _format, _type );

    clonedTexture.offset.copy( _offset );
    clonedTexture.repeat.copy( _repeat );

    return clonedTexture;
  }
  
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
