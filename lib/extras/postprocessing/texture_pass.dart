part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class TexturePass extends PostPass {
  ShaderProgram program;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  Scene scene;
  OrthographicCamera camera;
  Mesh quad;
  bool enabled = true;
  bool needsSwap = false;

  TexturePass(Texture texture, [double opacity = 1.0]) {

    program = new ShaderProgram.fromThreeish(CopyShader);
    uniforms = program.uniforms;
    uniforms['opacity'].value = opacity;
    uniforms['tDiffuse'].value = texture;

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

    quad.material = material;
    renderer.renderToTarget(scene, camera, readBuffer);
  }
}
