part of three;

class CompressedTexture extends Texture {
  var mipmaps;
  var images;
  CompressedTexture( {this.mipmaps, width, height, format, type, mapping, wrapS, wrapT, magFilter, minFilter} )
    : super ( null, mapping, wrapS, wrapT, magFilter, minFilter, format, type ),
      images = { "width": width, "height": height };
}
