part of three;

class DataTexture extends Texture {

  DataTexture._internal( image, data, width, height, format, [type, mapping, wrapS, wrapT, magFilter, minFilter] )
  : super(image, mapping, wrapS, wrapT, magFilter, minFilter, format, type ) ;

  factory DataTexture ( data, width, height, format, {type, mapping, wrapS, wrapT, magFilter, minFilter} ) {
		  return new DataTexture._internal(
		      { "data": data, "width": width, "height": height },
		      data, width, height, format, type, mapping, wrapS, wrapT, magFilter, minFilter);
		}

}