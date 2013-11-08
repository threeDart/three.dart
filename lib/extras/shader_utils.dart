library ShaderUtils;

import 'package:three/three.dart' as THREE;

//TODO
var lib = {
    "normal": "",
    'cube': new THREE.ShaderMaterial(

      uniforms: {
        "tCube": new THREE.Uniform.float(),
        "tFlip": new THREE.Uniform.float(-1.0)
        },

      vertexShader:
         '''varying vec3 vViewPosition;
            void main() {
              vec4 mPosition = modelMatrix * vec4( position, 1.0 );
              vViewPosition = cameraPosition - mPosition.xyz;
              gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
            }''',


      fragmentShader:
         '''uniform samplerCube tCube;
            uniform float tFlip;
            varying vec3 vViewPosition;
            void main() {
              vec3 wPos = cameraPosition - vViewPosition;
              gl_FragColor = textureCube( tCube, vec3( tFlip * wPos.x, wPos.yz ) );
            }'''
          )

};

