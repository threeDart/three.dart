part of three_shaders;

/*
 * @author Thibaut 'BKcore' Despoulain <http://bkcore.com>
 *
 * Ported to Dart from JS by
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

// Coeff'd additive buffer blending
  var AdditiveShader = {
    'uniforms': {
      'tDiffuse': { 'type': "t", 'value': null},
      'tAdd': { 'type': "t", 'value': null},
      'fCoeff': { 'type': "f", 'value': 1.0 }
    },

    'vertexShader': [
      "varying vec2 vUv;",

      "void main() {",

        "vUv = vec2( uv.x, 1.0 - uv.y );",
        "gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );",

      "}"
    ].join("\n"),

    'fragmentShader': [
      "uniform sampler2D tDiffuse;",
      "uniform sampler2D tAdd;",
      "uniform float fCoeff;",

      "varying vec2 vUv;",

      "void main() {",

        "vec4 texel = texture2D( tDiffuse, vUv );",
        "vec4 add = texture2D( tAdd, vUv );",
        "gl_FragColor = texel + add * fCoeff;",

      "}"
    ].join("\n")
  };
