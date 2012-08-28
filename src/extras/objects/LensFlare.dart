class LensFlare extends Object3D {
	List lensFlares;
	var customUpdateCallback;

	LensFlare(texture, size, distance, blending, color ) 
		: 	lensFlares = [], 
			customUpdateCallback = null, 
			super() {

		positionScreen = new THREE.Vector3();

		// TODO
		//if( texture !== undefined ) {
		//	add( texture, size, distance, blending, color );
		//}

	}

}