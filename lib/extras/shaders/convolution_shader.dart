part of three_shaders;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Convolution shader
 * ported from o3d sample to WebGL / GLSL
 * http://o3d.googlecode.com/svn/trunk/samples/convolution.html
 *
 * Ported to Dart from JS by:
 * @author Christopher Grabowski / https://github.com/cgrabowski
 */

var ConvolutionShader = {

  'defines': {

    "KERNEL_SIZE_FLOAT": "25.0",
    "KERNEL_SIZE_INT": "25",

  },

  'uniforms': {

    "tDiffuse":        { 'type': "t", 'value': null },
    "uImageIncrement": { 'type': "v2", 'value': new Vector2.array([0.001953125, 0.0]) },
    "cKernel":         { 'type': "fv1", 'value': [] }

  },

  'vertexShader': [

    "uniform vec2 uImageIncrement;",

    "varying vec2 vUv;",

    "void main() {",

      "vUv = uv - ( ( KERNEL_SIZE_FLOAT - 1.0 ) / 2.0 ) * uImageIncrement;",
      "gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );",

    "}"

  ].join("\n"),

  'fragmentShader': [

    "uniform float cKernel[ KERNEL_SIZE_INT ];",

    "uniform sampler2D tDiffuse;",
    "uniform vec2 uImageIncrement;",

    "varying vec2 vUv;",

    "void main() {",

      "vec2 imageCoord = vUv;",
      "vec4 sum = vec4( 0.0, 0.0, 0.0, 0.0 );",

      "for( int i = 0; i < KERNEL_SIZE_INT; i ++ ) {",

        "sum += texture2D( tDiffuse, imageCoord ) * cKernel[ i ];",
        "imageCoord += uImageIncrement;",

      "}",

      "gl_FragColor = sum;",

    "}"


  ].join("\n"),

  'buildKernel': ( double sigma ) {

    // We lop off the sqrt(2 * pi) * sigma term, since we're going to normalize anyway.

    double gauss( x, sigma ) {

      return exp( - ( x * x ) / ( 2.0 * sigma * sigma ) );

    }

    var i;
    var values;
    var sum;
    var halfWidth;
    var kMaxKernelSize = 25;
    int kernelSize = 2 * (sigma * 3.0).ceil() + 1;

    if ( kernelSize > kMaxKernelSize ) kernelSize = kMaxKernelSize;
    halfWidth = ( kernelSize - 1 ) * 0.5;

    values = new List( kernelSize );
    sum = 0.0;
    for ( i = 0; i < kernelSize; ++i ) {

      values[ i ] = gauss( i - halfWidth, sigma );
      sum += values[ i ];

    }

    // normalize the kernel

    for ( i = 0; i < kernelSize; ++i ) values[ i ] /= sum;

    return values;

  }

};
