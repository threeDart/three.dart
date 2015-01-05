part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class BloomPass  extends PostPass {
  static final Vector2 blurX = new Vector2.array([0.001953125, 0.0]);
  static final Vector2 blurY = new Vector2.array([0.0, 0.001953125]);
  WebGLRenderTarget renderTargetX;
  WebGLRenderTarget renderTargetY;
  ShaderProgram copyShader;
  ShaderMaterial materialCopy;
  ShaderProgram convolutionShader;
  ShaderMaterial materialConvolution;
  bool enabled = true;
  bool needsSwap = false;
  bool clear = false;
  bool maskActive;

  BloomPass({int strength: 1, num kernelSize: 25, double sigma: 4.0,
      int resolution: 256}) {

    renderTargetX = new WebGLRenderTarget(
        resolution,
        resolution,
        minFilter: LinearFilter,
        magFilter: LinearFilter,
        format: RGBFormat);
    renderTargetY = new WebGLRenderTarget(
        resolution,
        resolution,
        minFilter: LinearFilter,
        magFilter: LinearFilter,
        format: RGBFormat);

    copyShader = new ShaderProgram.fromThreeish(CopyShader);
    copyShader.uniforms['opacity'].value = strength;

    materialCopy = new ShaderMaterial(
        uniforms: copyShader.uniforms,
        vertexShader: copyShader.vertexShader,
        fragmentShader: copyShader.fragmentShader,
        blending: AdditiveBlending,
        transparent: true);

    convolutionShader = new ShaderProgram.fromThreeish(ConvolutionShader);

    convolutionShader.uniforms['uImageIncrement'].value = BloomPass.blurX;
    convolutionShader.uniforms['cKernel'].value = sigma;

    materialConvolution = new ShaderMaterial(
        uniforms: convolutionShader.uniforms,
        vertexShader: convolutionShader.vertexShader,
        fragmentShader: convolutionShader.fragmentShader);
    materialConvolution.defines['KERNEL_SIZE_FLOAT'] =
        double.parse(kernelSize.toStringAsFixed(1));
    materialConvolution.defines['KERNEL_SIZE_INT'] = kernelSize.toInt();
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta) {
    RenderingContext context = renderer.context;
    if (maskActive == true) {
      context.disable(RenderingContext.STENCIL_TEST);
    }

    EffectComposer.quad.material = materialConvolution;

    convolutionShader.uniforms['tDiffuse'].value = readBuffer;
    convolutionShader.uniforms['uImageIncrement'].value = BloomPass.blurX;

    renderer.renderTarget(
        EffectComposer.scene,
        EffectComposer.camera,
        this.renderTargetX,
        true);

    convolutionShader.uniforms['tDiffuse'].value = renderTargetX;
    convolutionShader.uniforms['uImageIncrement'].value = BloomPass.blurY;

    renderer.renderTarget(
        EffectComposer.scene,
        EffectComposer.camera,
        this.renderTargetY,
        true);

    EffectComposer.quad.material = materialCopy;
    copyShader.uniforms['tDiffuse'].value = renderTargetY;

    if (maskActive == true) {
      context.enable(RenderingContext.STENCIL_TEST);
    }

    renderer.renderTarget(
        EffectComposer.scene,
        EffectComposer.camera,
        readBuffer,
        true);
  }
}
