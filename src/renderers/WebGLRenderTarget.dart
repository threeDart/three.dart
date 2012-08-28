class WebGLRenderTarget { 

	num width, height;

	var wrapS, wrapT;

	var magFilter, minFilter;

	int anisotropy;

	Vector2 offset;
	Vector2 repeat;

	var format;
	var type;

	bool depthBuffer, 
		 stencilBuffer;

	bool generateMipmaps;
	
	var __webglTexture;
	
	WebGLRenderTarget ( this.width, this.height, 
						[ this.wrapS = Three.ClampToEdgeWrapping,
						  this.wrapT = Three.ClampToEdgeWrapping,
						  this.magFilter = Three.LinearFilter,
						  this.minFilter = Three.LinearMipMapLinearFilter,
						  this.anisotropy = 1,
						  this.format = Three.RGBAFormat,
						  this.type = Three.UnsignedByteType,
						  this.depthBuffer = true,
						  this.stencilBuffer = true,
						  this.offset = null, //new Vector2( 0, 0 ),
						  this.repeat = null, //new Vector2( 1, 1 ),
						  this.generateMipmaps = true
						] ) {
    if (offset == null) offset = new Vector2( 0, 0 );
    if (repeat == null) repeat = new Vector2( 1, 1 );
	}

  WebGLRenderTarget clone() => new WebGLRenderTarget( 
						width, 
						height ,

						wrapS: this.wrapS,
						wrapT: this.wrapT,

						magFilter: this.magFilter,
						anisotropy: this.anisotropy,

						minFilter: this.minFilter,

						offset: offset.clone(),
						repeat: repeat.clone(),

						format: this.format,
						type: this.type,

						depthBuffer: this.depthBuffer,
						stencilBuffer: this.stencilBuffer,

						generateMipmaps: this.generateMipmaps);

}