part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class FilmPass  extends PostPass {
  ShaderProgram filmShader;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  bool enabled = true;
  bool renderToScreen = false;
  bool needsSwap = true;

  FilmPass({double noiseIntensity, double scanlinesIntensity,
      double scanlinesCount, int grayscale}) {

    filmShader = new ShaderProgram.fromThreeish(FilmShader);
    uniforms = filmShader.uniforms;

    material = new ShaderMaterial(
        uniforms: filmShader.uniforms,
        vertexShader: filmShader.vertexShader,
        fragmentShader: filmShader.fragmentShader);

    if (grayscale != null) {
      uniforms['grayscale'].value = grayscale;
    }
    if (noiseIntensity != null) {
      uniforms['nIntensity'].value = noiseIntensity;
    }
    if (scanlinesIntensity != null) {
      uniforms['sIntensity'].value = scanlinesIntensity;
    }
    if (scanlinesCount != null) {
      uniforms['sCount'].value = scanlinesCount;
    }
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta) {

    uniforms['tDiffuse'].value = readBuffer;
    uniforms['time'].value += delta;

    EffectComposer.quad.material = this.material;

    if (renderToScreen == true) {
      renderer.render(EffectComposer.scene, EffectComposer.camera);
    } else {
      renderer.renderTarget(
          EffectComposer.scene,
          EffectComposer.camera,
          writeBuffer,
          false);
    }
  }
}
