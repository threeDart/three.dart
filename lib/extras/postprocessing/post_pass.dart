part of three_postprocessing;

abstract class PostPass {
  get enabled;
  get needsSwap;

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive);
}
