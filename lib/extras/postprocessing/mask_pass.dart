part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class ClearMaskPass implements PostPass {
  bool enabled = true;
  bool needsSwap = true;

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive) {
    renderer.context.disable(RenderingContext.STENCIL_TEST);
  }
}

class MaskPass {
  Scene scene;
  Camera camera;
  bool enabled = true;
  bool clear = true;
  bool needsSwap = false;
  bool inverse = false;

  MaskPass(this.scene, this.camera);

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive) {

    RenderingContext context = renderer.context;

    // don't update color or depth
    context.colorMask(false, false, false, false);
    context.depthMask(false);

    // set up stencil
    int writeValue = (inverse == true) ? 0 : 1;
    int clearValue = (inverse == true) ? 1 : 0;

    context.enable(RenderingContext.STENCIL_TEST);
    context.stencilOp(
        RenderingContext.REPLACE,
        RenderingContext.REPLACE,
        RenderingContext.REPLACE);
    context.stencilFunc(RenderingContext.ALWAYS, writeValue, 0xffffffff);
    context.clearStencil(clearValue);

    // draw into the stencil buffer
    renderer.renderToTarget(scene, camera, readBuffer, clear);
    renderer.renderToTarget(scene, camera, writeBuffer, clear);

    // re-enable update of color and depth
    context.colorMask(true, true, true, true);
    context.depthMask(true);

    // only render where stencil is set to 1
    context.stencilFunc(RenderingContext.EQUAL, 1, 0xffffffff); // draw if == 1
    context.stencilOp(
        RenderingContext.KEEP,
        RenderingContext.KEEP,
        RenderingContext.KEEP);
  }
}
