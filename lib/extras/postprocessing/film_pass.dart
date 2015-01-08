part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class FilmPass implements Pass {
  ShaderProgram program;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  bool enabled = true;
  bool renderToScreen = false;
  bool needsSwap = true;
  Scene scene;
  Camera camera;
  Mesh quad;

  FilmPass({double noiseIntensity, double scanlinesIntensity,
      double scanlinesCount, int grayscale}) {

    program = new ShaderProgram.fromThreeish(FilmShader);
    uniforms = program.uniforms;

    material = new ShaderMaterial(
        uniforms: uniforms,
        vertexShader: program.vertexShader,
        fragmentShader: program.fragmentShader);

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

    scene = new Scene();
    camera = new OrthographicCamera(-1.0, 1.0, 1.0, -1.0, 0.0, 1.0);
    scene.add(camera);
    quad = new Mesh(new PlaneBufferGeometry(2, 2), null);
    scene.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive) {

    uniforms['tDiffuse'].value = readBuffer;
    uniforms['time'].value += delta;

    quad.material = material;

    if (renderToScreen) {
      renderer.render(scene, camera);
    } else {
      renderer.renderToTarget(scene, camera, writeBuffer, false);
    }
  }
}
