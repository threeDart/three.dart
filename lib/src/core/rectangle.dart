part of three;

/**
 * @author mr.doob / http://mrdoob.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Rectangle {
  num _left, _top, _right, _bottom, _width, _height;
  bool _isEmpty;

  Rectangle()
      : _left = 0,
        _top = 0,
        _right = 0,
        _bottom = 0,
        _width = 0,
        _height = 0,
        _isEmpty = true;

  resize() {
    _width = _right - _left;
    _height = _bottom - _top;
  }

  num getX() => _left;
  num getY() => _top;
  num getWidth() => _width;
  num getHeight() => _height;
  num getLeft() => _left;
  num getTop() => _top;
  num getRight() => _right;
  num getBottom() => _bottom;

  setValues( num left, num top, num right, num bottom ) {
    _isEmpty = false;

    _left = left; _top = top;
    _right = right; _bottom = bottom;

    resize();
  }

  addPoint( num x, num y ) {
    if ( _isEmpty ) {
      _isEmpty = false;
      _left = x; _top = y;
      _right = x; _bottom = y;

      resize();
    } else {
      _left = _left < x ? _left : x; // Math.min( _left, x );
      _top = _top < y ? _top : y; // Math.min( _top, y );
      _right = _right > x ? _right : x; // Math.max( _right, x );
      _bottom = _bottom > y ? _bottom : y; // Math.max( _bottom, y );

      resize();
    }
  }

  add3Points( num x1, num y1, num x2, num y2, num x3, num y3 ) {
    if (_isEmpty) {
      _isEmpty = false;
      _left = x1 < x2 ? ( x1 < x3 ? x1 : x3 ) : ( x2 < x3 ? x2 : x3 );
      _top = y1 < y2 ? ( y1 < y3 ? y1 : y3 ) : ( y2 < y3 ? y2 : y3 );
      _right = x1 > x2 ? ( x1 > x3 ? x1 : x3 ) : ( x2 > x3 ? x2 : x3 );
      _bottom = y1 > y2 ? ( y1 > y3 ? y1 : y3 ) : ( y2 > y3 ? y2 : y3 );

      resize();
    } else {
      _left = x1 < x2 ? ( x1 < x3 ? ( x1 < _left ? x1 : _left ) : ( x3 < _left ? x3 : _left ) ) : ( x2 < x3 ? ( x2 < _left ? x2 : _left ) : ( x3 < _left ? x3 : _left ) );
      _top = y1 < y2 ? ( y1 < y3 ? ( y1 < _top ? y1 : _top ) : ( y3 < _top ? y3 : _top ) ) : ( y2 < y3 ? ( y2 < _top ? y2 : _top ) : ( y3 < _top ? y3 : _top ) );
      _right = x1 > x2 ? ( x1 > x3 ? ( x1 > _right ? x1 : _right ) : ( x3 > _right ? x3 : _right ) ) : ( x2 > x3 ? ( x2 > _right ? x2 : _right ) : ( x3 > _right ? x3 : _right ) );
      _bottom = y1 > y2 ? ( y1 > y3 ? ( y1 > _bottom ? y1 : _bottom ) : ( y3 > _bottom ? y3 : _bottom ) ) : ( y2 > y3 ? ( y2 > _bottom ? y2 : _bottom ) : ( y3 > _bottom ? y3 : _bottom ) );

      resize();
    }
  }

  addRectangle( Rectangle r ) {
    if ( _isEmpty )
    {
      _isEmpty = false;
      _left = r.getLeft(); _top = r.getTop();
      _right = r.getRight(); _bottom = r.getBottom();

      resize();
    } else {
      _left = _left < r.getLeft() ? _left : r.getLeft(); // Math.min(_left, r.getLeft() );
      _top = _top < r.getTop() ? _top : r.getTop(); // Math.min(_top, r.getTop() );
      _right = _right > r.getRight() ? _right : r.getRight(); // Math.max(_right, r.getRight() );
      _bottom = _bottom > r.getBottom() ? _bottom : r.getBottom(); // Math.max(_bottom, r.getBottom() );

      resize();
    }
  }

  inflate( num v ) {
    _left -= v; _top -= v;
    _right += v; _bottom += v;

    resize();
  }

  minSelf( Rectangle r ) {
    _left = _left > r.getLeft() ? _left : r.getLeft(); // Math.max( _left, r.getLeft() );
    _top = _top > r.getTop() ? _top : r.getTop(); // Math.max( _top, r.getTop() );
    _right = _right < r.getRight() ? _right : r.getRight(); // Math.min( _right, r.getRight() );
    _bottom = _bottom < r.getBottom() ? _bottom : r.getBottom(); // Math.min( _bottom, r.getBottom() );

    resize();
  }

  bool intersects ( Rectangle r ) {
    // http://gamemath.com/2011/09/detecting-whether-two-boxes-overlap/

    if ( _right < r.getLeft() ) return false;
    if ( _left > r.getRight() ) return false;
    if ( _bottom < r.getTop() ) return false;
    if ( _top > r.getBottom() ) return false;

    return true;
  }

  empty() {
    _isEmpty = true;

    _left = 0; _top = 0;
    _right = 0; _bottom = 0;

    resize();
  }

  bool get isEmpty => _isEmpty;

}
