part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class RenderPass extends Pass {
  Scene scene;
  Camera camera;
  Material overrideMaterial;
  Color clearColor;
  double clearAlpha;
  Color oldClearColor = new Color();
  double oldClearAlpha = 1.0;
  bool enabled = true;
  bool clear = true;
  bool needsSwap = true;

  RenderPass(this.scene, this.camera, [this.overrideMaterial = null,
      this.clearColor = null, this.clearAlpha = 1.0]);

  void render(WebGLRenderer renderer, WebGLRenderTarget writeTarget,
      WebGLRenderTarget readTarget, double delta, bool maskActive) {

    scene.overrideMaterial = overrideMaterial;
    if (clearColor != null) {
      oldClearColor.copy(renderer.getClearColor());
      oldClearAlpha = renderer.getClearAlpha();
      renderer.setClearColor(clearColor, clearAlpha);
    }

    renderer.renderToTarget(scene, camera, writeTarget, clear);

    if (clearColor != null) {
      renderer.setClearColor(oldClearColor, oldClearAlpha);
    }

    scene.overrideMaterial = null;
  }
}
