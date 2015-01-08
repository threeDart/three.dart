part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class BloomPass implements Pass {
  static final Vector2 blurX = new Vector2.array([0.001953125, 0.0]);
  static final Vector2 blurY = new Vector2.array([0.0, 0.001953125]);
  WebGLRenderTarget renderTargetX;
  WebGLRenderTarget renderTargetY;
  ShaderProgram copyShader;
  Map<String, Uniform> copyUniforms;
  ShaderMaterial materialCopy;
  ShaderProgram convolutionShader;
  Map<String, Uniform> convolutionUniforms;
  ShaderMaterial materialConvolution;
  bool enabled = true;
  bool needsSwap = false;
  bool clear = false;

  Scene scene;
  OrthographicCamera camera;
  Mesh quad;

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
    copyUniforms = copyShader.uniforms;
    copyUniforms['opacity'].value = strength;

    materialCopy = new ShaderMaterial(
        uniforms: copyUniforms,
        vertexShader: copyShader.vertexShader,
        fragmentShader: copyShader.fragmentShader,
        blending: AdditiveBlending,
        transparent: true);

    convolutionShader = new ShaderProgram.fromThreeish(ConvolutionShader);
    convolutionUniforms = convolutionShader.uniforms;

    convolutionUniforms['uImageIncrement'].value = BloomPass.blurX;
    convolutionUniforms['cKernel'].value = ConvolutionShader.buildKernel(sigma);

    materialConvolution = new ShaderMaterial(
        uniforms: convolutionUniforms,
        vertexShader: convolutionShader.vertexShader,
        fragmentShader: convolutionShader.fragmentShader);

    materialConvolution.defines['KERNEL_SIZE_FLOAT'] =
        double.parse(kernelSize.toStringAsFixed(1));
    materialConvolution.defines['KERNEL_SIZE_INT'] = kernelSize.toInt();

    scene = new Scene();
    camera = new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
    scene.add(camera);
    quad = new Mesh(new PlaneBufferGeometry(2, 2), null);
    scene.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive) {

    RenderingContext context = renderer.context;

    if (maskActive) {
      context.disable(RenderingContext.STENCIL_TEST);
    }

    quad.material = materialConvolution;

    convolutionShader.uniforms['tDiffuse'].value = readBuffer;
    convolutionShader.uniforms['uImageIncrement'].value = BloomPass.blurX;

    renderer.renderToTarget(scene, camera, renderTargetX, true);

    convolutionUniforms['tDiffuse'].value = renderTargetX;
    convolutionUniforms['uImageIncrement'].value = BloomPass.blurY;

    renderer.renderToTarget(scene, camera, renderTargetY, true);

    quad.material = materialCopy;
    copyUniforms['tDiffuse'].value = renderTargetY;

    if (maskActive) {
      context.enable(RenderingContext.STENCIL_TEST);
    }

    renderer.renderToTarget(scene, camera, readBuffer, clear);
  }
}
