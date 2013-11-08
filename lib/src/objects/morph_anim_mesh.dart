part of three;

class MorphAnimMesh extends Mesh {
  num duration;
  bool mirroredLoop;
  num time;

  num lastKeyframe, currentKeyframe;

  num direction;
  bool directionBackwards;

  num _startKeyframe, _endKeyframe, _length;

  MorphAnimMesh(Geometry geometry, Material material)
      : duration = 1000, // milliseconds
        mirroredLoop = false,
        time = 0,

        lastKeyframe = 0,
        currentKeyframe = 0,

        direction = 1,
        directionBackwards = false,

        super(geometry, material) {

        setFrameRange( 0, geometry.morphTargets.length - 1 );
  }

  setFrameRange( start, end ) {
    _startKeyframe = start;
    _endKeyframe = end;

    _length = _endKeyframe - _startKeyframe + 1;
  }

  setDirectionForward() {
    direction = 1;
    directionBackwards = false;
  }

  setDirectionBackward() {
    direction = -1;
    directionBackwards = true;
  }

  parseAnimations() {

    if ( geometry["animations"] == null ) geometry["animations"] = {};

    var firstAnimation, animations = geometry["animations"];

    RegExp pattern = new RegExp('''([a-z]+)(\d+)''');

    var il = geometry.morphTargets.length;
    for ( var i = 0; i < il; i ++ ) {

      var morph = geometry.morphTargets[ i ];
      // TODO(aforsell) Is this really correct use of RegExp?
      var parts = morph.name.allMatches( pattern.toString() ).toList();

      if ( parts && parts.length > 1 ) {

        var label = parts[ 1 ];
        var num = parts[ 2 ];

        if ( ! animations[ label ] ) animations[ label ] = { "start": double.INFINITY, "end": double.NEGATIVE_INFINITY };

        var animation = animations[ label ];

        if ( i < animation.start ) animation.start = i;
        if ( i > animation.end ) animation.end = i;

        if ( ! firstAnimation ) firstAnimation = label;

      }

    }

    geometry["firstAnimation"] = firstAnimation;

  }

  setAnimationLabel( label, start, end ) {

    if ( geometry["animations"] == null ) geometry["animations"] = {};

    geometry["animations"][ label ] = { "start": start, "end": end };

  }

  playAnimation( label, fps ) {

    var animation = geometry["animations"][ label ];

    if ( animation != null) {

      setFrameRange( animation.start, animation.end );
      duration = 1000 * ( ( animation.end - animation.start ) / fps );
      time = 0;

    } else {

      print( "animation[$label] undefined" );

    }

  }

  updateAnimation( delta ) {

    var frameTime = duration / _length;

    time += direction * delta;

    if ( mirroredLoop ) {

      if ( time > duration || time < 0 ) {

        direction *= -1;

        if ( time > duration ) {

          time = duration;
          directionBackwards = true;

        }

        if ( time < 0 ) {

          time = 0;
          directionBackwards = false;

        }

      }

    } else {

      time = time % duration;

      if ( time < 0 ) time += duration;

    }

    var keyframe = _startKeyframe + ThreeMath.clamp( ( time / frameTime ).floor(), 0, _length - 1 );

    if ( keyframe != currentKeyframe ) {

      morphTargetInfluences[ lastKeyframe ] = 0;
      morphTargetInfluences[ currentKeyframe ] = 1;

      morphTargetInfluences[ keyframe ] = 0;

      lastKeyframe = currentKeyframe;
      currentKeyframe = keyframe;

    }

    var mix = ( time % frameTime ) / frameTime;

    if ( directionBackwards ) {

      mix = 1 - mix;

    }

    morphTargetInfluences[ currentKeyframe ] = mix;
    morphTargetInfluences[ lastKeyframe ] = 1 - mix;

  }
}
