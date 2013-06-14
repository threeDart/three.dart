part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author szimek / https://github.com/szimek/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class ImageList {
  int loadCount;
  List<ImageElement> _images;
  Map<String,dynamic> props;

  ImageList(size): props = {},_images = new List<ImageElement>(size);

  ImageElement operator [](int index) => _images[index];
  void operator []=(int index, ImageElement img) { _images[index] = img; }
  int get length => _images.length;
  List<ImageElement> getRange(int start, int length) => _images.getRange(start, length);

}

class Texture {
  int id;
  var image;
  var mapping; //UVMapping appears to be missing..
  int wrapS, wrapT, magFilter, minFilter, format, type, anisotropy;
  Vector2 offset, repeat;
  bool generateMipmaps;
  bool premultiplyAlpha;

  bool needsUpdate;
  var onUpdate;

  bool flipY;

  int unpackAlignment = 4; // valid values: 1, 2, 4, 8 (see http://www.khronos.org/opengles/sdk/docs/man/xhtml/glPixelStorei.xml)

  List mipmaps = [];

  //TODO: resolve dynamic vars, find out what UVMapping is!
  Texture( [  this.image,
              this.mapping = null,
              this.wrapS = ClampToEdgeWrapping,
              this.wrapT = ClampToEdgeWrapping,
              this.magFilter = LinearFilter,
              this.minFilter = LinearMipMapLinearFilter,
              this.format = RGBAFormat,
              this.type = UnsignedByteType,
              this.anisotropy = 1] )
  {
    id = TextureCount ++;

    this.mapping = mapping != null ? mapping : new UVMapping();

    offset = new Vector2.zero();
    repeat = new Vector2( 1.0, 1.0 );

    generateMipmaps = true;
    premultiplyAlpha = false;
    flipY = true;

    needsUpdate = false;
    onUpdate = null;
  }

  Texture clone() {
    Texture clonedTexture = new Texture( image, mapping, wrapS, wrapT, magFilter, minFilter, format, type, anisotropy );

    clonedTexture.mipmaps = new List.from( mipmaps );
    clonedTexture.offset.setFrom( offset );
    clonedTexture.repeat.setFrom( repeat );

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
}
