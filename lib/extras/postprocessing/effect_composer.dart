part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class EffectComposer {
// shared static fields
  static final OrthographicCamera camera =
      new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
  static final Mesh quad = new Mesh(new PlaneGeometry(2.0, 2.0), null);
  static final Scene scene = new Scene()..add(quad);

  WebGLRenderer renderer;
  WebGLRenderTarget renderTarget1;
  WebGLRenderTarget renderTarget2;
  WebGLRenderTarget writeBuffer;
  WebGLRenderTarget readBuffer;
  ShaderPass copyPass;
  List<PostPass> passes = new List<PostPass>();

  EffectComposer(this.renderer, [WebGLRenderTarget renderTarget = null]) {

    if (renderTarget == null) {
      int width = (window == null) ? window.innerWidth : 1;
      int height = (window == null) ? window.innerHeight : 1;

      renderTarget = new WebGLRenderTarget(
          width,
          height,
          minFilter: LinearFilter,
          magFilter: LinearFilter,
          format: RGBFormat,
          stencilBuffer: false);
    }

    renderTarget1 = renderTarget;
    renderTarget2 = renderTarget.clone();

    writeBuffer = renderTarget1;
    readBuffer = renderTarget2;

    copyPass =
        new ShaderPass(new ShaderProgram.fromThreeish(CopyShader));
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

    var maskActive = false;

    PostPass pass;
    int il = passes.length;
    for (int i = 0; i < il; ++i) {

      pass = this.passes[i];

      if (!pass.enabled) continue;

      pass.render(
          this.renderer,
          this.writeBuffer,
          this.readBuffer,
          delta);

      if (pass.needsSwap) {

        if (maskActive) {

          var context = this.renderer.context;

          context.stencilFunc(context.NOTEQUAL, 1, 0xffffffff);

          this.copyPass.render(
              this.renderer,
              this.writeBuffer,
              this.readBuffer,
              delta);

          context.stencilFunc(context.EQUAL, 1, 0xffffffff);
        }

        this.swapBuffers();
      }

      if (pass is MaskPass) {
        maskActive = true;

      } else if (pass is ClearMaskPass) {
        maskActive = false;

      }
    }
  }

  void reset(renderTarget) {

    if (renderTarget == null) {

      renderTarget = this.renderTarget1.clone();

      renderTarget.width = window.innerWidth;
      renderTarget.height = window.innerHeight;
    }

    this.renderTarget1 = renderTarget;
    this.renderTarget2 = renderTarget.clone();

    this.writeBuffer = this.renderTarget1;
    this.readBuffer = this.renderTarget2;
  }

  void setSize(width, height) {

    var renderTarget = this.renderTarget1.clone();

    renderTarget.width = width;
    renderTarget.height = height;

    this.reset(renderTarget);
  }
}
