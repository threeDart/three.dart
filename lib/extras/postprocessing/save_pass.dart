part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class SavePass  implements Pass {
  WebGLRenderTarget renderTarget;
  ShaderProgram shader;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  String textureID = 'tDiffuse';
  bool enabled = true;
  bool needsSwap = false;
  bool clear = false;
  Scene scene;
  OrthographicCamera camera;
  Mesh quad;

  SavePass([WebGLRenderTarget this.renderTarget = null]) {

    shader = new ShaderProgram.fromThreeish(CopyShader);
    uniforms = shader.uniforms;

    material = new ShaderMaterial(
        uniforms: uniforms,
        vertexShader: shader.vertexShader,
        fragmentShader: shader.fragmentShader);

    if (renderTarget == null) {
      renderTarget = new WebGLRenderTarget(
          window.innerWidth,
          window.innerHeight,
          minFilter: LinearFilter,
          magFilter: LinearFilter,
          format: RGBFormat,
          stencilBuffer: false);
    }

    scene = new Scene();
    camera = new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
    scene.add(camera);
    quad = new Mesh(new PlaneBufferGeometry(2, 2), null);
    scene.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeTarget,
      WebGLRenderTarget readTarget, double delta, bool maskActive) {

    if (uniforms['textureID'] != null) {
      uniforms['textureID'].value = readTarget;
    }

    quad.material = material;

    renderer.renderToTarget(
        scene,
        camera,
        renderTarget,
        clear);
  }
}
