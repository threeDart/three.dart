part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class TexturePass extends PostPass {
  ShaderProgram copyShader;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  bool enabled = true;
  bool needsSwap = false;

  TexturePass(Texture texture, [double opacity = 1.0]) {

    copyShader = new ShaderProgram.fromThreeish(CopyShader);
    uniforms = copyShader.uniforms;
    uniforms['opacity'].value = opacity;
    uniforms['tDiffuse'].value = texture;

    material = new ShaderMaterial(
        uniforms: copyShader.uniforms,
        vertexShader: copyShader.vertexShader,
        fragmentShader: copyShader.fragmentShader);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta) {

    EffectComposer.quad.material = material;
    renderer.renderTarget(
        EffectComposer.scene,
        EffectComposer.camera,
        readBuffer);
  }
}
