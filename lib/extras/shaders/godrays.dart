part of three_shaders;

/*
 * @author Thibaut 'BKcore' Despoulain <http://bkcore.com>
 *
 * Ported to Dart from JS by
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

var GodraysShader = {
  'uniforms': {
    'tDiffuse': {
      'type': "t",
      'value': null
    },
    'fX': {
      'type': "f",
      'value': 0.5
    },
    'fY': {
      'type': "f",
      'value': 0.5
    },
    'fExposure': {
      'type': "f",
      'value': 0.6
    },
    'fDecay': {
      'type': "f",
      'value': 0.93
    },
    'fDensity': {
      'type': "f",
      'value': 0.96
    },
    'fWeight': {
      'type': "f",
      'value': 0.4
    },
    'fClamp': {
      'type': "f",
      'value': 1.0
    }
  },

  'vertexShader': [
      "varying vec2 vUv;",
      "void main() {",
      "vUv = vec2( uv.x, 1.0 - uv.y );",
      "gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );",
      "}"].join("\n"),

  'fragmentShader': [
      "varying vec2 vUv;",
      "uniform sampler2D tDiffuse;",
      "uniform float fX;",
      "uniform float fY;",
      "uniform float fExposure;",
      "uniform float fDecay;",
      "uniform float fDensity;",
      "uniform float fWeight;",
      "uniform float fClamp;",
      "const int iSamples = 20;",
      "void main()",
      "{",
      "vec2 deltaTextCoord = vec2(vUv - vec2(fX,fY));",
      "deltaTextCoord *= 1.0 /  float(iSamples) * fDensity;",
      "vec2 coord = vUv;",
      "float illuminationDecay = 1.0;",
      "vec4 FragColor = vec4(0.0);",
      "for(int i=0; i < iSamples ; i++)",
      "{",
      "coord -= deltaTextCoord;",
      "vec4 texel = texture2D(tDiffuse, coord);",
      "texel *= illuminationDecay * fWeight;",
      "FragColor += texel;",
      "illuminationDecay *= fDecay;",
      "}",
      "FragColor *= fExposure;",
      "FragColor = clamp(FragColor, 0.0, fClamp);",
      "gl_FragColor = FragColor;",
      "}"].join("\n")
};
