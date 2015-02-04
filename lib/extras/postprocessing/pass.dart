part of three_postprocessing;

abstract class Pass {
  get enabled;
  get needsSwap;

  void render(WebGLRenderer renderer, WebGLRenderTarget writeTarget, WebGLRenderTarget readTarget, double delta,
      bool maskActive);
}
