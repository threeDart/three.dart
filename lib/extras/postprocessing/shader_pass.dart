part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class ShaderPass implements Pass {
  ShaderProgram program;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  String textureID;
  Scene scene;
  Camera camera;
  Mesh quad;
  bool renderToScreen = false;
  bool enabled = true;
  bool needsSwap = true;
  bool clear = false;

  ShaderPass(this.program, [this.textureID = 'tDiffuse']) {
    uniforms = program.uniforms;
    material =
        new ShaderMaterial(uniforms: uniforms, vertexShader: program.vertexShader, fragmentShader: program.fragmentShader);

    scene = new Scene();
    camera = new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
    quad = new Mesh(new PlaneGeometry(2.0, 2.0), material);
    scene.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeTarget, WebGLRenderTarget readTarget, double delta,
      bool maskActive) {

    if (uniforms[textureID] != null) {
      uniforms[textureID].value = readTarget;
    }

    if (renderToScreen) {
      renderer.render(scene, camera);

    } else {
      renderer.renderToTarget(scene, camera, writeTarget, clear);
    }
  }
}
