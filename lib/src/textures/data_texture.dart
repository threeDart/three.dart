part of three;

class DataTexture extends Texture {

  DataTexture._internal( image, data, width, height, format, [type, mapping, wrapS, wrapT, magFilter, minFilter] )
  : super(image, mapping, wrapS, wrapT, magFilter, minFilter, format, type ) ;

  factory DataTexture ( data, width, height, format, {type:UnsignedByteType, mapping, wrapS:ClampToEdgeWrapping, wrapT:ClampToEdgeWrapping, magFilter:LinearFilter, minFilter:LinearMipMapLinearFilter} ) {
      return new DataTexture._internal(
          new DataImage(data,width,height),
          data, width, height, format, type, mapping, wrapS, wrapT, magFilter, minFilter);
    }

}

class DataImage {
  var data;
  int width,height;
  
  DataImage(var data,int width,int height) {
    this.data = data;
		this.width = width;
		this.height = height;
	}
}
