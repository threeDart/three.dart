import 'dart:html';
import 'dart:math' as Math;

import 'package:three/three.dart' as THREE;
import 'package:three/extras/renderers/canvas_renderer.dart' as THREE;
import 'package:three/extras/controls/first_person_controls.dart';

/**
 * Default First Person Control Scheme:
 * Use mouse to change camera orientation
 * Left click: move forward, Right click: move backward
 * Arrows/WASD: Strafe left/right, move forward/backward
 *
 * Starfield code adapted from: http://creativejs.com/tutorials/three-js-part-1-make-a-star-field/
 */

class Game {
  Element container;
  THREE.PerspectiveCamera camera;
  THREE.Scene scene;
  THREE.CanvasRenderer renderer;
  FirstPersonControls controls;

  List<THREE.Particle> particles;

  void init() {
    container = new Element.tag('div');
    document.body.nodes.add(container);

    camera = new THREE.PerspectiveCamera(75.0, window.innerWidth / window.innerHeight, 1.0, 10000.0);

    scene = new THREE.Scene();

    renderer = new THREE.CanvasRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);

    particles = new List<THREE.Particle>();

    makeParticles();

    container.nodes.add(renderer.domElement);

    controls = new FirstPersonControls(camera, renderer.domElement);
    controls.movementSpeed = 2;
  }

  void makeParticles() {
    var rng = new Math.Random();
    for (var i = 0; i < 500; i++) {
      var material = new THREE.ParticleCanvasMaterial(color: rng.nextDouble() * 0x808080 + 0x808080, program: particleRender);
      var particle = new THREE.Particle(material);

      particle.position.x = rng.nextDouble() * 1000 - 500;
      particle.position.y = rng.nextDouble() * 1000 - 500;
      particle.position.z = rng.nextDouble() * 1000 - 500;

      particle.scale.x = particle.scale.y =  rng.nextDouble() * 10 + 10;

      scene.add(particle);

      particles.add(particle);
    }
  }

  void particleRender(var context) {
    context.beginPath();
    context.arc(0, 0, 1, 0, Math.PI * 2, true);
    context.fill();
  }

  void animate(timestamp) {
    window.requestAnimationFrame( animate );
    controls.update(1.0);
    render();
  }

  void render() {
    renderer.render(scene, camera);
  }
}

void main() {
  var game = new Game();
  game.init();
  game.animate(0);
}