part of three_shaders;

/*
 * @author Christopher Grabowski / https://github.com/cgrabowski
 *
 * Produces typed shader programs.
 */

class ShaderProgram {
  Map<String, Uniform> uniforms;
  String vertexShader;
  String fragmentShader;

  ShaderProgram(Map<String, Uniform> uniforms, this.vertexShader, this.fragmentShader){
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
      typedUniformMap[name] =
          new Uniform(dynamicUniform['type'], dynamicUniform['value']);
    });

    return typedUniformMap;
  }

  //TODO compile method?
}
