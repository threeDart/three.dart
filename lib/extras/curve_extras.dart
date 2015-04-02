library CurveExtras;

import 'dart:math' as Math;
import 'package:three/three.dart' show Curve3D;
import 'package:vector_math/vector_math.dart';

class GrannyKnot extends Curve3D {
  Vector3 getPoint(double t) {
    t = 2 * Math.PI * t;
    
    var x = -0.22 * Math.cos(t) - 1.28 * Math.sin(t) - 0.44 * Math.cos(3 * t) - 0.78 * Math.sin(3 * t);
    var y = -0.1 * Math.cos(2 * t) - 0.27 * Math.sin(2 * t) + 0.38 * Math.cos(4 * t) + 0.46 * Math.sin(4 * t);
    var z = 0.7 * Math.cos(3 * t) - 0.4 * Math.sin(3 * t);
    
    return new Vector3(x, y, z)..scale(20.0);
  }
}

class HeartCurve extends Curve3D {
  double scale;
  
  HeartCurve([this.scale = 5.0]);
  
  Vector3 getPoint(double t) {
    t *= 2 * Math.PI;

    var tx = 16 * Math.pow(Math.sin(t), 3);
    var ty = 13 * Math.cos(t) - 5 * Math.cos(2 * t) - 2 * Math.cos(3 * t) - Math.cos(4 * t);

    return new Vector3(tx, ty, 0.0)..scale(scale);
  }
}

class VivianiCurve extends Curve3D {
  double radius;
  
  VivianiCurve(this.radius);
  
  Vector3 getPoint(double t) {
    t = t * 4 * Math.PI; // Normalized to 0..1
    var a = radius / 2;
    var tx = a * (1 + Math.cos(t)),
        ty = a * Math.sin(t),
        tz = 2 * a * Math.sin(t / 2);

    return new Vector3(tx, ty, tz);
  }
}

class KnotCurve extends Curve3D {
  Vector3 getPoint(double t) {
    t *= 2 * Math.PI;

    var R = 10;
    var s = 50;
    var tx = s * Math.sin(t),
        ty = Math.cos(t) * (R + s * Math.cos(t)),
        tz = Math.sin(t) * (R + s * Math.cos(t));

    return new Vector3(tx, ty, tz);
  }
}

class HelixCurve extends Curve3D {
  Vector3 getPoint(double t) {
    var radius = 30; 
    var height = 150; 
    var t2 = 2 * Math.PI * t * height / 30;
    var tx = Math.cos(t2) * radius,
        ty = Math.sin(t2) * radius,
        tz = height * t;

    return new Vector3(tx, ty, tz);
  }
}

class TrefoilKnot extends Curve3D {
  double scale;
  
  TrefoilKnot([this.scale = 10.0]);
    
  Vector3 getPoint(double t) {
    t *= Math.PI * 2;
    var tx = (2 + Math.cos(3 * t)) * Math.cos(2 * t),
        ty = (2 + Math.cos(3 * t)) * Math.sin(2 * t),
        tz = Math.sin(3 * t);

    return new Vector3(tx, ty, tz)..scale(scale);
  }
}

class TorusKnot extends Curve3D {
  double scale;
  
  TorusKnot([double scale = 10.0]);
  
  Vector3 getPoint(double t) {
    var p = 3, q = 4;
    t *= Math.PI * 2;
    var tx = (2 + Math.cos(q * t)) * Math.cos(p * t),
        ty = (2 + Math.cos(q * t)) * Math.sin(p * t),
        tz = Math.sin(q * t);

    return new Vector3(tx, ty, tz)..scale(scale);
  }
}

class CinquefoilKnot extends Curve3D {
  double scale;
  
  CinquefoilKnot([this.scale = 10.0]);
  
  Vector3 getPoint(double t) {
    var p = 2, q = 5;
    t *= Math.PI * 2;
    var tx = (2 + Math.cos(q * t)) * Math.cos(p * t),
        ty = (2 + Math.cos(q * t)) * Math.sin(p * t),
        tz = Math.sin(q * t);

    return new Vector3(tx, ty, tz)..scale(scale);
  }
}

class TrefoilPolynomialKnot extends Curve3D {
  double scale;
  
  TrefoilPolynomialKnot([this.scale = 10.0]);
  
  Vector3 getPoint(double t) {
    t = t * 4 - 2;
    var tx = Math.pow(t, 3) - 3 * t,
        ty = Math.pow(t, 4) - 4 * t * t,
        tz = 1 / 5 * Math.pow(t, 5) - 2 * t;

    return new Vector3(tx, ty, tz)..scale(scale);
  }
}

class FigureEightPolynomialKnot extends Curve3D {
  double scale;
  
  FigureEightPolynomialKnot([this.scale = 1.0]);
  
  Vector3 getPoint(double t) {
    var scaleTo = (x, y, t) => t * (y - x) * x;
    t = scaleTo(-4.0, 4.0, t);
    var tx = 2 / 5 * t * (t * t - 7) * (t * t - 10),
        ty = Math.pow(t, 4) - 13 * t * t,
        tz = 1 / 10 * t * (t * t - 4) * (t * t - 9) * (t * t - 12);

    return new Vector3(tx, ty, tz)..scale(scale);
  }
}

class DecoratedTorusKnot4a extends Curve3D {
  double scale;
  
  DecoratedTorusKnot4a([this.scale = 40.0]);
  
  Vector3 getPoint(double t) {
    t *= Math.PI * 2;
    var x = Math.cos(2 * t) * (1 + 0.6 * (Math.cos(5 * t) + 0.75 * Math.cos(10 * t))),
        y = Math.sin(2 * t) * (1 + 0.6 * (Math.cos(5 * t) + 0.75 * Math.cos(10 * t))),
        z = 0.35 * Math.sin(5 * t);

    return new Vector3(x, y, z)..scale(scale);
  }
}

class DecoratedTorusKnot4b extends Curve3D {
  double scale;
  
  DecoratedTorusKnot4b([this.scale = 40.0]);
  
  Vector3 getPoint(double t) {
    var fi = t * Math.PI * 2;
    var x = Math.cos(2 * fi) * (1 + 0.45 * Math.cos(3 * fi) + 0.4 * Math.cos(9 * fi)),
        y = Math.sin(2 * fi) * (1 + 0.45 * Math.cos(3 * fi) + 0.4 * Math.cos(9 * fi)),
        z = 0.2 * Math.sin(9 * fi);

    return new Vector3(x, y, z).scale(scale);    
  }
}

class DecoratedTorusKnot5a extends Curve3D {
  double scale;
  
  DecoratedTorusKnot5a([this.scale = 40.0]);
  
  Vector3 getPoint(double t) {
    var fi = t * Math.PI * 2;
    var x = Math.cos(3 * fi) * (1 + 0.3 * Math.cos(5 * fi) + 0.5 * Math.cos(10 * fi)),
        y = Math.sin(3 * fi) * (1 + 0.3 * Math.cos(5 * fi) + 0.5 * Math.cos(10 * fi)),
        z = 0.2 * Math.sin(20 * fi);

    return new Vector3(x, y, z)..scale(scale);
  }
}

class DecoratedTorusKnot5c extends Curve3D {
  double scale;
  
  DecoratedTorusKnot5c([this.scale = 40.0]);
  
  Vector3 getPoint(double t) {
    var fi = t * Math.PI * 2;
    var x = Math.cos(4 * fi) * (1 + 0.5 * (Math.cos(5 * fi) + 0.4 * Math.cos(20 * fi))),
        y = Math.sin(4 * fi) * (1 + 0.5 * (Math.cos(5 * fi) + 0.4 * Math.cos(20 * fi))),
        z = 0.35 * Math.sin(15 * fi);

    return new Vector3(x, y, z)..scale(scale);
  }
}


