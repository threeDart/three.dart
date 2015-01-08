part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class EffectComposer {

  WebGLRenderer renderer;
  WebGLRenderTarget readTarget;
  WebGLRenderTarget writeTarget;
  ShaderPass copyPass;
  List<Pass> passes = new List<Pass>();
  bool maskActive = false;

  EffectComposer(this.renderer, [WebGLRenderTarget target = null]) {
    this.renderer.autoClear = false;

    if (target == null) {
      target = new WebGLRenderTarget(
          window.innerWidth,
          window.innerHeight,
          minFilter: LinearFilter,
          magFilter: LinearFilter,
          format: RGBFormat,
          stencilBuffer: false);
    }
    writeTarget = target;
    readTarget = target.clone();
    copyPass = new ShaderPass(new ShaderProgram.fromThreeish(CopyShader));
  }

  void swapBuffers() {
    var tmp = readTarget;
    readTarget = writeTarget;
    writeTarget = tmp;
  }

  void addPass(pass) => passes.add(pass);

  void insertPass(pass, index) => passes.insert(index, pass);

  void render(double delta) {

    maskActive = false;

    passes.forEach((Pass pass) {
      if (!pass.enabled) return;

      pass.render(renderer, writeTarget, readTarget, delta, maskActive);

      if (pass.needsSwap) {

        if (maskActive) {
          var context = renderer.context;

          context.stencilFunc(context.NOTEQUAL, 1, 0xffffffff);
          copyPass.render(renderer, writeTarget, readTarget, delta, maskActive);
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

  void reset([WebGLRenderTarget target = null, int width, int height]) {

    if (width == null) {
      width = window.innerWidth;
    }
    if (height = null) {
      height = window.innerHeight;
    }
    if (target == null) {
      target = new WebGLRenderTarget(
          width,
          height,
          minFilter: LinearFilter,
          magFilter: LinearFilter,
          format: RGBFormat,
          stencilBuffer: false);
    }
    writeTarget = target;
    readTarget = target.clone();
  }
}
