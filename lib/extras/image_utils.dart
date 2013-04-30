library ImageUtils;

import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";

import "package:three/three.dart";

var crossOrigin = 'anonymous';

Texture loadTexture ( url, {mapping, onLoad, onError} ) {

	var image = new ImageElement();
	var texture = new Texture( image, mapping );

	var loader = new ImageLoader();

	loader.addEventListener( 'load',  ( event ) {

		texture.image = event.content;
		texture.needsUpdate = true;

		if ( onLoad != null ) onLoad( texture );

	} );

	loader.addEventListener( 'error',  ( event ) {

		if ( onError != null ) onError( event.message );

	} );

	loader.crossOrigin = crossOrigin;
	loader.load( url, image );

	return texture;

}

Texture loadCompressedTexture( url, {mapping, onLoad, onError} ) {

  var texture = new CompressedTexture();
  texture.mapping = mapping;

  var request = new HttpRequest();

  request.onLoad.listen( (Event e) {

    var buffer = request.response;
    var dds = parseDDS( buffer, true );

    texture.format = dds["format"];

    texture.mipmaps = dds["mipmaps"];
    texture.image.width = dds["width"];
    texture.image.height = dds["height"];

    // gl.generateMipmap fails for compressed textures
    // mipmaps must be embedded in the DDS file
    // or texture filters must not use mipmapping

    texture.generateMipmaps = false;

    texture.needsUpdate = true;

    if ( onLoad ) onLoad( texture );

  });

  request.onError.listen(onError);

  request.open( 'GET', url, async: true );
  request.responseType = "arraybuffer";
  request.send( null );

  return texture;

}


Texture loadTextureCube ( array, [mapping = null, onLoad ]) {

	var i, l;
	l = array.length;
	ImageList images = new ImageList(l);
	var texture = new Texture( images );
	mapping = (mapping == null)? texture.mapping:mapping;

	texture.flipY = false;

	images.loadCount = 0;

	for ( i = 0; i < l; ++ i ) {

		images[ i ] = new ImageElement();
		images[ i ].onLoad.listen((_) {

		  images.loadCount += 1;

			if ( images.loadCount == 6 ) {

				texture.needsUpdate = true;
				if ( onLoad != null ) onLoad();

			}

		});

		images[ i ].crossOrigin = crossOrigin;
		images[ i ].src = array[ i ];

	}

	return texture;

}

parseDDS( buffer, loadMipmaps ) {

  var dds = { "mipmaps": [], "width": 0, "height": 0, "format": null, "mipmapCount": 1 };

  // Adapted from @toji's DDS utils
  //  https://github.com/toji/webgl-texture-utils/blob/master/texture-util/dds.js

  // All values and structures referenced from:
  // http://msdn.microsoft.com/en-us/library/bb943991.aspx/

  var DDS_MAGIC = 0x20534444;

  var DDSD_CAPS = 0x1,
    DDSD_HEIGHT = 0x2,
    DDSD_WIDTH = 0x4,
    DDSD_PITCH = 0x8,
    DDSD_PIXELFORMAT = 0x1000,
    DDSD_MIPMAPCOUNT = 0x20000,
    DDSD_LINEARSIZE = 0x80000,
    DDSD_DEPTH = 0x800000;

  var DDSCAPS_COMPLEX = 0x8,
    DDSCAPS_MIPMAP = 0x400000,
    DDSCAPS_TEXTURE = 0x1000;

  var DDSCAPS2_CUBEMAP = 0x200,
    DDSCAPS2_CUBEMAP_POSITIVEX = 0x400,
    DDSCAPS2_CUBEMAP_NEGATIVEX = 0x800,
    DDSCAPS2_CUBEMAP_POSITIVEY = 0x1000,
    DDSCAPS2_CUBEMAP_NEGATIVEY = 0x2000,
    DDSCAPS2_CUBEMAP_POSITIVEZ = 0x4000,
    DDSCAPS2_CUBEMAP_NEGATIVEZ = 0x8000,
    DDSCAPS2_VOLUME = 0x200000;

  var DDPF_ALPHAPIXELS = 0x1,
    DDPF_ALPHA = 0x2,
    DDPF_FOURCC = 0x4,
    DDPF_RGB = 0x40,
    DDPF_YUV = 0x200,
    DDPF_LUMINANCE = 0x20000;

  fourCCToInt32( value ) {

    return value.charCodeAt(0) +
      (value.charCodeAt(1) << 8) +
      (value.charCodeAt(2) << 16) +
      (value.charCodeAt(3) << 24);

  }

  int32ToFourCC( value ) {

    return new String.fromCharCodes([
      value & 0xff,
      (value >> 8) & 0xff,
      (value >> 16) & 0xff,
      (value >> 24) & 0xff
    ]);
  }

  var FOURCC_DXT1 = fourCCToInt32("DXT1");
  var FOURCC_DXT3 = fourCCToInt32("DXT3");
  var FOURCC_DXT5 = fourCCToInt32("DXT5");

  var headerLengthInt = 31; // The header length in 32 bit ints

  // Offsets into the header array

  var off_magic = 0;

  var off_size = 1;
  var off_flags = 2;
  var off_height = 3;
  var off_width = 4;

  var off_mipmapCount = 7;

  var off_pfFlags = 20;
  var off_pfFourCC = 21;

  // Parse header

  var header = new Int32List.view(buffer, 0, headerLengthInt);

  if ( header[ off_magic ] != DDS_MAGIC ) {
      print( "ImageUtils.parseDDS(): Invalid magic number in DDS header" );
      return dds;
  }

  if ( (header[ off_pfFlags ] & DDPF_FOURCC) == 0 ) {
      print( "ImageUtils.parseDDS(): Unsupported format, must contain a FourCC code" );
      return dds;
  }

  var blockBytes;

  var fourCC = header[ off_pfFourCC ];

  if( fourCC == FOURCC_DXT1 ) {
      blockBytes = 8;
      dds["format"] = RGB_S3TC_DXT1_Format;
  } else if(fourCC == FOURCC_DXT3) {
      blockBytes = 16;
      dds["format"] = RGBA_S3TC_DXT3_Format;
  } else if(fourCC == FOURCC_DXT5) {
      blockBytes = 16;
      dds["format"] = RGBA_S3TC_DXT5_Format;
  } else {
      print( "ImageUtils.parseDDS(): Unsupported FourCC code: ${int32ToFourCC( fourCC )}" );
  }

  dds["mipmapCount"] = 1;

  if ( ( (header[ off_flags ] & DDSD_MIPMAPCOUNT) != 0) && (loadMipmaps != false) ) {
      dds["mipmapCount"] = Math.max( 1, header[ off_mipmapCount ] );
  }

  dds["width"] = header[ off_width ];
  dds["height"] = header[ off_height ];

  var dataOffset = header[ off_size ] + 4;

  // Extract mipmaps buffers

  var width = dds["width"];
  var height = dds["height"];

  for ( var i = 0; i < dds["mipmapCount"]; i ++ ) {

    int dataLength = Math.max( 4, width ) ~/ 4 * Math.max( 4, height ) ~/ 4 * blockBytes;
    var byteArray = new Uint8List.view(buffer, dataOffset, dataLength);

    var mipmap = { "data": byteArray, "width": width, "height": height };
    dds["mipmaps"].add( mipmap );

    dataOffset += dataLength;

    width = Math.max( width * 0.5, 1 );
    height = Math.max( height * 0.5, 1 );

  }

  return dds;

}

getNormalMap ( image, depth ) {

	// Adapted from http://www.paulbrunt.co.uk/lab/heightnormal/

	var cross = ( a, b ) {

		return [ a[ 1 ] * b[ 2 ] - a[ 2 ] * b[ 1 ], a[ 2 ] * b[ 0 ] - a[ 0 ] * b[ 2 ], a[ 0 ] * b[ 1 ] - a[ 1 ] * b[ 0 ] ];

	};

	var subtract = ( a, b ) {

		return [ a[ 0 ] - b[ 0 ], a[ 1 ] - b[ 1 ], a[ 2 ] - b[ 2 ] ];

	};

	var normalize = ( a ) {

		var l = Math.sqrt( a[ 0 ] * a[ 0 ] + a[ 1 ] * a[ 1 ] + a[ 2 ] * a[ 2 ] );
		return [ a[ 0 ] / l, a[ 1 ] / l, a[ 2 ] / l ];

	};

	depth = depth | 1;

	var width = image.width;
	var height = image.height;

	var canvas = new CanvasElement();;
	canvas.width = width;
	canvas.height = height;

	var context = canvas.context2D;
	context.drawImage( image, 0, 0 );

	var data = context.getImageData( 0, 0, width, height ).data;
	var imageData = context.createImageData( width, height );
	var output = imageData.data;

	for ( var x = 0; x < width; x ++ ) {

		for ( var y = 0; y < height; y ++ ) {

			num ly = y - 1 < 0 ? 0 : y - 1;
			num uy = y + 1 > height - 1 ? height - 1 : y + 1;
			num lx = x - 1 < 0 ? 0 : x - 1;
			num ux = x + 1 > width - 1 ? width - 1 : x + 1;

			var points = [];
			var origin = [ 0, 0, data[ ( y * width + x ) * 4 ] / 255 * depth ];
			points.add( [ - 1, 0, data[ ( y * width + lx ) * 4 ] / 255 * depth ] );
			points.add( [ - 1, - 1, data[ ( ly * width + lx ) * 4 ] / 255 * depth ] );
			points.add( [ 0, - 1, data[ ( ly * width + x ) * 4 ] / 255 * depth ] );
			points.add( [  1, - 1, data[ ( ly * width + ux ) * 4 ] / 255 * depth ] );
			points.add( [ 1, 0, data[ ( y * width + ux ) * 4 ] / 255 * depth ] );
			points.add( [ 1, 1, data[ ( uy * width + ux ) * 4 ] / 255 * depth ] );
			points.add( [ 0, 1, data[ ( uy * width + x ) * 4 ] / 255 * depth ] );
			points.add( [ - 1, 1, data[ ( uy * width + lx ) * 4 ] / 255 * depth ] );

			List<List> normals = [];
			var num_points = points.length;

			for ( var i = 0; i < num_points; i ++ ) {

				var v1 = points[ i ];
				var v2 = points[ ( i + 1 ) % num_points ];
				v1 = subtract( v1, origin );
				v2 = subtract( v2, origin );
				normals.add( normalize( cross( v1, v2 ) ) );

			}

			List<num> normal = [ 0, 0, 0 ];

			for ( var i = 0; i < normals.length; i ++ ) {

				normal[ 0 ] += normals[ i ][ 0 ];
				normal[ 1 ] += normals[ i ][ 1 ];
				normal[ 2 ] += normals[ i ][ 2 ];

			}

			normal[ 0 ] /= normals.length;
			normal[ 1 ] /= normals.length;
			normal[ 2 ] /= normals.length;

			var idx = ( y * width + x ) * 4;

			output[ idx ] = ( ( normal[ 0 ] + 1.0 ) / 2.0 * 255 ).toInt() | 0;
			output[ idx + 1 ] = ( ( normal[ 1 ] + 1.0 ) / 2.0 * 255 ).toInt() | 0;
			output[ idx + 2 ] = ( normal[ 2 ] * 255 ).toInt() | 0;
			output[ idx + 3 ] = 255;

		}

	}

	context.putImageData( imageData, 0, 0 );

	return canvas;

}

generateDataTexture( width, height, color ) {

	var size = width * height;
	var data = new Uint8List( 3 * size );

	var r = ( color.r * 255 ).floor();
	var g = ( color.g * 255 ).floor();
	var b = ( color.b * 255 ).floor();

	for ( var i = 0; i < size; i ++ ) {

		data[ i * 3 ] 	  = r;
		data[ i * 3 + 1 ] = g;
		data[ i * 3 + 2 ] = b;

	}

	var texture = new DataTexture( data, width, height, RGBFormat );
	texture.needsUpdate = true;

	return texture;

}