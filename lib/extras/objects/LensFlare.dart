part of three;

class LensFlare extends Object3D {
	List lensFlares;
	var customUpdateCallback;

	Vector3 positionScreen;

	LensFlare(texture, size, distance, blending, color )
		: 	lensFlares = [],
			customUpdateCallback = null,
			super() {

		positionScreen = new Vector3();

		// TODO
		//if( texture != undefined ) {
		//	add( texture, size, distance, blending, color );
		//}

	}

}