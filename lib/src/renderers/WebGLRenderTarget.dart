part of three;

class WebGLRenderTarget extends Texture {

	num width, height;

	Vector2 offset;
	Vector2 repeat;

	bool depthBuffer,
		 stencilBuffer;

	bool generateMipmaps;

	var __webglFramebuffer; // List<WebGLFramebuffer> or WebGLFramebuffer
	var __webglRenderbuffer; // List<WebGLRenderbuffer> or WebGLRenderbuffer

	WebGLRenderTarget ( this.width, this.height, {
	  int wrapS: ClampToEdgeWrapping,
	  int wrapT: ClampToEdgeWrapping,
	  int magFilter: LinearFilter,
	  int minFilter: LinearMipMapLinearFilter,
	  int anisotropy: 1,
	  int format: RGBAFormat,
	  int type: UnsignedByteType,
	  this.depthBuffer: true,
	  this.stencilBuffer: true,
	  this.offset: null, //new Vector2( 0, 0 ),
	  this.repeat: null, //new Vector2( 1, 1 ),
	  this.generateMipmaps: true
	} ) : super(null, null, wrapS, wrapT, magFilter, minFilter, format, type, anisotropy){
    if (offset == null) offset = new Vector2( 0, 0 );
    if (repeat == null) repeat = new Vector2( 1, 1 );
	}

	gl.Texture get __webglTexture => this["__webglTexture"];
  set __webglTexture(gl.Texture tex) { this["__webglTexture"] = tex; }

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