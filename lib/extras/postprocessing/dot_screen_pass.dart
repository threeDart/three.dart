part of three_postprocessing;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

class DotScreenPass implements PostPass {
  ShaderProgram dotScreenShader;
  Map<String, Uniform> uniforms;
  ShaderMaterial material;
  bool enabled = true;
  bool renderToScreen = false;
  bool needsSwap = true;
  Scene scene;
  Camera camera;
  Mesh quad;

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
        uniforms: uniforms,
        vertexShader: dotScreenShader.vertexShader,
        fragmentShader: dotScreenShader.fragmentShader);

    scene = new Scene();
    camera = new OrthographicCamera(-1.0, 1.0, 1.0 - 1.0, 0.0, 1.0);
    scene.add(camera);
    quad = new Mesh(new PlaneBufferGeometry(2, 2), null);
    scene.add(quad);
  }

  void render(WebGLRenderer renderer, WebGLRenderTarget writeBuffer,
      WebGLRenderTarget readBuffer, double delta, bool maskActive) {

    uniforms['tDiffuse'].value = readBuffer;
    uniforms['tSize'].value.set(readBuffer.width, readBuffer.height);

    quad.material = material;

    if (renderToScreen) {
      renderer.render(scene, camera);
    } else {
      renderer.renderToTarget(scene, camera, writeBuffer, false);
    }
  }
}
