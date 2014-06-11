part of gltf_loader;

final glTFAnimator = new _GLTFAnimator();

class _GLTFAnimator {

  var animators = [];

  void add(animator) {
    animators.add(animator);
  }

  remove(animator) {
    animators.remove(animator);
  }

  update() {
    animators.forEach((a) { a.update(); });
  }
}


// Construction/initialization
class GLTFAnimation {
  String name;
  bool running = false;
  bool loop = false;
  num duration = 0;
  num startTime = 0;
  List interps = [];

  GLTFAnimation([interps]) {
    if (interps != null) {
      addInterpolators(interps);
    }
  }

  addInterpolators(interps) {
    this.interps.addAll(interps);
    interps.forEach((interp) {
      duration = Math.max(duration, interp.duration);
    });
  }

// Start/stop
  play() {
    if (running)
      return;

    startTime = new DateTime.now().millisecondsSinceEpoch;
    running = true;
    glTFAnimator.add(this);
  }

  stop() {
    running = false;
    glTFAnimator.remove(this);
  }

  // Update - drive key frame evaluation
  update() {
    if (!running)
      return;

    var now = new DateTime.now().millisecondsSinceEpoch;
    var deltat = (now - startTime) / 1000;
    var t = deltat % duration;
    var nCycles = (deltat / duration).floor();

    if (nCycles >= 1 && !loop) {
      running = false;
      var i, len = interps.length;
      for (i = 0; i < len; i++) {
        interps[i].interp(duration);
      }
      stop();
      return;
    } else {
      var i, len = interps.length;
      for (i = 0; i < len; i++) {
        interps[i].interp(t);
      }
    }
  }
}

//Interpolator class
//Construction/initialization
class GLTFInterpolator {

  List keys;
  List values;
  int count;
  String type;
  String path;
  bool isRot;

  var target;
  var originalValue;
  var duration;

  Vector3 vec1, vec2, vec3;
  Quaternion quat1, quat2, quat3;

  GLTFInterpolator(target, {this.keys, this.values, this.count, this.type, this.path, this.isRot: false}) {

    var node = target;
    node.updateMatrix();
    node.matrixAutoUpdate = true;

    switch (path) {
      case "translation" :
        this.target = node.position;
        originalValue = node.position.clone();
        break;
      case "rotation" :
        this.target = node.quaternion;
        originalValue = node.quaternion.clone();
        isRot = true;
        break;
      case "scale" :
        this.target = node.scale;
        originalValue = node.scale.clone();
        break;
    }

    duration = keys[count - 1];

    vec1 = new Vector3.zero();
    vec2 = new Vector3.zero();
    vec3 = new Vector3.zero();
    quat1 = new Quaternion.identity();
    quat2 = new Quaternion.identity();
    quat3 = new Quaternion.identity();
  }

  //Interpolation and tweening methods
  interp(t) {
    var i, j;
    if (t == keys[0]) {
      if (isRot) {
        quat3
        ..x = values[0]
        ..y = values[1]
        ..z = values[2]
        ..w = values[3];
      } else {
        vec3.setValues(values[0], values[1], values[2]);
      }
    } else if (t < keys[0]) {
      if (isRot) {
        quat1..copyFrom(originalValue);
        quat2..x = values[0]
            ..y = values[1]
            ..z = values[2]
            ..w = values[3];
        THREE.slerp(quat1, quat2, quat3, t / keys[0]);
      } else {
        vec3.setValues(originalValue.x,
            originalValue.y,
            originalValue.z);
        vec2.setValues(values[0],
            values[1],
            values[2]);

        //vec3.lerp(vec2, t / keys[0]);
        vec3.add((vec2 - vec3) * (t / keys[0]));
      }
    } else if (t >= keys[count - 1]) {
      if (isRot) {
        quat3..x = values[(count - 1) * 4]
            ..y = values[(count - 1) * 4 + 1]
            ..z = values[(count - 1) * 4 + 2]
            ..w = values[(count - 1) * 4 + 3];
      } else {
        vec3.setValues(values[(count - 1) * 3],
            values[(count - 1) * 3 + 1],
            values[(count - 1) * 3 + 2]);
      }
    } else {
      for (i = 0; i < count - 1; i++) {
        var key1 = keys[i];
        var key2 = keys[i + 1];

        if (t >= key1 && t <= key2) {
          if (isRot) {
            quat1
                ..x = values[i * 4]
                ..y = values[i * 4 + 1]
                ..z = values[i * 4 + 2]
                ..w = values[i * 4 + 3];
            quat2
              ..x = values[(i + 1) * 4]
              ..y = values[(i + 1) * 4 + 1]
              ..z = values[(i + 1) * 4 + 2]
              ..w = values[(i + 1) * 4 + 3];
            THREE.slerp(quat1, quat2, quat3, (t - key1) / (key2 - key1));
          } else {
            vec3.setValues(values[i * 3],
                values[i * 3 + 1],
                values[i * 3 + 2]);
            vec2.setValues(values[(i + 1) * 3],
                values[(i + 1) * 3 + 1],
                values[(i + 1) * 3 + 2]);

            //vec3.lerp(vec2, (t - key1) / (key2 - key1));
            vec3.add((vec2 - vec3) * ((t - key1) / (key2 - key1)));
          }
        }
      }
    }

    if (target != null) {
      copyValue(target);
    }
  }

  copyValue(target) {
    if (isRot) {
      target.copyFrom(quat3);
    } else {
      target.setFrom(vec3);
    }
  }
}