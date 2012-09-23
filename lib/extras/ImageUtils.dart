#library("ImageUtils");

#import("dart:html");
#import("dart:math", prefix:'Math');
#import("../ThreeD.dart");

var crossOrigin = 'anonymous';

Texture loadTexture ( url, [mapping, onLoad, onError] ) {

	var image = new ImageElement();
	var texture = new Texture( image, mapping );

	var loader = new ImageLoader();

	loader.addEventListener( 'load', function ( event ) {

		texture.image = event.content;
		texture.needsUpdate = true;

		if ( onLoad != null ) onLoad( texture );

	} );

	loader.addEventListener( 'error', function ( event ) {

		if ( onError != null ) onError( event.message );

	} );

	loader.crossOrigin = crossOrigin;
	loader.load( url, image );

	return texture;

}

Texture loadTextureCube ( array, mapping, onLoad ) {

	var i, l;
	List<ImageElement> images = [];
	
	var texture = new Texture( images, mapping );

	texture.flipY = false;

	images.dynamic.loadCount = 0;

	l = array.length;
	for ( i = 0; i < l; ++ i ) {

		images[ i ] = new ImageElement();
		images[ i ].on.load.add((_) {

			images.dynamic.loadCount += 1;

			if ( images.dynamic.loadCount === 6 ) {

				texture.needsUpdate = true;
				if ( onLoad != null ) onLoad();

			}

		});

		images[ i ].crossOrigin = crossOrigin;
		images[ i ].src = array[ i ];

	}

	return texture;

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

	var context = canvas.context2d;
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
	var data = new Uint8Array( 3 * size );

	var r = ( color.r * 255 ).floor();
	var g = ( color.g * 255 ).floor();
	var b = ( color.b * 255 ).floor();

	for ( var i = 0; i < size; i ++ ) {

		data[ i * 3 ] 	  = r;
		data[ i * 3 + 1 ] = g;
		data[ i * 3 + 2 ] = b;

	}

	var texture = new DataTexture( data, width, height, Three.RGBFormat );
	texture.needsUpdate = true;

	return texture;

}