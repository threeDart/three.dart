part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class SavePass  extends PostPass {
  WebGLRenderTarget renderTarget;
  ShaderProgram copyShader;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  String textureID = 'tDiffuse';
  bool enabled = true;
  bool needsSwap = false;
  bool clear = false;

  SavePass([WebGLRenderTarget this.renderTarget]) {

    copyShader = new ShaderProgram.fromThreeish(CopyShader);
    uniforms = copyShader.uniforms;

    material = new ShaderMaterial(
        uniforms: uniforms,
        vertexShader: copyShader.vertexShader,
        fragmentShader: copyShader.fragmentShader);

    if (renderTarget == null) {
      renderTarget = new WebGLRenderTarget(
          window.innerWidth,
          window.innerHeight,
          minFilter: LinearFilter,
          magFilter: LinearFilter,
          format: RGBFormat,
          stencilBuffer: false);
    }
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta) {

    if (uniforms['textureID'] != null) {
      uniforms['textureID'].value = readBuffer;
    }

    EffectComposer.quad.material = material;

    renderer.renderTarget(
        EffectComposer.scene,
        EffectComposer.camera,
        renderTarget,
        clear);
  }
}
