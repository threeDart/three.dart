part of three_shaders;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Color correction
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

var ColorCorrectionShader = {

	'uniforms': {

		"tDiffuse": { 'type': "t", 'value': null },
		"powRGB":   { 'type': "v3", 'value': new Vector3( 2.0, 2.0, 2.0 ) },
		"mulRGB":   { 'type': "v3", 'value': new Vector3( 1.0, 1.0, 1.0 ) }

	},

	'vertexShader': [

		"varying vec2 vUv;",

		"void main() {",

			"vUv = uv;",

			"gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );",

		"}"

	].join("\n"),

	'fragmentShader': [

		"uniform sampler2D tDiffuse;",
		"uniform vec3 powRGB;",
		"uniform vec3 mulRGB;",

		"varying vec2 vUv;",

		"void main() {",

			"gl_FragColor = texture2D( tDiffuse, vUv );",
			"gl_FragColor.rgb = mulRGB * pow( gl_FragColor.rgb, powRGB );",

		"}"

	].join("\n")

};
