part of three_shaders;

/*
 * @author Christopher Grabowski / https://github.com/cgrabowski
 * @see three_shaders library
 *
 * Prepares dynamic shader programs that were ported from three.js
 * (e.g., three_shaders library) to be applied to ShaderMaterial or ShaderPass.
 * Unlike the Program class in web_gl_renderer.dart, this class does not
 * interact with the implementation of WebGLRenderer and doesn't even compile
 * the source code. It is just a public-facing helper class to prepare the
 * uniform map and shader sources.
 *
 * Usage examples:
 *
 * ShaderPass fxaaPass =
 *     new ShaderPass(new ShaderProgram.fromThreeish(FXAAShader));
 *
 * ShaderProgram program = new ShaderProgram.fromThreeish(BokehShader);
 * program.uniforms['focus'].value = 2.0;
 * ShaderMaterial material =
 *     new ShaderMaterial(
 *         uniforms: program.uniforms,
 *         vertexShader: program.vertexShader,
 *         fragmentShader: program.fragmentShader);
 */

class ShaderProgram {
  Map<String, Uniform> uniforms;
  String vertexShader;
  String fragmentShader;

  ShaderProgram(Map<String, Uniform> uniforms, this.vertexShader, this.fragmentShader) {
    this.uniforms = new Map<String, Uniform>.from(uniforms);
  }

  // Constructs a typed program from a dynamically-typed Map
  // in the typical three.js program format.
  ShaderProgram.fromThreeish(Map<String, dynamic> program) {

    if (program['uniforms'] != null) {
      uniforms = typedUniformMap(program['uniforms']);
    } else {
      uniforms = new Map<String, Uniform>();
    }

    vertexShader = program['vertexShader'];
    fragmentShader = program['fragmentShader'];
  }

  static Map<String, Uniform> typedUniformMap(var dynamicUniformMap) {
    Map<String, Uniform> typedUniformMap = new Map<String, Uniform>();

    dynamicUniformMap.forEach((name, dynamicUniform) {
      //print(name.toString() + ", " + dynamicUniform.toString());
      typedUniformMap[name] = new Uniform(dynamicUniform['type'], dynamicUniform['value']);
    });

    return typedUniformMap;
  }

  //TODO compile method?
}
