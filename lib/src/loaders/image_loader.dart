part of three;

class ImageLoader extends EventEmitter {

	String crossOrigin;

	ImageLoader() : crossOrigin = null, super();

	load( String url, [ImageElement image = null] ) {

		if ( image == null ) image = new ImageElement();

		image.onLoad.listen((_) {
			dispatchEvent( new EventEmitterEvent(type: 'load', content: image) );
		});

		image.onError.listen( (_) {
			dispatchEvent( new EventEmitterEvent(type: 'error', message: "Couldn\'t load URL [$url]" ) );
		});

		if ( crossOrigin != null ) image.crossOrigin = crossOrigin;

		image.src = url;

	}

}