part of ThreeD;

class WebGLRenderTargetCube extends WebGLRenderTarget {

	int activeCubeFace; // PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5

	WebGLRenderTargetCube( num width, num height,
						[ wrapS = Three.ClampToEdgeWrapping,
						  wrapT = Three.ClampToEdgeWrapping,
						  magFilter = Three.LinearFilter,
						  minFilter = Three.LinearMipMapLinearFilter,
						  anisotropy = 1,
						  format = Three.RGBAFormat,
						  type = Three.UnsignedByteType,
						  depthBuffer = true,
						  stencilBuffer = true
						] ) : activeCubeFace = 0,
						super(width,height,
						 wrapS,
						  wrapT,
						  magFilter,
						  minFilter,
						  anisotropy,
						  format,
						  type,
						  depthBuffer,
						  stencilBuffer);

}
