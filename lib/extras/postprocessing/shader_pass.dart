part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class ShaderPass  extends PostPass {
  ShaderProgram program;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  String textureID;
  bool renderToScreen = false;
  bool enabled = true;
  bool needsSwap = true;
  bool clear = false;

  ShaderPass(this.program, [this.textureID = 'tDiffuse']) {
    uniforms = program.uniforms;

    material = new ShaderMaterial(
        uniforms: uniforms,
        vertexShader: program.vertexShader,
        fragmentShader: program.fragmentShader);

    this.renderToScreen = false;

    this.enabled = true;
    this.needsSwap = true;
    this.clear = false;
  }

  void render(renderer, writeBuffer, readBuffer, delta) {

    if (uniforms[this.textureID] != null) {
      uniforms[this.textureID].value = readBuffer;
    }

    EffectComposer.quad.material = this.material;

    if (this.renderToScreen) {
      renderer.render(EffectComposer.scene, EffectComposer.camera);

    } else {
      renderer.renderTarget(
          EffectComposer.scene,
          EffectComposer.camera,
          writeBuffer,
          this.clear);
    }
  }
}
