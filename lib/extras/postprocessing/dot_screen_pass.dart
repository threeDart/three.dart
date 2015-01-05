part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class DotScreenPass  extends PostPass {
  ShaderProgram dotScreenShader;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  bool enabled = true;
  bool renderToScreen = false;
  bool needsSwap = true;

  DotScreenPass({Vector3 center, double angle, double scale}) {

    dotScreenShader = new ShaderProgram.fromThreeish(DotScreenShader);
    uniforms = dotScreenShader.uniforms;

    if (center != null) {
      uniforms['center'].value = center.clone();
    }
    if (angle != null) {
      uniforms['angle'].value = angle;
    }
    if (scale != null) {
      uniforms['scale'].value = scale;
    }

    material = new ShaderMaterial(
        uniforms: dotScreenShader.uniforms,
        vertexShader: dotScreenShader.vertexShader,
        fragmentShader: dotScreenShader.fragmentShader);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta) {

    uniforms['tDiffuse'].value = readBuffer;
    uniforms['tSize'].value.set(readBuffer.width, readBuffer.height);

    EffectComposer.quad.material = material;

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
