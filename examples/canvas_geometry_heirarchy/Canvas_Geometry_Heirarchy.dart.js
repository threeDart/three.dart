//  ********** Library dart:core **************
//  ********** Natives dart:core **************
function $defProp(obj, prop, value) {
  Object.defineProperty(obj, prop,
      {value: value, enumerable: false, writable: true, configurable: true});
}
$defProp(Object.prototype, '$typeNameOf', (function() {
  function constructorNameWithFallback(obj) {
    var constructor = obj.constructor;
    if (typeof(constructor) == 'function') {
      // The constructor isn't null or undefined at this point. Try
      // to grab hold of its name.
      var name = constructor.name;
      // If the name is a non-empty string, we use that as the type
      // name of this object. On Firefox, we often get 'Object' as
      // the constructor name even for more specialized objects so
      // we have to fall through to the toString() based implementation
      // below in that case.
      if (typeof(name) == 'string' && name && name != 'Object') return name;
    }
    var string = Object.prototype.toString.call(obj);
    return string.substring(8, string.length - 1);
  }

  function chrome$typeNameOf() {
    return this.constructor.name;
  }

  function firefox$typeNameOf() {
    var name = constructorNameWithFallback(this);
    if (name == 'Window') return 'DOMWindow';
    if (name == 'Document') return 'HTMLDocument';
    if (name == 'XMLDocument') return 'Document';
    return name;
  }

  function ie$typeNameOf() {
    var name = constructorNameWithFallback(this);
    if (name == 'Window') return 'DOMWindow';
    // IE calls both HTML and XML documents 'Document', so we check for the
    // xmlVersion property, which is the empty string on HTML documents.
    if (name == 'Document' && this.xmlVersion) return 'Document';
    if (name == 'Document') return 'HTMLDocument';
    return name;
  }

  // If we're not in the browser, we're almost certainly running on v8.
  if (typeof(navigator) != 'object') return chrome$typeNameOf;

  var userAgent = navigator.userAgent;
  if (/Chrome/.test(userAgent)) return chrome$typeNameOf;
  if (/Firefox/.test(userAgent)) return firefox$typeNameOf;
  if (/MSIE/.test(userAgent)) return ie$typeNameOf;
  return function() { return constructorNameWithFallback(this); };
})());
function $throw(e) {
  // If e is not a value, we can use V8's captureStackTrace utility method.
  // TODO(jmesserly): capture the stack trace on other JS engines.
  if (e && (typeof e == 'object') && Error.captureStackTrace) {
    // TODO(jmesserly): this will clobber the e.stack property
    Error.captureStackTrace(e, $throw);
  }
  throw e;
}
$defProp(Object.prototype, '$index', function(i) {
  $throw(new NoSuchMethodException(this, "operator []", [i]));
});
$defProp(Array.prototype, '$index', function(index) {
  var i = index | 0;
  if (i !== index) {
    throw new IllegalArgumentException('index is not int');
  } else if (i < 0 || i >= this.length) {
    throw new IndexOutOfRangeException(index);
  }
  return this[i];
});
$defProp(String.prototype, '$index', function(i) {
  return this[i];
});
$defProp(Object.prototype, '$setindex', function(i, value) {
  $throw(new NoSuchMethodException(this, "operator []=", [i, value]));
});
$defProp(Array.prototype, '$setindex', function(index, value) {
  var i = index | 0;
  if (i !== index) {
    throw new IllegalArgumentException('index is not int');
  } else if (i < 0 || i >= this.length) {
    throw new IndexOutOfRangeException(index);
  }
  return this[i] = value;
});
function $wrap_call$0(fn) { return fn; }
function $wrap_call$1(fn) { return fn; }
function $add$complex$(x, y) {
  if (typeof(x) == 'number') {
    $throw(new IllegalArgumentException(y));
  } else if (typeof(x) == 'string') {
    var str = (y == null) ? 'null' : y.toString();
    if (typeof(str) != 'string') {
      throw new Error("calling toString() on right hand operand of operator " +
      "+ did not return a String");
    }
    return x + str;
  } else if (typeof(x) == 'object') {
    return x.$add(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator +", [y]));
  }
}

function $add$(x, y) {
  if (typeof(x) == 'number' && typeof(y) == 'number') return x + y;
  return $add$complex$(x, y);
}
function $div$complex$(x, y) {
  if (typeof(x) == 'number') {
    $throw(new IllegalArgumentException(y));
  } else if (typeof(x) == 'object') {
    return x.$div(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator /", [y]));
  }
}
function $div$(x, y) {
  if (typeof(x) == 'number' && typeof(y) == 'number') return x / y;
  return $div$complex$(x, y);
}
function $eq$(x, y) {
  if (x == null) return y == null;
  return (typeof(x) != 'object') ? x === y : x.$eq(y);
}
// TODO(jimhug): Should this or should it not match equals?
$defProp(Object.prototype, '$eq', function(other) {
  return this === other;
});
function $lt$complex$(x, y) {
  if (typeof(x) == 'number') {
    $throw(new IllegalArgumentException(y));
  } else if (typeof(x) == 'object') {
    return x.$lt(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator <", [y]));
  }
}
function $lt$(x, y) {
  if (typeof(x) == 'number' && typeof(y) == 'number') return x < y;
  return $lt$complex$(x, y);
}
function $mul$complex$(x, y) {
  if (typeof(x) == 'number') {
    $throw(new IllegalArgumentException(y));
  } else if (typeof(x) == 'object') {
    return x.$mul(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator *", [y]));
  }
}
function $mul$(x, y) {
  if (typeof(x) == 'number' && typeof(y) == 'number') return x * y;
  return $mul$complex$(x, y);
}
function $ne$(x, y) {
  if (x == null) return y != null;
  return (typeof(x) != 'object') ? x !== y : !x.$eq(y);
}
function $negate$(x) {
  if (typeof(x) == 'number') return -x;
  if (typeof(x) == 'object') return x.$negate();
  $throw(new NoSuchMethodException(x, "operator negate", []));
}
function $sar$complex$(x, y) {
  if (typeof(x) == 'number') {
    $throw(new IllegalArgumentException(y));
  } else if (typeof(x) == 'object') {
    return x.$sar(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator >>", [y]));
  }
}
function $sar$(x, y) {
  if (typeof(x) == 'number' && typeof(y) == 'number') return x >> y;
  return $sar$complex$(x, y);
}
function $sub$complex$(x, y) {
  if (typeof(x) == 'number') {
    $throw(new IllegalArgumentException(y));
  } else if (typeof(x) == 'object') {
    return x.$sub(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator -", [y]));
  }
}
function $sub$(x, y) {
  if (typeof(x) == 'number' && typeof(y) == 'number') return x - y;
  return $sub$complex$(x, y);
}
function $truncdiv$(x, y) {
  if (typeof(x) == 'number') {
    if (typeof(y) == 'number') {
      if (y == 0) $throw(new IntegerDivisionByZeroException());
      var tmp = x / y;
      return (tmp < 0) ? Math.ceil(tmp) : Math.floor(tmp);
    } else {
      $throw(new IllegalArgumentException(y));
    }
  } else if (typeof(x) == 'object') {
    return x.$truncdiv(y);
  } else {
    $throw(new NoSuchMethodException(x, "operator ~/", [y]));
  }
}
$defProp(Object.prototype, "get$typeName", Object.prototype.$typeNameOf);
// ********** Code for Object **************
$defProp(Object.prototype, "get$dynamic", function() {
  "use strict"; return this;
});
$defProp(Object.prototype, "noSuchMethod", function(name, args) {
  $throw(new NoSuchMethodException(this, name, args));
});
$defProp(Object.prototype, "addEventListener$3", function($0, $1, $2) {
  return this.noSuchMethod("addEventListener", [$0, $1, $2]);
});
$defProp(Object.prototype, "drawImage$3", function($0, $1, $2) {
  return this.noSuchMethod("drawImage", [$0, $1, $2]);
});
$defProp(Object.prototype, "drawImage$5", function($0, $1, $2, $3, $4) {
  return this.noSuchMethod("drawImage", [$0, $1, $2, $3, $4]);
});
$defProp(Object.prototype, "getContext$0", function() {
  return this.noSuchMethod("getContext", []);
});
$defProp(Object.prototype, "indexOf$1", function($0) {
  return this.noSuchMethod("indexOf", [$0]);
});
$defProp(Object.prototype, "is$CanvasElement", function() {
  return false;
});
$defProp(Object.prototype, "is$Collection", function() {
  return false;
});
$defProp(Object.prototype, "is$ITextureMapMaterial", function() {
  return false;
});
$defProp(Object.prototype, "is$IVector4", function() {
  return false;
});
$defProp(Object.prototype, "is$ImageElement", function() {
  return false;
});
$defProp(Object.prototype, "is$List", function() {
  return false;
});
$defProp(Object.prototype, "is$Map", function() {
  return false;
});
$defProp(Object.prototype, "map$1", function($0) {
  return this.noSuchMethod("map", [$0]);
});
$defProp(Object.prototype, "moveTo$2", function($0, $1) {
  return this.noSuchMethod("moveTo", [$0, $1]);
});
$defProp(Object.prototype, "program$1", function($0) {
  return this.noSuchMethod("program", [$0]);
});
$defProp(Object.prototype, "putImageData$3", function($0, $1, $2) {
  return this.noSuchMethod("putImageData", [$0, $1, $2]);
});
$defProp(Object.prototype, "rotate$1", function($0) {
  return this.noSuchMethod("rotate", [$0]);
});
$defProp(Object.prototype, "scale$2", function($0, $1) {
  return this.noSuchMethod("scale", [$0, $1]);
});
$defProp(Object.prototype, "setInterval$2", function($0, $1) {
  return this.noSuchMethod("setInterval", [$0, $1]);
});
$defProp(Object.prototype, "sort$1", function($0) {
  return this.noSuchMethod("sort", [$0]);
});
$defProp(Object.prototype, "strokeRect$4", function($0, $1, $2, $3) {
  return this.noSuchMethod("strokeRect", [$0, $1, $2, $3]);
});
$defProp(Object.prototype, "transform$6", function($0, $1, $2, $3, $4, $5) {
  return this.noSuchMethod("transform", [$0, $1, $2, $3, $4, $5]);
});
$defProp(Object.prototype, "translate$2", function($0, $1) {
  return this.noSuchMethod("translate", [$0, $1]);
});
// ********** Code for IndexOutOfRangeException **************
function IndexOutOfRangeException(_index) {
  this._index = _index;
}
IndexOutOfRangeException.prototype.is$IndexOutOfRangeException = function(){return true};
IndexOutOfRangeException.prototype.toString = function() {
  return ("IndexOutOfRangeException: " + this._index);
}
// ********** Code for IllegalAccessException **************
function IllegalAccessException() {

}
IllegalAccessException.prototype.toString = function() {
  return "Attempt to modify an immutable object";
}
// ********** Code for NoSuchMethodException **************
function NoSuchMethodException(_receiver, _functionName, _arguments, _existingArgumentNames) {
  this._existingArgumentNames = _existingArgumentNames;
  this._receiver = _receiver;
  this._functionName = _functionName;
  this._arguments = _arguments;
}
NoSuchMethodException.prototype.is$NoSuchMethodException = function(){return true};
NoSuchMethodException.prototype.toString = function() {
  var sb = new StringBufferImpl("");
  for (var i = (0);
   i < this._arguments.get$length(); i++) {
    if (i > (0)) {
      sb.add(", ");
    }
    sb.add(this._arguments.$index(i));
  }
  if (null == this._existingArgumentNames) {
    return $add$($add$(("NoSuchMethodException : method not found: '" + this._functionName + "'\n"), ("Receiver: " + this._receiver + "\n")), ("Arguments: [" + sb + "]"));
  }
  else {
    var actualParameters = sb.toString();
    sb = new StringBufferImpl("");
    for (var i = (0);
     i < this._existingArgumentNames.get$length(); i++) {
      if (i > (0)) {
        sb.add(", ");
      }
      sb.add(this._existingArgumentNames.$index(i));
    }
    var formalParameters = sb.toString();
    return $add$($add$($add$("NoSuchMethodException: incorrect number of arguments passed to ", ("method named '" + this._functionName + "'\nReceiver: " + this._receiver + "\n")), ("Tried calling: " + this._functionName + "(" + actualParameters + ")\n")), ("Found: " + this._functionName + "(" + formalParameters + ")"));
  }
}
// ********** Code for ClosureArgumentMismatchException **************
function ClosureArgumentMismatchException() {

}
ClosureArgumentMismatchException.prototype.toString = function() {
  return "Closure argument mismatch";
}
// ********** Code for IllegalArgumentException **************
function IllegalArgumentException(arg) {
  this._arg = arg;
}
IllegalArgumentException.prototype.is$IllegalArgumentException = function(){return true};
IllegalArgumentException.prototype.toString = function() {
  return ("Illegal argument(s): " + this._arg);
}
// ********** Code for NoMoreElementsException **************
function NoMoreElementsException() {

}
NoMoreElementsException.prototype.toString = function() {
  return "NoMoreElementsException";
}
// ********** Code for EmptyQueueException **************
function EmptyQueueException() {

}
EmptyQueueException.prototype.toString = function() {
  return "EmptyQueueException";
}
// ********** Code for UnsupportedOperationException **************
function UnsupportedOperationException(_message) {
  this._message = _message;
}
UnsupportedOperationException.prototype.toString = function() {
  return ("UnsupportedOperationException: " + this._message);
}
// ********** Code for IntegerDivisionByZeroException **************
function IntegerDivisionByZeroException() {

}
IntegerDivisionByZeroException.prototype.is$IntegerDivisionByZeroException = function(){return true};
IntegerDivisionByZeroException.prototype.toString = function() {
  return "IntegerDivisionByZeroException";
}
// ********** Code for dart_core_Function **************
Function.prototype.to$call$0 = function() {
  this.call$0 = this._genStub(0);
  this.to$call$0 = function() { return this.call$0; };
  return this.call$0;
};
Function.prototype.call$0 = function() {
  return this.to$call$0()();
};
function to$call$0(f) { return f && f.to$call$0(); }
Function.prototype.to$call$1 = function() {
  this.call$1 = this._genStub(1);
  this.to$call$1 = function() { return this.call$1; };
  return this.call$1;
};
Function.prototype.call$1 = function($0) {
  return this.to$call$1()($0);
};
function to$call$1(f) { return f && f.to$call$1(); }
Function.prototype.to$call$2 = function() {
  this.call$2 = this._genStub(2);
  this.to$call$2 = function() { return this.call$2; };
  return this.call$2;
};
Function.prototype.call$2 = function($0, $1) {
  return this.to$call$2()($0, $1);
};
function to$call$2(f) { return f && f.to$call$2(); }
// ********** Code for Math **************
Math.min = function(a, b) {
  if (a == b) return a;
    if (a < b) {
      if (isNaN(b)) return b;
      else return a;
    }
    if (isNaN(a)) return a;
    else return b;
}
Math.max = function(a, b) {
  return (a >= b) ? a : b;
}
// ********** Code for top level **************
//  ********** Library dart:coreimpl **************
// ********** Code for ListFactory **************
ListFactory = Array;
$defProp(ListFactory.prototype, "is$List", function(){return true});
$defProp(ListFactory.prototype, "is$Collection", function(){return true});
$defProp(ListFactory.prototype, "get$length", function() { return this.length; });
$defProp(ListFactory.prototype, "set$length", function(value) { return this.length = value; });
$defProp(ListFactory.prototype, "add", function(value) {
  this.push(value);
});
$defProp(ListFactory.prototype, "addAll", function(collection) {
  for (var $$i = collection.iterator(); $$i.hasNext(); ) {
    var item = $$i.next();
    this.add(item);
  }
});
$defProp(ListFactory.prototype, "clear", function() {
  this.set$length((0));
});
$defProp(ListFactory.prototype, "removeLast", function() {
  return this.pop();
});
$defProp(ListFactory.prototype, "removeRange", function(start, length) {
      if (length == 0) return;
      if (length < 0) throw new IllegalArgumentException('length');
      if (start < 0 || start + length > this.length)
        throw new IndexOutOfRangeException(start);
      this.splice(start, length);
    
});
$defProp(ListFactory.prototype, "get$map", function() {
  return this.map.bind(this);
});
Function.prototype.bind = Function.prototype.bind ||
  function(thisObj) {
    var func = this;
    var funcLength = func.$length || func.length;
    var argsLength = arguments.length;
    if (argsLength > 1) {
      var boundArgs = Array.prototype.slice.call(arguments, 1);
      var bound = function() {
        // Prepend the bound arguments to the current arguments.
        var newArgs = Array.prototype.slice.call(arguments);
        Array.prototype.unshift.apply(newArgs, boundArgs);
        return func.apply(thisObj, newArgs);
      };
      bound.$length = Math.max(0, funcLength - (argsLength - 1));
      return bound;
    } else {
      var bound = function() {
        return func.apply(thisObj, arguments);
      };
      bound.$length = funcLength;
      return bound;
    }
  };
$defProp(ListFactory.prototype, "iterator", function() {
  return new ListIterator(this);
});
$defProp(ListFactory.prototype, "toString", function() {
  return Collections.collectionToString(this);
});
$defProp(ListFactory.prototype, "indexOf$1", ListFactory.prototype.indexOf);
$defProp(ListFactory.prototype, "map$1", function($0) {
  return this.map(to$call$1($0));
});
$defProp(ListFactory.prototype, "sort$1", function($0) {
  return this.sort(to$call$2($0));
});
// ********** Code for ListIterator **************
function ListIterator(array) {
  this._array = array;
  this._pos = (0);
}
ListIterator.prototype.hasNext = function() {
  return this._array.get$length() > this._pos;
}
ListIterator.prototype.next = function() {
  if (!this.hasNext()) {
    $throw(const$0001);
  }
  return this._array.$index(this._pos++);
}
// ********** Code for ImmutableMap **************
function ImmutableMap(keyValuePairs) {
  this._internal = _map(keyValuePairs);
}
ImmutableMap.prototype.is$Map = function(){return true};
ImmutableMap.prototype.$index = function(key) {
  return this._internal.$index(key);
}
ImmutableMap.prototype.get$length = function() {
  return this._internal.get$length();
}
ImmutableMap.prototype.forEach = function(f) {
  this._internal.forEach(f);
}
ImmutableMap.prototype.containsKey = function(key) {
  return this._internal.containsKey(key);
}
ImmutableMap.prototype.$setindex = function(key, value) {
  $throw(const$0013);
}
ImmutableMap.prototype.putIfAbsent = function(key, ifAbsent) {
  $throw(const$0013);
}
ImmutableMap.prototype.toString = function() {
  return Maps.mapToString(this);
}
// ********** Code for NumImplementation **************
NumImplementation = Number;
NumImplementation.prototype.$negate = function() {
  'use strict'; return -this;
}
NumImplementation.prototype.abs = function() {
  'use strict'; return Math.abs(this);
}
NumImplementation.prototype.round = function() {
  'use strict'; return Math.round(this);
}
NumImplementation.prototype.floor = function() {
  'use strict'; return Math.floor(this);
}
NumImplementation.prototype.hashCode = function() {
  'use strict'; return this & 0x1FFFFFFF;
}
// ********** Code for Collections **************
function Collections() {}
Collections.collectionToString = function(c) {
  var result = new StringBufferImpl("");
  Collections._emitCollection(c, result, new Array());
  return result.toString();
}
Collections._emitCollection = function(c, result, visiting) {
  visiting.add(c);
  var isList = !!(c && c.is$List());
  result.add(isList ? "[" : "{");
  var first = true;
  for (var $$i = c.iterator(); $$i.hasNext(); ) {
    var e = $$i.next();
    if (!first) {
      result.add(", ");
    }
    first = false;
    Collections._emitObject(e, result, visiting);
  }
  result.add(isList ? "]" : "}");
  visiting.removeLast();
}
Collections._emitObject = function(o, result, visiting) {
  if (!!(o && o.is$Collection())) {
    if (Collections._containsRef(visiting, o)) {
      result.add(!!(o && o.is$List()) ? "[...]" : "{...}");
    }
    else {
      Collections._emitCollection(o, result, visiting);
    }
  }
  else if (!!(o && o.is$Map())) {
    if (Collections._containsRef(visiting, o)) {
      result.add("{...}");
    }
    else {
      Maps._emitMap(o, result, visiting);
    }
  }
  else {
    result.add($eq$(o) ? "null" : o);
  }
}
Collections._containsRef = function(c, ref) {
  for (var $$i = c.iterator(); $$i.hasNext(); ) {
    var e = $$i.next();
    if ((null == e ? null == (ref) : e === ref)) return true;
  }
  return false;
}
// ********** Code for HashMapImplementation **************
function HashMapImplementation() {
  this._numberOfEntries = (0);
  this._numberOfDeleted = (0);
  this._loadLimit = HashMapImplementation._computeLoadLimit((8));
  this._keys = new Array((8));
  this._values = new Array((8));
}
HashMapImplementation.prototype.is$Map = function(){return true};
HashMapImplementation._computeLoadLimit = function(capacity) {
  return $truncdiv$((capacity * (3)), (4));
}
HashMapImplementation._firstProbe = function(hashCode, length) {
  return hashCode & (length - (1));
}
HashMapImplementation._nextProbe = function(currentProbe, numberOfProbes, length) {
  return (currentProbe + numberOfProbes) & (length - (1));
}
HashMapImplementation.prototype._probeForAdding = function(key) {
  var hash = HashMapImplementation._firstProbe(key.hashCode(), this._keys.get$length());
  var numberOfProbes = (1);
  var initialHash = hash;
  var insertionIndex = (-1);
  while (true) {
    var existingKey = this._keys.$index(hash);
    if (null == existingKey) {
      if (insertionIndex < (0)) return hash;
      return insertionIndex;
    }
    else if ($eq$(existingKey, key)) {
      return hash;
    }
    else if ((insertionIndex < (0)) && ((null == const$0000 ? null == (existingKey) : const$0000 === existingKey))) {
      insertionIndex = hash;
    }
    hash = HashMapImplementation._nextProbe(hash, numberOfProbes++, this._keys.get$length());
  }
}
HashMapImplementation.prototype._probeForLookup = function(key) {
  var hash = HashMapImplementation._firstProbe(key.hashCode(), this._keys.get$length());
  var numberOfProbes = (1);
  var initialHash = hash;
  while (true) {
    var existingKey = this._keys.$index(hash);
    if (null == existingKey) return (-1);
    if ($eq$(existingKey, key)) return hash;
    hash = HashMapImplementation._nextProbe(hash, numberOfProbes++, this._keys.get$length());
  }
}
HashMapImplementation.prototype._ensureCapacity = function() {
  var newNumberOfEntries = this._numberOfEntries + (1);
  if (newNumberOfEntries >= this._loadLimit) {
    this._grow(this._keys.get$length() * (2));
    return;
  }
  var capacity = this._keys.get$length();
  var numberOfFreeOrDeleted = capacity - newNumberOfEntries;
  var numberOfFree = numberOfFreeOrDeleted - this._numberOfDeleted;
  if (this._numberOfDeleted > numberOfFree) {
    this._grow(this._keys.get$length());
  }
}
HashMapImplementation._isPowerOfTwo = function(x) {
  return ((x & (x - (1))) == (0));
}
HashMapImplementation.prototype._grow = function(newCapacity) {
  var capacity = this._keys.get$length();
  this._loadLimit = HashMapImplementation._computeLoadLimit(newCapacity);
  var oldKeys = this._keys;
  var oldValues = this._values;
  this._keys = new Array(newCapacity);
  this._values = new Array(newCapacity);
  for (var i = (0);
   i < capacity; i++) {
    var key = oldKeys.$index(i);
    if (null == key || (null == key ? null == (const$0000) : key === const$0000)) {
      continue;
    }
    var value = oldValues.$index(i);
    var newIndex = this._probeForAdding(key);
    this._keys.$setindex(newIndex, key);
    this._values.$setindex(newIndex, value);
  }
  this._numberOfDeleted = (0);
}
HashMapImplementation.prototype.$setindex = function(key, value) {
  var $0;
  this._ensureCapacity();
  var index = this._probeForAdding(key);
  if ((null == this._keys.$index(index)) || ((($0 = this._keys.$index(index)) == null ? null == (const$0000) : $0 === const$0000))) {
    this._numberOfEntries++;
  }
  this._keys.$setindex(index, key);
  this._values.$setindex(index, value);
}
HashMapImplementation.prototype.$index = function(key) {
  var index = this._probeForLookup(key);
  if (index < (0)) return null;
  return this._values.$index(index);
}
HashMapImplementation.prototype.putIfAbsent = function(key, ifAbsent) {
  var index = this._probeForLookup(key);
  if (index >= (0)) return this._values.$index(index);
  var value = ifAbsent();
  this.$setindex(key, value);
  return value;
}
HashMapImplementation.prototype.get$length = function() {
  return this._numberOfEntries;
}
HashMapImplementation.prototype.forEach = function(f) {
  var length = this._keys.get$length();
  for (var i = (0);
   i < length; i++) {
    var key = this._keys.$index(i);
    if ((null != key) && ((null == key ? null != (const$0000) : key !== const$0000))) {
      f(key, this._values.$index(i));
    }
  }
}
HashMapImplementation.prototype.containsKey = function(key) {
  return (this._probeForLookup(key) != (-1));
}
HashMapImplementation.prototype.toString = function() {
  return Maps.mapToString(this);
}
// ********** Code for HashMapImplementation_Dynamic$DoubleLinkedQueueEntry_KeyValuePair **************
/** Implements extends for Dart classes on JavaScript prototypes. */
function $inherits(child, parent) {
  if (child.prototype.__proto__) {
    child.prototype.__proto__ = parent.prototype;
  } else {
    function tmp() {};
    tmp.prototype = parent.prototype;
    child.prototype = new tmp();
    child.prototype.constructor = child;
  }
}
$inherits(HashMapImplementation_Dynamic$DoubleLinkedQueueEntry_KeyValuePair, HashMapImplementation);
function HashMapImplementation_Dynamic$DoubleLinkedQueueEntry_KeyValuePair() {
  this._numberOfEntries = (0);
  this._numberOfDeleted = (0);
  this._loadLimit = HashMapImplementation._computeLoadLimit((8));
  this._keys = new Array((8));
  this._values = new Array((8));
}
HashMapImplementation_Dynamic$DoubleLinkedQueueEntry_KeyValuePair.prototype.is$Map = function(){return true};
// ********** Code for HashSetImplementation **************
function HashSetImplementation() {
  this._backingMap = new HashMapImplementation();
}
HashSetImplementation.prototype.is$Collection = function(){return true};
HashSetImplementation.prototype.add = function(value) {
  this._backingMap.$setindex(value, value);
}
HashSetImplementation.prototype.map = function(f) {
  var result = new HashSetImplementation();
  this._backingMap.forEach(function _(key, value) {
    result.add(f(key));
  }
  );
  return result;
}
HashSetImplementation.prototype.get$map = function() {
  return this.map.bind(this);
}
HashSetImplementation.prototype.get$length = function() {
  return this._backingMap.get$length();
}
HashSetImplementation.prototype.iterator = function() {
  return new HashSetIterator(this);
}
HashSetImplementation.prototype.toString = function() {
  return Collections.collectionToString(this);
}
HashSetImplementation.prototype.map$1 = function($0) {
  return this.map(to$call$1($0));
};
// ********** Code for HashSetIterator **************
function HashSetIterator(set_) {
  this._entries = set_._backingMap._keys;
  this._nextValidIndex = (-1);
  this._advance();
}
HashSetIterator.prototype.hasNext = function() {
  var $0;
  if (this._nextValidIndex >= this._entries.get$length()) return false;
  if ((($0 = this._entries.$index(this._nextValidIndex)) == null ? null == (const$0000) : $0 === const$0000)) {
    this._advance();
  }
  return this._nextValidIndex < this._entries.get$length();
}
HashSetIterator.prototype.next = function() {
  if (!this.hasNext()) {
    $throw(const$0001);
  }
  var res = this._entries.$index(this._nextValidIndex);
  this._advance();
  return res;
}
HashSetIterator.prototype._advance = function() {
  var length = this._entries.get$length();
  var entry;
  var deletedKey = const$0000;
  do {
    if (++this._nextValidIndex >= length) break;
    entry = this._entries.$index(this._nextValidIndex);
  }
  while ((null == entry) || ((null == entry ? null == (deletedKey) : entry === deletedKey)))
}
// ********** Code for _DeletedKeySentinel **************
function _DeletedKeySentinel() {

}
// ********** Code for KeyValuePair **************
function KeyValuePair(key, value) {
  this.value = value;
  this.key = key;
}
KeyValuePair.prototype.get$value = function() { return this.value; };
KeyValuePair.prototype.set$value = function(value) { return this.value = value; };
// ********** Code for LinkedHashMapImplementation **************
function LinkedHashMapImplementation() {
  this._map = new HashMapImplementation_Dynamic$DoubleLinkedQueueEntry_KeyValuePair();
  this._list = new DoubleLinkedQueue_KeyValuePair();
}
LinkedHashMapImplementation.prototype.is$Map = function(){return true};
LinkedHashMapImplementation.prototype.$setindex = function(key, value) {
  if (this._map.containsKey(key)) {
    this._map.$index(key).get$element().set$value(value);
  }
  else {
    this._list.addLast(new KeyValuePair(key, value));
    this._map.$setindex(key, this._list.lastEntry());
  }
}
LinkedHashMapImplementation.prototype.$index = function(key) {
  var entry = this._map.$index(key);
  if (null == entry) return null;
  return entry.get$element().get$value();
}
LinkedHashMapImplementation.prototype.putIfAbsent = function(key, ifAbsent) {
  var value = this.$index(key);
  if ((null == this.$index(key)) && !(this.containsKey(key))) {
    value = ifAbsent();
    this.$setindex(key, value);
  }
  return value;
}
LinkedHashMapImplementation.prototype.forEach = function(f) {
  this._list.forEach(function _(entry) {
    f(entry.key, entry.value);
  }
  );
}
LinkedHashMapImplementation.prototype.containsKey = function(key) {
  return this._map.containsKey(key);
}
LinkedHashMapImplementation.prototype.get$length = function() {
  return this._map.get$length();
}
LinkedHashMapImplementation.prototype.toString = function() {
  return Maps.mapToString(this);
}
// ********** Code for Maps **************
function Maps() {}
Maps.mapToString = function(m) {
  var result = new StringBufferImpl("");
  Maps._emitMap(m, result, new Array());
  return result.toString();
}
Maps._emitMap = function(m, result, visiting) {
  visiting.add(m);
  result.add("{");
  var first = true;
  m.forEach((function (k, v) {
    if (!first) {
      result.add(", ");
    }
    first = false;
    Collections._emitObject(k, result, visiting);
    result.add(": ");
    Collections._emitObject(v, result, visiting);
  })
  );
  result.add("}");
  visiting.removeLast();
}
// ********** Code for DoubleLinkedQueueEntry **************
function DoubleLinkedQueueEntry(e) {
  this._element = e;
}
DoubleLinkedQueueEntry.prototype._link = function(p, n) {
  this._next = n;
  this._previous = p;
  p._next = this;
  n._previous = this;
}
DoubleLinkedQueueEntry.prototype.prepend = function(e) {
  new DoubleLinkedQueueEntry(e)._link(this._previous, this);
}
DoubleLinkedQueueEntry.prototype._asNonSentinelEntry = function() {
  return this;
}
DoubleLinkedQueueEntry.prototype.previousEntry = function() {
  return this._previous._asNonSentinelEntry();
}
DoubleLinkedQueueEntry.prototype.get$element = function() {
  return this._element;
}
// ********** Code for DoubleLinkedQueueEntry_KeyValuePair **************
$inherits(DoubleLinkedQueueEntry_KeyValuePair, DoubleLinkedQueueEntry);
function DoubleLinkedQueueEntry_KeyValuePair(e) {
  this._element = e;
}
// ********** Code for _DoubleLinkedQueueEntrySentinel **************
$inherits(_DoubleLinkedQueueEntrySentinel, DoubleLinkedQueueEntry);
function _DoubleLinkedQueueEntrySentinel() {
  DoubleLinkedQueueEntry.call(this, null);
  this._link(this, this);
}
_DoubleLinkedQueueEntrySentinel.prototype._asNonSentinelEntry = function() {
  return null;
}
_DoubleLinkedQueueEntrySentinel.prototype.get$element = function() {
  $throw(const$0003);
}
// ********** Code for _DoubleLinkedQueueEntrySentinel_KeyValuePair **************
$inherits(_DoubleLinkedQueueEntrySentinel_KeyValuePair, _DoubleLinkedQueueEntrySentinel);
function _DoubleLinkedQueueEntrySentinel_KeyValuePair() {
  DoubleLinkedQueueEntry_KeyValuePair.call(this, null);
  this._link(this, this);
}
// ********** Code for DoubleLinkedQueue **************
function DoubleLinkedQueue() {
  this._sentinel = new _DoubleLinkedQueueEntrySentinel();
}
DoubleLinkedQueue.prototype.is$Collection = function(){return true};
DoubleLinkedQueue.prototype.addLast = function(value) {
  this._sentinel.prepend(value);
}
DoubleLinkedQueue.prototype.lastEntry = function() {
  return this._sentinel.previousEntry();
}
DoubleLinkedQueue.prototype.get$length = function() {
  var counter = (0);
  this.forEach(function _(element) {
    counter++;
  }
  );
  return counter;
}
DoubleLinkedQueue.prototype.forEach = function(f) {
  var entry = this._sentinel._next;
  while ((null == entry ? null != (this._sentinel) : entry !== this._sentinel)) {
    var nextEntry = entry._next;
    f(entry._element);
    entry = nextEntry;
  }
}
DoubleLinkedQueue.prototype.map = function(f) {
  var other = new DoubleLinkedQueue();
  var entry = this._sentinel._next;
  while ((null == entry ? null != (this._sentinel) : entry !== this._sentinel)) {
    var nextEntry = entry._next;
    other.addLast(f(entry._element));
    entry = nextEntry;
  }
  return other;
}
DoubleLinkedQueue.prototype.get$map = function() {
  return this.map.bind(this);
}
DoubleLinkedQueue.prototype.iterator = function() {
  return new _DoubleLinkedQueueIterator(this._sentinel);
}
DoubleLinkedQueue.prototype.toString = function() {
  return Collections.collectionToString(this);
}
DoubleLinkedQueue.prototype.map$1 = function($0) {
  return this.map(to$call$1($0));
};
// ********** Code for DoubleLinkedQueue_KeyValuePair **************
$inherits(DoubleLinkedQueue_KeyValuePair, DoubleLinkedQueue);
function DoubleLinkedQueue_KeyValuePair() {
  this._sentinel = new _DoubleLinkedQueueEntrySentinel_KeyValuePair();
}
DoubleLinkedQueue_KeyValuePair.prototype.is$Collection = function(){return true};
DoubleLinkedQueue_KeyValuePair.prototype.map$1 = function($0) {
  return this.map(to$call$1($0));
};
// ********** Code for _DoubleLinkedQueueIterator **************
function _DoubleLinkedQueueIterator(_sentinel) {
  this._sentinel = _sentinel;
  this._currentEntry = this._sentinel;
}
_DoubleLinkedQueueIterator.prototype.hasNext = function() {
  var $0;
  return (($0 = this._currentEntry._next) == null ? null != (this._sentinel) : $0 !== this._sentinel);
}
_DoubleLinkedQueueIterator.prototype.next = function() {
  if (!this.hasNext()) {
    $throw(const$0001);
  }
  this._currentEntry = this._currentEntry._next;
  return this._currentEntry.get$element();
}
// ********** Code for StringBufferImpl **************
function StringBufferImpl(content) {
  this.clear();
  this.add(content);
}
StringBufferImpl.prototype.get$length = function() {
  return this._length;
}
StringBufferImpl.prototype.add = function(obj) {
  var str = obj.toString();
  if (null == str || str.isEmpty()) return this;
  this._buffer.add(str);
  this._length = this._length + str.length;
  return this;
}
StringBufferImpl.prototype.clear = function() {
  this._buffer = new Array();
  this._length = (0);
  return this;
}
StringBufferImpl.prototype.toString = function() {
  if (this._buffer.get$length() == (0)) return "";
  if (this._buffer.get$length() == (1)) return this._buffer.$index((0));
  var result = StringBase.concatAll(this._buffer);
  this._buffer.clear();
  this._buffer.add(result);
  return result;
}
// ********** Code for StringBase **************
function StringBase() {}
StringBase.join = function(strings, separator) {
  if (strings.get$length() == (0)) return "";
  var s = strings.$index((0));
  for (var i = (1);
   i < strings.get$length(); i++) {
    s = $add$($add$(s, separator), strings.$index(i));
  }
  return s;
}
StringBase.concatAll = function(strings) {
  return StringBase.join(strings, "");
}
// ********** Code for StringImplementation **************
StringImplementation = String;
StringImplementation.prototype.get$length = function() { return this.length; };
StringImplementation.prototype.isEmpty = function() {
  return this.length == (0);
}
StringImplementation.prototype.hashCode = function() {
      'use strict';
      var hash = 0;
      for (var i = 0; i < this.length; i++) {
        hash = 0x1fffffff & (hash + this.charCodeAt(i));
        hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
        hash ^= hash >> 6;
      }

      hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
      hash ^= hash >> 11;
      return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
StringImplementation.prototype.indexOf$1 = StringImplementation.prototype.indexOf;
// ********** Code for DateImplementation **************
DateImplementation.now$ctor = function() {
  this.timeZone = new TimeZoneImplementation.local$ctor();
  this.value = DateImplementation._now();
  this._asJs();
}
DateImplementation.now$ctor.prototype = DateImplementation.prototype;
function DateImplementation() {}
DateImplementation.prototype.get$value = function() { return this.value; };
DateImplementation.prototype.get$timeZone = function() { return this.timeZone; };
DateImplementation.prototype.$eq = function(other) {
  if (!((other instanceof DateImplementation))) return false;
  return (this.value == other.get$value()) && ($eq$(this.timeZone, other.get$timeZone()));
}
DateImplementation.prototype.get$year = function() {
  return this.isUtc() ? this._asJs().getUTCFullYear() :
      this._asJs().getFullYear();
}
DateImplementation.prototype.get$month = function() {
  return this.isUtc() ? this._asJs().getUTCMonth() + 1 :
        this._asJs().getMonth() + 1;
}
DateImplementation.prototype.get$day = function() {
  return this.isUtc() ? this._asJs().getUTCDate() :
        this._asJs().getDate();
}
DateImplementation.prototype.get$hours = function() {
  return this.isUtc() ? this._asJs().getUTCHours() :
        this._asJs().getHours();
}
DateImplementation.prototype.get$minutes = function() {
  return this.isUtc() ? this._asJs().getUTCMinutes() :
        this._asJs().getMinutes();
}
DateImplementation.prototype.get$seconds = function() {
  return this.isUtc() ? this._asJs().getUTCSeconds() :
        this._asJs().getSeconds();
}
DateImplementation.prototype.get$milliseconds = function() {
  return this.isUtc() ? this._asJs().getUTCMilliseconds() :
      this._asJs().getMilliseconds();
}
DateImplementation.prototype.isUtc = function() {
  return this.timeZone.isUtc;
}
DateImplementation.prototype.get$isUtc = function() {
  return this.isUtc.bind(this);
}
DateImplementation.prototype.toString = function() {
  function threeDigits(n) {
    if (n >= (100)) return ("" + n);
    if (n > (10)) return ("0" + n);
    return ("00" + n);
  }
  function twoDigits(n) {
    if (n >= (10)) return ("" + n);
    return ("0" + n);
  }
  var m = twoDigits(this.get$month());
  var d = twoDigits(this.get$day());
  var h = twoDigits(this.get$hours());
  var min = twoDigits(this.get$minutes());
  var sec = twoDigits(this.get$seconds());
  var ms = threeDigits(this.get$milliseconds());
  if (this.timeZone.isUtc) {
    return ("" + this.get$year() + "-" + m + "-" + d + " " + h + ":" + min + ":" + sec + "." + ms + "Z");
  }
  else {
    return ("" + this.get$year() + "-" + m + "-" + d + " " + h + ":" + min + ":" + sec + "." + ms);
  }
}
DateImplementation._now = function() {
  return new Date().valueOf();
}
DateImplementation.prototype._asJs = function() {
    if (!this.date) {
      this.date = new Date(this.value);
    }
    return this.date;
}
// ********** Code for TimeZoneImplementation **************
TimeZoneImplementation.local$ctor = function() {
  this.isUtc = false;
}
TimeZoneImplementation.local$ctor.prototype = TimeZoneImplementation.prototype;
function TimeZoneImplementation() {}
TimeZoneImplementation.prototype.$eq = function(other) {
  if (!((other instanceof TimeZoneImplementation))) return false;
  return $eq$(this.isUtc, other.get$isUtc());
}
TimeZoneImplementation.prototype.toString = function() {
  if (this.isUtc) return "TimeZone (UTC)";
  return "TimeZone (Local)";
}
TimeZoneImplementation.prototype.get$isUtc = function() { return this.isUtc; };
// ********** Code for _ArgumentMismatchException **************
$inherits(_ArgumentMismatchException, ClosureArgumentMismatchException);
function _ArgumentMismatchException(_message) {
  this._dart_coreimpl_message = _message;
  ClosureArgumentMismatchException.call(this);
}
_ArgumentMismatchException.prototype.toString = function() {
  return ("Closure argument mismatch: " + this._dart_coreimpl_message);
}
// ********** Code for _FunctionImplementation **************
_FunctionImplementation = Function;
_FunctionImplementation.prototype._genStub = function(argsLength, names) {
      // Fast path #1: if no named arguments and arg count matches.
      var thisLength = this.$length || this.length;
      if (thisLength == argsLength && !names) {
        return this;
      }

      var paramsNamed = this.$optional ? (this.$optional.length / 2) : 0;
      var paramsBare = thisLength - paramsNamed;
      var argsNamed = names ? names.length : 0;
      var argsBare = argsLength - argsNamed;

      // Check we got the right number of arguments
      if (argsBare < paramsBare || argsLength > thisLength ||
          argsNamed > paramsNamed) {
        return function() {
          $throw(new _ArgumentMismatchException(
            'Wrong number of arguments to function. Expected ' + paramsBare +
            ' positional arguments and at most ' + paramsNamed +
            ' named arguments, but got ' + argsBare +
            ' positional arguments and ' + argsNamed + ' named arguments.'));
        };
      }

      // First, fill in all of the default values
      var p = new Array(paramsBare);
      if (paramsNamed) {
        p = p.concat(this.$optional.slice(paramsNamed));
      }
      // Fill in positional args
      var a = new Array(argsLength);
      for (var i = 0; i < argsBare; i++) {
        p[i] = a[i] = '$' + i;
      }
      // Then overwrite with supplied values for optional args
      var lastParameterIndex;
      var namesInOrder = true;
      for (var i = 0; i < argsNamed; i++) {
        var name = names[i];
        a[i + argsBare] = name;
        var j = this.$optional.indexOf(name);
        if (j < 0 || j >= paramsNamed) {
          return function() {
            $throw(new _ArgumentMismatchException(
              'Named argument "' + name + '" was not expected by function.' +
              ' Did you forget to mark the function parameter [optional]?'));
          };
        } else if (lastParameterIndex && lastParameterIndex > j) {
          namesInOrder = false;
        }
        p[j + paramsBare] = name;
        lastParameterIndex = j;
      }

      if (thisLength == argsLength && namesInOrder) {
        // Fast path #2: named arguments, but they're in order and all supplied.
        return this;
      }

      // Note: using Function instead of 'eval' to get a clean scope.
      // TODO(jmesserly): evaluate the performance of these stubs.
      var f = 'function(' + a.join(',') + '){return $f(' + p.join(',') + ');}';
      return new Function('$f', 'return ' + f + '').call(null, this);
    
}
// ********** Code for top level **************
function _map(itemsAndKeys) {
  var ret = new LinkedHashMapImplementation();
  for (var i = (0);
   i < itemsAndKeys.get$length(); ) {
    ret.$setindex(itemsAndKeys.$index(i++), itemsAndKeys.$index(i++));
  }
  return ret;
}
function _constMap(itemsAndKeys) {
  return new ImmutableMap(itemsAndKeys);
}
//  ********** Library dom **************
// ********** Code for _DOMTypeJs **************
function $dynamic(name) {
  var f = Object.prototype[name];
  if (f && f.methods) return f.methods;

  var methods = {};
  if (f) methods.Object = f;
  function $dynamicBind() {
    // Find the target method
    var obj = this;
    var tag = obj.$typeNameOf();
    var method = methods[tag];
    if (!method) {
      var table = $dynamicMetadata;
      for (var i = 0; i < table.length; i++) {
        var entry = table[i];
        if (entry.map.hasOwnProperty(tag)) {
          method = methods[entry.tag];
          if (method) break;
        }
      }
    }
    method = method || methods.Object;
    var proto = Object.getPrototypeOf(obj);
    if (!proto.hasOwnProperty(name)) {
      $defProp(proto, name, method);
    }

    return method.apply(this, Array.prototype.slice.call(arguments));
  };
  $dynamicBind.methods = methods;
  $defProp(Object.prototype, name, $dynamicBind);
  return methods;
}
if (typeof $dynamicMetadata == 'undefined') $dynamicMetadata = [];
$dynamic("get$dartObjectLocalStorage").DOMType = function() { return this.dartObjectLocalStorage; };
$dynamic("set$dartObjectLocalStorage").DOMType = function(value) { return this.dartObjectLocalStorage = value; };
// ********** Code for _EventTargetJs **************
$dynamic("addEventListener$3").EventTarget = function($0, $1, $2) {
  if (Object.getPrototypeOf(this).hasOwnProperty("addEventListener$3")) {
    return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
  }
  return Object.prototype.addEventListener$3.call(this, $0, $1, $2);
};
// ********** Code for _AbstractWorkerJs **************
$dynamic("addEventListener$3").AbstractWorker = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _ArrayBufferJs **************
// ********** Code for _ArrayBufferViewJs **************
// ********** Code for _NodeJs **************
$dynamic("get$attributes").Node = function() { return this.attributes; };
$dynamic("get$childNodes").Node = function() { return this.childNodes; };
$dynamic("get$lastChild").Node = function() { return this.lastChild; };
$dynamic("get$parentNode").Node = function() { return this.parentNode; };
$dynamic("set$textContent").Node = function(value) { return this.textContent = value; };
$dynamic("addEventListener$3").Node = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _AttrJs **************
$dynamic("get$name").Attr = function() { return this.name; };
$dynamic("get$value").Attr = function() { return this.value; };
$dynamic("set$value").Attr = function(value) { return this.value = value; };
// ********** Code for _AudioBufferJs **************
$dynamic("get$length").AudioBuffer = function() { return this.length; };
// ********** Code for _AudioNodeJs **************
// ********** Code for _AudioSourceNodeJs **************
// ********** Code for _AudioBufferSourceNodeJs **************
// ********** Code for _AudioChannelMergerJs **************
// ********** Code for _AudioChannelSplitterJs **************
// ********** Code for _AudioContextJs **************
// ********** Code for _AudioDestinationNodeJs **************
// ********** Code for _AudioParamJs **************
$dynamic("get$name").AudioParam = function() { return this.name; };
$dynamic("get$value").AudioParam = function() { return this.value; };
$dynamic("set$value").AudioParam = function(value) { return this.value = value; };
// ********** Code for _AudioGainJs **************
// ********** Code for _AudioGainNodeJs **************
// ********** Code for _AudioListenerJs **************
// ********** Code for _AudioPannerNodeJs **************
// ********** Code for _EventJs **************
// ********** Code for _AudioProcessingEventJs **************
// ********** Code for _BarInfoJs **************
// ********** Code for _BeforeLoadEventJs **************
// ********** Code for _BiquadFilterNodeJs **************
// ********** Code for _BlobJs **************
// ********** Code for _CharacterDataJs **************
$dynamic("get$data").CharacterData = function() { return this.data; };
$dynamic("get$length").CharacterData = function() { return this.length; };
// ********** Code for _TextJs **************
// ********** Code for _CDATASectionJs **************
// ********** Code for _CSSRuleJs **************
// ********** Code for _CSSCharsetRuleJs **************
// ********** Code for _CSSFontFaceRuleJs **************
// ********** Code for _CSSImportRuleJs **************
// ********** Code for _CSSMediaRuleJs **************
// ********** Code for _CSSPageRuleJs **************
// ********** Code for _CSSValueJs **************
// ********** Code for _CSSPrimitiveValueJs **************
// ********** Code for _CSSRuleListJs **************
$dynamic("get$length").CSSRuleList = function() { return this.length; };
// ********** Code for _CSSStyleDeclarationJs **************
$dynamic("get$length").CSSStyleDeclaration = function() { return this.length; };
// ********** Code for _CSSStyleRuleJs **************
// ********** Code for _StyleSheetJs **************
// ********** Code for _CSSStyleSheetJs **************
// ********** Code for _CSSUnknownRuleJs **************
// ********** Code for _CSSValueListJs **************
$dynamic("get$length").CSSValueList = function() { return this.length; };
// ********** Code for _CanvasGradientJs **************
// ********** Code for _CanvasPatternJs **************
// ********** Code for _CanvasPixelArrayJs **************
$dynamic("is$List").CanvasPixelArray = function(){return true};
$dynamic("is$Collection").CanvasPixelArray = function(){return true};
$dynamic("get$length").CanvasPixelArray = function() { return this.length; };
$dynamic("$index").CanvasPixelArray = function(index) {
  return this[index];
}
$dynamic("$setindex").CanvasPixelArray = function(index, value) {
  this[index] = value
}
$dynamic("iterator").CanvasPixelArray = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").CanvasPixelArray = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").CanvasPixelArray = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").CanvasPixelArray = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").CanvasPixelArray = function() {
  return this.map.bind(this);
}
$dynamic("sort").CanvasPixelArray = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").CanvasPixelArray = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").CanvasPixelArray = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").CanvasPixelArray = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").CanvasPixelArray = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").CanvasPixelArray = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _CanvasRenderingContextJs **************
// ********** Code for _CanvasRenderingContext2DJs **************
$dynamic("set$fillStyle").CanvasRenderingContext2D = function(value) { return this.fillStyle = value; };
$dynamic("set$globalAlpha").CanvasRenderingContext2D = function(value) { return this.globalAlpha = value; };
$dynamic("set$globalCompositeOperation").CanvasRenderingContext2D = function(value) { return this.globalCompositeOperation = value; };
$dynamic("set$lineCap").CanvasRenderingContext2D = function(value) { return this.lineCap = value; };
$dynamic("set$lineJoin").CanvasRenderingContext2D = function(value) { return this.lineJoin = value; };
$dynamic("set$lineWidth").CanvasRenderingContext2D = function(value) { return this.lineWidth = value; };
$dynamic("set$strokeStyle").CanvasRenderingContext2D = function(value) { return this.strokeStyle = value; };
$dynamic("get$scale").CanvasRenderingContext2D = function() {
  return this.scale.bind(this);
}
$dynamic("drawImage$3").CanvasRenderingContext2D = function($0, $1, $2) {
  return this.drawImage($0, $1, $2);
};
$dynamic("drawImage$5").CanvasRenderingContext2D = function($0, $1, $2, $3, $4) {
  return this.drawImage($0, $1, $2, $3, $4);
};
$dynamic("moveTo$2").CanvasRenderingContext2D = function($0, $1) {
  return this.moveTo($0, $1);
};
$dynamic("putImageData$3").CanvasRenderingContext2D = function($0, $1, $2) {
  return this.putImageData($0, $1, $2);
};
$dynamic("rotate$1").CanvasRenderingContext2D = function($0) {
  return this.rotate($0);
};
$dynamic("scale$2").CanvasRenderingContext2D = function($0, $1) {
  return this.scale($0, $1);
};
$dynamic("strokeRect$4").CanvasRenderingContext2D = function($0, $1, $2, $3) {
  return this.strokeRect($0, $1, $2, $3);
};
$dynamic("transform$6").CanvasRenderingContext2D = function($0, $1, $2, $3, $4, $5) {
  return this.transform($0, $1, $2, $3, $4, $5);
};
$dynamic("translate$2").CanvasRenderingContext2D = function($0, $1) {
  return this.translate($0, $1);
};
// ********** Code for _ClientRectJs **************
$dynamic("get$height").ClientRect = function() { return this.height; };
$dynamic("get$width").ClientRect = function() { return this.width; };
// ********** Code for _ClientRectListJs **************
$dynamic("get$length").ClientRectList = function() { return this.length; };
// ********** Code for _ClipboardJs **************
// ********** Code for _CloseEventJs **************
// ********** Code for _CommentJs **************
// ********** Code for _UIEventJs **************
// ********** Code for _CompositionEventJs **************
$dynamic("get$data").CompositionEvent = function() { return this.data; };
// ********** Code for _ConsoleJs **************
_ConsoleJs = (typeof console == 'undefined' ? {} : console);
_ConsoleJs.get$dartObjectLocalStorage = function() { return this.dartObjectLocalStorage; };
_ConsoleJs.set$dartObjectLocalStorage = function(value) { return this.dartObjectLocalStorage = value; };
// ********** Code for _ConvolverNodeJs **************
// ********** Code for _CoordinatesJs **************
// ********** Code for _CounterJs **************
// ********** Code for _CryptoJs **************
// ********** Code for _CustomEventJs **************
// ********** Code for _DOMApplicationCacheJs **************
$dynamic("addEventListener$3").DOMApplicationCache = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _DOMExceptionJs **************
$dynamic("get$name").DOMException = function() { return this.name; };
// ********** Code for _DOMFileSystemJs **************
$dynamic("get$name").DOMFileSystem = function() { return this.name; };
// ********** Code for _DOMFileSystemSyncJs **************
$dynamic("get$name").DOMFileSystemSync = function() { return this.name; };
// ********** Code for _DOMFormDataJs **************
// ********** Code for _DOMImplementationJs **************
// ********** Code for _DOMMimeTypeJs **************
// ********** Code for _DOMMimeTypeArrayJs **************
$dynamic("get$length").DOMMimeTypeArray = function() { return this.length; };
// ********** Code for _DOMParserJs **************
// ********** Code for _DOMPluginJs **************
$dynamic("get$length").DOMPlugin = function() { return this.length; };
$dynamic("get$name").DOMPlugin = function() { return this.name; };
// ********** Code for _DOMPluginArrayJs **************
$dynamic("get$length").DOMPluginArray = function() { return this.length; };
// ********** Code for _DOMSelectionJs **************
// ********** Code for _DOMTokenListJs **************
$dynamic("get$length").DOMTokenList = function() { return this.length; };
// ********** Code for _DOMSettableTokenListJs **************
$dynamic("get$value").DOMSettableTokenList = function() { return this.value; };
$dynamic("set$value").DOMSettableTokenList = function(value) { return this.value = value; };
// ********** Code for _DOMURLJs **************
// ********** Code for _DOMWindowJs **************
$dynamic("get$innerHeight").DOMWindow = function() { return this.innerHeight; };
$dynamic("get$innerWidth").DOMWindow = function() { return this.innerWidth; };
$dynamic("get$length").DOMWindow = function() { return this.length; };
$dynamic("get$name").DOMWindow = function() { return this.name; };
$dynamic("addEventListener$3").DOMWindow = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
$dynamic("moveTo$2").DOMWindow = function($0, $1) {
  return this.moveTo($0, $1);
};
$dynamic("setInterval$2").DOMWindow = function($0, $1) {
  return this.setInterval($wrap_call$0(to$call$0($0)), $1);
};
// ********** Code for _DataTransferItemJs **************
// ********** Code for _DataTransferItemListJs **************
$dynamic("get$length").DataTransferItemList = function() { return this.length; };
// ********** Code for _DataViewJs **************
// ********** Code for _DatabaseJs **************
// ********** Code for _DatabaseSyncJs **************
// ********** Code for _WorkerContextJs **************
$dynamic("addEventListener$3").WorkerContext = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
$dynamic("setInterval$2").WorkerContext = function($0, $1) {
  return this.setInterval($wrap_call$0(to$call$0($0)), $1);
};
// ********** Code for _DedicatedWorkerContextJs **************
// ********** Code for _DelayNodeJs **************
// ********** Code for _DeviceMotionEventJs **************
// ********** Code for _DeviceOrientationEventJs **************
// ********** Code for _EntryJs **************
$dynamic("get$name").Entry = function() { return this.name; };
$dynamic("moveTo$2").Entry = function($0, $1) {
  return this.moveTo($0, $1, $wrap_call$1(to$call$1(null)), $wrap_call$1(to$call$1(null)));
};
// ********** Code for _DirectoryEntryJs **************
// ********** Code for _EntrySyncJs **************
$dynamic("get$name").EntrySync = function() { return this.name; };
$dynamic("moveTo$2").EntrySync = function($0, $1) {
  return this.moveTo($0, $1);
};
// ********** Code for _DirectoryEntrySyncJs **************
// ********** Code for _DirectoryReaderJs **************
// ********** Code for _DirectoryReaderSyncJs **************
// ********** Code for _DocumentJs **************
$dynamic("get$body").Document = function() { return this.body; };
$dynamic("get$documentElement").Document = function() { return this.documentElement; };
// ********** Code for _DocumentFragmentJs **************
// ********** Code for _DocumentTypeJs **************
$dynamic("get$name").DocumentType = function() { return this.name; };
// ********** Code for _DynamicsCompressorNodeJs **************
// ********** Code for _ElementJs **************
// ********** Code for _ElementTimeControlJs **************
// ********** Code for _ElementTraversalJs **************
// ********** Code for _EntityJs **************
// ********** Code for _EntityReferenceJs **************
// ********** Code for _EntryArrayJs **************
$dynamic("get$length").EntryArray = function() { return this.length; };
// ********** Code for _EntryArraySyncJs **************
$dynamic("get$length").EntryArraySync = function() { return this.length; };
// ********** Code for _ErrorEventJs **************
// ********** Code for _EventExceptionJs **************
$dynamic("get$name").EventException = function() { return this.name; };
// ********** Code for _EventSourceJs **************
$dynamic("addEventListener$3").EventSource = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _FileJs **************
$dynamic("get$name").File = function() { return this.name; };
// ********** Code for _FileEntryJs **************
// ********** Code for _FileEntrySyncJs **************
// ********** Code for _FileErrorJs **************
// ********** Code for _FileExceptionJs **************
$dynamic("get$name").FileException = function() { return this.name; };
// ********** Code for _FileListJs **************
$dynamic("get$length").FileList = function() { return this.length; };
// ********** Code for _FileReaderJs **************
$dynamic("addEventListener$3").FileReader = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _FileReaderSyncJs **************
// ********** Code for _FileWriterJs **************
$dynamic("get$length").FileWriter = function() { return this.length; };
$dynamic("get$position").FileWriter = function() { return this.position; };
// ********** Code for _FileWriterSyncJs **************
$dynamic("get$length").FileWriterSync = function() { return this.length; };
$dynamic("get$position").FileWriterSync = function() { return this.position; };
// ********** Code for _Float32ArrayJs **************
var _Float32ArrayJs = {};
$dynamic("is$List").Float32Array = function(){return true};
$dynamic("is$Collection").Float32Array = function(){return true};
$dynamic("get$length").Float32Array = function() { return this.length; };
$dynamic("$index").Float32Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Float32Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Float32Array = function() {
  return new dom__FixedSizeListIterator_num(this);
}
$dynamic("add").Float32Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Float32Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Float32Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Float32Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Float32Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Float32Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Float32Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Float32Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Float32Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Float32Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _Float64ArrayJs **************
var _Float64ArrayJs = {};
$dynamic("is$List").Float64Array = function(){return true};
$dynamic("is$Collection").Float64Array = function(){return true};
$dynamic("get$length").Float64Array = function() { return this.length; };
$dynamic("$index").Float64Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Float64Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Float64Array = function() {
  return new dom__FixedSizeListIterator_num(this);
}
$dynamic("add").Float64Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Float64Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Float64Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Float64Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Float64Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Float64Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Float64Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Float64Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Float64Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Float64Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _GeolocationJs **************
// ********** Code for _GeopositionJs **************
// ********** Code for _HTMLAllCollectionJs **************
$dynamic("get$length").HTMLAllCollection = function() { return this.length; };
// ********** Code for _HTMLElementJs **************
$dynamic("get$id").HTMLElement = function() { return this.id; };
// ********** Code for _HTMLAnchorElementJs **************
$dynamic("get$name").HTMLAnchorElement = function() { return this.name; };
// ********** Code for _HTMLAppletElementJs **************
$dynamic("get$height").HTMLAppletElement = function() { return this.height; };
$dynamic("set$height").HTMLAppletElement = function(value) { return this.height = value; };
$dynamic("get$name").HTMLAppletElement = function() { return this.name; };
$dynamic("get$object").HTMLAppletElement = function() { return this.object; };
$dynamic("get$width").HTMLAppletElement = function() { return this.width; };
$dynamic("set$width").HTMLAppletElement = function(value) { return this.width = value; };
// ********** Code for _HTMLAreaElementJs **************
// ********** Code for _HTMLMediaElementJs **************
// ********** Code for _HTMLAudioElementJs **************
// ********** Code for _HTMLBRElementJs **************
// ********** Code for _HTMLBaseElementJs **************
// ********** Code for _HTMLBaseFontElementJs **************
$dynamic("get$color").HTMLBaseFontElement = function() { return this.color; };
// ********** Code for _HTMLBodyElementJs **************
// ********** Code for _HTMLButtonElementJs **************
$dynamic("get$name").HTMLButtonElement = function() { return this.name; };
$dynamic("get$value").HTMLButtonElement = function() { return this.value; };
$dynamic("set$value").HTMLButtonElement = function(value) { return this.value = value; };
// ********** Code for _HTMLCanvasElementJs **************
$dynamic("get$height").HTMLCanvasElement = function() { return this.height; };
$dynamic("set$height").HTMLCanvasElement = function(value) { return this.height = value; };
$dynamic("get$width").HTMLCanvasElement = function() { return this.width; };
$dynamic("set$width").HTMLCanvasElement = function(value) { return this.width = value; };
// ********** Code for _HTMLCollectionJs **************
$dynamic("is$List").HTMLCollection = function(){return true};
$dynamic("is$Collection").HTMLCollection = function(){return true};
$dynamic("get$length").HTMLCollection = function() { return this.length; };
$dynamic("$index").HTMLCollection = function(index) {
  return this[index];
}
$dynamic("$setindex").HTMLCollection = function(index, value) {
  $throw(new UnsupportedOperationException("Cannot assign element of immutable List."));
}
$dynamic("iterator").HTMLCollection = function() {
  return new dom__FixedSizeListIterator_dom_Node(this);
}
$dynamic("add").HTMLCollection = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").HTMLCollection = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").HTMLCollection = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").HTMLCollection = function() {
  return this.map.bind(this);
}
$dynamic("sort").HTMLCollection = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").HTMLCollection = function(element, start) {
  return _Lists.indexOf(this, element, start, this.get$length());
}
$dynamic("removeRange").HTMLCollection = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").HTMLCollection = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").HTMLCollection = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").HTMLCollection = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _HTMLContentElementJs **************
// ********** Code for _HTMLDListElementJs **************
// ********** Code for _HTMLDetailsElementJs **************
// ********** Code for _HTMLDirectoryElementJs **************
// ********** Code for _HTMLDivElementJs **************
// ********** Code for _HTMLDocumentJs **************
// ********** Code for _HTMLEmbedElementJs **************
$dynamic("get$height").HTMLEmbedElement = function() { return this.height; };
$dynamic("set$height").HTMLEmbedElement = function(value) { return this.height = value; };
$dynamic("get$name").HTMLEmbedElement = function() { return this.name; };
$dynamic("get$width").HTMLEmbedElement = function() { return this.width; };
$dynamic("set$width").HTMLEmbedElement = function(value) { return this.width = value; };
// ********** Code for _HTMLFieldSetElementJs **************
// ********** Code for _HTMLFontElementJs **************
$dynamic("get$color").HTMLFontElement = function() { return this.color; };
// ********** Code for _HTMLFormElementJs **************
$dynamic("get$length").HTMLFormElement = function() { return this.length; };
$dynamic("get$name").HTMLFormElement = function() { return this.name; };
// ********** Code for _HTMLFrameElementJs **************
$dynamic("get$height").HTMLFrameElement = function() { return this.height; };
$dynamic("get$name").HTMLFrameElement = function() { return this.name; };
$dynamic("get$width").HTMLFrameElement = function() { return this.width; };
// ********** Code for _HTMLFrameSetElementJs **************
// ********** Code for _HTMLHRElementJs **************
$dynamic("get$width").HTMLHRElement = function() { return this.width; };
$dynamic("set$width").HTMLHRElement = function(value) { return this.width = value; };
// ********** Code for _HTMLHeadElementJs **************
// ********** Code for _HTMLHeadingElementJs **************
// ********** Code for _HTMLHtmlElementJs **************
// ********** Code for _HTMLIFrameElementJs **************
$dynamic("get$height").HTMLIFrameElement = function() { return this.height; };
$dynamic("set$height").HTMLIFrameElement = function(value) { return this.height = value; };
$dynamic("get$name").HTMLIFrameElement = function() { return this.name; };
$dynamic("get$width").HTMLIFrameElement = function() { return this.width; };
$dynamic("set$width").HTMLIFrameElement = function(value) { return this.width = value; };
// ********** Code for _HTMLImageElementJs **************
$dynamic("get$height").HTMLImageElement = function() { return this.height; };
$dynamic("set$height").HTMLImageElement = function(value) { return this.height = value; };
$dynamic("get$name").HTMLImageElement = function() { return this.name; };
$dynamic("get$width").HTMLImageElement = function() { return this.width; };
$dynamic("set$width").HTMLImageElement = function(value) { return this.width = value; };
$dynamic("get$x").HTMLImageElement = function() { return this.x; };
$dynamic("get$y").HTMLImageElement = function() { return this.y; };
// ********** Code for _HTMLInputElementJs **************
$dynamic("get$name").HTMLInputElement = function() { return this.name; };
$dynamic("get$value").HTMLInputElement = function() { return this.value; };
$dynamic("set$value").HTMLInputElement = function(value) { return this.value = value; };
// ********** Code for _HTMLKeygenElementJs **************
$dynamic("get$name").HTMLKeygenElement = function() { return this.name; };
// ********** Code for _HTMLLIElementJs **************
$dynamic("get$value").HTMLLIElement = function() { return this.value; };
$dynamic("set$value").HTMLLIElement = function(value) { return this.value = value; };
// ********** Code for _HTMLLabelElementJs **************
// ********** Code for _HTMLLegendElementJs **************
// ********** Code for _HTMLLinkElementJs **************
// ********** Code for _HTMLMapElementJs **************
$dynamic("get$name").HTMLMapElement = function() { return this.name; };
// ********** Code for _HTMLMarqueeElementJs **************
$dynamic("get$height").HTMLMarqueeElement = function() { return this.height; };
$dynamic("set$height").HTMLMarqueeElement = function(value) { return this.height = value; };
$dynamic("get$width").HTMLMarqueeElement = function() { return this.width; };
$dynamic("set$width").HTMLMarqueeElement = function(value) { return this.width = value; };
// ********** Code for _HTMLMenuElementJs **************
// ********** Code for _HTMLMetaElementJs **************
$dynamic("get$name").HTMLMetaElement = function() { return this.name; };
// ********** Code for _HTMLMeterElementJs **************
$dynamic("get$value").HTMLMeterElement = function() { return this.value; };
$dynamic("set$value").HTMLMeterElement = function(value) { return this.value = value; };
// ********** Code for _HTMLModElementJs **************
// ********** Code for _HTMLOListElementJs **************
// ********** Code for _HTMLObjectElementJs **************
$dynamic("get$data").HTMLObjectElement = function() { return this.data; };
$dynamic("get$height").HTMLObjectElement = function() { return this.height; };
$dynamic("set$height").HTMLObjectElement = function(value) { return this.height = value; };
$dynamic("get$name").HTMLObjectElement = function() { return this.name; };
$dynamic("get$width").HTMLObjectElement = function() { return this.width; };
$dynamic("set$width").HTMLObjectElement = function(value) { return this.width = value; };
// ********** Code for _HTMLOptGroupElementJs **************
// ********** Code for _HTMLOptionElementJs **************
$dynamic("get$value").HTMLOptionElement = function() { return this.value; };
$dynamic("set$value").HTMLOptionElement = function(value) { return this.value = value; };
// ********** Code for _HTMLOptionsCollectionJs **************
$dynamic("is$List").HTMLOptionsCollection = function(){return true};
$dynamic("is$Collection").HTMLOptionsCollection = function(){return true};
$dynamic("get$length").HTMLOptionsCollection = function() {
  return this.length;
}
// ********** Code for _HTMLOutputElementJs **************
$dynamic("get$name").HTMLOutputElement = function() { return this.name; };
$dynamic("get$value").HTMLOutputElement = function() { return this.value; };
$dynamic("set$value").HTMLOutputElement = function(value) { return this.value = value; };
// ********** Code for _HTMLParagraphElementJs **************
// ********** Code for _HTMLParamElementJs **************
$dynamic("get$name").HTMLParamElement = function() { return this.name; };
$dynamic("get$value").HTMLParamElement = function() { return this.value; };
$dynamic("set$value").HTMLParamElement = function(value) { return this.value = value; };
// ********** Code for _HTMLPreElementJs **************
$dynamic("get$width").HTMLPreElement = function() { return this.width; };
$dynamic("set$width").HTMLPreElement = function(value) { return this.width = value; };
// ********** Code for _HTMLProgressElementJs **************
$dynamic("get$position").HTMLProgressElement = function() { return this.position; };
$dynamic("get$value").HTMLProgressElement = function() { return this.value; };
$dynamic("set$value").HTMLProgressElement = function(value) { return this.value = value; };
// ********** Code for _HTMLQuoteElementJs **************
// ********** Code for _HTMLScriptElementJs **************
// ********** Code for _HTMLSelectElementJs **************
$dynamic("get$length").HTMLSelectElement = function() { return this.length; };
$dynamic("get$name").HTMLSelectElement = function() { return this.name; };
$dynamic("get$value").HTMLSelectElement = function() { return this.value; };
$dynamic("set$value").HTMLSelectElement = function(value) { return this.value = value; };
// ********** Code for _HTMLShadowElementJs **************
// ********** Code for _HTMLSourceElementJs **************
// ********** Code for _HTMLSpanElementJs **************
// ********** Code for _HTMLStyleElementJs **************
// ********** Code for _HTMLTableCaptionElementJs **************
// ********** Code for _HTMLTableCellElementJs **************
$dynamic("get$height").HTMLTableCellElement = function() { return this.height; };
$dynamic("set$height").HTMLTableCellElement = function(value) { return this.height = value; };
$dynamic("get$width").HTMLTableCellElement = function() { return this.width; };
$dynamic("set$width").HTMLTableCellElement = function(value) { return this.width = value; };
// ********** Code for _HTMLTableColElementJs **************
$dynamic("get$width").HTMLTableColElement = function() { return this.width; };
$dynamic("set$width").HTMLTableColElement = function(value) { return this.width = value; };
// ********** Code for _HTMLTableElementJs **************
$dynamic("get$width").HTMLTableElement = function() { return this.width; };
$dynamic("set$width").HTMLTableElement = function(value) { return this.width = value; };
// ********** Code for _HTMLTableRowElementJs **************
// ********** Code for _HTMLTableSectionElementJs **************
// ********** Code for _HTMLTextAreaElementJs **************
$dynamic("get$name").HTMLTextAreaElement = function() { return this.name; };
$dynamic("get$value").HTMLTextAreaElement = function() { return this.value; };
$dynamic("set$value").HTMLTextAreaElement = function(value) { return this.value = value; };
// ********** Code for _HTMLTitleElementJs **************
// ********** Code for _HTMLTrackElementJs **************
// ********** Code for _HTMLUListElementJs **************
// ********** Code for _HTMLUnknownElementJs **************
// ********** Code for _HTMLVideoElementJs **************
$dynamic("get$height").HTMLVideoElement = function() { return this.height; };
$dynamic("set$height").HTMLVideoElement = function(value) { return this.height = value; };
$dynamic("get$width").HTMLVideoElement = function() { return this.width; };
$dynamic("set$width").HTMLVideoElement = function(value) { return this.width = value; };
// ********** Code for _HashChangeEventJs **************
// ********** Code for _HighPass2FilterNodeJs **************
// ********** Code for _HistoryJs **************
$dynamic("get$length").History = function() { return this.length; };
// ********** Code for _IDBAnyJs **************
// ********** Code for _IDBCursorJs **************
// ********** Code for _IDBCursorWithValueJs **************
$dynamic("get$value").IDBCursorWithValue = function() { return this.value; };
// ********** Code for _IDBDatabaseJs **************
$dynamic("get$name").IDBDatabase = function() { return this.name; };
$dynamic("addEventListener$3").IDBDatabase = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _IDBDatabaseErrorJs **************
// ********** Code for _IDBDatabaseExceptionJs **************
$dynamic("get$name").IDBDatabaseException = function() { return this.name; };
// ********** Code for _IDBFactoryJs **************
// ********** Code for _IDBIndexJs **************
$dynamic("get$name").IDBIndex = function() { return this.name; };
// ********** Code for _IDBKeyJs **************
// ********** Code for _IDBKeyRangeJs **************
// ********** Code for _IDBObjectStoreJs **************
$dynamic("get$name").IDBObjectStore = function() { return this.name; };
// ********** Code for _IDBRequestJs **************
$dynamic("addEventListener$3").IDBRequest = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _IDBTransactionJs **************
$dynamic("addEventListener$3").IDBTransaction = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _IDBVersionChangeEventJs **************
// ********** Code for _IDBVersionChangeRequestJs **************
// ********** Code for _ImageDataJs **************
$dynamic("get$data").ImageData = function() { return this.data; };
$dynamic("get$height").ImageData = function() { return this.height; };
$dynamic("get$width").ImageData = function() { return this.width; };
// ********** Code for _Int16ArrayJs **************
var _Int16ArrayJs = {};
$dynamic("is$List").Int16Array = function(){return true};
$dynamic("is$Collection").Int16Array = function(){return true};
$dynamic("get$length").Int16Array = function() { return this.length; };
$dynamic("$index").Int16Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Int16Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Int16Array = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").Int16Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Int16Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Int16Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Int16Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Int16Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Int16Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Int16Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Int16Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Int16Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Int16Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _Int32ArrayJs **************
var _Int32ArrayJs = {};
$dynamic("is$List").Int32Array = function(){return true};
$dynamic("is$Collection").Int32Array = function(){return true};
$dynamic("get$length").Int32Array = function() { return this.length; };
$dynamic("$index").Int32Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Int32Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Int32Array = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").Int32Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Int32Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Int32Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Int32Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Int32Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Int32Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Int32Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Int32Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Int32Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Int32Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _Int8ArrayJs **************
var _Int8ArrayJs = {};
$dynamic("is$List").Int8Array = function(){return true};
$dynamic("is$Collection").Int8Array = function(){return true};
$dynamic("get$length").Int8Array = function() { return this.length; };
$dynamic("$index").Int8Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Int8Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Int8Array = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").Int8Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Int8Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Int8Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Int8Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Int8Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Int8Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Int8Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Int8Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Int8Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Int8Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _JavaScriptAudioNodeJs **************
// ********** Code for _JavaScriptCallFrameJs **************
// ********** Code for _KeyboardEventJs **************
// ********** Code for _MediaStreamJs **************
$dynamic("addEventListener$3").MediaStream = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _LocalMediaStreamJs **************
// ********** Code for _LocationJs **************
// ********** Code for _LowPass2FilterNodeJs **************
// ********** Code for _MediaControllerJs **************
$dynamic("addEventListener$3").MediaController = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _MediaElementAudioSourceNodeJs **************
// ********** Code for _MediaErrorJs **************
// ********** Code for _MediaListJs **************
$dynamic("is$List").MediaList = function(){return true};
$dynamic("is$Collection").MediaList = function(){return true};
$dynamic("get$length").MediaList = function() { return this.length; };
$dynamic("$index").MediaList = function(index) {
  return this[index];
}
$dynamic("$setindex").MediaList = function(index, value) {
  $throw(new UnsupportedOperationException("Cannot assign element of immutable List."));
}
$dynamic("iterator").MediaList = function() {
  return new dom__FixedSizeListIterator_dart_core_String(this);
}
$dynamic("add").MediaList = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").MediaList = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").MediaList = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").MediaList = function() {
  return this.map.bind(this);
}
$dynamic("sort").MediaList = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").MediaList = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").MediaList = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").MediaList = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").MediaList = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").MediaList = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _MediaQueryListJs **************
// ********** Code for _MediaQueryListListenerJs **************
// ********** Code for _MediaStreamEventJs **************
// ********** Code for _MediaStreamListJs **************
$dynamic("get$length").MediaStreamList = function() { return this.length; };
// ********** Code for _MediaStreamTrackJs **************
// ********** Code for _MediaStreamTrackListJs **************
$dynamic("get$length").MediaStreamTrackList = function() { return this.length; };
// ********** Code for _MemoryInfoJs **************
// ********** Code for _MessageChannelJs **************
// ********** Code for _MessageEventJs **************
$dynamic("get$data").MessageEvent = function() { return this.data; };
// ********** Code for _MessagePortJs **************
$dynamic("addEventListener$3").MessagePort = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _MetadataJs **************
// ********** Code for _MouseEventJs **************
$dynamic("get$clientX").MouseEvent = function() { return this.clientX; };
$dynamic("get$clientY").MouseEvent = function() { return this.clientY; };
$dynamic("get$x").MouseEvent = function() { return this.x; };
$dynamic("get$y").MouseEvent = function() { return this.y; };
// ********** Code for _MutationEventJs **************
// ********** Code for _NamedNodeMapJs **************
$dynamic("is$List").NamedNodeMap = function(){return true};
$dynamic("is$Collection").NamedNodeMap = function(){return true};
$dynamic("get$length").NamedNodeMap = function() { return this.length; };
$dynamic("$index").NamedNodeMap = function(index) {
  return this[index];
}
$dynamic("$setindex").NamedNodeMap = function(index, value) {
  $throw(new UnsupportedOperationException("Cannot assign element of immutable List."));
}
$dynamic("iterator").NamedNodeMap = function() {
  return new dom__FixedSizeListIterator_dom_Node(this);
}
$dynamic("add").NamedNodeMap = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").NamedNodeMap = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").NamedNodeMap = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").NamedNodeMap = function() {
  return this.map.bind(this);
}
$dynamic("sort").NamedNodeMap = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").NamedNodeMap = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").NamedNodeMap = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").NamedNodeMap = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").NamedNodeMap = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").NamedNodeMap = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _NavigatorJs **************
// ********** Code for _NavigatorUserMediaErrorJs **************
// ********** Code for _NodeFilterJs **************
// ********** Code for _NodeIteratorJs **************
// ********** Code for _NodeListJs **************
$dynamic("is$List").NodeList = function(){return true};
$dynamic("is$Collection").NodeList = function(){return true};
$dynamic("get$length").NodeList = function() { return this.length; };
$dynamic("$index").NodeList = function(index) {
  return this[index];
}
$dynamic("$setindex").NodeList = function(index, value) {
  $throw(new UnsupportedOperationException("Cannot assign element of immutable List."));
}
$dynamic("iterator").NodeList = function() {
  return new dom__FixedSizeListIterator_dom_Node(this);
}
$dynamic("add").NodeList = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").NodeList = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").NodeList = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").NodeList = function() {
  return this.map.bind(this);
}
$dynamic("sort").NodeList = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").NodeList = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").NodeList = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").NodeList = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").NodeList = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").NodeList = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _NodeSelectorJs **************
// ********** Code for _NotationJs **************
// ********** Code for _NotificationJs **************
$dynamic("addEventListener$3").Notification = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _NotificationCenterJs **************
// ********** Code for _OESStandardDerivativesJs **************
// ********** Code for _OESTextureFloatJs **************
// ********** Code for _OESVertexArrayObjectJs **************
// ********** Code for _OfflineAudioCompletionEventJs **************
// ********** Code for _OperationNotAllowedExceptionJs **************
$dynamic("get$name").OperationNotAllowedException = function() { return this.name; };
// ********** Code for _OverflowEventJs **************
// ********** Code for _PageTransitionEventJs **************
// ********** Code for _PeerConnectionJs **************
$dynamic("addEventListener$3").PeerConnection = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _PerformanceJs **************
// ********** Code for _PerformanceNavigationJs **************
// ********** Code for _PerformanceTimingJs **************
// ********** Code for _PopStateEventJs **************
// ********** Code for _PositionErrorJs **************
// ********** Code for _ProcessingInstructionJs **************
$dynamic("get$data").ProcessingInstruction = function() { return this.data; };
// ********** Code for _ProgressEventJs **************
// ********** Code for _RGBColorJs **************
// ********** Code for _RangeJs **************
// ********** Code for _RangeExceptionJs **************
$dynamic("get$name").RangeException = function() { return this.name; };
// ********** Code for _RealtimeAnalyserNodeJs **************
// ********** Code for _RectJs **************
// ********** Code for _SQLErrorJs **************
// ********** Code for _SQLExceptionJs **************
// ********** Code for _SQLResultSetJs **************
// ********** Code for _SQLResultSetRowListJs **************
$dynamic("get$length").SQLResultSetRowList = function() { return this.length; };
// ********** Code for _SQLTransactionJs **************
// ********** Code for _SQLTransactionSyncJs **************
// ********** Code for _SVGElementJs **************
$dynamic("get$id").SVGElement = function() { return this.id; };
// ********** Code for _SVGAElementJs **************
// ********** Code for _SVGAltGlyphDefElementJs **************
// ********** Code for _SVGTextContentElementJs **************
// ********** Code for _SVGTextPositioningElementJs **************
$dynamic("get$x").SVGTextPositioningElement = function() { return this.x; };
$dynamic("get$y").SVGTextPositioningElement = function() { return this.y; };
// ********** Code for _SVGAltGlyphElementJs **************
// ********** Code for _SVGAltGlyphItemElementJs **************
// ********** Code for _SVGAngleJs **************
$dynamic("get$value").SVGAngle = function() { return this.value; };
$dynamic("set$value").SVGAngle = function(value) { return this.value = value; };
// ********** Code for _SVGAnimationElementJs **************
// ********** Code for _SVGAnimateColorElementJs **************
// ********** Code for _SVGAnimateElementJs **************
// ********** Code for _SVGAnimateMotionElementJs **************
// ********** Code for _SVGAnimateTransformElementJs **************
// ********** Code for _SVGAnimatedAngleJs **************
// ********** Code for _SVGAnimatedBooleanJs **************
// ********** Code for _SVGAnimatedEnumerationJs **************
// ********** Code for _SVGAnimatedIntegerJs **************
// ********** Code for _SVGAnimatedLengthJs **************
// ********** Code for _SVGAnimatedLengthListJs **************
// ********** Code for _SVGAnimatedNumberJs **************
// ********** Code for _SVGAnimatedNumberListJs **************
// ********** Code for _SVGAnimatedPreserveAspectRatioJs **************
// ********** Code for _SVGAnimatedRectJs **************
// ********** Code for _SVGAnimatedStringJs **************
// ********** Code for _SVGAnimatedTransformListJs **************
// ********** Code for _SVGCircleElementJs **************
// ********** Code for _SVGClipPathElementJs **************
// ********** Code for _SVGColorJs **************
// ********** Code for _SVGComponentTransferFunctionElementJs **************
$dynamic("get$offset").SVGComponentTransferFunctionElement = function() { return this.offset; };
// ********** Code for _SVGCursorElementJs **************
$dynamic("get$x").SVGCursorElement = function() { return this.x; };
$dynamic("get$y").SVGCursorElement = function() { return this.y; };
// ********** Code for _SVGDefsElementJs **************
// ********** Code for _SVGDescElementJs **************
// ********** Code for _SVGDocumentJs **************
// ********** Code for _SVGElementInstanceJs **************
$dynamic("get$childNodes").SVGElementInstance = function() { return this.childNodes; };
$dynamic("get$lastChild").SVGElementInstance = function() { return this.lastChild; };
$dynamic("get$parentNode").SVGElementInstance = function() { return this.parentNode; };
$dynamic("addEventListener$3").SVGElementInstance = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _SVGElementInstanceListJs **************
$dynamic("get$length").SVGElementInstanceList = function() { return this.length; };
// ********** Code for _SVGEllipseElementJs **************
// ********** Code for _SVGExceptionJs **************
$dynamic("get$name").SVGException = function() { return this.name; };
// ********** Code for _SVGExternalResourcesRequiredJs **************
// ********** Code for _SVGFEBlendElementJs **************
$dynamic("get$height").SVGFEBlendElement = function() { return this.height; };
$dynamic("get$width").SVGFEBlendElement = function() { return this.width; };
$dynamic("get$x").SVGFEBlendElement = function() { return this.x; };
$dynamic("get$y").SVGFEBlendElement = function() { return this.y; };
// ********** Code for _SVGFEColorMatrixElementJs **************
$dynamic("get$height").SVGFEColorMatrixElement = function() { return this.height; };
$dynamic("get$width").SVGFEColorMatrixElement = function() { return this.width; };
$dynamic("get$x").SVGFEColorMatrixElement = function() { return this.x; };
$dynamic("get$y").SVGFEColorMatrixElement = function() { return this.y; };
// ********** Code for _SVGFEComponentTransferElementJs **************
$dynamic("get$height").SVGFEComponentTransferElement = function() { return this.height; };
$dynamic("get$width").SVGFEComponentTransferElement = function() { return this.width; };
$dynamic("get$x").SVGFEComponentTransferElement = function() { return this.x; };
$dynamic("get$y").SVGFEComponentTransferElement = function() { return this.y; };
// ********** Code for _SVGFECompositeElementJs **************
$dynamic("get$height").SVGFECompositeElement = function() { return this.height; };
$dynamic("get$width").SVGFECompositeElement = function() { return this.width; };
$dynamic("get$x").SVGFECompositeElement = function() { return this.x; };
$dynamic("get$y").SVGFECompositeElement = function() { return this.y; };
// ********** Code for _SVGFEConvolveMatrixElementJs **************
$dynamic("get$height").SVGFEConvolveMatrixElement = function() { return this.height; };
$dynamic("get$width").SVGFEConvolveMatrixElement = function() { return this.width; };
$dynamic("get$x").SVGFEConvolveMatrixElement = function() { return this.x; };
$dynamic("get$y").SVGFEConvolveMatrixElement = function() { return this.y; };
// ********** Code for _SVGFEDiffuseLightingElementJs **************
$dynamic("get$height").SVGFEDiffuseLightingElement = function() { return this.height; };
$dynamic("get$width").SVGFEDiffuseLightingElement = function() { return this.width; };
$dynamic("get$x").SVGFEDiffuseLightingElement = function() { return this.x; };
$dynamic("get$y").SVGFEDiffuseLightingElement = function() { return this.y; };
// ********** Code for _SVGFEDisplacementMapElementJs **************
$dynamic("get$scale").SVGFEDisplacementMapElement = function() { return this.scale; };
$dynamic("get$height").SVGFEDisplacementMapElement = function() { return this.height; };
$dynamic("get$width").SVGFEDisplacementMapElement = function() { return this.width; };
$dynamic("get$x").SVGFEDisplacementMapElement = function() { return this.x; };
$dynamic("get$y").SVGFEDisplacementMapElement = function() { return this.y; };
// ********** Code for _SVGFEDistantLightElementJs **************
// ********** Code for _SVGFEDropShadowElementJs **************
$dynamic("get$height").SVGFEDropShadowElement = function() { return this.height; };
$dynamic("get$width").SVGFEDropShadowElement = function() { return this.width; };
$dynamic("get$x").SVGFEDropShadowElement = function() { return this.x; };
$dynamic("get$y").SVGFEDropShadowElement = function() { return this.y; };
// ********** Code for _SVGFEFloodElementJs **************
$dynamic("get$height").SVGFEFloodElement = function() { return this.height; };
$dynamic("get$width").SVGFEFloodElement = function() { return this.width; };
$dynamic("get$x").SVGFEFloodElement = function() { return this.x; };
$dynamic("get$y").SVGFEFloodElement = function() { return this.y; };
// ********** Code for _SVGFEFuncAElementJs **************
// ********** Code for _SVGFEFuncBElementJs **************
// ********** Code for _SVGFEFuncGElementJs **************
// ********** Code for _SVGFEFuncRElementJs **************
// ********** Code for _SVGFEGaussianBlurElementJs **************
$dynamic("get$height").SVGFEGaussianBlurElement = function() { return this.height; };
$dynamic("get$width").SVGFEGaussianBlurElement = function() { return this.width; };
$dynamic("get$x").SVGFEGaussianBlurElement = function() { return this.x; };
$dynamic("get$y").SVGFEGaussianBlurElement = function() { return this.y; };
// ********** Code for _SVGFEImageElementJs **************
$dynamic("get$height").SVGFEImageElement = function() { return this.height; };
$dynamic("get$width").SVGFEImageElement = function() { return this.width; };
$dynamic("get$x").SVGFEImageElement = function() { return this.x; };
$dynamic("get$y").SVGFEImageElement = function() { return this.y; };
// ********** Code for _SVGFEMergeElementJs **************
$dynamic("get$height").SVGFEMergeElement = function() { return this.height; };
$dynamic("get$width").SVGFEMergeElement = function() { return this.width; };
$dynamic("get$x").SVGFEMergeElement = function() { return this.x; };
$dynamic("get$y").SVGFEMergeElement = function() { return this.y; };
// ********** Code for _SVGFEMergeNodeElementJs **************
// ********** Code for _SVGFEMorphologyElementJs **************
$dynamic("get$height").SVGFEMorphologyElement = function() { return this.height; };
$dynamic("get$width").SVGFEMorphologyElement = function() { return this.width; };
$dynamic("get$x").SVGFEMorphologyElement = function() { return this.x; };
$dynamic("get$y").SVGFEMorphologyElement = function() { return this.y; };
// ********** Code for _SVGFEOffsetElementJs **************
$dynamic("get$height").SVGFEOffsetElement = function() { return this.height; };
$dynamic("get$width").SVGFEOffsetElement = function() { return this.width; };
$dynamic("get$x").SVGFEOffsetElement = function() { return this.x; };
$dynamic("get$y").SVGFEOffsetElement = function() { return this.y; };
// ********** Code for _SVGFEPointLightElementJs **************
$dynamic("get$x").SVGFEPointLightElement = function() { return this.x; };
$dynamic("get$y").SVGFEPointLightElement = function() { return this.y; };
$dynamic("get$z").SVGFEPointLightElement = function() { return this.z; };
// ********** Code for _SVGFESpecularLightingElementJs **************
$dynamic("get$height").SVGFESpecularLightingElement = function() { return this.height; };
$dynamic("get$width").SVGFESpecularLightingElement = function() { return this.width; };
$dynamic("get$x").SVGFESpecularLightingElement = function() { return this.x; };
$dynamic("get$y").SVGFESpecularLightingElement = function() { return this.y; };
// ********** Code for _SVGFESpotLightElementJs **************
$dynamic("get$x").SVGFESpotLightElement = function() { return this.x; };
$dynamic("get$y").SVGFESpotLightElement = function() { return this.y; };
$dynamic("get$z").SVGFESpotLightElement = function() { return this.z; };
// ********** Code for _SVGFETileElementJs **************
$dynamic("get$height").SVGFETileElement = function() { return this.height; };
$dynamic("get$width").SVGFETileElement = function() { return this.width; };
$dynamic("get$x").SVGFETileElement = function() { return this.x; };
$dynamic("get$y").SVGFETileElement = function() { return this.y; };
// ********** Code for _SVGFETurbulenceElementJs **************
$dynamic("get$height").SVGFETurbulenceElement = function() { return this.height; };
$dynamic("get$width").SVGFETurbulenceElement = function() { return this.width; };
$dynamic("get$x").SVGFETurbulenceElement = function() { return this.x; };
$dynamic("get$y").SVGFETurbulenceElement = function() { return this.y; };
// ********** Code for _SVGFilterElementJs **************
$dynamic("get$height").SVGFilterElement = function() { return this.height; };
$dynamic("get$width").SVGFilterElement = function() { return this.width; };
$dynamic("get$x").SVGFilterElement = function() { return this.x; };
$dynamic("get$y").SVGFilterElement = function() { return this.y; };
// ********** Code for _SVGStylableJs **************
// ********** Code for _SVGFilterPrimitiveStandardAttributesJs **************
$dynamic("get$height").SVGFilterPrimitiveStandardAttributes = function() { return this.height; };
$dynamic("get$width").SVGFilterPrimitiveStandardAttributes = function() { return this.width; };
$dynamic("get$x").SVGFilterPrimitiveStandardAttributes = function() { return this.x; };
$dynamic("get$y").SVGFilterPrimitiveStandardAttributes = function() { return this.y; };
// ********** Code for _SVGFitToViewBoxJs **************
// ********** Code for _SVGFontElementJs **************
// ********** Code for _SVGFontFaceElementJs **************
// ********** Code for _SVGFontFaceFormatElementJs **************
// ********** Code for _SVGFontFaceNameElementJs **************
// ********** Code for _SVGFontFaceSrcElementJs **************
// ********** Code for _SVGFontFaceUriElementJs **************
// ********** Code for _SVGForeignObjectElementJs **************
$dynamic("get$height").SVGForeignObjectElement = function() { return this.height; };
$dynamic("get$width").SVGForeignObjectElement = function() { return this.width; };
$dynamic("get$x").SVGForeignObjectElement = function() { return this.x; };
$dynamic("get$y").SVGForeignObjectElement = function() { return this.y; };
// ********** Code for _SVGGElementJs **************
// ********** Code for _SVGGlyphElementJs **************
// ********** Code for _SVGGlyphRefElementJs **************
$dynamic("get$x").SVGGlyphRefElement = function() { return this.x; };
$dynamic("get$y").SVGGlyphRefElement = function() { return this.y; };
// ********** Code for _SVGGradientElementJs **************
// ********** Code for _SVGHKernElementJs **************
// ********** Code for _SVGImageElementJs **************
$dynamic("get$height").SVGImageElement = function() { return this.height; };
$dynamic("get$width").SVGImageElement = function() { return this.width; };
$dynamic("get$x").SVGImageElement = function() { return this.x; };
$dynamic("get$y").SVGImageElement = function() { return this.y; };
// ********** Code for _SVGLangSpaceJs **************
// ********** Code for _SVGLengthJs **************
$dynamic("get$value").SVGLength = function() { return this.value; };
$dynamic("set$value").SVGLength = function(value) { return this.value = value; };
// ********** Code for _SVGLengthListJs **************
// ********** Code for _SVGLineElementJs **************
// ********** Code for _SVGLinearGradientElementJs **************
// ********** Code for _SVGLocatableJs **************
// ********** Code for _SVGMPathElementJs **************
// ********** Code for _SVGMarkerElementJs **************
// ********** Code for _SVGMaskElementJs **************
$dynamic("get$height").SVGMaskElement = function() { return this.height; };
$dynamic("get$width").SVGMaskElement = function() { return this.width; };
$dynamic("get$x").SVGMaskElement = function() { return this.x; };
$dynamic("get$y").SVGMaskElement = function() { return this.y; };
// ********** Code for _SVGMatrixJs **************
$dynamic("get$scale").SVGMatrix = function() {
  return this.scale.bind(this);
}
$dynamic("rotate$1").SVGMatrix = function($0) {
  return this.rotate($0);
};
$dynamic("translate$2").SVGMatrix = function($0, $1) {
  return this.translate($0, $1);
};
// ********** Code for _SVGMetadataElementJs **************
// ********** Code for _SVGMissingGlyphElementJs **************
// ********** Code for _SVGNumberJs **************
$dynamic("get$value").SVGNumber = function() { return this.value; };
$dynamic("set$value").SVGNumber = function(value) { return this.value = value; };
// ********** Code for _SVGNumberListJs **************
// ********** Code for _SVGPaintJs **************
// ********** Code for _SVGPathElementJs **************
// ********** Code for _SVGPathSegJs **************
// ********** Code for _SVGPathSegArcAbsJs **************
$dynamic("get$x").SVGPathSegArcAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegArcAbs = function() { return this.y; };
// ********** Code for _SVGPathSegArcRelJs **************
$dynamic("get$x").SVGPathSegArcRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegArcRel = function() { return this.y; };
// ********** Code for _SVGPathSegClosePathJs **************
// ********** Code for _SVGPathSegCurvetoCubicAbsJs **************
$dynamic("get$x").SVGPathSegCurvetoCubicAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoCubicAbs = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoCubicRelJs **************
$dynamic("get$x").SVGPathSegCurvetoCubicRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoCubicRel = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoCubicSmoothAbsJs **************
$dynamic("get$x").SVGPathSegCurvetoCubicSmoothAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoCubicSmoothAbs = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoCubicSmoothRelJs **************
$dynamic("get$x").SVGPathSegCurvetoCubicSmoothRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoCubicSmoothRel = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoQuadraticAbsJs **************
$dynamic("get$x").SVGPathSegCurvetoQuadraticAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoQuadraticAbs = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoQuadraticRelJs **************
$dynamic("get$x").SVGPathSegCurvetoQuadraticRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoQuadraticRel = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoQuadraticSmoothAbsJs **************
$dynamic("get$x").SVGPathSegCurvetoQuadraticSmoothAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoQuadraticSmoothAbs = function() { return this.y; };
// ********** Code for _SVGPathSegCurvetoQuadraticSmoothRelJs **************
$dynamic("get$x").SVGPathSegCurvetoQuadraticSmoothRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegCurvetoQuadraticSmoothRel = function() { return this.y; };
// ********** Code for _SVGPathSegLinetoAbsJs **************
$dynamic("get$x").SVGPathSegLinetoAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegLinetoAbs = function() { return this.y; };
// ********** Code for _SVGPathSegLinetoHorizontalAbsJs **************
$dynamic("get$x").SVGPathSegLinetoHorizontalAbs = function() { return this.x; };
// ********** Code for _SVGPathSegLinetoHorizontalRelJs **************
$dynamic("get$x").SVGPathSegLinetoHorizontalRel = function() { return this.x; };
// ********** Code for _SVGPathSegLinetoRelJs **************
$dynamic("get$x").SVGPathSegLinetoRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegLinetoRel = function() { return this.y; };
// ********** Code for _SVGPathSegLinetoVerticalAbsJs **************
$dynamic("get$y").SVGPathSegLinetoVerticalAbs = function() { return this.y; };
// ********** Code for _SVGPathSegLinetoVerticalRelJs **************
$dynamic("get$y").SVGPathSegLinetoVerticalRel = function() { return this.y; };
// ********** Code for _SVGPathSegListJs **************
// ********** Code for _SVGPathSegMovetoAbsJs **************
$dynamic("get$x").SVGPathSegMovetoAbs = function() { return this.x; };
$dynamic("get$y").SVGPathSegMovetoAbs = function() { return this.y; };
// ********** Code for _SVGPathSegMovetoRelJs **************
$dynamic("get$x").SVGPathSegMovetoRel = function() { return this.x; };
$dynamic("get$y").SVGPathSegMovetoRel = function() { return this.y; };
// ********** Code for _SVGPatternElementJs **************
$dynamic("get$height").SVGPatternElement = function() { return this.height; };
$dynamic("get$width").SVGPatternElement = function() { return this.width; };
$dynamic("get$x").SVGPatternElement = function() { return this.x; };
$dynamic("get$y").SVGPatternElement = function() { return this.y; };
// ********** Code for _SVGPointJs **************
$dynamic("get$x").SVGPoint = function() { return this.x; };
$dynamic("get$y").SVGPoint = function() { return this.y; };
// ********** Code for _SVGPointListJs **************
// ********** Code for _SVGPolygonElementJs **************
// ********** Code for _SVGPolylineElementJs **************
// ********** Code for _SVGPreserveAspectRatioJs **************
// ********** Code for _SVGRadialGradientElementJs **************
// ********** Code for _SVGRectJs **************
$dynamic("get$height").SVGRect = function() { return this.height; };
$dynamic("set$height").SVGRect = function(value) { return this.height = value; };
$dynamic("get$width").SVGRect = function() { return this.width; };
$dynamic("set$width").SVGRect = function(value) { return this.width = value; };
$dynamic("get$x").SVGRect = function() { return this.x; };
$dynamic("get$y").SVGRect = function() { return this.y; };
// ********** Code for _SVGRectElementJs **************
$dynamic("get$height").SVGRectElement = function() { return this.height; };
$dynamic("get$width").SVGRectElement = function() { return this.width; };
$dynamic("get$x").SVGRectElement = function() { return this.x; };
$dynamic("get$y").SVGRectElement = function() { return this.y; };
// ********** Code for _SVGRenderingIntentJs **************
// ********** Code for _SVGSVGElementJs **************
$dynamic("get$height").SVGSVGElement = function() { return this.height; };
$dynamic("get$width").SVGSVGElement = function() { return this.width; };
$dynamic("get$x").SVGSVGElement = function() { return this.x; };
$dynamic("get$y").SVGSVGElement = function() { return this.y; };
// ********** Code for _SVGScriptElementJs **************
// ********** Code for _SVGSetElementJs **************
// ********** Code for _SVGStopElementJs **************
$dynamic("get$offset").SVGStopElement = function() { return this.offset; };
// ********** Code for _SVGStringListJs **************
// ********** Code for _SVGStyleElementJs **************
// ********** Code for _SVGSwitchElementJs **************
// ********** Code for _SVGSymbolElementJs **************
// ********** Code for _SVGTRefElementJs **************
// ********** Code for _SVGTSpanElementJs **************
// ********** Code for _SVGTestsJs **************
// ********** Code for _SVGTextElementJs **************
// ********** Code for _SVGTextPathElementJs **************
// ********** Code for _SVGTitleElementJs **************
// ********** Code for _SVGTransformJs **************
// ********** Code for _SVGTransformListJs **************
// ********** Code for _SVGTransformableJs **************
// ********** Code for _SVGURIReferenceJs **************
// ********** Code for _SVGUnitTypesJs **************
// ********** Code for _SVGUseElementJs **************
$dynamic("get$height").SVGUseElement = function() { return this.height; };
$dynamic("get$width").SVGUseElement = function() { return this.width; };
$dynamic("get$x").SVGUseElement = function() { return this.x; };
$dynamic("get$y").SVGUseElement = function() { return this.y; };
// ********** Code for _SVGVKernElementJs **************
// ********** Code for _SVGViewElementJs **************
// ********** Code for _SVGZoomAndPanJs **************
// ********** Code for _SVGViewSpecJs **************
// ********** Code for _SVGZoomEventJs **************
// ********** Code for _ScreenJs **************
$dynamic("get$height").Screen = function() { return this.height; };
$dynamic("get$width").Screen = function() { return this.width; };
// ********** Code for _ScriptProfileJs **************
// ********** Code for _ScriptProfileNodeJs **************
// ********** Code for _ShadowRootJs **************
// ********** Code for _SharedWorkerJs **************
// ********** Code for _SharedWorkerContextJs **************
$dynamic("get$name").SharedWorkerContext = function() { return this.name; };
// ********** Code for _SpeechInputEventJs **************
// ********** Code for _SpeechInputResultJs **************
// ********** Code for _SpeechInputResultListJs **************
$dynamic("get$length").SpeechInputResultList = function() { return this.length; };
// ********** Code for _StorageJs **************
$dynamic("get$length").Storage = function() { return this.length; };
$dynamic("get$dartObjectLocalStorage").Storage = function() {
      if (this === window.localStorage)
        return window._dartLocalStorageLocalStorage;
      else if (this === window.sessionStorage)
        return window._dartSessionStorageLocalStorage;
      else
        throw new UnsupportedOperationException('Cannot dartObjectLocalStorage for unknown Storage object.');
}
$dynamic("set$dartObjectLocalStorage").Storage = function(value) {
      if (this === window.localStorage)
        window._dartLocalStorageLocalStorage = value;
      else if (this === window.sessionStorage)
        window._dartSessionStorageLocalStorage = value;
      else
        throw new UnsupportedOperationException('Cannot dartObjectLocalStorage for unknown Storage object.');
}
// ********** Code for _StorageEventJs **************
// ********** Code for _StorageInfoJs **************
// ********** Code for _StyleMediaJs **************
// ********** Code for _StyleSheetListJs **************
$dynamic("is$List").StyleSheetList = function(){return true};
$dynamic("is$Collection").StyleSheetList = function(){return true};
$dynamic("get$length").StyleSheetList = function() { return this.length; };
$dynamic("$index").StyleSheetList = function(index) {
  return this[index];
}
$dynamic("$setindex").StyleSheetList = function(index, value) {
  $throw(new UnsupportedOperationException("Cannot assign element of immutable List."));
}
$dynamic("iterator").StyleSheetList = function() {
  return new dom__FixedSizeListIterator_dom_StyleSheet(this);
}
$dynamic("add").StyleSheetList = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").StyleSheetList = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").StyleSheetList = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").StyleSheetList = function() {
  return this.map.bind(this);
}
$dynamic("sort").StyleSheetList = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").StyleSheetList = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").StyleSheetList = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").StyleSheetList = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").StyleSheetList = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").StyleSheetList = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _TextEventJs **************
$dynamic("get$data").TextEvent = function() { return this.data; };
// ********** Code for _TextMetricsJs **************
$dynamic("get$width").TextMetrics = function() { return this.width; };
// ********** Code for _TextTrackJs **************
$dynamic("addEventListener$3").TextTrack = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _TextTrackCueJs **************
$dynamic("get$id").TextTrackCue = function() { return this.id; };
$dynamic("addEventListener$3").TextTrackCue = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _TextTrackCueListJs **************
$dynamic("get$length").TextTrackCueList = function() { return this.length; };
// ********** Code for _TextTrackListJs **************
$dynamic("get$length").TextTrackList = function() { return this.length; };
$dynamic("addEventListener$3").TextTrackList = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _TimeRangesJs **************
$dynamic("get$length").TimeRanges = function() { return this.length; };
// ********** Code for _TouchJs **************
$dynamic("get$clientX").Touch = function() { return this.clientX; };
$dynamic("get$clientY").Touch = function() { return this.clientY; };
// ********** Code for _TouchEventJs **************
// ********** Code for _TouchListJs **************
$dynamic("is$List").TouchList = function(){return true};
$dynamic("is$Collection").TouchList = function(){return true};
$dynamic("get$length").TouchList = function() { return this.length; };
$dynamic("$index").TouchList = function(index) {
  return this[index];
}
$dynamic("$setindex").TouchList = function(index, value) {
  $throw(new UnsupportedOperationException("Cannot assign element of immutable List."));
}
$dynamic("iterator").TouchList = function() {
  return new dom__FixedSizeListIterator_dom_Touch(this);
}
$dynamic("add").TouchList = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").TouchList = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").TouchList = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").TouchList = function() {
  return this.map.bind(this);
}
$dynamic("sort").TouchList = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").TouchList = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").TouchList = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").TouchList = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").TouchList = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").TouchList = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _TrackEventJs **************
// ********** Code for _TreeWalkerJs **************
$dynamic("get$lastChild").TreeWalker = function() {
  return this.lastChild.bind(this);
}
$dynamic("get$parentNode").TreeWalker = function() {
  return this.parentNode.bind(this);
}
// ********** Code for _Uint16ArrayJs **************
var _Uint16ArrayJs = {};
$dynamic("is$List").Uint16Array = function(){return true};
$dynamic("is$Collection").Uint16Array = function(){return true};
$dynamic("get$length").Uint16Array = function() { return this.length; };
$dynamic("$index").Uint16Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Uint16Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Uint16Array = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").Uint16Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Uint16Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Uint16Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Uint16Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Uint16Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Uint16Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Uint16Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Uint16Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Uint16Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Uint16Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _Uint32ArrayJs **************
var _Uint32ArrayJs = {};
$dynamic("is$List").Uint32Array = function(){return true};
$dynamic("is$Collection").Uint32Array = function(){return true};
$dynamic("get$length").Uint32Array = function() { return this.length; };
$dynamic("$index").Uint32Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Uint32Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Uint32Array = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").Uint32Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Uint32Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Uint32Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Uint32Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Uint32Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Uint32Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Uint32Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Uint32Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Uint32Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Uint32Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _Uint8ArrayJs **************
var _Uint8ArrayJs = {};
$dynamic("is$List").Uint8Array = function(){return true};
$dynamic("is$Collection").Uint8Array = function(){return true};
$dynamic("get$length").Uint8Array = function() { return this.length; };
$dynamic("$index").Uint8Array = function(index) {
  return this[index];
}
$dynamic("$setindex").Uint8Array = function(index, value) {
  this[index] = value
}
$dynamic("iterator").Uint8Array = function() {
  return new dom__FixedSizeListIterator_int(this);
}
$dynamic("add").Uint8Array = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("addAll").Uint8Array = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
$dynamic("map").Uint8Array = function(f) {
  return dom__Collections.map(this, [], f);
}
$dynamic("get$map").Uint8Array = function() {
  return this.map.bind(this);
}
$dynamic("sort").Uint8Array = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
$dynamic("indexOf").Uint8Array = function(element, start) {
  return _Lists.indexOf(this, element, start, this.length);
}
$dynamic("removeRange").Uint8Array = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
$dynamic("indexOf$1").Uint8Array = function($0) {
  return this.indexOf($0, (0));
};
$dynamic("map$1").Uint8Array = function($0) {
  return this.map($wrap_call$1(to$call$1($0)));
};
$dynamic("sort$1").Uint8Array = function($0) {
  return this.sort($wrap_call$2(to$call$2($0)));
};
// ********** Code for _Uint8ClampedArrayJs **************
var _Uint8ClampedArrayJs = {};
$dynamic("is$List").Uint8ClampedArray = function(){return true};
$dynamic("is$Collection").Uint8ClampedArray = function(){return true};
// ********** Code for _ValidityStateJs **************
// ********** Code for _WaveShaperNodeJs **************
// ********** Code for _WebGLActiveInfoJs **************
$dynamic("get$name").WebGLActiveInfo = function() { return this.name; };
// ********** Code for _WebGLBufferJs **************
// ********** Code for _WebGLCompressedTextureS3TCJs **************
// ********** Code for _WebGLContextAttributesJs **************
// ********** Code for _WebGLContextEventJs **************
// ********** Code for _WebGLDebugRendererInfoJs **************
// ********** Code for _WebGLDebugShadersJs **************
// ********** Code for _WebGLFramebufferJs **************
// ********** Code for _WebGLLoseContextJs **************
// ********** Code for _WebGLProgramJs **************
// ********** Code for _WebGLRenderbufferJs **************
// ********** Code for _WebGLRenderingContextJs **************
// ********** Code for _WebGLShaderJs **************
// ********** Code for _WebGLTextureJs **************
// ********** Code for _WebGLUniformLocationJs **************
// ********** Code for _WebGLVertexArrayObjectOESJs **************
// ********** Code for _WebKitAnimationJs **************
$dynamic("get$name").WebKitAnimation = function() { return this.name; };
// ********** Code for _WebKitAnimationEventJs **************
// ********** Code for _WebKitAnimationListJs **************
$dynamic("get$length").WebKitAnimationList = function() { return this.length; };
// ********** Code for _WebKitBlobBuilderJs **************
// ********** Code for _WebKitCSSKeyframeRuleJs **************
// ********** Code for _WebKitCSSKeyframesRuleJs **************
$dynamic("get$name").WebKitCSSKeyframesRule = function() { return this.name; };
// ********** Code for _WebKitCSSMatrixJs **************
$dynamic("get$scale").WebKitCSSMatrix = function() {
  return this.scale.bind(this);
}
// ********** Code for _WebKitCSSRegionRuleJs **************
// ********** Code for _WebKitCSSTransformValueJs **************
// ********** Code for _WebKitNamedFlowJs **************
// ********** Code for _WebKitPointJs **************
$dynamic("get$x").WebKitPoint = function() { return this.x; };
$dynamic("get$y").WebKitPoint = function() { return this.y; };
// ********** Code for _WebKitTransitionEventJs **************
// ********** Code for _WebSocketJs **************
$dynamic("addEventListener$3").WebSocket = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _WheelEventJs **************
$dynamic("get$clientX").WheelEvent = function() { return this.clientX; };
$dynamic("get$clientY").WheelEvent = function() { return this.clientY; };
$dynamic("get$x").WheelEvent = function() { return this.x; };
$dynamic("get$y").WheelEvent = function() { return this.y; };
// ********** Code for _WorkerJs **************
// ********** Code for _WorkerLocationJs **************
// ********** Code for _WorkerNavigatorJs **************
// ********** Code for _XMLHttpRequestJs **************
$dynamic("addEventListener$3").XMLHttpRequest = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _XMLHttpRequestExceptionJs **************
$dynamic("get$name").XMLHttpRequestException = function() { return this.name; };
// ********** Code for _XMLHttpRequestProgressEventJs **************
$dynamic("get$position").XMLHttpRequestProgressEvent = function() { return this.position; };
// ********** Code for _XMLHttpRequestUploadJs **************
$dynamic("addEventListener$3").XMLHttpRequestUpload = function($0, $1, $2) {
  return this.addEventListener($0, $wrap_call$1(to$call$1($1)), $2);
};
// ********** Code for _XMLSerializerJs **************
// ********** Code for _XPathEvaluatorJs **************
// ********** Code for _XPathExceptionJs **************
$dynamic("get$name").XPathException = function() { return this.name; };
// ********** Code for _XPathExpressionJs **************
// ********** Code for _XPathNSResolverJs **************
// ********** Code for _XPathResultJs **************
// ********** Code for _XSLTProcessorJs **************
// ********** Code for _DOMParserFactoryProvider **************
function _DOMParserFactoryProvider() {}
// ********** Code for _DOMURLFactoryProvider **************
function _DOMURLFactoryProvider() {}
// ********** Code for _EventSourceFactoryProvider **************
function _EventSourceFactoryProvider() {}
// ********** Code for _FileReaderFactoryProvider **************
function _FileReaderFactoryProvider() {}
// ********** Code for _FileReaderSyncFactoryProvider **************
function _FileReaderSyncFactoryProvider() {}
// ********** Code for _HTMLAudioElementFactoryProvider **************
function _HTMLAudioElementFactoryProvider() {}
// ********** Code for _HTMLOptionElementFactoryProvider **************
function _HTMLOptionElementFactoryProvider() {}
// ********** Code for _MediaControllerFactoryProvider **************
function _MediaControllerFactoryProvider() {}
// ********** Code for _MediaStreamFactoryProvider **************
function _MediaStreamFactoryProvider() {}
// ********** Code for _MessageChannelFactoryProvider **************
function _MessageChannelFactoryProvider() {}
// ********** Code for _PeerConnectionFactoryProvider **************
function _PeerConnectionFactoryProvider() {}
// ********** Code for _ShadowRootFactoryProvider **************
function _ShadowRootFactoryProvider() {}
// ********** Code for _SharedWorkerFactoryProvider **************
function _SharedWorkerFactoryProvider() {}
// ********** Code for _TextTrackCueFactoryProvider **************
function _TextTrackCueFactoryProvider() {}
// ********** Code for _WebKitBlobBuilderFactoryProvider **************
function _WebKitBlobBuilderFactoryProvider() {}
// ********** Code for _WebKitCSSMatrixFactoryProvider **************
function _WebKitCSSMatrixFactoryProvider() {}
// ********** Code for _WorkerFactoryProvider **************
function _WorkerFactoryProvider() {}
// ********** Code for _XMLHttpRequestFactoryProvider **************
function _XMLHttpRequestFactoryProvider() {}
// ********** Code for _XMLSerializerFactoryProvider **************
function _XMLSerializerFactoryProvider() {}
// ********** Code for _XPathEvaluatorFactoryProvider **************
function _XPathEvaluatorFactoryProvider() {}
// ********** Code for _XSLTProcessorFactoryProvider **************
function _XSLTProcessorFactoryProvider() {}
// ********** Code for dom__Collections **************
function dom__Collections() {}
dom__Collections.map = function(source, destination, f) {
  for (var $$i = source.iterator(); $$i.hasNext(); ) {
    var e = $$i.next();
    destination.add(f(e));
  }
  return destination;
}
// ********** Code for _DOMWindowCrossFrameImpl **************
function _DOMWindowCrossFrameImpl() {}
_DOMWindowCrossFrameImpl.prototype.get$dartObjectLocalStorage = function() { return this.dartObjectLocalStorage; };
_DOMWindowCrossFrameImpl.prototype.set$dartObjectLocalStorage = function(value) { return this.dartObjectLocalStorage = value; };
_DOMWindowCrossFrameImpl.prototype.get$typeName = function() {
  return "DOMWindow";
}
_DOMWindowCrossFrameImpl.prototype.get$length = function() {
  return this._window.length;
}
// ********** Code for _AudioContextFactoryProvider **************
function _AudioContextFactoryProvider() {}
// ********** Code for _TypedArrayFactoryProvider **************
function _TypedArrayFactoryProvider() {}
// ********** Code for _WebKitPointFactoryProvider **************
function _WebKitPointFactoryProvider() {}
// ********** Code for _WebSocketFactoryProvider **************
function _WebSocketFactoryProvider() {}
// ********** Code for dom__VariableSizeListIterator **************
function dom__VariableSizeListIterator() {}
dom__VariableSizeListIterator.prototype.hasNext = function() {
  return this._dom_array.get$length() > this._dom_pos;
}
dom__VariableSizeListIterator.prototype.next = function() {
  if (!this.hasNext()) {
    $throw(const$0001);
  }
  return this._dom_array.$index(this._dom_pos++);
}
// ********** Code for dom__FixedSizeListIterator **************
$inherits(dom__FixedSizeListIterator, dom__VariableSizeListIterator);
function dom__FixedSizeListIterator() {}
dom__FixedSizeListIterator.prototype.hasNext = function() {
  return this._dom_length > this._dom_pos;
}
// ********** Code for dom__VariableSizeListIterator_dart_core_String **************
$inherits(dom__VariableSizeListIterator_dart_core_String, dom__VariableSizeListIterator);
function dom__VariableSizeListIterator_dart_core_String(array) {
  this._dom_array = array;
  this._dom_pos = (0);
}
// ********** Code for dom__FixedSizeListIterator_dart_core_String **************
$inherits(dom__FixedSizeListIterator_dart_core_String, dom__FixedSizeListIterator);
function dom__FixedSizeListIterator_dart_core_String(array) {
  this._dom_length = array.get$length();
  dom__VariableSizeListIterator_dart_core_String.call(this, array);
}
// ********** Code for dom__VariableSizeListIterator_int **************
$inherits(dom__VariableSizeListIterator_int, dom__VariableSizeListIterator);
function dom__VariableSizeListIterator_int(array) {
  this._dom_array = array;
  this._dom_pos = (0);
}
// ********** Code for dom__FixedSizeListIterator_int **************
$inherits(dom__FixedSizeListIterator_int, dom__FixedSizeListIterator);
function dom__FixedSizeListIterator_int(array) {
  this._dom_length = array.get$length();
  dom__VariableSizeListIterator_int.call(this, array);
}
// ********** Code for dom__VariableSizeListIterator_num **************
$inherits(dom__VariableSizeListIterator_num, dom__VariableSizeListIterator);
function dom__VariableSizeListIterator_num(array) {
  this._dom_array = array;
  this._dom_pos = (0);
}
// ********** Code for dom__FixedSizeListIterator_num **************
$inherits(dom__FixedSizeListIterator_num, dom__FixedSizeListIterator);
function dom__FixedSizeListIterator_num(array) {
  this._dom_length = array.get$length();
  dom__VariableSizeListIterator_num.call(this, array);
}
// ********** Code for dom__VariableSizeListIterator_dom_Node **************
$inherits(dom__VariableSizeListIterator_dom_Node, dom__VariableSizeListIterator);
function dom__VariableSizeListIterator_dom_Node(array) {
  this._dom_array = array;
  this._dom_pos = (0);
}
// ********** Code for dom__FixedSizeListIterator_dom_Node **************
$inherits(dom__FixedSizeListIterator_dom_Node, dom__FixedSizeListIterator);
function dom__FixedSizeListIterator_dom_Node(array) {
  this._dom_length = array.get$length();
  dom__VariableSizeListIterator_dom_Node.call(this, array);
}
// ********** Code for dom__VariableSizeListIterator_dom_StyleSheet **************
$inherits(dom__VariableSizeListIterator_dom_StyleSheet, dom__VariableSizeListIterator);
function dom__VariableSizeListIterator_dom_StyleSheet(array) {
  this._dom_array = array;
  this._dom_pos = (0);
}
// ********** Code for dom__FixedSizeListIterator_dom_StyleSheet **************
$inherits(dom__FixedSizeListIterator_dom_StyleSheet, dom__FixedSizeListIterator);
function dom__FixedSizeListIterator_dom_StyleSheet(array) {
  this._dom_length = array.get$length();
  dom__VariableSizeListIterator_dom_StyleSheet.call(this, array);
}
// ********** Code for dom__VariableSizeListIterator_dom_Touch **************
$inherits(dom__VariableSizeListIterator_dom_Touch, dom__VariableSizeListIterator);
function dom__VariableSizeListIterator_dom_Touch(array) {
  this._dom_array = array;
  this._dom_pos = (0);
}
// ********** Code for dom__FixedSizeListIterator_dom_Touch **************
$inherits(dom__FixedSizeListIterator_dom_Touch, dom__FixedSizeListIterator);
function dom__FixedSizeListIterator_dom_Touch(array) {
  this._dom_length = array.get$length();
  dom__VariableSizeListIterator_dom_Touch.call(this, array);
}
// ********** Code for _Lists **************
function _Lists() {}
_Lists.indexOf = function(a, element, startIndex, endIndex) {
  if (startIndex >= a.get$length()) {
    return (-1);
  }
  if (startIndex < (0)) {
    startIndex = (0);
  }
  for (var i = startIndex;
   i < endIndex; i++) {
    if ($eq$(a.$index(i), element)) {
      return i;
    }
  }
  return (-1);
}
// ********** Code for top level **************
function get$$window() {
  return window;
}
function get$$document() {
  return window.document;
}
//  ********** Library htmlimpl **************
// ********** Code for DOMWrapperBase **************
DOMWrapperBase._wrap$ctor = function(_ptr) {
  this._ptr = _ptr;
  var hasExistingWrapper = null == this._ptr.get$dartObjectLocalStorage();
  this._ptr.set$dartObjectLocalStorage(this);
}
DOMWrapperBase._wrap$ctor.prototype = DOMWrapperBase.prototype;
function DOMWrapperBase() {}
DOMWrapperBase.prototype.get$_ptr = function() { return this._ptr; };
// ********** Code for EventTargetWrappingImplementation **************
$inherits(EventTargetWrappingImplementation, DOMWrapperBase);
EventTargetWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
EventTargetWrappingImplementation._wrap$ctor.prototype = EventTargetWrappingImplementation.prototype;
function EventTargetWrappingImplementation() {}
// ********** Code for NodeWrappingImplementation **************
$inherits(NodeWrappingImplementation, EventTargetWrappingImplementation);
NodeWrappingImplementation._wrap$ctor = function(ptr) {
  EventTargetWrappingImplementation._wrap$ctor.call(this, ptr);
}
NodeWrappingImplementation._wrap$ctor.prototype = NodeWrappingImplementation.prototype;
function NodeWrappingImplementation() {}
NodeWrappingImplementation.prototype.get$nodes = function() {
  if (null == this._nodes) {
    this._nodes = new _ChildrenNodeList._wrap$ctor(this._ptr);
  }
  return this._nodes;
}
NodeWrappingImplementation.prototype.remove = function() {
  if (null != this._ptr.get$parentNode()) {
    this._ptr.get$parentNode().removeChild(this._ptr);
  }
  return this;
}
// ********** Code for ElementWrappingImplementation **************
$inherits(ElementWrappingImplementation, NodeWrappingImplementation);
ElementWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
ElementWrappingImplementation._wrap$ctor.prototype = ElementWrappingImplementation.prototype;
function ElementWrappingImplementation() {}
ElementWrappingImplementation.ElementWrappingImplementation$tag$factory = function(tag) {
  return LevelDom.wrapElement(get$$document().createElement(tag));
}
ElementWrappingImplementation.prototype.get$attributes = function() {
  if (null == this._elementAttributeMap) {
    this._elementAttributeMap = new ElementAttributeMap._wrap$ctor(this._ptr);
  }
  return this._elementAttributeMap;
}
ElementWrappingImplementation.prototype.get$id = function() {
  return this._ptr.get$id();
}
// ********** Code for AnchorElementWrappingImplementation **************
$inherits(AnchorElementWrappingImplementation, ElementWrappingImplementation);
AnchorElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
AnchorElementWrappingImplementation._wrap$ctor.prototype = AnchorElementWrappingImplementation.prototype;
function AnchorElementWrappingImplementation() {}
AnchorElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
AnchorElementWrappingImplementation.prototype.toString = function() {
  return this._ptr.toString();
}
// ********** Code for AreaElementWrappingImplementation **************
$inherits(AreaElementWrappingImplementation, ElementWrappingImplementation);
AreaElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
AreaElementWrappingImplementation._wrap$ctor.prototype = AreaElementWrappingImplementation.prototype;
function AreaElementWrappingImplementation() {}
// ********** Code for MediaElementWrappingImplementation **************
$inherits(MediaElementWrappingImplementation, ElementWrappingImplementation);
MediaElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
MediaElementWrappingImplementation._wrap$ctor.prototype = MediaElementWrappingImplementation.prototype;
function MediaElementWrappingImplementation() {}
// ********** Code for AudioElementWrappingImplementation **************
$inherits(AudioElementWrappingImplementation, MediaElementWrappingImplementation);
AudioElementWrappingImplementation._wrap$ctor = function(ptr) {
  MediaElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
AudioElementWrappingImplementation._wrap$ctor.prototype = AudioElementWrappingImplementation.prototype;
function AudioElementWrappingImplementation() {}
// ********** Code for EventWrappingImplementation **************
$inherits(EventWrappingImplementation, DOMWrapperBase);
EventWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
EventWrappingImplementation._wrap$ctor.prototype = EventWrappingImplementation.prototype;
function EventWrappingImplementation() {}
// ********** Code for AudioProcessingEventWrappingImplementation **************
$inherits(AudioProcessingEventWrappingImplementation, EventWrappingImplementation);
AudioProcessingEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
AudioProcessingEventWrappingImplementation._wrap$ctor.prototype = AudioProcessingEventWrappingImplementation.prototype;
function AudioProcessingEventWrappingImplementation() {}
// ********** Code for BRElementWrappingImplementation **************
$inherits(BRElementWrappingImplementation, ElementWrappingImplementation);
BRElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
BRElementWrappingImplementation._wrap$ctor.prototype = BRElementWrappingImplementation.prototype;
function BRElementWrappingImplementation() {}
// ********** Code for BaseElementWrappingImplementation **************
$inherits(BaseElementWrappingImplementation, ElementWrappingImplementation);
BaseElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
BaseElementWrappingImplementation._wrap$ctor.prototype = BaseElementWrappingImplementation.prototype;
function BaseElementWrappingImplementation() {}
// ********** Code for ButtonElementWrappingImplementation **************
$inherits(ButtonElementWrappingImplementation, ElementWrappingImplementation);
ButtonElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ButtonElementWrappingImplementation._wrap$ctor.prototype = ButtonElementWrappingImplementation.prototype;
function ButtonElementWrappingImplementation() {}
ButtonElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
ButtonElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
ButtonElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for CharacterDataWrappingImplementation **************
$inherits(CharacterDataWrappingImplementation, NodeWrappingImplementation);
CharacterDataWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
CharacterDataWrappingImplementation._wrap$ctor.prototype = CharacterDataWrappingImplementation.prototype;
function CharacterDataWrappingImplementation() {}
CharacterDataWrappingImplementation.prototype.get$data = function() {
  return this._ptr.get$data();
}
CharacterDataWrappingImplementation.prototype.get$length = function() {
  return this._ptr.get$length();
}
// ********** Code for TextWrappingImplementation **************
$inherits(TextWrappingImplementation, CharacterDataWrappingImplementation);
TextWrappingImplementation._wrap$ctor = function(ptr) {
  CharacterDataWrappingImplementation._wrap$ctor.call(this, ptr);
}
TextWrappingImplementation._wrap$ctor.prototype = TextWrappingImplementation.prototype;
function TextWrappingImplementation() {}
// ********** Code for CDATASectionWrappingImplementation **************
$inherits(CDATASectionWrappingImplementation, TextWrappingImplementation);
CDATASectionWrappingImplementation._wrap$ctor = function(ptr) {
  TextWrappingImplementation._wrap$ctor.call(this, ptr);
}
CDATASectionWrappingImplementation._wrap$ctor.prototype = CDATASectionWrappingImplementation.prototype;
function CDATASectionWrappingImplementation() {}
// ********** Code for CanvasElementWrappingImplementation **************
$inherits(CanvasElementWrappingImplementation, ElementWrappingImplementation);
CanvasElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
CanvasElementWrappingImplementation._wrap$ctor.prototype = CanvasElementWrappingImplementation.prototype;
function CanvasElementWrappingImplementation() {}
CanvasElementWrappingImplementation.prototype.is$CanvasElement = function(){return true};
CanvasElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
CanvasElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
CanvasElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
CanvasElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
CanvasElementWrappingImplementation.prototype.getContext = function(contextId) {
  if (null == contextId) {
    return LevelDom.wrapCanvasRenderingContext(this._ptr.getContext$0());
  }
  else {
    return LevelDom.wrapCanvasRenderingContext(this._ptr.getContext(contextId));
  }
}
CanvasElementWrappingImplementation.prototype.getContext$0 = CanvasElementWrappingImplementation.prototype.getContext;
// ********** Code for CanvasPatternWrappingImplementation **************
$inherits(CanvasPatternWrappingImplementation, DOMWrapperBase);
CanvasPatternWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
CanvasPatternWrappingImplementation._wrap$ctor.prototype = CanvasPatternWrappingImplementation.prototype;
function CanvasPatternWrappingImplementation() {}
// ********** Code for CanvasPixelArrayWrappingImplementation **************
$inherits(CanvasPixelArrayWrappingImplementation, DOMWrapperBase);
CanvasPixelArrayWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
CanvasPixelArrayWrappingImplementation._wrap$ctor.prototype = CanvasPixelArrayWrappingImplementation.prototype;
function CanvasPixelArrayWrappingImplementation() {}
CanvasPixelArrayWrappingImplementation.prototype.is$List = function(){return true};
CanvasPixelArrayWrappingImplementation.prototype.is$Collection = function(){return true};
CanvasPixelArrayWrappingImplementation.prototype.get$length = function() {
  return this._ptr.get$length();
}
CanvasPixelArrayWrappingImplementation.prototype.$index = function(index) {
  return this._ptr.$index(index);
}
CanvasPixelArrayWrappingImplementation.prototype.$setindex = function(index, value) {
  this._ptr.$setindex(index, value);
}
CanvasPixelArrayWrappingImplementation.prototype.add = function(value) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
CanvasPixelArrayWrappingImplementation.prototype.addAll = function(collection) {
  $throw(new UnsupportedOperationException("Cannot add to immutable List."));
}
CanvasPixelArrayWrappingImplementation.prototype.sort = function(compare) {
  $throw(new UnsupportedOperationException("Cannot sort immutable List."));
}
CanvasPixelArrayWrappingImplementation.prototype.indexOf = function(element, start) {
  return Lists.indexOf(this, element, start, this.get$length());
}
CanvasPixelArrayWrappingImplementation.prototype.clear = function() {
  $throw(new UnsupportedOperationException("Cannot clear immutable List."));
}
CanvasPixelArrayWrappingImplementation.prototype.removeLast = function() {
  $throw(new UnsupportedOperationException("Cannot removeLast on immutable List."));
}
CanvasPixelArrayWrappingImplementation.prototype.map = function(f) {
  return _Collections.map(this, [], f);
}
CanvasPixelArrayWrappingImplementation.prototype.get$map = function() {
  return this.map.bind(this);
}
CanvasPixelArrayWrappingImplementation.prototype.removeRange = function(start, length) {
  $throw(new UnsupportedOperationException("Cannot removeRange on immutable List."));
}
CanvasPixelArrayWrappingImplementation.prototype.iterator = function() {
  return new _FixedSizeListIterator_int(this);
}
CanvasPixelArrayWrappingImplementation.prototype.indexOf$1 = function($0) {
  return this.indexOf($0, (0));
};
CanvasPixelArrayWrappingImplementation.prototype.map$1 = function($0) {
  return this.map(to$call$1($0));
};
CanvasPixelArrayWrappingImplementation.prototype.sort$1 = function($0) {
  return this.sort(to$call$2($0));
};
// ********** Code for CanvasRenderingContextWrappingImplementation **************
$inherits(CanvasRenderingContextWrappingImplementation, DOMWrapperBase);
CanvasRenderingContextWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
CanvasRenderingContextWrappingImplementation._wrap$ctor.prototype = CanvasRenderingContextWrappingImplementation.prototype;
function CanvasRenderingContextWrappingImplementation() {}
// ********** Code for CanvasRenderingContext2DWrappingImplementation **************
$inherits(CanvasRenderingContext2DWrappingImplementation, CanvasRenderingContextWrappingImplementation);
CanvasRenderingContext2DWrappingImplementation._wrap$ctor = function(ptr) {
  CanvasRenderingContextWrappingImplementation._wrap$ctor.call(this, ptr);
}
CanvasRenderingContext2DWrappingImplementation._wrap$ctor.prototype = CanvasRenderingContext2DWrappingImplementation.prototype;
function CanvasRenderingContext2DWrappingImplementation() {}
CanvasRenderingContext2DWrappingImplementation.prototype.set$fillStyle = function(value) {
  this._ptr.set$fillStyle(LevelDom.unwrapMaybePrimitive(value));
}
CanvasRenderingContext2DWrappingImplementation.prototype.set$globalAlpha = function(value) {
  this._ptr.set$globalAlpha(value);
}
CanvasRenderingContext2DWrappingImplementation.prototype.set$globalCompositeOperation = function(value) {
  this._ptr.set$globalCompositeOperation(value);
}
CanvasRenderingContext2DWrappingImplementation.prototype.set$lineCap = function(value) {
  this._ptr.set$lineCap(value);
}
CanvasRenderingContext2DWrappingImplementation.prototype.set$lineJoin = function(value) {
  this._ptr.set$lineJoin(value);
}
CanvasRenderingContext2DWrappingImplementation.prototype.set$lineWidth = function(value) {
  this._ptr.set$lineWidth(value);
}
CanvasRenderingContext2DWrappingImplementation.prototype.set$strokeStyle = function(value) {
  this._ptr.set$strokeStyle(LevelDom.unwrapMaybePrimitive(value));
}
CanvasRenderingContext2DWrappingImplementation.prototype.beginPath = function() {
  this._ptr.beginPath();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.clearRect = function(x, y, width, height) {
  this._ptr.clearRect(x, y, width, height);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.clip = function() {
  this._ptr.clip();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.closePath = function() {
  this._ptr.closePath();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.createPattern = function(canvas_OR_image, repetitionType) {
  if (!!(canvas_OR_image && canvas_OR_image.is$CanvasElement())) {
    return LevelDom.wrapCanvasPattern(this._ptr.createPattern(LevelDom.unwrapMaybePrimitive(canvas_OR_image), repetitionType));
  }
  else {
    if (!!(canvas_OR_image && canvas_OR_image.is$ImageElement())) {
      return LevelDom.wrapCanvasPattern(this._ptr.createPattern(LevelDom.unwrapMaybePrimitive(canvas_OR_image), repetitionType));
    }
  }
  $throw("Incorrect number or type of arguments");
}
CanvasRenderingContext2DWrappingImplementation.prototype.drawImage = function(canvas_OR_image, sx_OR_x, sy_OR_y, sw_OR_width, height_OR_sh, dx, dy, dw, dh) {
  if (!!(canvas_OR_image && canvas_OR_image.is$ImageElement())) {
    if (null == sw_OR_width) {
      if (null == height_OR_sh) {
        if (null == dx) {
          if (null == dy) {
            if (null == dw) {
              if (null == dh) {
                this._ptr.drawImage$3(LevelDom.unwrapMaybePrimitive(canvas_OR_image), sx_OR_x, sy_OR_y);
                return;
              }
            }
          }
        }
      }
    }
    else {
      if (null == dx) {
        if (null == dy) {
          if (null == dw) {
            if (null == dh) {
              this._ptr.drawImage$5(LevelDom.unwrapMaybePrimitive(canvas_OR_image), sx_OR_x, sy_OR_y, sw_OR_width, height_OR_sh);
              return;
            }
          }
        }
      }
      else {
        this._ptr.drawImage(LevelDom.unwrapMaybePrimitive(canvas_OR_image), sx_OR_x, sy_OR_y, sw_OR_width, height_OR_sh, dx, dy, dw, dh);
        return;
      }
    }
  }
  else {
    if (!!(canvas_OR_image && canvas_OR_image.is$CanvasElement())) {
      if (null == sw_OR_width) {
        if (null == height_OR_sh) {
          if (null == dx) {
            if (null == dy) {
              if (null == dw) {
                if (null == dh) {
                  this._ptr.drawImage$3(LevelDom.unwrapMaybePrimitive(canvas_OR_image), sx_OR_x, sy_OR_y);
                  return;
                }
              }
            }
          }
        }
      }
      else {
        if (null == dx) {
          if (null == dy) {
            if (null == dw) {
              if (null == dh) {
                this._ptr.drawImage$5(LevelDom.unwrapMaybePrimitive(canvas_OR_image), sx_OR_x, sy_OR_y, sw_OR_width, height_OR_sh);
                return;
              }
            }
          }
        }
        else {
          this._ptr.drawImage(LevelDom.unwrapMaybePrimitive(canvas_OR_image), sx_OR_x, sy_OR_y, sw_OR_width, height_OR_sh, dx, dy, dw, dh);
          return;
        }
      }
    }
  }
  $throw("Incorrect number or type of arguments");
}
CanvasRenderingContext2DWrappingImplementation.prototype.fill = function() {
  this._ptr.fill();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.fillRect = function(x, y, width, height) {
  this._ptr.fillRect(x, y, width, height);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.getImageData = function(sx, sy, sw, sh) {
  return LevelDom.wrapImageData(this._ptr.getImageData(sx, sy, sw, sh));
}
CanvasRenderingContext2DWrappingImplementation.prototype.lineTo = function(x, y) {
  this._ptr.lineTo(x, y);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.moveTo = function(x, y) {
  this._ptr.moveTo$2(x, y);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.putImageData = function(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight) {
  if (null == dirtyX) {
    if (null == dirtyY) {
      if (null == dirtyWidth) {
        if (null == dirtyHeight) {
          this._ptr.putImageData$3(LevelDom.unwrap(imagedata), dx, dy);
          return;
        }
      }
    }
  }
  else {
    this._ptr.putImageData(LevelDom.unwrap(imagedata), dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
    return;
  }
  $throw("Incorrect number or type of arguments");
}
CanvasRenderingContext2DWrappingImplementation.prototype.restore = function() {
  this._ptr.restore();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.rotate = function(angle) {
  this._ptr.rotate$1(angle);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.save = function() {
  this._ptr.save();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.scale = function(sx, sy) {
  this._ptr.scale$2(sx, sy);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.get$scale = function() {
  return this.scale.bind(this);
}
CanvasRenderingContext2DWrappingImplementation.prototype.setTransform = function(m11, m12, m21, m22, dx, dy) {
  this._ptr.setTransform(m11, m12, m21, m22, dx, dy);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.stroke = function() {
  this._ptr.stroke();
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.strokeRect = function(x, y, width, height, lineWidth) {
  if (null == lineWidth) {
    this._ptr.strokeRect$4(x, y, width, height);
    return;
  }
  else {
    this._ptr.strokeRect(x, y, width, height, lineWidth);
    return;
  }
}
CanvasRenderingContext2DWrappingImplementation.prototype.transform = function(m11, m12, m21, m22, dx, dy) {
  this._ptr.transform$6(m11, m12, m21, m22, dx, dy);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.translate = function(tx, ty) {
  this._ptr.translate$2(tx, ty);
  return;
}
CanvasRenderingContext2DWrappingImplementation.prototype.drawImage$3 = CanvasRenderingContext2DWrappingImplementation.prototype.drawImage;
CanvasRenderingContext2DWrappingImplementation.prototype.drawImage$5 = CanvasRenderingContext2DWrappingImplementation.prototype.drawImage;
CanvasRenderingContext2DWrappingImplementation.prototype.moveTo$2 = CanvasRenderingContext2DWrappingImplementation.prototype.moveTo;
CanvasRenderingContext2DWrappingImplementation.prototype.putImageData$3 = CanvasRenderingContext2DWrappingImplementation.prototype.putImageData;
CanvasRenderingContext2DWrappingImplementation.prototype.rotate$1 = CanvasRenderingContext2DWrappingImplementation.prototype.rotate;
CanvasRenderingContext2DWrappingImplementation.prototype.scale$2 = CanvasRenderingContext2DWrappingImplementation.prototype.scale;
CanvasRenderingContext2DWrappingImplementation.prototype.strokeRect$4 = CanvasRenderingContext2DWrappingImplementation.prototype.strokeRect;
CanvasRenderingContext2DWrappingImplementation.prototype.transform$6 = CanvasRenderingContext2DWrappingImplementation.prototype.transform;
CanvasRenderingContext2DWrappingImplementation.prototype.translate$2 = CanvasRenderingContext2DWrappingImplementation.prototype.translate;
// ********** Code for CommentWrappingImplementation **************
$inherits(CommentWrappingImplementation, CharacterDataWrappingImplementation);
CommentWrappingImplementation._wrap$ctor = function(ptr) {
  CharacterDataWrappingImplementation._wrap$ctor.call(this, ptr);
}
CommentWrappingImplementation._wrap$ctor.prototype = CommentWrappingImplementation.prototype;
function CommentWrappingImplementation() {}
// ********** Code for DListElementWrappingImplementation **************
$inherits(DListElementWrappingImplementation, ElementWrappingImplementation);
DListElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
DListElementWrappingImplementation._wrap$ctor.prototype = DListElementWrappingImplementation.prototype;
function DListElementWrappingImplementation() {}
// ********** Code for DataListElementWrappingImplementation **************
$inherits(DataListElementWrappingImplementation, ElementWrappingImplementation);
DataListElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
DataListElementWrappingImplementation._wrap$ctor.prototype = DataListElementWrappingImplementation.prototype;
function DataListElementWrappingImplementation() {}
// ********** Code for DetailsElementWrappingImplementation **************
$inherits(DetailsElementWrappingImplementation, ElementWrappingImplementation);
DetailsElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
DetailsElementWrappingImplementation._wrap$ctor.prototype = DetailsElementWrappingImplementation.prototype;
function DetailsElementWrappingImplementation() {}
// ********** Code for DivElementWrappingImplementation **************
$inherits(DivElementWrappingImplementation, ElementWrappingImplementation);
DivElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
DivElementWrappingImplementation._wrap$ctor.prototype = DivElementWrappingImplementation.prototype;
function DivElementWrappingImplementation() {}
// ********** Code for EmbedElementWrappingImplementation **************
$inherits(EmbedElementWrappingImplementation, ElementWrappingImplementation);
EmbedElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
EmbedElementWrappingImplementation._wrap$ctor.prototype = EmbedElementWrappingImplementation.prototype;
function EmbedElementWrappingImplementation() {}
EmbedElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
EmbedElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
EmbedElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
EmbedElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
EmbedElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for EntityReferenceWrappingImplementation **************
$inherits(EntityReferenceWrappingImplementation, NodeWrappingImplementation);
EntityReferenceWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
EntityReferenceWrappingImplementation._wrap$ctor.prototype = EntityReferenceWrappingImplementation.prototype;
function EntityReferenceWrappingImplementation() {}
// ********** Code for EntityWrappingImplementation **************
$inherits(EntityWrappingImplementation, NodeWrappingImplementation);
EntityWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
EntityWrappingImplementation._wrap$ctor.prototype = EntityWrappingImplementation.prototype;
function EntityWrappingImplementation() {}
// ********** Code for FieldSetElementWrappingImplementation **************
$inherits(FieldSetElementWrappingImplementation, ElementWrappingImplementation);
FieldSetElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
FieldSetElementWrappingImplementation._wrap$ctor.prototype = FieldSetElementWrappingImplementation.prototype;
function FieldSetElementWrappingImplementation() {}
// ********** Code for FontElementWrappingImplementation **************
$inherits(FontElementWrappingImplementation, ElementWrappingImplementation);
FontElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
FontElementWrappingImplementation._wrap$ctor.prototype = FontElementWrappingImplementation.prototype;
function FontElementWrappingImplementation() {}
FontElementWrappingImplementation.prototype.get$color = function() {
  return this._ptr.get$color();
}
// ********** Code for FormElementWrappingImplementation **************
$inherits(FormElementWrappingImplementation, ElementWrappingImplementation);
FormElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
FormElementWrappingImplementation._wrap$ctor.prototype = FormElementWrappingImplementation.prototype;
function FormElementWrappingImplementation() {}
FormElementWrappingImplementation.prototype.get$length = function() {
  return this._ptr.get$length();
}
FormElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
// ********** Code for HRElementWrappingImplementation **************
$inherits(HRElementWrappingImplementation, ElementWrappingImplementation);
HRElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
HRElementWrappingImplementation._wrap$ctor.prototype = HRElementWrappingImplementation.prototype;
function HRElementWrappingImplementation() {}
HRElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
HRElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for HeadElementWrappingImplementation **************
$inherits(HeadElementWrappingImplementation, ElementWrappingImplementation);
HeadElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
HeadElementWrappingImplementation._wrap$ctor.prototype = HeadElementWrappingImplementation.prototype;
function HeadElementWrappingImplementation() {}
// ********** Code for HeadingElementWrappingImplementation **************
$inherits(HeadingElementWrappingImplementation, ElementWrappingImplementation);
HeadingElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
HeadingElementWrappingImplementation._wrap$ctor.prototype = HeadingElementWrappingImplementation.prototype;
function HeadingElementWrappingImplementation() {}
// ********** Code for IDBVersionChangeEventWrappingImplementation **************
$inherits(IDBVersionChangeEventWrappingImplementation, EventWrappingImplementation);
IDBVersionChangeEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
IDBVersionChangeEventWrappingImplementation._wrap$ctor.prototype = IDBVersionChangeEventWrappingImplementation.prototype;
function IDBVersionChangeEventWrappingImplementation() {}
// ********** Code for IFrameElementWrappingImplementation **************
$inherits(IFrameElementWrappingImplementation, ElementWrappingImplementation);
IFrameElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
IFrameElementWrappingImplementation._wrap$ctor.prototype = IFrameElementWrappingImplementation.prototype;
function IFrameElementWrappingImplementation() {}
IFrameElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
IFrameElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
IFrameElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
IFrameElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
IFrameElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for ImageDataWrappingImplementation **************
$inherits(ImageDataWrappingImplementation, DOMWrapperBase);
ImageDataWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
ImageDataWrappingImplementation._wrap$ctor.prototype = ImageDataWrappingImplementation.prototype;
function ImageDataWrappingImplementation() {}
ImageDataWrappingImplementation.prototype.get$data = function() {
  return LevelDom.wrapCanvasPixelArray(this._ptr.get$data());
}
ImageDataWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
ImageDataWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
// ********** Code for ImageElementWrappingImplementation **************
$inherits(ImageElementWrappingImplementation, ElementWrappingImplementation);
ImageElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ImageElementWrappingImplementation._wrap$ctor.prototype = ImageElementWrappingImplementation.prototype;
function ImageElementWrappingImplementation() {}
ImageElementWrappingImplementation.prototype.is$ImageElement = function(){return true};
ImageElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
ImageElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
ImageElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
ImageElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
ImageElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
ImageElementWrappingImplementation.prototype.get$x = function() {
  return this._ptr.get$x();
}
ImageElementWrappingImplementation.prototype.get$y = function() {
  return this._ptr.get$y();
}
// ********** Code for InputElementWrappingImplementation **************
$inherits(InputElementWrappingImplementation, ElementWrappingImplementation);
InputElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
InputElementWrappingImplementation._wrap$ctor.prototype = InputElementWrappingImplementation.prototype;
function InputElementWrappingImplementation() {}
InputElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
InputElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
InputElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for KeygenElementWrappingImplementation **************
$inherits(KeygenElementWrappingImplementation, ElementWrappingImplementation);
KeygenElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
KeygenElementWrappingImplementation._wrap$ctor.prototype = KeygenElementWrappingImplementation.prototype;
function KeygenElementWrappingImplementation() {}
KeygenElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
// ********** Code for LIElementWrappingImplementation **************
$inherits(LIElementWrappingImplementation, ElementWrappingImplementation);
LIElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
LIElementWrappingImplementation._wrap$ctor.prototype = LIElementWrappingImplementation.prototype;
function LIElementWrappingImplementation() {}
LIElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
LIElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for LabelElementWrappingImplementation **************
$inherits(LabelElementWrappingImplementation, ElementWrappingImplementation);
LabelElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
LabelElementWrappingImplementation._wrap$ctor.prototype = LabelElementWrappingImplementation.prototype;
function LabelElementWrappingImplementation() {}
// ********** Code for LegendElementWrappingImplementation **************
$inherits(LegendElementWrappingImplementation, ElementWrappingImplementation);
LegendElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
LegendElementWrappingImplementation._wrap$ctor.prototype = LegendElementWrappingImplementation.prototype;
function LegendElementWrappingImplementation() {}
// ********** Code for LinkElementWrappingImplementation **************
$inherits(LinkElementWrappingImplementation, ElementWrappingImplementation);
LinkElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
LinkElementWrappingImplementation._wrap$ctor.prototype = LinkElementWrappingImplementation.prototype;
function LinkElementWrappingImplementation() {}
// ********** Code for MapElementWrappingImplementation **************
$inherits(MapElementWrappingImplementation, ElementWrappingImplementation);
MapElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
MapElementWrappingImplementation._wrap$ctor.prototype = MapElementWrappingImplementation.prototype;
function MapElementWrappingImplementation() {}
MapElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
// ********** Code for MarqueeElementWrappingImplementation **************
$inherits(MarqueeElementWrappingImplementation, ElementWrappingImplementation);
MarqueeElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
MarqueeElementWrappingImplementation._wrap$ctor.prototype = MarqueeElementWrappingImplementation.prototype;
function MarqueeElementWrappingImplementation() {}
MarqueeElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
MarqueeElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
MarqueeElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
MarqueeElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for MenuElementWrappingImplementation **************
$inherits(MenuElementWrappingImplementation, ElementWrappingImplementation);
MenuElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
MenuElementWrappingImplementation._wrap$ctor.prototype = MenuElementWrappingImplementation.prototype;
function MenuElementWrappingImplementation() {}
// ********** Code for MetaElementWrappingImplementation **************
$inherits(MetaElementWrappingImplementation, ElementWrappingImplementation);
MetaElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
MetaElementWrappingImplementation._wrap$ctor.prototype = MetaElementWrappingImplementation.prototype;
function MetaElementWrappingImplementation() {}
MetaElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
// ********** Code for MeterElementWrappingImplementation **************
$inherits(MeterElementWrappingImplementation, ElementWrappingImplementation);
MeterElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
MeterElementWrappingImplementation._wrap$ctor.prototype = MeterElementWrappingImplementation.prototype;
function MeterElementWrappingImplementation() {}
MeterElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
MeterElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for ModElementWrappingImplementation **************
$inherits(ModElementWrappingImplementation, ElementWrappingImplementation);
ModElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ModElementWrappingImplementation._wrap$ctor.prototype = ModElementWrappingImplementation.prototype;
function ModElementWrappingImplementation() {}
// ********** Code for NotationWrappingImplementation **************
$inherits(NotationWrappingImplementation, NodeWrappingImplementation);
NotationWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
NotationWrappingImplementation._wrap$ctor.prototype = NotationWrappingImplementation.prototype;
function NotationWrappingImplementation() {}
// ********** Code for OListElementWrappingImplementation **************
$inherits(OListElementWrappingImplementation, ElementWrappingImplementation);
OListElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
OListElementWrappingImplementation._wrap$ctor.prototype = OListElementWrappingImplementation.prototype;
function OListElementWrappingImplementation() {}
// ********** Code for OfflineAudioCompletionEventWrappingImplementation **************
$inherits(OfflineAudioCompletionEventWrappingImplementation, EventWrappingImplementation);
OfflineAudioCompletionEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
OfflineAudioCompletionEventWrappingImplementation._wrap$ctor.prototype = OfflineAudioCompletionEventWrappingImplementation.prototype;
function OfflineAudioCompletionEventWrappingImplementation() {}
// ********** Code for OptGroupElementWrappingImplementation **************
$inherits(OptGroupElementWrappingImplementation, ElementWrappingImplementation);
OptGroupElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
OptGroupElementWrappingImplementation._wrap$ctor.prototype = OptGroupElementWrappingImplementation.prototype;
function OptGroupElementWrappingImplementation() {}
// ********** Code for OptionElementWrappingImplementation **************
$inherits(OptionElementWrappingImplementation, ElementWrappingImplementation);
OptionElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
OptionElementWrappingImplementation._wrap$ctor.prototype = OptionElementWrappingImplementation.prototype;
function OptionElementWrappingImplementation() {}
OptionElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
OptionElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for OutputElementWrappingImplementation **************
$inherits(OutputElementWrappingImplementation, ElementWrappingImplementation);
OutputElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
OutputElementWrappingImplementation._wrap$ctor.prototype = OutputElementWrappingImplementation.prototype;
function OutputElementWrappingImplementation() {}
OutputElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
OutputElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
OutputElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for ParagraphElementWrappingImplementation **************
$inherits(ParagraphElementWrappingImplementation, ElementWrappingImplementation);
ParagraphElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ParagraphElementWrappingImplementation._wrap$ctor.prototype = ParagraphElementWrappingImplementation.prototype;
function ParagraphElementWrappingImplementation() {}
// ********** Code for ParamElementWrappingImplementation **************
$inherits(ParamElementWrappingImplementation, ElementWrappingImplementation);
ParamElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ParamElementWrappingImplementation._wrap$ctor.prototype = ParamElementWrappingImplementation.prototype;
function ParamElementWrappingImplementation() {}
ParamElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
ParamElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
ParamElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for PreElementWrappingImplementation **************
$inherits(PreElementWrappingImplementation, ElementWrappingImplementation);
PreElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
PreElementWrappingImplementation._wrap$ctor.prototype = PreElementWrappingImplementation.prototype;
function PreElementWrappingImplementation() {}
PreElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
PreElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for ProcessingInstructionWrappingImplementation **************
$inherits(ProcessingInstructionWrappingImplementation, NodeWrappingImplementation);
ProcessingInstructionWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
ProcessingInstructionWrappingImplementation._wrap$ctor.prototype = ProcessingInstructionWrappingImplementation.prototype;
function ProcessingInstructionWrappingImplementation() {}
ProcessingInstructionWrappingImplementation.prototype.get$data = function() {
  return this._ptr.get$data();
}
// ********** Code for ProgressElementWrappingImplementation **************
$inherits(ProgressElementWrappingImplementation, ElementWrappingImplementation);
ProgressElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ProgressElementWrappingImplementation._wrap$ctor.prototype = ProgressElementWrappingImplementation.prototype;
function ProgressElementWrappingImplementation() {}
ProgressElementWrappingImplementation.prototype.get$position = function() {
  return this._ptr.get$position();
}
ProgressElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
ProgressElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for QuoteElementWrappingImplementation **************
$inherits(QuoteElementWrappingImplementation, ElementWrappingImplementation);
QuoteElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
QuoteElementWrappingImplementation._wrap$ctor.prototype = QuoteElementWrappingImplementation.prototype;
function QuoteElementWrappingImplementation() {}
// ********** Code for SVGElementWrappingImplementation **************
$inherits(SVGElementWrappingImplementation, ElementWrappingImplementation);
SVGElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGElementWrappingImplementation._wrap$ctor.prototype = SVGElementWrappingImplementation.prototype;
function SVGElementWrappingImplementation() {}
SVGElementWrappingImplementation.prototype.get$id = function() {
  return this._ptr.get$id();
}
// ********** Code for SVGAElementWrappingImplementation **************
$inherits(SVGAElementWrappingImplementation, SVGElementWrappingImplementation);
SVGAElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAElementWrappingImplementation._wrap$ctor.prototype = SVGAElementWrappingImplementation.prototype;
function SVGAElementWrappingImplementation() {}
// ********** Code for SVGAltGlyphDefElementWrappingImplementation **************
$inherits(SVGAltGlyphDefElementWrappingImplementation, SVGElementWrappingImplementation);
SVGAltGlyphDefElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAltGlyphDefElementWrappingImplementation._wrap$ctor.prototype = SVGAltGlyphDefElementWrappingImplementation.prototype;
function SVGAltGlyphDefElementWrappingImplementation() {}
// ********** Code for SVGTextContentElementWrappingImplementation **************
$inherits(SVGTextContentElementWrappingImplementation, SVGElementWrappingImplementation);
SVGTextContentElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTextContentElementWrappingImplementation._wrap$ctor.prototype = SVGTextContentElementWrappingImplementation.prototype;
function SVGTextContentElementWrappingImplementation() {}
// ********** Code for SVGTextPositioningElementWrappingImplementation **************
$inherits(SVGTextPositioningElementWrappingImplementation, SVGTextContentElementWrappingImplementation);
SVGTextPositioningElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGTextContentElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTextPositioningElementWrappingImplementation._wrap$ctor.prototype = SVGTextPositioningElementWrappingImplementation.prototype;
function SVGTextPositioningElementWrappingImplementation() {}
SVGTextPositioningElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLengthList(this._ptr.get$x());
}
SVGTextPositioningElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLengthList(this._ptr.get$y());
}
// ********** Code for SVGAltGlyphElementWrappingImplementation **************
$inherits(SVGAltGlyphElementWrappingImplementation, SVGTextPositioningElementWrappingImplementation);
SVGAltGlyphElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGTextPositioningElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAltGlyphElementWrappingImplementation._wrap$ctor.prototype = SVGAltGlyphElementWrappingImplementation.prototype;
function SVGAltGlyphElementWrappingImplementation() {}
// ********** Code for SVGAltGlyphItemElementWrappingImplementation **************
$inherits(SVGAltGlyphItemElementWrappingImplementation, SVGElementWrappingImplementation);
SVGAltGlyphItemElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAltGlyphItemElementWrappingImplementation._wrap$ctor.prototype = SVGAltGlyphItemElementWrappingImplementation.prototype;
function SVGAltGlyphItemElementWrappingImplementation() {}
// ********** Code for SVGAnimationElementWrappingImplementation **************
$inherits(SVGAnimationElementWrappingImplementation, SVGElementWrappingImplementation);
SVGAnimationElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAnimationElementWrappingImplementation._wrap$ctor.prototype = SVGAnimationElementWrappingImplementation.prototype;
function SVGAnimationElementWrappingImplementation() {}
// ********** Code for SVGAnimateColorElementWrappingImplementation **************
$inherits(SVGAnimateColorElementWrappingImplementation, SVGAnimationElementWrappingImplementation);
SVGAnimateColorElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGAnimationElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAnimateColorElementWrappingImplementation._wrap$ctor.prototype = SVGAnimateColorElementWrappingImplementation.prototype;
function SVGAnimateColorElementWrappingImplementation() {}
// ********** Code for SVGAnimateElementWrappingImplementation **************
$inherits(SVGAnimateElementWrappingImplementation, SVGAnimationElementWrappingImplementation);
SVGAnimateElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGAnimationElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAnimateElementWrappingImplementation._wrap$ctor.prototype = SVGAnimateElementWrappingImplementation.prototype;
function SVGAnimateElementWrappingImplementation() {}
// ********** Code for SVGAnimateMotionElementWrappingImplementation **************
$inherits(SVGAnimateMotionElementWrappingImplementation, SVGAnimationElementWrappingImplementation);
SVGAnimateMotionElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGAnimationElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAnimateMotionElementWrappingImplementation._wrap$ctor.prototype = SVGAnimateMotionElementWrappingImplementation.prototype;
function SVGAnimateMotionElementWrappingImplementation() {}
// ********** Code for SVGAnimateTransformElementWrappingImplementation **************
$inherits(SVGAnimateTransformElementWrappingImplementation, SVGAnimationElementWrappingImplementation);
SVGAnimateTransformElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGAnimationElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGAnimateTransformElementWrappingImplementation._wrap$ctor.prototype = SVGAnimateTransformElementWrappingImplementation.prototype;
function SVGAnimateTransformElementWrappingImplementation() {}
// ********** Code for SVGAnimatedLengthListWrappingImplementation **************
$inherits(SVGAnimatedLengthListWrappingImplementation, DOMWrapperBase);
SVGAnimatedLengthListWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
SVGAnimatedLengthListWrappingImplementation._wrap$ctor.prototype = SVGAnimatedLengthListWrappingImplementation.prototype;
function SVGAnimatedLengthListWrappingImplementation() {}
// ********** Code for SVGAnimatedLengthWrappingImplementation **************
$inherits(SVGAnimatedLengthWrappingImplementation, DOMWrapperBase);
SVGAnimatedLengthWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
SVGAnimatedLengthWrappingImplementation._wrap$ctor.prototype = SVGAnimatedLengthWrappingImplementation.prototype;
function SVGAnimatedLengthWrappingImplementation() {}
// ********** Code for SVGAnimatedNumberWrappingImplementation **************
$inherits(SVGAnimatedNumberWrappingImplementation, DOMWrapperBase);
SVGAnimatedNumberWrappingImplementation._wrap$ctor = function(ptr) {
  DOMWrapperBase._wrap$ctor.call(this, ptr);
}
SVGAnimatedNumberWrappingImplementation._wrap$ctor.prototype = SVGAnimatedNumberWrappingImplementation.prototype;
function SVGAnimatedNumberWrappingImplementation() {}
// ********** Code for SVGCircleElementWrappingImplementation **************
$inherits(SVGCircleElementWrappingImplementation, SVGElementWrappingImplementation);
SVGCircleElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGCircleElementWrappingImplementation._wrap$ctor.prototype = SVGCircleElementWrappingImplementation.prototype;
function SVGCircleElementWrappingImplementation() {}
// ********** Code for SVGClipPathElementWrappingImplementation **************
$inherits(SVGClipPathElementWrappingImplementation, SVGElementWrappingImplementation);
SVGClipPathElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGClipPathElementWrappingImplementation._wrap$ctor.prototype = SVGClipPathElementWrappingImplementation.prototype;
function SVGClipPathElementWrappingImplementation() {}
// ********** Code for SVGComponentTransferFunctionElementWrappingImplementation **************
$inherits(SVGComponentTransferFunctionElementWrappingImplementation, SVGElementWrappingImplementation);
SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor.prototype = SVGComponentTransferFunctionElementWrappingImplementation.prototype;
function SVGComponentTransferFunctionElementWrappingImplementation() {}
SVGComponentTransferFunctionElementWrappingImplementation.prototype.get$offset = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$offset());
}
// ********** Code for SVGCursorElementWrappingImplementation **************
$inherits(SVGCursorElementWrappingImplementation, SVGElementWrappingImplementation);
SVGCursorElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGCursorElementWrappingImplementation._wrap$ctor.prototype = SVGCursorElementWrappingImplementation.prototype;
function SVGCursorElementWrappingImplementation() {}
SVGCursorElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGCursorElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGDefsElementWrappingImplementation **************
$inherits(SVGDefsElementWrappingImplementation, SVGElementWrappingImplementation);
SVGDefsElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGDefsElementWrappingImplementation._wrap$ctor.prototype = SVGDefsElementWrappingImplementation.prototype;
function SVGDefsElementWrappingImplementation() {}
// ********** Code for SVGDescElementWrappingImplementation **************
$inherits(SVGDescElementWrappingImplementation, SVGElementWrappingImplementation);
SVGDescElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGDescElementWrappingImplementation._wrap$ctor.prototype = SVGDescElementWrappingImplementation.prototype;
function SVGDescElementWrappingImplementation() {}
// ********** Code for SVGEllipseElementWrappingImplementation **************
$inherits(SVGEllipseElementWrappingImplementation, SVGElementWrappingImplementation);
SVGEllipseElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGEllipseElementWrappingImplementation._wrap$ctor.prototype = SVGEllipseElementWrappingImplementation.prototype;
function SVGEllipseElementWrappingImplementation() {}
// ********** Code for SVGFEBlendElementWrappingImplementation **************
$inherits(SVGFEBlendElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEBlendElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEBlendElementWrappingImplementation._wrap$ctor.prototype = SVGFEBlendElementWrappingImplementation.prototype;
function SVGFEBlendElementWrappingImplementation() {}
SVGFEBlendElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEBlendElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEBlendElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEBlendElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEColorMatrixElementWrappingImplementation **************
$inherits(SVGFEColorMatrixElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEColorMatrixElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEColorMatrixElementWrappingImplementation._wrap$ctor.prototype = SVGFEColorMatrixElementWrappingImplementation.prototype;
function SVGFEColorMatrixElementWrappingImplementation() {}
SVGFEColorMatrixElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEColorMatrixElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEColorMatrixElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEColorMatrixElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEComponentTransferElementWrappingImplementation **************
$inherits(SVGFEComponentTransferElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEComponentTransferElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEComponentTransferElementWrappingImplementation._wrap$ctor.prototype = SVGFEComponentTransferElementWrappingImplementation.prototype;
function SVGFEComponentTransferElementWrappingImplementation() {}
SVGFEComponentTransferElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEComponentTransferElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEComponentTransferElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEComponentTransferElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEConvolveMatrixElementWrappingImplementation **************
$inherits(SVGFEConvolveMatrixElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEConvolveMatrixElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEConvolveMatrixElementWrappingImplementation._wrap$ctor.prototype = SVGFEConvolveMatrixElementWrappingImplementation.prototype;
function SVGFEConvolveMatrixElementWrappingImplementation() {}
SVGFEConvolveMatrixElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEConvolveMatrixElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEConvolveMatrixElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEConvolveMatrixElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEDiffuseLightingElementWrappingImplementation **************
$inherits(SVGFEDiffuseLightingElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEDiffuseLightingElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEDiffuseLightingElementWrappingImplementation._wrap$ctor.prototype = SVGFEDiffuseLightingElementWrappingImplementation.prototype;
function SVGFEDiffuseLightingElementWrappingImplementation() {}
SVGFEDiffuseLightingElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEDiffuseLightingElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEDiffuseLightingElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEDiffuseLightingElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEDisplacementMapElementWrappingImplementation **************
$inherits(SVGFEDisplacementMapElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEDisplacementMapElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEDisplacementMapElementWrappingImplementation._wrap$ctor.prototype = SVGFEDisplacementMapElementWrappingImplementation.prototype;
function SVGFEDisplacementMapElementWrappingImplementation() {}
SVGFEDisplacementMapElementWrappingImplementation.prototype.get$scale = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$scale());
}
SVGFEDisplacementMapElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEDisplacementMapElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEDisplacementMapElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEDisplacementMapElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEDistantLightElementWrappingImplementation **************
$inherits(SVGFEDistantLightElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEDistantLightElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEDistantLightElementWrappingImplementation._wrap$ctor.prototype = SVGFEDistantLightElementWrappingImplementation.prototype;
function SVGFEDistantLightElementWrappingImplementation() {}
// ********** Code for SVGFEDropShadowElementWrappingImplementation **************
$inherits(SVGFEDropShadowElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEDropShadowElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEDropShadowElementWrappingImplementation._wrap$ctor.prototype = SVGFEDropShadowElementWrappingImplementation.prototype;
function SVGFEDropShadowElementWrappingImplementation() {}
SVGFEDropShadowElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEDropShadowElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEDropShadowElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEDropShadowElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEFloodElementWrappingImplementation **************
$inherits(SVGFEFloodElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEFloodElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEFloodElementWrappingImplementation._wrap$ctor.prototype = SVGFEFloodElementWrappingImplementation.prototype;
function SVGFEFloodElementWrappingImplementation() {}
SVGFEFloodElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEFloodElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEFloodElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEFloodElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEFuncAElementWrappingImplementation **************
$inherits(SVGFEFuncAElementWrappingImplementation, SVGComponentTransferFunctionElementWrappingImplementation);
SVGFEFuncAElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEFuncAElementWrappingImplementation._wrap$ctor.prototype = SVGFEFuncAElementWrappingImplementation.prototype;
function SVGFEFuncAElementWrappingImplementation() {}
// ********** Code for SVGFEFuncBElementWrappingImplementation **************
$inherits(SVGFEFuncBElementWrappingImplementation, SVGComponentTransferFunctionElementWrappingImplementation);
SVGFEFuncBElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEFuncBElementWrappingImplementation._wrap$ctor.prototype = SVGFEFuncBElementWrappingImplementation.prototype;
function SVGFEFuncBElementWrappingImplementation() {}
// ********** Code for SVGFEFuncGElementWrappingImplementation **************
$inherits(SVGFEFuncGElementWrappingImplementation, SVGComponentTransferFunctionElementWrappingImplementation);
SVGFEFuncGElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEFuncGElementWrappingImplementation._wrap$ctor.prototype = SVGFEFuncGElementWrappingImplementation.prototype;
function SVGFEFuncGElementWrappingImplementation() {}
// ********** Code for SVGFEFuncRElementWrappingImplementation **************
$inherits(SVGFEFuncRElementWrappingImplementation, SVGComponentTransferFunctionElementWrappingImplementation);
SVGFEFuncRElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEFuncRElementWrappingImplementation._wrap$ctor.prototype = SVGFEFuncRElementWrappingImplementation.prototype;
function SVGFEFuncRElementWrappingImplementation() {}
// ********** Code for SVGFEGaussianBlurElementWrappingImplementation **************
$inherits(SVGFEGaussianBlurElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEGaussianBlurElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEGaussianBlurElementWrappingImplementation._wrap$ctor.prototype = SVGFEGaussianBlurElementWrappingImplementation.prototype;
function SVGFEGaussianBlurElementWrappingImplementation() {}
SVGFEGaussianBlurElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEGaussianBlurElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEGaussianBlurElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEGaussianBlurElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEImageElementWrappingImplementation **************
$inherits(SVGFEImageElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEImageElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEImageElementWrappingImplementation._wrap$ctor.prototype = SVGFEImageElementWrappingImplementation.prototype;
function SVGFEImageElementWrappingImplementation() {}
SVGFEImageElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEImageElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEImageElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEImageElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEMergeElementWrappingImplementation **************
$inherits(SVGFEMergeElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEMergeElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEMergeElementWrappingImplementation._wrap$ctor.prototype = SVGFEMergeElementWrappingImplementation.prototype;
function SVGFEMergeElementWrappingImplementation() {}
SVGFEMergeElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEMergeElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEMergeElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEMergeElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEMergeNodeElementWrappingImplementation **************
$inherits(SVGFEMergeNodeElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEMergeNodeElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEMergeNodeElementWrappingImplementation._wrap$ctor.prototype = SVGFEMergeNodeElementWrappingImplementation.prototype;
function SVGFEMergeNodeElementWrappingImplementation() {}
// ********** Code for SVGFEOffsetElementWrappingImplementation **************
$inherits(SVGFEOffsetElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEOffsetElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEOffsetElementWrappingImplementation._wrap$ctor.prototype = SVGFEOffsetElementWrappingImplementation.prototype;
function SVGFEOffsetElementWrappingImplementation() {}
SVGFEOffsetElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFEOffsetElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFEOffsetElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFEOffsetElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFEPointLightElementWrappingImplementation **************
$inherits(SVGFEPointLightElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFEPointLightElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFEPointLightElementWrappingImplementation._wrap$ctor.prototype = SVGFEPointLightElementWrappingImplementation.prototype;
function SVGFEPointLightElementWrappingImplementation() {}
SVGFEPointLightElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$x());
}
SVGFEPointLightElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$y());
}
SVGFEPointLightElementWrappingImplementation.prototype.get$z = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$z());
}
// ********** Code for SVGFESpecularLightingElementWrappingImplementation **************
$inherits(SVGFESpecularLightingElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFESpecularLightingElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFESpecularLightingElementWrappingImplementation._wrap$ctor.prototype = SVGFESpecularLightingElementWrappingImplementation.prototype;
function SVGFESpecularLightingElementWrappingImplementation() {}
SVGFESpecularLightingElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFESpecularLightingElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFESpecularLightingElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFESpecularLightingElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFESpotLightElementWrappingImplementation **************
$inherits(SVGFESpotLightElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFESpotLightElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFESpotLightElementWrappingImplementation._wrap$ctor.prototype = SVGFESpotLightElementWrappingImplementation.prototype;
function SVGFESpotLightElementWrappingImplementation() {}
SVGFESpotLightElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$x());
}
SVGFESpotLightElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$y());
}
SVGFESpotLightElementWrappingImplementation.prototype.get$z = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$z());
}
// ********** Code for SVGFETileElementWrappingImplementation **************
$inherits(SVGFETileElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFETileElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFETileElementWrappingImplementation._wrap$ctor.prototype = SVGFETileElementWrappingImplementation.prototype;
function SVGFETileElementWrappingImplementation() {}
SVGFETileElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFETileElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFETileElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFETileElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFETurbulenceElementWrappingImplementation **************
$inherits(SVGFETurbulenceElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFETurbulenceElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFETurbulenceElementWrappingImplementation._wrap$ctor.prototype = SVGFETurbulenceElementWrappingImplementation.prototype;
function SVGFETurbulenceElementWrappingImplementation() {}
SVGFETurbulenceElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFETurbulenceElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFETurbulenceElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFETurbulenceElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFilterElementWrappingImplementation **************
$inherits(SVGFilterElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFilterElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFilterElementWrappingImplementation._wrap$ctor.prototype = SVGFilterElementWrappingImplementation.prototype;
function SVGFilterElementWrappingImplementation() {}
SVGFilterElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGFilterElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGFilterElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGFilterElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGFontElementWrappingImplementation **************
$inherits(SVGFontElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFontElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFontElementWrappingImplementation._wrap$ctor.prototype = SVGFontElementWrappingImplementation.prototype;
function SVGFontElementWrappingImplementation() {}
// ********** Code for SVGFontFaceElementWrappingImplementation **************
$inherits(SVGFontFaceElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFontFaceElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFontFaceElementWrappingImplementation._wrap$ctor.prototype = SVGFontFaceElementWrappingImplementation.prototype;
function SVGFontFaceElementWrappingImplementation() {}
// ********** Code for SVGFontFaceFormatElementWrappingImplementation **************
$inherits(SVGFontFaceFormatElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFontFaceFormatElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFontFaceFormatElementWrappingImplementation._wrap$ctor.prototype = SVGFontFaceFormatElementWrappingImplementation.prototype;
function SVGFontFaceFormatElementWrappingImplementation() {}
// ********** Code for SVGFontFaceNameElementWrappingImplementation **************
$inherits(SVGFontFaceNameElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFontFaceNameElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFontFaceNameElementWrappingImplementation._wrap$ctor.prototype = SVGFontFaceNameElementWrappingImplementation.prototype;
function SVGFontFaceNameElementWrappingImplementation() {}
// ********** Code for SVGFontFaceSrcElementWrappingImplementation **************
$inherits(SVGFontFaceSrcElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFontFaceSrcElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFontFaceSrcElementWrappingImplementation._wrap$ctor.prototype = SVGFontFaceSrcElementWrappingImplementation.prototype;
function SVGFontFaceSrcElementWrappingImplementation() {}
// ********** Code for SVGFontFaceUriElementWrappingImplementation **************
$inherits(SVGFontFaceUriElementWrappingImplementation, SVGElementWrappingImplementation);
SVGFontFaceUriElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGFontFaceUriElementWrappingImplementation._wrap$ctor.prototype = SVGFontFaceUriElementWrappingImplementation.prototype;
function SVGFontFaceUriElementWrappingImplementation() {}
// ********** Code for SVGForeignObjectElementWrappingImplementation **************
$inherits(SVGForeignObjectElementWrappingImplementation, SVGElementWrappingImplementation);
SVGForeignObjectElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGForeignObjectElementWrappingImplementation._wrap$ctor.prototype = SVGForeignObjectElementWrappingImplementation.prototype;
function SVGForeignObjectElementWrappingImplementation() {}
SVGForeignObjectElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGForeignObjectElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGForeignObjectElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGForeignObjectElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGGElementWrappingImplementation **************
$inherits(SVGGElementWrappingImplementation, SVGElementWrappingImplementation);
SVGGElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGGElementWrappingImplementation._wrap$ctor.prototype = SVGGElementWrappingImplementation.prototype;
function SVGGElementWrappingImplementation() {}
// ********** Code for SVGGlyphElementWrappingImplementation **************
$inherits(SVGGlyphElementWrappingImplementation, SVGElementWrappingImplementation);
SVGGlyphElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGGlyphElementWrappingImplementation._wrap$ctor.prototype = SVGGlyphElementWrappingImplementation.prototype;
function SVGGlyphElementWrappingImplementation() {}
// ********** Code for SVGGlyphRefElementWrappingImplementation **************
$inherits(SVGGlyphRefElementWrappingImplementation, SVGElementWrappingImplementation);
SVGGlyphRefElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGGlyphRefElementWrappingImplementation._wrap$ctor.prototype = SVGGlyphRefElementWrappingImplementation.prototype;
function SVGGlyphRefElementWrappingImplementation() {}
SVGGlyphRefElementWrappingImplementation.prototype.get$x = function() {
  return this._ptr.get$x();
}
SVGGlyphRefElementWrappingImplementation.prototype.get$y = function() {
  return this._ptr.get$y();
}
// ********** Code for SVGGradientElementWrappingImplementation **************
$inherits(SVGGradientElementWrappingImplementation, SVGElementWrappingImplementation);
SVGGradientElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGGradientElementWrappingImplementation._wrap$ctor.prototype = SVGGradientElementWrappingImplementation.prototype;
function SVGGradientElementWrappingImplementation() {}
// ********** Code for SVGHKernElementWrappingImplementation **************
$inherits(SVGHKernElementWrappingImplementation, SVGElementWrappingImplementation);
SVGHKernElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGHKernElementWrappingImplementation._wrap$ctor.prototype = SVGHKernElementWrappingImplementation.prototype;
function SVGHKernElementWrappingImplementation() {}
// ********** Code for SVGImageElementWrappingImplementation **************
$inherits(SVGImageElementWrappingImplementation, SVGElementWrappingImplementation);
SVGImageElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGImageElementWrappingImplementation._wrap$ctor.prototype = SVGImageElementWrappingImplementation.prototype;
function SVGImageElementWrappingImplementation() {}
SVGImageElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGImageElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGImageElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGImageElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGLineElementWrappingImplementation **************
$inherits(SVGLineElementWrappingImplementation, SVGElementWrappingImplementation);
SVGLineElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGLineElementWrappingImplementation._wrap$ctor.prototype = SVGLineElementWrappingImplementation.prototype;
function SVGLineElementWrappingImplementation() {}
// ********** Code for SVGLinearGradientElementWrappingImplementation **************
$inherits(SVGLinearGradientElementWrappingImplementation, SVGGradientElementWrappingImplementation);
SVGLinearGradientElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGGradientElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGLinearGradientElementWrappingImplementation._wrap$ctor.prototype = SVGLinearGradientElementWrappingImplementation.prototype;
function SVGLinearGradientElementWrappingImplementation() {}
// ********** Code for SVGMPathElementWrappingImplementation **************
$inherits(SVGMPathElementWrappingImplementation, SVGElementWrappingImplementation);
SVGMPathElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGMPathElementWrappingImplementation._wrap$ctor.prototype = SVGMPathElementWrappingImplementation.prototype;
function SVGMPathElementWrappingImplementation() {}
// ********** Code for SVGMarkerElementWrappingImplementation **************
$inherits(SVGMarkerElementWrappingImplementation, SVGElementWrappingImplementation);
SVGMarkerElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGMarkerElementWrappingImplementation._wrap$ctor.prototype = SVGMarkerElementWrappingImplementation.prototype;
function SVGMarkerElementWrappingImplementation() {}
// ********** Code for SVGMaskElementWrappingImplementation **************
$inherits(SVGMaskElementWrappingImplementation, SVGElementWrappingImplementation);
SVGMaskElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGMaskElementWrappingImplementation._wrap$ctor.prototype = SVGMaskElementWrappingImplementation.prototype;
function SVGMaskElementWrappingImplementation() {}
SVGMaskElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGMaskElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGMaskElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGMaskElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGMetadataElementWrappingImplementation **************
$inherits(SVGMetadataElementWrappingImplementation, SVGElementWrappingImplementation);
SVGMetadataElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGMetadataElementWrappingImplementation._wrap$ctor.prototype = SVGMetadataElementWrappingImplementation.prototype;
function SVGMetadataElementWrappingImplementation() {}
// ********** Code for SVGMissingGlyphElementWrappingImplementation **************
$inherits(SVGMissingGlyphElementWrappingImplementation, SVGElementWrappingImplementation);
SVGMissingGlyphElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGMissingGlyphElementWrappingImplementation._wrap$ctor.prototype = SVGMissingGlyphElementWrappingImplementation.prototype;
function SVGMissingGlyphElementWrappingImplementation() {}
// ********** Code for SVGPathElementWrappingImplementation **************
$inherits(SVGPathElementWrappingImplementation, SVGElementWrappingImplementation);
SVGPathElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGPathElementWrappingImplementation._wrap$ctor.prototype = SVGPathElementWrappingImplementation.prototype;
function SVGPathElementWrappingImplementation() {}
// ********** Code for SVGPatternElementWrappingImplementation **************
$inherits(SVGPatternElementWrappingImplementation, SVGElementWrappingImplementation);
SVGPatternElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGPatternElementWrappingImplementation._wrap$ctor.prototype = SVGPatternElementWrappingImplementation.prototype;
function SVGPatternElementWrappingImplementation() {}
SVGPatternElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGPatternElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGPatternElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGPatternElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGPolygonElementWrappingImplementation **************
$inherits(SVGPolygonElementWrappingImplementation, SVGElementWrappingImplementation);
SVGPolygonElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGPolygonElementWrappingImplementation._wrap$ctor.prototype = SVGPolygonElementWrappingImplementation.prototype;
function SVGPolygonElementWrappingImplementation() {}
// ********** Code for SVGPolylineElementWrappingImplementation **************
$inherits(SVGPolylineElementWrappingImplementation, SVGElementWrappingImplementation);
SVGPolylineElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGPolylineElementWrappingImplementation._wrap$ctor.prototype = SVGPolylineElementWrappingImplementation.prototype;
function SVGPolylineElementWrappingImplementation() {}
// ********** Code for SVGRadialGradientElementWrappingImplementation **************
$inherits(SVGRadialGradientElementWrappingImplementation, SVGGradientElementWrappingImplementation);
SVGRadialGradientElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGGradientElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGRadialGradientElementWrappingImplementation._wrap$ctor.prototype = SVGRadialGradientElementWrappingImplementation.prototype;
function SVGRadialGradientElementWrappingImplementation() {}
// ********** Code for SVGRectElementWrappingImplementation **************
$inherits(SVGRectElementWrappingImplementation, SVGElementWrappingImplementation);
SVGRectElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGRectElementWrappingImplementation._wrap$ctor.prototype = SVGRectElementWrappingImplementation.prototype;
function SVGRectElementWrappingImplementation() {}
SVGRectElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGRectElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGRectElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGRectElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGScriptElementWrappingImplementation **************
$inherits(SVGScriptElementWrappingImplementation, SVGElementWrappingImplementation);
SVGScriptElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGScriptElementWrappingImplementation._wrap$ctor.prototype = SVGScriptElementWrappingImplementation.prototype;
function SVGScriptElementWrappingImplementation() {}
// ********** Code for SVGSetElementWrappingImplementation **************
$inherits(SVGSetElementWrappingImplementation, SVGAnimationElementWrappingImplementation);
SVGSetElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGAnimationElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGSetElementWrappingImplementation._wrap$ctor.prototype = SVGSetElementWrappingImplementation.prototype;
function SVGSetElementWrappingImplementation() {}
// ********** Code for SVGStopElementWrappingImplementation **************
$inherits(SVGStopElementWrappingImplementation, SVGElementWrappingImplementation);
SVGStopElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGStopElementWrappingImplementation._wrap$ctor.prototype = SVGStopElementWrappingImplementation.prototype;
function SVGStopElementWrappingImplementation() {}
SVGStopElementWrappingImplementation.prototype.get$offset = function() {
  return LevelDom.wrapSVGAnimatedNumber(this._ptr.get$offset());
}
// ********** Code for SVGStyleElementWrappingImplementation **************
$inherits(SVGStyleElementWrappingImplementation, SVGElementWrappingImplementation);
SVGStyleElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGStyleElementWrappingImplementation._wrap$ctor.prototype = SVGStyleElementWrappingImplementation.prototype;
function SVGStyleElementWrappingImplementation() {}
// ********** Code for SVGSwitchElementWrappingImplementation **************
$inherits(SVGSwitchElementWrappingImplementation, SVGElementWrappingImplementation);
SVGSwitchElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGSwitchElementWrappingImplementation._wrap$ctor.prototype = SVGSwitchElementWrappingImplementation.prototype;
function SVGSwitchElementWrappingImplementation() {}
// ********** Code for SVGSymbolElementWrappingImplementation **************
$inherits(SVGSymbolElementWrappingImplementation, SVGElementWrappingImplementation);
SVGSymbolElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGSymbolElementWrappingImplementation._wrap$ctor.prototype = SVGSymbolElementWrappingImplementation.prototype;
function SVGSymbolElementWrappingImplementation() {}
// ********** Code for SVGTRefElementWrappingImplementation **************
$inherits(SVGTRefElementWrappingImplementation, SVGTextPositioningElementWrappingImplementation);
SVGTRefElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGTextPositioningElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTRefElementWrappingImplementation._wrap$ctor.prototype = SVGTRefElementWrappingImplementation.prototype;
function SVGTRefElementWrappingImplementation() {}
// ********** Code for SVGTSpanElementWrappingImplementation **************
$inherits(SVGTSpanElementWrappingImplementation, SVGTextPositioningElementWrappingImplementation);
SVGTSpanElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGTextPositioningElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTSpanElementWrappingImplementation._wrap$ctor.prototype = SVGTSpanElementWrappingImplementation.prototype;
function SVGTSpanElementWrappingImplementation() {}
// ********** Code for SVGTextElementWrappingImplementation **************
$inherits(SVGTextElementWrappingImplementation, SVGTextPositioningElementWrappingImplementation);
SVGTextElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGTextPositioningElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTextElementWrappingImplementation._wrap$ctor.prototype = SVGTextElementWrappingImplementation.prototype;
function SVGTextElementWrappingImplementation() {}
// ********** Code for SVGTextPathElementWrappingImplementation **************
$inherits(SVGTextPathElementWrappingImplementation, SVGTextContentElementWrappingImplementation);
SVGTextPathElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGTextContentElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTextPathElementWrappingImplementation._wrap$ctor.prototype = SVGTextPathElementWrappingImplementation.prototype;
function SVGTextPathElementWrappingImplementation() {}
// ********** Code for SVGTitleElementWrappingImplementation **************
$inherits(SVGTitleElementWrappingImplementation, SVGElementWrappingImplementation);
SVGTitleElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGTitleElementWrappingImplementation._wrap$ctor.prototype = SVGTitleElementWrappingImplementation.prototype;
function SVGTitleElementWrappingImplementation() {}
// ********** Code for SVGUseElementWrappingImplementation **************
$inherits(SVGUseElementWrappingImplementation, SVGElementWrappingImplementation);
SVGUseElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGUseElementWrappingImplementation._wrap$ctor.prototype = SVGUseElementWrappingImplementation.prototype;
function SVGUseElementWrappingImplementation() {}
SVGUseElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGUseElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGUseElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGUseElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for SVGVKernElementWrappingImplementation **************
$inherits(SVGVKernElementWrappingImplementation, SVGElementWrappingImplementation);
SVGVKernElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGVKernElementWrappingImplementation._wrap$ctor.prototype = SVGVKernElementWrappingImplementation.prototype;
function SVGVKernElementWrappingImplementation() {}
// ********** Code for SVGViewElementWrappingImplementation **************
$inherits(SVGViewElementWrappingImplementation, SVGElementWrappingImplementation);
SVGViewElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGViewElementWrappingImplementation._wrap$ctor.prototype = SVGViewElementWrappingImplementation.prototype;
function SVGViewElementWrappingImplementation() {}
// ********** Code for UIEventWrappingImplementation **************
$inherits(UIEventWrappingImplementation, EventWrappingImplementation);
UIEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
UIEventWrappingImplementation._wrap$ctor.prototype = UIEventWrappingImplementation.prototype;
function UIEventWrappingImplementation() {}
// ********** Code for SVGZoomEventWrappingImplementation **************
$inherits(SVGZoomEventWrappingImplementation, UIEventWrappingImplementation);
SVGZoomEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGZoomEventWrappingImplementation._wrap$ctor.prototype = SVGZoomEventWrappingImplementation.prototype;
function SVGZoomEventWrappingImplementation() {}
// ********** Code for ScriptElementWrappingImplementation **************
$inherits(ScriptElementWrappingImplementation, ElementWrappingImplementation);
ScriptElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ScriptElementWrappingImplementation._wrap$ctor.prototype = ScriptElementWrappingImplementation.prototype;
function ScriptElementWrappingImplementation() {}
// ********** Code for SelectElementWrappingImplementation **************
$inherits(SelectElementWrappingImplementation, ElementWrappingImplementation);
SelectElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SelectElementWrappingImplementation._wrap$ctor.prototype = SelectElementWrappingImplementation.prototype;
function SelectElementWrappingImplementation() {}
SelectElementWrappingImplementation.prototype.get$length = function() {
  return this._ptr.get$length();
}
SelectElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
SelectElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
SelectElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
SelectElementWrappingImplementation.prototype.item = function(index) {
  return LevelDom.wrapNode(this._ptr.item(index));
}
// ********** Code for SourceElementWrappingImplementation **************
$inherits(SourceElementWrappingImplementation, ElementWrappingImplementation);
SourceElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SourceElementWrappingImplementation._wrap$ctor.prototype = SourceElementWrappingImplementation.prototype;
function SourceElementWrappingImplementation() {}
// ********** Code for SpanElementWrappingImplementation **************
$inherits(SpanElementWrappingImplementation, ElementWrappingImplementation);
SpanElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SpanElementWrappingImplementation._wrap$ctor.prototype = SpanElementWrappingImplementation.prototype;
function SpanElementWrappingImplementation() {}
// ********** Code for SpeechInputEventWrappingImplementation **************
$inherits(SpeechInputEventWrappingImplementation, EventWrappingImplementation);
SpeechInputEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
SpeechInputEventWrappingImplementation._wrap$ctor.prototype = SpeechInputEventWrappingImplementation.prototype;
function SpeechInputEventWrappingImplementation() {}
// ********** Code for StyleElementWrappingImplementation **************
$inherits(StyleElementWrappingImplementation, ElementWrappingImplementation);
StyleElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
StyleElementWrappingImplementation._wrap$ctor.prototype = StyleElementWrappingImplementation.prototype;
function StyleElementWrappingImplementation() {}
// ********** Code for TableCaptionElementWrappingImplementation **************
$inherits(TableCaptionElementWrappingImplementation, ElementWrappingImplementation);
TableCaptionElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TableCaptionElementWrappingImplementation._wrap$ctor.prototype = TableCaptionElementWrappingImplementation.prototype;
function TableCaptionElementWrappingImplementation() {}
// ********** Code for TableCellElementWrappingImplementation **************
$inherits(TableCellElementWrappingImplementation, ElementWrappingImplementation);
TableCellElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TableCellElementWrappingImplementation._wrap$ctor.prototype = TableCellElementWrappingImplementation.prototype;
function TableCellElementWrappingImplementation() {}
TableCellElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
TableCellElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
TableCellElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
TableCellElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for TableColElementWrappingImplementation **************
$inherits(TableColElementWrappingImplementation, ElementWrappingImplementation);
TableColElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TableColElementWrappingImplementation._wrap$ctor.prototype = TableColElementWrappingImplementation.prototype;
function TableColElementWrappingImplementation() {}
TableColElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
TableColElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for TableElementWrappingImplementation **************
$inherits(TableElementWrappingImplementation, ElementWrappingImplementation);
TableElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TableElementWrappingImplementation._wrap$ctor.prototype = TableElementWrappingImplementation.prototype;
function TableElementWrappingImplementation() {}
TableElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
TableElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for TableRowElementWrappingImplementation **************
$inherits(TableRowElementWrappingImplementation, ElementWrappingImplementation);
TableRowElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TableRowElementWrappingImplementation._wrap$ctor.prototype = TableRowElementWrappingImplementation.prototype;
function TableRowElementWrappingImplementation() {}
// ********** Code for TableSectionElementWrappingImplementation **************
$inherits(TableSectionElementWrappingImplementation, ElementWrappingImplementation);
TableSectionElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TableSectionElementWrappingImplementation._wrap$ctor.prototype = TableSectionElementWrappingImplementation.prototype;
function TableSectionElementWrappingImplementation() {}
// ********** Code for TextAreaElementWrappingImplementation **************
$inherits(TextAreaElementWrappingImplementation, ElementWrappingImplementation);
TextAreaElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TextAreaElementWrappingImplementation._wrap$ctor.prototype = TextAreaElementWrappingImplementation.prototype;
function TextAreaElementWrappingImplementation() {}
TextAreaElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
TextAreaElementWrappingImplementation.prototype.get$value = function() {
  return this._ptr.get$value();
}
TextAreaElementWrappingImplementation.prototype.set$value = function(value) {
  this._ptr.set$value(value);
}
// ********** Code for TitleElementWrappingImplementation **************
$inherits(TitleElementWrappingImplementation, ElementWrappingImplementation);
TitleElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TitleElementWrappingImplementation._wrap$ctor.prototype = TitleElementWrappingImplementation.prototype;
function TitleElementWrappingImplementation() {}
// ********** Code for TrackElementWrappingImplementation **************
$inherits(TrackElementWrappingImplementation, ElementWrappingImplementation);
TrackElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
TrackElementWrappingImplementation._wrap$ctor.prototype = TrackElementWrappingImplementation.prototype;
function TrackElementWrappingImplementation() {}
// ********** Code for UListElementWrappingImplementation **************
$inherits(UListElementWrappingImplementation, ElementWrappingImplementation);
UListElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
UListElementWrappingImplementation._wrap$ctor.prototype = UListElementWrappingImplementation.prototype;
function UListElementWrappingImplementation() {}
// ********** Code for UnknownElementWrappingImplementation **************
$inherits(UnknownElementWrappingImplementation, ElementWrappingImplementation);
UnknownElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
UnknownElementWrappingImplementation._wrap$ctor.prototype = UnknownElementWrappingImplementation.prototype;
function UnknownElementWrappingImplementation() {}
// ********** Code for VideoElementWrappingImplementation **************
$inherits(VideoElementWrappingImplementation, MediaElementWrappingImplementation);
VideoElementWrappingImplementation._wrap$ctor = function(ptr) {
  MediaElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
VideoElementWrappingImplementation._wrap$ctor.prototype = VideoElementWrappingImplementation.prototype;
function VideoElementWrappingImplementation() {}
VideoElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
VideoElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
VideoElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
VideoElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for WebGLContextEventWrappingImplementation **************
$inherits(WebGLContextEventWrappingImplementation, EventWrappingImplementation);
WebGLContextEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
WebGLContextEventWrappingImplementation._wrap$ctor.prototype = WebGLContextEventWrappingImplementation.prototype;
function WebGLContextEventWrappingImplementation() {}
// ********** Code for WebGLRenderingContextWrappingImplementation **************
$inherits(WebGLRenderingContextWrappingImplementation, CanvasRenderingContextWrappingImplementation);
WebGLRenderingContextWrappingImplementation._wrap$ctor = function(ptr) {
  CanvasRenderingContextWrappingImplementation._wrap$ctor.call(this, ptr);
}
WebGLRenderingContextWrappingImplementation._wrap$ctor.prototype = WebGLRenderingContextWrappingImplementation.prototype;
function WebGLRenderingContextWrappingImplementation() {}
// ********** Code for LevelDom **************
function LevelDom() {}
LevelDom.wrapCanvasPattern = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new CanvasPatternWrappingImplementation._wrap$ctor(raw);
}
LevelDom.wrapCanvasPixelArray = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new CanvasPixelArrayWrappingImplementation._wrap$ctor(raw);
}
LevelDom.wrapCanvasRenderingContext = function(raw) {
  if (null == raw) {
    return null;
  }
  if (null != raw.get$dartObjectLocalStorage()) {
    return raw.get$dartObjectLocalStorage();
  }
  switch (raw.get$typeName()) {
    case "CanvasRenderingContext":

      return new CanvasRenderingContextWrappingImplementation._wrap$ctor(raw);

    case "CanvasRenderingContext2D":

      return new CanvasRenderingContext2DWrappingImplementation._wrap$ctor(raw);

    case "WebGLRenderingContext":

      return new WebGLRenderingContextWrappingImplementation._wrap$ctor(raw);

    default:

      $throw(new UnsupportedOperationException($add$("Unknown type:", raw.toString())));

  }
}
LevelDom.wrapDocument = function(raw) {
  if (null == raw) {
    return null;
  }
  if (null != raw.get$dartObjectLocalStorage()) {
    return raw.get$dartObjectLocalStorage();
  }
  switch (raw.get$typeName()) {
    case "Document":
    case "XMLDocument":

      return new XMLDocumentWrappingImplementation._wrap$ctor(raw, raw.get$documentElement());

    case "HTMLDocument":

      return new DocumentWrappingImplementation._wrap$ctor(raw, raw.get$documentElement());

    case "SVGDocument":

      return new SVGDocumentWrappingImplementation._wrap$ctor(raw);

    default:

      $throw(new UnsupportedOperationException($add$("Unknown type:", raw.toString())));

  }
}
LevelDom.wrapElement = function(raw) {
  if (null == raw) {
    return null;
  }
  if (null != raw.get$dartObjectLocalStorage()) {
    return raw.get$dartObjectLocalStorage();
  }
  switch (raw.get$typeName()) {
    case "Element":

      return new XMLElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLAnchorElement":

      return new AnchorElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLAreaElement":

      return new AreaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLAudioElement":

      return new AudioElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLBRElement":

      return new BRElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLBaseElement":

      return new BaseElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLBodyElement":

      return new BodyElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLButtonElement":

      return new ButtonElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLCanvasElement":

      return new CanvasElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDListElement":

      return new DListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDataListElement":

      return new DataListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDetailsElement":

      return new DetailsElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDivElement":

      return new DivElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLElement":

      return new ElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLEmbedElement":

      return new EmbedElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLFieldSetElement":

      return new FieldSetElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLFontElement":

      return new FontElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLFormElement":

      return new FormElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHRElement":

      return new HRElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHeadElement":

      return new HeadElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHeadingElement":

      return new HeadingElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHtmlElement":

      return new DocumentWrappingImplementation._wrap$ctor(raw.get$parentNode(), raw);

    case "HTMLIFrameElement":

      return new IFrameElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLImageElement":

      return new ImageElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLInputElement":

      return new InputElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLKeygenElement":

      return new KeygenElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLIElement":

      return new LIElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLabelElement":

      return new LabelElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLegendElement":

      return new LegendElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLinkElement":

      return new LinkElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMapElement":

      return new MapElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMarqueeElement":

      return new MarqueeElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMediaElement":

      return new MediaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMenuElement":

      return new MenuElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMetaElement":

      return new MetaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMeterElement":

      return new MeterElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLModElement":

      return new ModElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOListElement":

      return new OListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLObjectElement":

      return new ObjectElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOptGroupElement":

      return new OptGroupElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOptionElement":

      return new OptionElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOutputElement":

      return new OutputElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLParagraphElement":

      return new ParagraphElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLParamElement":

      return new ParamElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLPreElement":

      return new PreElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLProgressElement":

      return new ProgressElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLQuoteElement":

      return new QuoteElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAElement":

      return new SVGAElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAltGlyphDefElement":

      return new SVGAltGlyphDefElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAltGlyphElement":

      return new SVGAltGlyphElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAltGlyphItemElement":

      return new SVGAltGlyphItemElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateColorElement":

      return new SVGAnimateColorElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateElement":

      return new SVGAnimateElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateMotionElement":

      return new SVGAnimateMotionElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateTransformElement":

      return new SVGAnimateTransformElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimationElement":

      return new SVGAnimationElementWrappingImplementation._wrap$ctor(raw);

    case "SVGCircleElement":

      return new SVGCircleElementWrappingImplementation._wrap$ctor(raw);

    case "SVGClipPathElement":

      return new SVGClipPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGComponentTransferFunctionElement":

      return new SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor(raw);

    case "SVGCursorElement":

      return new SVGCursorElementWrappingImplementation._wrap$ctor(raw);

    case "SVGDefsElement":

      return new SVGDefsElementWrappingImplementation._wrap$ctor(raw);

    case "SVGDescElement":

      return new SVGDescElementWrappingImplementation._wrap$ctor(raw);

    case "SVGElement":

      return new SVGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGEllipseElement":

      return new SVGEllipseElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEBlendElement":

      return new SVGFEBlendElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEColorMatrixElement":

      return new SVGFEColorMatrixElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEComponentTransferElement":

      return new SVGFEComponentTransferElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEConvolveMatrixElement":

      return new SVGFEConvolveMatrixElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDiffuseLightingElement":

      return new SVGFEDiffuseLightingElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDisplacementMapElement":

      return new SVGFEDisplacementMapElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDistantLightElement":

      return new SVGFEDistantLightElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDropShadowElement":

      return new SVGFEDropShadowElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFloodElement":

      return new SVGFEFloodElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncAElement":

      return new SVGFEFuncAElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncBElement":

      return new SVGFEFuncBElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncGElement":

      return new SVGFEFuncGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncRElement":

      return new SVGFEFuncRElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEGaussianBlurElement":

      return new SVGFEGaussianBlurElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEImageElement":

      return new SVGFEImageElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEMergeElement":

      return new SVGFEMergeElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEMergeNodeElement":

      return new SVGFEMergeNodeElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEOffsetElement":

      return new SVGFEOffsetElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEPointLightElement":

      return new SVGFEPointLightElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFESpecularLightingElement":

      return new SVGFESpecularLightingElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFESpotLightElement":

      return new SVGFESpotLightElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFETileElement":

      return new SVGFETileElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFETurbulenceElement":

      return new SVGFETurbulenceElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFilterElement":

      return new SVGFilterElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontElement":

      return new SVGFontElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceElement":

      return new SVGFontFaceElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceFormatElement":

      return new SVGFontFaceFormatElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceNameElement":

      return new SVGFontFaceNameElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceSrcElement":

      return new SVGFontFaceSrcElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceUriElement":

      return new SVGFontFaceUriElementWrappingImplementation._wrap$ctor(raw);

    case "SVGForeignObjectElement":

      return new SVGForeignObjectElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGElement":

      return new SVGGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGlyphElement":

      return new SVGGlyphElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGlyphRefElement":

      return new SVGGlyphRefElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGradientElement":

      return new SVGGradientElementWrappingImplementation._wrap$ctor(raw);

    case "SVGHKernElement":

      return new SVGHKernElementWrappingImplementation._wrap$ctor(raw);

    case "SVGImageElement":

      return new SVGImageElementWrappingImplementation._wrap$ctor(raw);

    case "SVGLineElement":

      return new SVGLineElementWrappingImplementation._wrap$ctor(raw);

    case "SVGLinearGradientElement":

      return new SVGLinearGradientElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMPathElement":

      return new SVGMPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMarkerElement":

      return new SVGMarkerElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMaskElement":

      return new SVGMaskElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMetadataElement":

      return new SVGMetadataElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMissingGlyphElement":

      return new SVGMissingGlyphElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPathElement":

      return new SVGPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPatternElement":

      return new SVGPatternElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPolygonElement":

      return new SVGPolygonElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPolylineElement":

      return new SVGPolylineElementWrappingImplementation._wrap$ctor(raw);

    case "SVGRadialGradientElement":

      return new SVGRadialGradientElementWrappingImplementation._wrap$ctor(raw);

    case "SVGRectElement":

      return new SVGRectElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSVGElement":

      return new SVGSVGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGScriptElement":

      return new SVGScriptElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSetElement":

      return new SVGSetElementWrappingImplementation._wrap$ctor(raw);

    case "SVGStopElement":

      return new SVGStopElementWrappingImplementation._wrap$ctor(raw);

    case "SVGStyleElement":

      return new SVGStyleElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSwitchElement":

      return new SVGSwitchElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSymbolElement":

      return new SVGSymbolElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTRefElement":

      return new SVGTRefElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTSpanElement":

      return new SVGTSpanElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextContentElement":

      return new SVGTextContentElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextElement":

      return new SVGTextElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextPathElement":

      return new SVGTextPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextPositioningElement":

      return new SVGTextPositioningElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTitleElement":

      return new SVGTitleElementWrappingImplementation._wrap$ctor(raw);

    case "SVGUseElement":

      return new SVGUseElementWrappingImplementation._wrap$ctor(raw);

    case "SVGVKernElement":

      return new SVGVKernElementWrappingImplementation._wrap$ctor(raw);

    case "SVGViewElement":

      return new SVGViewElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLScriptElement":

      return new ScriptElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLSelectElement":

      return new SelectElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLSourceElement":

      return new SourceElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLSpanElement":

      return new SpanElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLStyleElement":

      return new StyleElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableCaptionElement":

      return new TableCaptionElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableCellElement":

      return new TableCellElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableColElement":

      return new TableColElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableElement":

      return new TableElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableRowElement":

      return new TableRowElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableSectionElement":

      return new TableSectionElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTextAreaElement":

      return new TextAreaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTitleElement":

      return new TitleElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTrackElement":

      return new TrackElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLUListElement":

      return new UListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLUnknownElement":

      return new UnknownElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLVideoElement":

      return new VideoElementWrappingImplementation._wrap$ctor(raw);

    default:

      $throw(new UnsupportedOperationException($add$("Unknown type:", raw.toString())));

  }
}
LevelDom.wrapEvent = function(raw) {
  if (null == raw) {
    return null;
  }
  if (null != raw.get$dartObjectLocalStorage()) {
    return raw.get$dartObjectLocalStorage();
  }
  switch (raw.get$typeName()) {
    case "WebKitAnimationEvent":

      return new AnimationEventWrappingImplementation._wrap$ctor(raw);

    case "AudioProcessingEvent":

      return new AudioProcessingEventWrappingImplementation._wrap$ctor(raw);

    case "BeforeLoadEvent":

      return new BeforeLoadEventWrappingImplementation._wrap$ctor(raw);

    case "CloseEvent":

      return new CloseEventWrappingImplementation._wrap$ctor(raw);

    case "CompositionEvent":

      return new CompositionEventWrappingImplementation._wrap$ctor(raw);

    case "CustomEvent":

      return new CustomEventWrappingImplementation._wrap$ctor(raw);

    case "DeviceMotionEvent":

      return new DeviceMotionEventWrappingImplementation._wrap$ctor(raw);

    case "DeviceOrientationEvent":

      return new DeviceOrientationEventWrappingImplementation._wrap$ctor(raw);

    case "ErrorEvent":

      return new ErrorEventWrappingImplementation._wrap$ctor(raw);

    case "Event":

      return new EventWrappingImplementation._wrap$ctor(raw);

    case "HashChangeEvent":

      return new HashChangeEventWrappingImplementation._wrap$ctor(raw);

    case "IDBVersionChangeEvent":

      return new IDBVersionChangeEventWrappingImplementation._wrap$ctor(raw);

    case "KeyboardEvent":

      return new KeyboardEventWrappingImplementation._wrap$ctor(raw);

    case "MessageEvent":

      return new MessageEventWrappingImplementation._wrap$ctor(raw);

    case "MouseEvent":

      return new MouseEventWrappingImplementation._wrap$ctor(raw);

    case "MutationEvent":

      return new MutationEventWrappingImplementation._wrap$ctor(raw);

    case "OfflineAudioCompletionEvent":

      return new OfflineAudioCompletionEventWrappingImplementation._wrap$ctor(raw);

    case "OverflowEvent":

      return new OverflowEventWrappingImplementation._wrap$ctor(raw);

    case "PageTransitionEvent":

      return new PageTransitionEventWrappingImplementation._wrap$ctor(raw);

    case "PopStateEvent":

      return new PopStateEventWrappingImplementation._wrap$ctor(raw);

    case "ProgressEvent":

      return new ProgressEventWrappingImplementation._wrap$ctor(raw);

    case "SVGZoomEvent":

      return new SVGZoomEventWrappingImplementation._wrap$ctor(raw);

    case "SpeechInputEvent":

      return new SpeechInputEventWrappingImplementation._wrap$ctor(raw);

    case "StorageEvent":

      return new StorageEventWrappingImplementation._wrap$ctor(raw);

    case "TextEvent":

      return new TextEventWrappingImplementation._wrap$ctor(raw);

    case "TouchEvent":

      return new TouchEventWrappingImplementation._wrap$ctor(raw);

    case "WebKitTransitionEvent":

      return new TransitionEventWrappingImplementation._wrap$ctor(raw);

    case "UIEvent":

      return new UIEventWrappingImplementation._wrap$ctor(raw);

    case "WebGLContextEvent":

      return new WebGLContextEventWrappingImplementation._wrap$ctor(raw);

    case "WheelEvent":

      return new WheelEventWrappingImplementation._wrap$ctor(raw);

    case "XMLHttpRequestProgressEvent":

      return new XMLHttpRequestProgressEventWrappingImplementation._wrap$ctor(raw);

    default:

      $throw(new UnsupportedOperationException($add$("Unknown type:", raw.toString())));

  }
}
LevelDom.wrapImageData = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new ImageDataWrappingImplementation._wrap$ctor(raw);
}
LevelDom.wrapNode = function(raw) {
  if (null == raw) {
    return null;
  }
  if (null != raw.get$dartObjectLocalStorage()) {
    return raw.get$dartObjectLocalStorage();
  }
  switch (raw.get$typeName()) {
    case "Element":

      return new XMLElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLAnchorElement":

      return new AnchorElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLAreaElement":

      return new AreaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLAudioElement":

      return new AudioElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLBRElement":

      return new BRElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLBaseElement":

      return new BaseElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLBodyElement":

      return new BodyElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLButtonElement":

      return new ButtonElementWrappingImplementation._wrap$ctor(raw);

    case "CDATASection":

      return new CDATASectionWrappingImplementation._wrap$ctor(raw);

    case "HTMLCanvasElement":

      return new CanvasElementWrappingImplementation._wrap$ctor(raw);

    case "CharacterData":

      return new CharacterDataWrappingImplementation._wrap$ctor(raw);

    case "Comment":

      return new CommentWrappingImplementation._wrap$ctor(raw);

    case "HTMLDListElement":

      return new DListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDataListElement":

      return new DataListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDetailsElement":

      return new DetailsElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDivElement":

      return new DivElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLDocument":

      return new DocumentWrappingImplementation._wrap$ctor(raw, raw.get$documentElement());

    case "DocumentFragment":

      return new DocumentFragmentWrappingImplementation._wrap$ctor(raw);

    case "HTMLElement":

      return new ElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLEmbedElement":

      return new EmbedElementWrappingImplementation._wrap$ctor(raw);

    case "Entity":

      return new EntityWrappingImplementation._wrap$ctor(raw);

    case "EntityReference":

      return new EntityReferenceWrappingImplementation._wrap$ctor(raw);

    case "HTMLFieldSetElement":

      return new FieldSetElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLFontElement":

      return new FontElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLFormElement":

      return new FormElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHRElement":

      return new HRElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHeadElement":

      return new HeadElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHeadingElement":

      return new HeadingElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLHtmlElement":

      return new DocumentWrappingImplementation._wrap$ctor(raw.get$parentNode(), raw);

    case "HTMLIFrameElement":

      return new IFrameElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLImageElement":

      return new ImageElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLInputElement":

      return new InputElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLKeygenElement":

      return new KeygenElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLIElement":

      return new LIElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLabelElement":

      return new LabelElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLegendElement":

      return new LegendElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLLinkElement":

      return new LinkElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMapElement":

      return new MapElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMarqueeElement":

      return new MarqueeElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMediaElement":

      return new MediaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMenuElement":

      return new MenuElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMetaElement":

      return new MetaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLMeterElement":

      return new MeterElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLModElement":

      return new ModElementWrappingImplementation._wrap$ctor(raw);

    case "Node":

      return new NodeWrappingImplementation._wrap$ctor(raw);

    case "Notation":

      return new NotationWrappingImplementation._wrap$ctor(raw);

    case "HTMLOListElement":

      return new OListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLObjectElement":

      return new ObjectElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOptGroupElement":

      return new OptGroupElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOptionElement":

      return new OptionElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLOutputElement":

      return new OutputElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLParagraphElement":

      return new ParagraphElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLParamElement":

      return new ParamElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLPreElement":

      return new PreElementWrappingImplementation._wrap$ctor(raw);

    case "ProcessingInstruction":

      return new ProcessingInstructionWrappingImplementation._wrap$ctor(raw);

    case "HTMLProgressElement":

      return new ProgressElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLQuoteElement":

      return new QuoteElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAElement":

      return new SVGAElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAltGlyphDefElement":

      return new SVGAltGlyphDefElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAltGlyphElement":

      return new SVGAltGlyphElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAltGlyphItemElement":

      return new SVGAltGlyphItemElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateColorElement":

      return new SVGAnimateColorElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateElement":

      return new SVGAnimateElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateMotionElement":

      return new SVGAnimateMotionElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimateTransformElement":

      return new SVGAnimateTransformElementWrappingImplementation._wrap$ctor(raw);

    case "SVGAnimationElement":

      return new SVGAnimationElementWrappingImplementation._wrap$ctor(raw);

    case "SVGCircleElement":

      return new SVGCircleElementWrappingImplementation._wrap$ctor(raw);

    case "SVGClipPathElement":

      return new SVGClipPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGComponentTransferFunctionElement":

      return new SVGComponentTransferFunctionElementWrappingImplementation._wrap$ctor(raw);

    case "SVGCursorElement":

      return new SVGCursorElementWrappingImplementation._wrap$ctor(raw);

    case "SVGDefsElement":

      return new SVGDefsElementWrappingImplementation._wrap$ctor(raw);

    case "SVGDescElement":

      return new SVGDescElementWrappingImplementation._wrap$ctor(raw);

    case "SVGDocument":

      return new SVGDocumentWrappingImplementation._wrap$ctor(raw);

    case "SVGElement":

      return new SVGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGEllipseElement":

      return new SVGEllipseElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEBlendElement":

      return new SVGFEBlendElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEColorMatrixElement":

      return new SVGFEColorMatrixElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEComponentTransferElement":

      return new SVGFEComponentTransferElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEConvolveMatrixElement":

      return new SVGFEConvolveMatrixElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDiffuseLightingElement":

      return new SVGFEDiffuseLightingElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDisplacementMapElement":

      return new SVGFEDisplacementMapElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDistantLightElement":

      return new SVGFEDistantLightElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEDropShadowElement":

      return new SVGFEDropShadowElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFloodElement":

      return new SVGFEFloodElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncAElement":

      return new SVGFEFuncAElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncBElement":

      return new SVGFEFuncBElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncGElement":

      return new SVGFEFuncGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEFuncRElement":

      return new SVGFEFuncRElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEGaussianBlurElement":

      return new SVGFEGaussianBlurElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEImageElement":

      return new SVGFEImageElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEMergeElement":

      return new SVGFEMergeElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEMergeNodeElement":

      return new SVGFEMergeNodeElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEOffsetElement":

      return new SVGFEOffsetElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFEPointLightElement":

      return new SVGFEPointLightElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFESpecularLightingElement":

      return new SVGFESpecularLightingElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFESpotLightElement":

      return new SVGFESpotLightElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFETileElement":

      return new SVGFETileElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFETurbulenceElement":

      return new SVGFETurbulenceElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFilterElement":

      return new SVGFilterElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontElement":

      return new SVGFontElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceElement":

      return new SVGFontFaceElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceFormatElement":

      return new SVGFontFaceFormatElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceNameElement":

      return new SVGFontFaceNameElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceSrcElement":

      return new SVGFontFaceSrcElementWrappingImplementation._wrap$ctor(raw);

    case "SVGFontFaceUriElement":

      return new SVGFontFaceUriElementWrappingImplementation._wrap$ctor(raw);

    case "SVGForeignObjectElement":

      return new SVGForeignObjectElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGElement":

      return new SVGGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGlyphElement":

      return new SVGGlyphElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGlyphRefElement":

      return new SVGGlyphRefElementWrappingImplementation._wrap$ctor(raw);

    case "SVGGradientElement":

      return new SVGGradientElementWrappingImplementation._wrap$ctor(raw);

    case "SVGHKernElement":

      return new SVGHKernElementWrappingImplementation._wrap$ctor(raw);

    case "SVGImageElement":

      return new SVGImageElementWrappingImplementation._wrap$ctor(raw);

    case "SVGLineElement":

      return new SVGLineElementWrappingImplementation._wrap$ctor(raw);

    case "SVGLinearGradientElement":

      return new SVGLinearGradientElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMPathElement":

      return new SVGMPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMarkerElement":

      return new SVGMarkerElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMaskElement":

      return new SVGMaskElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMetadataElement":

      return new SVGMetadataElementWrappingImplementation._wrap$ctor(raw);

    case "SVGMissingGlyphElement":

      return new SVGMissingGlyphElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPathElement":

      return new SVGPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPatternElement":

      return new SVGPatternElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPolygonElement":

      return new SVGPolygonElementWrappingImplementation._wrap$ctor(raw);

    case "SVGPolylineElement":

      return new SVGPolylineElementWrappingImplementation._wrap$ctor(raw);

    case "SVGRadialGradientElement":

      return new SVGRadialGradientElementWrappingImplementation._wrap$ctor(raw);

    case "SVGRectElement":

      return new SVGRectElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSVGElement":

      return new SVGSVGElementWrappingImplementation._wrap$ctor(raw);

    case "SVGScriptElement":

      return new SVGScriptElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSetElement":

      return new SVGSetElementWrappingImplementation._wrap$ctor(raw);

    case "SVGStopElement":

      return new SVGStopElementWrappingImplementation._wrap$ctor(raw);

    case "SVGStyleElement":

      return new SVGStyleElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSwitchElement":

      return new SVGSwitchElementWrappingImplementation._wrap$ctor(raw);

    case "SVGSymbolElement":

      return new SVGSymbolElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTRefElement":

      return new SVGTRefElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTSpanElement":

      return new SVGTSpanElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextContentElement":

      return new SVGTextContentElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextElement":

      return new SVGTextElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextPathElement":

      return new SVGTextPathElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTextPositioningElement":

      return new SVGTextPositioningElementWrappingImplementation._wrap$ctor(raw);

    case "SVGTitleElement":

      return new SVGTitleElementWrappingImplementation._wrap$ctor(raw);

    case "SVGUseElement":

      return new SVGUseElementWrappingImplementation._wrap$ctor(raw);

    case "SVGVKernElement":

      return new SVGVKernElementWrappingImplementation._wrap$ctor(raw);

    case "SVGViewElement":

      return new SVGViewElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLScriptElement":

      return new ScriptElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLSelectElement":

      return new SelectElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLSourceElement":

      return new SourceElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLSpanElement":

      return new SpanElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLStyleElement":

      return new StyleElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableCaptionElement":

      return new TableCaptionElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableCellElement":

      return new TableCellElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableColElement":

      return new TableColElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableElement":

      return new TableElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableRowElement":

      return new TableRowElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTableSectionElement":

      return new TableSectionElementWrappingImplementation._wrap$ctor(raw);

    case "Text":

      return new TextWrappingImplementation._wrap$ctor(raw);

    case "HTMLTextAreaElement":

      return new TextAreaElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTitleElement":

      return new TitleElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLTrackElement":

      return new TrackElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLUListElement":

      return new UListElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLUnknownElement":

      return new UnknownElementWrappingImplementation._wrap$ctor(raw);

    case "HTMLVideoElement":

      return new VideoElementWrappingImplementation._wrap$ctor(raw);

    default:

      $throw(new UnsupportedOperationException($add$("Unknown type:", raw.toString())));

  }
}
LevelDom.wrapSVGAnimatedLength = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new SVGAnimatedLengthWrappingImplementation._wrap$ctor(raw);
}
LevelDom.wrapSVGAnimatedLengthList = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new SVGAnimatedLengthListWrappingImplementation._wrap$ctor(raw);
}
LevelDom.wrapSVGAnimatedNumber = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new SVGAnimatedNumberWrappingImplementation._wrap$ctor(raw);
}
LevelDom.wrapWindow = function(raw) {
  return null == raw ? null : null != raw.get$dartObjectLocalStorage() ? raw.get$dartObjectLocalStorage() : new WindowWrappingImplementation._wrap$ctor(raw);
}
LevelDom.unwrapMaybePrimitive = function(raw) {
  return (null == raw || (typeof(raw) == 'string') || (typeof(raw) == 'number') || (typeof(raw) == 'boolean')) ? raw : raw.get$_ptr();
}
LevelDom.unwrap = function(raw) {
  return null == raw ? null : raw.get$_ptr();
}
LevelDom.initialize = function() {
  $globals.secretWindow = LevelDom.wrapWindow(get$$window());
  $globals.secretDocument = LevelDom.wrapDocument(get$$document());
}
// ********** Code for _Collections **************
function _Collections() {}
_Collections.map = function(source, destination, f) {
  for (var $$i = source.iterator(); $$i.hasNext(); ) {
    var e = $$i.next();
    destination.add(f(e));
  }
  return destination;
}
// ********** Code for _VariableSizeListIterator **************
function _VariableSizeListIterator() {}
_VariableSizeListIterator.prototype.hasNext = function() {
  return this._htmlimpl_list.get$length() > this._htmlimpl_pos;
}
_VariableSizeListIterator.prototype.next = function() {
  if (!this.hasNext()) {
    $throw(const$0001);
  }
  return this._htmlimpl_list.$index(this._htmlimpl_pos++);
}
// ********** Code for _FixedSizeListIterator **************
$inherits(_FixedSizeListIterator, _VariableSizeListIterator);
function _FixedSizeListIterator() {}
_FixedSizeListIterator.prototype.hasNext = function() {
  return this._htmlimpl_length > this._htmlimpl_pos;
}
// ********** Code for _VariableSizeListIterator_int **************
$inherits(_VariableSizeListIterator_int, _VariableSizeListIterator);
function _VariableSizeListIterator_int(list) {
  this._htmlimpl_list = list;
  this._htmlimpl_pos = (0);
}
// ********** Code for _FixedSizeListIterator_int **************
$inherits(_FixedSizeListIterator_int, _FixedSizeListIterator);
function _FixedSizeListIterator_int(list) {
  this._htmlimpl_length = list.get$length();
  _VariableSizeListIterator_int.call(this, list);
}
// ********** Code for Lists **************
function Lists() {}
Lists.indexOf = function(a, element, startIndex, endIndex) {
  if (startIndex >= a.get$length()) {
    return (-1);
  }
  if (startIndex < (0)) {
    startIndex = (0);
  }
  for (var i = startIndex;
   i < endIndex; i++) {
    if ($eq$(a.$index(i), element)) {
      return i;
    }
  }
  return (-1);
}
Lists.removeRange = function(a, start, length, removeOne) {
  if (start < (0)) {
    $throw(new IndexOutOfRangeException(start));
  }
  else if (length < (0)) {
    $throw(new IllegalArgumentException(("negative length " + length)));
  }
  else if (start + length > a.get$length()) {
    $throw(new IndexOutOfRangeException(Math.min(a.get$length(), start)));
  }
  for (var i = (0);
   $lt$(i, length); i = $add$(i, (1))) {
    removeOne(start);
  }
}
// ********** Code for AnimationEventWrappingImplementation **************
$inherits(AnimationEventWrappingImplementation, EventWrappingImplementation);
AnimationEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
AnimationEventWrappingImplementation._wrap$ctor.prototype = AnimationEventWrappingImplementation.prototype;
function AnimationEventWrappingImplementation() {}
// ********** Code for BeforeLoadEventWrappingImplementation **************
$inherits(BeforeLoadEventWrappingImplementation, EventWrappingImplementation);
BeforeLoadEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
BeforeLoadEventWrappingImplementation._wrap$ctor.prototype = BeforeLoadEventWrappingImplementation.prototype;
function BeforeLoadEventWrappingImplementation() {}
// ********** Code for BodyElementWrappingImplementation **************
$inherits(BodyElementWrappingImplementation, ElementWrappingImplementation);
BodyElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
BodyElementWrappingImplementation._wrap$ctor.prototype = BodyElementWrappingImplementation.prototype;
function BodyElementWrappingImplementation() {}
// ********** Code for CloseEventWrappingImplementation **************
$inherits(CloseEventWrappingImplementation, EventWrappingImplementation);
CloseEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
CloseEventWrappingImplementation._wrap$ctor.prototype = CloseEventWrappingImplementation.prototype;
function CloseEventWrappingImplementation() {}
// ********** Code for CompositionEventWrappingImplementation **************
$inherits(CompositionEventWrappingImplementation, UIEventWrappingImplementation);
CompositionEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
CompositionEventWrappingImplementation._wrap$ctor.prototype = CompositionEventWrappingImplementation.prototype;
function CompositionEventWrappingImplementation() {}
CompositionEventWrappingImplementation.prototype.get$data = function() {
  return this._ptr.get$data();
}
// ********** Code for CustomEventWrappingImplementation **************
$inherits(CustomEventWrappingImplementation, EventWrappingImplementation);
CustomEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
CustomEventWrappingImplementation._wrap$ctor.prototype = CustomEventWrappingImplementation.prototype;
function CustomEventWrappingImplementation() {}
// ********** Code for DeviceMotionEventWrappingImplementation **************
$inherits(DeviceMotionEventWrappingImplementation, EventWrappingImplementation);
DeviceMotionEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
DeviceMotionEventWrappingImplementation._wrap$ctor.prototype = DeviceMotionEventWrappingImplementation.prototype;
function DeviceMotionEventWrappingImplementation() {}
// ********** Code for DeviceOrientationEventWrappingImplementation **************
$inherits(DeviceOrientationEventWrappingImplementation, EventWrappingImplementation);
DeviceOrientationEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
DeviceOrientationEventWrappingImplementation._wrap$ctor.prototype = DeviceOrientationEventWrappingImplementation.prototype;
function DeviceOrientationEventWrappingImplementation() {}
// ********** Code for DocumentFragmentWrappingImplementation **************
$inherits(DocumentFragmentWrappingImplementation, NodeWrappingImplementation);
DocumentFragmentWrappingImplementation._wrap$ctor = function(ptr) {
  NodeWrappingImplementation._wrap$ctor.call(this, ptr);
}
DocumentFragmentWrappingImplementation._wrap$ctor.prototype = DocumentFragmentWrappingImplementation.prototype;
function DocumentFragmentWrappingImplementation() {}
DocumentFragmentWrappingImplementation.prototype.get$id = function() {
  return "";
}
DocumentFragmentWrappingImplementation.prototype.get$attributes = function() {
  return const$0014;
}
// ********** Code for EventsImplementation **************
EventsImplementation._wrap$ctor = function(_ptr) {
  this._ptr = _ptr;
  this._listenerMap = new HashMapImplementation();
}
EventsImplementation._wrap$ctor.prototype = EventsImplementation.prototype;
function EventsImplementation() {}
EventsImplementation.prototype.get$_ptr = function() { return this._ptr; };
EventsImplementation.prototype.$index = function(type) {
  return this._get(type.toLowerCase());
}
EventsImplementation.prototype._get = function(type) {
  var $this = this; // closure support
  return this._listenerMap.putIfAbsent(type, (function () {
    return new EventListenerListImplementation($this._ptr, type);
  })
  );
}
// ********** Code for ElementEventsImplementation **************
$inherits(ElementEventsImplementation, EventsImplementation);
ElementEventsImplementation._wrap$ctor = function(_ptr) {
  EventsImplementation._wrap$ctor.call(this, _ptr);
}
ElementEventsImplementation._wrap$ctor.prototype = ElementEventsImplementation.prototype;
function ElementEventsImplementation() {}
ElementEventsImplementation.prototype.get$mouseMove = function() {
  return this._get("mousemove");
}
// ********** Code for DocumentEventsImplementation **************
$inherits(DocumentEventsImplementation, ElementEventsImplementation);
DocumentEventsImplementation._wrap$ctor = function(_ptr) {
  ElementEventsImplementation._wrap$ctor.call(this, _ptr);
}
DocumentEventsImplementation._wrap$ctor.prototype = DocumentEventsImplementation.prototype;
function DocumentEventsImplementation() {}
// ********** Code for DocumentWrappingImplementation **************
$inherits(DocumentWrappingImplementation, ElementWrappingImplementation);
DocumentWrappingImplementation._wrap$ctor = function(_documentPtr, ptr) {
  this._documentPtr = _documentPtr;
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
  this._documentPtr.get$dynamic().set$dartObjectLocalStorage(this);
}
DocumentWrappingImplementation._wrap$ctor.prototype = DocumentWrappingImplementation.prototype;
function DocumentWrappingImplementation() {}
DocumentWrappingImplementation.prototype.get$body = function() {
  return LevelDom.wrapElement(this._documentPtr.get$body());
}
DocumentWrappingImplementation.prototype.get$on = function() {
  if (null == this._on) {
    this._on = new DocumentEventsImplementation._wrap$ctor(this._documentPtr);
  }
  return this._on;
}
// ********** Code for ElementAttributeMap **************
ElementAttributeMap._wrap$ctor = function(_element) {
  this._element = _element;
}
ElementAttributeMap._wrap$ctor.prototype = ElementAttributeMap.prototype;
function ElementAttributeMap() {}
ElementAttributeMap.prototype.is$Map = function(){return true};
ElementAttributeMap.prototype.containsKey = function(key) {
  return this._element.hasAttribute(key);
}
ElementAttributeMap.prototype.$index = function(key) {
  return this._element.getAttribute(key);
}
ElementAttributeMap.prototype.$setindex = function(key, value) {
  this._element.setAttribute(key, value);
}
ElementAttributeMap.prototype.forEach = function(f) {
  var attributes = this._element.get$attributes();
  for (var i = (0), len = attributes.get$length();
   i < len; i++) {
    var item = attributes.item(i);
    f(item.get$name(), item.get$value());
  }
}
ElementAttributeMap.prototype.get$length = function() {
  return this._element.get$attributes().get$length();
}
// ********** Code for ErrorEventWrappingImplementation **************
$inherits(ErrorEventWrappingImplementation, EventWrappingImplementation);
ErrorEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
ErrorEventWrappingImplementation._wrap$ctor.prototype = ErrorEventWrappingImplementation.prototype;
function ErrorEventWrappingImplementation() {}
// ********** Code for _EventListenerWrapper **************
function _EventListenerWrapper(raw, wrapped, useCapture) {
  this.wrapped = wrapped;
  this.useCapture = useCapture;
  this.raw = raw;
}
// ********** Code for EventListenerListImplementation **************
function EventListenerListImplementation(_ptr, _type) {
  this._ptr = _ptr;
  this._type = _type;
  this._wrappers = new Array();
}
EventListenerListImplementation.prototype.get$_ptr = function() { return this._ptr; };
EventListenerListImplementation.prototype.add = function(listener, useCapture) {
  this._add(listener, useCapture);
  return this;
}
EventListenerListImplementation.prototype._add = function(listener, useCapture) {
  this._ptr.addEventListener$3(this._type, this._findOrAddWrapper(listener, useCapture), useCapture);
}
EventListenerListImplementation.prototype._findOrAddWrapper = function(listener, useCapture) {
  var $0;
  if (null == this._wrappers) {
    this._wrappers = [];
  }
  else {
    var $$list = this._wrappers;
    for (var $$i = $$list.iterator(); $$i.hasNext(); ) {
      var wrapper = $$i.next();
      if ((($0 = wrapper.raw) == null ? null == (listener) : $0 === listener) && $eq$(wrapper.useCapture, useCapture)) {
        return wrapper.wrapped;
      }
    }
  }
  var wrapped = (function (e) {
    listener(LevelDom.wrapEvent(e));
  })
  ;
  this._wrappers.add(new _EventListenerWrapper(listener, wrapped, useCapture));
  return wrapped;
}
// ********** Code for HashChangeEventWrappingImplementation **************
$inherits(HashChangeEventWrappingImplementation, EventWrappingImplementation);
HashChangeEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
HashChangeEventWrappingImplementation._wrap$ctor.prototype = HashChangeEventWrappingImplementation.prototype;
function HashChangeEventWrappingImplementation() {}
// ********** Code for KeyboardEventWrappingImplementation **************
$inherits(KeyboardEventWrappingImplementation, UIEventWrappingImplementation);
KeyboardEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
KeyboardEventWrappingImplementation._wrap$ctor.prototype = KeyboardEventWrappingImplementation.prototype;
function KeyboardEventWrappingImplementation() {}
// ********** Code for MessageEventWrappingImplementation **************
$inherits(MessageEventWrappingImplementation, EventWrappingImplementation);
MessageEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
MessageEventWrappingImplementation._wrap$ctor.prototype = MessageEventWrappingImplementation.prototype;
function MessageEventWrappingImplementation() {}
MessageEventWrappingImplementation.prototype.get$data = function() {
  return this._ptr.get$data();
}
// ********** Code for MouseEventWrappingImplementation **************
$inherits(MouseEventWrappingImplementation, UIEventWrappingImplementation);
MouseEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
MouseEventWrappingImplementation._wrap$ctor.prototype = MouseEventWrappingImplementation.prototype;
function MouseEventWrappingImplementation() {}
MouseEventWrappingImplementation.prototype.get$clientX = function() {
  return this._ptr.get$clientX();
}
MouseEventWrappingImplementation.prototype.get$clientY = function() {
  return this._ptr.get$clientY();
}
MouseEventWrappingImplementation.prototype.get$x = function() {
  return this._ptr.get$x();
}
MouseEventWrappingImplementation.prototype.get$y = function() {
  return this._ptr.get$y();
}
// ********** Code for MutationEventWrappingImplementation **************
$inherits(MutationEventWrappingImplementation, EventWrappingImplementation);
MutationEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
MutationEventWrappingImplementation._wrap$ctor.prototype = MutationEventWrappingImplementation.prototype;
function MutationEventWrappingImplementation() {}
// ********** Code for _ChildrenNodeList **************
_ChildrenNodeList._wrap$ctor = function(node) {
  this._node = node;
  this._childNodes = node.get$childNodes();
}
_ChildrenNodeList._wrap$ctor.prototype = _ChildrenNodeList.prototype;
function _ChildrenNodeList() {}
_ChildrenNodeList.prototype.is$List = function(){return true};
_ChildrenNodeList.prototype.is$Collection = function(){return true};
_ChildrenNodeList.prototype._toList = function() {
  var output = new Array(this._childNodes.get$length());
  for (var i = (0), len = this._childNodes.get$length();
   i < len; i++) {
    output.$setindex(i, LevelDom.wrapNode(this._childNodes.$index(i)));
  }
  return output;
}
_ChildrenNodeList.prototype.map = function(f) {
  return this._toList().map$1(f);
}
_ChildrenNodeList.prototype.get$map = function() {
  return this.map.bind(this);
}
_ChildrenNodeList.prototype.get$length = function() {
  return this._childNodes.get$length();
}
_ChildrenNodeList.prototype.$index = function(index) {
  return LevelDom.wrapNode(this._childNodes.$index(index));
}
_ChildrenNodeList.prototype.$setindex = function(index, value) {
  this._node.replaceChild(LevelDom.unwrap(value), this._childNodes.$index(index));
}
_ChildrenNodeList.prototype.add = function(value) {
  this._node.appendChild(LevelDom.unwrap(value));
  return value;
}
_ChildrenNodeList.prototype.iterator = function() {
  return this._toList().iterator();
}
_ChildrenNodeList.prototype.addAll = function(collection) {
  for (var $$i = collection.iterator(); $$i.hasNext(); ) {
    var node = $$i.next();
    this._node.appendChild(LevelDom.unwrap(node));
  }
}
_ChildrenNodeList.prototype.sort = function(compare) {
  $throw(const$0012);
}
_ChildrenNodeList.prototype.removeRange = function(start, length) {
  var $this = this; // closure support
  return Lists.removeRange(this, start, length, (function (i) {
    return $this.$index(i).remove();
  })
  );
}
_ChildrenNodeList.prototype.indexOf = function(element, start) {
  return Lists.indexOf(this, element, start, this.get$length());
}
_ChildrenNodeList.prototype.clear = function() {
  this._node.set$textContent("");
}
_ChildrenNodeList.prototype.removeLast = function() {
  var last = this.last();
  if ($ne$(last)) {
    this._node.removeChild(LevelDom.unwrap(last));
  }
  return last;
}
_ChildrenNodeList.prototype.last = function() {
  return LevelDom.wrapNode(this._node.get$lastChild());
}
_ChildrenNodeList.prototype.indexOf$1 = function($0) {
  return this.indexOf($0, (0));
};
_ChildrenNodeList.prototype.map$1 = function($0) {
  return this.map(to$call$1($0));
};
_ChildrenNodeList.prototype.sort$1 = function($0) {
  return this.sort(to$call$2($0));
};
// ********** Code for _ListWrapper **************
function _ListWrapper() {}
_ListWrapper.prototype.is$List = function(){return true};
_ListWrapper.prototype.is$Collection = function(){return true};
_ListWrapper.prototype.iterator = function() {
  return this._list.iterator();
}
_ListWrapper.prototype.map = function(f) {
  return this._list.map$1(f);
}
_ListWrapper.prototype.get$map = function() {
  return this.map.bind(this);
}
_ListWrapper.prototype.get$length = function() {
  return this._list.get$length();
}
_ListWrapper.prototype.$index = function(index) {
  return this._list.$index(index);
}
_ListWrapper.prototype.$setindex = function(index, value) {
  this._list.$setindex(index, value);
}
_ListWrapper.prototype.add = function(value) {
  return this._list.add(value);
}
_ListWrapper.prototype.addAll = function(collection) {
  return this._list.addAll(collection);
}
_ListWrapper.prototype.sort = function(compare) {
  return this._list.sort$1(compare);
}
_ListWrapper.prototype.indexOf = function(element, start) {
  return this._list.indexOf(element, start);
}
_ListWrapper.prototype.clear = function() {
  return this._list.clear();
}
_ListWrapper.prototype.removeLast = function() {
  return this._list.removeLast();
}
_ListWrapper.prototype.removeRange = function(start, length) {
  return this._list.removeRange(start, length);
}
_ListWrapper.prototype.indexOf$1 = function($0) {
  return this.indexOf($0, (0));
};
_ListWrapper.prototype.map$1 = function($0) {
  return this.map(to$call$1($0));
};
_ListWrapper.prototype.sort$1 = function($0) {
  return this.sort(to$call$2($0));
};
// ********** Code for ObjectElementWrappingImplementation **************
$inherits(ObjectElementWrappingImplementation, ElementWrappingImplementation);
ObjectElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
ObjectElementWrappingImplementation._wrap$ctor.prototype = ObjectElementWrappingImplementation.prototype;
function ObjectElementWrappingImplementation() {}
ObjectElementWrappingImplementation.prototype.get$data = function() {
  return this._ptr.get$data();
}
ObjectElementWrappingImplementation.prototype.get$height = function() {
  return this._ptr.get$height();
}
ObjectElementWrappingImplementation.prototype.set$height = function(value) {
  this._ptr.set$height(value);
}
ObjectElementWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
ObjectElementWrappingImplementation.prototype.get$width = function() {
  return this._ptr.get$width();
}
ObjectElementWrappingImplementation.prototype.set$width = function(value) {
  this._ptr.set$width(value);
}
// ********** Code for OverflowEventWrappingImplementation **************
$inherits(OverflowEventWrappingImplementation, EventWrappingImplementation);
OverflowEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
OverflowEventWrappingImplementation._wrap$ctor.prototype = OverflowEventWrappingImplementation.prototype;
function OverflowEventWrappingImplementation() {}
// ********** Code for PageTransitionEventWrappingImplementation **************
$inherits(PageTransitionEventWrappingImplementation, EventWrappingImplementation);
PageTransitionEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
PageTransitionEventWrappingImplementation._wrap$ctor.prototype = PageTransitionEventWrappingImplementation.prototype;
function PageTransitionEventWrappingImplementation() {}
// ********** Code for PopStateEventWrappingImplementation **************
$inherits(PopStateEventWrappingImplementation, EventWrappingImplementation);
PopStateEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
PopStateEventWrappingImplementation._wrap$ctor.prototype = PopStateEventWrappingImplementation.prototype;
function PopStateEventWrappingImplementation() {}
// ********** Code for ProgressEventWrappingImplementation **************
$inherits(ProgressEventWrappingImplementation, EventWrappingImplementation);
ProgressEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
ProgressEventWrappingImplementation._wrap$ctor.prototype = ProgressEventWrappingImplementation.prototype;
function ProgressEventWrappingImplementation() {}
// ********** Code for StorageEventWrappingImplementation **************
$inherits(StorageEventWrappingImplementation, EventWrappingImplementation);
StorageEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
StorageEventWrappingImplementation._wrap$ctor.prototype = StorageEventWrappingImplementation.prototype;
function StorageEventWrappingImplementation() {}
// ********** Code for SVGDocumentWrappingImplementation **************
$inherits(SVGDocumentWrappingImplementation, DocumentWrappingImplementation);
SVGDocumentWrappingImplementation._wrap$ctor = function(ptr) {
  DocumentWrappingImplementation._wrap$ctor.call(this, ptr, ptr.rootElement);
}
SVGDocumentWrappingImplementation._wrap$ctor.prototype = SVGDocumentWrappingImplementation.prototype;
function SVGDocumentWrappingImplementation() {}
// ********** Code for SVGSVGElementWrappingImplementation **************
$inherits(SVGSVGElementWrappingImplementation, SVGElementWrappingImplementation);
SVGSVGElementWrappingImplementation._wrap$ctor = function(ptr) {
  SVGElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
SVGSVGElementWrappingImplementation._wrap$ctor.prototype = SVGSVGElementWrappingImplementation.prototype;
function SVGSVGElementWrappingImplementation() {}
SVGSVGElementWrappingImplementation.prototype.get$height = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$height());
}
SVGSVGElementWrappingImplementation.prototype.get$width = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$width());
}
SVGSVGElementWrappingImplementation.prototype.get$x = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$x());
}
SVGSVGElementWrappingImplementation.prototype.get$y = function() {
  return LevelDom.wrapSVGAnimatedLength(this._ptr.get$y());
}
// ********** Code for TextEventWrappingImplementation **************
$inherits(TextEventWrappingImplementation, UIEventWrappingImplementation);
TextEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
TextEventWrappingImplementation._wrap$ctor.prototype = TextEventWrappingImplementation.prototype;
function TextEventWrappingImplementation() {}
TextEventWrappingImplementation.prototype.get$data = function() {
  return this._ptr.get$data();
}
// ********** Code for TouchEventWrappingImplementation **************
$inherits(TouchEventWrappingImplementation, UIEventWrappingImplementation);
TouchEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
TouchEventWrappingImplementation._wrap$ctor.prototype = TouchEventWrappingImplementation.prototype;
function TouchEventWrappingImplementation() {}
// ********** Code for TransitionEventWrappingImplementation **************
$inherits(TransitionEventWrappingImplementation, EventWrappingImplementation);
TransitionEventWrappingImplementation._wrap$ctor = function(ptr) {
  EventWrappingImplementation._wrap$ctor.call(this, ptr);
}
TransitionEventWrappingImplementation._wrap$ctor.prototype = TransitionEventWrappingImplementation.prototype;
function TransitionEventWrappingImplementation() {}
// ********** Code for WheelEventWrappingImplementation **************
$inherits(WheelEventWrappingImplementation, UIEventWrappingImplementation);
WheelEventWrappingImplementation._wrap$ctor = function(ptr) {
  UIEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
WheelEventWrappingImplementation._wrap$ctor.prototype = WheelEventWrappingImplementation.prototype;
function WheelEventWrappingImplementation() {}
WheelEventWrappingImplementation.prototype.get$clientX = function() {
  return this._ptr.get$clientX();
}
WheelEventWrappingImplementation.prototype.get$clientY = function() {
  return this._ptr.get$clientY();
}
WheelEventWrappingImplementation.prototype.get$x = function() {
  return this._ptr.get$x();
}
WheelEventWrappingImplementation.prototype.get$y = function() {
  return this._ptr.get$y();
}
// ********** Code for WindowWrappingImplementation **************
$inherits(WindowWrappingImplementation, EventTargetWrappingImplementation);
WindowWrappingImplementation._wrap$ctor = function(ptr) {
  EventTargetWrappingImplementation._wrap$ctor.call(this, ptr);
}
WindowWrappingImplementation._wrap$ctor.prototype = WindowWrappingImplementation.prototype;
function WindowWrappingImplementation() {}
WindowWrappingImplementation.prototype.get$innerHeight = function() {
  return this._ptr.get$innerHeight();
}
WindowWrappingImplementation.prototype.get$innerWidth = function() {
  return this._ptr.get$innerWidth();
}
WindowWrappingImplementation.prototype.get$length = function() {
  return this._ptr.get$length();
}
WindowWrappingImplementation.prototype.get$name = function() {
  return this._ptr.get$name();
}
WindowWrappingImplementation.prototype.moveTo = function(x, y) {
  this._ptr.moveTo$2(x, y);
}
WindowWrappingImplementation.prototype.setInterval = function(handler, timeout) {
  return this._ptr.setInterval$2(handler, timeout);
}
WindowWrappingImplementation.prototype.moveTo$2 = WindowWrappingImplementation.prototype.moveTo;
WindowWrappingImplementation.prototype.setInterval$2 = function($0, $1) {
  return this.setInterval(to$call$0($0), $1);
};
// ********** Code for XMLDocumentWrappingImplementation **************
$inherits(XMLDocumentWrappingImplementation, DocumentWrappingImplementation);
XMLDocumentWrappingImplementation._wrap$ctor = function(documentPtr, ptr) {
  DocumentWrappingImplementation._wrap$ctor.call(this, documentPtr, ptr);
  ptr.set$dartObjectLocalStorage(null);
  this.documentEl = new XMLElementWrappingImplementation._wrap$ctor(ptr);
  ptr.set$dartObjectLocalStorage(this);
}
XMLDocumentWrappingImplementation._wrap$ctor.prototype = XMLDocumentWrappingImplementation.prototype;
function XMLDocumentWrappingImplementation() {}
XMLDocumentWrappingImplementation.prototype.get$id = function() {
  return this.documentEl.get$id();
}
// ********** Code for XMLElementWrappingImplementation **************
$inherits(XMLElementWrappingImplementation, ElementWrappingImplementation);
XMLElementWrappingImplementation._wrap$ctor = function(ptr) {
  ElementWrappingImplementation._wrap$ctor.call(this, ptr);
}
XMLElementWrappingImplementation._wrap$ctor.prototype = XMLElementWrappingImplementation.prototype;
function XMLElementWrappingImplementation() {}
XMLElementWrappingImplementation.prototype.get$id = function() {
  return this._attr("id", "");
}
XMLElementWrappingImplementation.prototype._attr = function(name, def) {
  return this.get$attributes().containsKey(name) ? this.get$attributes().$index(name) : def;
}
// ********** Code for XMLHttpRequestProgressEventWrappingImplementation **************
$inherits(XMLHttpRequestProgressEventWrappingImplementation, ProgressEventWrappingImplementation);
XMLHttpRequestProgressEventWrappingImplementation._wrap$ctor = function(ptr) {
  ProgressEventWrappingImplementation._wrap$ctor.call(this, ptr);
}
XMLHttpRequestProgressEventWrappingImplementation._wrap$ctor.prototype = XMLHttpRequestProgressEventWrappingImplementation.prototype;
function XMLHttpRequestProgressEventWrappingImplementation() {}
XMLHttpRequestProgressEventWrappingImplementation.prototype.get$position = function() {
  return this._ptr.get$position();
}
// ********** Code for top level **************
var _pendingRequests;
var _pendingMeasurementFrameCallbacks;
//  ********** Library html **************
// ********** Code for top level **************
var secretWindow;
var secretDocument;
function html_get$$window() {
  if (null == $globals.secretWindow) {
    LevelDom.initialize();
  }
  return $globals.secretWindow;
}
function html_get$$document() {
  if (null == $globals.secretWindow) {
    LevelDom.initialize();
  }
  return $globals.secretDocument;
}
//  ********** Library ThreeD **************
// ********** Code for Three **************
function Three() {}
// ********** Code for Object3D **************
function Object3D() {
  var $0;
  this._name = "";
  this.id = ($globals.Three_Object3DCount = ($0 = $globals.Three_Object3DCount) + (1), $0);
  this.parent = null;
  this.children = [];
  this.up = new Vector3((0), (0), (0));
  this.position = new Vector3((0), (0), (0));
  this.rotation = new Vector3((0), (0), (0));
  this.eulerOrder = "XYZ";
  this.scale = new Vector3((1), (1), (1));
  this.dynamic = false;
  this.doubleSided = false;
  this.flipSided = false;
  this.renderDepth = null;
  this.rotationAutoUpdate = true;
  this.matrix = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this.matrixWorld = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this.matrixRotationWorld = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this.matrixAutoUpdate = true;
  this.matrixWorldNeedsUpdate = true;
  this.quaternion = new Quaternion((0), (0), (0), (1));
  this.useQuaternion = false;
  this.boundRadius = (0);
  this.boundRadiusScale = (1);
  this.visible = true;
  this.castShadow = false;
  this.receiveShadow = false;
  this.frustumCulled = true;
  this._vector = new Vector3((0), (0), (0));
}
Object3D.prototype.get$id = function() { return this.id; };
Object3D.prototype.get$position = function() { return this.position; };
Object3D.prototype.get$rotation = function() { return this.rotation; };
Object3D.prototype.get$scale = function() { return this.scale; };
Object3D.prototype.get$dynamic = function() { return this.dynamic; };
Object3D.prototype.get$matrixWorld = function() { return this.matrixWorld; };
Object3D.prototype.get$name = function() {
  return this._name;
}
Object3D.prototype.translate = function(distance, axis) {
  this.matrix.rotateAxis(axis);
  this.position.addSelf(axis.multiplyScalar(distance));
}
Object3D.prototype.add = function(object) {
  var $0;
  if ((($0 = this.children.indexOf$1(object)) == null ? null == ((-1)) : $0 === (-1))) {
    if (null != object.parent) {
      object.parent.remove(object);
    }
    object.parent = this;
    this.children.add(object);
    var scene = this;
    while (null != scene.parent) {
      scene = scene.parent;
    }
    if (null != scene && (scene instanceof Scene)) {
      scene.addObject(object);
    }
  }
}
Object3D.prototype.remove = function(object) {
  var index = this.children.indexOf$1(object);
  if ((null == index ? null != ((-1)) : index !== (-1))) {
    object.parent = null;
    this.children.removeRange(index, (1));
    var scene = this;
    while (null != scene.parent) {
      scene = scene.parent;
    }
    if (null != scene && (scene instanceof Scene)) {
      scene.removeObject(object);
    }
  }
}
Object3D.prototype.updateMatrix = function() {
  var $0, $1, $2;
  this.matrix.setPosition(this.position);
  if (this.useQuaternion) {
    this.matrix.setRotationFromQuaternion(this.quaternion);
  }
  else {
    this.matrix.setRotationFromEuler(this.rotation, this.eulerOrder);
  }
  if ((($0 = this.scale.get$x()) == null ? null != ((1)) : $0 !== (1)) || (($1 = this.scale.get$y()) == null ? null != ((1)) : $1 !== (1)) || (($2 = this.scale.get$z()) == null ? null != ((1)) : $2 !== (1))) {
    this.matrix.scale(this.scale);
    this.boundRadiusScale = Math.max(this.scale.get$x(), Math.max(this.scale.get$y(), this.scale.get$z()));
  }
  this.matrixWorldNeedsUpdate = true;
}
Object3D.prototype.updateMatrixWorld = function(force) {
  if (this.matrixAutoUpdate) this.updateMatrix();
  if (this.matrixWorldNeedsUpdate || force) {
    if (null != this.parent) {
      this.matrixWorld.multiply(this.parent.matrixWorld, this.matrix);
    }
    else {
      this.matrixWorld.copy(this.matrix);
    }
    this.matrixWorldNeedsUpdate = false;
    force = true;
  }
  for (var i = (0), l = this.children.get$length();
   i < l; i++) {
    this.children.$index(i).updateMatrixWorld(force);
  }
}
Object3D.prototype.translate$2 = Object3D.prototype.translate;
// ********** Code for Camera **************
$inherits(Camera, Object3D);
function Camera() {
  Object3D.call(this);
  this.matrixWorldInverse = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this.projectionMatrix = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this.projectionMatrixInverse = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
}
Camera.prototype.lookAt = function(vector) {
  this.matrix.lookAt(this.position, vector, this.up);
  if (this.rotationAutoUpdate) {
    this.rotation.setRotationFromMatrix(this.matrix);
  }
}
// ********** Code for PerspectiveCamera **************
$inherits(PerspectiveCamera, Camera);
function PerspectiveCamera(fov, aspect, near, far) {
  Camera.call(this);
  this._fov = null != fov ? fov : (50);
  this._aspect = null != aspect ? aspect : (1);
  this._near = null != near ? near : (0.1);
  this._far = null != far ? far : (2000);
  this.updateProjectionMatrix();
}
PerspectiveCamera.prototype.get$near = function() {
  return this._near;
}
PerspectiveCamera.prototype.get$far = function() {
  return this._far;
}
PerspectiveCamera.prototype.updateProjectionMatrix = function() {
  if (null != this._fullWidth) {
    var aspect = this._fullWidth / this._fullHeight;
    var top = Math.tan(this._fov * (3.141592653589793) / (360)) * this._near;
    var bottom = -top;
    var left = aspect * bottom;
    var right = aspect * top;
    var width = (right - left).abs();
    var height = (top - bottom).abs();
    this.projectionMatrix = Matrix4.makeFrustum(left + this._x * width / this._fullWidth, left + (this._x + width) * width / this._fullWidth, top - (this._y + height) * height / this._fullHeight, top - this._y * height / this._fullHeight, this._near, this._far);
  }
  else {
    this.projectionMatrix = Matrix4.makePerspective(this._fov, this._aspect, this._near, this._far);
  }
}
// ********** Code for Vector3 **************
function Vector3(_x, _y, _z) {
  this._z = _z;
  this._y = _y;
  this._x = _x;
}
Vector3.prototype.get$x = function() {
  return this._x;
}
Vector3.prototype.set$x = function(value) {
  this._x = value;
}
Vector3.prototype.get$y = function() {
  return this._y;
}
Vector3.prototype.set$y = function(value) {
  this._y = value;
}
Vector3.prototype.get$z = function() {
  return this._z;
}
Vector3.prototype.set$z = function(value) {
  this._z = value;
}
Vector3.prototype.setValues = function(x, y, z) {
  this._x = x;
  this._y = y;
  this._z = z;
  return this;
}
Vector3.prototype.copy = function(v) {
  this._x = v.get$x();
  this._y = v.get$y();
  this._z = v.get$z();
  return this;
}
Vector3.prototype.clone = function() {
  return new Vector3(this._x, this._y, this._z);
}
Vector3.prototype.addSelf = function(v) {
  this._x = this._x + v.get$x();
  this._y = this._y + v.get$y();
  this._z = this._z + v.get$z();
  return this;
}
Vector3.prototype.sub = function(v1, v2) {
  this._x = v1.get$x() - v2.get$x();
  this._y = v1.get$y() - v2.get$y();
  this._z = v1.get$z() - v2.get$z();
  return this;
}
Vector3.prototype.multiplyScalar = function(s) {
  this._x = this._x * s;
  this._y = this._y * s;
  this._z = this._z * s;
  return this;
}
Vector3.prototype.divideScalar = function(s) {
  if ((null == s ? null != ((0)) : s !== (0))) {
    this._x = this._x / s;
    this._y = this._y / s;
    this._z = this._z / s;
  }
  else {
    this._x = (0);
    this._y = (0);
    this._z = (0);
  }
  return this;
}
Vector3.prototype.dot = function(v) {
  return this._x * v.get$x() + this._y * v.get$y() + this._z * v.get$z();
}
Vector3.prototype.lengthSq = function() {
  return this._x * this._x + this._y * this._y + this._z * this._z;
}
Vector3.prototype.length = function() {
  return Math.sqrt(this.lengthSq());
}
Vector3.prototype.get$length = function() {
  return this.length.bind(this);
}
Vector3.prototype.normalize = function() {
  return this.divideScalar(this.length());
}
Vector3.prototype.cross = function(a, b) {
  this._x = a.get$y() * b.get$z() - a.get$z() * b.get$y();
  this._y = a.get$z() * b.get$x() - a.get$x() * b.get$z();
  this._z = a.get$x() * b.get$y() - a.get$y() * b.get$x();
  return this;
}
Vector3.prototype.distanceTo = function(v) {
  return Math.sqrt(this.distanceToSquared(v));
}
Vector3.prototype.distanceToSquared = function(v) {
  return new Vector3((0), (0), (0)).sub(this, v).lengthSq();
}
Vector3.prototype.setRotationFromMatrix = function(m) {
  var cosY = Math.cos(this._y);
  this._y = Math.asin(m.get$n13());
  if (cosY.abs() > (0.00001)) {
    this._x = Math.atan2(-m.get$n23() / cosY, m.get$n33() / cosY);
    this._z = Math.atan2(-m.get$n12() / cosY, m.get$n11() / cosY);
  }
  else {
    this._x = (0);
    this._z = Math.atan2(m.get$n21(), m.get$n22());
  }
}
// ********** Code for Matrix3 **************
function Matrix3() {
  this._m = [];
}
// ********** Code for Matrix4 **************
function Matrix4(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  this.n22 = n22;
  this.n14 = n14;
  this.n32 = n32;
  this.n24 = n24;
  this.n34 = n34;
  this.n43 = n43;
  this.n42 = n42;
  this.n44 = n44;
  this.n31 = n31;
  this.n23 = n23;
  this.n11 = n11;
  this.n21 = n21;
  this.n13 = n13;
  this.n12 = n12;
  this.n41 = n41;
  this.n33 = n33;
  this._flat = new Array();
  this._m33 = new Matrix3();
  if ($globals.Matrix4___v1 == null) $globals.Matrix4___v1 = new Vector3((0), (0), (0));
  if ($globals.Matrix4___v2 == null) $globals.Matrix4___v2 = new Vector3((0), (0), (0));
  if ($globals.Matrix4___v3 == null) $globals.Matrix4___v3 = new Vector3((0), (0), (0));
  if ($globals.Matrix4___m1 == null) $globals.Matrix4___m1 = new Matrix4.createMatrices$ctor((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  if ($globals.Matrix4___m2 == null) $globals.Matrix4___m2 = new Matrix4.createMatrices$ctor((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
}
Matrix4.createMatrices$ctor = function(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  this.n22 = n22;
  this.n14 = n14;
  this.n32 = n32;
  this.n24 = n24;
  this.n34 = n34;
  this.n43 = n43;
  this.n42 = n42;
  this.n44 = n44;
  this.n31 = n31;
  this.n23 = n23;
  this.n11 = n11;
  this.n21 = n21;
  this.n13 = n13;
  this.n12 = n12;
  this.n41 = n41;
  this.n33 = n33;
  this._flat = new Array();
  this._m33 = new Matrix3();
}
Matrix4.createMatrices$ctor.prototype = Matrix4.prototype;
Matrix4.prototype.get$n11 = function() { return this.n11; };
Matrix4.prototype.get$n12 = function() { return this.n12; };
Matrix4.prototype.get$n13 = function() { return this.n13; };
Matrix4.prototype.get$n21 = function() { return this.n21; };
Matrix4.prototype.get$n22 = function() { return this.n22; };
Matrix4.prototype.get$n23 = function() { return this.n23; };
Matrix4.prototype.get$n33 = function() { return this.n33; };
Matrix4.prototype.setValues = function(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44) {
  this.n11 = this.n11;
  this.n12 = this.n12;
  this.n13 = this.n13;
  this.n14 = this.n14;
  this.n21 = this.n21;
  this.n22 = this.n22;
  this.n23 = this.n23;
  this.n24 = this.n24;
  this.n31 = this.n31;
  this.n32 = this.n32;
  this.n33 = this.n33;
  this.n34 = this.n34;
  this.n41 = this.n41;
  this.n42 = this.n42;
  this.n43 = this.n43;
  this.n44 = this.n44;
  return this;
}
Matrix4.prototype.copy = function(m) {
  this.setValues(m.n11, m.n12, m.n13, m.n14, m.n21, m.n22, m.n23, m.n24, m.n31, m.n32, m.n33, m.n34, m.n41, m.n42, m.n43, m.n44);
  return this;
}
Matrix4.prototype.lookAt = function(eye, center, up) {
  var $0, $1;
  var x = $globals.Matrix4___v1, y = $globals.Matrix4___v2, z = $globals.Matrix4___v3;
  z.sub(eye, center).normalize();
  if ((($0 = z.length()) == null ? null == ((0)) : $0 === (0))) {
    z.set$z((1));
  }
  x.cross(up, z).normalize();
  if ((($1 = x.length()) == null ? null == ((0)) : $1 === (0))) {
    z.set$x(z.get$x() + (0.0001));
    x.cross(up, z).normalize();
  }
  y.cross(z, x).normalize();
  this.n11 = x.get$x();
  this.n12 = y.get$x();
  this.n13 = z.get$x();
  this.n21 = x.get$y();
  this.n22 = y.get$y();
  this.n23 = z.get$y();
  this.n31 = x.get$z();
  this.n32 = y.get$z();
  this.n33 = z.get$z();
  return this;
}
Matrix4.prototype.multiply = function(a, b) {
  var a11 = a.n11, a12 = a.n12, a13 = a.n13, a14 = a.n14, a21 = a.n21, a22 = a.n22, a23 = a.n23, a24 = a.n24, a31 = a.n31, a32 = a.n32, a33 = a.n33, a34 = a.n34, a41 = a.n41, a42 = a.n42, a43 = a.n43, a44 = a.n44, b11 = b.n11, b12 = b.n12, b13 = b.n13, b14 = b.n14, b21 = b.n21, b22 = b.n22, b23 = b.n23, b24 = b.n24, b31 = b.n31, b32 = b.n32, b33 = b.n33, b34 = b.n34, b41 = b.n41, b42 = b.n42, b43 = b.n43, b44 = b.n44;
  this.n11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
  this.n12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
  this.n13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
  this.n14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;
  this.n21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
  this.n22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
  this.n23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
  this.n24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;
  this.n31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
  this.n32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
  this.n33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
  this.n34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;
  this.n41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
  this.n42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
  this.n43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
  this.n44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
  return this;
}
Matrix4.prototype.multiplyScalar = function(s) {
  this.n11 = this.n11 * s;
  this.n12 = this.n12 * s;
  this.n13 = this.n13 * s;
  this.n14 = this.n14 * s;
  this.n21 = this.n21 * s;
  this.n22 = this.n22 * s;
  this.n23 = this.n23 * s;
  this.n24 = this.n24 * s;
  this.n31 = this.n31 * s;
  this.n32 = this.n32 * s;
  this.n33 = this.n33 * s;
  this.n34 = this.n34 * s;
  this.n41 = this.n41 * s;
  this.n42 = this.n42 * s;
  this.n43 = this.n43 * s;
  this.n44 = this.n44 * s;
  return this;
}
Matrix4.prototype.multiplyVector3 = function(v) {
  var vx = v.get$x(), vy = v.get$y(), vz = v.get$z(), d = (1) / (this.n41 * vx + this.n42 * vy + this.n43 * vz + this.n44);
  v.set$x((this.n11 * vx + this.n12 * vy + this.n13 * vz + this.n14) * d);
  v.set$y((this.n21 * vx + this.n22 * vy + this.n23 * vz + this.n24) * d);
  v.set$z((this.n31 * vx + this.n32 * vy + this.n33 * vz + this.n34) * d);
  return v;
}
Matrix4.prototype.multiplyVector4 = function(v) {
  var vx = v.get$x(), vy = v.get$y(), vz = v.get$z(), vw = v.get$w();
  v.set$x(this.n11 * vx + this.n12 * vy + this.n13 * vz + this.n14 * vw);
  v.set$y(this.n21 * vx + this.n22 * vy + this.n23 * vz + this.n24 * vw);
  v.set$z(this.n31 * vx + this.n32 * vy + this.n33 * vz + this.n34 * vw);
  v.set$w(this.n41 * vx + this.n42 * vy + this.n43 * vz + this.n44 * vw);
  return v;
}
Matrix4.prototype.rotateAxis = function(v) {
  var vx = v.get$x(), vy = v.get$y(), vz = v.get$z();
  v.set$x(vx * this.n11 + vy * this.n12 + vz * this.n13);
  v.set$y(vx * this.n21 + vy * this.n22 + vz * this.n23);
  v.set$z(vx * this.n31 + vy * this.n32 + vz * this.n33);
  v.normalize();
  return v;
}
Matrix4.prototype.determinant = function() {
  var m11 = this.n11, m12 = this.n12, m13 = this.n13, m14 = this.n14, m21 = this.n21, m22 = this.n22, m23 = this.n23, m24 = this.n24, m31 = this.n31, m32 = this.n32, m33 = this.n33, m34 = this.n34, m41 = this.n41, m42 = this.n42, m43 = this.n43, m44 = this.n44;
  return (m14 * m23 * m32 * m41 - m13 * m24 * m32 * m41 - m14 * m22 * m33 * m41 + m12 * m24 * m33 * m41 + m13 * m22 * m34 * m41 - m12 * m23 * m34 * m41 - m14 * m23 * m31 * m42 + m13 * m24 * m31 * m42 + m14 * m21 * m33 * m42 - m11 * m24 * m33 * m42 - m13 * m21 * m34 * m42 + m11 * m23 * m34 * m42 + m14 * m22 * m31 * m43 - m12 * m24 * m31 * m43 - m14 * m21 * m32 * m43 + m11 * m24 * m32 * m43 + m12 * m21 * m34 * m43 - m11 * m22 * m34 * m43 - m13 * m22 * m31 * m44 + m12 * m23 * m31 * m44 + m13 * m21 * m32 * m44 - m11 * m23 * m32 * m44 - m12 * m21 * m33 * m44 + m11 * m22 * m33 * m44);
}
Matrix4.prototype.setPosition = function(v) {
  this.n14 = v.get$x();
  this.n24 = v.get$y();
  this.n34 = v.get$z();
  return this;
}
Matrix4.prototype.getPosition = function() {
  return $globals.Matrix4___v1.setValues(this.n14, this.n24, this.n34);
}
Matrix4.prototype.getColumnX = function() {
  return $globals.Matrix4___v1.setValues(this.n11, this.n21, this.n31);
}
Matrix4.prototype.getColumnY = function() {
  return $globals.Matrix4___v1.setValues(this.n12, this.n22, this.n32);
}
Matrix4.prototype.getColumnZ = function() {
  return $globals.Matrix4___v1.setValues(this.n13, this.n23, this.n33);
}
Matrix4.prototype.getInverse = function(m) {
  var _n11 = m.n11, _n12 = m.n12, _n13 = m.n13, _n14 = m.n14, _n21 = m.n21, _n22 = m.n22, _n23 = m.n23, _n24 = m.n24, _n31 = m.n31, _n32 = m.n32, _n33 = m.n33, _n34 = m.n34, _n41 = m.n41, _n42 = m.n42, _n43 = m.n43, _n44 = m.n44;
  this.n11 = _n23 * _n34 * _n42 - _n24 * _n33 * _n42 + _n24 * _n32 * _n43 - _n22 * _n34 * _n43 - _n23 * _n32 * _n44 + _n22 * _n33 * _n44;
  this.n12 = _n14 * _n33 * _n42 - _n13 * _n34 * _n42 - _n14 * _n32 * _n43 + _n12 * _n34 * _n43 + _n13 * _n32 * _n44 - _n12 * _n33 * _n44;
  this.n13 = _n13 * _n24 * _n42 - _n14 * _n23 * _n42 + _n14 * _n22 * _n43 - _n12 * _n24 * _n43 - _n13 * _n22 * _n44 + _n12 * _n23 * _n44;
  this.n14 = _n14 * _n23 * _n32 - _n13 * _n24 * _n32 - _n14 * _n22 * _n33 + _n12 * _n24 * _n33 + _n13 * _n22 * _n34 - _n12 * _n23 * _n34;
  this.n21 = _n24 * _n33 * _n41 - _n23 * _n34 * _n41 - _n24 * _n31 * _n43 + _n21 * _n34 * _n43 + _n23 * _n31 * _n44 - _n21 * _n33 * _n44;
  this.n22 = _n13 * _n34 * _n41 - _n14 * _n33 * _n41 + _n14 * _n31 * _n43 - _n11 * _n34 * _n43 - _n13 * _n31 * _n44 + _n11 * _n33 * _n44;
  this.n23 = _n14 * _n23 * _n41 - _n13 * _n24 * _n41 - _n14 * _n21 * _n43 + _n11 * _n24 * _n43 + _n13 * _n21 * _n44 - _n11 * _n23 * _n44;
  this.n24 = _n13 * _n24 * _n31 - _n14 * _n23 * _n31 + _n14 * _n21 * _n33 - _n11 * _n24 * _n33 - _n13 * _n21 * _n34 + _n11 * _n23 * _n34;
  this.n31 = _n22 * _n34 * _n41 - _n24 * _n32 * _n41 + _n24 * _n31 * _n42 - _n21 * _n34 * _n42 - _n22 * _n31 * _n44 + _n21 * _n32 * _n44;
  this.n32 = _n14 * _n32 * _n41 - _n12 * _n34 * _n41 - _n14 * _n31 * _n42 + _n11 * _n34 * _n42 + _n12 * _n31 * _n44 - _n11 * _n32 * _n44;
  this.n33 = _n12 * _n24 * _n41 - _n14 * _n22 * _n41 + _n14 * _n21 * _n42 - _n11 * _n24 * _n42 - _n12 * _n21 * _n44 + _n11 * _n22 * _n44;
  this.n34 = _n14 * _n22 * _n31 - _n12 * _n24 * _n31 - _n14 * _n21 * _n32 + _n11 * _n24 * _n32 + _n12 * _n21 * _n34 - _n11 * _n22 * _n34;
  this.n41 = _n23 * _n32 * _n41 - _n22 * _n33 * _n41 - _n23 * _n31 * _n42 + _n21 * _n33 * _n42 + _n22 * _n31 * _n43 - _n21 * _n32 * _n43;
  this.n42 = _n12 * _n33 * _n41 - _n13 * _n32 * _n41 + _n13 * _n31 * _n42 - _n11 * _n33 * _n42 - _n12 * _n31 * _n43 + _n11 * _n32 * _n43;
  this.n43 = _n13 * _n22 * _n41 - _n12 * _n23 * _n41 - _n13 * _n21 * _n42 + _n11 * _n23 * _n42 + _n12 * _n21 * _n43 - _n11 * _n22 * _n43;
  this.n44 = _n12 * _n23 * _n31 - _n13 * _n22 * _n31 + _n13 * _n21 * _n32 - _n11 * _n23 * _n32 - _n12 * _n21 * _n33 + _n11 * _n22 * _n33;
  this.multiplyScalar((1) / m.determinant());
  return this;
}
Matrix4.prototype.setRotationFromEuler = function(v, order) {
  var x = v.get$x(), y = v.get$y(), z = v.get$z(), a = Math.cos(x), b = Math.sin(x), c = Math.cos(y), d = Math.sin(y), e = Math.cos(z), f = Math.sin(z);
  switch (order) {
    case "YXZ":

      var ce = c * e, cf = c * f, de = d * e, df = d * f;
      this.n11 = ce + df * b;
      this.n12 = de * b - cf;
      this.n13 = a * d;
      this.n21 = a * f;
      this.n22 = a * e;
      this.n23 = -b;
      this.n31 = cf * b - de;
      this.n32 = df + ce * b;
      this.n33 = a * c;
      break;

    case "ZXY":

      var ce = c * e, cf = c * f, de = d * e, df = d * f;
      this.n11 = ce - df * b;
      this.n12 = -a * f;
      this.n13 = de + cf * b;
      this.n21 = cf + de * b;
      this.n22 = a * e;
      this.n23 = df - ce * b;
      this.n31 = -a * d;
      this.n32 = b;
      this.n33 = a * c;
      break;

    case "ZYX":

      var ae = a * e, af = a * f, be = b * e, bf = b * f;
      this.n11 = c * e;
      this.n12 = be * d - af;
      this.n13 = ae * d + bf;
      this.n21 = c * f;
      this.n22 = bf * d + ae;
      this.n23 = af * d - be;
      this.n31 = -d;
      this.n32 = b * c;
      this.n33 = a * c;
      break;

    case "YZX":

      var ac = a * c, ad = a * d, bc = b * c, bd = b * d;
      this.n11 = c * e;
      this.n12 = bd - ac * f;
      this.n13 = bc * f + ad;
      this.n21 = f;
      this.n22 = a * e;
      this.n23 = -b * e;
      this.n31 = -d * e;
      this.n32 = ad * f + bc;
      this.n33 = ac - bd * f;
      break;

    case "XZY":

      var ac = a * c, ad = a * d, bc = b * c, bd = b * d;
      this.n11 = c * e;
      this.n12 = -f;
      this.n13 = d * e;
      this.n21 = ac * f + bd;
      this.n22 = a * e;
      this.n23 = ad * f - bc;
      this.n31 = bc * f - ad;
      this.n32 = b * e;
      this.n33 = bd * f + ac;
      break;

    default:

      var ae = a * e, af = a * f, be = b * e, bf = b * f;
      this.n11 = c * e;
      this.n12 = -c * f;
      this.n13 = d;
      this.n21 = af + be * d;
      this.n22 = ae - bf * d;
      this.n23 = -b * c;
      this.n31 = bf - ae * d;
      this.n32 = be + af * d;
      this.n33 = a * c;
      break;

  }
  return this;
}
Matrix4.prototype.setRotationFromQuaternion = function(q) {
  var x = q.x, y = q.y, z = q.z, w = q.w, x2 = x + x, y2 = y + y, z2 = z + z, xx = x * x2, xy = x * y2, xz = x * z2, yy = y * y2, yz = y * z2, zz = z * z2, wx = w * x2, wy = w * y2, wz = w * z2;
  this.n11 = (1) - (yy + zz);
  this.n12 = xy - wz;
  this.n13 = xz + wy;
  this.n21 = xy + wz;
  this.n22 = (1) - (xx + zz);
  this.n23 = yz - wx;
  this.n31 = xz - wy;
  this.n32 = yz + wx;
  this.n33 = (1) - (xx + yy);
  return this;
}
Matrix4.prototype.scale = function(v) {
  var x = v.get$x(), y = v.get$y(), z = v.get$z();
  this.n11 = this.n11 * x;
  this.n12 = this.n12 * y;
  this.n13 = this.n13 * z;
  this.n21 = this.n21 * x;
  this.n22 = this.n22 * y;
  this.n23 = this.n23 * z;
  this.n31 = this.n31 * x;
  this.n32 = this.n32 * y;
  this.n33 = this.n33 * z;
  this.n41 = this.n41 * x;
  this.n42 = this.n42 * y;
  this.n43 = this.n43 * z;
  return this;
}
Matrix4.prototype.get$scale = function() {
  return this.scale.bind(this);
}
Matrix4.prototype.extractRotation = function(m) {
  var vector = $globals.Matrix4___v1;
  var scaleX = (1) / vector.setValues(m.n11, m.n21, m.n31).length();
  var scaleY = (1) / vector.setValues(m.n12, m.n22, m.n32).length();
  var scaleZ = (1) / vector.setValues(m.n13, m.n23, m.n33).length();
  this.n11 = m.n11 * scaleX;
  this.n21 = m.n21 * scaleX;
  this.n31 = m.n31 * scaleX;
  this.n12 = m.n12 * scaleY;
  this.n22 = m.n22 * scaleY;
  this.n32 = m.n32 * scaleY;
  this.n13 = m.n13 * scaleZ;
  this.n23 = m.n23 * scaleZ;
  this.n33 = m.n33 * scaleZ;
  return this;
}
Matrix4.makeFrustum = function(left, right, bottom, top, near, far) {
  var x, y, a, b, c, d;
  var m = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  x = (2) * near / (right - left);
  y = (2) * near / (top - bottom);
  a = (right + left) / (right - left);
  b = (top + bottom) / (top - bottom);
  c = -(far + near) / (far - near);
  d = (-2) * far * near / (far - near);
  m.n11 = x;
  m.n12 = (0);
  m.n13 = a;
  m.n14 = (0);
  m.n21 = (0);
  m.n22 = y;
  m.n23 = b;
  m.n24 = (0);
  m.n31 = (0);
  m.n32 = (0);
  m.n33 = c;
  m.n34 = d;
  m.n41 = (0);
  m.n42 = (0);
  m.n43 = (-1);
  m.n44 = (0);
  return m;
}
Matrix4.makePerspective = function(fov, aspect, near, far) {
  var ymax, ymin, xmin, xmax;
  ymax = near * Math.tan(fov * (3.141592653589793) / (360));
  ymin = -ymax;
  xmin = ymin * aspect;
  xmax = ymax * aspect;
  return Matrix4.makeFrustum(xmin, xmax, ymin, ymax, near, far);
}
// ********** Code for Quaternion **************
function Quaternion(x, y, z, w) {
  this.y = y;
  this.w = w;
  this.x = x;
  this.z = z;
}
Quaternion.prototype.get$x = function() { return this.x; };
Quaternion.prototype.get$y = function() { return this.y; };
Quaternion.prototype.get$z = function() { return this.z; };
Quaternion.prototype.get$w = function() { return this.w; };
Quaternion.prototype.length = function() {
  return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
}
Quaternion.prototype.get$length = function() {
  return this.length.bind(this);
}
// ********** Code for Vector4 **************
function Vector4(_x, _y, _z, _w) {
  this._z = _z;
  this._y = _y;
  this._w = _w;
  this._x = _x;
}
Vector4.prototype.is$IVector4 = function(){return true};
Vector4.prototype.get$x = function() {
  return this._x;
}
Vector4.prototype.set$x = function(value) {
  this._x = value;
}
Vector4.prototype.get$y = function() {
  return this._y;
}
Vector4.prototype.set$y = function(value) {
  this._y = value;
}
Vector4.prototype.get$z = function() {
  return this._z;
}
Vector4.prototype.set$z = function(value) {
  this._z = value;
}
Vector4.prototype.get$w = function() {
  return this._w;
}
Vector4.prototype.set$w = function(value) {
  this._w = value;
}
Vector4.prototype.setValues = function(x, y, z, w) {
  this._x = x;
  this._y = y;
  this._z = z;
  this._w = w;
  return this;
}
Vector4.prototype.copy = function(v) {
  this._x = v.get$x();
  this._y = v.get$y();
  this._z = v.get$z();
  if (!!(v && v.is$IVector4())) {
    var v4 = v;
    this._w = v4.get$w();
  }
  else {
    this._w = (1);
  }
}
Vector4.prototype.multiplyScalar = function(s) {
  this._x = this._x * s;
  this._y = this._y * s;
  this._z = this._z * s;
  this._w = this._w * s;
  return this;
}
Vector4.prototype.divideScalar = function(s) {
  if (null != s) {
    this._x = this._x / s;
    this._y = this._y / s;
    this._z = this._z / s;
    this._w = this._w / s;
  }
  else {
    this._x = (0);
    this._y = (0);
    this._z = (0);
    this._w = (1);
  }
  return this;
}
Vector4.prototype.dot = function(v) {
  return this._x * v.get$x() + this._y * v.get$y() + this._z * v.get$z() + this._w * v.get$w();
}
Vector4.prototype.lengthSq = function() {
  return this.dot(this);
}
Vector4.prototype.length = function() {
  return Math.sqrt(this.lengthSq());
}
Vector4.prototype.get$length = function() {
  return this.length.bind(this);
}
Vector4.prototype.lerpSelf = function(v, alpha) {
  this._x = this._x + ((v.get$x() - this._x) * alpha);
  this._y = this._y + ((v.get$y() - this._y) * alpha);
  this._z = this._z + ((v.get$z() - this._z) * alpha);
  this._w = this._w + ((v.get$w() - this._w) * alpha);
  return this;
}
// ********** Code for Color **************
function Color(hex) {
  this.r = (1);
  this.g = (1);
  this.b = (1);
  if (null != hex) this.setHex(hex);
}
Color.prototype.setRGB = function(newR, newG, newB) {
  this.r = newR;
  this.g = newG;
  this.b = newB;
  return this;
}
Color.prototype.setHex = function(hex) {
  hex = hex.floor();
  this.r = (hex >> (16) & (255)) / (255);
  this.g = (hex >> (8) & (255)) / (255);
  this.b = (hex & (255)) / (255);
  return this;
}
Color.prototype.getContextStyle = function() {
  return $add$($add$($add$("rgb(" + (this.r * (255)).floor(), ",") + (this.g * (255)).floor(), ",") + (this.b * (255)).floor(), ")");
}
// ********** Code for Face3 **************
function Face3() {}
Face3.prototype.get$centroid = function() {
  return this._centroid;
}
Face3.prototype.get$normal = function() {
  return this._normal;
}
Face3.prototype.get$vertexNormals = function() {
  return this._vertexNormals;
}
Face3.prototype.get$materialIndex = function() {
  return this._materialIndex;
}
Face3.prototype.get$a = function() {
  return this._a;
}
Face3.prototype.get$b = function() {
  return this._b;
}
Face3.prototype.get$c = function() {
  return this._c;
}
// ********** Code for Face4 **************
function Face4(a, b, c, d, normal, color, materialIndex) {
  this._a = a;
  this._b = b;
  this._c = c;
  this._d = d;
  this._normal = (normal instanceof Vector3) ? normal : new Vector3((0), (0), (0));
  this._vertexNormals = !!(normal && normal.is$List()) ? normal : [];
  this._color = (color instanceof Color) ? color : new Color();
  this._vertexColors = !!(color && color.is$List()) ? color : [];
  this._vertexTangents = [];
  this._materialIndex = materialIndex;
  this._centroid = new Vector3((0), (0), (0));
}
Face4.prototype.get$centroid = function() {
  return this._centroid;
}
Face4.prototype.get$normal = function() {
  return this._normal;
}
Face4.prototype.get$vertexNormals = function() {
  return this._vertexNormals;
}
Face4.prototype.get$materialIndex = function() {
  return this._materialIndex;
}
Face4.prototype.set$materialIndex = function(value) {
  this._materialIndex = value;
}
Face4.prototype.get$a = function() {
  return this._a;
}
Face4.prototype.set$a = function(value) {
  this._a = value;
}
Face4.prototype.get$b = function() {
  return this._b;
}
Face4.prototype.set$b = function(value) {
  this._b = value;
}
Face4.prototype.get$c = function() {
  return this._c;
}
Face4.prototype.set$c = function(value) {
  this._c = value;
}
Face4.prototype.get$d = function() {
  return this._d;
}
Face4.prototype.set$d = function(value) {
  this._d = value;
}
// ********** Code for Frustum **************
function Frustum() {
  if ($globals.Frustum___v1 == null) {
    $globals.Frustum___v1 = new Vector3((0), (0), (0));
  }
  this._planes = [new Vector4((0), (0), (0), (1)), new Vector4((0), (0), (0), (1)), new Vector4((0), (0), (0), (1)), new Vector4((0), (0), (0), (1)), new Vector4((0), (0), (0), (1)), new Vector4((0), (0), (0), (1))];
}
Frustum.prototype.setFromMatrix = function(m) {
  var i;
  var plane;
  var planes = this._planes;
  plane = planes.$index((0));
  plane.setValues(m.n41 - m.n11, m.n42 - m.n12, m.n43 - m.n13, m.n44 - m.n14);
  plane = planes.$index((1));
  plane.setValues(m.n41 + m.n11, m.n42 + m.n12, m.n43 + m.n13, m.n44 + m.n14);
  plane = planes.$index((2));
  plane.setValues(m.n41 + m.n21, m.n42 + m.n22, m.n43 + m.n23, m.n44 + m.n24);
  plane = planes.$index((3));
  plane.setValues(m.n41 - m.n21, m.n42 - m.n22, m.n43 - m.n23, m.n44 - m.n24);
  plane = planes.$index((4));
  plane.setValues(m.n41 - m.n31, m.n42 - m.n32, m.n43 - m.n33, m.n44 - m.n34);
  plane = planes.$index((5));
  plane.setValues(m.n41 + m.n31, m.n42 + m.n32, m.n43 + m.n33, m.n44 + m.n34);
  for (i = (0);
   i < (6); i++) {
    plane = planes.$index(i);
    plane.divideScalar(Math.sqrt(plane.get$x() * plane.get$x() + plane.get$y() * plane.get$y() + plane.get$z() * plane.get$z()));
  }
}
Frustum.prototype.contains = function(object) {
  var distance;
  var planes = this._planes;
  var matrix = object.get$matrixWorld();
  var scale = $globals.Frustum___v1.setValues(matrix.getColumnX().length(), matrix.getColumnY().length(), matrix.getColumnZ().length());
  var radius = $negate$(object.get$geometry().get$boundingSphere().$index("radius")) * Math.max(scale.get$x(), Math.max(scale.get$y(), scale.get$z()));
  for (var i = (0);
   i < (6); i++) {
    distance = $mul$(planes.$index(i).get$x(), matrix.n14) + $mul$(planes.$index(i).get$y(), matrix.n24) + $mul$(planes.$index(i).get$z(), matrix.n34) + planes.$index(i).get$w();
    if (distance <= radius) return false;
  }
  return true;
}
// ********** Code for Geometry **************
function Geometry() {
  var $0;
  this._id = ($globals.Three_GeometryCount = ($0 = $globals.Three_GeometryCount) + (1), $0);
  this._vertices = [];
  this._colors = [];
  this._materials = [];
  this._faces = [];
  this._faceUvs = [[]];
  this._faceVertexUvs = [];
  this._faceVertexUvs.add(new Array());
  this._morphTargets = [];
  this._morphColors = [];
  this._skinWeights = [];
  this._skinIndices = [];
  this._boundingBox = null;
  this._boundingSphere = null;
  this._hasTangents = false;
  this._dynamic = false;
}
Geometry.prototype.get$boundingSphere = function() {
  return this._boundingSphere;
}
Geometry.prototype.get$morphTargets = function() {
  return this._morphTargets;
}
Geometry.prototype.get$faces = function() {
  return this._faces;
}
Geometry.prototype.get$materials = function() {
  return this._materials;
}
Geometry.prototype.get$vertices = function() {
  return this._vertices;
}
Geometry.prototype.get$faceVertexUvs = function() {
  return this._faceVertexUvs;
}
Geometry.prototype.computeCentroids = function() {
  var f;
  var fl = this._faces.get$length();
  var face;
  for (f = (0);
   f < fl; f++) {
    face = this._faces.$index(f);
    face.get$centroid().setValues((0), (0), (0));
    if ((face instanceof Face3)) {
      face.get$centroid().addSelf(this._vertices.$index(face.get$a()).get$position());
      face.get$centroid().addSelf(this._vertices.$index(face.get$b()).get$position());
      face.get$centroid().addSelf(this._vertices.$index(face.get$c()).get$position());
      face.get$centroid().divideScalar((3));
    }
    else if ((face instanceof Face4)) {
      var face4 = face;
      face4.get$centroid().addSelf(this._vertices.$index(face4.get$a()).get$position());
      face4.get$centroid().addSelf(this._vertices.$index(face4.get$b()).get$position());
      face4.get$centroid().addSelf(this._vertices.$index(face4.get$c()).get$position());
      face4.get$centroid().addSelf(this._vertices.$index(face4.get$d()).get$position());
      face4.get$centroid().divideScalar((4));
    }
  }
}
Geometry.prototype.computeBoundingSphere = function() {
  var radius, maxRadius = (0);
  var vl = this._vertices.get$length();
  for (var v = (0);
   v < vl; v++) {
    radius = this._vertices.$index(v).get$position().length();
    if (radius > maxRadius) maxRadius = radius;
  }
  this._boundingSphere = _map(["radius", maxRadius]);
}
Geometry.prototype.mergeVertices = function() {
  var verticesMap = new HashMapImplementation();
  var unique = [];
  var changes = [];
  var key;
  var precisionPoints = (4);
  var precision = Math.pow((10), precisionPoints);
  var i;
  var il = this._vertices.get$length();
  for (i = (0);
   i < il; i++) {
    var v = this._vertices.$index(i).get$position();
    var vx = (v.get$x() * precision).round();
    var vy = (v.get$y() * precision).round();
    var vz = (v.get$z() * precision).round();
    key = ("" + vx + "_" + vy + "_" + vz);
    if (null == verticesMap.$index(key)) {
      verticesMap.$setindex(key, i);
      unique.add(this._vertices.$index(i));
      changes.add(unique.get$length() - (1));
    }
    else {
      changes.add(changes.$index(verticesMap.$index(key)));
    }
  }
  il = this._faces.get$length();
  for (i = (0);
   i < il; i++) {
    var face = this._faces.$index(i);
    if ((face instanceof Face3)) {
      face.set$a(changes.$index(face.get$a()));
      face.set$b(changes.$index(face.get$b()));
      face.set$c(changes.$index(face.get$c()));
    }
    else if ((face instanceof Face4)) {
      var face4 = face;
      face4.set$a(changes.$index(face4.get$a()));
      face4.set$b(changes.$index(face4.get$b()));
      face4.set$c(changes.$index(face4.get$c()));
      face4.set$d(changes.$index(face4.get$d()));
    }
  }
  this._vertices = unique;
}
// ********** Code for Vertex **************
function Vertex(position) {
  this._position = (position != null) ? position : new Vector3((0), (0), (0));
}
Vertex.prototype.get$position = function() {
  return this._position;
}
// ********** Code for Projector **************
function Projector() {
  this._objectPool = [];
  this._vertexPool = [];
  this._face3Pool = [];
  this._face4Pool = [];
  this._linePool = [];
  this._particlePool = [];
  this._renderData = new ProjectorRenderData();
  this._vector3 = new Vector3((0), (0), (0));
  this._vector4 = new Vector4((0), (0), (0), (1));
  this._projScreenMatrix = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this._projScreenobjectMatrixWorld = new Matrix4((1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1), (0), (0), (0), (0), (1));
  this._frustum = new Frustum();
  this._clippedVertex1PositionScreen = new Vector4((0), (0), (0), (1));
  this._clippedVertex2PositionScreen = new Vector4((0), (0), (0), (1));
  var _face3VertexNormals;
}
Projector.prototype.projectGraph = function(root, sort) {
  this._objectCount = (0);
  this._renderData.objects = [];
  this._renderData.sprites = [];
  this._renderData.lights = [];
  this.projectObject(root);
  if (sort) {
    this._renderData.objects.sort$1(this.get$painterSort());
  }
  return this._renderData;
}
Projector.prototype.projectObject = function(object) {
  var $0, $1;
  if ((($0 = object.visible) == null ? null == (false) : $0 === false)) return null;
  if (((object instanceof Mesh) || (object instanceof Line)) && ((($1 = object.frustumCulled) == null ? null == (false) : $1 === false) || this._frustum.contains(object))) {
    this._projScreenMatrix.multiplyVector3(this._vector3.copy(object.position));
    this._object = this.getNextObjectInPool();
    this._object.object = object;
    this._object.z = this._vector3.get$z();
    this._renderData.objects.add(this._object);
  }
  else if ((object instanceof Sprite) || (object instanceof Particle)) {
    this._projScreenMatrix.multiplyVector3(this._vector3.copy(object.position));
    this._object = this.getNextObjectInPool();
    this._object.object = object;
    this._object.z = this._vector3.get$z();
    this._renderData.sprites.add(this._object);
  }
  else if ((object instanceof Light)) {
    this._renderData.lights.add(object);
  }
  var cl = object.children.get$length();
  for (var c = (0);
   c < cl; c++) {
    var obj = object.children.$index(c);
    this.projectObject(object.children.$index(c));
  }
}
Projector.prototype.projectScene = function(scene, camera, sort) {
  var $0, $1, $2;
  var near = camera.get$near(), far = camera.get$far();
  var o, ol, v, vl, f, fl, n, nl, c, cl, u, ul;
  var object;
  var objectMatrixWorld, objectMatrixWorldRotation;
  var objectMaterial;
  var geometry;
  var geometryMaterials;
  var vertices;
  var vertex;
  var vertexPositionScreen, normal;
  var faces;
  var face;
  var _face;
  var faceVertexNormals;
  var faceVertexUvs;
  var v1, v2, v3, v4;
  this._face3Count = (0);
  this._face4Count = (0);
  this._lineCount = (0);
  this._particleCount = (0);
  this._renderData.elements = [];
  if (null == camera.parent) {
    scene.add(camera);
  }
  scene.updateMatrixWorld();
  camera.matrixWorldInverse.getInverse(camera.matrixWorld);
  this._projScreenMatrix.multiply(camera.projectionMatrix, camera.matrixWorldInverse);
  this._frustum.setFromMatrix(this._projScreenMatrix);
  this._renderData = this.projectGraph(scene, false);
  ol = this._renderData.objects.get$length();
  for (o = (0);
   o < ol; o++) {
    object = this._renderData.objects.$index(o).get$object();
    objectMatrixWorld = object.matrixWorld;
    objectMaterial = object.get$material();
    this._vertexCount = (0);
    if ((object instanceof Mesh)) {
      geometry = object.get$geometry();
      geometryMaterials = object.get$geometry().get$materials();
      vertices = geometry.get$vertices();
      faces = geometry.get$faces();
      faceVertexUvs = geometry.get$faceVertexUvs();
      objectMatrixWorldRotation = object.matrixRotationWorld.extractRotation(objectMatrixWorld);
      vl = vertices.get$length();
      for (v = (0);
       v < vl; v++) {
        this._vertex = this.getNextVertexInPool();
        this._vertex.positionWorld.copy(vertices.$index(v).get$position());
        objectMatrixWorld.multiplyVector3(this._vertex.positionWorld);
        this._vertex.positionScreen.copy(this._vertex.positionWorld);
        this._projScreenMatrix.multiplyVector4(this._vertex.positionScreen);
        ($0 = this._vertex.positionScreen).set$x($0.get$x() / this._vertex.positionScreen.get$w());
        ($1 = this._vertex.positionScreen).set$y($1.get$y() / this._vertex.positionScreen.get$w());
        this._vertex.visible = this._vertex.positionScreen.get$z() > near && this._vertex.positionScreen.get$z() < far;
      }
      fl = faces.get$length();
      for (f = (0);
       f < fl; f++) {
        face = faces.$index(f);
        if ((face instanceof Face3)) {
          v1 = this._vertexPool.$index(face.get$a());
          v2 = this._vertexPool.$index(face.get$b());
          v3 = this._vertexPool.$index(face.get$c());
          if (v1.visible && v2.visible && v3.visible && (object.doubleSided || ($ne$(object.flipSided, (v3.positionScreen.get$x() - v1.positionScreen.get$x()) * (v2.positionScreen.get$y() - v1.positionScreen.get$y()) - (v3.positionScreen.get$y() - v1.positionScreen.get$y()) * (v2.positionScreen.get$x() - v1.positionScreen.get$x()) < (0))))) {
            _face = this.getNextFace3InPool();
            _face.get$v1().copy(v1);
            _face.get$v2().copy(v2);
            _face.get$v3().copy(v3);
          }
          else {
            continue;
          }
        }
        else if ((face instanceof Face4)) {
          var face4 = face;
          v1 = this._vertexPool.$index(face4.get$a());
          v2 = this._vertexPool.$index(face4.get$b());
          v3 = this._vertexPool.$index(face4.get$c());
          v4 = this._vertexPool.$index(face4.get$d());
          var bool1 = (v4.positionScreen.get$x() - v1.positionScreen.get$x()) * (v2.positionScreen.get$y() - v1.positionScreen.get$y()) - (v4.positionScreen.get$y() - v1.positionScreen.get$y()) * (v2.positionScreen.get$x() - v1.positionScreen.get$x()) < (0);
          var bool2 = (v2.positionScreen.get$x() - v3.positionScreen.get$x()) * (v4.positionScreen.get$y() - v3.positionScreen.get$y()) - (v2.positionScreen.get$y() - v3.positionScreen.get$y()) * (v4.positionScreen.get$x() - v3.positionScreen.get$x()) < (0);
          var bool3 = bool1 || bool2;
          if (v1.visible && v2.visible && v3.visible && v4.visible && (object.doubleSided || ($ne$(object.flipSided, bool3)))) {
            _face = this.getNextFace4InPool();
            _face.get$v1().copy(v1);
            _face.get$v2().copy(v2);
            _face.get$v3().copy(v3);
            var rFace4 = _face;
            rFace4.get$v4().copy(v4);
          }
          else {
            continue;
          }
        }
        _face.get$normalWorld().copy(face.get$normal());
        objectMatrixWorldRotation.multiplyVector3(_face.get$normalWorld());
        _face.get$centroidWorld().copy(face.get$centroid());
        objectMatrixWorld.multiplyVector3(_face.get$centroidWorld());
        _face.get$centroidScreen().copy(_face.get$centroidWorld());
        this._projScreenMatrix.multiplyVector3(_face.get$centroidScreen());
        faceVertexNormals = face.get$vertexNormals();
        nl = faceVertexNormals.get$length();
        for (n = (0);
         n < nl; n++) {
          normal = _face.get$vertexNormalsWorld().$index(n);
          normal.copy(faceVertexNormals.$index(n));
          objectMatrixWorldRotation.multiplyVector3(normal);
        }
        cl = faceVertexUvs.get$length();
        for (c = (0);
         c < cl; c++) {
          var uvs = faceVertexUvs.$index(c).$index(f);
          if (uvs == null) continue;
          ul = uvs.get$length();
          for (u = (0);
           u < ul; u++) {
            var faceUVs = _face.get$uvs().$index(c);
            faceUVs.add(uvs.$index(u));
          }
        }
        _face.set$material(objectMaterial);
        _face.set$faceMaterial(null != face.get$materialIndex() ? geometryMaterials.$index(face.get$materialIndex()) : null);
        _face.set$z(_face.get$centroidScreen().get$z());
        this._renderData.elements.add(_face);
      }
    }
    else if ((object instanceof Line)) {
      this._projScreenobjectMatrixWorld.multiply(this._projScreenMatrix, objectMatrixWorld);
      vertices = object.get$geometry().get$vertices();
      v1 = this.getNextVertexInPool();
      v1.positionScreen.copy(vertices.$index((0)).get$position());
      this._projScreenobjectMatrixWorld.multiplyVector4(v1.positionScreen);
      vl = vertices.get$length();
      for (v = (1);
       v < vl; v++) {
        v1 = this.getNextVertexInPool();
        v1.positionScreen.copy(vertices.$index(v).get$position());
        this._projScreenobjectMatrixWorld.multiplyVector4(v1.positionScreen);
        v2 = this._vertexPool.$index(this._vertexCount - (2));
        this._clippedVertex1PositionScreen.copy(v1.positionScreen);
        this._clippedVertex2PositionScreen.copy(v2.positionScreen);
        if (this.clipLine(this._clippedVertex1PositionScreen, this._clippedVertex2PositionScreen)) {
          this._clippedVertex1PositionScreen.multiplyScalar((1) / this._clippedVertex1PositionScreen.get$w());
          this._clippedVertex2PositionScreen.multiplyScalar((1) / this._clippedVertex2PositionScreen.get$w());
          this._line = this.getNextLineInPool();
          this._line.v1.positionScreen.copy(this._clippedVertex1PositionScreen);
          this._line.v2.positionScreen.copy(this._clippedVertex2PositionScreen);
          this._line.z = Math.max(this._clippedVertex1PositionScreen.get$z(), this._clippedVertex2PositionScreen.get$z());
          this._line.material = objectMaterial;
          this._renderData.elements.add(this._line);
        }
      }
    }
  }
  ol = this._renderData.sprites.get$length();
  for (o = (0);
   o < ol; o++) {
    object = this._renderData.sprites.$index(o).get$object();
    objectMatrixWorld = object.matrixWorld;
    if ((object instanceof Particle)) {
      this._vector4.setValues(objectMatrixWorld.n14, objectMatrixWorld.n24, objectMatrixWorld.n34, (1));
      this._projScreenMatrix.multiplyVector4(this._vector4);
      ($2 = this._vector4).set$z($2.get$z() / this._vector4.get$w());
      if (this._vector4.get$z() > (0) && this._vector4.get$z() < (1)) {
        this._particle = this.getNextParticleInPool();
        this._particle.x = this._vector4.get$x() / this._vector4.get$w();
        this._particle.y = this._vector4.get$y() / this._vector4.get$w();
        this._particle.z = this._vector4.get$z();
        this._particle.rotation = object.rotation.get$z();
        this._particle.scale.set$x(object.scale.get$x() * (this._particle.x - (this._vector4.get$x() + camera.projectionMatrix.n11) / (this._vector4.get$w() + camera.projectionMatrix.n14)).abs());
        this._particle.scale.set$y(object.scale.get$y() * (this._particle.y - (this._vector4.get$y() + camera.projectionMatrix.n22) / (this._vector4.get$w() + camera.projectionMatrix.n24)).abs());
        this._particle.material = object.get$material();
        this._renderData.elements.add(this._particle);
      }
    }
  }
  if (sort) {
    this._renderData.elements.sort$1(this.get$painterSort());
  }
  return this._renderData;
}
Projector.prototype.getNextObjectInPool = function() {
  var object;
  if (this._objectCount < this._objectPool.get$length()) {
    object = ($ne$(this._objectPool.$index(this._objectCount))) ? this._objectPool.$index(this._objectCount) : new RenderableObject();
  }
  else {
    object = new RenderableObject();
    this._objectPool.add(object);
  }
  this._objectCount++;
  return object;
}
Projector.prototype.getNextVertexInPool = function() {
  var vertex;
  if (this._vertexCount < this._vertexPool.get$length()) {
    vertex = ($ne$(this._vertexPool.$index(this._vertexCount))) ? this._vertexPool.$index(this._vertexCount) : new RenderableVertex();
  }
  else {
    vertex = new RenderableVertex();
    this._vertexPool.add(vertex);
  }
  this._vertexCount++;
  return vertex;
}
Projector.prototype.getNextFace3InPool = function() {
  var face;
  if (this._face3Count < this._face3Pool.get$length()) {
    face = ($ne$(this._face3Pool.$index(this._face3Count))) ? this._face3Pool.$index(this._face3Count) : new RenderableFace3();
  }
  else {
    face = new RenderableFace3();
    this._face3Pool.add(face);
  }
  this._face3Count++;
  return face;
}
Projector.prototype.getNextFace4InPool = function() {
  var face;
  if (this._face4Count < this._face4Pool.get$length()) {
    face = ($ne$(this._face4Pool.$index(this._face4Count))) ? this._face4Pool.$index(this._face4Count) : new RenderableFace4();
  }
  else {
    face = new RenderableFace4();
    this._face4Pool.add(face);
  }
  this._face4Count++;
  return face;
}
Projector.prototype.getNextLineInPool = function() {
  var line;
  if (this._lineCount < this._linePool.get$length()) {
    line = ($ne$(this._linePool.$index(this._lineCount))) ? this._linePool.$index(this._lineCount) : new RenderableLine();
  }
  else {
    line = new RenderableLine();
    this._linePool.add(line);
  }
  this._lineCount++;
  return line;
}
Projector.prototype.getNextParticleInPool = function() {
  var particle;
  if (this._particleCount < this._particlePool.get$length()) {
    particle = ($ne$(this._particlePool.$index(this._particleCount))) ? this._particlePool.$index(this._particleCount) : new RenderableParticle();
  }
  else {
    particle = new RenderableParticle();
    this._particlePool.add(particle);
  }
  this._particleCount++;
  return particle;
}
Projector.prototype.painterSort = function(a, b) {
  return $sub$(b.get$z(), a.get$z());
}
Projector.prototype.get$painterSort = function() {
  return this.painterSort.bind(this);
}
Projector.prototype.clipLine = function(s1, s2) {
  var alpha1 = (0), alpha2 = (1), bc1near = s1.get$z() + s1.get$w(), bc2near = s2.get$z() + s2.get$w(), bc1far = -s1.get$z() + s1.get$w(), bc2far = -s2.get$z() + s2.get$w();
  if (bc1near >= (0) && bc2near >= (0) && bc1far >= (0) && bc2far >= (0)) {
    return true;
  }
  else if ((bc1near < (0) && bc2near < (0)) || (bc1far < (0) && bc2far < (0))) {
    return false;
  }
  else {
    if (bc1near < (0)) {
      alpha1 = Math.max(alpha1, bc1near / (bc1near - bc2near));
    }
    else if (bc2near < (0)) {
      alpha2 = Math.min(alpha2, bc1near / (bc1near - bc2near));
    }
    if (bc1far < (0)) {
      alpha1 = Math.max(alpha1, bc1far / (bc1far - bc2far));
    }
    else if (bc2far < (0)) {
      alpha2 = Math.min(alpha2, bc1far / (bc1far - bc2far));
    }
    if (alpha2 < alpha1) {
      return false;
    }
    else {
      s1.lerpSelf(s2, alpha1);
      s2.lerpSelf(s1, (1) - alpha2);
      return true;
    }
  }
}
// ********** Code for ProjectorRenderData **************
function ProjectorRenderData() {
  this.objects = [];
  this.sprites = [];
  this.lights = [];
  this.elements = [];
}
// ********** Code for Vector2 **************
function Vector2(_x, _y) {
  this._y = _y;
  this._x = _x;
}
Vector2.prototype.get$x = function() {
  return this._x;
}
Vector2.prototype.set$x = function(value) {
  this._x = value;
}
Vector2.prototype.get$y = function() {
  return this._y;
}
Vector2.prototype.set$y = function(value) {
  this._y = value;
}
Vector2.prototype.lengthSq = function() {
  return this._x * this._x + this._y * this._y;
}
Vector2.prototype.length = function() {
  return Math.sqrt(this.lengthSq());
}
Vector2.prototype.get$length = function() {
  return this.length.bind(this);
}
// ********** Code for UV **************
function UV(u, v) {
  this._u = (u != null) ? u : (0);
  this._v = (v != null) ? v : (0);
}
UV.prototype.get$u = function() {
  return this._u;
}
UV.prototype.get$v = function() {
  return this._v;
}
// ********** Code for Rectangle **************
function Rectangle() {
  this._isEmpty = true;
}
Rectangle.prototype.resize = function() {
  this._width = this._right - this._left;
  this._height = this._bottom - this._top;
}
Rectangle.prototype.getX = function() {
  return this._left;
}
Rectangle.prototype.getY = function() {
  return this._top;
}
Rectangle.prototype.getWidth = function() {
  return this._width;
}
Rectangle.prototype.getHeight = function() {
  return this._height;
}
Rectangle.prototype.getLeft = function() {
  return this._left;
}
Rectangle.prototype.getTop = function() {
  return this._top;
}
Rectangle.prototype.getRight = function() {
  return this._right;
}
Rectangle.prototype.getBottom = function() {
  return this._bottom;
}
Rectangle.prototype.setValues = function(left, top, right, bottom) {
  this._isEmpty = false;
  this._left = left;
  this._top = top;
  this._right = right;
  this._bottom = bottom;
  this.resize();
}
Rectangle.prototype.addPoint = function(x, y) {
  if (this._isEmpty) {
    this._isEmpty = false;
    this._left = x;
    this._top = y;
    this._right = x;
    this._bottom = y;
    this.resize();
  }
  else {
    this._left = this._left < x ? this._left : x;
    this._top = this._top < y ? this._top : y;
    this._right = this._right > x ? this._right : x;
    this._bottom = this._bottom > y ? this._bottom : y;
    this.resize();
  }
}
Rectangle.prototype.add3Points = function(x1, y1, x2, y2, x3, y3) {
  if (this._isEmpty) {
    this._isEmpty = false;
    this._left = x1 < x2 ? (x1 < x3 ? x1 : x3) : (x2 < x3 ? x2 : x3);
    this._top = y1 < y2 ? (y1 < y3 ? y1 : y3) : (y2 < y3 ? y2 : y3);
    this._right = x1 > x2 ? (x1 > x3 ? x1 : x3) : (x2 > x3 ? x2 : x3);
    this._bottom = y1 > y2 ? (y1 > y3 ? y1 : y3) : (y2 > y3 ? y2 : y3);
    this.resize();
  }
  else {
    this._left = x1 < x2 ? (x1 < x3 ? (x1 < this._left ? x1 : this._left) : (x3 < this._left ? x3 : this._left)) : (x2 < x3 ? (x2 < this._left ? x2 : this._left) : (x3 < this._left ? x3 : this._left));
    this._top = y1 < y2 ? (y1 < y3 ? (y1 < this._top ? y1 : this._top) : (y3 < this._top ? y3 : this._top)) : (y2 < y3 ? (y2 < this._top ? y2 : this._top) : (y3 < this._top ? y3 : this._top));
    this._right = x1 > x2 ? (x1 > x3 ? (x1 > this._right ? x1 : this._right) : (x3 > this._right ? x3 : this._right)) : (x2 > x3 ? (x2 > this._right ? x2 : this._right) : (x3 > this._right ? x3 : this._right));
    this._bottom = y1 > y2 ? (y1 > y3 ? (y1 > this._bottom ? y1 : this._bottom) : (y3 > this._bottom ? y3 : this._bottom)) : (y2 > y3 ? (y2 > this._bottom ? y2 : this._bottom) : (y3 > this._bottom ? y3 : this._bottom));
    this.resize();
  }
}
Rectangle.prototype.addRectangle = function(r) {
  if (this._isEmpty) {
    this._isEmpty = false;
    this._left = r.getLeft();
    this._top = r.getTop();
    this._right = r.getRight();
    this._bottom = r.getBottom();
    this.resize();
  }
  else {
    this._left = this._left < r.getLeft() ? this._left : r.getLeft();
    this._top = this._top < r.getTop() ? this._top : r.getTop();
    this._right = this._right > r.getRight() ? this._right : r.getRight();
    this._bottom = this._bottom > r.getBottom() ? this._bottom : r.getBottom();
    this.resize();
  }
}
Rectangle.prototype.inflate = function(v) {
  this._left = this._left - v;
  this._top = this._top - v;
  this._right = this._right + v;
  this._bottom = this._bottom + v;
  this.resize();
}
Rectangle.prototype.minSelf = function(r) {
  this._left = this._left > r.getLeft() ? this._left : r.getLeft();
  this._top = this._top > r.getTop() ? this._top : r.getTop();
  this._right = this._right < r.getRight() ? this._right : r.getRight();
  this._bottom = this._bottom < r.getBottom() ? this._bottom : r.getBottom();
  this.resize();
}
Rectangle.prototype.intersects = function(r) {
  if (this._right < r.getLeft()) return false;
  if (this._left > r.getRight()) return false;
  if (this._bottom < r.getTop()) return false;
  if (this._top > r.getBottom()) return false;
  return true;
}
Rectangle.prototype.empty = function() {
  this._isEmpty = true;
  this._left = (0);
  this._top = (0);
  this._right = (0);
  this._bottom = (0);
  this.resize();
}
Rectangle.prototype.isEmpty = function() {
  return this._isEmpty;
}
// ********** Code for CubeGeometry **************
$inherits(CubeGeometry, Geometry);
function CubeGeometry(width, height, depth, segmentsWidth, segmentsHeight, segmentsDepth, materials, sides) {
  Geometry.call(this);
  var width_half = width / (2), height_half = height / (2), depth_half = depth / (2);
  var mpx, mpy, mpz, mnx, mny, mnz;
  if (null != materials) {
    if (!!(materials && materials.is$List())) {
      this._materials = materials;
    }
    else {
      this._materials = [];
      for (var i = (0);
       i < (6); i++) {
        this._materials.add(materials);
      }
    }
    mpx = (0);
    mnx = (1);
    mpy = (2);
    mny = (3);
    mpz = (4);
    mnz = (5);
  }
  else {
    this._materials = [];
  }
  this._sides = new CubeGeomSides(true, true, true, true, true, true);
  if (sides != null) {
    for (var $$i = sides.iterator(); $$i.hasNext(); ) {
      var s = $$i.next();
      if (null != this._sides.get$dynamic().$index(s)) {
        this._sides.get$dynamic().$setindex(s, sides.$index(s));
      }
    }
  }
  if (this._sides.px) this.buildPlane("z", "y", (-1), (-1), depth, height, width_half, mpx);
  if (this._sides.nx) this.buildPlane("z", "y", (1), (-1), depth, height, -width_half, mnx);
  if (this._sides.py) this.buildPlane("x", "z", (1), (1), width, depth, height_half, mpy);
  if (this._sides.ny) this.buildPlane("x", "z", (1), (-1), width, depth, -height_half, mny);
  if (this._sides.pz) this.buildPlane("x", "y", (1), (-1), width, height, depth_half, mpz);
  if (this._sides.nz) this.buildPlane("x", "y", (-1), (-1), width, height, -depth_half, mnz);
  this.computeCentroids();
  this.mergeVertices();
}
CubeGeometry.prototype.buildPlane = function(u, v, udir, vdir, width, height, depth, material) {
  var w;
  var ix, iy, gridX = (this.segmentsWidth != null) ? this.segmentsWidth : (1), gridY = (this.segmentsHeight != null) ? this.segmentsHeight : (1), width_half = width / (2), height_half = height / (2), offset = this.get$vertices().get$length();
  if (((null == u ? null == ("x") : u === "x") && (null == v ? null == ("y") : v === "y")) || ((null == u ? null == ("y") : u === "y") && (null == v ? null == ("x") : v === "x"))) {
    w = "z";
  }
  else if (((null == u ? null == ("x") : u === "x") && (null == v ? null == ("z") : v === "z")) || ((null == u ? null == ("z") : u === "z") && (null == v ? null == ("x") : v === "x"))) {
    w = "y";
    gridY = (this.segmentsDepth != null) ? this.segmentsDepth : (1);
  }
  else if (((null == u ? null == ("z") : u === "z") && (null == v ? null == ("y") : v === "y")) || ((null == u ? null == ("y") : u === "y") && (null == v ? null == ("z") : v === "z"))) {
    w = "x";
    gridX = (this.segmentsDepth != null) ? this.segmentsDepth : (1);
  }
  var gridX1 = gridX + (1), gridY1 = gridY + (1), segment_width = width / gridX, segment_height = height / gridY;
  var normal = new Vector3((0), (0), (0));
  if (w == "x") normal.set$x(depth > (0) ? (1) : (-1));
  else if (w == "y") normal.set$y(depth > (0) ? (1) : (-1));
  else if (w == "z") normal.set$z(depth > (0) ? (1) : (-1));
  for (iy = (0);
   iy < gridY1; iy++) {
    for (ix = (0);
     ix < gridX1; ix++) {
      var vector = new Vector3((0), (0), (0));
      if (u == "x") vector.set$x((ix * segment_width - width_half) * udir);
      else if (u == "y") vector.set$y((ix * segment_width - width_half) * udir);
      else if (u == "z") vector.set$z((ix * segment_width - width_half) * udir);
      if (v == "x") vector.set$x((iy * segment_height - height_half) * vdir);
      else if (v == "y") vector.set$y((iy * segment_height - height_half) * vdir);
      else if (v == "z") vector.set$z((iy * segment_height - height_half) * vdir);
      if (w == "x") vector.set$x(depth);
      else if (w == "y") vector.set$y(depth);
      else if (w == "z") vector.set$z(depth);
      this.get$vertices().add(new Vertex(vector));
    }
  }
  for (iy = (0);
   iy < gridY; iy++) {
    for (ix = (0);
     ix < gridX; ix++) {
      var a = ix + gridX1 * iy;
      var b = ix + gridX1 * (iy + (1));
      var c = (ix + (1)) + gridX1 * (iy + (1));
      var d = (ix + (1)) + gridX1 * iy;
      var face = new Face4(a + offset, b + offset, c + offset, d + offset);
      face.get$normal().copy(normal);
      face.get$vertexNormals().addAll([normal.clone(), normal.clone(), normal.clone(), normal.clone()]);
      face.set$materialIndex(material);
      this.get$faces().add(face);
      var faceVertexUV = this.get$faceVertexUvs().$index((0));
      var newUVs = new Array();
      newUVs.addAll([new UV(ix / gridX, iy / gridY), new UV(ix / gridX, (iy + (1)) / gridY), new UV((ix + (1)) / gridX, (iy + (1)) / gridY), new UV((ix + (1)) / gridX, iy / gridY)]);
      faceVertexUV.add(newUVs);
    }
  }
}
// ********** Code for CubeGeomSides **************
function CubeGeomSides(px, nx, py, ny, pz, nz) {
  this.pz = pz;
  this.nx = nx;
  this.ny = ny;
  this.py = py;
  this.nz = nz;
  this.px = px;
}
// ********** Code for AmbientLight **************
function AmbientLight() {}
// ********** Code for Light **************
$inherits(Light, Object3D);
function Light() {}
Light.prototype.get$color = function() { return this.color; };
// ********** Code for DirectionalLight **************
$inherits(DirectionalLight, Light);
function DirectionalLight() {}
DirectionalLight.prototype.get$intensity = function() {
  return this._intensity;
}
// ********** Code for PointLight **************
$inherits(PointLight, Light);
function PointLight() {}
PointLight.prototype.get$intensity = function() {
  return this._intensity;
}
PointLight.prototype.get$distance = function() {
  return this._distance;
}
// ********** Code for Material **************
function Material(parameters) {
  var $0;
  var _parameters = parameters != null ? parameters : new HashMapImplementation();
  this._name = "";
  this._id = ($globals.Three_MaterialCount = ($0 = $globals.Three_MaterialCount) + (1), $0);
  this._opacity = null != _parameters.$index("opacity") ? _parameters.$index("opacity") : (1);
  this._transparent = null != _parameters.$index("transparent") ? _parameters.$index("transparent") : false;
  this._blending = null != _parameters.$index("blending") ? _parameters.$index("blending") : $globals.Three_NormalBlending;
  this._depthTest = null != _parameters.$index("depthTest") ? _parameters.$index("depthTest") : true;
  this._depthWrite = null != _parameters.$index("depthWrite") ? _parameters.$index("depthWrite") : true;
  this._polygonOffset = null != _parameters.$index("polygonOffset") ? _parameters.$index("polygonOffset") : false;
  this._polygonOffsetFactor = null != _parameters.$index("polygonOffsetFactor") ? _parameters.$index("polygonOffsetFactor") : (0);
  this._polygonOffsetUnits = null != _parameters.$index("polygonOffsetUnits") ? _parameters.$index("polygonOffsetUnits") : (0);
  this._alphaTest = null != _parameters.$index("alphaTest") ? _parameters.$index("alphaTest") : (0);
  this._overdraw = null != _parameters.$index("overdraw") ? _parameters.$index("overdraw") : false;
}
Material.prototype.get$opacity = function() {
  return this._opacity;
}
Material.prototype.get$overdraw = function() {
  return this._overdraw;
}
Material.prototype.get$blending = function() {
  return this._blending;
}
// ********** Code for MeshBasicMaterial **************
$inherits(MeshBasicMaterial, Material);
function MeshBasicMaterial(parameters) {
  Material.call(this, parameters);
  parameters = parameters != null ? parameters : new HashMapImplementation();
  this._color = null != parameters.$index("color") ? new Color(parameters.$index("color")) : new Color((16777215));
  this._ThreeD_map = null != parameters.$index("map") ? parameters.$index("map") : null;
  this._lightMap = null != parameters.$index("lightMap") ? parameters.$index("lightMap") : null;
  this._envMap = null != parameters.$index("envMap") ? parameters.$index("envMap") : null;
  this._combine = null != parameters.$index("combine") ? parameters.$index("combine") : $globals.Three_MultiplyOperation;
  this._reflectivity = null != parameters.$index("reflectivity") ? parameters.$index("reflectivity") : (1);
  this._refractionRatio = null != parameters.$index("refractionRatio") ? parameters.$index("refractionRatio") : (0.98);
  this._fog = null != parameters.$index("fog") ? parameters.$index("fog") : true;
  this._shading = null != parameters.$index("shading") ? parameters.$index("shading") : $globals.Three_SmoothShading;
  this._wireframe = null != parameters.$index("wireframe") ? parameters.$index("wireframe") : false;
  this._wireframeLinewidth = null != parameters.$index("wireframeLinewidth") ? parameters.$index("wireframeLinewidth") : (1);
  this._wireframeLinecap = null != parameters.$index("wireframeLinecap") ? parameters.$index("wireframeLinecap") : "round";
  this._wireframeLinejoin = null != parameters.$index("wireframeLinejoin") ? parameters.$index("wireframeLinejoin") : "round";
  this._vertexColors = null != parameters.$index("vertexColors") ? parameters.$index("vertexColors") : false;
  this._skinning = null != parameters.$index("skinning") ? parameters.$index("skinning") : false;
  this._morphTargets = null != parameters.$index("morphTargets") ? parameters.$index("morphTargets") : false;
}
MeshBasicMaterial.prototype.is$ITextureMapMaterial = function(){return true};
MeshBasicMaterial.prototype.get$map = function() {
  return this._ThreeD_map;
}
MeshBasicMaterial.prototype.get$envMap = function() {
  return this._envMap;
}
MeshBasicMaterial.prototype.get$color = function() {
  return this._color;
}
MeshBasicMaterial.prototype.get$wireframe = function() {
  return this._wireframe;
}
MeshBasicMaterial.prototype.get$wireframeLinewidth = function() {
  return this._wireframeLinewidth;
}
MeshBasicMaterial.prototype.get$wireframeLinecap = function() {
  return this._wireframeLinecap;
}
MeshBasicMaterial.prototype.get$wireframeLinejoin = function() {
  return this._wireframeLinejoin;
}
// ********** Code for MeshFaceMaterial **************
function MeshFaceMaterial() {}
// ********** Code for ParticleBasicMaterial **************
$inherits(ParticleBasicMaterial, Material);
function ParticleBasicMaterial() {}
// ********** Code for ParticleCanvasMaterial **************
$inherits(ParticleCanvasMaterial, Material);
function ParticleCanvasMaterial() {}
ParticleCanvasMaterial.prototype.get$color = function() { return this.color; };
ParticleCanvasMaterial.prototype.program$1 = function($0) {
  return this.program.call$1($0);
};
// ********** Code for LineBasicMaterial **************
$inherits(LineBasicMaterial, Material);
function LineBasicMaterial() {}
LineBasicMaterial.prototype.get$linewidth = function() {
  return this._linewidth;
}
LineBasicMaterial.prototype.get$linecap = function() {
  return this._linecap;
}
LineBasicMaterial.prototype.get$linejoin = function() {
  return this._linejoin;
}
LineBasicMaterial.prototype.get$color = function() {
  return this._color;
}
// ********** Code for MeshLambertMaterial **************
$inherits(MeshLambertMaterial, Material);
function MeshLambertMaterial() {}
MeshLambertMaterial.prototype.is$ITextureMapMaterial = function(){return true};
MeshLambertMaterial.prototype.get$map = function() {
  return this._map;
}
MeshLambertMaterial.prototype.get$color = function() {
  return this._color;
}
MeshLambertMaterial.prototype.get$wireframe = function() {
  return this._wireframe;
}
MeshLambertMaterial.prototype.get$wireframeLinewidth = function() {
  return this._wireframeLinewidth;
}
MeshLambertMaterial.prototype.get$wireframeLinecap = function() {
  return this._wireframeLinecap;
}
MeshLambertMaterial.prototype.get$wireframeLinejoin = function() {
  return this._wireframeLinejoin;
}
MeshLambertMaterial.prototype.get$shading = function() {
  return this._shading;
}
// ********** Code for MeshDepthMaterial **************
$inherits(MeshDepthMaterial, Material);
function MeshDepthMaterial() {}
// ********** Code for MeshNormalMaterial **************
$inherits(MeshNormalMaterial, Material);
function MeshNormalMaterial(parameters) {
  Material.call(this, parameters);
  var _parameters = parameters != null ? parameters : new HashMapImplementation();
  this._shading = _parameters.$index("shading") ? _parameters.$index("shading") : $globals.Three_FlatShading;
  this._wireframe = _parameters.$index("wireframe") ? _parameters.$index("wireframe") : false;
  this._wireframeLinewidth = _parameters.$index("wireframeLinewidth") ? _parameters.$index("wireframeLinewidth") : (1);
}
MeshNormalMaterial.prototype.get$wireframe = function() {
  return this._wireframe;
}
MeshNormalMaterial.prototype.get$wireframeLinewidth = function() {
  return this._wireframeLinewidth;
}
MeshNormalMaterial.prototype.get$wireframeLinecap = function() {
  return this._wireframeLinecap;
}
MeshNormalMaterial.prototype.get$wireframeLinejoin = function() {
  return this._wireframeLinejoin;
}
// ********** Code for Bone **************
function Bone() {}
// ********** Code for Mesh **************
$inherits(Mesh, Object3D);
function Mesh(geometry, material) {
  Object3D.call(this);
  this._geometry = geometry;
  this._material = material;
  if (!!(material && material.is$List())) {
  }
  if (this._geometry != null) {
    if (this._geometry.get$boundingSphere() == null) {
      this._geometry.computeBoundingSphere();
    }
    this._boundRadius = geometry.get$boundingSphere().$index("radius");
    if (this._geometry.get$morphTargets().get$length() != (0)) {
      this._morphTargetBase = (-1);
      this._morphTargetForcedOrder = [];
      this._morphTargetInfluences = [];
      this._morphTargetDictionary = new HashMapImplementation();
      for (var m = (0);
       m < this._geometry.get$morphTargets().get$length(); m++) {
        this._morphTargetInfluences.add((0));
        this._morphTargetDictionary.$setindex(this._geometry.get$morphTargets().$index(m).get$name(), m);
      }
    }
  }
}
Mesh.prototype.get$geometry = function() {
  return this._geometry;
}
Mesh.prototype.get$material = function() {
  return this._material;
}
// ********** Code for Line **************
$inherits(Line, Object3D);
function Line() {}
Line.prototype.get$geometry = function() {
  return this._geometry;
}
Line.prototype.get$material = function() {
  return this._material;
}
// ********** Code for Particle **************
$inherits(Particle, Object3D);
function Particle() {}
Particle.prototype.get$material = function() { return this.material; };
// ********** Code for Sprite **************
function Sprite() {}
// ********** Code for RenderableObject **************
function RenderableObject() {
  this.object = null;
  this.z = null;
}
RenderableObject.prototype.get$object = function() { return this.object; };
RenderableObject.prototype.get$z = function() { return this.z; };
// ********** Code for RenderableVertex **************
function RenderableVertex() {
  this.visible = true;
  this.positionWorld = new Vector3((0), (0), (0));
  this.positionScreen = new Vector4((0), (0), (0), (1));
}
RenderableVertex.prototype.copy = function(vertex) {
  this.positionWorld.copy(vertex.positionWorld);
  this.positionScreen.copy(vertex.positionScreen);
}
// ********** Code for RenderableFace3 **************
function RenderableFace3() {
  this._v1 = new RenderableVertex();
  this._v2 = new RenderableVertex();
  this._v3 = new RenderableVertex();
  this._centroidWorld = new Vector3((0), (0), (0));
  this._centroidScreen = new Vector3((0), (0), (0));
  this._normalWorld = new Vector3((0), (0), (0));
  this._vertexNormalsWorld = [new Vector3((0), (0), (0)), new Vector3((0), (0), (0)), new Vector3((0), (0), (0))];
  this._material = null;
  this._faceMaterial = null;
  this._uvs = [[]];
  this._z = null;
}
RenderableFace3.prototype.get$v1 = function() {
  return this._v1;
}
RenderableFace3.prototype.get$v2 = function() {
  return this._v2;
}
RenderableFace3.prototype.get$v3 = function() {
  return this._v3;
}
RenderableFace3.prototype.get$normalWorld = function() {
  return this._normalWorld;
}
RenderableFace3.prototype.get$centroidWorld = function() {
  return this._centroidWorld;
}
RenderableFace3.prototype.get$centroidScreen = function() {
  return this._centroidScreen;
}
RenderableFace3.prototype.get$vertexNormalsWorld = function() {
  return this._vertexNormalsWorld;
}
RenderableFace3.prototype.get$uvs = function() {
  return this._uvs;
}
RenderableFace3.prototype.get$material = function() {
  return this._material;
}
RenderableFace3.prototype.get$faceMaterial = function() {
  return this._faceMaterial;
}
RenderableFace3.prototype.get$z = function() {
  return this._z;
}
// ********** Code for RenderableFace4 **************
function RenderableFace4() {
  this._v1 = new RenderableVertex();
  this._v2 = new RenderableVertex();
  this._v3 = new RenderableVertex();
  this._v4 = new RenderableVertex();
  this._centroidWorld = new Vector3((0), (0), (0));
  this._centroidScreen = new Vector3((0), (0), (0));
  this._normalWorld = new Vector3((0), (0), (0));
  this._vertexNormalsWorld = [new Vector3((0), (0), (0)), new Vector3((0), (0), (0)), new Vector3((0), (0), (0)), new Vector3((0), (0), (0))];
  this._material = null;
  this._faceMaterial = null;
  this._uvs = [];
  this._uvs.add(new Array());
  this._z = null;
}
RenderableFace4.prototype.get$v1 = function() {
  return this._v1;
}
RenderableFace4.prototype.get$v2 = function() {
  return this._v2;
}
RenderableFace4.prototype.get$v3 = function() {
  return this._v3;
}
RenderableFace4.prototype.get$v4 = function() {
  return this._v4;
}
RenderableFace4.prototype.get$normalWorld = function() {
  return this._normalWorld;
}
RenderableFace4.prototype.get$centroidWorld = function() {
  return this._centroidWorld;
}
RenderableFace4.prototype.get$centroidScreen = function() {
  return this._centroidScreen;
}
RenderableFace4.prototype.get$vertexNormalsWorld = function() {
  return this._vertexNormalsWorld;
}
RenderableFace4.prototype.get$uvs = function() {
  return this._uvs;
}
RenderableFace4.prototype.get$material = function() {
  return this._material;
}
RenderableFace4.prototype.set$material = function(value) {
  this._material = value;
}
RenderableFace4.prototype.get$faceMaterial = function() {
  return this._faceMaterial;
}
RenderableFace4.prototype.set$faceMaterial = function(value) {
  this._faceMaterial = value;
}
RenderableFace4.prototype.get$z = function() {
  return this._z;
}
RenderableFace4.prototype.set$z = function(value) {
  this._z = value;
}
// ********** Code for RenderableLine **************
function RenderableLine() {
  this.material = null;
  this.z = null;
  this.v1 = new RenderableVertex();
  this.v2 = new RenderableVertex();
}
RenderableLine.prototype.get$z = function() { return this.z; };
RenderableLine.prototype.get$v1 = function() { return this.v1; };
RenderableLine.prototype.get$v2 = function() { return this.v2; };
RenderableLine.prototype.get$material = function() { return this.material; };
// ********** Code for RenderableParticle **************
function RenderableParticle() {
  this.material = null;
  this.x = null;
  this.y = null;
  this.rotation = null;
  this.z = null;
  this.scale = new Vector2((0), (0));
}
RenderableParticle.prototype.get$x = function() { return this.x; };
RenderableParticle.prototype.get$y = function() { return this.y; };
RenderableParticle.prototype.get$z = function() { return this.z; };
RenderableParticle.prototype.get$rotation = function() { return this.rotation; };
RenderableParticle.prototype.get$scale = function() { return this.scale; };
RenderableParticle.prototype.get$material = function() { return this.material; };
// ********** Code for CanvasRenderer **************
function CanvasRenderer(parameters) {
  var $0, $1;
  this._pi2 = (6.283185307179586);
  parameters = parameters != null ? parameters : new HashMapImplementation();
  this._projector = new Projector();
  this._canvas = $ne$(parameters.$index("canvas")) ? parameters.$index("canvas") : ElementWrappingImplementation.ElementWrappingImplementation$tag$factory("canvas");
  this._context = this._canvas.getContext("2d");
  this.debug = $ne$(parameters.$index("debug")) ? parameters.$index("debug") : false;
  this._clearColor = new Color((0));
  this._clearOpacity = (0);
  this._contextGlobalAlpha = (1);
  this._contextGlobalCompositeOperation = (0);
  this._contextStrokeStyle = null;
  this._contextFillStyle = null;
  this._contextLineWidth = null;
  this._contextLineCap = null;
  this._contextLineJoin = null;
  this._v5 = new RenderableVertex();
  this._v6 = new RenderableVertex();
  this._color = new Color();
  this._color1 = new Color();
  this._color2 = new Color();
  this._color3 = new Color();
  this._color4 = new Color();
  this._patterns = [];
  this._imagedatas = [];
  this._clipRect = new Rectangle();
  this._clearRect = new Rectangle();
  this._bboxRect = new Rectangle();
  this._enableLighting = false;
  this._ambientLight = new Color();
  this._directionalLights = new Color();
  this._pointLights = new Color();
  this._vector3 = new Vector3((0), (0), (0));
  this._gradientMapQuality = (16);
  this._pixelMap = ElementWrappingImplementation.ElementWrappingImplementation$tag$factory("canvas");
  this._pixelMap.set$width((this._pixelMap.set$height(($0 = (2))), $0));
  this._pixelMapContext = this._pixelMap.getContext("2d");
  this._pixelMapContext.set$fillStyle("rgba(0,0,0,1)");
  this._pixelMapContext.fillRect((0), (0), (2), (2));
  this._pixelMapImage = this._pixelMapContext.getImageData((0), (0), (2), (2));
  this._pixelMapData = this._pixelMapImage.get$data();
  this._gradientMap = ElementWrappingImplementation.ElementWrappingImplementation$tag$factory("canvas");
  this._gradientMap.set$width((this._gradientMap.set$height(($1 = this._gradientMapQuality)), $1));
  this._gradientMapContext = this._gradientMap.getContext("2d");
  this._gradientMapContext.translate(-this._gradientMapQuality / (2), -this._gradientMapQuality / (2));
  this._gradientMapContext.scale(this._gradientMapQuality, this._gradientMapQuality);
  this._gradientMapQuality--;
  this.domElement = this._canvas;
  this._autoClear = true;
  this._sortObjects = true;
  this._sortElements = true;
  this._info = new CanvasRenderData();
}
CanvasRenderer.prototype.setSize = function(width, height) {
  this._canvasWidth = width;
  this._canvasHeight = height;
  this._canvasWidthHalf = (this._canvasWidth / (2)).floor();
  this._canvasHeightHalf = (this._canvasHeight / (2)).floor();
  this._canvas.set$width(this._canvasWidth);
  this._canvas.set$height(this._canvasHeight);
  this._clipRect.setValues(-this._canvasWidthHalf, -this._canvasHeightHalf, this._canvasWidthHalf, this._canvasHeightHalf);
  this._clearRect.setValues(-this._canvasWidthHalf, -this._canvasHeightHalf, this._canvasWidthHalf, this._canvasHeightHalf);
  this._contextGlobalAlpha = (1);
  this._contextGlobalCompositeOperation = (0);
  this._contextStrokeStyle = null;
  this._contextFillStyle = null;
  this._contextLineWidth = null;
  this._contextLineCap = null;
  this._contextLineJoin = null;
}
CanvasRenderer.prototype.clear = function() {
  this._context.setTransform((1), (0), (0), (-1), this._canvasWidthHalf, this._canvasHeightHalf);
  if (!this._clearRect.isEmpty()) {
    this._clearRect.minSelf(this._clipRect);
    this._clearRect.inflate((2));
    if (this._clearOpacity < (1)) {
      this._context.clearRect((this._clearRect.getX()).floor(), (this._clearRect.getY()).floor(), (this._clearRect.getWidth()).floor(), (this._clearRect.getHeight()).floor());
    }
    if (this._clearOpacity > (0)) {
      this.setBlending($globals.Three_NormalBlending);
      this.setOpacity((1));
      this.setFillStyle($add$($add$($add$($add$("rgba(" + (this._clearColor.r * (255)).floor(), ",") + (this._clearColor.g * (255)).floor(), ",") + (this._clearColor.b * (255)).floor(), ",") + this._clearOpacity, ")"));
      this._context.fillRect((this._clearRect.getX()).floor(), (this._clearRect.getY()).floor(), (this._clearRect.getWidth()).floor(), (this._clearRect.getHeight()).floor());
    }
    this._clearRect.empty();
  }
}
CanvasRenderer.prototype.render = function(scene, camera) {
  var $0, $1, $10, $11, $12, $13, $14, $15, $16, $17, $2, $3, $4, $5, $6, $7, $8, $9;
  var e, el;
  var element;
  var material;
  this._camera = camera;
  this._autoClear ? this.clear() : this._context.setTransform((1), (0), (0), (-1), this._canvasWidthHalf, this._canvasHeightHalf);
  this._info.render.reset();
  this._renderData = this._projector.projectScene(scene, camera, this._sortElements);
  this._ThreeD_elements = this._renderData.elements;
  this._lights = this._renderData.lights;
  if (this.debug) {
    this._context.set$fillStyle("rgba( 0, 255, 255, 0.5 )");
    this._context.fillRect(this._clipRect.getX(), this._clipRect.getY(), this._clipRect.getWidth(), this._clipRect.getHeight());
  }
  this._enableLighting = this._lights.get$length() > (0);
  if (this._enableLighting) {
    this.calculateLights(this._lights);
  }
  el = this._ThreeD_elements.get$length();
  for (e = (0);
   e < el; e++) {
    element = this._ThreeD_elements.$index(e);
    material = element.get$material();
    material = (material instanceof MeshFaceMaterial) ? element.get$faceMaterial() : material;
    if (material == null || material.get$opacity() == (0)) continue;
    this._bboxRect.empty();
    var _v1 = null, _v2 = null, _v3 = null, _v4 = null;
    if ((element instanceof RenderableParticle)) {
      var rp = element;
      rp.x = rp.x * this._canvasWidthHalf;
      rp.y = rp.y * this._canvasHeightHalf;
      this.renderParticle(rp, element, material, scene);
    }
    else if ((element instanceof RenderableLine)) {
      _v1 = element.get$v1();
      _v2 = element.get$v2();
      ($0 = _v1.positionScreen).set$x($0.get$x() * this._canvasWidthHalf);
      ($1 = _v1.positionScreen).set$y($1.get$y() * this._canvasHeightHalf);
      ($2 = _v2.positionScreen).set$x($2.get$x() * this._canvasWidthHalf);
      ($3 = _v2.positionScreen).set$y($3.get$y() * this._canvasHeightHalf);
      this._bboxRect.addPoint(_v1.positionScreen.get$x(), _v1.positionScreen.get$y());
      this._bboxRect.addPoint(_v2.positionScreen.get$x(), _v2.positionScreen.get$y());
      if (this._clipRect.intersects(this._bboxRect)) {
        this.renderLine(_v1, _v2, element, material, scene);
      }
    }
    else if ((element instanceof RenderableFace3)) {
      _v1 = element.get$v1();
      _v2 = element.get$v2();
      _v3 = element.get$v3();
      ($4 = _v1.positionScreen).set$x($4.get$x() * this._canvasWidthHalf);
      ($5 = _v1.positionScreen).set$y($5.get$y() * this._canvasHeightHalf);
      ($6 = _v2.positionScreen).set$x($6.get$x() * this._canvasWidthHalf);
      ($7 = _v2.positionScreen).set$y($7.get$y() * this._canvasHeightHalf);
      ($8 = _v3.positionScreen).set$x($8.get$x() * this._canvasWidthHalf);
      ($9 = _v3.positionScreen).set$y($9.get$y() * this._canvasHeightHalf);
      if (material.get$overdraw()) {
        this.expand(_v1.positionScreen, _v2.positionScreen);
        this.expand(_v2.positionScreen, _v3.positionScreen);
        this.expand(_v3.positionScreen, _v1.positionScreen);
      }
      this._bboxRect.add3Points(_v1.positionScreen.get$x(), _v1.positionScreen.get$y(), _v2.positionScreen.get$x(), _v2.positionScreen.get$y(), _v3.positionScreen.get$x(), _v3.positionScreen.get$y());
      if (this._clipRect.intersects(this._bboxRect)) {
        this.renderFace3(_v1, _v2, _v3, (0), (1), (2), element, material, scene);
      }
    }
    else if ((element instanceof RenderableFace4)) {
      _v1 = element.get$v1();
      _v2 = element.get$v2();
      _v3 = element.get$v3();
      _v4 = element.get$v4();
      ($10 = _v1.positionScreen).set$x($10.get$x() * this._canvasWidthHalf);
      ($11 = _v1.positionScreen).set$y($11.get$y() * this._canvasHeightHalf);
      ($12 = _v2.positionScreen).set$x($12.get$x() * this._canvasWidthHalf);
      ($13 = _v2.positionScreen).set$y($13.get$y() * this._canvasHeightHalf);
      ($14 = _v3.positionScreen).set$x($14.get$x() * this._canvasWidthHalf);
      ($15 = _v3.positionScreen).set$y($15.get$y() * this._canvasHeightHalf);
      ($16 = _v4.positionScreen).set$x($16.get$x() * this._canvasWidthHalf);
      ($17 = _v4.positionScreen).set$y($17.get$y() * this._canvasHeightHalf);
      this._v5.positionScreen.copy(_v2.positionScreen);
      this._v6.positionScreen.copy(_v4.positionScreen);
      if (material.get$overdraw()) {
        this.expand(_v1.positionScreen, _v2.positionScreen);
        this.expand(_v2.positionScreen, _v4.positionScreen);
        this.expand(_v4.positionScreen, _v1.positionScreen);
        this.expand(_v3.positionScreen, this._v5.positionScreen);
        this.expand(_v3.positionScreen, this._v6.positionScreen);
      }
      this._bboxRect.addPoint(_v1.positionScreen.get$x(), _v1.positionScreen.get$y());
      this._bboxRect.addPoint(_v2.positionScreen.get$x(), _v2.positionScreen.get$y());
      this._bboxRect.addPoint(_v3.positionScreen.get$x(), _v3.positionScreen.get$y());
      this._bboxRect.addPoint(_v4.positionScreen.get$x(), _v4.positionScreen.get$y());
      if (this._clipRect.intersects(this._bboxRect)) {
        this.renderFace4(_v1, _v2, _v3, _v4, this._v5, this._v6, element, material, scene);
      }
    }
    if (this.debug) {
      this._context.set$lineWidth((1));
      this._context.set$strokeStyle("rgba( 0, 255, 0, 0.5 )");
      this._context.strokeRect(this._bboxRect.getX(), this._bboxRect.getY(), this._bboxRect.getWidth(), this._bboxRect.getHeight());
    }
    this._clearRect.addRectangle(this._bboxRect);
  }
  if (this.debug) {
    this._context.set$lineWidth((1));
    this._context.set$strokeStyle("rgba( 255, 0, 0, 0.5 )");
    this._context.strokeRect(this._clearRect.getX(), this._clearRect.getY(), this._clearRect.getWidth(), this._clearRect.getHeight());
  }
  this._context.setTransform((1), (0), (0), (1), (0), (0));
}
CanvasRenderer.prototype.calculateLights = function(lights) {
  var $0, $1, $2, $3, $4, $5, $6, $7, $8;
  var l, ll;
  var light;
  var lightColor;
  this._ambientLight.setRGB((0), (0), (0));
  this._directionalLights.setRGB((0), (0), (0));
  this._pointLights.setRGB((0), (0), (0));
  ll = lights.get$length();
  for (l = (0);
   l < ll; l++) {
    light = lights.$index(l);
    lightColor = light.color;
    if ((light instanceof AmbientLight)) {
      ($0 = this._ambientLight).r = $0.r + lightColor.r;
      ($1 = this._ambientLight).g = $1.g + lightColor.g;
      ($2 = this._ambientLight).b = $2.b + lightColor.b;
    }
    else if ((light instanceof DirectionalLight)) {
      ($3 = this._directionalLights).r = $3.r + lightColor.r;
      ($4 = this._directionalLights).g = $4.g + lightColor.g;
      ($5 = this._directionalLights).b = $5.b + lightColor.b;
    }
    else if ((light instanceof PointLight)) {
      ($6 = this._pointLights).r = $6.r + lightColor.r;
      ($7 = this._pointLights).g = $7.g + lightColor.g;
      ($8 = this._pointLights).b = $8.b + lightColor.b;
    }
  }
}
CanvasRenderer.prototype.calculateLight = function(lights, position, normal, color) {
  var l, ll;
  var light;
  var lightColor;
  var lightPosition;
  var amount;
  ll = lights.get$length();
  for (l = (0);
   l < ll; l++) {
    light = lights.$index(l);
    lightColor = light.color;
    if ((light instanceof DirectionalLight)) {
      var dLight = light;
      lightPosition = light.matrixWorld.getPosition();
      amount = normal.dot(lightPosition);
      if (amount <= (0)) continue;
      amount *= dLight.get$intensity();
      color.r = color.r + (lightColor.r * amount);
      color.g = color.g + (lightColor.g * amount);
      color.b = color.b + (lightColor.b * amount);
    }
    else if ((light instanceof PointLight)) {
      var pLight = light;
      lightPosition = light.matrixWorld.getPosition();
      amount = normal.dot(this._vector3.sub(lightPosition, position).normalize());
      if (amount <= (0)) continue;
      amount *= (pLight.get$distance() == (0) ? (1) : (1) - Math.min(position.distanceTo(lightPosition) / pLight.get$distance(), (1)));
      if (amount == (0)) continue;
      amount *= pLight.get$intensity();
      color.r = color.r + (lightColor.r * amount);
      color.g = color.g + (lightColor.g * amount);
      color.b = color.b + (lightColor.b * amount);
    }
  }
}
CanvasRenderer.prototype.renderParticle = function(v1, element, material, scene) {
  this.setOpacity(material.get$opacity());
  this.setBlending(material.get$blending());
  var width, height, scaleX, scaleY, bitmapWidth, bitmapHeight;
  var bitmap;
  if ((material instanceof ParticleBasicMaterial)) {
    if (material.get$map()) {
      bitmap = material.get$map().noSuchMethod("get:image", []);
      bitmapWidth = $sar$(bitmap.get$width(), (1));
      bitmapHeight = $sar$(bitmap.get$height(), (1));
      scaleX = $mul$(element.get$scale().get$x(), this._canvasWidthHalf);
      scaleY = $mul$(element.get$scale().get$y(), this._canvasHeightHalf);
      width = scaleX * bitmapWidth;
      height = scaleY * bitmapHeight;
      this._bboxRect.setValues(v1.x - width, v1.y - height, v1.x + width, v1.y + height);
      if (!this._clipRect.intersects(this._bboxRect)) {
        return;
      }
      this._context.save();
      this._context.translate(v1.x, v1.y);
      this._context.rotate($negate$(element.get$rotation()));
      this._context.scale(scaleX, -scaleY);
      this._context.translate(-bitmapWidth, -bitmapHeight);
      this._context.drawImage(bitmap, (0), (0));
      this._context.restore();
    }
    if (this.debug) {
      this._context.beginPath();
      this._context.moveTo(v1.x - (10), v1.y);
      this._context.lineTo(v1.x + (10), v1.y);
      this._context.moveTo(v1.x, v1.y - (10));
      this._context.lineTo(v1.x, v1.y + (10));
      this._context.closePath();
      this._context.set$strokeStyle("rgb(255,255,0)");
      this._context.stroke();
    }
  }
  else if ((material instanceof ParticleCanvasMaterial)) {
    width = $mul$(element.get$scale().get$x(), this._canvasWidthHalf);
    height = $mul$(element.get$scale().get$y(), this._canvasHeightHalf);
    this._bboxRect.setValues(v1.x - width, v1.y - height, v1.x + width, v1.y + height);
    if (!this._clipRect.intersects(this._bboxRect)) {
      return;
    }
    this.setStrokeStyle(material.get$color().getContextStyle());
    this.setFillStyle(material.get$color().getContextStyle());
    this._context.save();
    this._context.translate(v1.x, v1.y);
    this._context.rotate($negate$(element.get$rotation()));
    this._context.scale(width, height);
    material.program$1(this._context);
    this._context.restore();
  }
}
CanvasRenderer.prototype.renderLine = function(v1, v2, element, material, scene) {
  this.setOpacity(material.get$opacity());
  this.setBlending(material.get$blending());
  this._context.beginPath();
  this._context.moveTo(v1.positionScreen.get$x(), v1.positionScreen.get$y());
  this._context.lineTo(v2.positionScreen.get$x(), v2.positionScreen.get$y());
  this._context.closePath();
  if ((material instanceof LineBasicMaterial)) {
    var lbMaterial = material;
    this.setLineWidth(lbMaterial.get$linewidth());
    this.setLineCap(lbMaterial.get$linecap());
    this.setLineJoin(lbMaterial.get$linejoin());
    this.setStrokeStyle(lbMaterial.get$color().getContextStyle());
    this._context.stroke();
    this._bboxRect.inflate(lbMaterial.get$linewidth() * (2));
  }
}
CanvasRenderer.prototype.renderFace3 = function(v1, v2, v3, uv1, uv2, uv3, element, material, scene) {
  var $0, $1, $10, $11, $12, $13, $2, $3, $4, $5, $6, $7, $8, $9;
  ($0 = this._info.render).vertices = $0.vertices + (3);
  ($1 = this._info.render).faces = $1.faces + (1);
  this.setOpacity(material.get$opacity());
  this.setBlending(material.get$blending());
  this._v1x = v1.positionScreen.get$x();
  this._v1y = v1.positionScreen.get$y();
  this._v2x = v2.positionScreen.get$x();
  this._v2y = v2.positionScreen.get$y();
  this._v3x = v3.positionScreen.get$x();
  this._v3y = v3.positionScreen.get$y();
  this.drawTriangle(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y);
  if ((material instanceof MeshBasicMaterial)) {
    var mbMaterial = material;
    if (mbMaterial.get$map() != null) {
      if ((mbMaterial.get$map().get$mapping() instanceof UVMapping)) {
        this._uvs = element.get$uvs().$index((0));
        this.patternPath(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._uvs.$index(uv1).get$u(), this._uvs.$index(uv1).get$v(), this._uvs.$index(uv2).get$u(), this._uvs.$index(uv2).get$v(), this._uvs.$index(uv3).get$u(), this._uvs.$index(uv3).get$v(), mbMaterial.get$map());
      }
    }
    else if (mbMaterial.get$envMap()) {
      if ((mbMaterial.get$envMap().get$mapping() instanceof SphericalReflectionMapping)) {
        var cameraMatrix = this._camera.matrixWorldInverse;
        this._vector3.copy(element.get$vertexNormalsWorld().$index(uv1));
        this._uv1x = (this._vector3.get$x() * cameraMatrix.n11 + this._vector3.get$y() * cameraMatrix.n12 + this._vector3.get$z() * cameraMatrix.n13) * (0.5) + (0.5);
        this._uv1y = -(this._vector3.get$x() * cameraMatrix.n21 + this._vector3.get$y() * cameraMatrix.n22 + this._vector3.get$z() * cameraMatrix.n23) * (0.5) + (0.5);
        this._vector3.copy(element.get$vertexNormalsWorld().$index(uv2));
        this._uv2x = (this._vector3.get$x() * cameraMatrix.n11 + this._vector3.get$y() * cameraMatrix.n12 + this._vector3.get$z() * cameraMatrix.n13) * (0.5) + (0.5);
        this._uv2y = -(this._vector3.get$x() * cameraMatrix.n21 + this._vector3.get$y() * cameraMatrix.n22 + this._vector3.get$z() * cameraMatrix.n23) * (0.5) + (0.5);
        this._vector3.copy(element.get$vertexNormalsWorld().$index(uv3));
        this._uv3x = (this._vector3.get$x() * cameraMatrix.n11 + this._vector3.get$y() * cameraMatrix.n12 + this._vector3.get$z() * cameraMatrix.n13) * (0.5) + (0.5);
        this._uv3y = -(this._vector3.get$x() * cameraMatrix.n21 + this._vector3.get$y() * cameraMatrix.n22 + this._vector3.get$z() * cameraMatrix.n23) * (0.5) + (0.5);
        this.patternPath(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._uv1x, this._uv1y, this._uv2x, this._uv2y, this._uv3x, this._uv3y, mbMaterial.get$envMap());
      }
    }
    else {
      mbMaterial.get$wireframe() ? this.strokePath(mbMaterial.get$color(), mbMaterial.get$wireframeLinewidth(), mbMaterial.get$wireframeLinecap(), mbMaterial.get$wireframeLinejoin()) : this.fillPath(mbMaterial.get$color());
    }
  }
  else if ((material instanceof MeshLambertMaterial)) {
    var mlMaterial = material;
    if (mlMaterial.get$map() != null && !mlMaterial.get$wireframe()) {
      if ((mlMaterial.get$map().get$mapping() instanceof UVMapping)) {
        this._uvs = element.get$uvs().$index((0));
        this.patternPath(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._uvs.$index(uv1).get$u(), this._uvs.$index(uv1).get$v(), this._uvs.$index(uv2).get$u(), this._uvs.$index(uv2).get$v(), this._uvs.$index(uv3).get$u(), this._uvs.$index(uv3).get$v(), mlMaterial.get$map());
      }
      this.setBlending($globals.Three_SubtractiveBlending);
    }
    if (this._enableLighting) {
      if (!mlMaterial.get$wireframe() && mlMaterial.get$shading() == $globals.Three_SmoothShading && element.get$vertexNormalsWorld().get$length() == (3)) {
        this._color1.r = (this._color2.r = ($3 = (this._color3.r = ($2 = this._ambientLight.r), $2)), $3);
        this._color1.g = (this._color2.g = ($5 = (this._color3.g = ($4 = this._ambientLight.g), $4)), $5);
        this._color1.b = (this._color2.b = ($7 = (this._color3.b = ($6 = this._ambientLight.b), $6)), $7);
        this.calculateLight(this._lights, element.get$v1().positionWorld, element.get$vertexNormalsWorld().$index((0)), this._color1);
        this.calculateLight(this._lights, element.get$v2().positionWorld, element.get$vertexNormalsWorld().$index((1)), this._color2);
        this.calculateLight(this._lights, element.get$v3().positionWorld, element.get$vertexNormalsWorld().$index((2)), this._color3);
        this._color1.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color1.r, (1)));
        this._color1.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color1.g, (1)));
        this._color1.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color1.b, (1)));
        this._color2.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color2.r, (1)));
        this._color2.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color2.g, (1)));
        this._color2.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color2.b, (1)));
        this._color3.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color3.r, (1)));
        this._color3.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color3.g, (1)));
        this._color3.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color3.b, (1)));
        this._color4.r = (this._color2.r + this._color3.r) * (0.5);
        this._color4.g = (this._color2.g + this._color3.g) * (0.5);
        this._color4.b = (this._color2.b + this._color3.b) * (0.5);
        this._image = this.getGradientTexture(this._color1, this._color2, this._color3, this._color4);
        this.clipImage(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, (0), (0), (1), (0), (0), (1), this._image);
      }
      else {
        this._color.r = this._ambientLight.r;
        this._color.g = this._ambientLight.g;
        this._color.b = this._ambientLight.b;
        this.calculateLight(this._lights, element.get$centroidWorld(), element.get$normalWorld(), this._color);
        this._color.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color.r, (1)));
        this._color.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color.g, (1)));
        this._color.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color.b, (1)));
        mlMaterial.get$wireframe() ? this.strokePath(this._color, mlMaterial.get$wireframeLinewidth(), mlMaterial.get$wireframeLinecap(), mlMaterial.get$wireframeLinejoin()) : this.fillPath(this._color);
      }
    }
    else {
      mlMaterial.get$wireframe() ? this.strokePath(mlMaterial.get$color(), mlMaterial.get$wireframeLinewidth(), mlMaterial.get$wireframeLinecap(), mlMaterial.get$wireframeLinejoin()) : this.fillPath(mlMaterial.get$color());
    }
  }
  else if ((material instanceof MeshDepthMaterial)) {
    this._near = this._camera.get$near();
    this._far = this._camera.get$far();
    this._color1.r = (this._color1.g = ($9 = (this._color1.b = ($8 = (1) - this.smoothstep(v1.positionScreen.get$z(), this._near, this._far)), $8)), $9);
    this._color2.r = (this._color2.g = ($11 = (this._color2.b = ($10 = (1) - this.smoothstep(v2.positionScreen.get$z(), this._near, this._far)), $10)), $11);
    this._color3.r = (this._color3.g = ($13 = (this._color3.b = ($12 = (1) - this.smoothstep(v3.positionScreen.get$z(), this._near, this._far)), $12)), $13);
    this._color4.r = (this._color2.r + this._color3.r) * (0.5);
    this._color4.g = (this._color2.g + this._color3.g) * (0.5);
    this._color4.b = (this._color2.b + this._color3.b) * (0.5);
    this._image = this.getGradientTexture(this._color1, this._color2, this._color3, this._color4);
    this.clipImage(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, (0), (0), (1), (0), (0), (1), this._image);
  }
  else if ((material instanceof MeshNormalMaterial)) {
    var mnMaterial = material;
    this._color.r = this.normalToComponent(element.get$normalWorld().get$x());
    this._color.g = this.normalToComponent(element.get$normalWorld().get$y());
    this._color.b = this.normalToComponent(element.get$normalWorld().get$z());
    mnMaterial.get$wireframe() ? this.strokePath(this._color, mnMaterial.get$wireframeLinewidth(), mnMaterial.get$wireframeLinecap(), mnMaterial.get$wireframeLinejoin()) : this.fillPath(this._color);
  }
}
CanvasRenderer.prototype.renderFace4 = function(v1, v2, v3, v4, v5, v6, element, material, scene) {
  var $0, $1, $10, $11, $12, $13, $14, $15, $16, $17, $18, $2, $3, $4, $5, $6, $7, $8, $9;
  ($0 = this._info.render).vertices = $0.vertices + (4);
  ($1 = this._info.render).faces = $1.faces + (1);
  this.setOpacity(material.get$opacity());
  this.setBlending(material.get$blending());
  if (!!(material && material.is$ITextureMapMaterial())) {
    this.renderFace3(v1, v2, v4, (0), (1), (3), element, material, scene);
    this.renderFace3(v5, v3, v6, (1), (2), (3), element, material, scene);
    return;
  }
  this._v1x = v1.positionScreen.get$x();
  this._v1y = v1.positionScreen.get$y();
  this._v2x = v2.positionScreen.get$x();
  this._v2y = v2.positionScreen.get$y();
  this._v3x = v3.positionScreen.get$x();
  this._v3y = v3.positionScreen.get$y();
  this._v4x = v4.positionScreen.get$x();
  this._v4y = v4.positionScreen.get$y();
  this._v5x = v5.positionScreen.get$x();
  this._v5y = v5.positionScreen.get$y();
  this._v6x = v6.positionScreen.get$x();
  this._v6y = v6.positionScreen.get$y();
  if ((material instanceof MeshBasicMaterial)) {
    var mbMaterial = material;
    this.drawQuad(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
    mbMaterial.get$wireframe() ? this.strokePath(mbMaterial.get$color(), mbMaterial.get$wireframeLinewidth(), mbMaterial.get$wireframeLinecap(), mbMaterial.get$wireframeLinejoin()) : this.fillPath(mbMaterial.get$color());
  }
  else if ((material instanceof MeshLambertMaterial)) {
    var mlMaterial = material;
    if (this._enableLighting) {
      if (!mlMaterial.get$wireframe() && mlMaterial.get$shading() == $globals.Three_SmoothShading && element.get$vertexNormalsWorld().get$length() == (4)) {
        this._color1.r = (this._color2.r = ($4 = (this._color3.r = ($3 = (this._color4.r = ($2 = this._ambientLight.r), $2)), $3)), $4);
        this._color1.g = (this._color2.g = ($7 = (this._color3.g = ($6 = (this._color4.g = ($5 = this._ambientLight.g), $5)), $6)), $7);
        this._color1.b = (this._color2.b = ($10 = (this._color3.b = ($9 = (this._color4.b = ($8 = this._ambientLight.b), $8)), $9)), $10);
        this.calculateLight(this._lights, element.get$v1().positionWorld, element.get$vertexNormalsWorld().$index((0)), this._color1);
        this.calculateLight(this._lights, element.get$v2().positionWorld, element.get$vertexNormalsWorld().$index((1)), this._color2);
        this.calculateLight(this._lights, element.get$v4().positionWorld, element.get$vertexNormalsWorld().$index((3)), this._color3);
        this.calculateLight(this._lights, element.get$v3().positionWorld, element.get$vertexNormalsWorld().$index((2)), this._color4);
        this._color1.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color1.r, (1)));
        this._color1.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color1.g, (1)));
        this._color1.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color1.b, (1)));
        this._color2.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color2.r, (1)));
        this._color2.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color2.g, (1)));
        this._color2.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color2.b, (1)));
        this._color3.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color3.r, (1)));
        this._color3.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color3.g, (1)));
        this._color3.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color3.b, (1)));
        this._color4.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color4.r, (1)));
        this._color4.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color4.g, (1)));
        this._color4.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color4.b, (1)));
        this._image = this.getGradientTexture(this._color1, this._color2, this._color3, this._color4);
        this.drawTriangle(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y);
        this.clipImage(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y, (0), (0), (1), (0), (0), (1), this._image);
        this.drawTriangle(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y);
        this.clipImage(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y, (1), (0), (1), (1), (0), (1), this._image);
      }
      else {
        this._color.r = this._ambientLight.r;
        this._color.g = this._ambientLight.g;
        this._color.b = this._ambientLight.b;
        this.calculateLight(this._lights, element.get$centroidWorld(), element.get$normalWorld(), this._color);
        this._color.r = Math.max((0), Math.min(mlMaterial.get$color().r * this._color.r, (1)));
        this._color.g = Math.max((0), Math.min(mlMaterial.get$color().g * this._color.g, (1)));
        this._color.b = Math.max((0), Math.min(mlMaterial.get$color().b * this._color.b, (1)));
        this.drawQuad(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
        mlMaterial.get$wireframe() ? this.strokePath(this._color, mlMaterial.get$wireframeLinewidth(), mlMaterial.get$wireframeLinecap(), mlMaterial.get$wireframeLinejoin()) : this.fillPath(this._color);
      }
    }
    else {
      this.drawQuad(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
      mlMaterial.get$wireframe() ? this.strokePath(mlMaterial.get$color(), mlMaterial.get$wireframeLinewidth(), mlMaterial.get$wireframeLinecap(), mlMaterial.get$wireframeLinejoin()) : this.fillPath(mlMaterial.get$color());
    }
  }
  else if ((material instanceof MeshNormalMaterial)) {
    var mnMaterial = material;
    this._color.r = this.normalToComponent(element.get$normalWorld().get$x());
    this._color.g = this.normalToComponent(element.get$normalWorld().get$y());
    this._color.b = this.normalToComponent(element.get$normalWorld().get$z());
    this.drawQuad(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
    mnMaterial.get$wireframe() ? this.strokePath(this._color, mnMaterial.get$wireframeLinewidth(), mnMaterial.get$wireframeLinecap(), mnMaterial.get$wireframeLinejoin()) : this.fillPath(this._color);
  }
  else if ((material instanceof MeshDepthMaterial)) {
    var mdMaterial = material;
    this._near = this._camera.get$near();
    this._far = this._camera.get$far();
    this._color1.r = (this._color1.g = ($12 = (this._color1.b = ($11 = (1) - this.smoothstep(v1.positionScreen.get$z(), this._near, this._far)), $11)), $12);
    this._color2.r = (this._color2.g = ($14 = (this._color2.b = ($13 = (1) - this.smoothstep(v2.positionScreen.get$z(), this._near, this._far)), $13)), $14);
    this._color3.r = (this._color3.g = ($16 = (this._color3.b = ($15 = (1) - this.smoothstep(v4.positionScreen.get$z(), this._near, this._far)), $15)), $16);
    this._color4.r = (this._color4.g = ($18 = (this._color4.b = ($17 = (1) - this.smoothstep(v3.positionScreen.get$z(), this._near, this._far)), $17)), $18);
    this._image = this.getGradientTexture(this._color1, this._color2, this._color3, this._color4);
    this.drawTriangle(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y);
    this.clipImage(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y, (0), (0), (1), (0), (0), (1), this._image);
    this.drawTriangle(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y);
    this.clipImage(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y, (1), (0), (1), (1), (0), (1), this._image);
  }
}
CanvasRenderer.prototype.drawTriangle = function(x0, y0, x1, y1, x2, y2) {
  this._context.beginPath();
  this._context.moveTo(x0, y0);
  this._context.lineTo(x1, y1);
  this._context.lineTo(x2, y2);
  this._context.lineTo(x0, y0);
  this._context.closePath();
}
CanvasRenderer.prototype.drawQuad = function(x0, y0, x1, y1, x2, y2, x3, y3) {
  this._context.beginPath();
  this._context.moveTo(x0, y0);
  this._context.lineTo(x1, y1);
  this._context.lineTo(x2, y2);
  this._context.lineTo(x3, y3);
  this._context.lineTo(x0, y0);
  this._context.closePath();
}
CanvasRenderer.prototype.strokePath = function(color, linewidth, linecap, linejoin) {
  this.setLineWidth(linewidth);
  this.setLineCap(linecap);
  this.setLineJoin(linejoin);
  this.setStrokeStyle(color.getContextStyle());
  this._context.stroke();
  this._bboxRect.inflate(linewidth * (2));
}
CanvasRenderer.prototype.fillPath = function(color) {
  this.setFillStyle(color.getContextStyle());
  this._context.fill();
}
CanvasRenderer.prototype.patternPath = function(x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, texture) {
  if ($eq$(texture.noSuchMethod("get:image", []).get$width(), (0))) return;
  if ($eq$(texture.noSuchMethod("get:needsUpdate", []), true) || $eq$(this._patterns.$index(texture.get$id()))) {
    var repeatX = $eq$(texture.noSuchMethod("get:wrapS", []), $globals.Three_RepeatWrapping);
    var repeatY = $eq$(texture.noSuchMethod("get:wrapT", []), $globals.Three_RepeatWrapping);
    this._patterns.$setindex(texture.get$id(), this._context.createPattern(texture.noSuchMethod("get:image", []), repeatX && repeatY ? "repeat" : repeatX && !repeatY ? "repeat-x" : !repeatX && repeatY ? "repeat-y" : "no-repeat"));
    texture.noSuchMethod("set:needsUpdate", [false]);
  }
  this.setFillStyle(this._patterns.$index(texture.get$id()));
  var a, b, c, d, e, f, det, idet, offsetX = $div$(texture.get$offset().get$x(), texture.get$repeat().get$x()), offsetY = $div$(texture.get$offset().get$y(), texture.get$repeat().get$y()), width = $mul$(texture.noSuchMethod("get:image", []).get$width(), texture.get$repeat().get$x()), height = $mul$(texture.noSuchMethod("get:image", []).get$height(), texture.get$repeat().get$y());
  u0 = (u0 + offsetX) * width;
  v0 = (v0 + offsetY) * height;
  u1 = (u1 + offsetX) * width;
  v1 = (v1 + offsetY) * height;
  u2 = (u2 + offsetX) * width;
  v2 = (v2 + offsetY) * height;
  x1 -= x0;
  y1 -= y0;
  x2 -= x0;
  y2 -= y0;
  u1 -= u0;
  v1 -= v0;
  u2 -= u0;
  v2 -= v0;
  det = u1 * v2 - u2 * v1;
  if (det == (0)) {
    if (null == this._imagedatas.$index(texture.get$id())) {
      var canvas = ElementWrappingImplementation.ElementWrappingImplementation$tag$factory("canvas");
      canvas.set$width(texture.noSuchMethod("get:image", []).get$width());
      canvas.set$height(texture.noSuchMethod("get:image", []).get$height());
      var context = canvas.getContext("2d");
      context.drawImage(texture.noSuchMethod("get:image", []), (0), (0));
      this._imagedatas.$setindex(texture.get$id(), context.getImageData((0), (0), texture.noSuchMethod("get:image", []).get$width(), texture.noSuchMethod("get:image", []).get$height()).get$data());
    }
    var data = this._imagedatas.$index(texture.get$id());
    var index = (u0.floor() + $mul$(v0.floor(), texture.noSuchMethod("get:image", []).get$width())) * (4);
    this._color.setRGB($div$(data.$index(index), (255)), $div$(data.$index(index + (1)), (255)), $div$(data.$index(index + (2)), (255)));
    this.fillPath(this._color);
    return;
  }
  idet = (1) / det;
  a = (v2 * x1 - v1 * x2) * idet;
  b = (v2 * y1 - v1 * y2) * idet;
  c = (u1 * x2 - u2 * x1) * idet;
  d = (u1 * y2 - u2 * y1) * idet;
  e = x0 - a * u0 - c * v0;
  f = y0 - b * u0 - d * v0;
  this._context.save();
  this._context.transform(a, b, c, d, e, f);
  this._context.fill();
  this._context.restore();
}
CanvasRenderer.prototype.clipImage = function(x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, image) {
  var a, b, c, d, e, f, det, idet, width = $sub$(image.get$width(), (1)), height = $sub$(image.get$height(), (1));
  u0 *= width;
  v0 *= height;
  u1 *= width;
  v1 *= height;
  u2 *= width;
  v2 *= height;
  x1 -= x0;
  y1 -= y0;
  x2 -= x0;
  y2 -= y0;
  u1 -= u0;
  v1 -= v0;
  u2 -= u0;
  v2 -= v0;
  det = u1 * v2 - u2 * v1;
  idet = (1) / det;
  a = (v2 * x1 - v1 * x2) * idet;
  b = (v2 * y1 - v1 * y2) * idet;
  c = (u1 * x2 - u2 * x1) * idet;
  d = (u1 * y2 - u2 * y1) * idet;
  e = x0 - a * u0 - c * v0;
  f = y0 - b * u0 - d * v0;
  this._context.save();
  this._context.transform(a, b, c, d, e, f);
  this._context.clip();
  this._context.drawImage(image, (0), (0));
  this._context.restore();
}
CanvasRenderer.prototype.getGradientTexture = function(color1, color2, color3, color4) {
  var c1r = ~~(color1.r * (255)), c1g = ~~(color1.g * (255)), c1b = ~~(color1.b * (255)), c2r = ~~(color2.r * (255)), c2g = ~~(color2.g * (255)), c2b = ~~(color2.b * (255)), c3r = ~~(color3.r * (255)), c3g = ~~(color3.g * (255)), c3b = ~~(color3.b * (255)), c4r = ~~(color4.r * (255)), c4g = ~~(color4.g * (255)), c4b = ~~(color4.b * (255));
  this._pixelMapData.$setindex((0), c1r < (0) ? (0) : c1r > (255) ? (255) : c1r);
  this._pixelMapData.$setindex((1), c1g < (0) ? (0) : c1g > (255) ? (255) : c1g);
  this._pixelMapData.$setindex((2), c1b < (0) ? (0) : c1b > (255) ? (255) : c1b);
  this._pixelMapData.$setindex((4), c2r < (0) ? (0) : c2r > (255) ? (255) : c2r);
  this._pixelMapData.$setindex((5), c2g < (0) ? (0) : c2g > (255) ? (255) : c2g);
  this._pixelMapData.$setindex((6), c2b < (0) ? (0) : c2b > (255) ? (255) : c2b);
  this._pixelMapData.$setindex((8), c3r < (0) ? (0) : c3r > (255) ? (255) : c3r);
  this._pixelMapData.$setindex((9), c3g < (0) ? (0) : c3g > (255) ? (255) : c3g);
  this._pixelMapData.$setindex((10), c3b < (0) ? (0) : c3b > (255) ? (255) : c3b);
  this._pixelMapData.$setindex((12), c4r < (0) ? (0) : c4r > (255) ? (255) : c4r);
  this._pixelMapData.$setindex((13), c4g < (0) ? (0) : c4g > (255) ? (255) : c4g);
  this._pixelMapData.$setindex((14), c4b < (0) ? (0) : c4b > (255) ? (255) : c4b);
  this._pixelMapContext.putImageData(this._pixelMapImage, (0), (0));
  this._gradientMapContext.drawImage(this._pixelMap, (0), (0));
  return this._gradientMap;
}
CanvasRenderer.prototype.smoothstep = function(value, min, max) {
  var x = (value - min) / (max - min);
  return $mul$(x, x) * ((3) - $mul$((2), x));
}
CanvasRenderer.prototype.normalToComponent = function(normal) {
  var component = (normal + (1)) * (0.5);
  return component < (0) ? (0) : (component > (1) ? (1) : component);
}
CanvasRenderer.prototype.expand = function(v1, v2) {
  var x = v2.get$x() - v1.get$x(), y = v2.get$y() - v1.get$y(), det = x * x + y * y, idet;
  if (det == (0)) return;
  idet = (1) / Math.sqrt(det);
  x *= idet;
  y *= idet;
  v2.set$x(v2.get$x() + x);
  v2.set$y(v2.get$y() + y);
  v1.set$x(v1.get$x() - x);
  v1.set$y(v1.get$y() - y);
}
CanvasRenderer.prototype.setOpacity = function(value) {
  var $0;
  if (this._contextGlobalAlpha != value) {
    this._context.set$globalAlpha((this._contextGlobalAlpha = ($0 = value), $0));
  }
}
CanvasRenderer.prototype.setBlending = function(value) {
  if (this._contextGlobalCompositeOperation != value) {
    switch (value) {
      case $globals.Three_NormalBlending:

        this._context.set$globalCompositeOperation("source-over");
        break;

      case $globals.Three_AdditiveBlending:

        this._context.set$globalCompositeOperation("lighter");
        break;

      case $globals.Three_SubtractiveBlending:

        this._context.set$globalCompositeOperation("darker");
        break;

    }
    this._contextGlobalCompositeOperation = value;
  }
}
CanvasRenderer.prototype.setLineWidth = function(value) {
  var $0;
  if (this._contextLineWidth != value) {
    this._context.set$lineWidth((this._contextLineWidth = ($0 = value), $0));
  }
}
CanvasRenderer.prototype.setLineCap = function(value) {
  var $0;
  if (this._contextLineCap != value) {
    this._context.set$lineCap((this._contextLineCap = ($0 = value), $0));
  }
}
CanvasRenderer.prototype.setLineJoin = function(value) {
  var $0;
  if (this._contextLineJoin != value) {
    this._context.set$lineJoin((this._contextLineJoin = ($0 = value), $0));
  }
}
CanvasRenderer.prototype.setStrokeStyle = function(style) {
  var $0;
  if (this._contextStrokeStyle != style) {
    this._context.set$strokeStyle((this._contextStrokeStyle = ($0 = style), $0));
  }
}
CanvasRenderer.prototype.setFillStyle = function(style) {
  var $0;
  if (this._contextFillStyle != style) {
    this._context.set$fillStyle((this._contextFillStyle = ($0 = style), $0));
  }
}
CanvasRenderer.prototype.set$sortObjects = function(value) {
  this._sortObjects = value;
}
// ********** Code for CanvasRenderData **************
function CanvasRenderData() {
  this.render = new RenderInts();
}
// ********** Code for RenderInts **************
function RenderInts() {
  this.reset();
}
RenderInts.prototype.reset = function() {
  this.vertices = (0);
  this.faces = (0);
}
// ********** Code for Scene **************
$inherits(Scene, Object3D);
function Scene() {
  Object3D.call(this);
  this.fog = null;
  this.overrideMaterial = null;
  this.matrixAutoUpdate = false;
  this.objects = [];
  this.lights = [];
  this.__objectsAdded = [];
  this.__objectsRemoved = [];
}
Scene.prototype.addObject = function(object) {
  var $0, $1;
  if ((object instanceof Light)) {
    if ((($0 = this.lights.indexOf$1(object)) == null ? null == ((-1)) : $0 === (-1))) {
      this.lights.add(object);
    }
  }
  else if (!((object instanceof Camera) || (object instanceof Bone))) {
    if ((($1 = this.objects.indexOf$1(object)) == null ? null == ((-1)) : $1 === (-1))) {
      this.objects.add(object);
      this.__objectsAdded.add(object);
      var i = this.__objectsRemoved.indexOf$1(object);
      if ((null == i ? null != ((-1)) : i !== (-1))) {
        this.__objectsRemoved.removeRange(i, (1));
      }
    }
  }
  for (var c = (0);
   c < object.children.get$length(); c++) {
    this.addObject(object.children.$index(c));
  }
}
Scene.prototype.removeObject = function(object) {
  if ((object instanceof Light)) {
    var i = this.lights.indexOf$1(object);
    if ((null == i ? null != ((-1)) : i !== (-1))) {
      this.lights.removeRange(i, (1));
    }
  }
  else if (!((object instanceof Camera))) {
    var i = this.objects.indexOf$1(object);
    if ((null == i ? null != ((-1)) : i !== (-1))) {
      this.objects.removeRange(i, (1));
      this.__objectsRemoved.add(object);
      var ai = this.__objectsAdded.indexOf$1(object);
      if ((null == ai ? null != ((-1)) : ai !== (-1))) {
        this.__objectsAdded.removeRange(ai, (1));
      }
    }
  }
  for (var c = (0);
   c < object.children.get$length(); c++) {
    this.removeObject(object.children.$index(c));
  }
}
// ********** Code for UVMapping **************
function UVMapping() {}
// ********** Code for SphericalReflectionMapping **************
function SphericalReflectionMapping() {}
// ********** Code for top level **************
//  ********** Library Canvas_Geometry_Heirarchy **************
// ********** Code for Canvas_Geometry_Heirarchy **************
function Canvas_Geometry_Heirarchy() {
  this.mouseX = (0);
  this.mouseY = (0);
}
Canvas_Geometry_Heirarchy.prototype.get$geometry = function() { return this.geometry; };
Canvas_Geometry_Heirarchy.prototype.run = function() {
  html_get$$document().get$on().get$mouseMove().add(this.get$onDocumentMouseMove(), false);
  this.init();
  this.animate();
}
Canvas_Geometry_Heirarchy.prototype.init = function() {
  var $this = this; // closure support
  this.windowHalfX = html_get$$window().get$innerWidth() / (2);
  this.windowHalfY = html_get$$window().get$innerHeight() / (2);
  this.container = ElementWrappingImplementation.ElementWrappingImplementation$tag$factory("div");
  html_get$$document().get$body().get$nodes().add(this.container);
  this.scene = new Scene();
  this.camera = new PerspectiveCamera((60), html_get$$window().get$innerWidth() / html_get$$window().get$innerHeight(), (1), (10000));
  this.camera.position.set$z((500));
  this.scene.add(this.camera);
  var materials = [];
  for (var i = (0);
   i < (6); i++) {
    materials.add(new MeshBasicMaterial(_map(["color", Math.random() * (16777215)])));
  }
  this.geometry = new CubeGeometry((100), (100), (100));
  var material = new MeshNormalMaterial();
  this.group = new Object3D();
  for (var i = (0);
   $lt$(i, (200)); i = $add$(i, (1))) {
    var mesh = new Mesh(this.geometry, material);
    mesh.position.set$x(Math.random() * (2000) - (1000));
    mesh.position.set$y(Math.random() * (2000) - (1000));
    mesh.position.set$z(Math.random() * (2000) - (1000));
    mesh.rotation.set$x(Math.random() * (360) * (0.017453292519943295));
    mesh.rotation.set$y(Math.random() * (360) * (0.017453292519943295));
    mesh.matrixAutoUpdate = false;
    mesh.updateMatrix();
    this.group.add(mesh);
  }
  this.scene.add(this.group);
  this.renderer = new CanvasRenderer();
  this.renderer.setSize(html_get$$window().get$innerWidth(), html_get$$window().get$innerHeight());
  this.renderer.set$sortObjects(false);
  this.container.get$nodes().add(this.renderer.domElement);
  html_get$$window().setInterval(function f() {
    return $this.animate();
  }
  , (10));
}
Canvas_Geometry_Heirarchy.prototype.onDocumentMouseMove = function(event) {
  this.mouseX = (event.get$clientX() - this.windowHalfX) * (10);
  this.mouseY = (event.get$clientY() - this.windowHalfY) * (10);
}
Canvas_Geometry_Heirarchy.prototype.get$onDocumentMouseMove = function() {
  return this.onDocumentMouseMove.bind(this);
}
Canvas_Geometry_Heirarchy.prototype.animate = function() {
  this.render();
}
Canvas_Geometry_Heirarchy.prototype.render = function() {
  var $0, $1;
  ($0 = this.camera.position).set$x($0.get$x() + ((this.mouseX - this.camera.position.get$x()) * (0.05)));
  ($1 = this.camera.position).set$y($1.get$y() + ((-this.mouseY - this.camera.position.get$y()) * (0.05)));
  this.camera.lookAt(this.scene.position);
  this.group.rotation.set$x(Math.sin(new DateImplementation.now$ctor().value * (0.0007)) * (0.5));
  this.group.rotation.set$y(Math.sin(new DateImplementation.now$ctor().value * (0.0003)) * (0.5));
  this.group.rotation.set$z(Math.sin(new DateImplementation.now$ctor().value * (0.0002)) * (0.5));
  this.renderer.render(this.scene, this.camera);
}
// ********** Code for top level **************
function main() {
  new Canvas_Geometry_Heirarchy().run();
}
// 200 dynamic types.
// 504 types
// 44 !leaf
function $dynamicSetMetadata(inputTable) {
  // TODO: Deal with light isolates.
  var table = [];
  for (var i = 0; i < inputTable.length; i++) {
    var tag = inputTable[i][0];
    var tags = inputTable[i][1];
    var map = {};
    var tagNames = tags.split('|');
    for (var j = 0; j < tagNames.length; j++) {
      map[tagNames[j]] = true;
    }
    table.push({tag: tag, tags: tags, map: map});
  }
  $dynamicMetadata = table;
}
(function(){
  var v0/*SVGComponentTransferFunctionElement*/ = 'SVGComponentTransferFunctionElement|SVGFEFuncAElement|SVGFEFuncBElement|SVGFEFuncGElement|SVGFEFuncRElement';
  var v1/*SVGTextPositioningElement*/ = 'SVGTextPositioningElement|SVGAltGlyphElement|SVGTRefElement|SVGTSpanElement|SVGTextElement';
  var v2/*CharacterData*/ = 'CharacterData|Comment|Text|CDATASection';
  var v3/*Document*/ = 'Document|HTMLDocument|SVGDocument';
  var v4/*HTMLElement*/ = 'HTMLElement|HTMLAnchorElement|HTMLAppletElement|HTMLAreaElement|HTMLBRElement|HTMLBaseElement|HTMLBaseFontElement|HTMLBodyElement|HTMLButtonElement|HTMLCanvasElement|HTMLContentElement|HTMLDListElement|HTMLDetailsElement|HTMLDirectoryElement|HTMLDivElement|HTMLEmbedElement|HTMLFieldSetElement|HTMLFontElement|HTMLFormElement|HTMLFrameElement|HTMLFrameSetElement|HTMLHRElement|HTMLHeadElement|HTMLHeadingElement|HTMLHtmlElement|HTMLIFrameElement|HTMLImageElement|HTMLInputElement|HTMLKeygenElement|HTMLLIElement|HTMLLabelElement|HTMLLegendElement|HTMLLinkElement|HTMLMapElement|HTMLMarqueeElement|HTMLMediaElement|HTMLAudioElement|HTMLVideoElement|HTMLMenuElement|HTMLMetaElement|HTMLMeterElement|HTMLModElement|HTMLOListElement|HTMLObjectElement|HTMLOptGroupElement|HTMLOptionElement|HTMLOutputElement|HTMLParagraphElement|HTMLParamElement|HTMLPreElement|HTMLProgressElement|HTMLQuoteElement|HTMLScriptElement|HTMLSelectElement|HTMLShadowElement|HTMLSourceElement|HTMLSpanElement|HTMLStyleElement|HTMLTableCaptionElement|HTMLTableCellElement|HTMLTableColElement|HTMLTableElement|HTMLTableRowElement|HTMLTableSectionElement|HTMLTextAreaElement|HTMLTitleElement|HTMLTrackElement|HTMLUListElement|HTMLUnknownElement';
  var v5/*SVGElement*/ = [v0/*SVGComponentTransferFunctionElement*/,v1/*SVGTextPositioningElement*/,'SVGElement|SVGAElement|SVGAltGlyphDefElement|SVGAltGlyphItemElement|SVGAnimationElement|SVGAnimateColorElement|SVGAnimateElement|SVGAnimateMotionElement|SVGAnimateTransformElement|SVGSetElement|SVGCircleElement|SVGClipPathElement|SVGCursorElement|SVGDefsElement|SVGDescElement|SVGEllipseElement|SVGFEBlendElement|SVGFEColorMatrixElement|SVGFEComponentTransferElement|SVGFECompositeElement|SVGFEConvolveMatrixElement|SVGFEDiffuseLightingElement|SVGFEDisplacementMapElement|SVGFEDistantLightElement|SVGFEDropShadowElement|SVGFEFloodElement|SVGFEGaussianBlurElement|SVGFEImageElement|SVGFEMergeElement|SVGFEMergeNodeElement|SVGFEMorphologyElement|SVGFEOffsetElement|SVGFEPointLightElement|SVGFESpecularLightingElement|SVGFESpotLightElement|SVGFETileElement|SVGFETurbulenceElement|SVGFilterElement|SVGFontElement|SVGFontFaceElement|SVGFontFaceFormatElement|SVGFontFaceNameElement|SVGFontFaceSrcElement|SVGFontFaceUriElement|SVGForeignObjectElement|SVGGElement|SVGGlyphElement|SVGGlyphRefElement|SVGGradientElement|SVGLinearGradientElement|SVGRadialGradientElement|SVGHKernElement|SVGImageElement|SVGLineElement|SVGMPathElement|SVGMarkerElement|SVGMaskElement|SVGMetadataElement|SVGMissingGlyphElement|SVGPathElement|SVGPatternElement|SVGPolygonElement|SVGPolylineElement|SVGRectElement|SVGSVGElement|SVGScriptElement|SVGStopElement|SVGStyleElement|SVGSwitchElement|SVGSymbolElement|SVGTextContentElement|SVGTextPathElement|SVGTitleElement|SVGUseElement|SVGVKernElement|SVGViewElement'].join('|');
  var v6/*AbstractWorker*/ = 'AbstractWorker|SharedWorker|Worker';
  var v7/*Node*/ = [v2/*CharacterData*/,v3/*Document*/,v4/*HTMLElement*/,v5/*SVGElement*/,'Node|Attr|DocumentFragment|ShadowRoot|DocumentType|Element|Entity|EntityReference|Notation|ProcessingInstruction'].join('|');
  var v8/*Uint8Array*/ = 'Uint8Array|Uint8ClampedArray';
  var v9/*AudioParam*/ = 'AudioParam|AudioGain';
  var v10/*CSSValueList*/ = 'CSSValueList|WebKitCSSTransformValue';
  var v11/*DOMTokenList*/ = 'DOMTokenList|DOMSettableTokenList';
  var v12/*Entry*/ = 'Entry|DirectoryEntry|FileEntry';
  var v13/*EntrySync*/ = 'EntrySync|DirectoryEntrySync|FileEntrySync';
  var v14/*EventTarget*/ = [v6/*AbstractWorker*/,v7/*Node*/,'EventTarget|DOMApplicationCache|DOMWindow|EventSource|MessagePort|Notification|SVGElementInstance|WebSocket|XMLHttpRequest|XMLHttpRequestUpload'].join('|');
  var v15/*HTMLCollection*/ = 'HTMLCollection|HTMLOptionsCollection';
  var v16/*IDBRequest*/ = 'IDBRequest|IDBVersionChangeRequest';
  var v17/*MediaStream*/ = 'MediaStream|LocalMediaStream';
  var v18/*WorkerContext*/ = 'WorkerContext|DedicatedWorkerContext|SharedWorkerContext';
  var table = [
    // [dynamic-dispatch-tag, tags of classes implementing dynamic-dispatch-tag]
    ['AbstractWorker', v6/*AbstractWorker*/]
    , ['AudioParam', v9/*AudioParam*/]
    , ['CSSValueList', v10/*CSSValueList*/]
    , ['CharacterData', v2/*CharacterData*/]
    , ['DOMTokenList', v11/*DOMTokenList*/]
    , ['Document', v3/*Document*/]
    , ['Entry', v12/*Entry*/]
    , ['EntrySync', v13/*EntrySync*/]
    , ['HTMLElement', v4/*HTMLElement*/]
    , ['SVGComponentTransferFunctionElement', v0/*SVGComponentTransferFunctionElement*/]
    , ['SVGTextPositioningElement', v1/*SVGTextPositioningElement*/]
    , ['SVGElement', v5/*SVGElement*/]
    , ['Node', v7/*Node*/]
    , ['EventTarget', v14/*EventTarget*/]
    , ['HTMLCollection', v15/*HTMLCollection*/]
    , ['IDBRequest', v16/*IDBRequest*/]
    , ['MediaStream', v17/*MediaStream*/]
    , ['Uint8Array', v8/*Uint8Array*/]
    , ['WorkerContext', v18/*WorkerContext*/]
    , ['DOMType', [v8/*Uint8Array*/,v9/*AudioParam*/,v10/*CSSValueList*/,v11/*DOMTokenList*/,v12/*Entry*/,v13/*EntrySync*/,v14/*EventTarget*/,v15/*HTMLCollection*/,v16/*IDBRequest*/,v17/*MediaStream*/,v18/*WorkerContext*/,'DOMType|ArrayBuffer|ArrayBufferView|DataView|Float32Array|Float64Array|Int16Array|Int32Array|Int8Array|Uint16Array|Uint32Array|AudioBuffer|AudioContext|AudioListener|AudioNode|AudioChannelMerger|AudioChannelSplitter|AudioDestinationNode|AudioGainNode|AudioPannerNode|AudioSourceNode|AudioBufferSourceNode|MediaElementAudioSourceNode|BiquadFilterNode|ConvolverNode|DelayNode|DynamicsCompressorNode|HighPass2FilterNode|JavaScriptAudioNode|LowPass2FilterNode|RealtimeAnalyserNode|WaveShaperNode|BarInfo|Blob|File|CSSRule|CSSCharsetRule|CSSFontFaceRule|CSSImportRule|CSSMediaRule|CSSPageRule|CSSStyleRule|CSSUnknownRule|WebKitCSSKeyframeRule|WebKitCSSKeyframesRule|WebKitCSSRegionRule|CSSRuleList|CSSStyleDeclaration|CSSValue|CSSPrimitiveValue|SVGColor|SVGPaint|CanvasGradient|CanvasPattern|CanvasPixelArray|CanvasRenderingContext|CanvasRenderingContext2D|WebGLRenderingContext|ClientRect|ClientRectList|Clipboard|Coordinates|Counter|Crypto|DOMException|DOMFileSystem|DOMFileSystemSync|DOMFormData|DOMImplementation|DOMMimeType|DOMMimeTypeArray|DOMParser|DOMPlugin|DOMPluginArray|DOMSelection|DOMURL|DataTransferItem|DataTransferItemList|Database|DatabaseSync|DirectoryReader|DirectoryReaderSync|ElementTimeControl|ElementTraversal|EntryArray|EntryArraySync|Event|AudioProcessingEvent|BeforeLoadEvent|CloseEvent|CustomEvent|DeviceMotionEvent|DeviceOrientationEvent|ErrorEvent|HashChangeEvent|IDBVersionChangeEvent|MediaStreamEvent|MessageEvent|MutationEvent|OfflineAudioCompletionEvent|OverflowEvent|PageTransitionEvent|PopStateEvent|ProgressEvent|XMLHttpRequestProgressEvent|SpeechInputEvent|StorageEvent|TrackEvent|UIEvent|CompositionEvent|KeyboardEvent|MouseEvent|SVGZoomEvent|TextEvent|TouchEvent|WheelEvent|WebGLContextEvent|WebKitAnimationEvent|WebKitTransitionEvent|EventException|FileError|FileException|FileList|FileReader|FileReaderSync|FileWriter|FileWriterSync|Geolocation|Geoposition|HTMLAllCollection|History|IDBAny|IDBCursor|IDBCursorWithValue|IDBDatabase|IDBDatabaseError|IDBDatabaseException|IDBFactory|IDBIndex|IDBKey|IDBKeyRange|IDBObjectStore|IDBTransaction|ImageData|JavaScriptCallFrame|Location|MediaController|MediaError|MediaList|MediaQueryList|MediaQueryListListener|MediaStreamList|MediaStreamTrack|MediaStreamTrackList|MemoryInfo|MessageChannel|Metadata|NamedNodeMap|Navigator|NavigatorUserMediaError|NodeFilter|NodeIterator|NodeList|NodeSelector|NotificationCenter|OESStandardDerivatives|OESTextureFloat|OESVertexArrayObject|OperationNotAllowedException|PeerConnection|Performance|PerformanceNavigation|PerformanceTiming|PositionError|RGBColor|Range|RangeException|Rect|SQLError|SQLException|SQLResultSet|SQLResultSetRowList|SQLTransaction|SQLTransactionSync|SVGAngle|SVGAnimatedAngle|SVGAnimatedBoolean|SVGAnimatedEnumeration|SVGAnimatedInteger|SVGAnimatedLength|SVGAnimatedLengthList|SVGAnimatedNumber|SVGAnimatedNumberList|SVGAnimatedPreserveAspectRatio|SVGAnimatedRect|SVGAnimatedString|SVGAnimatedTransformList|SVGElementInstanceList|SVGException|SVGExternalResourcesRequired|SVGFitToViewBox|SVGLangSpace|SVGLength|SVGLengthList|SVGLocatable|SVGTransformable|SVGMatrix|SVGNumber|SVGNumberList|SVGPathSeg|SVGPathSegArcAbs|SVGPathSegArcRel|SVGPathSegClosePath|SVGPathSegCurvetoCubicAbs|SVGPathSegCurvetoCubicRel|SVGPathSegCurvetoCubicSmoothAbs|SVGPathSegCurvetoCubicSmoothRel|SVGPathSegCurvetoQuadraticAbs|SVGPathSegCurvetoQuadraticRel|SVGPathSegCurvetoQuadraticSmoothAbs|SVGPathSegCurvetoQuadraticSmoothRel|SVGPathSegLinetoAbs|SVGPathSegLinetoHorizontalAbs|SVGPathSegLinetoHorizontalRel|SVGPathSegLinetoRel|SVGPathSegLinetoVerticalAbs|SVGPathSegLinetoVerticalRel|SVGPathSegMovetoAbs|SVGPathSegMovetoRel|SVGPathSegList|SVGPoint|SVGPointList|SVGPreserveAspectRatio|SVGRect|SVGRenderingIntent|SVGStringList|SVGStylable|SVGFilterPrimitiveStandardAttributes|SVGTests|SVGTransform|SVGTransformList|SVGURIReference|SVGUnitTypes|SVGZoomAndPan|SVGViewSpec|Screen|ScriptProfile|ScriptProfileNode|SpeechInputResult|SpeechInputResultList|Storage|StorageInfo|StyleMedia|StyleSheet|CSSStyleSheet|StyleSheetList|TextMetrics|TextTrack|TextTrackCue|TextTrackCueList|TextTrackList|TimeRanges|Touch|TouchList|TreeWalker|ValidityState|WebGLActiveInfo|WebGLBuffer|WebGLCompressedTextureS3TC|WebGLContextAttributes|WebGLDebugRendererInfo|WebGLDebugShaders|WebGLFramebuffer|WebGLLoseContext|WebGLProgram|WebGLRenderbuffer|WebGLShader|WebGLTexture|WebGLUniformLocation|WebGLVertexArrayObjectOES|WebKitAnimation|WebKitAnimationList|WebKitBlobBuilder|WebKitCSSMatrix|WebKitNamedFlow|WebKitPoint|WorkerLocation|WorkerNavigator|XMLHttpRequestException|XMLSerializer|XPathEvaluator|XPathException|XPathExpression|XPathNSResolver|XPathResult|XSLTProcessor'].join('|')]
  ];
  $dynamicSetMetadata(table);
})();
//  ********** Globals **************
function $static_init(){
  $globals.Three_AdditiveBlending = (1);
  $globals.Three_FlatShading = (1);
  $globals.Three_GeometryCount = (0);
  $globals.Three_MaterialCount = (0);
  $globals.Three_MultiplyOperation = (0);
  $globals.Three_NormalBlending = (0);
  $globals.Three_Object3DCount = (0);
  $globals.Three_RepeatWrapping = (0);
  $globals.Three_SmoothShading = (2);
  $globals.Three_SubtractiveBlending = (2);
}
var const$0000 = Object.create(_DeletedKeySentinel.prototype, {});
var const$0001 = Object.create(NoMoreElementsException.prototype, {});
var const$0003 = Object.create(EmptyQueueException.prototype, {});
var const$0012 = Object.create(UnsupportedOperationException.prototype, {_message: {"value": "TODO(jacobr): should we impl?", writeable: false}});
var const$0013 = Object.create(IllegalAccessException.prototype, {});
var const$0014 = _constMap([]);
var $globals = {};
$static_init();
main();
