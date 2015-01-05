part of three;

class WebGLRenderTargetCube extends WebGLRenderTarget {

  int activeCubeFace; // PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5

  WebGLRenderTargetCube( num width, num height,
           {  int wrapS: ClampToEdgeWrapping,
              int wrapT: ClampToEdgeWrapping,
              int magFilter: LinearFilter,
              int minFilter: LinearMipMapLinearFilter,
              int anisotropy: 1,
              int format: RGBAFormat,
              int type: UnsignedByteType,
              bool depthBuffer: true,
              bool stencilBuffer: true
           } ) : activeCubeFace = 0,
            super(width, height,
                wrapS: wrapS,
                wrapT: wrapT,
                magFilter: magFilter,
                minFilter: minFilter,
                anisotropy: anisotropy,
                format: format,
                type: type,
                depthBuffer: depthBuffer,
                stencilBuffer: stencilBuffer);

}
