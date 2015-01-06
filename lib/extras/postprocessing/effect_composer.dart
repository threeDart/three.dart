part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class EffectComposer {

  WebGLRenderer renderer;
  WebGLRenderTarget renderTarget1;
  WebGLRenderTarget renderTarget2;
  WebGLRenderTarget writeBuffer;
  WebGLRenderTarget readBuffer;
  ShaderPass copyPass;
  List<PostPass> passes = new List<PostPass>();
  bool maskActive = false;

  EffectComposer(this.renderer, [WebGLRenderTarget renderTarget = null]) {

    if (renderTarget == null) {
      renderTarget = new WebGLRenderTarget(
          window.innerWidth,
          window.innerHeight,
          minFilter: LinearFilter,
          magFilter: LinearFilter,
          format: RGBFormat,
          stencilBuffer: false);
    }

    renderTarget1 = renderTarget;
    renderTarget2 = renderTarget.clone();

    writeBuffer = renderTarget1;
    readBuffer = renderTarget2;

    copyPass = new ShaderPass(new ShaderProgram.fromThreeish(CopyShader));
  }

  void swapBuffers() {
    var tmp = readBuffer;
    readBuffer = writeBuffer;
    writeBuffer = tmp;
  }

  void addPass(pass) => passes.add(pass);

  void insertPass(pass, index) => passes.insert(index, pass);

  void render(double delta) {

    writeBuffer = renderTarget1;
    readBuffer = renderTarget2;

    maskActive = false;

    passes.forEach((PostPass pass) {
      if (!pass.enabled) return;

      pass.render(renderer, writeBuffer, readBuffer, delta, maskActive);

      if (pass.needsSwap) {

        if (maskActive) {
          var context = renderer.context;

          context.stencilFunc(context.NOTEQUAL, 1, 0xffffffff);
          copyPass.render(renderer, writeBuffer, readBuffer, delta, maskActive);
          context.stencilFunc(context.EQUAL, 1, 0xffffffff);
        }

        swapBuffers();
      }

      if (pass is MaskPass) {
        maskActive = true;
      } else if (pass is ClearMaskPass) {
        maskActive = false;
      }
    });
  }

  void reset(WebGLRenderTarget renderTarget) {

    if (renderTarget == null) {

      renderTarget = renderTarget1.clone();

      renderTarget.width = window.innerWidth;
      renderTarget.height = window.innerHeight;
    }

    this.renderTarget1 = renderTarget;
    this.renderTarget2 = renderTarget.clone();

    this.writeBuffer = renderTarget1;
    this.readBuffer = renderTarget2;
  }

  void setSize(width, height) {

    var renderTarget = renderTarget1.clone();

    renderTarget.width = width;
    renderTarget.height = height;

    reset(renderTarget);
  }
}
