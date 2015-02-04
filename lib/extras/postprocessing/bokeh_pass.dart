part of three_postprocessing;
/**
 * Depth-of-field post-process with bokeh shader
 *
 *  * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
  */

class BokehPass implements Pass {
  WebGLRenderTarget renderTargetColor, renderTargetDepth;
  Scene scene1, scene2;
  PerspectiveCamera camera1;
  OrthographicCamera camera2;
  ShaderProgram program;
  Map<String, Uniform> uniforms;
  MeshDepthMaterial materialDepth;
  ShaderMaterial materialBokeh;
  Mesh quad;
  bool enabled = true;
  bool needsSwap = false;
  bool renderToScreen = false;
  bool clear = false;

  BokehPass(this.scene1, this.camera1, {double focus: 1.0, double aspect, double aperture: 0.025, double maxblur: 1.0,
      int width, int height}) {

    if (width == null) {
      width = window.innerWidth;
    }
    if (height == null) {
      height = window.innerHeight;
    }

    if (aspect == null) aspect = camera1.aspect;
    renderTargetColor =
        new WebGLRenderTarget(width, height, minFilter: LinearFilter, magFilter: LinearFilter, format: RGBFormat);

    renderTargetDepth = renderTargetColor.clone();
    materialDepth = new MeshDepthMaterial();

    program = new ShaderProgram.fromThreeish(BokehShader);
    uniforms = program.uniforms;
    uniforms['tDepth'].value = renderTargetDepth;
    uniforms['focus'].value = focus;
    uniforms['aspect'].value = aspect;
    uniforms['aperture'].value = aperture;
    uniforms['maxblur'].value = maxblur;

    materialBokeh =
        new ShaderMaterial(uniforms: uniforms, vertexShader: program.vertexShader, fragmentShader: program.fragmentShader);

    scene2 = new Scene();
    camera2 = new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
    scene2.add(camera2);
    quad = new Mesh(new PlaneGeometry(2.0, 2.0), materialBokeh);
    scene2.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer, WebGLRenderTarget readBuffer, double delta,
      bool maskActive) {

    quad.material = materialBokeh;
    scene1.overrideMaterial = materialDepth;

    renderer.renderToTarget(scene1, camera1, renderTargetDepth, true);

    uniforms['tColor'].value = readBuffer;

    if (renderToScreen) {
      renderer.render(scene2, camera2);
    } else {
      renderer.renderToTarget(scene2, camera2, writeBuffer, clear);
    }

    scene1.overrideMaterial = null;
  }
}
