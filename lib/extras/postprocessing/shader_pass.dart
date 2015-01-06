part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class ShaderPass implements PostPass {
  ShaderProgram program;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  String textureID;
  Scene scene;
  OrthographicCamera camera;
  Mesh quad;
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

    scene = new Scene();
    camera = new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
    scene.add(camera);
    quad = new Mesh(new PlaneBufferGeometry(2, 2), null);
    scene.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive) {

    if (uniforms[textureID] != null) {
      uniforms[textureID].value = readBuffer;
    }

    quad.material = material;

    if (renderToScreen) {
      renderer.render(scene, camera);

    } else {
      renderer.renderToTarget(scene, camera, writeBuffer, clear);
    }
  }
}
