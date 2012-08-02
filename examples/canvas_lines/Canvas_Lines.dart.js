function Isolate() {}
init();

var $$ = {};
var $ = Isolate.$isolateProperties;
$$.ExceptionImplementation = {"":
 ["_msg"],
 super: "Object",
 toString$0: function() {
  var t1 = this._msg;
  return t1 == null ? 'Exception' : 'Exception: ' + $.S(t1);
 }
};

$$.HashMapImplementation = {"":
 ["_numberOfDeleted", "_numberOfEntries", "_loadLimit", "_values", "_keys?"],
 super: "Object",
 toString$0: function() {
  return $.Maps_mapToString(this);
 },
 containsKey$1: function(key) {
  return !$.eqB(this._probeForLookup$1(key), -1);
 },
 getValues$0: function() {
  var t1 = ({});
  var list = $.ListFactory_List($.get$length(this));
  $.setRuntimeTypeInfo(list, ({E: 'V'}));
  t1.i_1 = 0;
  this.forEach$1(new $.HashMapImplementation_getValues__(list, t1));
  return list;
 },
 getKeys$0: function() {
  var t1 = ({});
  var list = $.ListFactory_List($.get$length(this));
  $.setRuntimeTypeInfo(list, ({E: 'K'}));
  t1.i_10 = 0;
  this.forEach$1(new $.HashMapImplementation_getKeys__(list, t1));
  return list;
 },
 forEach$1: function(f) {
  var length$ = $.get$length(this._keys);
  if (typeof length$ !== 'number') return this.forEach$1$bailout(1, f, length$);
  for (var i = 0; i < length$; ++i) {
    var key = $.index(this._keys, i);
    !(key == null) && !(key === $.CTC3) && f.$call$2(key, $.index(this._values, i));
  }
 },
 forEach$1$bailout: function(state, f, length$) {
  for (var i = 0; $.ltB(i, length$); ++i) {
    var key = $.index(this._keys, i);
    !(key == null) && !(key === $.CTC3) && f.$call$2(key, $.index(this._values, i));
  }
 },
 get$length: function() {
  return this._numberOfEntries;
 },
 length$0: function() { return this.get$length().$call$0(); },
 isEmpty$0: function() {
  return $.eq(this._numberOfEntries, 0);
 },
 remove$1: function(key) {
  var index = this._probeForLookup$1(key);
  if ($.geB(index, 0)) {
    this._numberOfEntries = $.sub(this._numberOfEntries, 1);
    var value = $.index(this._values, index);
    $.indexSet(this._values, index, null);
    $.indexSet(this._keys, index, $.CTC3);
    this._numberOfDeleted = $.add(this._numberOfDeleted, 1);
    return value;
  }
  return;
 },
 operator$index$1: function(key) {
  var index = this._probeForLookup$1(key);
  if ($.ltB(index, 0)) return;
  return $.index(this._values, index);
 },
 operator$indexSet$2: function(key, value) {
  this._ensureCapacity$0();
  var index = this._probeForAdding$1(key);
  if ($.index(this._keys, index) == null || $.index(this._keys, index) === $.CTC3) this._numberOfEntries = $.add(this._numberOfEntries, 1);
  $.indexSet(this._keys, index, key);
  $.indexSet(this._values, index, value);
 },
 clear$0: function() {
  this._numberOfEntries = 0;
  this._numberOfDeleted = 0;
  var length$ = $.get$length(this._keys);
  if (typeof length$ !== 'number') return this.clear$0$bailout(1, length$);
  for (var i = 0; i < length$; ++i) {
    $.indexSet(this._keys, i, null);
    $.indexSet(this._values, i, null);
  }
 },
 clear$0$bailout: function(state, length$) {
  for (var i = 0; $.ltB(i, length$); ++i) {
    $.indexSet(this._keys, i, null);
    $.indexSet(this._values, i, null);
  }
 },
 _grow$1: function(newCapacity) {
  var capacity = $.get$length(this._keys);
  if (typeof capacity !== 'number') return this._grow$1$bailout(1, newCapacity, capacity, 0, 0);
  this._loadLimit = $.HashMapImplementation__computeLoadLimit(newCapacity);
  var oldKeys = this._keys;
  if (typeof oldKeys !== 'string' && (typeof oldKeys !== 'object' || oldKeys === null || (oldKeys.constructor !== Array && !oldKeys.is$JavaScriptIndexingBehavior()))) return this._grow$1$bailout(2, newCapacity, oldKeys, capacity, 0);
  var oldValues = this._values;
  if (typeof oldValues !== 'string' && (typeof oldValues !== 'object' || oldValues === null || (oldValues.constructor !== Array && !oldValues.is$JavaScriptIndexingBehavior()))) return this._grow$1$bailout(3, newCapacity, oldKeys, oldValues, capacity);
  this._keys = $.ListFactory_List(newCapacity);
  var t4 = $.ListFactory_List(newCapacity);
  $.setRuntimeTypeInfo(t4, ({E: 'V'}));
  this._values = t4;
  for (var i = 0; i < capacity; ++i) {
    var t1 = oldKeys.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var key = oldKeys[i];
    if (key == null || key === $.CTC3) continue;
    t1 = oldValues.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var value = oldValues[i];
    var newIndex = this._probeForAdding$1(key);
    $.indexSet(this._keys, newIndex, key);
    $.indexSet(this._values, newIndex, value);
  }
  this._numberOfDeleted = 0;
 },
 _grow$1$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var newCapacity = env0;
      capacity = env1;
      break;
    case 2:
      newCapacity = env0;
      oldKeys = env1;
      capacity = env2;
      break;
    case 3:
      newCapacity = env0;
      oldKeys = env1;
      oldValues = env2;
      capacity = env3;
      break;
  }
  switch (state) {
    case 0:
      var capacity = $.get$length(this._keys);
    case 1:
      state = 0;
      this._loadLimit = $.HashMapImplementation__computeLoadLimit(newCapacity);
      var oldKeys = this._keys;
    case 2:
      state = 0;
      var oldValues = this._values;
    case 3:
      state = 0;
      this._keys = $.ListFactory_List(newCapacity);
      var t4 = $.ListFactory_List(newCapacity);
      $.setRuntimeTypeInfo(t4, ({E: 'V'}));
      this._values = t4;
      for (var i = 0; $.ltB(i, capacity); ++i) {
        var key = $.index(oldKeys, i);
        if (key == null || key === $.CTC3) continue;
        var value = $.index(oldValues, i);
        var newIndex = this._probeForAdding$1(key);
        $.indexSet(this._keys, newIndex, key);
        $.indexSet(this._values, newIndex, value);
      }
      this._numberOfDeleted = 0;
  }
 },
 _ensureCapacity$0: function() {
  var newNumberOfEntries = $.add(this._numberOfEntries, 1);
  if ($.geB(newNumberOfEntries, this._loadLimit)) {
    this._grow$1($.mul($.get$length(this._keys), 2));
    return;
  }
  var numberOfFree = $.sub($.sub($.get$length(this._keys), newNumberOfEntries), this._numberOfDeleted);
  $.gtB(this._numberOfDeleted, numberOfFree) && this._grow$1($.get$length(this._keys));
 },
 _probeForLookup$1: function(key) {
  var hash = $.HashMapImplementation__firstProbe($.hashCode(key), $.get$length(this._keys));
  for (var numberOfProbes = 1; true; ) {
    var existingKey = $.index(this._keys, hash);
    if (existingKey == null) return -1;
    if ($.eqB(existingKey, key)) return hash;
    var numberOfProbes0 = numberOfProbes + 1;
    hash = $.HashMapImplementation__nextProbe(hash, numberOfProbes, $.get$length(this._keys));
    numberOfProbes = numberOfProbes0;
  }
 },
 _probeForAdding$1: function(key) {
  var hash = $.HashMapImplementation__firstProbe($.hashCode(key), $.get$length(this._keys));
  if (hash !== (hash | 0)) return this._probeForAdding$1$bailout(1, key, hash, 0, 0, 0);
  for (var numberOfProbes = 1, insertionIndex = -1; true; ) {
    var t1 = this._keys;
    if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this._probeForAdding$1$bailout(2, numberOfProbes, hash, key, insertionIndex, t1);
    var t3 = t1.length;
    if (hash < 0 || hash >= t3) throw $.ioore(hash);
    var existingKey = t1[hash];
    if (existingKey == null) {
      if (insertionIndex < 0) return hash;
      return insertionIndex;
    }
    if ($.eqB(existingKey, key)) return hash;
    if (insertionIndex < 0 && $.CTC3 === existingKey) insertionIndex = hash;
    var numberOfProbes0 = numberOfProbes + 1;
    hash = $.HashMapImplementation__nextProbe(hash, numberOfProbes, $.get$length(this._keys));
    if (hash !== (hash | 0)) return this._probeForAdding$1$bailout(3, key, numberOfProbes0, insertionIndex, hash, 0);
    numberOfProbes = numberOfProbes0;
  }
 },
 _probeForAdding$1$bailout: function(state, env0, env1, env2, env3, env4) {
  switch (state) {
    case 1:
      var key = env0;
      hash = env1;
      break;
    case 2:
      numberOfProbes = env0;
      hash = env1;
      key = env2;
      insertionIndex = env3;
      t1 = env4;
      break;
    case 3:
      key = env0;
      numberOfProbes0 = env1;
      insertionIndex = env2;
      hash = env3;
      break;
  }
  switch (state) {
    case 0:
      var hash = $.HashMapImplementation__firstProbe($.hashCode(key), $.get$length(this._keys));
    case 1:
      state = 0;
      var numberOfProbes = 1;
      var insertionIndex = -1;
    default:
      L0: while (true) {
        switch (state) {
          case 0:
            if (!true) break L0;
            var t1 = this._keys;
          case 2:
            state = 0;
            var existingKey = $.index(t1, hash);
            if (existingKey == null) {
              if ($.ltB(insertionIndex, 0)) return hash;
              return insertionIndex;
            }
            if ($.eqB(existingKey, key)) return hash;
            if ($.ltB(insertionIndex, 0) && $.CTC3 === existingKey) insertionIndex = hash;
            var numberOfProbes0 = numberOfProbes + 1;
            hash = $.HashMapImplementation__nextProbe(hash, numberOfProbes, $.get$length(this._keys));
          case 3:
            state = 0;
            numberOfProbes = numberOfProbes0;
        }
      }
  }
 },
 HashMapImplementation$0: function() {
  this._numberOfEntries = 0;
  this._numberOfDeleted = 0;
  this._loadLimit = $.HashMapImplementation__computeLoadLimit(8);
  this._keys = $.ListFactory_List(8);
  var t1 = $.ListFactory_List(8);
  $.setRuntimeTypeInfo(t1, ({E: 'V'}));
  this._values = t1;
 },
 is$Map: function() { return true; }
};

$$.HashSetImplementation = {"":
 ["_backingMap?"],
 super: "Object",
 toString$0: function() {
  return $.Collections_collectionToString(this);
 },
 iterator$0: function() {
  var t1 = $.HashSetIterator$(this);
  $.setRuntimeTypeInfo(t1, ({E: 'E'}));
  return t1;
 },
 get$length: function() {
  return $.get$length(this._backingMap);
 },
 length$0: function() { return this.get$length().$call$0(); },
 isEmpty$0: function() {
  return $.isEmpty(this._backingMap);
 },
 filter$1: function(f) {
  var result = $.HashSetImplementation$();
  $.setRuntimeTypeInfo(result, ({E: 'E'}));
  $.forEach(this._backingMap, new $.HashSetImplementation_filter__(result, f));
  return result;
 },
 forEach$1: function(f) {
  $.forEach(this._backingMap, new $.HashSetImplementation_forEach__(f));
 },
 addAll$1: function(collection) {
  $.forEach(collection, new $.HashSetImplementation_addAll__(this));
 },
 remove$1: function(value) {
  var t1 = this._backingMap;
  if (t1.containsKey$1(value) !== true) return false;
  t1.remove$1(value);
  return true;
 },
 contains$1: function(value) {
  return this._backingMap.containsKey$1(value);
 },
 add$1: function(value) {
  var t1 = this._backingMap;
  if (typeof t1 !== 'object' || t1 === null || ((t1.constructor !== Array || !!t1.immutable$list) && !t1.is$JavaScriptIndexingBehavior())) return this.add$1$bailout(1, t1, value);
  if (value !== (value | 0)) throw $.iae(value);
  var t3 = t1.length;
  if (value < 0 || value >= t3) throw $.ioore(value);
  t1[value] = value;
 },
 add$1$bailout: function(state, t1, value) {
  $.indexSet(t1, value, value);
 },
 clear$0: function() {
  $.clear(this._backingMap);
 },
 HashSetImplementation$0: function() {
  this._backingMap = $.HashMapImplementation$();
 },
 is$Collection: function() { return true; }
};

$$.HashSetIterator = {"":
 ["_nextValidIndex", "_entries"],
 super: "Object",
 _advance$0: function() {
  var t1 = this._entries;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this._advance$0$bailout(1, t1);
  var length$ = t1.length;
  var entry = null;
  do {
    var t2 = this._nextValidIndex + 1;
    this._nextValidIndex = t2;
    if (t2 >= length$) break;
    t2 = this._nextValidIndex;
    if (t2 !== (t2 | 0)) throw $.iae(t2);
    var t3 = t1.length;
    if (t2 < 0 || t2 >= t3) throw $.ioore(t2);
    entry = t1[t2];
  } while ((entry == null || entry === $.CTC3));
 },
 _advance$0$bailout: function(state, t1) {
  var length$ = $.get$length(t1);
  var entry = null;
  do {
    var t2 = this._nextValidIndex + 1;
    this._nextValidIndex = t2;
    if ($.geB(t2, length$)) break;
    entry = $.index(t1, this._nextValidIndex);
  } while ((entry == null || entry === $.CTC3));
 },
 next$0: function() {
  if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
  var t1 = this._entries;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.next$0$bailout(1, t1);
  var t3 = this._nextValidIndex;
  if (t3 !== (t3 | 0)) throw $.iae(t3);
  var t4 = t1.length;
  if (t3 < 0 || t3 >= t4) throw $.ioore(t3);
  var res = t1[t3];
  this._advance$0();
  return res;
 },
 next$0$bailout: function(state, t1) {
  var res = $.index(t1, this._nextValidIndex);
  this._advance$0();
  return res;
 },
 hasNext$0: function() {
  var t1 = this._nextValidIndex;
  var t2 = this._entries;
  if (typeof t2 !== 'string' && (typeof t2 !== 'object' || t2 === null || (t2.constructor !== Array && !t2.is$JavaScriptIndexingBehavior()))) return this.hasNext$0$bailout(1, t1, t2);
  var t4 = t2.length;
  if (t1 >= t4) return false;
  if (t1 !== (t1 | 0)) throw $.iae(t1);
  if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
  t2[t1] === $.CTC3 && this._advance$0();
  return this._nextValidIndex < t2.length;
 },
 hasNext$0$bailout: function(state, t1, t2) {
  if ($.geB(t1, $.get$length(t2))) return false;
  $.index(t2, this._nextValidIndex) === $.CTC3 && this._advance$0();
  return $.lt(this._nextValidIndex, $.get$length(t2));
 },
 HashSetIterator$1: function(set_) {
  this._advance$0();
 }
};

$$._DeletedKeySentinel = {"":
 [],
 super: "Object"
};

$$.KeyValuePair = {"":
 ["value=", "key?"],
 super: "Object"
};

$$.LinkedHashMapImplementation = {"":
 ["_map", "_list"],
 super: "Object",
 toString$0: function() {
  return $.Maps_mapToString(this);
 },
 clear$0: function() {
  $.clear(this._map);
  $.clear(this._list);
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 get$length: function() {
  return $.get$length(this._map);
 },
 length$0: function() { return this.get$length().$call$0(); },
 containsKey$1: function(key) {
  return this._map.containsKey$1(key);
 },
 forEach$1: function(f) {
  $.forEach(this._list, new $.LinkedHashMapImplementation_forEach__(f));
 },
 getValues$0: function() {
  var t1 = ({});
  var list = $.ListFactory_List($.get$length(this));
  $.setRuntimeTypeInfo(list, ({E: 'V'}));
  t1.index_1 = 0;
  $.forEach(this._list, new $.LinkedHashMapImplementation_getValues__(list, t1));
  return list;
 },
 getKeys$0: function() {
  var t1 = ({});
  var list = $.ListFactory_List($.get$length(this));
  $.setRuntimeTypeInfo(list, ({E: 'K'}));
  t1.index_10 = 0;
  $.forEach(this._list, new $.LinkedHashMapImplementation_getKeys__(list, t1));
  return list;
 },
 remove$1: function(key) {
  var entry = this._map.remove$1(key);
  if (entry == null) return;
  entry.remove$0();
  return entry.get$element().get$value();
 },
 operator$index$1: function(key) {
  var entry = $.index(this._map, key);
  if (entry == null) return;
  return entry.get$element().get$value();
 },
 operator$indexSet$2: function(key, value) {
  var t1 = this._map;
  if (typeof t1 !== 'object' || t1 === null || ((t1.constructor !== Array || !!t1.immutable$list) && !t1.is$JavaScriptIndexingBehavior())) return this.operator$indexSet$2$bailout(1, key, value, t1);
  if (t1.containsKey$1(key) === true) {
    if (key !== (key | 0)) throw $.iae(key);
    var t2 = t1.length;
    if (key < 0 || key >= t2) throw $.ioore(key);
    t1[key].get$element().set$value(value);
  } else {
    t2 = this._list;
    $.addLast(t2, $.KeyValuePair$(key, value));
    t2 = t2.lastEntry$0();
    if (key !== (key | 0)) throw $.iae(key);
    var t3 = t1.length;
    if (key < 0 || key >= t3) throw $.ioore(key);
    t1[key] = t2;
  }
 },
 operator$indexSet$2$bailout: function(state, key, value, t1) {
  if (t1.containsKey$1(key) === true) $.index(t1, key).get$element().set$value(value);
  else {
    var t2 = this._list;
    $.addLast(t2, $.KeyValuePair$(key, value));
    $.indexSet(t1, key, t2.lastEntry$0());
  }
 },
 LinkedHashMapImplementation$0: function() {
  this._map = $.HashMapImplementation$();
  var t1 = $.DoubleLinkedQueue$();
  $.setRuntimeTypeInfo(t1, ({E: 'KeyValuePair<K, V>'}));
  this._list = t1;
 },
 is$Map: function() { return true; }
};

$$.DoubleLinkedQueueEntry = {"":
 ["_element?", "_next=", "_previous="],
 super: "Object",
 get$element: function() {
  return this._element;
 },
 previousEntry$0: function() {
  return this._previous._asNonSentinelEntry$0();
 },
 _asNonSentinelEntry$0: function() {
  return this;
 },
 remove$0: function() {
  var t1 = this._next;
  this._previous.set$_next(t1);
  t1 = this._previous;
  this._next.set$_previous(t1);
  this._next = null;
  this._previous = null;
  return this._element;
 },
 prepend$1: function(e) {
  var t1 = $.DoubleLinkedQueueEntry$(e);
  $.setRuntimeTypeInfo(t1, ({E: 'E'}));
  t1._link$2(this._previous, this);
 },
 _link$2: function(p, n) {
  this._next = n;
  this._previous = p;
  p.set$_next(this);
  n.set$_previous(this);
 },
 DoubleLinkedQueueEntry$1: function(e) {
  this._element = e;
 }
};

$$._DoubleLinkedQueueEntrySentinel = {"":
 ["_element", "_next", "_previous"],
 super: "DoubleLinkedQueueEntry",
 get$element: function() {
  throw $.captureStackTrace($.CTC2);
 },
 _asNonSentinelEntry$0: function() {
  return;
 },
 remove$0: function() {
  throw $.captureStackTrace($.CTC2);
 },
 _DoubleLinkedQueueEntrySentinel$0: function() {
  this._link$2(this, this);
 }
};

$$.DoubleLinkedQueue = {"":
 ["_sentinel"],
 super: "Object",
 toString$0: function() {
  return $.Collections_collectionToString(this);
 },
 iterator$0: function() {
  var t1 = $._DoubleLinkedQueueIterator$(this._sentinel);
  $.setRuntimeTypeInfo(t1, ({E: 'E'}));
  return t1;
 },
 filter$1: function(f) {
  var other = $.DoubleLinkedQueue$();
  $.setRuntimeTypeInfo(other, ({E: 'E'}));
  var t1 = this._sentinel;
  var entry = t1.get$_next();
  for (; !(entry == null ? t1 == null : entry === t1); ) {
    var nextEntry = entry.get$_next();
    f.$call$1(entry.get$_element()) === true && other.addLast$1(entry.get$_element());
    entry = nextEntry;
  }
  return other;
 },
 forEach$1: function(f) {
  var t1 = this._sentinel;
  var entry = t1.get$_next();
  for (; !(entry == null ? t1 == null : entry === t1); ) {
    var nextEntry = entry.get$_next();
    f.$call$1(entry.get$_element());
    entry = nextEntry;
  }
 },
 clear$0: function() {
  var t1 = this._sentinel;
  t1.set$_next(t1);
  t1.set$_previous(t1);
 },
 isEmpty$0: function() {
  var t1 = this._sentinel;
  var t2 = t1.get$_next();
  return t2 == null ? t1 == null : t2 === t1;
 },
 get$length: function() {
  var t1 = ({});
  t1.counter_1 = 0;
  this.forEach$1(new $.DoubleLinkedQueue_length__(t1));
  return t1.counter_1;
 },
 length$0: function() { return this.get$length().$call$0(); },
 lastEntry$0: function() {
  return this._sentinel.previousEntry$0();
 },
 last$0: function() {
  return this._sentinel.get$_previous().get$element();
 },
 first$0: function() {
  return this._sentinel.get$_next().get$element();
 },
 removeFirst$0: function() {
  return this._sentinel.get$_next().remove$0();
 },
 removeLast$0: function() {
  return this._sentinel.get$_previous().remove$0();
 },
 addAll$1: function(collection) {
  for (var t1 = $.iterator(collection); t1.hasNext$0() === true; ) {
    this.add$1(t1.next$0());
  }
 },
 add$1: function(value) {
  this.addLast$1(value);
 },
 addLast$1: function(value) {
  this._sentinel.prepend$1(value);
 },
 DoubleLinkedQueue$0: function() {
  var t1 = $._DoubleLinkedQueueEntrySentinel$();
  $.setRuntimeTypeInfo(t1, ({E: 'E'}));
  this._sentinel = t1;
 },
 is$Collection: function() { return true; }
};

$$._DoubleLinkedQueueIterator = {"":
 ["_currentEntry", "_sentinel"],
 super: "Object",
 next$0: function() {
  if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
  this._currentEntry = this._currentEntry.get$_next();
  return this._currentEntry.get$element();
 },
 hasNext$0: function() {
  var t1 = this._currentEntry.get$_next();
  var t2 = this._sentinel;
  return !(t1 == null ? t2 == null : t1 === t2);
 },
 _DoubleLinkedQueueIterator$1: function(_sentinel) {
  this._currentEntry = this._sentinel;
 }
};

$$.StringBufferImpl = {"":
 ["_length", "_buffer"],
 super: "Object",
 toString$0: function() {
  if ($.get$length(this._buffer) === 0) return '';
  if ($.get$length(this._buffer) === 1) return $.index(this._buffer, 0);
  var result = $.StringBase_concatAll(this._buffer);
  $.clear(this._buffer);
  $.add$1(this._buffer, result);
  return result;
 },
 clear$0: function() {
  var t1 = $.ListFactory_List(null);
  $.setRuntimeTypeInfo(t1, ({E: 'String'}));
  this._buffer = t1;
  this._length = 0;
  return this;
 },
 addAll$1: function(objects) {
  for (var t1 = $.iterator(objects); t1.hasNext$0() === true; ) {
    this.add$1(t1.next$0());
  }
  return this;
 },
 add$1: function(obj) {
  var str = $.toString(obj);
  if (str == null || $.isEmpty(str) === true) return this;
  $.add$1(this._buffer, str);
  var t1 = this._length;
  if (typeof t1 !== 'number') return this.add$1$bailout(1, str, t1);
  var t3 = $.get$length(str);
  if (typeof t3 !== 'number') return this.add$1$bailout(2, t1, t3);
  this._length = t1 + t3;
  return this;
 },
 add$1$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      str = env0;
      t1 = env1;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
      var str = $.toString(obj);
      if (str == null || $.isEmpty(str) === true) return this;
      $.add$1(this._buffer, str);
      var t1 = this._length;
    case 1:
      state = 0;
      var t3 = $.get$length(str);
    case 2:
      state = 0;
      this._length = $.add(t1, t3);
      return this;
  }
 },
 isEmpty$0: function() {
  return this._length === 0;
 },
 get$length: function() {
  return this._length;
 },
 length$0: function() { return this.get$length().$call$0(); },
 StringBufferImpl$1: function(content$) {
  this.clear$0();
  this.add$1(content$);
 }
};

$$.JSSyntaxRegExp = {"":
 ["ignoreCase?", "multiLine?", "pattern?"],
 super: "Object",
 allMatches$1: function(str) {
  $.checkString(str);
  return $._AllMatchesIterable$(this, str);
 },
 hasMatch$1: function(str) {
  return $.regExpTest(this, $.checkString(str));
 },
 firstMatch$1: function(str) {
  var m = $.regExpExec(this, $.checkString(str));
  if (m == null) return;
  var matchStart = $.regExpMatchStart(m);
  var matchEnd = $.add(matchStart, $.get$length($.index(m, 0)));
  return $.MatchImplementation$(this.pattern, str, matchStart, matchEnd, m);
 },
 JSSyntaxRegExp$_globalVersionOf$1: function(other) {
  $.regExpAttachGlobalNative(this);
 },
 is$JSSyntaxRegExp: true
};

$$.MatchImplementation = {"":
 ["_groups", "_end", "_start", "str", "pattern?"],
 super: "Object",
 operator$index$1: function(index) {
  return this.group$1(index);
 },
 group$1: function(index) {
  return $.index(this._groups, index);
 }
};

$$._AllMatchesIterable = {"":
 ["_str", "_re"],
 super: "Object",
 iterator$0: function() {
  return $._AllMatchesIterator$(this._re, this._str);
 }
};

$$._AllMatchesIterator = {"":
 ["_done", "_next=", "_str", "_re"],
 super: "Object",
 hasNext$0: function() {
  if (this._done === true) return false;
  if (!(this._next == null)) return true;
  this._next = this._re.firstMatch$1(this._str);
  if (this._next == null) {
    this._done = true;
    return false;
  }
  return true;
 },
 next$0: function() {
  if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
  var next = this._next;
  this._next = null;
  return next;
 }
};

$$.ListIterator = {"":
 ["list", "i"],
 super: "Object",
 next$0: function() {
  if (this.hasNext$0() !== true) throw $.captureStackTrace($.NoMoreElementsException$());
  var value = (this.list[this.i]);
  var t1 = this.i;
  if (typeof t1 !== 'number') return this.next$0$bailout(1, t1, value);
  this.i = t1 + 1;
  return value;
 },
 next$0$bailout: function(state, t1, value) {
  this.i = $.add(t1, 1);
  return value;
 },
 hasNext$0: function() {
  var t1 = this.i;
  if (typeof t1 !== 'number') return this.hasNext$0$bailout(1, t1);
  return t1 < (this.list.length);
 },
 hasNext$0$bailout: function(state, t1) {
  return $.lt(t1, (this.list.length));
 }
};

$$.StackTrace = {"":
 ["stack"],
 super: "Object",
 toString$0: function() {
  var t1 = this.stack;
  return !(t1 == null) ? t1 : '';
 }
};

$$.Closure = {"":
 [],
 super: "Object",
 toString$0: function() {
  return 'Closure';
 }
};

$$.MetaInfo = {"":
 ["set?", "tags", "tag?"],
 super: "Object"
};

$$.StringMatch = {"":
 ["pattern?", "str", "_lib2_start"],
 super: "Object",
 group$1: function(group_) {
  if (!$.eqB(group_, 0)) throw $.captureStackTrace($.IndexOutOfRangeException$(group_));
  return this.pattern;
 },
 operator$index$1: function(g) {
  return this.group$1(g);
 }
};

$$.Object = {"":
 [],
 super: "",
 noSuchMethod$2: function(name$, args) {
  throw $.captureStackTrace($.NoSuchMethodException$(this, name$, args, null));
 },
 toString$0: function() {
  return $.Primitives_objectToString(this);
 },
 _lib3_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib4_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib5_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib2_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib6_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib5_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib1_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib7_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib0_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 _lib8_probeForLookup$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForLookup', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForLookup', [arg0])
},
 clipImage$13: function (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('clipImage', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12])
      : $.Object.prototype.noSuchMethod$2.call(this, 'clipImage', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12])
},
 _lib3_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib4_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib5_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib2_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib6_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib5_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib7_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib9_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib0_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib9_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 _lib8_setAttachedInfo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setAttachedInfo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setAttachedInfo', [arg0, arg1])
},
 $dom_addEventListener$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_addEventListener', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_addEventListener', [arg0, arg1, arg2])
},
 getContext$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getContext', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getContext', [arg0])
},
 getValues$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getValues', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getValues', [])
},
 getY$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getY', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getY', [])
},
 removeFirst$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('removeFirst', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'removeFirst', [])
},
 floor$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('floor', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'floor', [])
},
 truncate$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('truncate', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'truncate', [])
},
 render$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('render', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'render', [])
},
 render$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('render', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'render', [arg0, arg1])
},
 charCodeAt$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('charCodeAt', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'charCodeAt', [arg0])
},
 $dom_getItem$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_getItem', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_getItem', [arg0])
},
 isNaN$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('isNaN', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'isNaN', [])
},
 isInfinite$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('isInfinite', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'isInfinite', [])
},
 operator$le$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$le', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$le', [arg0])
},
 createPattern$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('createPattern', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'createPattern', [arg0, arg1])
},
 visitList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitList', [arg0])
},
 fillRect$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('fillRect', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'fillRect', [arg0, arg1, arg2, arg3])
},
 _lib3_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib4_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib5_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib2_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib6_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib5_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib1_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib7_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib0_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 _lib8_ensureCapacity$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_ensureCapacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_ensureCapacity', [])
},
 setBlending$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setBlending', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setBlending', [arg0])
},
 setSize$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setSize', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setSize', [arg0, arg1])
},
 operator$div$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$div', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$div', [arg0])
},
 $dom_setItem$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_setItem', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_setItem', [arg0, arg1])
},
 translate$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('translate', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'translate', [arg0, arg1])
},
 operator$tdiv$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$tdiv', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$tdiv', [arg0])
},
 extractRotation$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('extractRotation', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'extractRotation', [arg0])
},
 putImageData$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('putImageData', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'putImageData', [arg0, arg1, arg2])
},
 toInt$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('toInt', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'toInt', [])
},
 visitWorkerSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitWorkerSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitWorkerSendPort', [arg0])
},
 visitWorkerSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitWorkerSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitWorkerSendPort', [arg0])
},
 setLineJoin$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setLineJoin', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setLineJoin', [arg0])
},
 $dom_appendChild$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_appendChild', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_appendChild', [arg0])
},
 firstMatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('firstMatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'firstMatch', [arg0])
},
 addSelf$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('addSelf', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'addSelf', [arg0])
},
 remove$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('remove', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'remove', [])
},
 remove$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('remove', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'remove', [arg0])
},
 hasNext$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('hasNext', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'hasNext', [])
},
 _lib3_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib4_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib5_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib2_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib6_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib5_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib1_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib7_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib9_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib0_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib9_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 _lib8_add$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_add', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_add', [arg0, arg1])
},
 projectScene$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('projectScene', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'projectScene', [arg0, arg1, arg2])
},
 $dom_removeChild$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_removeChild', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_removeChild', [arg0])
},
 previousEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('previousEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'previousEntry', [])
},
 copy$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('copy', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'copy', [arg0])
},
 allMatches$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('allMatches', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'allMatches', [arg0])
},
 setHex$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setHex', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setHex', [arg0])
},
 getNextFace3InPool$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getNextFace3InPool', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getNextFace3InPool', [])
},
 arc$6: function (arg0, arg1, arg2, arg3, arg4, arg5) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('arc', [arg0, arg1, arg2, arg3, arg4, arg5])
      : $.Object.prototype.noSuchMethod$2.call(this, 'arc', [arg0, arg1, arg2, arg3, arg4, arg5])
},
 maybeCloseWorker$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('maybeCloseWorker', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'maybeCloseWorker', [])
},
 _lib3_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib4_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib5_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib2_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib6_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib5_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib7_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib9_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib0_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib9_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 _lib8_serializeList$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_serializeList', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_serializeList', [arg0])
},
 setRotationFromQuaternion$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setRotationFromQuaternion', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setRotationFromQuaternion', [arg0])
},
 restore$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('restore', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'restore', [])
},
 clipLine$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('clipLine', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'clipLine', [arg0, arg1])
},
 operator$mul$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$mul', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$mul', [arg0])
},
 add$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('add', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'add', [arg0])
},
 drawQuad$8: function (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('drawQuad', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7])
      : $.Object.prototype.noSuchMethod$2.call(this, 'drawQuad', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7])
},
 contains$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('contains', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'contains', [arg0])
},
 contains$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('contains', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'contains', [arg0, arg1])
},
 multiplyVector3$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('multiplyVector3', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'multiplyVector3', [arg0])
},
 minSelf$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('minSelf', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'minSelf', [arg0])
},
 addAll$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('addAll', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'addAll', [arg0])
},
 stroke$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('stroke', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'stroke', [])
},
 endsWith$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('endsWith', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'endsWith', [arg0])
},
 getImageData$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getImageData', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getImageData', [arg0, arg1, arg2, arg3])
},
 clearRect$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('clearRect', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'clearRect', [arg0, arg1, arg2, arg3])
},
 renderLine$5: function (arg0, arg1, arg2, arg3, arg4) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('renderLine', [arg0, arg1, arg2, arg3, arg4])
      : $.Object.prototype.noSuchMethod$2.call(this, 'renderLine', [arg0, arg1, arg2, arg3, arg4])
},
 postMessage$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('postMessage', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'postMessage', [arg0])
},
 addRectangle$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('addRectangle', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'addRectangle', [arg0])
},
 operator$shl$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$shl', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$shl', [arg0])
},
 setRotationFromMatrix$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setRotationFromMatrix', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setRotationFromMatrix', [arg0])
},
 renderFace4$9: function (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('renderFace4', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])
      : $.Object.prototype.noSuchMethod$2.call(this, 'renderFace4', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])
},
 setRGB$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setRGB', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setRGB', [arg0, arg1, arg2])
},
 smoothstep$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('smoothstep', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'smoothstep', [arg0, arg1, arg2])
},
 getInverse$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getInverse', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getInverse', [arg0])
},
 getNextLineInPool$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getNextLineInPool', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getNextLineInPool', [])
},
 operator$xor$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$xor', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$xor', [arg0])
},
 indexOf$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('indexOf', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'indexOf', [arg0])
},
 indexOf$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('indexOf', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'indexOf', [arg0, arg1])
},
 operator$sub$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$sub', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$sub', [arg0])
},
 getNextVertexInPool$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getNextVertexInPool', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getNextVertexInPool', [])
},
 abs$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('abs', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'abs', [])
},
 setInterval$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setInterval', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setInterval', [arg0, arg1])
},
 determinant$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('determinant', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'determinant', [])
},
 clear$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('clear', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'clear', [])
},
 $dom_key$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_key', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_key', [arg0])
},
 dequeue$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('dequeue', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'dequeue', [])
},
 $dom_removeEventListener$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_removeEventListener', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_removeEventListener', [arg0, arg1, arg2])
},
 multiplyScalar$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('multiplyScalar', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'multiplyScalar', [arg0])
},
 $call$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$call', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '$call', [])
},
 $call$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$call', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '$call', [arg0])
},
 $call$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$call', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '$call', [arg0, arg1])
},
 $call$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$call', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, '$call', [arg0, arg1, arg2])
},
 $call$6: function (arg0, arg1, arg2, arg3, arg4, arg5) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$call', [arg0, arg1, arg2, arg3, arg4, arg5])
      : $.Object.prototype.noSuchMethod$2.call(this, '$call', [arg0, arg1, arg2, arg3, arg4, arg5])
},
 forEach$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('forEach', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'forEach', [arg0])
},
 operator$indexSet$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$indexSet', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$indexSet', [arg0, arg1])
},
 getX$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getX', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getX', [])
},
 _lib3_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib4_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib5_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib2_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib6_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib5_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib7_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib9_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib0_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib9_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib8_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib3_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib4_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib5_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib2_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib6_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib5_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib7_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib9_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib0_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib9_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib8_setGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_setGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_setGlobals', [])
},
 _lib3_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib4_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib5_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib2_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib6_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib5_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib1_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib7_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib0_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 _lib8_link$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_link', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_link', [arg0, arg1])
},
 setOpacity$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setOpacity', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setOpacity', [arg0])
},
 addPoint$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('addPoint', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'addPoint', [arg0, arg1])
},
 _lib3_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib4_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib5_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib2_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib6_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib5_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib7_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib9_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib0_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib9_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 _lib8_clearAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_clearAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_clearAttachedInfo', [arg0])
},
 isNegative$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('isNegative', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'isNegative', [])
},
 hasMatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('hasMatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'hasMatch', [arg0])
},
 getNextParticleInPool$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getNextParticleInPool', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getNextParticleInPool', [])
},
 operator$add$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$add', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$add', [arg0])
},
 _lib3_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib4_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib5_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib2_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib6_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib5_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib7_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib9_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib0_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib9_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib8_runHelper$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_runHelper', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_runHelper', [])
},
 _lib3_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib4_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib5_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib2_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib6_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib5_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib1_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib7_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib0_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 _lib8_probeForAdding$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_probeForAdding', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_probeForAdding', [arg0])
},
 setStrokeStyle$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setStrokeStyle', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setStrokeStyle', [arg0])
},
 getLeft$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getLeft', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getLeft', [])
},
 removeRange$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('removeRange', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'removeRange', [arg0, arg1])
},
 removeRange$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('removeRange', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'removeRange', [arg0, arg1])
},
 program$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('program', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'program', [arg0])
},
 getHeight$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getHeight', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getHeight', [])
},
 setTransform$6: function (arg0, arg1, arg2, arg3, arg4, arg5) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setTransform', [arg0, arg1, arg2, arg3, arg4, arg5])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setTransform', [arg0, arg1, arg2, arg3, arg4, arg5])
},
 calculateLights$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('calculateLights', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'calculateLights', [arg0])
},
 _lib3_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib4_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib5_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib2_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib6_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib5_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib1_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib7_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib0_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 _lib8_asNonSentinelEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_asNonSentinelEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_asNonSentinelEntry', [])
},
 getContextStyle$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getContextStyle', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getContextStyle', [])
},
 cross$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('cross', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'cross', [arg0, arg1])
},
 setFromMatrix$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setFromMatrix', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setFromMatrix', [arg0])
},
 projectObject$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('projectObject', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'projectObject', [arg0])
},
 split$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('split', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'split', [arg0])
},
 drawImage$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('drawImage', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'drawImage', [arg0, arg1, arg2])
},
 getColumnX$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getColumnX', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getColumnX', [])
},
 _lib3_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib4_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib5_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib2_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib6_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib5_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib1_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib7_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib9_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib0_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib9_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 _lib8_remove$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_remove', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '_remove', [arg0, arg1])
},
 updateMatrix$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('updateMatrix', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'updateMatrix', [])
},
 hashCode$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('hashCode', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'hashCode', [])
},
 lineTo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lineTo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lineTo', [arg0, arg1])
},
 setLineWidth$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setLineWidth', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setLineWidth', [arg0])
},
 moveTo$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('moveTo', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'moveTo', [arg0, arg1])
},
 inflate$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('inflate', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'inflate', [arg0])
},
 getRange$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getRange', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getRange', [arg0, arg1])
},
 patternPath$13: function (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('patternPath', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12])
      : $.Object.prototype.noSuchMethod$2.call(this, 'patternPath', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12])
},
 normalToComponent$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('normalToComponent', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'normalToComponent', [arg0])
},
 visitSendPortSync$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitSendPortSync', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitSendPortSync', [arg0])
},
 cleanup$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('cleanup', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'cleanup', [])
},
 startsWith$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('startsWith', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'startsWith', [arg0])
},
 closePath$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('closePath', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'closePath', [])
},
 lookAt$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lookAt', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lookAt', [arg0])
},
 lookAt$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lookAt', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lookAt', [arg0, arg1, arg2])
},
 distanceTo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('distanceTo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'distanceTo', [arg0])
},
 init$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('init', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'init', [])
},
 save$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('save', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'save', [])
},
 rotateAxis$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('rotateAxis', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'rotateAxis', [arg0])
},
 setLineCap$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setLineCap', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setLineCap', [arg0])
},
 updateMatrixWorld$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('updateMatrixWorld', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'updateMatrixWorld', [])
},
 updateMatrixWorld$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('updateMatrixWorld', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'updateMatrixWorld', [arg0])
},
 setRotationFromEuler$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setRotationFromEuler', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setRotationFromEuler', [arg0, arg1])
},
 preventDefault$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('preventDefault', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'preventDefault', [])
},
 getNextObjectInPool$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getNextObjectInPool', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getNextObjectInPool', [])
},
 $dom_removeItem$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_removeItem', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_removeItem', [arg0])
},
 strokePath$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('strokePath', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'strokePath', [arg0, arg1, arg2, arg3])
},
 lastEntry$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lastEntry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lastEntry', [])
},
 compareTo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('compareTo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'compareTo', [arg0])
},
 length$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('length', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'length', [])
},
 getNextFace4InPool$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getNextFace4InPool', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getNextFace4InPool', [])
},
 calculateLight$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('calculateLight', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'calculateLight', [arg0, arg1, arg2, arg3])
},
 process$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('process', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'process', [])
},
 normalize$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('normalize', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'normalize', [])
},
 replaceWith$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('replaceWith', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'replaceWith', [arg0])
},
 containsKey$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('containsKey', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'containsKey', [arg0])
},
 getRight$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getRight', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getRight', [])
},
 clip$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('clip', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'clip', [])
},
 divideScalar$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('divideScalar', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'divideScalar', [arg0])
},
 divideScalar$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('divideScalar', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'divideScalar', [arg0])
},
 divideScalar$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('divideScalar', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'divideScalar', [arg0])
},
 divideScalar$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('divideScalar', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'divideScalar', [arg0])
},
 beginPath$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('beginPath', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'beginPath', [])
},
 last$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('last', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'last', [])
},
 last$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('last', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'last', [])
},
 last$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('last', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'last', [])
},
 add3Points$6: function (arg0, arg1, arg2, arg3, arg4, arg5) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('add3Points', [arg0, arg1, arg2, arg3, arg4, arg5])
      : $.Object.prototype.noSuchMethod$2.call(this, 'add3Points', [arg0, arg1, arg2, arg3, arg4, arg5])
},
 addObject$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('addObject', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'addObject', [arg0])
},
 sort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('sort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'sort', [arg0])
},
 getTop$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getTop', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getTop', [])
},
 next$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'next', [])
},
 operator$ge$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$ge', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$ge', [arg0])
},
 scale$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('scale', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'scale', [arg0])
},
 scale$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('scale', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'scale', [arg0, arg1])
},
 projectGraph$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('projectGraph', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'projectGraph', [arg0, arg1])
},
 _lib3_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib4_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib5_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib2_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib6_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib5_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib1_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib7_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib9_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib0_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib9_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 _lib8_toList$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_toList', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_toList', [])
},
 getBottom$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getBottom', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getBottom', [])
},
 filter$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('filter', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'filter', [arg0])
},
 expand$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('expand', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'expand', [arg0, arg1])
},
 _lib3_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib4_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib5_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib2_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib6_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib5_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib7_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib9_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib0_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib9_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib8_getAttachedInfo$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_getAttachedInfo', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_getAttachedInfo', [arg0])
},
 _lib3_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib4_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib5_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib2_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib6_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib5_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib7_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib9_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib0_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib9_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 _lib8_nativeInitWorkerMessageHandler$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeInitWorkerMessageHandler', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeInitWorkerMessageHandler', [])
},
 computeBoundingSphere$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('computeBoundingSphere', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'computeBoundingSphere', [])
},
 prepend$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('prepend', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'prepend', [arg0])
},
 runIteration$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('runIteration', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'runIteration', [])
},
 runIteration$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('runIteration', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'runIteration', [])
},
 _lib3_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib4_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib5_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib2_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib6_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib5_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib7_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib9_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib0_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib9_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib8_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib3_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib4_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib5_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib2_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib6_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib5_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib7_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib9_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib0_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib9_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib8_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib3_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib4_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib5_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib2_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib6_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib5_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib7_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib9_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib0_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib9_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 _lib8_dispatch$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_dispatch', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_dispatch', [arg0])
},
 operator$negate$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$negate', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$negate', [])
},
 intersects$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('intersects', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'intersects', [arg0])
},
 run$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('run', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'run', [])
},
 renderFace3$9: function (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('renderFace3', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])
      : $.Object.prototype.noSuchMethod$2.call(this, 'renderFace3', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])
},
 getColumnY$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getColumnY', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getColumnY', [])
},
 fill$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('fill', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'fill', [])
},
 visitPrimitive$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitPrimitive', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitPrimitive', [arg0])
},
 transform$6: function (arg0, arg1, arg2, arg3, arg4, arg5) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('transform', [arg0, arg1, arg2, arg3, arg4, arg5])
      : $.Object.prototype.noSuchMethod$2.call(this, 'transform', [arg0, arg1, arg2, arg3, arg4, arg5])
},
 animate$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('animate', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'animate', [])
},
 animate$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('animate', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'animate', [])
},
 distanceToSquared$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('distanceToSquared', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'distanceToSquared', [arg0])
},
 distanceToSquared$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('distanceToSquared', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'distanceToSquared', [arg0])
},
 setValues$16: function (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setValues', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setValues', [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15])
},
 setValues$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setValues', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setValues', [arg0, arg1])
},
 setValues$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setValues', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setValues', [arg0, arg1, arg2])
},
 setValues$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setValues', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setValues', [arg0, arg1, arg2, arg3])
},
 getPosition$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getPosition', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getPosition', [])
},
 addLast$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('addLast', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'addLast', [arg0])
},
 _lib3_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib4_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib5_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib2_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib6_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib5_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib7_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib9_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib0_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib9_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 _lib8_nativeDetectEnvironment$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_nativeDetectEnvironment', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_nativeDetectEnvironment', [])
},
 group$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('group', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'group', [arg0])
},
 group$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('group', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'group', [arg0])
},
 operator$index$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$index', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$index', [arg0])
},
 $dom_replaceChild$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_replaceChild', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_replaceChild', [arg0, arg1])
},
 lengthSq$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lengthSq', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lengthSq', [])
},
 lengthSq$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lengthSq', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lengthSq', [])
},
 lengthSq$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lengthSq', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lengthSq', [])
},
 lengthSq$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lengthSq', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lengthSq', [])
},
 getGradientTexture$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getGradientTexture', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getGradientTexture', [arg0, arg1, arg2, arg3])
},
 operator$lt$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$lt', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$lt', [arg0])
},
 drawTriangle$6: function (arg0, arg1, arg2, arg3, arg4, arg5) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('drawTriangle', [arg0, arg1, arg2, arg3, arg4, arg5])
      : $.Object.prototype.noSuchMethod$2.call(this, 'drawTriangle', [arg0, arg1, arg2, arg3, arg4, arg5])
},
 getWidth$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getWidth', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getWidth', [])
},
 getPropertyValue$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getPropertyValue', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getPropertyValue', [arg0])
},
 $dom_clear$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('$dom_clear', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '$dom_clear', [])
},
 operator$not$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$not', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$not', [])
},
 removeObject$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('removeObject', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'removeObject', [arg0])
},
 setFillStyle$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setFillStyle', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setFillStyle', [arg0])
},
 operator$and$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$and', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$and', [arg0])
},
 updateProjectionMatrix$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('updateProjectionMatrix', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'updateProjectionMatrix', [])
},
 removeLast$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('removeLast', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'removeLast', [])
},
 _lib3_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib4_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib5_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib2_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib6_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib5_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib1_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib7_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib0_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 _lib8_grow$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_grow', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, '_grow', [arg0])
},
 dot$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('dot', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'dot', [arg0])
},
 dot$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('dot', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'dot', [arg0])
},
 operator$gt$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$gt', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$gt', [arg0])
},
 initGlobals$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('initGlobals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'initGlobals', [])
},
 multiply$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('multiply', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'multiply', [arg0, arg1])
},
 multiplyVector4$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('multiplyVector4', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'multiplyVector4', [arg0])
},
 setProperty$3: function (arg0, arg1, arg2) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setProperty', [arg0, arg1, arg2])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setProperty', [arg0, arg1, arg2])
},
 rotate$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('rotate', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'rotate', [arg0])
},
 fillPath$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('fillPath', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'fillPath', [arg0])
},
 _lib3_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib4_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib5_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib2_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib6_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib5_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib1_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib7_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib0_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 _lib8_advance$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('_advance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, '_advance', [])
},
 resize$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('resize', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'resize', [])
},
 isEmpty$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('isEmpty', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'isEmpty', [])
},
 getColumnZ$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getColumnZ', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getColumnZ', [])
},
 renderParticle$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('renderParticle', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'renderParticle', [arg0, arg1, arg2, arg3])
},
 ceil$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('ceil', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'ceil', [])
},
 visitNativeJsSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitNativeJsSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitNativeJsSendPort', [arg0])
},
 visitNativeJsSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitNativeJsSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitNativeJsSendPort', [arg0])
},
 strokeRect$4: function (arg0, arg1, arg2, arg3) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('strokeRect', [arg0, arg1, arg2, arg3])
      : $.Object.prototype.noSuchMethod$2.call(this, 'strokeRect', [arg0, arg1, arg2, arg3])
},
 setTimeout$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setTimeout', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setTimeout', [arg0, arg1])
},
 reset$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('reset', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'reset', [])
},
 reset$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('reset', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'reset', [])
},
 operator$shr$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('operator$shr', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'operator$shr', [arg0])
},
 empty$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('empty', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'empty', [])
},
 eval$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('eval', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'eval', [arg0])
},
 substring$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('substring', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'substring', [arg0])
},
 substring$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('substring', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'substring', [arg0, arg1])
},
 iterator$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('iterator', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'iterator', [])
},
 setPosition$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('setPosition', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'setPosition', [arg0])
},
 visitMap$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitMap', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitMap', [arg0])
},
 first$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('first', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'first', [])
},
 sub$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('sub', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'sub', [arg0, arg1])
},
 getKeys$0: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('getKeys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'getKeys', [])
},
 visitSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitSendPort', [arg0])
},
 visitSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitSendPort', [arg0])
},
 visitSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitSendPort', [arg0])
},
 visitBufferingSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitBufferingSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitBufferingSendPort', [arg0])
},
 visitBufferingSendPort$1: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('visitBufferingSendPort', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'visitBufferingSendPort', [arg0])
},
 lerpSelf$2: function (arg0, arg1) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('lerpSelf', [arg0, arg1])
      : $.Object.prototype.noSuchMethod$2.call(this, 'lerpSelf', [arg0, arg1])
},
 get$offset: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get offset', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get offset', [])
},
 get$faceMaterial: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get faceMaterial', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get faceMaterial', [])
},
 get$_lib3_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib4_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib5_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib2_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib6_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib5_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib1_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib7_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib0_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$_lib8_element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _element', [])
},
 get$isWorker: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get isWorker', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get isWorker', [])
},
 get$far: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get far', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get far', [])
},
 get$key: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get key', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get key', [])
},
 get$y: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get y', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get y', [])
},
 get$_lib3_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib4_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib5_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib2_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib6_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib5_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib1_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib7_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib9_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib9_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$_lib8_id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _id', [])
},
 get$n34: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n34', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n34', [])
},
 get$g: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get g', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get g', [])
},
 get$$$dom_children: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get $dom_children', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get $dom_children', [])
},
 get$render: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get render', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get render', [])
},
 get$touches: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get touches', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get touches', [])
},
 get$_lib3_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib4_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib5_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib2_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib6_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib5_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib7_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib9_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib0_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib9_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$_lib8_receivePortId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePortId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePortId', [])
},
 get$width: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get width', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get width', [])
},
 get$boundingSphere: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get boundingSphere', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get boundingSphere', [])
},
 get$materials: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get materials', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get materials', [])
},
 get$rootContext: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get rootContext', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get rootContext', [])
},
 get$fromCommandLine: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get fromCommandLine', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get fromCommandLine', [])
},
 get$w: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get w', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get w', [])
},
 get$length: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get length', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get length', [])
},
 get$elements: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get elements', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get elements', [])
},
 get$currentManagerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get currentManagerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get currentManagerId', [])
},
 get$n14: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n14', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n14', [])
},
 get$_lib3_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib4_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib5_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib2_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib6_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib5_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib1_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib7_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib0_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$_lib8_next: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _next', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _next', [])
},
 get$n43: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n43', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n43', [])
},
 get$innerHeight: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get innerHeight', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get innerHeight', [])
},
 get$n11: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n11', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n11', [])
},
 get$image: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get image', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get image', [])
},
 get$v1: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get v1', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get v1', [])
},
 get$n21: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n21', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n21', [])
},
 get$mouseMove: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get mouseMove', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get mouseMove', [])
},
 get$v2: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get v2', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get v2', [])
},
 get$value: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get value', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get value', [])
},
 get$objects: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get objects', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get objects', [])
},
 get$lights: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get lights', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get lights', [])
},
 get$matrixWorldInverse: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get matrixWorldInverse', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get matrixWorldInverse', [])
},
 get$linecap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get linecap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get linecap', [])
},
 get$navigator: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get navigator', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get navigator', [])
},
 get$exceptionName: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get exceptionName', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get exceptionName', [])
},
 get$clientY: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get clientY', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get clientY', [])
},
 get$a: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get a', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get a', [])
},
 get$scale: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get scale', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get scale', [])
},
 get$n32: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n32', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n32', [])
},
 get$u: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get u', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get u', [])
},
 get$overdraw: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get overdraw', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get overdraw', [])
},
 get$envMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get envMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get envMap', [])
},
 get$id: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get id', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get id', [])
},
 get$_lib3_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib4_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib5_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib2_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib6_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib5_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib1_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib7_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib0_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$_lib8_keys: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _keys', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _keys', [])
},
 get$vertexNormalsWorld: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get vertexNormalsWorld', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get vertexNormalsWorld', [])
},
 get$materialIndex: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get materialIndex', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get materialIndex', [])
},
 get$wrapT: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get wrapT', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get wrapT', [])
},
 get$tag: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get tag', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get tag', [])
},
 get$data: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get data', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get data', [])
},
 get$v3: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get v3', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get v3', [])
},
 get$$$dom_childNodes: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get $dom_childNodes', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get $dom_childNodes', [])
},
 get$uvs: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get uvs', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get uvs', [])
},
 get$c: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get c', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get c', [])
},
 get$blending: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get blending', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get blending', [])
},
 get$topEventLoop: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get topEventLoop', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get topEventLoop', [])
},
 get$touchStart: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get touchStart', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get touchStart', [])
},
 get$n12: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n12', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n12', [])
},
 get$wireframe: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get wireframe', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get wireframe', [])
},
 get$intensity: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get intensity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get intensity', [])
},
 get$object: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get object', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get object', [])
},
 get$add: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get add', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get add', [])
},
 get$_lib3_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib4_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib5_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib2_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib6_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib5_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib1_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib7_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib0_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$_lib8_previous: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _previous', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _previous', [])
},
 get$distance: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get distance', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get distance', [])
},
 get$centroidWorld: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get centroidWorld', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get centroidWorld', [])
},
 get$linewidth: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get linewidth', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get linewidth', [])
},
 get$useWorkers: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get useWorkers', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get useWorkers', [])
},
 get$needSerialization: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get needSerialization', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get needSerialization', [])
},
 get$frustumCulled: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get frustumCulled', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get frustumCulled', [])
},
 get$height: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get height', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get height', [])
},
 get$onDocumentTouchStart: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get onDocumentTouchStart', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get onDocumentTouchStart', [])
},
 get$n23: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n23', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n23', [])
},
 get$normalWorld: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get normalWorld', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get normalWorld', [])
},
 get$pageX: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get pageX', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get pageX', [])
},
 get$opacity: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get opacity', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get opacity', [])
},
 get$color: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get color', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get color', [])
},
 get$n22: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n22', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n22', [])
},
 get$wireframeLinewidth: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get wireframeLinewidth', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get wireframeLinewidth', [])
},
 get$mapping: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get mapping', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get mapping', [])
},
 get$d: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get d', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get d', [])
},
 get$_lib3_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib4_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib5_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib2_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib6_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib5_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib7_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib9_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib0_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib9_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$_lib8_port: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _port', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _port', [])
},
 get$on: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get on', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get on', [])
},
 get$map: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get map', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get map', [])
},
 get$ignoreCase: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get ignoreCase', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get ignoreCase', [])
},
 get$_lib3_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib4_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib5_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib2_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib6_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib5_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib7_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib9_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib0_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib9_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$_lib8_receivePort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _receivePort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _receivePort', [])
},
 get$$$dom_length: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get $dom_length', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get $dom_length', [])
},
 get$_lib3_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib4_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib5_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib2_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib6_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib5_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib7_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib9_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib0_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib9_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$_lib8_workerId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _workerId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _workerId', [])
},
 get$n42: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n42', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n42', [])
},
 get$wrapS: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get wrapS', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get wrapS', [])
},
 get$clientX: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get clientX', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get clientX', [])
},
 get$b: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get b', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get b', [])
},
 get$repeat: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get repeat', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get repeat', [])
},
 get$z: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get z', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get z', [])
},
 get$ports: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get ports', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get ports', [])
},
 get$isolates: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get isolates', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get isolates', [])
},
 get$onDocumentTouchMove: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get onDocumentTouchMove', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get onDocumentTouchMove', [])
},
 get$rotation: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get rotation', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get rotation', [])
},
 get$body: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get body', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get body', [])
},
 get$needsUpdate: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get needsUpdate', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get needsUpdate', [])
},
 get$centroid: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get centroid', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get centroid', [])
},
 get$mainManager: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get mainManager', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get mainManager', [])
},
 get$element: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get element', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get element', [])
},
 get$$$dom_firstElementChild: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get $dom_firstElementChild', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get $dom_firstElementChild', [])
},
 get$set: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get set', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get set', [])
},
 get$_lib3_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib4_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib5_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib2_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib6_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib5_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib1_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib7_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib9_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib0_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib9_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$_lib8_filtered: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _filtered', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _filtered', [])
},
 get$nodes: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get nodes', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get nodes', [])
},
 get$centroidScreen: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get centroidScreen', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get centroidScreen', [])
},
 get$domElement: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get domElement', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get domElement', [])
},
 get$nextIsolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get nextIsolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get nextIsolateId', [])
},
 get$faces: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get faces', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get faces', [])
},
 get$wireframeLinecap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get wireframeLinecap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get wireframeLinecap', [])
},
 get$position: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get position', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get position', [])
},
 get$material: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get material', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get material', [])
},
 get$v4: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get v4', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get v4', [])
},
 get$positionWorld: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get positionWorld', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get positionWorld', [])
},
 get$faceVertexUvs: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get faceVertexUvs', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get faceVertexUvs', [])
},
 get$projectionMatrix: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get projectionMatrix', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get projectionMatrix', [])
},
 get$shading: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get shading', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get shading', [])
},
 get$touchMove: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get touchMove', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get touchMove', [])
},
 get$visible: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get visible', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get visible', [])
},
 get$pattern: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get pattern', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get pattern', [])
},
 get$positionScreen: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get positionScreen', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get positionScreen', [])
},
 get$n31: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n31', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n31', [])
},
 get$v: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get v', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get v', [])
},
 get$innerWidth: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get innerWidth', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get innerWidth', [])
},
 get$currentContext: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get currentContext', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get currentContext', [])
},
 get$near: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get near', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get near', [])
},
 get$n41: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n41', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n41', [])
},
 get$linejoin: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get linejoin', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get linejoin', [])
},
 get$onDocumentMouseMove: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get onDocumentMouseMove', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get onDocumentMouseMove', [])
},
 get$sprites: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get sprites', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get sprites', [])
},
 get$r: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get r', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get r', [])
},
 get$userAgent: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get userAgent', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get userAgent', [])
},
 get$x: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get x', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get x', [])
},
 get$pageY: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get pageY', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get pageY', [])
},
 get$matrixWorld: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get matrixWorld', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get matrixWorld', [])
},
 get$vertexNormals: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get vertexNormals', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get vertexNormals', [])
},
 get$geometry: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get geometry', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get geometry', [])
},
 get$n24: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n24', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n24', [])
},
 get$wireframeLinejoin: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get wireframeLinejoin', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get wireframeLinejoin', [])
},
 get$multiLine: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get multiLine', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get multiLine', [])
},
 get$painterSort: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get painterSort', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get painterSort', [])
},
 get$vertices: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get vertices', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get vertices', [])
},
 get$_lib3_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib4_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib5_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib2_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib6_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib5_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib1_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib7_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib0_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$_lib8_backingMap: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _backingMap', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _backingMap', [])
},
 get$n44: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n44', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n44', [])
},
 get$parent: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get parent', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get parent', [])
},
 get$children: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get children', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get children', [])
},
 get$p: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get p', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get p', [])
},
 get$_lib3_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib4_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib5_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib2_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib6_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib5_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib7_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib9_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib0_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib9_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$_lib8_isolateId: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get _isolateId', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get _isolateId', [])
},
 get$n13: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n13', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n13', [])
},
 get$normal: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get normal', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get normal', [])
},
 get$$$dom_lastElementChild: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get $dom_lastElementChild', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get $dom_lastElementChild', [])
},
 get$n33: function () {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('get n33', [])
      : $.Object.prototype.noSuchMethod$2.call(this, 'get n33', [])
},
 set$globalAlpha: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set globalAlpha', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set globalAlpha', [arg0])
},
 set$lights: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set lights', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set lights', [arg0])
},
 set$faceMaterial: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set faceMaterial', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set faceMaterial', [arg0])
},
 set$y: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set y', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set y', [arg0])
},
 set$g: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set g', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set g', [arg0])
},
 set$visible: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set visible', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set visible', [arg0])
},
 set$strokeStyle: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set strokeStyle', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set strokeStyle', [arg0])
},
 set$currentContext: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set currentContext', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set currentContext', [arg0])
},
 set$width: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set width', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set width', [arg0])
},
 set$rootContext: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set rootContext', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set rootContext', [arg0])
},
 set$b: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set b', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set b', [arg0])
},
 set$z: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set z', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set z', [arg0])
},
 set$w: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set w', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set w', [arg0])
},
 set$length: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set length', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set length', [arg0])
},
 set$r: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set r', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set r', [arg0])
},
 set$sprites: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set sprites', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set sprites', [arg0])
},
 set$_lib3_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib4_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib5_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib2_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib6_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib5_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib1_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib7_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib0_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$_lib8_previous: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _previous', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _previous', [arg0])
},
 set$x: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set x', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set x', [arg0])
},
 set$lineWidth: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set lineWidth', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set lineWidth', [arg0])
},
 set$elements: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set elements', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set elements', [arg0])
},
 set$rotation: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set rotation', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set rotation', [arg0])
},
 set$lineJoin: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set lineJoin', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set lineJoin', [arg0])
},
 set$lineCap: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set lineCap', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set lineCap', [arg0])
},
 set$text: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set text', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set text', [arg0])
},
 set$object: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set object', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set object', [arg0])
},
 set$globalCompositeOperation: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set globalCompositeOperation', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set globalCompositeOperation', [arg0])
},
 set$height: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set height', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set height', [arg0])
},
 set$_lib3_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib4_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib5_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib2_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib6_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib5_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib1_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib7_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib0_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$_lib8_next: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set _next', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set _next', [arg0])
},
 set$vertices: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set vertices', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set vertices', [arg0])
},
 set$needsUpdate: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set needsUpdate', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set needsUpdate', [arg0])
},
 set$nextIsolateId: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set nextIsolateId', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set nextIsolateId', [arg0])
},
 set$parent: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set parent', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set parent', [arg0])
},
 set$objects: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set objects', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set objects', [arg0])
},
 set$value: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set value', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set value', [arg0])
},
 set$faces: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set faces', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set faces', [arg0])
},
 set$fillStyle: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set fillStyle', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set fillStyle', [arg0])
},
 set$material: function (arg0) {
  return this.noSuchMethod$2
      ? this.noSuchMethod$2('set material', [arg0])
      : $.Object.prototype.noSuchMethod$2.call(this, 'set material', [arg0])
}
};

$$.IndexOutOfRangeException = {"":
 ["_value"],
 super: "Object",
 toString$0: function() {
  return 'IndexOutOfRangeException: ' + $.S(this._value);
 }
};

$$.NoSuchMethodException = {"":
 ["_existingArgumentNames", "_arguments", "_functionName", "_receiver"],
 super: "Object",
 toString$0: function() {
  var sb = $.StringBufferImpl$('');
  var t1 = this._arguments;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.toString$0$bailout(1, sb, t1);
  var i = 0;
  for (; i < t1.length; ++i) {
    i > 0 && sb.add$1(', ');
    var t2 = t1.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    sb.add$1(t1[i]);
  }
  t1 = this._existingArgumentNames;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.toString$0$bailout(2, t1, sb);
  var actualParameters = sb.toString$0();
  sb = $.StringBufferImpl$('');
  for (i = 0; i < t1.length; ++i) {
    i > 0 && sb.add$1(', ');
    t2 = t1.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    sb.add$1(t1[i]);
  }
  var formalParameters = sb.toString$0();
  t1 = this._functionName;
  return 'NoSuchMethodException: incorrect number of arguments passed to method named \'' + $.S(t1) + '\'\nReceiver: ' + $.S(this._receiver) + '\n' + 'Tried calling: ' + $.S(t1) + '(' + $.S(actualParameters) + ')\n' + 'Found: ' + $.S(t1) + '(' + $.S(formalParameters) + ')';
 },
 toString$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      sb = env0;
      t1 = env1;
      break;
    case 2:
      t1 = env0;
      sb = env1;
      break;
  }
  switch (state) {
    case 0:
      var sb = $.StringBufferImpl$('');
      var t1 = this._arguments;
    case 1:
      state = 0;
      var i = 0;
      for (; $.ltB(i, $.get$length(t1)); ++i) {
        i > 0 && sb.add$1(', ');
        sb.add$1($.index(t1, i));
      }
      t1 = this._existingArgumentNames;
    case 2:
      state = 0;
      if (t1 == null) return 'NoSuchMethodException : method not found: \'' + $.S(this._functionName) + '\'\n' + 'Receiver: ' + $.S(this._receiver) + '\n' + 'Arguments: [' + $.S(sb) + ']';
      var actualParameters = sb.toString$0();
      sb = $.StringBufferImpl$('');
      for (i = 0; $.ltB(i, $.get$length(t1)); ++i) {
        i > 0 && sb.add$1(', ');
        sb.add$1($.index(t1, i));
      }
      var formalParameters = sb.toString$0();
      t1 = this._functionName;
      return 'NoSuchMethodException: incorrect number of arguments passed to method named \'' + $.S(t1) + '\'\nReceiver: ' + $.S(this._receiver) + '\n' + 'Tried calling: ' + $.S(t1) + '(' + $.S(actualParameters) + ')\n' + 'Found: ' + $.S(t1) + '(' + $.S(formalParameters) + ')';
  }
 }
};

$$.ObjectNotClosureException = {"":
 [],
 super: "Object",
 toString$0: function() {
  return 'Object is not closure';
 }
};

$$.IllegalArgumentException = {"":
 ["_arg"],
 super: "Object",
 toString$0: function() {
  return 'Illegal argument(s): ' + $.S(this._arg);
 }
};

$$.StackOverflowException = {"":
 [],
 super: "Object",
 toString$0: function() {
  return 'Stack Overflow';
 }
};

$$.BadNumberFormatException = {"":
 ["_s"],
 super: "Object",
 toString$0: function() {
  return 'BadNumberFormatException: \'' + $.S(this._s) + '\'';
 }
};

$$.NullPointerException = {"":
 ["arguments", "functionName"],
 super: "Object",
 get$exceptionName: function() {
  return 'NullPointerException';
 },
 toString$0: function() {
  var t1 = this.functionName;
  if (t1 == null) return this.get$exceptionName();
  return $.S(this.get$exceptionName()) + ' : method: \'' + $.S(t1) + '\'\n' + 'Receiver: null\n' + 'Arguments: ' + $.S(this.arguments);
 }
};

$$.NoMoreElementsException = {"":
 [],
 super: "Object",
 toString$0: function() {
  return 'NoMoreElementsException';
 }
};

$$.EmptyQueueException = {"":
 [],
 super: "Object",
 toString$0: function() {
  return 'EmptyQueueException';
 }
};

$$.UnsupportedOperationException = {"":
 ["_message"],
 super: "Object",
 toString$0: function() {
  return 'UnsupportedOperationException: ' + $.S(this._message);
 }
};

$$.NotImplementedException = {"":
 ["_message"],
 super: "Object",
 toString$0: function() {
  var t1 = this._message;
  return !(t1 == null) ? 'NotImplementedException: ' + $.S(t1) : 'NotImplementedException';
 }
};

$$.IllegalJSRegExpException = {"":
 ["_errmsg", "_pattern"],
 super: "Object",
 toString$0: function() {
  return 'IllegalJSRegExpException: \'' + $.S(this._pattern) + '\' \'' + $.S(this._errmsg) + '\'';
 }
};

$$.Canvas_Lines = {"":
 ["windowHalfY", "windowHalfX", "mouseY", "mouseX", "geometry?", "material=", "renderer", "scene", "camera", "container"],
 super: "Object",
 run$0: function() {
  this.init$0();
  this.animate$0();
 },
 render$0: function() {
  var t1 = this.camera.get$position();
  t1.set$x($.add(t1.get$x(), $.mul($.sub(this.mouseX, this.camera.get$position().get$x()), 0.05)));
  t1 = this.camera.get$position();
  t1.set$y($.add(t1.get$y(), $.mul($.sub($.add($.neg(this.mouseY), 200), this.camera.get$position().get$y()), 0.05)));
  this.camera.lookAt$1(this.scene.get$position());
  this.renderer.render$2(this.scene, this.camera);
 },
 get$render: function() { return new $.BoundClosure(this, 'render$0'); },
 animate$0: function() {
  this.render$0();
 },
 onDocumentTouchMove$1: function(event$) {
  if ($.eqB($.get$length(event$.get$touches()), 1)) {
    event$.preventDefault$0();
    this.mouseX = $.sub($.index(event$.get$touches(), 0).get$pageX(), this.windowHalfX);
    this.mouseY = $.sub($.index(event$.get$touches(), 0).get$pageY(), this.windowHalfY);
  }
 },
 get$onDocumentTouchMove: function() { return new $.BoundClosure0(this, 'onDocumentTouchMove$1'); },
 onDocumentTouchStart$1: function(event$) {
  if ($.gtB($.get$length(event$.get$touches()), 1)) {
    event$.preventDefault$0();
    this.mouseX = $.sub($.index(event$.get$touches(), 0).get$pageX(), this.windowHalfX);
    this.mouseY = $.sub($.index(event$.get$touches(), 0).get$pageY(), this.windowHalfY);
  }
 },
 get$onDocumentTouchStart: function() { return new $.BoundClosure0(this, 'onDocumentTouchStart$1'); },
 onDocumentMouseMove$1: function(event$) {
  this.mouseX = $.sub(event$.get$clientX(), this.windowHalfX);
  this.mouseY = $.sub(event$.get$clientY(), this.windowHalfY);
 },
 get$onDocumentMouseMove: function() { return new $.BoundClosure0(this, 'onDocumentMouseMove$1'); },
 init$0: function() {
  this.windowHalfX = $.toInt($.div($.window().get$innerWidth(), 2));
  this.windowHalfY = $.toInt($.div($.window().get$innerHeight(), 2));
  this.container = $._ElementFactoryProvider_Element$tag('div');
  $.add$1($.document().get$body().get$nodes(), this.container);
  this.camera = $.PerspectiveCamera$(75, $.div($.window().get$innerWidth(), $.window().get$innerHeight()), 1, 10000);
  this.camera.get$position().set$z(100);
  this.scene = $.Scene$();
  $.add$1(this.scene, this.camera);
  this.renderer = $.CanvasRenderer$(null);
  this.renderer.setSize$2($.window().get$innerWidth(), $.window().get$innerHeight());
  $.add$1(this.container.get$nodes(), this.renderer.get$domElement());
  this.material = $.ParticleCanvasMaterial$($.makeLiteralMap(['color', 16777215, 'program', new $.Canvas_Lines_init_function(6.283185307179586)]));
  this.geometry = $.Geometry$();
  for (var i = 0, particle = null; i < 100; ++i) {
    particle = $.Particle$(this.material);
    var t1 = $.sub($.mul($.Math_random(), 2), 1);
    var t2 = particle.position;
    t2.set$x(t1);
    t2.set$y($.sub($.mul($.Math_random(), 2), 1));
    t2.set$z($.sub($.mul($.Math_random(), 2), 1));
    t2.normalize$0();
    t2.multiplyScalar$1($.add($.mul($.Math_random(), 10), 450));
    t1 = particle.scale;
    t1.set$y(5);
    t1.set$x(5);
    $.add$1(this.scene, particle);
    $.add$1(this.geometry.get$vertices(), $.Vertex$(t2));
  }
  var line = $.Line$(this.geometry, $.LineBasicMaterial$($.makeLiteralMap(['color', 16777215, 'opacity', 0.5])), 0);
  $.add$1(this.scene, line);
  $.add$1($.document().get$on().get$mouseMove(), this.get$onDocumentMouseMove());
  $.add$1($.document().get$on().get$touchStart(), this.get$onDocumentTouchStart());
  $.add$1($.document().get$on().get$touchMove(), this.get$onDocumentTouchMove());
  $.window().setInterval$2(new $.Canvas_Lines_init_f(this), 10);
 }
};

$$._AbstractWorkerEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._AudioContextEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._BatteryManagerEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._BodyElementEventsImpl = {"":
 ["_ptr"],
 super: "_ElementEventsImpl"
};

$$._DOMApplicationCacheEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._DedicatedWorkerContextEventsImpl = {"":
 ["_ptr"],
 super: "_WorkerContextEventsImpl"
};

$$._DeprecatedPeerConnectionEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._DocumentEventsImpl = {"":
 ["_ptr"],
 super: "_ElementEventsImpl",
 get$touchStart: function() {
  return this.operator$index$1('touchstart');
 },
 get$touchMove: function() {
  return this.operator$index$1('touchmove');
 },
 get$reset: function() {
  return this.operator$index$1('reset');
 },
 reset$0: function() { return this.get$reset().$call$0(); },
 get$mouseMove: function() {
  return this.operator$index$1('mousemove');
 },
 get$copy: function() {
  return this.operator$index$1('copy');
 },
 copy$1: function(arg0) { return this.get$copy().$call$1(arg0); }
};

$$.FilteredElementList = {"":
 ["_childNodes", "_node"],
 super: "Object",
 last$0: function() {
  return $.last(this.get$_filtered());
 },
 indexOf$2: function(element, start) {
  return $.indexOf$2(this.get$_filtered(), element, start);
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 getRange$2: function(start, rangeLength) {
  return $.getRange(this.get$_filtered(), start, rangeLength);
 },
 iterator$0: function() {
  return $.iterator(this.get$_filtered());
 },
 operator$index$1: function(index) {
  return $.index(this.get$_filtered(), index);
 },
 get$length: function() {
  return $.get$length(this.get$_filtered());
 },
 length$0: function() { return this.get$length().$call$0(); },
 isEmpty$0: function() {
  return $.isEmpty(this.get$_filtered());
 },
 filter$1: function(f) {
  return $.filter(this.get$_filtered(), f);
 },
 removeLast$0: function() {
  var result = this.last$0();
  !(result == null) && result.remove$0();
  return result;
 },
 clear$0: function() {
  $.clear(this._childNodes);
 },
 removeRange$2: function(start, rangeLength) {
  $.forEach($.getRange(this.get$_filtered(), start, rangeLength), new $.FilteredElementList_removeRange_anon());
 },
 sort$1: function(compare) {
  throw $.captureStackTrace($.CTC6);
 },
 addLast$1: function(value) {
  this.add$1(value);
 },
 addAll$1: function(collection) {
  $.forEach(collection, this.get$add());
 },
 add$1: function(value) {
  $.add$1(this._childNodes, value);
 },
 get$add: function() { return new $.BoundClosure0(this, 'add$1'); },
 set$length: function(newLength) {
  var len = $.get$length(this);
  if ($.geB(newLength, len)) return;
  if ($.ltB(newLength, 0)) throw $.captureStackTrace($.CTC5);
  this.removeRange$2($.sub(newLength, 1), $.sub(len, newLength));
 },
 operator$indexSet$2: function(index, value) {
  this.operator$index$1(index).replaceWith$1(value);
 },
 forEach$1: function(f) {
  $.forEach(this.get$_filtered(), f);
 },
 get$first: function() {
  for (var t1 = $.iterator(this._childNodes); t1.hasNext$0() === true; ) {
    var t2 = t1.next$0();
    if (typeof t2 === 'object' && t2 !== null && t2.is$Element()) return t2;
  }
  return;
 },
 first$0: function() { return this.get$first().$call$0(); },
 get$_filtered: function() {
  return $.ListFactory_List$from($.filter(this._childNodes, new $.FilteredElementList__filtered_anon()));
 },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._ChildrenElementList = {"":
 ["_childElements", "_lib_element?"],
 super: "Object",
 last$0: function() {
  return this._lib_element.get$$$dom_lastElementChild();
 },
 removeLast$0: function() {
  var result = this.last$0();
  !(result == null) && this._lib_element.$dom_removeChild$1(result);
  return result;
 },
 clear$0: function() {
  this._lib_element.set$text('');
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 getRange$2: function(start, rangeLength) {
  return $._FrozenElementList$_wrap($._Lists_getRange(this, start, rangeLength, []));
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.CTC7);
 },
 sort$1: function(compare) {
  throw $.captureStackTrace($.CTC6);
 },
 addAll$1: function(collection) {
  for (var t1 = $.iterator(collection), t2 = this._lib_element; t1.hasNext$0() === true; ) {
    t2.$dom_appendChild$1(t1.next$0());
  }
 },
 iterator$0: function() {
  return $.iterator(this._toList$0());
 },
 addLast$1: function(value) {
  return this.add$1(value);
 },
 add$1: function(value) {
  this._lib_element.$dom_appendChild$1(value);
  return value;
 },
 set$length: function(newLength) {
  throw $.captureStackTrace($.CTC4);
 },
 operator$indexSet$2: function(index, value) {
  this._lib_element.$dom_replaceChild$2(value, $.index(this._childElements, index));
 },
 operator$index$1: function(index) {
  return $.index(this._childElements, index);
 },
 get$length: function() {
  return $.get$length(this._childElements);
 },
 length$0: function() { return this.get$length().$call$0(); },
 isEmpty$0: function() {
  return this._lib_element.get$$$dom_firstElementChild() == null;
 },
 filter$1: function(f) {
  var output = [];
  this.forEach$1(new $._ChildrenElementList_filter_anon(f, output));
  return $._FrozenElementList$_wrap(output);
 },
 forEach$1: function(f) {
  for (var t1 = $.iterator(this._childElements); t1.hasNext$0() === true; ) {
    f.$call$1(t1.next$0());
  }
 },
 get$first: function() {
  return this._lib_element.get$$$dom_firstElementChild();
 },
 first$0: function() { return this.get$first().$call$0(); },
 _toList$0: function() {
  var t1 = this._childElements;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this._toList$0$bailout(1, t1);
  var output = $.ListFactory_List(t1.length);
  for (var len = t1.length, i = 0; i < len; ++i) {
    var t2 = t1.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    var t3 = t1[i];
    var t4 = output.length;
    if (i < 0 || i >= t4) throw $.ioore(i);
    output[i] = t3;
  }
  return output;
 },
 _toList$0$bailout: function(state, t1) {
  var output = $.ListFactory_List($.get$length(t1));
  for (var len = $.get$length(t1), i = 0; $.ltB(i, len); ++i) {
    var t2 = $.index(t1, i);
    var t3 = output.length;
    if (i < 0 || i >= t3) throw $.ioore(i);
    output[i] = t2;
  }
  return output;
 },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._FrozenElementList = {"":
 ["_nodeList"],
 super: "Object",
 last$0: function() {
  return $.last(this._nodeList);
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.CTC4);
 },
 clear$0: function() {
  throw $.captureStackTrace($.CTC4);
 },
 indexOf$2: function(element, start) {
  return $.indexOf$2(this._nodeList, element, start);
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 getRange$2: function(start, rangeLength) {
  return $._FrozenElementList$_wrap($.getRange(this._nodeList, start, rangeLength));
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.CTC4);
 },
 sort$1: function(compare) {
  throw $.captureStackTrace($.CTC4);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.CTC4);
 },
 iterator$0: function() {
  return $._FrozenElementListIterator$(this);
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.CTC4);
 },
 add$1: function(value) {
  throw $.captureStackTrace($.CTC4);
 },
 set$length: function(newLength) {
  $.set$length(this._nodeList, newLength);
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.CTC4);
 },
 operator$index$1: function(index) {
  return $.index(this._nodeList, index);
 },
 get$length: function() {
  return $.get$length(this._nodeList);
 },
 length$0: function() { return this.get$length().$call$0(); },
 isEmpty$0: function() {
  return $.isEmpty(this._nodeList);
 },
 filter$1: function(f) {
  var out = $._ElementList$([]);
  for (var t1 = this.iterator$0(); t1.hasNext$0() === true; ) {
    var t2 = t1.next$0();
    f.$call$1(t2) === true && out.add$1(t2);
  }
  return out;
 },
 forEach$1: function(f) {
  for (var t1 = this.iterator$0(); t1.hasNext$0() === true; ) {
    f.$call$1(t1.next$0());
  }
 },
 get$first: function() {
  return $.index(this._nodeList, 0);
 },
 first$0: function() { return this.get$first().$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._FrozenElementListIterator = {"":
 ["_index", "_lib_list"],
 super: "Object",
 hasNext$0: function() {
  var t1 = this._index;
  if (typeof t1 !== 'number') return this.hasNext$0$bailout(1, t1, 0);
  var t3 = $.get$length(this._lib_list);
  if (typeof t3 !== 'number') return this.hasNext$0$bailout(2, t1, t3);
  return t1 < t3;
 },
 hasNext$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._index;
    case 1:
      state = 0;
      var t3 = $.get$length(this._lib_list);
    case 2:
      state = 0;
      return $.lt(t1, t3);
  }
 },
 next$0: function() {
  if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
  var t1 = this._lib_list;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.next$0$bailout(1, t1, 0);
  var t3 = this._index;
  if (typeof t3 !== 'number') return this.next$0$bailout(2, t1, t3);
  this._index = t3 + 1;
  if (t3 !== (t3 | 0)) throw $.iae(t3);
  var t5 = t1.length;
  if (t3 < 0 || t3 >= t5) throw $.ioore(t3);
  return t1[t3];
 },
 next$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
      if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
      var t1 = this._lib_list;
    case 1:
      state = 0;
      var t3 = this._index;
    case 2:
      state = 0;
      this._index = $.add(t3, 1);
      return $.index(t1, t3);
  }
 }
};

$$._ElementList = {"":
 ["_lib_list"],
 super: "_ListWrapper",
 getRange$2: function(start, rangeLength) {
  return $._ElementList$($._ListWrapper.prototype.getRange$2.call(this, start, rangeLength));
 },
 filter$1: function(f) {
  return $._ElementList$($._ListWrapper.prototype.filter$1.call(this, f));
 },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._ElementEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl",
 get$touchStart: function() {
  return this.operator$index$1('touchstart');
 },
 get$touchMove: function() {
  return this.operator$index$1('touchmove');
 },
 get$reset: function() {
  return this.operator$index$1('reset');
 },
 reset$0: function() { return this.get$reset().$call$0(); },
 get$mouseMove: function() {
  return this.operator$index$1('mousemove');
 },
 get$copy: function() {
  return this.operator$index$1('copy');
 },
 copy$1: function(arg0) { return this.get$copy().$call$1(arg0); }
};

$$._EventSourceEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._EventsImpl = {"":
 ["_ptr"],
 super: "Object",
 operator$index$1: function(type) {
  return $._EventListenerListImpl$(this._ptr, type);
 }
};

$$._EventListenerListImpl = {"":
 ["_type", "_ptr"],
 super: "Object",
 _remove$2: function(listener, useCapture) {
  this._ptr.$dom_removeEventListener$3(this._type, listener, useCapture);
 },
 _add$2: function(listener, useCapture) {
  this._ptr.$dom_addEventListener$3(this._type, listener, useCapture);
 },
 remove$2: function(listener, useCapture) {
  this._remove$2(listener, useCapture);
  return this;
 },
 remove$1: function(listener) {
  return this.remove$2(listener,false)
},
 add$2: function(listener, useCapture) {
  this._add$2(listener, useCapture);
  return this;
 },
 add$1: function(listener) {
  return this.add$2(listener,false)
}
};

$$._FileReaderEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._FileWriterEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._FrameSetElementEventsImpl = {"":
 ["_ptr"],
 super: "_ElementEventsImpl"
};

$$._IDBDatabaseEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._IDBRequestEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._IDBTransactionEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._IDBVersionChangeRequestEventsImpl = {"":
 ["_ptr"],
 super: "_IDBRequestEventsImpl"
};

$$._InputElementEventsImpl = {"":
 ["_ptr"],
 super: "_ElementEventsImpl"
};

$$._JavaScriptAudioNodeEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._MediaElementEventsImpl = {"":
 ["_ptr"],
 super: "_ElementEventsImpl"
};

$$._MediaStreamEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._MediaStreamTrackListEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._MessagePortEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._ChildNodeListLazy = {"":
 ["_this"],
 super: "Object",
 operator$index$1: function(index) {
  return $.index(this._this.get$$$dom_childNodes(), index);
 },
 get$length: function() {
  return $.get$length(this._this.get$$$dom_childNodes());
 },
 length$0: function() { return this.get$length().$call$0(); },
 getRange$2: function(start, rangeLength) {
  return $._NodeListWrapper$($._Lists_getRange(this, start, rangeLength, []));
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._NodeListWrapper$($._Collections_filter(this, [], f));
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 iterator$0: function() {
  return $.iterator(this._this.get$$$dom_childNodes());
 },
 operator$indexSet$2: function(index, value) {
  this._this.$dom_replaceChild$2(value, this.operator$index$1(index));
 },
 clear$0: function() {
  this._this.set$text('');
 },
 removeLast$0: function() {
  var result = this.last$0();
  !(result == null) && this._this.$dom_removeChild$1(result);
  return result;
 },
 addAll$1: function(collection) {
  for (var t1 = $.iterator(collection), t2 = this._this; t1.hasNext$0() === true; ) {
    t2.$dom_appendChild$1(t1.next$0());
  }
 },
 addLast$1: function(value) {
  this._this.$dom_appendChild$1(value);
 },
 add$1: function(value) {
  this._this.$dom_appendChild$1(value);
 },
 last$0: function() {
  return this._this.lastChild;;
 },
 get$first: function() {
  return this._this.firstChild;;
 },
 first$0: function() { return this.get$first().$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._ListWrapper = {"":
 [],
 super: "Object",
 get$first: function() {
  return $.index(this._lib_list, 0);
 },
 first$0: function() { return this.get$first().$call$0(); },
 removeRange$2: function(start, rangeLength) {
  return $.removeRange(this._lib_list, start, rangeLength);
 },
 getRange$2: function(start, rangeLength) {
  return $.getRange(this._lib_list, start, rangeLength);
 },
 last$0: function() {
  return $.last(this._lib_list);
 },
 removeLast$0: function() {
  return $.removeLast(this._lib_list);
 },
 clear$0: function() {
  return $.clear(this._lib_list);
 },
 indexOf$2: function(element, start) {
  return $.indexOf$2(this._lib_list, element, start);
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  return $.sort(this._lib_list, compare);
 },
 addAll$1: function(collection) {
  return $.addAll(this._lib_list, collection);
 },
 addLast$1: function(value) {
  return $.addLast(this._lib_list, value);
 },
 add$1: function(value) {
  return $.add$1(this._lib_list, value);
 },
 set$length: function(newLength) {
  $.set$length(this._lib_list, newLength);
 },
 operator$indexSet$2: function(index, value) {
  $.indexSet(this._lib_list, index, value);
 },
 operator$index$1: function(index) {
  return $.index(this._lib_list, index);
 },
 get$length: function() {
  return $.get$length(this._lib_list);
 },
 length$0: function() { return this.get$length().$call$0(); },
 isEmpty$0: function() {
  return $.isEmpty(this._lib_list);
 },
 filter$1: function(f) {
  return $.filter(this._lib_list, f);
 },
 forEach$1: function(f) {
  return $.forEach(this._lib_list, f);
 },
 iterator$0: function() {
  return $.iterator(this._lib_list);
 },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._NodeListWrapper = {"":
 ["_lib_list"],
 super: "_ListWrapper",
 getRange$2: function(start, rangeLength) {
  return $._NodeListWrapper$($.getRange(this._lib_list, start, rangeLength));
 },
 filter$1: function(f) {
  return $._NodeListWrapper$($.filter(this._lib_list, f));
 },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._NotificationEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._PeerConnection00EventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._SVGElementInstanceEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl",
 get$reset: function() {
  return this.operator$index$1('reset');
 },
 reset$0: function() { return this.get$reset().$call$0(); },
 get$mouseMove: function() {
  return this.operator$index$1('mousemove');
 },
 get$copy: function() {
  return this.operator$index$1('copy');
 },
 copy$1: function(arg0) { return this.get$copy().$call$1(arg0); }
};

$$._SharedWorkerContextEventsImpl = {"":
 ["_ptr"],
 super: "_WorkerContextEventsImpl"
};

$$._SpeechRecognitionEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._TextTrackEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._TextTrackCueEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._TextTrackListEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._WebSocketEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._WindowEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl",
 get$touchStart: function() {
  return this.operator$index$1('touchstart');
 },
 get$touchMove: function() {
  return this.operator$index$1('touchmove');
 },
 get$reset: function() {
  return this.operator$index$1('reset');
 },
 reset$0: function() { return this.get$reset().$call$0(); },
 get$mouseMove: function() {
  return this.operator$index$1('mousemove');
 }
};

$$._WorkerEventsImpl = {"":
 ["_ptr"],
 super: "_AbstractWorkerEventsImpl"
};

$$._WorkerContextEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._XMLHttpRequestEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._XMLHttpRequestUploadEventsImpl = {"":
 ["_ptr"],
 super: "_EventsImpl"
};

$$._IDBOpenDBRequestEventsImpl = {"":
 ["_ptr"],
 super: "_IDBRequestEventsImpl"
};

$$._FixedSizeListIterator = {"":
 ["_lib_length", "_pos", "_array"],
 super: "_VariableSizeListIterator",
 hasNext$0: function() {
  var t1 = this._lib_length;
  if (typeof t1 !== 'number') return this.hasNext$0$bailout(1, t1, 0);
  var t3 = this._pos;
  if (typeof t3 !== 'number') return this.hasNext$0$bailout(2, t1, t3);
  return t1 > t3;
 },
 hasNext$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._lib_length;
    case 1:
      state = 0;
      var t3 = this._pos;
    case 2:
      state = 0;
      return $.gt(t1, t3);
  }
 }
};

$$._VariableSizeListIterator = {"":
 [],
 super: "Object",
 next$0: function() {
  if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
  var t1 = this._array;
  if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.next$0$bailout(1, t1, 0);
  var t3 = this._pos;
  if (typeof t3 !== 'number') return this.next$0$bailout(2, t1, t3);
  this._pos = t3 + 1;
  if (t3 !== (t3 | 0)) throw $.iae(t3);
  var t5 = t1.length;
  if (t3 < 0 || t3 >= t5) throw $.ioore(t3);
  return t1[t3];
 },
 next$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
      if (this.hasNext$0() !== true) throw $.captureStackTrace($.CTC1);
      var t1 = this._array;
    case 1:
      state = 0;
      var t3 = this._pos;
    case 2:
      state = 0;
      this._pos = $.add(t3, 1);
      return $.index(t1, t3);
  }
 },
 hasNext$0: function() {
  var t1 = $.get$length(this._array);
  if (typeof t1 !== 'number') return this.hasNext$0$bailout(1, t1, 0);
  var t3 = this._pos;
  if (typeof t3 !== 'number') return this.hasNext$0$bailout(2, t3, t1);
  return t1 > t3;
 },
 hasNext$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t3 = env0;
      t1 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = $.get$length(this._array);
    case 1:
      state = 0;
      var t3 = this._pos;
    case 2:
      state = 0;
      return $.gt(t1, t3);
  }
 }
};

$$._MessageTraverserVisitedMap = {"":
 [],
 super: "Object",
 cleanup$0: function() {
 },
 reset$0: function() {
 },
 operator$indexSet$2: function(object, info) {
 },
 operator$index$1: function(object) {
  return;
 }
};

$$._MessageTraverser = {"":
 [],
 super: "Object",
 _dispatch$1: function(x) {
  if ($._MessageTraverser_isPrimitive(x) === true) return this.visitPrimitive$1(x);
  if (typeof x === 'object' && x !== null && (x.constructor === Array || x.is$List())) return this.visitList$1(x);
  if (typeof x === 'object' && x !== null && x.is$Map()) return this.visitMap$1(x);
  if (typeof x === 'object' && x !== null && !!x.is$SendPort) return this.visitSendPort$1(x);
  if (typeof x === 'object' && x !== null && !!x.is$SendPortSync) return this.visitSendPortSync$1(x);
  throw $.captureStackTrace('Message serialization: Illegal value ' + $.S(x) + ' passed');
 },
 traverse$1: function(x) {
  if ($._MessageTraverser_isPrimitive(x) === true) return this.visitPrimitive$1(x);
  var t1 = this._visited;
  t1.reset$0();
  var result = null;
  try {
    result = this._dispatch$1(x);
  } finally {
    t1.cleanup$0();
  }
  return result;
 }
};

$$._Copier = {"":
 [],
 super: "_MessageTraverser",
 visitMap$1: function(map) {
  var t1 = ({});
  var t2 = this._visited;
  t1.copy_1 = $.index(t2, map);
  var t3 = t1.copy_1;
  if (!(t3 == null)) return t3;
  t1.copy_1 = $.HashMapImplementation$();
  $.indexSet(t2, map, t1.copy_1);
  $.forEach(map, new $._Copier_visitMap_anon(this, t1));
  return t1.copy_1;
 },
 visitList$1: function(list) {
  if (typeof list !== 'string' && (typeof list !== 'object' || list === null || (list.constructor !== Array && !list.is$JavaScriptIndexingBehavior()))) return this.visitList$1$bailout(1, list);
  var t1 = this._visited;
  var copy = t1.operator$index$1(list);
  if (!(copy == null)) return copy;
  var len = list.length;
  copy = $.ListFactory_List(len);
  t1.operator$indexSet$2(list, copy);
  for (var i = 0; i < len; ++i) {
    t1 = list.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var t2 = this._dispatch$1(list[i]);
    var t3 = copy.length;
    if (i < 0 || i >= t3) throw $.ioore(i);
    copy[i] = t2;
  }
  return copy;
 },
 visitList$1$bailout: function(state, list) {
  var t1 = this._visited;
  var copy = $.index(t1, list);
  if (!(copy == null)) return copy;
  var len = $.get$length(list);
  copy = $.ListFactory_List(len);
  $.indexSet(t1, list, copy);
  for (var i = 0; $.ltB(i, len); ++i) {
    t1 = this._dispatch$1($.index(list, i));
    var t2 = copy.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    copy[i] = t1;
  }
  return copy;
 },
 visitPrimitive$1: function(x) {
  return x;
 }
};

$$._Serializer = {"":
 [],
 super: "_MessageTraverser",
 _serializeList$1: function(list) {
  if (typeof list !== 'string' && (typeof list !== 'object' || list === null || (list.constructor !== Array && !list.is$JavaScriptIndexingBehavior()))) return this._serializeList$1$bailout(1, list);
  var len = list.length;
  var result = $.ListFactory_List(len);
  for (var i = 0; i < len; ++i) {
    var t1 = list.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var t2 = this._dispatch$1(list[i]);
    var t3 = result.length;
    if (i < 0 || i >= t3) throw $.ioore(i);
    result[i] = t2;
  }
  return result;
 },
 _serializeList$1$bailout: function(state, list) {
  var len = $.get$length(list);
  var result = $.ListFactory_List(len);
  for (var i = 0; $.ltB(i, len); ++i) {
    var t1 = this._dispatch$1($.index(list, i));
    var t2 = result.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    result[i] = t1;
  }
  return result;
 },
 visitMap$1: function(map) {
  var t1 = this._visited;
  var copyId = $.index(t1, map);
  if (!(copyId == null)) return ['ref', copyId];
  var id = this._nextFreeRefId;
  this._nextFreeRefId = id + 1;
  $.indexSet(t1, map, id);
  return ['map', id, this._serializeList$1(map.getKeys$0()), this._serializeList$1(map.getValues$0())];
 },
 visitList$1: function(list) {
  var t1 = this._visited;
  var copyId = $.index(t1, list);
  if (!(copyId == null)) return ['ref', copyId];
  var id = this._nextFreeRefId;
  this._nextFreeRefId = id + 1;
  $.indexSet(t1, list, id);
  return ['list', id, this._serializeList$1(list)];
 },
 visitPrimitive$1: function(x) {
  return x;
 }
};

$$._Manager = {"":
 ["managers", "mainManager?", "isolates?", "supportsWorkers", "isWorker?", "fromCommandLine?", "topEventLoop?", "rootContext=", "currentContext=", "nextManagerId", "currentManagerId?", "nextIsolateId="],
 super: "Object",
 maybeCloseWorker$0: function() {
  $.isEmpty(this.isolates) === true && this.mainManager.postMessage$1($._serializeMessage($.makeLiteralMap(['command', 'close'])));
 },
 _nativeInitWorkerMessageHandler$0: function() {
      $globalThis.onmessage = function (e) {
      _IsolateNatives._processWorkerMessage(this.mainManager, e);
    }
  ;
 },
 _nativeDetectEnvironment$0: function() {
      this.isWorker = $isWorker;
    this.supportsWorkers = $supportsWorkers;
    this.fromCommandLine = typeof(window) == 'undefined';
  ;
 },
 get$needSerialization: function() {
  return this.get$useWorkers();
 },
 get$useWorkers: function() {
  return this.supportsWorkers;
 },
 _Manager$0: function() {
  this._nativeDetectEnvironment$0();
  this.topEventLoop = $._EventLoop$();
  this.isolates = $.HashMapImplementation$();
  this.managers = $.HashMapImplementation$();
  if (this.isWorker === true) {
    this.mainManager = $._MainManagerStub$();
    this._nativeInitWorkerMessageHandler$0();
  }
 }
};

$$._IsolateContext = {"":
 ["isolateStatics", "ports?", "id?"],
 super: "Object",
 _setGlobals$0: function() {
  $setGlobals(this);;
 },
 eval$1: function(code) {
  var old = $._globalState().get$currentContext();
  $._globalState().set$currentContext(this);
  this._setGlobals$0();
  var result = null;
  try {
    result = code.$call$0();
  } finally {
    var t1 = old;
    $._globalState().set$currentContext(t1);
    t1 = old;
    !(t1 == null) && t1._setGlobals$0();
  }
  return result;
 },
 initGlobals$0: function() {
  $initGlobals(this);;
 },
 _IsolateContext$0: function() {
  var t1 = $._globalState();
  var t2 = t1.get$nextIsolateId();
  t1.set$nextIsolateId($.add(t2, 1));
  this.id = t2;
  this.ports = $.HashMapImplementation$();
  this.initGlobals$0();
 }
};

$$._EventLoop = {"":
 ["events"],
 super: "Object",
 run$0: function() {
  if ($._globalState().get$isWorker() !== true) this._runHelper$0();
  else {
    try {
      this._runHelper$0();
    } catch (exception) {
      var t1 = $.unwrapException(exception);
      var e = t1;
      var trace = $.getTraceFromException(exception);
      $._globalState().get$mainManager().postMessage$1($._serializeMessage($.makeLiteralMap(['command', 'error', 'msg', $.S(e) + '\n' + $.S(trace)])));
    }
  }
 },
 _runHelper$0: function() {
  if (!($._window() == null)) new $._EventLoop__runHelper_next(this).$call$0();
  else {
    for (; this.runIteration$0() === true; ) {
    }
  }
 },
 runIteration$0: function() {
  var event$ = this.dequeue$0();
  if (event$ == null) {
    if ($._globalState().get$isWorker() === true) $._globalState().maybeCloseWorker$0();
    else {
      if (!($._globalState().get$rootContext() == null) && ($._globalState().get$isolates().containsKey$1($._globalState().get$rootContext().get$id()) === true && ($._globalState().get$fromCommandLine() === true && $.isEmpty($._globalState().get$rootContext().get$ports()) === true))) throw $.captureStackTrace($.ExceptionImplementation$('Program exited with open ReceivePorts.'));
    }
    return false;
  }
  event$.process$0();
  return true;
 },
 dequeue$0: function() {
  var t1 = this.events;
  if ($.isEmpty(t1) === true) return;
  return t1.removeFirst$0();
 }
};

$$._MainManagerStub = {"":
 [],
 super: "Object",
 postMessage$1: function(msg) {
  $globalThis.postMessage(msg);;
 },
 get$id: function() {
  return 0;
 }
};

$$._BaseSendPort = {"":
 ["_isolateId?"],
 super: "Object",
 is$SendPort: true
};

$$._NativeJsSendPort = {"":
 ["_receivePort?", "_isolateId"],
 super: "_BaseSendPort",
 hashCode$0: function() {
  return this._receivePort.get$_lib1_id();
 },
 operator$eq$1: function(other) {
  return typeof other === 'object' && other !== null && !!other.is$_NativeJsSendPort && $.eqB(this._receivePort, other._receivePort);
 },
 is$_NativeJsSendPort: true,
 is$SendPort: true
};

$$._WorkerSendPort = {"":
 ["_receivePortId?", "_workerId?", "_isolateId"],
 super: "_BaseSendPort",
 hashCode$0: function() {
  return $.xor($.xor($.shl(this._workerId, 16), $.shl(this._isolateId, 8)), this._receivePortId);
 },
 operator$eq$1: function(other) {
  if (typeof other === 'object' && other !== null && !!other.is$_WorkerSendPort) {
    var t1 = $.eqB(this._workerId, other._workerId) && ($.eqB(this._isolateId, other._isolateId) && $.eqB(this._receivePortId, other._receivePortId));
  } else t1 = false;
  return t1;
 },
 is$_WorkerSendPort: true,
 is$SendPort: true
};

$$._JsSerializer = {"":
 ["_nextFreeRefId", "_visited"],
 super: "_Serializer",
 visitBufferingSendPort$1: function(port) {
  if (!(port.get$_port() == null)) return this.visitSendPort$1(port.get$_port());
  throw $.captureStackTrace('internal error: must call _waitForPendingPorts to ensure all ports are resolved at this point.');
 },
 visitWorkerSendPort$1: function(port) {
  return ['sendport', port.get$_workerId(), port.get$_isolateId(), port.get$_receivePortId()];
 },
 visitNativeJsSendPort$1: function(port) {
  return ['sendport', $._globalState().get$currentManagerId(), port.get$_isolateId(), port.get$_receivePort().get$_lib1_id()];
 },
 visitSendPort$1: function(x) {
  if (typeof x === 'object' && x !== null && !!x.is$_NativeJsSendPort) return this.visitNativeJsSendPort$1(x);
  if (typeof x === 'object' && x !== null && !!x.is$_WorkerSendPort) return this.visitWorkerSendPort$1(x);
  if (typeof x === 'object' && x !== null && !!x.is$_BufferingSendPort) return this.visitBufferingSendPort$1(x);
  throw $.captureStackTrace('Illegal underlying port ' + $.S(x));
 },
 _JsSerializer$0: function() {
  this._visited = $._JsVisitedMap$();
 }
};

$$._JsCopier = {"":
 ["_visited"],
 super: "_Copier",
 visitBufferingSendPort$1: function(port) {
  if (!(port.get$_port() == null)) return this.visitSendPort$1(port.get$_port());
  throw $.captureStackTrace('internal error: must call _waitForPendingPorts to ensure all ports are resolved at this point.');
 },
 visitWorkerSendPort$1: function(port) {
  return $._WorkerSendPort$(port.get$_workerId(), port.get$_isolateId(), port.get$_receivePortId());
 },
 visitNativeJsSendPort$1: function(port) {
  return $._NativeJsSendPort$(port.get$_receivePort(), port.get$_isolateId());
 },
 visitSendPort$1: function(x) {
  if (typeof x === 'object' && x !== null && !!x.is$_NativeJsSendPort) return this.visitNativeJsSendPort$1(x);
  if (typeof x === 'object' && x !== null && !!x.is$_WorkerSendPort) return this.visitWorkerSendPort$1(x);
  if (typeof x === 'object' && x !== null && !!x.is$_BufferingSendPort) return this.visitBufferingSendPort$1(x);
  throw $.captureStackTrace('Illegal underlying port ' + $.S(this.get$p()));
 },
 _JsCopier$0: function() {
  this._visited = $._JsVisitedMap$();
 }
};

$$._JsVisitedMap = {"":
 ["tagged"],
 super: "Object",
 _getAttachedInfo$1: function(o) {
  return o['__MessageTraverser__attached_info__'];;
 },
 _setAttachedInfo$2: function(o, info) {
  o['__MessageTraverser__attached_info__'] = info;;
 },
 _clearAttachedInfo$1: function(o) {
  o['__MessageTraverser__attached_info__'] = (void 0);;
 },
 cleanup$0: function() {
  var length$ = $.get$length(this.tagged);
  if (typeof length$ !== 'number') return this.cleanup$0$bailout(1, length$);
  var i = 0;
  for (; i < length$; ++i) {
    this._clearAttachedInfo$1($.index(this.tagged, i));
  }
  this.tagged = null;
 },
 cleanup$0$bailout: function(state, length$) {
  var i = 0;
  for (; $.ltB(i, length$); ++i) {
    this._clearAttachedInfo$1($.index(this.tagged, i));
  }
  this.tagged = null;
 },
 reset$0: function() {
  this.tagged = $.ListFactory_List(null);
 },
 operator$indexSet$2: function(object, info) {
  $.add$1(this.tagged, object);
  this._setAttachedInfo$2(object, info);
 },
 operator$index$1: function(object) {
  return this._getAttachedInfo$1(object);
 }
};

$$.Camera = {"":
 ["projectionMatrix?", "matrixWorldInverse?"],
 super: "Object3D",
 lookAt$1: function(vector) {
  var t1 = this.matrix;
  t1.lookAt$3(this.position, vector, this.up);
  this.rotationAutoUpdate === true && this.rotation.setRotationFromMatrix$1(t1);
 },
 Camera$0: function() {
  this.matrixWorldInverse = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this.projectionMatrix = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this.projectionMatrixInverse = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
 },
 is$Camera: true
};

$$.PerspectiveCamera = {"":
 ["_height", "_width", "_y", "_x", "_fullHeight", "_fullWidth", "_far", "_near", "_aspect", "_fov", "projectionMatrixInverse", "projectionMatrix", "matrixWorldInverse", "_vector", "frustumCulled", "receiveShadow", "castShadow", "visible", "boundRadiusScale", "boundRadius", "useQuaternion", "quaternion", "matrixWorldNeedsUpdate", "matrixAutoUpdate", "matrixRotationWorld", "matrixWorld", "matrix", "renderDepth", "rotationAutoUpdate", "flipSided", "doubleSided", "dynamic", "eulerOrder", "scale", "rotation", "position", "up", "children", "parent", "id", "_name"],
 super: "Camera",
 updateProjectionMatrix$0: function() {
  var t1 = this._fullWidth;
  var t2 = !(t1 == null);
  var t3 = this._near;
  var t4 = this._fov;
  var t5 = this._far;
  if (t2) {
    t2 = this._fullHeight;
    var aspect = $.div(t1, t2);
    var top$ = $.mul($.Math_tan($.div($.mul(t4, 3.141592653589793), 360)), t3);
    var bottom = $.neg(top$);
    var left = $.mul(aspect, bottom);
    var width = $.abs($.sub($.mul(aspect, top$), left));
    var height = $.abs($.sub(top$, bottom));
    var t6 = this._x;
    var t7 = $.add(left, $.div($.mul(t6, width), t1));
    var t8 = $.add(left, $.div($.mul($.add(t6, width), width), t1));
    var t9 = this._y;
    this.projectionMatrix = $.Matrix4_makeFrustum(t7, t8, $.sub(top$, $.div($.mul($.add(t9, height), height), t2)), $.sub(top$, $.div($.mul(t9, height), t2)), t3, t5);
  } else this.projectionMatrix = $.Matrix4_makePerspective(t4, this._aspect, t3, t5);
 },
 get$far: function() {
  return this._far;
 },
 get$near: function() {
  return this._near;
 },
 PerspectiveCamera$4: function(fov, aspect, near, far) {
  this._fov = !(fov == null) ? fov : 50;
  this._aspect = !(aspect == null) ? aspect : 1;
  this._near = !(near == null) ? near : 0.1;
  this._far = !(far == null) ? far : 2000;
  this.updateProjectionMatrix$0();
 }
};

$$.Vector3 = {"":
 ["_z", "_y", "_x"],
 super: "Object",
 setRotationFromMatrix$1: function(m) {
  var cosY = $.Math_cos(this._y);
  this._y = $.Math_asin(m.get$n13());
  if ($.gtB($.abs(cosY), 0.00001)) {
    this._x = $.Math_atan2($.div($.neg(m.get$n23()), cosY), $.div(m.get$n33(), cosY));
    this._z = $.Math_atan2($.div($.neg(m.get$n12()), cosY), $.div(m.get$n11(), cosY));
  } else {
    this._x = 0;
    this._z = $.Math_atan2(m.get$n21(), m.get$n22());
  }
 },
 distanceToSquared$1: function(v) {
  return $.Vector3$(0, 0, 0).sub$2(this, v).lengthSq$0();
 },
 distanceTo$1: function(v) {
  return $.Math_sqrt(this.distanceToSquared$1(v));
 },
 cross$2: function(a, b) {
  this._x = $.sub($.mul(a.get$y(), b.get$z()), $.mul(a.get$z(), b.get$y()));
  this._y = $.sub($.mul(a.get$z(), b.get$x()), $.mul(a.get$x(), b.get$z()));
  this._z = $.sub($.mul(a.get$x(), b.get$y()), $.mul(a.get$y(), b.get$x()));
  return this;
 },
 normalize$0: function() {
  return this.divideScalar$1(this.length$0());
 },
 length$0: function() {
  return $.Math_sqrt(this.lengthSq$0());
 },
 get$length: function() { return new $.BoundClosure(this, 'length$0'); },
 lengthSq$0: function() {
  var t1 = this._x;
  t1 = $.mul(t1, t1);
  var t2 = this._y;
  t1 = $.add(t1, $.mul(t2, t2));
  var t3 = this._z;
  return $.add(t1, $.mul(t3, t3));
 },
 dot$1: function(v) {
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.dot$1$bailout(1, v, t1, 0, 0);
  var t3 = v.get$x();
  if (typeof t3 !== 'number') return this.dot$1$bailout(2, v, t3, t1, 0);
  t3 *= t1;
  t1 = this._y;
  if (typeof t1 !== 'number') return this.dot$1$bailout(3, v, t3, t1, 0);
  var t6 = v.get$y();
  if (typeof t6 !== 'number') return this.dot$1$bailout(4, v, t6, t3, t1);
  t3 += t1 * t6;
  var t8 = this._z;
  if (typeof t8 !== 'number') return this.dot$1$bailout(5, v, t3, t8, 0);
  var t10 = v.get$z();
  if (typeof t10 !== 'number') return this.dot$1$bailout(6, t3, t10, t8, 0);
  return t3 + t8 * t10;
 },
 dot$1$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var v = env0;
      t1 = env1;
      break;
    case 2:
      v = env0;
      t3 = env1;
      t1 = env2;
      break;
    case 3:
      v = env0;
      t3 = env1;
      t1 = env2;
      break;
    case 4:
      v = env0;
      t6 = env1;
      t3 = env2;
      t1 = env3;
      break;
    case 5:
      v = env0;
      t3 = env1;
      t8 = env2;
      break;
    case 6:
      t3 = env0;
      t10 = env1;
      t8 = env2;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._x;
    case 1:
      state = 0;
      var t3 = v.get$x();
    case 2:
      state = 0;
      t3 = $.mul(t1, t3);
      t1 = this._y;
    case 3:
      state = 0;
      var t6 = v.get$y();
    case 4:
      state = 0;
      t3 = $.add(t3, $.mul(t1, t6));
      var t8 = this._z;
    case 5:
      state = 0;
      var t10 = v.get$z();
    case 6:
      state = 0;
      return $.add(t3, $.mul(t8, t10));
  }
 },
 divideScalar$1: function(s) {
  if (typeof s !== 'number') return this.divideScalar$1$bailout(1, s, 0);
  if (!(s === 0)) {
    var t1 = this._x;
    if (typeof t1 !== 'number') return this.divideScalar$1$bailout(2, s, t1);
    this._x = t1 / s;
    var t3 = this._y;
    if (typeof t3 !== 'number') return this.divideScalar$1$bailout(3, s, t3);
    this._y = t3 / s;
    var t5 = this._z;
    if (typeof t5 !== 'number') return this.divideScalar$1$bailout(4, s, t5);
    this._z = t5 / s;
  } else {
    this._x = 0;
    this._y = 0;
    this._z = 0;
  }
  return this;
 },
 divideScalar$1$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      var s = env0;
      break;
    case 2:
      s = env0;
      t1 = env1;
      break;
    case 3:
      s = env0;
      t3 = env1;
      break;
    case 4:
      s = env0;
      t5 = env1;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
    default:
      if (state == 2 || state == 3 || state == 4 || (state == 0 && !$.eqB(s, 0))) {
        switch (state) {
          case 0:
            var t1 = this._x;
          case 2:
            state = 0;
            this._x = $.div(t1, s);
            var t3 = this._y;
          case 3:
            state = 0;
            this._y = $.div(t3, s);
            var t5 = this._z;
          case 4:
            state = 0;
            this._z = $.div(t5, s);
        }
      } else {
        this._x = 0;
        this._y = 0;
        this._z = 0;
      }
      return this;
  }
 },
 multiplyScalar$1: function(s) {
  this._x = $.mul(this._x, s);
  this._y = $.mul(this._y, s);
  this._z = $.mul(this._z, s);
  return this;
 },
 multiply$2: function(a, b) {
  var t1 = a.get$x();
  if (typeof t1 !== 'number') return this.multiply$2$bailout(1, a, b, t1, 0);
  var t3 = b.get$x();
  if (typeof t3 !== 'number') return this.multiply$2$bailout(2, a, b, t1, t3);
  this._x = t1 * t3;
  var t5 = a.get$y();
  if (typeof t5 !== 'number') return this.multiply$2$bailout(3, a, b, t5, 0);
  var t7 = b.get$y();
  if (typeof t7 !== 'number') return this.multiply$2$bailout(4, a, b, t5, t7);
  this._y = t5 * t7;
  var t9 = a.get$z();
  if (typeof t9 !== 'number') return this.multiply$2$bailout(5, b, t9, 0, 0);
  var t11 = b.get$z();
  if (typeof t11 !== 'number') return this.multiply$2$bailout(6, t9, t11, 0, 0);
  this._z = t9 * t11;
  return this;
 },
 multiply$2$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var a = env0;
      var b = env1;
      t1 = env2;
      break;
    case 2:
      a = env0;
      b = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      a = env0;
      b = env1;
      t5 = env2;
      break;
    case 4:
      a = env0;
      b = env1;
      t5 = env2;
      t7 = env3;
      break;
    case 5:
      b = env0;
      t9 = env1;
      break;
    case 6:
      t9 = env0;
      t11 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = a.get$x();
    case 1:
      state = 0;
      var t3 = b.get$x();
    case 2:
      state = 0;
      this._x = $.mul(t1, t3);
      var t5 = a.get$y();
    case 3:
      state = 0;
      var t7 = b.get$y();
    case 4:
      state = 0;
      this._y = $.mul(t5, t7);
      var t9 = a.get$z();
    case 5:
      state = 0;
      var t11 = b.get$z();
    case 6:
      state = 0;
      this._z = $.mul(t9, t11);
      return this;
  }
 },
 sub$2: function(v1, v2) {
  var t1 = v1.get$x();
  if (typeof t1 !== 'number') return this.sub$2$bailout(1, v1, v2, t1, 0);
  var t3 = v2.get$x();
  if (typeof t3 !== 'number') return this.sub$2$bailout(2, v1, v2, t1, t3);
  this._x = t1 - t3;
  var t5 = v1.get$y();
  if (typeof t5 !== 'number') return this.sub$2$bailout(3, v1, v2, t5, 0);
  var t7 = v2.get$y();
  if (typeof t7 !== 'number') return this.sub$2$bailout(4, v1, v2, t5, t7);
  this._y = t5 - t7;
  var t9 = v1.get$z();
  if (typeof t9 !== 'number') return this.sub$2$bailout(5, v2, t9, 0, 0);
  var t11 = v2.get$z();
  if (typeof t11 !== 'number') return this.sub$2$bailout(6, t9, t11, 0, 0);
  this._z = t9 - t11;
  return this;
 },
 sub$2$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      t1 = env2;
      break;
    case 2:
      v1 = env0;
      v2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      v1 = env0;
      v2 = env1;
      t5 = env2;
      break;
    case 4:
      v1 = env0;
      v2 = env1;
      t5 = env2;
      t7 = env3;
      break;
    case 5:
      v2 = env0;
      t9 = env1;
      break;
    case 6:
      t9 = env0;
      t11 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = v1.get$x();
    case 1:
      state = 0;
      var t3 = v2.get$x();
    case 2:
      state = 0;
      this._x = $.sub(t1, t3);
      var t5 = v1.get$y();
    case 3:
      state = 0;
      var t7 = v2.get$y();
    case 4:
      state = 0;
      this._y = $.sub(t5, t7);
      var t9 = v1.get$z();
    case 5:
      state = 0;
      var t11 = v2.get$z();
    case 6:
      state = 0;
      this._z = $.sub(t9, t11);
      return this;
  }
 },
 addSelf$1: function(v) {
  this._x = $.add(this._x, v.get$x());
  this._y = $.add(this._y, v.get$y());
  this._z = $.add(this._z, v.get$z());
  return this;
 },
 copy$1: function(v) {
  this._x = v.get$x();
  this._y = v.get$y();
  this._z = v.get$z();
  return this;
 },
 setValues$3: function(x, y, z) {
  this._x = x;
  this._y = y;
  this._z = z;
  return this;
 },
 set$z: function(value) {
  this._z = value;
 },
 set$y: function(value) {
  this._y = value;
 },
 set$x: function(value) {
  this._x = value;
 },
 get$z: function() {
  return this._z;
 },
 get$y: function() {
  return this._y;
 },
 get$x: function() {
  return this._x;
 },
 Vector3$3: function(x, y, z) {
  this._x = !(null == x) ? x : 0;
  this._y = !(null == y) ? y : 0;
  this._z = !(null == z) ? z : 0;
 }
};

$$.Matrix3 = {"":
 ["_m"],
 super: "Object",
 Matrix3$0: function() {
  this._m = [];
 }
};

$$.Matrix4 = {"":
 ["n44?", "n43?", "n42?", "n41?", "n34?", "n33?", "n32?", "n31?", "n24?", "n23?", "n22?", "n21?", "n14?", "n13?", "n12?", "n11?", "_m33", "_flat"],
 super: "Object",
 extractRotation$1: function(m) {
  var vector = $.Matrix4___v1;
  var t1 = vector.setValues$3(m.get$n11(), m.get$n21(), m.get$n31()).length$0();
  if (typeof t1 !== 'number') throw $.iae(t1);
  var scaleX = 1 / t1;
  t1 = vector.setValues$3(m.get$n12(), m.get$n22(), m.get$n32()).length$0();
  if (typeof t1 !== 'number') throw $.iae(t1);
  var scaleY = 1 / t1;
  t1 = vector.setValues$3(m.get$n13(), m.get$n23(), m.get$n33()).length$0();
  if (typeof t1 !== 'number') throw $.iae(t1);
  var scaleZ = 1 / t1;
  t1 = m.get$n11();
  if (typeof t1 !== 'number') return this.extractRotation$1$bailout(1, m, scaleZ, scaleY, t1, scaleX);
  this.n11 = t1 * scaleX;
  var t3 = m.get$n21();
  if (typeof t3 !== 'number') return this.extractRotation$1$bailout(2, m, scaleZ, scaleY, scaleX, t3);
  this.n21 = t3 * scaleX;
  var t5 = m.get$n31();
  if (typeof t5 !== 'number') return this.extractRotation$1$bailout(3, m, scaleZ, scaleY, t5, scaleX);
  this.n31 = t5 * scaleX;
  var t7 = m.get$n12();
  if (typeof t7 !== 'number') return this.extractRotation$1$bailout(4, m, scaleZ, scaleY, t7, 0);
  this.n12 = t7 * scaleY;
  var t9 = m.get$n22();
  if (typeof t9 !== 'number') return this.extractRotation$1$bailout(5, m, scaleZ, scaleY, t9, 0);
  this.n22 = t9 * scaleY;
  var t11 = m.get$n32();
  if (typeof t11 !== 'number') return this.extractRotation$1$bailout(6, m, scaleZ, scaleY, t11, 0);
  this.n32 = t11 * scaleY;
  var t13 = m.get$n13();
  if (typeof t13 !== 'number') return this.extractRotation$1$bailout(7, m, scaleZ, t13, 0, 0);
  this.n13 = t13 * scaleZ;
  var t15 = m.get$n23();
  if (typeof t15 !== 'number') return this.extractRotation$1$bailout(8, m, scaleZ, t15, 0, 0);
  this.n23 = t15 * scaleZ;
  var t17 = m.get$n33();
  if (typeof t17 !== 'number') return this.extractRotation$1$bailout(9, scaleZ, t17, 0, 0, 0);
  this.n33 = t17 * scaleZ;
  return this;
 },
 extractRotation$1$bailout: function(state, env0, env1, env2, env3, env4) {
  switch (state) {
    case 1:
      var m = env0;
      scaleZ = env1;
      scaleY = env2;
      t1 = env3;
      scaleX = env4;
      break;
    case 2:
      m = env0;
      scaleZ = env1;
      scaleY = env2;
      scaleX = env3;
      t3 = env4;
      break;
    case 3:
      m = env0;
      scaleZ = env1;
      scaleY = env2;
      t5 = env3;
      scaleX = env4;
      break;
    case 4:
      m = env0;
      scaleZ = env1;
      scaleY = env2;
      t7 = env3;
      break;
    case 5:
      m = env0;
      scaleZ = env1;
      scaleY = env2;
      t9 = env3;
      break;
    case 6:
      m = env0;
      scaleZ = env1;
      scaleY = env2;
      t11 = env3;
      break;
    case 7:
      m = env0;
      scaleZ = env1;
      t13 = env2;
      break;
    case 8:
      m = env0;
      scaleZ = env1;
      t15 = env2;
      break;
    case 9:
      scaleZ = env0;
      t17 = env1;
      break;
  }
  switch (state) {
    case 0:
      var vector = $.Matrix4___v1;
      var t1 = vector.setValues$3(m.get$n11(), m.get$n21(), m.get$n31()).length$0();
      if (typeof t1 !== 'number') throw $.iae(t1);
      var scaleX = 1 / t1;
      t1 = vector.setValues$3(m.get$n12(), m.get$n22(), m.get$n32()).length$0();
      if (typeof t1 !== 'number') throw $.iae(t1);
      var scaleY = 1 / t1;
      t1 = vector.setValues$3(m.get$n13(), m.get$n23(), m.get$n33()).length$0();
      if (typeof t1 !== 'number') throw $.iae(t1);
      var scaleZ = 1 / t1;
      t1 = m.get$n11();
    case 1:
      state = 0;
      this.n11 = $.mul(t1, scaleX);
      var t3 = m.get$n21();
    case 2:
      state = 0;
      this.n21 = $.mul(t3, scaleX);
      var t5 = m.get$n31();
    case 3:
      state = 0;
      this.n31 = $.mul(t5, scaleX);
      var t7 = m.get$n12();
    case 4:
      state = 0;
      this.n12 = $.mul(t7, scaleY);
      var t9 = m.get$n22();
    case 5:
      state = 0;
      this.n22 = $.mul(t9, scaleY);
      var t11 = m.get$n32();
    case 6:
      state = 0;
      this.n32 = $.mul(t11, scaleY);
      var t13 = m.get$n13();
    case 7:
      state = 0;
      this.n13 = $.mul(t13, scaleZ);
      var t15 = m.get$n23();
    case 8:
      state = 0;
      this.n23 = $.mul(t15, scaleZ);
      var t17 = m.get$n33();
    case 9:
      state = 0;
      this.n33 = $.mul(t17, scaleZ);
      return this;
  }
 },
 scale$1: function(v) {
  var x = v.get$x();
  var y = v.get$y();
  var z = v.get$z();
  this.n11 = $.mul(this.n11, x);
  this.n12 = $.mul(this.n12, y);
  this.n13 = $.mul(this.n13, z);
  this.n21 = $.mul(this.n21, x);
  this.n22 = $.mul(this.n22, y);
  this.n23 = $.mul(this.n23, z);
  this.n31 = $.mul(this.n31, x);
  this.n32 = $.mul(this.n32, y);
  this.n33 = $.mul(this.n33, z);
  this.n41 = $.mul(this.n41, x);
  this.n42 = $.mul(this.n42, y);
  this.n43 = $.mul(this.n43, z);
  return this;
 },
 get$scale: function() { return new $.BoundClosure0(this, 'scale$1'); },
 setRotationFromQuaternion$1: function(q) {
  var x = q.get$x();
  var y = q.get$y();
  var z = q.get$z();
  var w = q.get$w();
  var x2 = $.add(x, x);
  var y2 = $.add(y, y);
  var z2 = $.add(z, z);
  var xx = $.mul(x, x2);
  var xy = $.mul(x, y2);
  var xz = $.mul(x, z2);
  var yy = $.mul(y, y2);
  var yz = $.mul(y, z2);
  var zz = $.mul(z, z2);
  var wx = $.mul(w, x2);
  var wy = $.mul(w, y2);
  var wz = $.mul(w, z2);
  var t1 = $.add(yy, zz);
  if (typeof t1 !== 'number') throw $.iae(t1);
  this.n11 = 1 - t1;
  this.n12 = $.sub(xy, wz);
  this.n13 = $.add(xz, wy);
  this.n21 = $.add(xy, wz);
  var t2 = $.add(xx, zz);
  if (typeof t2 !== 'number') throw $.iae(t2);
  this.n22 = 1 - t2;
  this.n23 = $.sub(yz, wx);
  this.n31 = $.sub(xz, wy);
  this.n32 = $.add(yz, wx);
  var t3 = $.add(xx, yy);
  if (typeof t3 !== 'number') throw $.iae(t3);
  this.n33 = 1 - t3;
  return this;
 },
 setRotationFromEuler$2: function(v, order) {
  var x = v.get$x();
  var y = v.get$y();
  var z = v.get$z();
  var a = $.Math_cos(x);
  var b = $.Math_sin(x);
  var c = $.Math_cos(y);
  var d = $.Math_sin(y);
  var e = $.Math_cos(z);
  var f = $.Math_sin(z);
  switch (order) {
    case 'YXZ':
      var ce = $.mul(c, e);
      var cf = $.mul(c, f);
      var de = $.mul(d, e);
      var df = $.mul(d, f);
      this.n11 = $.add(ce, $.mul(df, b));
      this.n12 = $.sub($.mul(de, b), cf);
      this.n13 = $.mul(a, d);
      this.n21 = $.mul(a, f);
      this.n22 = $.mul(a, e);
      this.n23 = $.neg(b);
      this.n31 = $.sub($.mul(cf, b), de);
      this.n32 = $.add(df, $.mul(ce, b));
      this.n33 = $.mul(a, c);
      break;
    case 'ZXY':
      ce = $.mul(c, e);
      cf = $.mul(c, f);
      de = $.mul(d, e);
      df = $.mul(d, f);
      this.n11 = $.sub(ce, $.mul(df, b));
      this.n12 = $.mul($.neg(a), f);
      this.n13 = $.add(de, $.mul(cf, b));
      this.n21 = $.add(cf, $.mul(de, b));
      this.n22 = $.mul(a, e);
      this.n23 = $.sub(df, $.mul(ce, b));
      this.n31 = $.mul($.neg(a), d);
      this.n32 = b;
      this.n33 = $.mul(a, c);
      break;
    case 'ZYX':
      var ae = $.mul(a, e);
      var af = $.mul(a, f);
      var be = $.mul(b, e);
      var bf = $.mul(b, f);
      this.n11 = $.mul(c, e);
      this.n12 = $.sub($.mul(be, d), af);
      this.n13 = $.add($.mul(ae, d), bf);
      this.n21 = $.mul(c, f);
      this.n22 = $.add($.mul(bf, d), ae);
      this.n23 = $.sub($.mul(af, d), be);
      this.n31 = $.neg(d);
      this.n32 = $.mul(b, c);
      this.n33 = $.mul(a, c);
      break;
    case 'YZX':
      var ac = $.mul(a, c);
      var ad = $.mul(a, d);
      var bc = $.mul(b, c);
      var bd = $.mul(b, d);
      this.n11 = $.mul(c, e);
      this.n12 = $.sub(bd, $.mul(ac, f));
      this.n13 = $.add($.mul(bc, f), ad);
      this.n21 = f;
      this.n22 = $.mul(a, e);
      this.n23 = $.mul($.neg(b), e);
      this.n31 = $.mul($.neg(d), e);
      this.n32 = $.add($.mul(ad, f), bc);
      this.n33 = $.sub(ac, $.mul(bd, f));
      break;
    case 'XZY':
      ac = $.mul(a, c);
      ad = $.mul(a, d);
      bc = $.mul(b, c);
      bd = $.mul(b, d);
      this.n11 = $.mul(c, e);
      this.n12 = $.neg(f);
      this.n13 = $.mul(d, e);
      this.n21 = $.add($.mul(ac, f), bd);
      this.n22 = $.mul(a, e);
      this.n23 = $.sub($.mul(ad, f), bc);
      this.n31 = $.sub($.mul(bc, f), ad);
      this.n32 = $.mul(b, e);
      this.n33 = $.add($.mul(bd, f), ac);
      break;
    default:
      ae = $.mul(a, e);
      af = $.mul(a, f);
      be = $.mul(b, e);
      bf = $.mul(b, f);
      this.n11 = $.mul(c, e);
      this.n12 = $.mul($.neg(c), f);
      this.n13 = d;
      this.n21 = $.add(af, $.mul(be, d));
      this.n22 = $.sub(ae, $.mul(bf, d));
      this.n23 = $.mul($.neg(b), c);
      this.n31 = $.sub(bf, $.mul(ae, d));
      this.n32 = $.add(be, $.mul(af, d));
      this.n33 = $.mul(a, c);
      break;
  }
  return this;
 },
 getInverse$1: function(m) {
  var _n11 = m.get$n11();
  var _n12 = m.get$n12();
  var _n13 = m.get$n13();
  var _n14 = m.get$n14();
  var _n21 = m.get$n21();
  var _n22 = m.get$n22();
  var _n23 = m.get$n23();
  var _n24 = m.get$n24();
  var _n31 = m.get$n31();
  var _n32 = m.get$n32();
  var _n33 = m.get$n33();
  var _n34 = m.get$n34();
  var _n41 = m.get$n41();
  var _n42 = m.get$n42();
  var _n43 = m.get$n43();
  var _n44 = m.get$n44();
  this.n11 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n23, _n34), _n42), $.mul($.mul(_n24, _n33), _n42)), $.mul($.mul(_n24, _n32), _n43)), $.mul($.mul(_n22, _n34), _n43)), $.mul($.mul(_n23, _n32), _n44)), $.mul($.mul(_n22, _n33), _n44));
  this.n12 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n14, _n33), _n42), $.mul($.mul(_n13, _n34), _n42)), $.mul($.mul(_n14, _n32), _n43)), $.mul($.mul(_n12, _n34), _n43)), $.mul($.mul(_n13, _n32), _n44)), $.mul($.mul(_n12, _n33), _n44));
  this.n13 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n13, _n24), _n42), $.mul($.mul(_n14, _n23), _n42)), $.mul($.mul(_n14, _n22), _n43)), $.mul($.mul(_n12, _n24), _n43)), $.mul($.mul(_n13, _n22), _n44)), $.mul($.mul(_n12, _n23), _n44));
  this.n14 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n14, _n23), _n32), $.mul($.mul(_n13, _n24), _n32)), $.mul($.mul(_n14, _n22), _n33)), $.mul($.mul(_n12, _n24), _n33)), $.mul($.mul(_n13, _n22), _n34)), $.mul($.mul(_n12, _n23), _n34));
  this.n21 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n24, _n33), _n41), $.mul($.mul(_n23, _n34), _n41)), $.mul($.mul(_n24, _n31), _n43)), $.mul($.mul(_n21, _n34), _n43)), $.mul($.mul(_n23, _n31), _n44)), $.mul($.mul(_n21, _n33), _n44));
  this.n22 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n13, _n34), _n41), $.mul($.mul(_n14, _n33), _n41)), $.mul($.mul(_n14, _n31), _n43)), $.mul($.mul(_n11, _n34), _n43)), $.mul($.mul(_n13, _n31), _n44)), $.mul($.mul(_n11, _n33), _n44));
  this.n23 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n14, _n23), _n41), $.mul($.mul(_n13, _n24), _n41)), $.mul($.mul(_n14, _n21), _n43)), $.mul($.mul(_n11, _n24), _n43)), $.mul($.mul(_n13, _n21), _n44)), $.mul($.mul(_n11, _n23), _n44));
  this.n24 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n13, _n24), _n31), $.mul($.mul(_n14, _n23), _n31)), $.mul($.mul(_n14, _n21), _n33)), $.mul($.mul(_n11, _n24), _n33)), $.mul($.mul(_n13, _n21), _n34)), $.mul($.mul(_n11, _n23), _n34));
  this.n31 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n22, _n34), _n41), $.mul($.mul(_n24, _n32), _n41)), $.mul($.mul(_n24, _n31), _n42)), $.mul($.mul(_n21, _n34), _n42)), $.mul($.mul(_n22, _n31), _n44)), $.mul($.mul(_n21, _n32), _n44));
  this.n32 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n14, _n32), _n41), $.mul($.mul(_n12, _n34), _n41)), $.mul($.mul(_n14, _n31), _n42)), $.mul($.mul(_n11, _n34), _n42)), $.mul($.mul(_n12, _n31), _n44)), $.mul($.mul(_n11, _n32), _n44));
  this.n33 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n12, _n24), _n41), $.mul($.mul(_n14, _n22), _n41)), $.mul($.mul(_n14, _n21), _n42)), $.mul($.mul(_n11, _n24), _n42)), $.mul($.mul(_n12, _n21), _n44)), $.mul($.mul(_n11, _n22), _n44));
  this.n34 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n14, _n22), _n31), $.mul($.mul(_n12, _n24), _n31)), $.mul($.mul(_n14, _n21), _n32)), $.mul($.mul(_n11, _n24), _n32)), $.mul($.mul(_n12, _n21), _n34)), $.mul($.mul(_n11, _n22), _n34));
  this.n41 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n23, _n32), _n41), $.mul($.mul(_n22, _n33), _n41)), $.mul($.mul(_n23, _n31), _n42)), $.mul($.mul(_n21, _n33), _n42)), $.mul($.mul(_n22, _n31), _n43)), $.mul($.mul(_n21, _n32), _n43));
  this.n42 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n12, _n33), _n41), $.mul($.mul(_n13, _n32), _n41)), $.mul($.mul(_n13, _n31), _n42)), $.mul($.mul(_n11, _n33), _n42)), $.mul($.mul(_n12, _n31), _n43)), $.mul($.mul(_n11, _n32), _n43));
  this.n43 = $.sub($.add($.add($.sub($.sub($.mul($.mul(_n13, _n22), _n41), $.mul($.mul(_n12, _n23), _n41)), $.mul($.mul(_n13, _n21), _n42)), $.mul($.mul(_n11, _n23), _n42)), $.mul($.mul(_n12, _n21), _n43)), $.mul($.mul(_n11, _n22), _n43));
  this.n44 = $.add($.sub($.sub($.add($.sub($.mul($.mul(_n12, _n23), _n31), $.mul($.mul(_n13, _n22), _n31)), $.mul($.mul(_n13, _n21), _n32)), $.mul($.mul(_n11, _n23), _n32)), $.mul($.mul(_n12, _n21), _n33)), $.mul($.mul(_n11, _n22), _n33));
  var t1 = m.determinant$0();
  if (typeof t1 !== 'number') throw $.iae(t1);
  this.multiplyScalar$1(1 / t1);
  return this;
 },
 getColumnZ$0: function() {
  return $.Matrix4___v1.setValues$3(this.n13, this.n23, this.n33);
 },
 getColumnY$0: function() {
  return $.Matrix4___v1.setValues$3(this.n12, this.n22, this.n32);
 },
 getColumnX$0: function() {
  return $.Matrix4___v1.setValues$3(this.n11, this.n21, this.n31);
 },
 getPosition$0: function() {
  return $.Matrix4___v1.setValues$3(this.n14, this.n24, this.n34);
 },
 setPosition$1: function(v) {
  this.n14 = v.get$x();
  this.n24 = v.get$y();
  this.n34 = v.get$z();
  return this;
 },
 determinant$0: function() {
  var m11 = this.n11;
  var m12 = this.n12;
  var m13 = this.n13;
  var m14 = this.n14;
  var m21 = this.n21;
  var m22 = this.n22;
  var m23 = this.n23;
  var m24 = this.n24;
  var m31 = this.n31;
  var m32 = this.n32;
  var m33 = this.n33;
  var m34 = this.n34;
  var m41 = this.n41;
  var m42 = this.n42;
  var m43 = this.n43;
  var m44 = this.n44;
  return $.add($.sub($.sub($.add($.add($.sub($.sub($.add($.add($.sub($.sub($.add($.add($.sub($.sub($.add($.add($.sub($.sub($.add($.add($.sub($.sub($.mul($.mul($.mul(m14, m23), m32), m41), $.mul($.mul($.mul(m13, m24), m32), m41)), $.mul($.mul($.mul(m14, m22), m33), m41)), $.mul($.mul($.mul(m12, m24), m33), m41)), $.mul($.mul($.mul(m13, m22), m34), m41)), $.mul($.mul($.mul(m12, m23), m34), m41)), $.mul($.mul($.mul(m14, m23), m31), m42)), $.mul($.mul($.mul(m13, m24), m31), m42)), $.mul($.mul($.mul(m14, m21), m33), m42)), $.mul($.mul($.mul(m11, m24), m33), m42)), $.mul($.mul($.mul(m13, m21), m34), m42)), $.mul($.mul($.mul(m11, m23), m34), m42)), $.mul($.mul($.mul(m14, m22), m31), m43)), $.mul($.mul($.mul(m12, m24), m31), m43)), $.mul($.mul($.mul(m14, m21), m32), m43)), $.mul($.mul($.mul(m11, m24), m32), m43)), $.mul($.mul($.mul(m12, m21), m34), m43)), $.mul($.mul($.mul(m11, m22), m34), m43)), $.mul($.mul($.mul(m13, m22), m31), m44)), $.mul($.mul($.mul(m12, m23), m31), m44)), $.mul($.mul($.mul(m13, m21), m32), m44)), $.mul($.mul($.mul(m11, m23), m32), m44)), $.mul($.mul($.mul(m12, m21), m33), m44)), $.mul($.mul($.mul(m11, m22), m33), m44));
 },
 rotateAxis$1: function(v) {
  var vx = v.get$x();
  var vy = v.get$y();
  var vz = v.get$z();
  v.set$x($.add($.add($.mul(vx, this.n11), $.mul(vy, this.n12)), $.mul(vz, this.n13)));
  v.set$y($.add($.add($.mul(vx, this.n21), $.mul(vy, this.n22)), $.mul(vz, this.n23)));
  v.set$z($.add($.add($.mul(vx, this.n31), $.mul(vy, this.n32)), $.mul(vz, this.n33)));
  v.normalize$0();
  return v;
 },
 multiplyVector4$1: function(v) {
  var vx = v.get$x();
  if (typeof vx !== 'number') return this.multiplyVector4$1$bailout(1, v, vx, 0, 0, 0, 0, 0);
  var vy = v.get$y();
  if (typeof vy !== 'number') return this.multiplyVector4$1$bailout(2, v, vx, vy, 0, 0, 0, 0);
  var vz = v.get$z();
  if (typeof vz !== 'number') return this.multiplyVector4$1$bailout(3, v, vx, vy, vz, 0, 0, 0);
  var vw = v.get$w();
  if (typeof vw !== 'number') return this.multiplyVector4$1$bailout(4, v, vx, vy, vz, vw, 0, 0);
  var t5 = this.n11;
  if (typeof t5 !== 'number') return this.multiplyVector4$1$bailout(5, v, vx, vy, vz, vw, t5, 0);
  t5 *= vx;
  var t7 = this.n12;
  if (typeof t7 !== 'number') return this.multiplyVector4$1$bailout(6, v, vx, vy, vz, vw, t7, t5);
  t5 += t7 * vy;
  var t9 = this.n13;
  if (typeof t9 !== 'number') return this.multiplyVector4$1$bailout(7, v, vx, vy, vz, vw, t9, t5);
  t5 += t9 * vz;
  var t11 = this.n14;
  if (typeof t11 !== 'number') return this.multiplyVector4$1$bailout(8, v, vx, vy, vz, vw, t11, t5);
  v.set$x(t5 + t11 * vw);
  var t13 = this.n21;
  if (typeof t13 !== 'number') return this.multiplyVector4$1$bailout(9, v, vx, vy, vz, vw, t13, 0);
  t13 *= vx;
  var t15 = this.n22;
  if (typeof t15 !== 'number') return this.multiplyVector4$1$bailout(10, v, vx, vy, vz, vw, t15, t13);
  t13 += t15 * vy;
  var t17 = this.n23;
  if (typeof t17 !== 'number') return this.multiplyVector4$1$bailout(11, v, t13, vx, vy, vz, vw, t17);
  t13 += t17 * vz;
  var t19 = this.n24;
  if (typeof t19 !== 'number') return this.multiplyVector4$1$bailout(12, v, vx, vy, vz, vw, t13, t19);
  v.set$y(t13 + t19 * vw);
  var t21 = this.n31;
  if (typeof t21 !== 'number') return this.multiplyVector4$1$bailout(13, v, vx, vy, vz, vw, t21, 0);
  t21 *= vx;
  var t23 = this.n32;
  if (typeof t23 !== 'number') return this.multiplyVector4$1$bailout(14, v, vx, vy, vz, vw, t23, t21);
  t21 += t23 * vy;
  var t25 = this.n33;
  if (typeof t25 !== 'number') return this.multiplyVector4$1$bailout(15, v, vx, vy, vz, vw, t21, t25);
  t21 += t25 * vz;
  var t27 = this.n34;
  if (typeof t27 !== 'number') return this.multiplyVector4$1$bailout(16, v, t27, vx, vy, vz, vw, t21);
  v.set$z(t21 + t27 * vw);
  var t29 = this.n41;
  if (typeof t29 !== 'number') return this.multiplyVector4$1$bailout(17, v, t29, vx, vy, vz, vw, 0);
  t29 *= vx;
  var t31 = this.n42;
  if (typeof t31 !== 'number') return this.multiplyVector4$1$bailout(18, v, t29, t31, vy, vz, vw, 0);
  t29 += t31 * vy;
  var t33 = this.n43;
  if (typeof t33 !== 'number') return this.multiplyVector4$1$bailout(19, v, t33, vz, vw, t29, 0, 0);
  t29 += t33 * vz;
  var t35 = this.n44;
  if (typeof t35 !== 'number') return this.multiplyVector4$1$bailout(20, v, t29, t35, vw, 0, 0, 0);
  v.set$w(t29 + t35 * vw);
  return v;
 },
 multiplyVector4$1$bailout: function(state, env0, env1, env2, env3, env4, env5, env6) {
  switch (state) {
    case 1:
      var v = env0;
      vx = env1;
      break;
    case 2:
      v = env0;
      vx = env1;
      vy = env2;
      break;
    case 3:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      break;
    case 4:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      break;
    case 5:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t5 = env5;
      break;
    case 6:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t7 = env5;
      t5 = env6;
      break;
    case 7:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t9 = env5;
      t5 = env6;
      break;
    case 8:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t11 = env5;
      t5 = env6;
      break;
    case 9:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t13 = env5;
      break;
    case 10:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t15 = env5;
      t13 = env6;
      break;
    case 11:
      v = env0;
      t13 = env1;
      vx = env2;
      vy = env3;
      vz = env4;
      vw = env5;
      t17 = env6;
      break;
    case 12:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t13 = env5;
      t19 = env6;
      break;
    case 13:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t21 = env5;
      break;
    case 14:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t23 = env5;
      t21 = env6;
      break;
    case 15:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      vw = env4;
      t21 = env5;
      t25 = env6;
      break;
    case 16:
      v = env0;
      t27 = env1;
      vx = env2;
      vy = env3;
      vz = env4;
      vw = env5;
      t21 = env6;
      break;
    case 17:
      v = env0;
      t29 = env1;
      vx = env2;
      vy = env3;
      vz = env4;
      vw = env5;
      break;
    case 18:
      v = env0;
      t29 = env1;
      t31 = env2;
      vy = env3;
      vz = env4;
      vw = env5;
      break;
    case 19:
      v = env0;
      t33 = env1;
      vz = env2;
      vw = env3;
      t29 = env4;
      break;
    case 20:
      v = env0;
      t29 = env1;
      t35 = env2;
      vw = env3;
      break;
  }
  switch (state) {
    case 0:
      var vx = v.get$x();
    case 1:
      state = 0;
      var vy = v.get$y();
    case 2:
      state = 0;
      var vz = v.get$z();
    case 3:
      state = 0;
      var vw = v.get$w();
    case 4:
      state = 0;
      var t5 = this.n11;
    case 5:
      state = 0;
      t5 = $.mul(t5, vx);
      var t7 = this.n12;
    case 6:
      state = 0;
      t5 = $.add(t5, $.mul(t7, vy));
      var t9 = this.n13;
    case 7:
      state = 0;
      t5 = $.add(t5, $.mul(t9, vz));
      var t11 = this.n14;
    case 8:
      state = 0;
      v.set$x($.add(t5, $.mul(t11, vw)));
      var t13 = this.n21;
    case 9:
      state = 0;
      t13 = $.mul(t13, vx);
      var t15 = this.n22;
    case 10:
      state = 0;
      t13 = $.add(t13, $.mul(t15, vy));
      var t17 = this.n23;
    case 11:
      state = 0;
      t13 = $.add(t13, $.mul(t17, vz));
      var t19 = this.n24;
    case 12:
      state = 0;
      v.set$y($.add(t13, $.mul(t19, vw)));
      var t21 = this.n31;
    case 13:
      state = 0;
      t21 = $.mul(t21, vx);
      var t23 = this.n32;
    case 14:
      state = 0;
      t21 = $.add(t21, $.mul(t23, vy));
      var t25 = this.n33;
    case 15:
      state = 0;
      t21 = $.add(t21, $.mul(t25, vz));
      var t27 = this.n34;
    case 16:
      state = 0;
      v.set$z($.add(t21, $.mul(t27, vw)));
      var t29 = this.n41;
    case 17:
      state = 0;
      t29 = $.mul(t29, vx);
      var t31 = this.n42;
    case 18:
      state = 0;
      t29 = $.add(t29, $.mul(t31, vy));
      var t33 = this.n43;
    case 19:
      state = 0;
      t29 = $.add(t29, $.mul(t33, vz));
      var t35 = this.n44;
    case 20:
      state = 0;
      v.set$w($.add(t29, $.mul(t35, vw)));
      return v;
  }
 },
 multiplyVector3$1: function(v) {
  var vx = v.get$x();
  if (typeof vx !== 'number') return this.multiplyVector3$1$bailout(1, v, vx, 0, 0, 0, 0, 0);
  var vy = v.get$y();
  if (typeof vy !== 'number') return this.multiplyVector3$1$bailout(2, v, vx, vy, 0, 0, 0, 0);
  var vz = v.get$z();
  if (typeof vz !== 'number') return this.multiplyVector3$1$bailout(3, v, vx, vy, vz, 0, 0, 0);
  var t4 = this.n41;
  if (typeof t4 !== 'number') return this.multiplyVector3$1$bailout(4, v, vx, vy, vz, t4, 0, 0);
  t4 *= vx;
  var t6 = this.n42;
  if (typeof t6 !== 'number') return this.multiplyVector3$1$bailout(5, v, vx, vy, vz, t6, t4, 0);
  t4 += t6 * vy;
  var t8 = this.n43;
  if (typeof t8 !== 'number') return this.multiplyVector3$1$bailout(6, v, vx, vy, vz, t8, t4, 0);
  t4 += t8 * vz;
  var t10 = this.n44;
  if (typeof t10 !== 'number') return this.multiplyVector3$1$bailout(7, v, vx, vy, vz, t4, t10, 0);
  var d = 1 / (t4 + t10);
  var t12 = this.n11;
  if (typeof t12 !== 'number') return this.multiplyVector3$1$bailout(8, v, vx, vy, vz, d, t12, 0);
  t12 *= vx;
  var t14 = this.n12;
  if (typeof t14 !== 'number') return this.multiplyVector3$1$bailout(9, v, vx, vy, vz, d, t14, t12);
  t12 += t14 * vy;
  var t16 = this.n13;
  if (typeof t16 !== 'number') return this.multiplyVector3$1$bailout(10, v, t12, vx, vy, vz, d, t16);
  t12 += t16 * vz;
  var t18 = this.n14;
  if (typeof t18 !== 'number') return this.multiplyVector3$1$bailout(11, v, vx, vy, vz, t12, d, t18);
  v.set$x((t12 + t18) * d);
  var t20 = this.n21;
  if (typeof t20 !== 'number') return this.multiplyVector3$1$bailout(12, v, vx, vy, vz, d, t20, 0);
  t20 *= vx;
  var t22 = this.n22;
  if (typeof t22 !== 'number') return this.multiplyVector3$1$bailout(13, v, vx, vy, vz, d, t20, t22);
  t20 += t22 * vy;
  var t24 = this.n23;
  if (typeof t24 !== 'number') return this.multiplyVector3$1$bailout(14, v, vx, vy, vz, t20, d, t24);
  t20 += t24 * vz;
  var t26 = this.n24;
  if (typeof t26 !== 'number') return this.multiplyVector3$1$bailout(15, v, t26, vx, vy, vz, d, t20);
  v.set$y((t20 + t26) * d);
  var t28 = this.n31;
  if (typeof t28 !== 'number') return this.multiplyVector3$1$bailout(16, v, t28, vx, vy, vz, d, 0);
  t28 *= vx;
  var t30 = this.n32;
  if (typeof t30 !== 'number') return this.multiplyVector3$1$bailout(17, v, t28, t30, vy, vz, d, 0);
  t28 += t30 * vy;
  var t32 = this.n33;
  if (typeof t32 !== 'number') return this.multiplyVector3$1$bailout(18, v, d, t32, vz, t28, 0, 0);
  t28 += t32 * vz;
  var t34 = this.n34;
  if (typeof t34 !== 'number') return this.multiplyVector3$1$bailout(19, v, d, t28, t34, 0, 0, 0);
  v.set$z((t28 + t34) * d);
  return v;
 },
 multiplyVector3$1$bailout: function(state, env0, env1, env2, env3, env4, env5, env6) {
  switch (state) {
    case 1:
      var v = env0;
      vx = env1;
      break;
    case 2:
      v = env0;
      vx = env1;
      vy = env2;
      break;
    case 3:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      break;
    case 4:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      t4 = env4;
      break;
    case 5:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      t6 = env4;
      t4 = env5;
      break;
    case 6:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      t8 = env4;
      t4 = env5;
      break;
    case 7:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      t4 = env4;
      t10 = env5;
      break;
    case 8:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      d = env4;
      t10 = env5;
      break;
    case 9:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      d = env4;
      t12 = env5;
      t10 = env6;
      break;
    case 10:
      v = env0;
      t10 = env1;
      vx = env2;
      vy = env3;
      vz = env4;
      d = env5;
      t14 = env6;
      break;
    case 11:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      t10 = env4;
      d = env5;
      t16 = env6;
      break;
    case 12:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      d = env4;
      t18 = env5;
      break;
    case 13:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      d = env4;
      t18 = env5;
      t20 = env6;
      break;
    case 14:
      v = env0;
      vx = env1;
      vy = env2;
      vz = env3;
      t18 = env4;
      d = env5;
      t22 = env6;
      break;
    case 15:
      v = env0;
      t24 = env1;
      vx = env2;
      vy = env3;
      vz = env4;
      d = env5;
      t18 = env6;
      break;
    case 16:
      v = env0;
      t26 = env1;
      vx = env2;
      vy = env3;
      vz = env4;
      d = env5;
      break;
    case 17:
      v = env0;
      t26 = env1;
      t28 = env2;
      vy = env3;
      vz = env4;
      d = env5;
      break;
    case 18:
      v = env0;
      d = env1;
      t30 = env2;
      vz = env3;
      t26 = env4;
      break;
    case 19:
      v = env0;
      d = env1;
      t26 = env2;
      t32 = env3;
      break;
  }
  switch (state) {
    case 0:
      var vx = v.get$x();
    case 1:
      state = 0;
      var vy = v.get$y();
    case 2:
      state = 0;
      var vz = v.get$z();
    case 3:
      state = 0;
      var t4 = this.n41;
    case 4:
      state = 0;
      t4 = $.mul(t4, vx);
      var t6 = this.n42;
    case 5:
      state = 0;
      t4 = $.add(t4, $.mul(t6, vy));
      var t8 = this.n43;
    case 6:
      state = 0;
      t4 = $.add(t4, $.mul(t8, vz));
      var t10 = this.n44;
    case 7:
      state = 0;
      t10 = $.add(t4, t10);
      if (typeof t10 !== 'number') throw $.iae(t10);
      var d = 1 / t10;
      t10 = this.n11;
    case 8:
      state = 0;
      t10 = $.mul(t10, vx);
      var t12 = this.n12;
    case 9:
      state = 0;
      t10 = $.add(t10, $.mul(t12, vy));
      var t14 = this.n13;
    case 10:
      state = 0;
      t10 = $.add(t10, $.mul(t14, vz));
      var t16 = this.n14;
    case 11:
      state = 0;
      v.set$x($.mul($.add(t10, t16), d));
      var t18 = this.n21;
    case 12:
      state = 0;
      t18 = $.mul(t18, vx);
      var t20 = this.n22;
    case 13:
      state = 0;
      t18 = $.add(t18, $.mul(t20, vy));
      var t22 = this.n23;
    case 14:
      state = 0;
      t18 = $.add(t18, $.mul(t22, vz));
      var t24 = this.n24;
    case 15:
      state = 0;
      v.set$y($.mul($.add(t18, t24), d));
      var t26 = this.n31;
    case 16:
      state = 0;
      t26 = $.mul(t26, vx);
      var t28 = this.n32;
    case 17:
      state = 0;
      t26 = $.add(t26, $.mul(t28, vy));
      var t30 = this.n33;
    case 18:
      state = 0;
      t26 = $.add(t26, $.mul(t30, vz));
      var t32 = this.n34;
    case 19:
      state = 0;
      v.set$z($.mul($.add(t26, t32), d));
      return v;
  }
 },
 multiplyScalar$1: function(s) {
  this.n11 = $.mul(this.n11, s);
  this.n12 = $.mul(this.n12, s);
  this.n13 = $.mul(this.n13, s);
  this.n14 = $.mul(this.n14, s);
  this.n21 = $.mul(this.n21, s);
  this.n22 = $.mul(this.n22, s);
  this.n23 = $.mul(this.n23, s);
  this.n24 = $.mul(this.n24, s);
  this.n31 = $.mul(this.n31, s);
  this.n32 = $.mul(this.n32, s);
  this.n33 = $.mul(this.n33, s);
  this.n34 = $.mul(this.n34, s);
  this.n41 = $.mul(this.n41, s);
  this.n42 = $.mul(this.n42, s);
  this.n43 = $.mul(this.n43, s);
  this.n44 = $.mul(this.n44, s);
  return this;
 },
 multiply$2: function(a, b) {
  var a11 = a.get$n11();
  if (typeof a11 !== 'number') return this.multiply$2$bailout(1, a, b, a11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a12 = a.get$n12();
  if (typeof a12 !== 'number') return this.multiply$2$bailout(2, a, b, a11, a12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a13 = a.get$n13();
  if (typeof a13 !== 'number') return this.multiply$2$bailout(3, a, b, a11, a12, a13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a14 = a.get$n14();
  if (typeof a14 !== 'number') return this.multiply$2$bailout(4, a, b, a11, a12, a13, a14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a21 = a.get$n21();
  if (typeof a21 !== 'number') return this.multiply$2$bailout(5, a, b, a11, a12, a13, a14, a21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a22 = a.get$n22();
  if (typeof a22 !== 'number') return this.multiply$2$bailout(6, a, b, a11, a12, a13, a14, a21, a22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a23 = a.get$n23();
  if (typeof a23 !== 'number') return this.multiply$2$bailout(7, a, b, a11, a12, a13, a14, a21, a22, a23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a24 = a.get$n24();
  if (typeof a24 !== 'number') return this.multiply$2$bailout(8, a, b, a11, a12, a13, a14, a21, a22, a23, a24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a31 = a.get$n31();
  if (typeof a31 !== 'number') return this.multiply$2$bailout(9, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a32 = a.get$n32();
  if (typeof a32 !== 'number') return this.multiply$2$bailout(10, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a33 = a.get$n33();
  if (typeof a33 !== 'number') return this.multiply$2$bailout(11, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a34 = a.get$n34();
  if (typeof a34 !== 'number') return this.multiply$2$bailout(12, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a41 = a.get$n41();
  if (typeof a41 !== 'number') return this.multiply$2$bailout(13, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a42 = a.get$n42();
  if (typeof a42 !== 'number') return this.multiply$2$bailout(14, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a43 = a.get$n43();
  if (typeof a43 !== 'number') return this.multiply$2$bailout(15, a, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var a44 = a.get$n44();
  if (typeof a44 !== 'number') return this.multiply$2$bailout(16, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b11 = b.get$n11();
  if (typeof b11 !== 'number') return this.multiply$2$bailout(17, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b12 = b.get$n12();
  if (typeof b12 !== 'number') return this.multiply$2$bailout(18, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b13 = b.get$n13();
  if (typeof b13 !== 'number') return this.multiply$2$bailout(19, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b14 = b.get$n14();
  if (typeof b14 !== 'number') return this.multiply$2$bailout(20, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b21 = b.get$n21();
  if (typeof b21 !== 'number') return this.multiply$2$bailout(21, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b22 = b.get$n22();
  if (typeof b22 !== 'number') return this.multiply$2$bailout(22, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var b23 = b.get$n23();
  if (typeof b23 !== 'number') return this.multiply$2$bailout(23, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, 0, 0, 0, 0, 0, 0, 0, 0);
  var b24 = b.get$n24();
  if (typeof b24 !== 'number') return this.multiply$2$bailout(24, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, 0, 0, 0, 0, 0, 0, 0);
  var b31 = b.get$n31();
  if (typeof b31 !== 'number') return this.multiply$2$bailout(25, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, 0, 0, 0, 0, 0, 0);
  var b32 = b.get$n32();
  if (typeof b32 !== 'number') return this.multiply$2$bailout(26, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, 0, 0, 0, 0, 0);
  var b33 = b.get$n33();
  if (typeof b33 !== 'number') return this.multiply$2$bailout(27, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, 0, 0, 0, 0);
  var b34 = b.get$n34();
  if (typeof b34 !== 'number') return this.multiply$2$bailout(28, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, 0, 0, 0);
  var b41 = b.get$n41();
  if (typeof b41 !== 'number') return this.multiply$2$bailout(29, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, 0, 0);
  var b42 = b.get$n42();
  if (typeof b42 !== 'number') return this.multiply$2$bailout(30, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, 0);
  var b43 = b.get$n43();
  if (typeof b43 !== 'number') return this.multiply$2$bailout(31, b, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43);
  var b44 = b.get$n44();
  if (typeof b44 !== 'number') return this.multiply$2$bailout(32, a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, b11, b12, b13, b14, b21, b22, b23, b24, b31, b32, b33, b34, b41, b42, b43, b44);
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
 },
 multiply$2$bailout: function(state, env0, env1, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11, env12, env13, env14, env15, env16, env17, env18, env19, env20, env21, env22, env23, env24, env25, env26, env27, env28, env29, env30, env31) {
  switch (state) {
    case 1:
      var a = env0;
      var b = env1;
      a11 = env2;
      break;
    case 2:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      break;
    case 3:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      break;
    case 4:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      break;
    case 5:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      break;
    case 6:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      break;
    case 7:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      break;
    case 8:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      break;
    case 9:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      break;
    case 10:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      a32 = env11;
      break;
    case 11:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      a32 = env11;
      a33 = env12;
      break;
    case 12:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      a32 = env11;
      a33 = env12;
      a34 = env13;
      break;
    case 13:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      a32 = env11;
      a33 = env12;
      a34 = env13;
      a41 = env14;
      break;
    case 14:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      a32 = env11;
      a33 = env12;
      a34 = env13;
      a41 = env14;
      a42 = env15;
      break;
    case 15:
      a = env0;
      b = env1;
      a11 = env2;
      a12 = env3;
      a13 = env4;
      a14 = env5;
      a21 = env6;
      a22 = env7;
      a23 = env8;
      a24 = env9;
      a31 = env10;
      a32 = env11;
      a33 = env12;
      a34 = env13;
      a41 = env14;
      a42 = env15;
      a43 = env16;
      break;
    case 16:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      break;
    case 17:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      break;
    case 18:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      break;
    case 19:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      break;
    case 20:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      break;
    case 21:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      break;
    case 22:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      break;
    case 23:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      break;
    case 24:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      break;
    case 25:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      break;
    case 26:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      b32 = env26;
      break;
    case 27:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      b32 = env26;
      b33 = env27;
      break;
    case 28:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      b32 = env26;
      b33 = env27;
      b34 = env28;
      break;
    case 29:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      b32 = env26;
      b33 = env27;
      b34 = env28;
      b41 = env29;
      break;
    case 30:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      b32 = env26;
      b33 = env27;
      b34 = env28;
      b41 = env29;
      b42 = env30;
      break;
    case 31:
      b = env0;
      a11 = env1;
      a12 = env2;
      a13 = env3;
      a14 = env4;
      a21 = env5;
      a22 = env6;
      a23 = env7;
      a24 = env8;
      a31 = env9;
      a32 = env10;
      a33 = env11;
      a34 = env12;
      a41 = env13;
      a42 = env14;
      a43 = env15;
      a44 = env16;
      b11 = env17;
      b12 = env18;
      b13 = env19;
      b14 = env20;
      b21 = env21;
      b22 = env22;
      b23 = env23;
      b24 = env24;
      b31 = env25;
      b32 = env26;
      b33 = env27;
      b34 = env28;
      b41 = env29;
      b42 = env30;
      b43 = env31;
      break;
    case 32:
      a11 = env0;
      a12 = env1;
      a13 = env2;
      a14 = env3;
      a21 = env4;
      a22 = env5;
      a23 = env6;
      a24 = env7;
      a31 = env8;
      a32 = env9;
      a33 = env10;
      a34 = env11;
      a41 = env12;
      a42 = env13;
      a43 = env14;
      a44 = env15;
      b11 = env16;
      b12 = env17;
      b13 = env18;
      b14 = env19;
      b21 = env20;
      b22 = env21;
      b23 = env22;
      b24 = env23;
      b31 = env24;
      b32 = env25;
      b33 = env26;
      b34 = env27;
      b41 = env28;
      b42 = env29;
      b43 = env30;
      b44 = env31;
      break;
  }
  switch (state) {
    case 0:
      var a11 = a.get$n11();
    case 1:
      state = 0;
      var a12 = a.get$n12();
    case 2:
      state = 0;
      var a13 = a.get$n13();
    case 3:
      state = 0;
      var a14 = a.get$n14();
    case 4:
      state = 0;
      var a21 = a.get$n21();
    case 5:
      state = 0;
      var a22 = a.get$n22();
    case 6:
      state = 0;
      var a23 = a.get$n23();
    case 7:
      state = 0;
      var a24 = a.get$n24();
    case 8:
      state = 0;
      var a31 = a.get$n31();
    case 9:
      state = 0;
      var a32 = a.get$n32();
    case 10:
      state = 0;
      var a33 = a.get$n33();
    case 11:
      state = 0;
      var a34 = a.get$n34();
    case 12:
      state = 0;
      var a41 = a.get$n41();
    case 13:
      state = 0;
      var a42 = a.get$n42();
    case 14:
      state = 0;
      var a43 = a.get$n43();
    case 15:
      state = 0;
      var a44 = a.get$n44();
    case 16:
      state = 0;
      var b11 = b.get$n11();
    case 17:
      state = 0;
      var b12 = b.get$n12();
    case 18:
      state = 0;
      var b13 = b.get$n13();
    case 19:
      state = 0;
      var b14 = b.get$n14();
    case 20:
      state = 0;
      var b21 = b.get$n21();
    case 21:
      state = 0;
      var b22 = b.get$n22();
    case 22:
      state = 0;
      var b23 = b.get$n23();
    case 23:
      state = 0;
      var b24 = b.get$n24();
    case 24:
      state = 0;
      var b31 = b.get$n31();
    case 25:
      state = 0;
      var b32 = b.get$n32();
    case 26:
      state = 0;
      var b33 = b.get$n33();
    case 27:
      state = 0;
      var b34 = b.get$n34();
    case 28:
      state = 0;
      var b41 = b.get$n41();
    case 29:
      state = 0;
      var b42 = b.get$n42();
    case 30:
      state = 0;
      var b43 = b.get$n43();
    case 31:
      state = 0;
      var b44 = b.get$n44();
    case 32:
      state = 0;
      this.n11 = $.add($.add($.add($.mul(a11, b11), $.mul(a12, b21)), $.mul(a13, b31)), $.mul(a14, b41));
      this.n12 = $.add($.add($.add($.mul(a11, b12), $.mul(a12, b22)), $.mul(a13, b32)), $.mul(a14, b42));
      this.n13 = $.add($.add($.add($.mul(a11, b13), $.mul(a12, b23)), $.mul(a13, b33)), $.mul(a14, b43));
      this.n14 = $.add($.add($.add($.mul(a11, b14), $.mul(a12, b24)), $.mul(a13, b34)), $.mul(a14, b44));
      this.n21 = $.add($.add($.add($.mul(a21, b11), $.mul(a22, b21)), $.mul(a23, b31)), $.mul(a24, b41));
      this.n22 = $.add($.add($.add($.mul(a21, b12), $.mul(a22, b22)), $.mul(a23, b32)), $.mul(a24, b42));
      this.n23 = $.add($.add($.add($.mul(a21, b13), $.mul(a22, b23)), $.mul(a23, b33)), $.mul(a24, b43));
      this.n24 = $.add($.add($.add($.mul(a21, b14), $.mul(a22, b24)), $.mul(a23, b34)), $.mul(a24, b44));
      this.n31 = $.add($.add($.add($.mul(a31, b11), $.mul(a32, b21)), $.mul(a33, b31)), $.mul(a34, b41));
      this.n32 = $.add($.add($.add($.mul(a31, b12), $.mul(a32, b22)), $.mul(a33, b32)), $.mul(a34, b42));
      this.n33 = $.add($.add($.add($.mul(a31, b13), $.mul(a32, b23)), $.mul(a33, b33)), $.mul(a34, b43));
      this.n34 = $.add($.add($.add($.mul(a31, b14), $.mul(a32, b24)), $.mul(a33, b34)), $.mul(a34, b44));
      this.n41 = $.add($.add($.add($.mul(a41, b11), $.mul(a42, b21)), $.mul(a43, b31)), $.mul(a44, b41));
      this.n42 = $.add($.add($.add($.mul(a41, b12), $.mul(a42, b22)), $.mul(a43, b32)), $.mul(a44, b42));
      this.n43 = $.add($.add($.add($.mul(a41, b13), $.mul(a42, b23)), $.mul(a43, b33)), $.mul(a44, b43));
      this.n44 = $.add($.add($.add($.mul(a41, b14), $.mul(a42, b24)), $.mul(a43, b34)), $.mul(a44, b44));
      return this;
  }
 },
 lookAt$3: function(eye, center, up) {
  var x = $.Matrix4___v1;
  var y = $.Matrix4___v2;
  var z = $.Matrix4___v3;
  z.sub$2(eye, center).normalize$0();
  z.length$0() === 0 && z.set$z(1);
  x.cross$2(up, z).normalize$0();
  if (x.length$0() === 0) {
    z.set$x($.add(z.get$x(), 0.0001));
    x.cross$2(up, z).normalize$0();
  }
  y.cross$2(z, x).normalize$0();
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
 },
 copy$1: function(m) {
  this.setValues$16(m.get$n11(), m.get$n12(), m.get$n13(), m.get$n14(), m.get$n21(), m.get$n22(), m.get$n23(), m.get$n24(), m.get$n31(), m.get$n32(), m.get$n33(), m.get$n34(), m.get$n41(), m.get$n42(), m.get$n43(), m.get$n44());
  return this;
 },
 setValues$16: function(m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44) {
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
 },
 Matrix4$createMatrices$16: function(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  this._flat = $.ListFactory_List(null);
  this._m33 = $.Matrix3$();
 },
 Matrix4$16: function(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  this._flat = $.ListFactory_List(null);
  this._m33 = $.Matrix3$();
  if ($.Matrix4___v1 == null) $.Matrix4___v1 = $.Vector3$(0, 0, 0);
  if ($.Matrix4___v2 == null) $.Matrix4___v2 = $.Vector3$(0, 0, 0);
  if ($.Matrix4___v3 == null) $.Matrix4___v3 = $.Vector3$(0, 0, 0);
  if ($.Matrix4___m1 == null) $.Matrix4___m1 = $.Matrix4$createMatrices(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  if ($.Matrix4___m2 == null) $.Matrix4___m2 = $.Matrix4$createMatrices(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
 }
};

$$.Quaternion = {"":
 ["w=", "z=", "y=", "x="],
 super: "Object",
 multiply$2: function(q1, q2) {
  var t1 = q1.get$x();
  if (typeof t1 !== 'number') return this.multiply$2$bailout(1, q1, q2, t1, 0, 0);
  var t3 = q2.get$w();
  if (typeof t3 !== 'number') return this.multiply$2$bailout(2, q1, q2, t1, t3, 0);
  t3 *= t1;
  t1 = q1.get$y();
  if (typeof t1 !== 'number') return this.multiply$2$bailout(3, q1, q2, t1, t3, 0);
  var t6 = q2.get$z();
  if (typeof t6 !== 'number') return this.multiply$2$bailout(4, q1, q2, t6, t1, t3);
  t3 += t1 * t6;
  var t8 = q1.get$z();
  if (typeof t8 !== 'number') return this.multiply$2$bailout(5, q1, q2, t3, t8, 0);
  var t10 = q2.get$y();
  if (typeof t10 !== 'number') return this.multiply$2$bailout(6, q1, q2, t3, t8, t10);
  t3 -= t8 * t10;
  var t12 = q1.get$w();
  if (typeof t12 !== 'number') return this.multiply$2$bailout(7, q1, q2, t3, t12, 0);
  var t14 = q2.get$x();
  if (typeof t14 !== 'number') return this.multiply$2$bailout(8, q1, q2, t3, t12, t14);
  this.x = t3 + t12 * t14;
  var t16 = q1.get$x();
  if (typeof t16 !== 'number') return this.multiply$2$bailout(9, q1, q2, t16, 0, 0);
  t16 = -t16;
  var t18 = q2.get$z();
  if (typeof t18 !== 'number') return this.multiply$2$bailout(10, q1, q2, t16, t18, 0);
  t18 *= t16;
  t16 = q1.get$y();
  if (typeof t16 !== 'number') return this.multiply$2$bailout(11, q1, q2, t16, t18, 0);
  var t21 = q2.get$w();
  if (typeof t21 !== 'number') return this.multiply$2$bailout(12, q1, q2, t16, t18, t21);
  t18 += t16 * t21;
  var t23 = q1.get$z();
  if (typeof t23 !== 'number') return this.multiply$2$bailout(13, q1, q2, t18, t23, 0);
  var t25 = q2.get$x();
  if (typeof t25 !== 'number') return this.multiply$2$bailout(14, q1, q2, t25, t18, t23);
  t18 += t23 * t25;
  var t27 = q1.get$w();
  if (typeof t27 !== 'number') return this.multiply$2$bailout(15, q1, q2, t18, t27, 0);
  var t29 = q2.get$y();
  if (typeof t29 !== 'number') return this.multiply$2$bailout(16, q1, q2, t18, t27, t29);
  this.y = t18 + t27 * t29;
  var t31 = q1.get$x();
  if (typeof t31 !== 'number') return this.multiply$2$bailout(17, q1, q2, t31, 0, 0);
  var t33 = q2.get$y();
  if (typeof t33 !== 'number') return this.multiply$2$bailout(18, q1, q2, t31, t33, 0);
  t33 *= t31;
  t31 = q1.get$y();
  if (typeof t31 !== 'number') return this.multiply$2$bailout(19, q1, q2, t31, t33, 0);
  var t36 = q2.get$x();
  if (typeof t36 !== 'number') return this.multiply$2$bailout(20, q1, q2, t36, t31, t33);
  t33 -= t31 * t36;
  var t38 = q1.get$z();
  if (typeof t38 !== 'number') return this.multiply$2$bailout(21, q1, q2, t33, t38, 0);
  var t40 = q2.get$w();
  if (typeof t40 !== 'number') return this.multiply$2$bailout(22, q1, q2, t33, t38, t40);
  t33 += t38 * t40;
  var t42 = q1.get$w();
  if (typeof t42 !== 'number') return this.multiply$2$bailout(23, q1, q2, t33, t42, 0);
  var t44 = q2.get$z();
  if (typeof t44 !== 'number') return this.multiply$2$bailout(24, q1, q2, t33, t42, t44);
  this.z = t33 + t42 * t44;
  var t46 = q1.get$x();
  if (typeof t46 !== 'number') return this.multiply$2$bailout(25, q1, q2, t46, 0, 0);
  t46 = -t46;
  var t48 = q2.get$x();
  if (typeof t48 !== 'number') return this.multiply$2$bailout(26, q1, q2, t46, t48, 0);
  t48 *= t46;
  t46 = q1.get$y();
  if (typeof t46 !== 'number') return this.multiply$2$bailout(27, q1, q2, t46, t48, 0);
  var t51 = q2.get$y();
  if (typeof t51 !== 'number') return this.multiply$2$bailout(28, q1, q2, t46, t48, t51);
  t48 -= t46 * t51;
  var t53 = q1.get$z();
  if (typeof t53 !== 'number') return this.multiply$2$bailout(29, q1, q2, t48, t53, 0);
  var t55 = q2.get$z();
  if (typeof t55 !== 'number') return this.multiply$2$bailout(30, q1, q2, t55, t48, t53);
  t48 -= t53 * t55;
  var t57 = q1.get$w();
  if (typeof t57 !== 'number') return this.multiply$2$bailout(31, q2, t48, t57, 0, 0);
  var t59 = q2.get$w();
  if (typeof t59 !== 'number') return this.multiply$2$bailout(32, t48, t57, t59, 0, 0);
  this.w = t48 + t57 * t59;
  return this;
 },
 multiply$2$bailout: function(state, env0, env1, env2, env3, env4) {
  switch (state) {
    case 1:
      var q1 = env0;
      var q2 = env1;
      t1 = env2;
      break;
    case 2:
      q1 = env0;
      q2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      q1 = env0;
      q2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 4:
      q1 = env0;
      q2 = env1;
      t6 = env2;
      t1 = env3;
      t3 = env4;
      break;
    case 5:
      q1 = env0;
      q2 = env1;
      t3 = env2;
      t8 = env3;
      break;
    case 6:
      q1 = env0;
      q2 = env1;
      t3 = env2;
      t8 = env3;
      t10 = env4;
      break;
    case 7:
      q1 = env0;
      q2 = env1;
      t3 = env2;
      t12 = env3;
      break;
    case 8:
      q1 = env0;
      q2 = env1;
      t3 = env2;
      t12 = env3;
      t14 = env4;
      break;
    case 9:
      q1 = env0;
      q2 = env1;
      t16 = env2;
      break;
    case 10:
      q1 = env0;
      q2 = env1;
      t16 = env2;
      t18 = env3;
      break;
    case 11:
      q1 = env0;
      q2 = env1;
      t16 = env2;
      t18 = env3;
      break;
    case 12:
      q1 = env0;
      q2 = env1;
      t16 = env2;
      t18 = env3;
      t21 = env4;
      break;
    case 13:
      q1 = env0;
      q2 = env1;
      t18 = env2;
      t23 = env3;
      break;
    case 14:
      q1 = env0;
      q2 = env1;
      t25 = env2;
      t18 = env3;
      t23 = env4;
      break;
    case 15:
      q1 = env0;
      q2 = env1;
      t18 = env2;
      t27 = env3;
      break;
    case 16:
      q1 = env0;
      q2 = env1;
      t18 = env2;
      t27 = env3;
      t29 = env4;
      break;
    case 17:
      q1 = env0;
      q2 = env1;
      t31 = env2;
      break;
    case 18:
      q1 = env0;
      q2 = env1;
      t31 = env2;
      t33 = env3;
      break;
    case 19:
      q1 = env0;
      q2 = env1;
      t31 = env2;
      t33 = env3;
      break;
    case 20:
      q1 = env0;
      q2 = env1;
      t36 = env2;
      t31 = env3;
      t33 = env4;
      break;
    case 21:
      q1 = env0;
      q2 = env1;
      t33 = env2;
      t38 = env3;
      break;
    case 22:
      q1 = env0;
      q2 = env1;
      t33 = env2;
      t38 = env3;
      t40 = env4;
      break;
    case 23:
      q1 = env0;
      q2 = env1;
      t33 = env2;
      t42 = env3;
      break;
    case 24:
      q1 = env0;
      q2 = env1;
      t33 = env2;
      t42 = env3;
      t44 = env4;
      break;
    case 25:
      q1 = env0;
      q2 = env1;
      t46 = env2;
      break;
    case 26:
      q1 = env0;
      q2 = env1;
      t46 = env2;
      t48 = env3;
      break;
    case 27:
      q1 = env0;
      q2 = env1;
      t46 = env2;
      t48 = env3;
      break;
    case 28:
      q1 = env0;
      q2 = env1;
      t46 = env2;
      t48 = env3;
      t51 = env4;
      break;
    case 29:
      q1 = env0;
      q2 = env1;
      t48 = env2;
      t53 = env3;
      break;
    case 30:
      q1 = env0;
      q2 = env1;
      t55 = env2;
      t48 = env3;
      t53 = env4;
      break;
    case 31:
      q2 = env0;
      t48 = env1;
      t57 = env2;
      break;
    case 32:
      t48 = env0;
      t57 = env1;
      t59 = env2;
      break;
  }
  switch (state) {
    case 0:
      var t1 = q1.get$x();
    case 1:
      state = 0;
      var t3 = q2.get$w();
    case 2:
      state = 0;
      t3 = $.mul(t1, t3);
      t1 = q1.get$y();
    case 3:
      state = 0;
      var t6 = q2.get$z();
    case 4:
      state = 0;
      t3 = $.add(t3, $.mul(t1, t6));
      var t8 = q1.get$z();
    case 5:
      state = 0;
      var t10 = q2.get$y();
    case 6:
      state = 0;
      t3 = $.sub(t3, $.mul(t8, t10));
      var t12 = q1.get$w();
    case 7:
      state = 0;
      var t14 = q2.get$x();
    case 8:
      state = 0;
      this.x = $.add(t3, $.mul(t12, t14));
      var t16 = q1.get$x();
    case 9:
      state = 0;
      t16 = $.neg(t16);
      var t18 = q2.get$z();
    case 10:
      state = 0;
      t18 = $.mul(t16, t18);
      t16 = q1.get$y();
    case 11:
      state = 0;
      var t21 = q2.get$w();
    case 12:
      state = 0;
      t18 = $.add(t18, $.mul(t16, t21));
      var t23 = q1.get$z();
    case 13:
      state = 0;
      var t25 = q2.get$x();
    case 14:
      state = 0;
      t18 = $.add(t18, $.mul(t23, t25));
      var t27 = q1.get$w();
    case 15:
      state = 0;
      var t29 = q2.get$y();
    case 16:
      state = 0;
      this.y = $.add(t18, $.mul(t27, t29));
      var t31 = q1.get$x();
    case 17:
      state = 0;
      var t33 = q2.get$y();
    case 18:
      state = 0;
      t33 = $.mul(t31, t33);
      t31 = q1.get$y();
    case 19:
      state = 0;
      var t36 = q2.get$x();
    case 20:
      state = 0;
      t33 = $.sub(t33, $.mul(t31, t36));
      var t38 = q1.get$z();
    case 21:
      state = 0;
      var t40 = q2.get$w();
    case 22:
      state = 0;
      t33 = $.add(t33, $.mul(t38, t40));
      var t42 = q1.get$w();
    case 23:
      state = 0;
      var t44 = q2.get$z();
    case 24:
      state = 0;
      this.z = $.add(t33, $.mul(t42, t44));
      var t46 = q1.get$x();
    case 25:
      state = 0;
      t46 = $.neg(t46);
      var t48 = q2.get$x();
    case 26:
      state = 0;
      t48 = $.mul(t46, t48);
      t46 = q1.get$y();
    case 27:
      state = 0;
      var t51 = q2.get$y();
    case 28:
      state = 0;
      t48 = $.sub(t48, $.mul(t46, t51));
      var t53 = q1.get$z();
    case 29:
      state = 0;
      var t55 = q2.get$z();
    case 30:
      state = 0;
      t48 = $.sub(t48, $.mul(t53, t55));
      var t57 = q1.get$w();
    case 31:
      state = 0;
      var t59 = q2.get$w();
    case 32:
      state = 0;
      this.w = $.add(t48, $.mul(t57, t59));
      return this;
  }
 },
 normalize$0: function() {
  var t1 = this.x;
  if (typeof t1 !== 'number') return this.normalize$0$bailout(1, t1, 0);
  t1 *= t1;
  var t3 = this.y;
  if (typeof t3 !== 'number') return this.normalize$0$bailout(2, t1, t3);
  t1 += t3 * t3;
  var t5 = this.z;
  if (typeof t5 !== 'number') return this.normalize$0$bailout(3, t5, t1);
  t1 += t5 * t5;
  var t7 = this.w;
  if (typeof t7 !== 'number') return this.normalize$0$bailout(4, t1, t7);
  var l = $.Math_sqrt(t1 + t7 * t7);
  if (l === 0) {
    this.x = 0;
    this.y = 0;
    this.z = 0;
    this.w = 0;
  } else {
    if (typeof l !== 'number') throw $.iae(l);
    l = 1 / l;
    t1 = this.x;
    if (typeof t1 !== 'number') return this.normalize$0$bailout(5, t1, l);
    this.x = t1 * l;
    t3 = this.y;
    if (typeof t3 !== 'number') return this.normalize$0$bailout(6, t3, l);
    this.y = t3 * l;
    t5 = this.z;
    if (typeof t5 !== 'number') return this.normalize$0$bailout(7, t5, l);
    this.z = t5 * l;
    t7 = this.w;
    if (typeof t7 !== 'number') return this.normalize$0$bailout(8, t7, l);
    this.w = t7 * l;
  }
  return this;
 },
 normalize$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
    case 3:
      t5 = env0;
      t1 = env1;
      break;
    case 4:
      t1 = env0;
      t7 = env1;
      break;
    case 5:
      t1 = env0;
      l = env1;
      break;
    case 6:
      t3 = env0;
      l = env1;
      break;
    case 7:
      t5 = env0;
      l = env1;
      break;
    case 8:
      t7 = env0;
      l = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this.x;
    case 1:
      state = 0;
      t1 = $.mul(t1, t1);
      var t3 = this.y;
    case 2:
      state = 0;
      t1 = $.add(t1, $.mul(t3, t3));
      var t5 = this.z;
    case 3:
      state = 0;
      t1 = $.add(t1, $.mul(t5, t5));
      var t7 = this.w;
    case 4:
      state = 0;
      var l = $.Math_sqrt($.add(t1, $.mul(t7, t7)));
    default:
      if ((state == 0 && l === 0)) {
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.w = 0;
      } else {
        switch (state) {
          case 0:
            if (typeof l !== 'number') throw $.iae(l);
            l = 1 / l;
            t1 = this.x;
          case 5:
            state = 0;
            this.x = $.mul(t1, l);
            t3 = this.y;
          case 6:
            state = 0;
            this.y = $.mul(t3, l);
            t5 = this.z;
          case 7:
            state = 0;
            this.z = $.mul(t5, l);
            t7 = this.w;
          case 8:
            state = 0;
            this.w = $.mul(t7, l);
        }
      }
      return this;
  }
 },
 length$0: function() {
  var t1 = this.x;
  if (typeof t1 !== 'number') return this.length$0$bailout(1, t1, 0);
  t1 *= t1;
  var t3 = this.y;
  if (typeof t3 !== 'number') return this.length$0$bailout(2, t1, t3);
  t1 += t3 * t3;
  var t5 = this.z;
  if (typeof t5 !== 'number') return this.length$0$bailout(3, t5, t1);
  t1 += t5 * t5;
  var t7 = this.w;
  if (typeof t7 !== 'number') return this.length$0$bailout(4, t1, t7);
  return $.Math_sqrt(t1 + t7 * t7);
 },
 length$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      t3 = env1;
      break;
    case 3:
      t5 = env0;
      t1 = env1;
      break;
    case 4:
      t1 = env0;
      t7 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this.x;
    case 1:
      state = 0;
      t1 = $.mul(t1, t1);
      var t3 = this.y;
    case 2:
      state = 0;
      t1 = $.add(t1, $.mul(t3, t3));
      var t5 = this.z;
    case 3:
      state = 0;
      t1 = $.add(t1, $.mul(t5, t5));
      var t7 = this.w;
    case 4:
      state = 0;
      return $.Math_sqrt($.add(t1, $.mul(t7, t7)));
  }
 },
 get$length: function() { return new $.BoundClosure(this, 'length$0'); },
 copy$1: function(q) {
  this.x = q.get$x();
  this.y = q.get$y();
  this.z = q.get$z();
  this.w = q.get$w();
  return this;
 },
 setValues$4: function(newX, newY, newZ, newW) {
  this.x = newX;
  this.y = newY;
  this.z = newZ;
  this.w = newW;
  return this;
 }
};

$$.Vector4 = {"":
 ["_w", "_z", "_y", "_x"],
 super: "Object",
 lerpSelf$2: function(v, alpha) {
  this._x = $.add(this._x, $.mul($.sub(v.get$x(), this._x), alpha));
  this._y = $.add(this._y, $.mul($.sub(v.get$y(), this._y), alpha));
  this._z = $.add(this._z, $.mul($.sub(v.get$z(), this._z), alpha));
  this._w = $.add(this._w, $.mul($.sub(v.get$w(), this._w), alpha));
  return this;
 },
 normalize$0: function() {
  return this.divideScalar$1(this.length$0());
 },
 length$0: function() {
  return $.Math_sqrt(this.lengthSq$0());
 },
 get$length: function() { return new $.BoundClosure(this, 'length$0'); },
 lengthSq$0: function() {
  return this.dot$1(this);
 },
 dot$1: function(v) {
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.dot$1$bailout(1, v, t1, 0, 0);
  var t3 = v.get$x();
  if (typeof t3 !== 'number') return this.dot$1$bailout(2, v, t1, t3, 0);
  t3 *= t1;
  t1 = this._y;
  if (typeof t1 !== 'number') return this.dot$1$bailout(3, v, t1, t3, 0);
  var t6 = v.get$y();
  if (typeof t6 !== 'number') return this.dot$1$bailout(4, v, t6, t1, t3);
  t3 += t1 * t6;
  var t8 = this._z;
  if (typeof t8 !== 'number') return this.dot$1$bailout(5, v, t3, t8, 0);
  var t10 = v.get$z();
  if (typeof t10 !== 'number') return this.dot$1$bailout(6, v, t3, t8, t10);
  t3 += t8 * t10;
  var t12 = this._w;
  if (typeof t12 !== 'number') return this.dot$1$bailout(7, v, t3, t12, 0);
  var t14 = v.get$w();
  if (typeof t14 !== 'number') return this.dot$1$bailout(8, t3, t14, t12, 0);
  return t3 + t12 * t14;
 },
 dot$1$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var v = env0;
      t1 = env1;
      break;
    case 2:
      v = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 3:
      v = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 4:
      v = env0;
      t6 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 5:
      v = env0;
      t3 = env1;
      t8 = env2;
      break;
    case 6:
      v = env0;
      t3 = env1;
      t8 = env2;
      t10 = env3;
      break;
    case 7:
      v = env0;
      t3 = env1;
      t12 = env2;
      break;
    case 8:
      t3 = env0;
      t14 = env1;
      t12 = env2;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._x;
    case 1:
      state = 0;
      var t3 = v.get$x();
    case 2:
      state = 0;
      t3 = $.mul(t1, t3);
      t1 = this._y;
    case 3:
      state = 0;
      var t6 = v.get$y();
    case 4:
      state = 0;
      t3 = $.add(t3, $.mul(t1, t6));
      var t8 = this._z;
    case 5:
      state = 0;
      var t10 = v.get$z();
    case 6:
      state = 0;
      t3 = $.add(t3, $.mul(t8, t10));
      var t12 = this._w;
    case 7:
      state = 0;
      var t14 = v.get$w();
    case 8:
      state = 0;
      return $.add(t3, $.mul(t12, t14));
  }
 },
 divideScalar$1: function(s) {
  if (typeof s !== 'number') return this.divideScalar$1$bailout(1, s, 0);
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.divideScalar$1$bailout(2, s, t1);
  this._x = t1 / s;
  var t3 = this._y;
  if (typeof t3 !== 'number') return this.divideScalar$1$bailout(3, s, t3);
  this._y = t3 / s;
  var t5 = this._z;
  if (typeof t5 !== 'number') return this.divideScalar$1$bailout(4, s, t5);
  this._z = t5 / s;
  var t7 = this._w;
  if (typeof t7 !== 'number') return this.divideScalar$1$bailout(5, s, t7);
  this._w = t7 / s;
  return this;
 },
 divideScalar$1$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      var s = env0;
      break;
    case 2:
      s = env0;
      t1 = env1;
      break;
    case 3:
      s = env0;
      t3 = env1;
      break;
    case 4:
      s = env0;
      t5 = env1;
      break;
    case 5:
      s = env0;
      t7 = env1;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
    default:
      if (state == 2 || state == 3 || state == 4 || state == 5 || (state == 0 && !(s == null))) {
        switch (state) {
          case 0:
            var t1 = this._x;
          case 2:
            state = 0;
            this._x = $.div(t1, s);
            var t3 = this._y;
          case 3:
            state = 0;
            this._y = $.div(t3, s);
            var t5 = this._z;
          case 4:
            state = 0;
            this._z = $.div(t5, s);
            var t7 = this._w;
          case 5:
            state = 0;
            this._w = $.div(t7, s);
        }
      } else {
        this._x = 0;
        this._y = 0;
        this._z = 0;
        this._w = 1;
      }
      return this;
  }
 },
 multiplyScalar$1: function(s) {
  if (typeof s !== 'number') return this.multiplyScalar$1$bailout(1, s, 0);
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.multiplyScalar$1$bailout(2, s, t1);
  this._x = t1 * s;
  var t3 = this._y;
  if (typeof t3 !== 'number') return this.multiplyScalar$1$bailout(3, s, t3);
  this._y = t3 * s;
  var t5 = this._z;
  if (typeof t5 !== 'number') return this.multiplyScalar$1$bailout(4, s, t5);
  this._z = t5 * s;
  var t7 = this._w;
  if (typeof t7 !== 'number') return this.multiplyScalar$1$bailout(5, s, t7);
  this._w = t7 * s;
  return this;
 },
 multiplyScalar$1$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      var s = env0;
      break;
    case 2:
      s = env0;
      t1 = env1;
      break;
    case 3:
      s = env0;
      t3 = env1;
      break;
    case 4:
      s = env0;
      t5 = env1;
      break;
    case 5:
      s = env0;
      t7 = env1;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      var t1 = this._x;
    case 2:
      state = 0;
      this._x = $.mul(t1, s);
      var t3 = this._y;
    case 3:
      state = 0;
      this._y = $.mul(t3, s);
      var t5 = this._z;
    case 4:
      state = 0;
      this._z = $.mul(t5, s);
      var t7 = this._w;
    case 5:
      state = 0;
      this._w = $.mul(t7, s);
      return this;
  }
 },
 sub$2: function(v1, v2) {
  var t1 = v1.get$x();
  if (typeof t1 !== 'number') return this.sub$2$bailout(1, v1, v2, t1, 0);
  var t3 = v2.get$x();
  if (typeof t3 !== 'number') return this.sub$2$bailout(2, v1, v2, t1, t3);
  this._x = t1 - t3;
  var t5 = v1.get$y();
  if (typeof t5 !== 'number') return this.sub$2$bailout(3, v1, v2, t5, 0);
  var t7 = v2.get$y();
  if (typeof t7 !== 'number') return this.sub$2$bailout(4, v1, v2, t5, t7);
  this._y = t5 - t7;
  var t9 = v1.get$z();
  if (typeof t9 !== 'number') return this.sub$2$bailout(5, v1, v2, t9, 0);
  var t11 = v2.get$z();
  if (typeof t11 !== 'number') return this.sub$2$bailout(6, v1, v2, t9, t11);
  this._z = t9 - t11;
  var t13 = v1.get$w();
  if (typeof t13 !== 'number') return this.sub$2$bailout(7, v2, t13, 0, 0);
  var t15 = v2.get$w();
  if (typeof t15 !== 'number') return this.sub$2$bailout(8, t13, t15, 0, 0);
  this._w = t13 - t15;
  return this;
 },
 sub$2$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      t1 = env2;
      break;
    case 2:
      v1 = env0;
      v2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      v1 = env0;
      v2 = env1;
      t5 = env2;
      break;
    case 4:
      v1 = env0;
      v2 = env1;
      t5 = env2;
      t7 = env3;
      break;
    case 5:
      v1 = env0;
      v2 = env1;
      t9 = env2;
      break;
    case 6:
      v1 = env0;
      v2 = env1;
      t9 = env2;
      t11 = env3;
      break;
    case 7:
      v2 = env0;
      t13 = env1;
      break;
    case 8:
      t13 = env0;
      t15 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = v1.get$x();
    case 1:
      state = 0;
      var t3 = v2.get$x();
    case 2:
      state = 0;
      this._x = $.sub(t1, t3);
      var t5 = v1.get$y();
    case 3:
      state = 0;
      var t7 = v2.get$y();
    case 4:
      state = 0;
      this._y = $.sub(t5, t7);
      var t9 = v1.get$z();
    case 5:
      state = 0;
      var t11 = v2.get$z();
    case 6:
      state = 0;
      this._z = $.sub(t9, t11);
      var t13 = v1.get$w();
    case 7:
      state = 0;
      var t15 = v2.get$w();
    case 8:
      state = 0;
      this._w = $.sub(t13, t15);
      return this;
  }
 },
 addSelf$1: function(v) {
  this._x = $.add(this._x, v.get$x());
  this._y = $.add(this._y, v.get$y());
  this._z = $.add(this._z, v.get$z());
  this._w = $.add(this._w, v.get$w());
  return this;
 },
 copy$1: function(v) {
  this._x = v.get$x();
  this._y = v.get$y();
  this._z = v.get$z();
  if (typeof v === 'object' && v !== null && !!v.is$IVector4) this._w = v.get$w();
  else this._w = 1;
 },
 setValues$4: function(x, y, z, w) {
  this._x = x;
  this._y = y;
  this._z = z;
  this._w = w;
  return this;
 },
 set$w: function(value) {
  this._w = value;
 },
 get$w: function() {
  return this._w;
 },
 set$z: function(value) {
  this._z = value;
 },
 get$z: function() {
  return this._z;
 },
 set$y: function(value) {
  this._y = value;
 },
 get$y: function() {
  return this._y;
 },
 set$x: function(value) {
  this._x = value;
 },
 get$x: function() {
  return this._x;
 },
 Vector4$4: function(x, y, z, w) {
  this._x = !(x == null) ? x : 0;
  this._y = !(y == null) ? y : 0;
  this._z = !(z == null) ? z : 0;
  this._w = !(w == null) ? w : 1;
 },
 is$IVector4: true
};

$$.Object3D = {"":
 ["frustumCulled?", "visible=", "matrixWorld?", "scale?", "rotation=", "position?", "children?", "parent=", "id?"],
 super: "Object",
 updateMatrixWorld$1: function(force) {
  if (typeof force !== 'boolean') return this.updateMatrixWorld$1$bailout(1, force);
  this.matrixAutoUpdate && this.updateMatrix$0();
  if (!this.matrixWorldNeedsUpdate) var t1 = force;
  else t1 = true;
  if (t1) {
    t1 = this.parent;
    var t2 = !(t1 == null);
    var t3 = this.matrixWorld;
    var t4 = this.matrix;
    if (t2) t3.multiply$2(t1.get$matrixWorld(), t4);
    else t3.copy$1(t4);
    this.matrixWorldNeedsUpdate = false;
    force = true;
  }
  for (t1 = this.children, l = t1.length, i = 0; i < l; ++i) {
    t2 = t1.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    t1[i].updateMatrixWorld$1(force);
  }
  var l, i;
 },
 updateMatrixWorld$1$bailout: function(state, force) {
  this.matrixAutoUpdate === true && this.updateMatrix$0();
  if (this.matrixWorldNeedsUpdate === true || force === true) {
    var t1 = this.parent;
    var t2 = !(t1 == null);
    var t3 = this.matrixWorld;
    var t4 = this.matrix;
    if (t2) t3.multiply$2(t1.get$matrixWorld(), t4);
    else t3.copy$1(t4);
    this.matrixWorldNeedsUpdate = false;
    force = true;
  }
  for (t1 = this.children, l = t1.length, i = 0; i < l; ++i) {
    t2 = t1.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    t1[i].updateMatrixWorld$1(force);
  }
  var l, i;
 },
 updateMatrixWorld$0: function() {
  return this.updateMatrixWorld$1(false)
},
 updateMatrix$0: function() {
  var t1 = this.matrix;
  t1.setPosition$1(this.position);
  if (this.useQuaternion === true) t1.setRotationFromQuaternion$1(this.quaternion);
  else t1.setRotationFromEuler$2(this.rotation, this.eulerOrder);
  var t2 = this.scale;
  if (!(t2.get$x() === 1) || (!(t2.get$y() === 1) || !(t2.get$z() === 1))) {
    t1.scale$1(t2);
    this.boundRadiusScale = $.Math_max(t2.get$x(), $.Math_max(t2.get$y(), t2.get$z()));
  }
  this.matrixWorldNeedsUpdate = true;
 },
 remove$1: function(object) {
  var t1 = this.children;
  var index = $.indexOf$1(t1, object);
  if (!(index === -1)) {
    object.set$parent(null);
    $.removeRange(t1, index, 1);
    for (var scene = this; !(scene.get$parent() == null); ) {
      scene = scene.get$parent();
    }
    typeof scene === 'object' && scene !== null && !!scene.is$Scene && scene.removeObject$1(object);
  }
 },
 add$1: function(object) {
  var t1 = this.children;
  if ($.indexOf$1(t1, object) === -1) {
    !(object.get$parent() == null) && object.get$parent().remove$1(object);
    object.set$parent(this);
    $.add$1(t1, object);
    for (var scene = this; !(scene.get$parent() == null); ) {
      scene = scene.get$parent();
    }
    typeof scene === 'object' && scene !== null && !!scene.is$Scene && scene.addObject$1(object);
  }
 },
 lookAt$1: function(vector) {
  var t1 = this.matrix;
  t1.lookAt$3(vector, this.position, this.up);
  this.rotationAutoUpdate === true && this.rotation.setRotationFromMatrix$1(t1);
 },
 translate$2: function(distance, axis) {
  this.matrix.rotateAxis$1(axis);
  this.position.addSelf$1(axis.multiplyScalar$1(distance));
 },
 scale$1: function(arg0) { return this.scale.$call$1(arg0); },
 scale$2: function(arg0, arg1) { return this.scale.$call$2(arg0, arg1); },
 Object3D$0: function() {
  this._name = '';
  var t1 = $.Three_Object3DCount;
  $.Three_Object3DCount = $.add(t1, 1);
  this.id = t1;
  this.parent = null;
  this.children = [];
  this.up = $.Vector3$(0, 0, 0);
  this.position = $.Vector3$(0, 0, 0);
  this.rotation = $.Vector3$(0, 0, 0);
  this.eulerOrder = 'XYZ';
  this.scale = $.Vector3$(1, 1, 1);
  this.dynamic = false;
  this.doubleSided = false;
  this.flipSided = false;
  this.renderDepth = null;
  this.rotationAutoUpdate = true;
  this.matrix = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this.matrixWorld = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this.matrixRotationWorld = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this.matrixAutoUpdate = true;
  this.matrixWorldNeedsUpdate = true;
  this.quaternion = $.Quaternion$(0, 0, 0, 1);
  this.useQuaternion = false;
  this.boundRadius = 0.0;
  this.boundRadiusScale = 1.0;
  this.visible = true;
  this.castShadow = false;
  this.receiveShadow = false;
  this.frustumCulled = true;
  this._vector = $.Vector3$(0, 0, 0);
 }
};

$$.Color = {"":
 ["b=", "g=", "r="],
 super: "Object",
 getContextStyle$0: function() {
  var t1 = this.r;
  t1 = typeof t1 === 'number' && $.ltB(this.r, 1);
  var rr = this.r;
  if (t1) rr = $.toInt($.mul(rr, 255));
  t1 = this.g;
  t1 = typeof t1 === 'number' && $.ltB(this.g, 1);
  var gg = this.g;
  if (t1) gg = $.toInt($.mul(gg, 255));
  t1 = this.b;
  t1 = typeof t1 === 'number' && $.ltB(this.b, 1);
  var bb = this.b;
  if (t1) bb = $.toInt($.mul(bb, 255));
  return 'rgb(' + $.S(rr) + ',' + $.S(gg) + ',' + $.S(bb) + ')';
 },
 setHex$1: function(hex) {
  var h = $.toInt($.floor(hex));
  this.r = $.shr($.and(h, 16711680), 16);
  this.g = $.shr($.and(h, 65280), 8);
  this.b = $.and(h, 255);
  return this;
 },
 setRGB$3: function(newR, newG, newB) {
  this.r = newR;
  this.g = newG;
  this.b = newB;
  return this;
 },
 copy$1: function(color) {
  this.r = color.get$r();
  this.g = color.get$g();
  this.b = color.get$b();
  return this;
 },
 Color$1: function(hex) {
  this.r = 1;
  this.g = 1;
  this.b = 1;
  typeof hex === 'number' && this.setHex$1(hex);
 }
};

$$.Frustum = {"":
 ["_planes"],
 super: "Object",
 contains$1: function(object) {
  var planes = this._planes;
  var matrix = object.get$matrixWorld();
  var scale = $.Frustum___v1.setValues$3(matrix.getColumnX$0().length$0(), matrix.getColumnY$0().length$0(), matrix.getColumnZ$0().length$0());
  var radius = $.mul($.neg($.index(object.get$geometry().get$boundingSphere(), 'radius')), $.Math_max(scale.get$x(), $.Math_max(scale.get$y(), scale.get$z())));
  if (typeof radius !== 'number') return this.contains$1$bailout(1, planes, matrix, radius);
  for (var distance = null, i = 0; i < 6; ++i) {
    var t1 = planes.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var t2 = $.mul(planes[i].get$x(), matrix.get$n14());
    var t3 = planes.length;
    if (i < 0 || i >= t3) throw $.ioore(i);
    t2 = $.add(t2, $.mul(planes[i].get$y(), matrix.get$n24()));
    var t4 = planes.length;
    if (i < 0 || i >= t4) throw $.ioore(i);
    t2 = $.add(t2, $.mul(planes[i].get$z(), matrix.get$n34()));
    var t5 = planes.length;
    if (i < 0 || i >= t5) throw $.ioore(i);
    distance = $.add(t2, planes[i].get$w());
    if ($.leB(distance, radius)) return false;
  }
  return true;
 },
 contains$1$bailout: function(state, planes, matrix, radius) {
  for (var distance = null, i = 0; i < 6; ++i) {
    var t1 = planes.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var t2 = $.mul(planes[i].get$x(), matrix.get$n14());
    var t3 = planes.length;
    if (i < 0 || i >= t3) throw $.ioore(i);
    t2 = $.add(t2, $.mul(planes[i].get$y(), matrix.get$n24()));
    var t4 = planes.length;
    if (i < 0 || i >= t4) throw $.ioore(i);
    t2 = $.add(t2, $.mul(planes[i].get$z(), matrix.get$n34()));
    var t5 = planes.length;
    if (i < 0 || i >= t5) throw $.ioore(i);
    distance = $.add(t2, planes[i].get$w());
    if ($.leB(distance, radius)) return false;
  }
  return true;
 },
 setFromMatrix$1: function(m) {
  var planes = this._planes;
  var t1 = planes.length;
  if (0 < 0 || 0 >= t1) throw $.ioore(0);
  planes[0].setValues$4($.sub(m.get$n41(), m.get$n11()), $.sub(m.get$n42(), m.get$n12()), $.sub(m.get$n43(), m.get$n13()), $.sub(m.get$n44(), m.get$n14()));
  var t2 = planes.length;
  if (1 < 0 || 1 >= t2) throw $.ioore(1);
  planes[1].setValues$4($.add(m.get$n41(), m.get$n11()), $.add(m.get$n42(), m.get$n12()), $.add(m.get$n43(), m.get$n13()), $.add(m.get$n44(), m.get$n14()));
  var t3 = planes.length;
  if (2 < 0 || 2 >= t3) throw $.ioore(2);
  planes[2].setValues$4($.add(m.get$n41(), m.get$n21()), $.add(m.get$n42(), m.get$n22()), $.add(m.get$n43(), m.get$n23()), $.add(m.get$n44(), m.get$n24()));
  var t4 = planes.length;
  if (3 < 0 || 3 >= t4) throw $.ioore(3);
  planes[3].setValues$4($.sub(m.get$n41(), m.get$n21()), $.sub(m.get$n42(), m.get$n22()), $.sub(m.get$n43(), m.get$n23()), $.sub(m.get$n44(), m.get$n24()));
  var t5 = planes.length;
  if (4 < 0 || 4 >= t5) throw $.ioore(4);
  planes[4].setValues$4($.sub(m.get$n41(), m.get$n31()), $.sub(m.get$n42(), m.get$n32()), $.sub(m.get$n43(), m.get$n33()), $.sub(m.get$n44(), m.get$n34()));
  var t6 = planes.length;
  if (5 < 0 || 5 >= t6) throw $.ioore(5);
  var plane = planes[5];
  plane.setValues$4($.add(m.get$n41(), m.get$n31()), $.add(m.get$n42(), m.get$n32()), $.add(m.get$n43(), m.get$n33()), $.add(m.get$n44(), m.get$n34()));
  for (var i = 0; i < 6; ++i) {
    t1 = planes.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    plane = planes[i];
    plane.divideScalar$1($.Math_sqrt($.add($.add($.mul(plane.get$x(), plane.get$x()), $.mul(plane.get$y(), plane.get$y())), $.mul(plane.get$z(), plane.get$z()))));
  }
 },
 Frustum$0: function() {
  if ($.Frustum___v1 == null) $.Frustum___v1 = $.Vector3$(0, 0, 0);
  this._planes = [$.Vector4$(0, 0, 0, 1), $.Vector4$(0, 0, 0, 1), $.Vector4$(0, 0, 0, 1), $.Vector4$(0, 0, 0, 1), $.Vector4$(0, 0, 0, 1), $.Vector4$(0, 0, 0, 1)];
 }
};

$$.Geometry = {"":
 ["_dynamic", "_hasTangents", "_boundingSphere", "_boundingBox", "__tmpVertices", "_skinIndices", "_skinWeights", "_morphColors", "_morphTargets", "_faceVertexUvs", "_faceUvs", "tan2", "tan1", "_faces", "_materials", "_colors", "_vertices", "_id?"],
 super: "Object",
 computeBoundingSphere$0: function() {
  var t1 = this._vertices;
  var vl = t1.length;
  for (var radius = null, maxRadius = 0, v = 0; v < vl; ++v) {
    var t2 = t1.length;
    if (v < 0 || v >= t2) throw $.ioore(v);
    radius = t1[v].get$position().length$0();
    if ($.gtB(radius, maxRadius)) maxRadius = radius;
  }
  this._boundingSphere = $.makeLiteralMap(['radius', maxRadius]);
 },
 get$faceVertexUvs: function() {
  return this._faceVertexUvs;
 },
 get$vertices: function() {
  return this._vertices;
 },
 get$materials: function() {
  return this._materials;
 },
 get$faces: function() {
  return this._faces;
 },
 get$boundingSphere: function() {
  return this._boundingSphere;
 },
 Geometry$0: function() {
  var t1 = $.Three_GeometryCount;
  $.Three_GeometryCount = $.add(t1, 1);
  this._id = t1;
  this._vertices = [];
  this._colors = [];
  this._materials = [];
  this._faces = [];
  this._faceUvs = [[]];
  this._faceVertexUvs = [];
  $.add$1(this._faceVertexUvs, $.ListFactory_List(null));
  this._morphTargets = [];
  this._morphColors = [];
  this._skinWeights = [];
  this._skinIndices = [];
  this._boundingBox = null;
  this._boundingSphere = null;
  this._hasTangents = false;
  this._dynamic = false;
 }
};

$$.Vertex = {"":
 ["_position"],
 super: "Object",
 get$position: function() {
  return this._position;
 },
 Vertex$1: function(position) {
  this._position = !(position == null) ? position : $.Vector3$(0, 0, 0);
 }
};

$$.Projector = {"":
 ["_frustum", "_projScreenobjectMatrixWorld", "_projScreenMatrix", "_renderData", "_clippedVertex2PositionScreen", "_clippedVertex1PositionScreen", "_vector4", "_vector3", "_particle", "_line", "_vertex", "_object", "_particleCount", "_lineCount", "_face4Count", "_face3Count", "_vertexCount", "_objectCount", "_particlePool", "_linePool", "_face3Pool", "_face4Pool", "_vertexPool", "_objectPool"],
 super: "Object",
 clipLine$2: function(s1, s2) {
  var t1 = s1.get$z();
  if (typeof t1 !== 'number') return this.clipLine$2$bailout(1, s1, s2, t1, 0, 0, 0, 0);
  var t3 = s1.get$w();
  if (typeof t3 !== 'number') return this.clipLine$2$bailout(2, s1, s2, t1, t3, 0, 0, 0);
  var bc1near = t1 + t3;
  t3 = s2.get$z();
  if (typeof t3 !== 'number') return this.clipLine$2$bailout(3, s1, s2, bc1near, t3, 0, 0, 0);
  var t5 = s2.get$w();
  if (typeof t5 !== 'number') return this.clipLine$2$bailout(4, s1, s2, bc1near, t3, t5, 0, 0);
  var bc2near = t3 + t5;
  t5 = s1.get$z();
  if (typeof t5 !== 'number') return this.clipLine$2$bailout(5, s1, s2, bc1near, bc2near, t5, 0, 0);
  t5 = -t5;
  var t7 = s1.get$w();
  if (typeof t7 !== 'number') return this.clipLine$2$bailout(6, s1, s2, t7, t5, bc1near, bc2near, 0);
  var bc1far = t5 + t7;
  t7 = s2.get$z();
  if (typeof t7 !== 'number') return this.clipLine$2$bailout(7, s1, s2, bc1far, t7, bc1near, bc2near, 0);
  t7 = -t7;
  var t9 = s2.get$w();
  if (typeof t9 !== 'number') return this.clipLine$2$bailout(8, s1, s2, bc1far, t7, t9, bc1near, bc2near);
  var bc2far = t7 + t9;
  if (bc1near >= 0 && (bc2near >= 0 && (bc1far >= 0 && bc2far >= 0))) return true;
  t1 = bc1near < 0;
  if (!(t1 && bc2near < 0)) {
    var t2 = bc1far < 0 && bc2far < 0;
  } else t2 = true;
  if (t2) return false;
  if (t1) {
    var alpha1 = $.Math_max(0, bc1near / (bc1near - bc2near));
    if (typeof alpha1 !== 'number') return this.clipLine$2$bailout(9, s1, s2, bc2far, bc1far, alpha1, 0, 0);
    var alpha2 = 1;
  } else {
    if (bc2near < 0) {
      alpha2 = $.Math_min(1, bc1near / (bc1near - bc2near));
      if (typeof alpha2 !== 'number') return this.clipLine$2$bailout(10, s1, s2, bc2far, bc1far, alpha2, 0, 0);
    } else alpha2 = 1;
    alpha1 = 0;
  }
  if (bc1far < 0) {
    alpha1 = $.Math_max(alpha1, bc1far / (bc1far - bc2far));
    if (typeof alpha1 !== 'number') return this.clipLine$2$bailout(11, s1, s2, alpha2, alpha1, 0, 0, 0);
  } else {
    if (bc2far < 0) {
      alpha2 = $.Math_min(alpha2, bc1far / (bc1far - bc2far));
      if (typeof alpha2 !== 'number') return this.clipLine$2$bailout(12, s1, s2, alpha1, alpha2, 0, 0, 0);
    }
  }
  if (alpha2 < alpha1) return false;
  s1.lerpSelf$2(s2, alpha1);
  s2.lerpSelf$2(s1, 1 - alpha2);
  return true;
 },
 clipLine$2$bailout: function(state, env0, env1, env2, env3, env4, env5, env6) {
  switch (state) {
    case 1:
      var s1 = env0;
      var s2 = env1;
      t1 = env2;
      break;
    case 2:
      s1 = env0;
      s2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      s1 = env0;
      s2 = env1;
      bc1near = env2;
      t3 = env3;
      break;
    case 4:
      s1 = env0;
      s2 = env1;
      bc1near = env2;
      t3 = env3;
      t5 = env4;
      break;
    case 5:
      s1 = env0;
      s2 = env1;
      bc1near = env2;
      bc2near = env3;
      t5 = env4;
      break;
    case 6:
      s1 = env0;
      s2 = env1;
      t7 = env2;
      t5 = env3;
      bc1near = env4;
      bc2near = env5;
      break;
    case 7:
      s1 = env0;
      s2 = env1;
      bc1far = env2;
      t7 = env3;
      bc1near = env4;
      bc2near = env5;
      break;
    case 8:
      s1 = env0;
      s2 = env1;
      bc1far = env2;
      t7 = env3;
      t9 = env4;
      bc1near = env5;
      bc2near = env6;
      break;
    case 9:
      s1 = env0;
      s2 = env1;
      bc2far = env2;
      bc1far = env3;
      alpha1 = env4;
      break;
    case 10:
      s1 = env0;
      s2 = env1;
      bc2far = env2;
      bc1far = env3;
      alpha2 = env4;
      break;
    case 11:
      s1 = env0;
      s2 = env1;
      alpha2 = env2;
      alpha1 = env3;
      break;
    case 12:
      s1 = env0;
      s2 = env1;
      alpha1 = env2;
      alpha2 = env3;
      break;
  }
  switch (state) {
    case 0:
      var t1 = s1.get$z();
    case 1:
      state = 0;
      var t3 = s1.get$w();
    case 2:
      state = 0;
      var bc1near = $.add(t1, t3);
      t3 = s2.get$z();
    case 3:
      state = 0;
      var t5 = s2.get$w();
    case 4:
      state = 0;
      var bc2near = $.add(t3, t5);
      t5 = s1.get$z();
    case 5:
      state = 0;
      t5 = $.neg(t5);
      var t7 = s1.get$w();
    case 6:
      state = 0;
      var bc1far = $.add(t5, t7);
      t7 = s2.get$z();
    case 7:
      state = 0;
      t7 = $.neg(t7);
      var t9 = s2.get$w();
    case 8:
      state = 0;
      var bc2far = $.add(t7, t9);
    default:
      if ((state == 0 && ($.geB(bc1near, 0) && ($.geB(bc2near, 0) && ($.geB(bc1far, 0) && $.geB(bc2far, 0)))))) {
        return true;
      } else {
        switch (state) {
          case 0:
            if (!($.ltB(bc1near, 0) && $.ltB(bc2near, 0))) {
              t1 = $.ltB(bc1far, 0) && $.ltB(bc2far, 0);
            } else t1 = true;
          default:
            if ((state == 0 && t1)) {
              return false;
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 9 || (state == 0 && $.ltB(bc1near, 0))) {
                    switch (state) {
                      case 0:
                        var alpha1 = $.Math_max(0, $.div(bc1near, $.sub(bc1near, bc2near)));
                      case 9:
                        state = 0;
                        var alpha2 = 1;
                    }
                  } else {
                    switch (state) {
                      case 0:
                      case 10:
                        if (state == 10 || (state == 0 && $.ltB(bc2near, 0))) {
                          switch (state) {
                            case 0:
                              alpha2 = $.Math_min(1, $.div(bc1near, $.sub(bc1near, bc2near)));
                            case 10:
                              state = 0;
                          }
                        } else {
                          alpha2 = 1;
                        }
                        alpha1 = 0;
                    }
                  }
                case 11:
                case 12:
                  if (state == 11 || (state == 0 && $.ltB(bc1far, 0))) {
                    switch (state) {
                      case 0:
                        alpha1 = $.Math_max(alpha1, $.div(bc1far, $.sub(bc1far, bc2far)));
                      case 11:
                        state = 0;
                    }
                  } else {
                    switch (state) {
                      case 0:
                      case 12:
                        if (state == 12 || (state == 0 && $.ltB(bc2far, 0))) {
                          switch (state) {
                            case 0:
                              alpha2 = $.Math_min(alpha2, $.div(bc1far, $.sub(bc1far, bc2far)));
                            case 12:
                              state = 0;
                          }
                        }
                    }
                  }
                  if ($.ltB(alpha2, alpha1)) return false;
                  s1.lerpSelf$2(s2, alpha1);
                  if (typeof alpha2 !== 'number') throw $.iae(alpha2);
                  s2.lerpSelf$2(s1, 1 - alpha2);
                  return true;
              }
            }
        }
      }
  }
 },
 painterSort$2: function(a, b) {
  return $.compareTo(b.get$z(), a.get$z());
 },
 get$painterSort: function() { return new $.BoundClosure2(this, 'painterSort$2'); },
 getNextParticleInPool$0: function() {
  var t1 = this._particleCount;
  if (typeof t1 !== 'number') return this.getNextParticleInPool$0$bailout(1, t1, 0);
  var t3 = this._particlePool;
  var t4 = t3.length;
  if (t1 < t4) {
    if (t1 !== (t1 | 0)) throw $.iae(t1);
    if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
    var particle = !(t3[t1] == null) ? t3[t1] : $.RenderableParticle$();
  } else {
    particle = $.RenderableParticle$();
    $.add$1(t3, particle);
  }
  t1 = this._particleCount;
  if (typeof t1 !== 'number') return this.getNextParticleInPool$0$bailout(2, t1, particle);
  this._particleCount = t1 + 1;
  return particle;
 },
 getNextParticleInPool$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      particle = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._particleCount;
    case 1:
      state = 0;
      var t3 = this._particlePool;
      if ($.ltB(t1, t3.length)) {
        t1 = this._particleCount;
        if (t1 !== (t1 | 0)) throw $.iae(t1);
        var t2 = t3.length;
        if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
        if (!(t3[t1] == null)) {
          t1 = this._particleCount;
          if (t1 !== (t1 | 0)) throw $.iae(t1);
          t2 = t3.length;
          if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
          var particle = t3[t1];
        } else particle = $.RenderableParticle$();
      } else {
        particle = $.RenderableParticle$();
        $.add$1(t3, particle);
      }
      t1 = this._particleCount;
    case 2:
      state = 0;
      this._particleCount = $.add(t1, 1);
      return particle;
  }
 },
 getNextLineInPool$0: function() {
  var t1 = this._lineCount;
  if (typeof t1 !== 'number') return this.getNextLineInPool$0$bailout(1, t1, 0);
  var t3 = this._linePool;
  var t4 = t3.length;
  if (t1 < t4) {
    if (t1 !== (t1 | 0)) throw $.iae(t1);
    if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
    var line = !(t3[t1] == null) ? t3[t1] : $.RenderableLine$();
  } else {
    line = $.RenderableLine$();
    $.add$1(t3, line);
  }
  t1 = this._lineCount;
  if (typeof t1 !== 'number') return this.getNextLineInPool$0$bailout(2, t1, line);
  this._lineCount = t1 + 1;
  return line;
 },
 getNextLineInPool$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      line = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._lineCount;
    case 1:
      state = 0;
      var t3 = this._linePool;
      if ($.ltB(t1, t3.length)) {
        t1 = this._lineCount;
        if (t1 !== (t1 | 0)) throw $.iae(t1);
        var t2 = t3.length;
        if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
        if (!(t3[t1] == null)) {
          t1 = this._lineCount;
          if (t1 !== (t1 | 0)) throw $.iae(t1);
          t2 = t3.length;
          if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
          var line = t3[t1];
        } else line = $.RenderableLine$();
      } else {
        line = $.RenderableLine$();
        $.add$1(t3, line);
      }
      t1 = this._lineCount;
    case 2:
      state = 0;
      this._lineCount = $.add(t1, 1);
      return line;
  }
 },
 getNextFace4InPool$0: function() {
  var t1 = this._face4Count;
  if (typeof t1 !== 'number') return this.getNextFace4InPool$0$bailout(1, t1, 0);
  var t3 = this._face4Pool;
  var t4 = t3.length;
  if (t1 < t4) {
    if (t1 !== (t1 | 0)) throw $.iae(t1);
    if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
    var face = !(t3[t1] == null) ? t3[t1] : $.RenderableFace4$();
  } else {
    face = $.RenderableFace4$();
    $.add$1(t3, face);
  }
  t1 = this._face4Count;
  if (typeof t1 !== 'number') return this.getNextFace4InPool$0$bailout(2, t1, face);
  this._face4Count = t1 + 1;
  return face;
 },
 getNextFace4InPool$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      face = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._face4Count;
    case 1:
      state = 0;
      var t3 = this._face4Pool;
      if ($.ltB(t1, t3.length)) {
        t1 = this._face4Count;
        if (t1 !== (t1 | 0)) throw $.iae(t1);
        var t2 = t3.length;
        if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
        if (!(t3[t1] == null)) {
          t1 = this._face4Count;
          if (t1 !== (t1 | 0)) throw $.iae(t1);
          t2 = t3.length;
          if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
          var face = t3[t1];
        } else face = $.RenderableFace4$();
      } else {
        face = $.RenderableFace4$();
        $.add$1(t3, face);
      }
      t1 = this._face4Count;
    case 2:
      state = 0;
      this._face4Count = $.add(t1, 1);
      return face;
  }
 },
 getNextFace3InPool$0: function() {
  var t1 = this._face3Count;
  if (typeof t1 !== 'number') return this.getNextFace3InPool$0$bailout(1, t1, 0);
  var t3 = this._face3Pool;
  var t4 = t3.length;
  if (t1 < t4) {
    if (t1 !== (t1 | 0)) throw $.iae(t1);
    if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
    var face = !(t3[t1] == null) ? t3[t1] : $.RenderableFace3$();
  } else {
    face = $.RenderableFace3$();
    $.add$1(t3, face);
  }
  t1 = this._face3Count;
  if (typeof t1 !== 'number') return this.getNextFace3InPool$0$bailout(2, t1, face);
  this._face3Count = t1 + 1;
  return face;
 },
 getNextFace3InPool$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      face = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._face3Count;
    case 1:
      state = 0;
      var t3 = this._face3Pool;
      if ($.ltB(t1, t3.length)) {
        t1 = this._face3Count;
        if (t1 !== (t1 | 0)) throw $.iae(t1);
        var t2 = t3.length;
        if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
        if (!(t3[t1] == null)) {
          t1 = this._face3Count;
          if (t1 !== (t1 | 0)) throw $.iae(t1);
          t2 = t3.length;
          if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
          var face = t3[t1];
        } else face = $.RenderableFace3$();
      } else {
        face = $.RenderableFace3$();
        $.add$1(t3, face);
      }
      t1 = this._face3Count;
    case 2:
      state = 0;
      this._face3Count = $.add(t1, 1);
      return face;
  }
 },
 getNextVertexInPool$0: function() {
  var t1 = this._vertexCount;
  if (typeof t1 !== 'number') return this.getNextVertexInPool$0$bailout(1, t1, 0);
  var t3 = this._vertexPool;
  var t4 = t3.length;
  if (t1 < t4) {
    if (t1 !== (t1 | 0)) throw $.iae(t1);
    if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
    var vertex = !(t3[t1] == null) ? t3[t1] : $.RenderableVertex$();
  } else {
    vertex = $.RenderableVertex$();
    $.add$1(t3, vertex);
  }
  t1 = this._vertexCount;
  if (typeof t1 !== 'number') return this.getNextVertexInPool$0$bailout(2, t1, vertex);
  this._vertexCount = t1 + 1;
  return vertex;
 },
 getNextVertexInPool$0$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      t1 = env0;
      break;
    case 2:
      t1 = env0;
      vertex = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._vertexCount;
    case 1:
      state = 0;
      var t3 = this._vertexPool;
      if ($.ltB(t1, t3.length)) {
        t1 = this._vertexCount;
        if (t1 !== (t1 | 0)) throw $.iae(t1);
        var t2 = t3.length;
        if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
        if (!(t3[t1] == null)) {
          t1 = this._vertexCount;
          if (t1 !== (t1 | 0)) throw $.iae(t1);
          t2 = t3.length;
          if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
          var vertex = t3[t1];
        } else vertex = $.RenderableVertex$();
      } else {
        vertex = $.RenderableVertex$();
        $.add$1(t3, vertex);
      }
      t1 = this._vertexCount;
    case 2:
      state = 0;
      this._vertexCount = $.add(t1, 1);
      return vertex;
  }
 },
 getNextObjectInPool$0: function() {
  var t1 = this._objectCount;
  var t2 = this._objectPool;
  if ($.ltB(t1, t2.length)) {
    t1 = this._objectCount;
    if (t1 !== (t1 | 0)) throw $.iae(t1);
    var t3 = t2.length;
    if (t1 < 0 || t1 >= t3) throw $.ioore(t1);
    if (!(t2[t1] == null)) {
      t1 = this._objectCount;
      if (t1 !== (t1 | 0)) throw $.iae(t1);
      t3 = t2.length;
      if (t1 < 0 || t1 >= t3) throw $.ioore(t1);
      var object = t2[t1];
    } else object = $.RenderableObject$();
  } else {
    object = $.RenderableObject$();
    $.add$1(t2, object);
  }
  this._objectCount = $.add(this._objectCount, 1);
  return object;
 },
 projectScene$3: function(scene, camera, sort) {
  var near = camera.get$near();
  if (typeof near !== 'number') return this.projectScene$3$bailout(1, scene, camera, sort, near, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var far = camera.get$far();
  if (typeof far !== 'number') return this.projectScene$3$bailout(2, scene, camera, sort, near, far, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  this._face3Count = 0;
  this._face4Count = 0;
  this._lineCount = 0;
  this._particleCount = 0;
  var t3 = [];
  this._renderData.set$elements(t3);
  camera.get$parent() == null && $.add$1(scene, camera);
  scene.updateMatrixWorld$0();
  camera.get$matrixWorldInverse().getInverse$1(camera.get$matrixWorld());
  var t1 = this._projScreenMatrix;
  t1.multiply$2(camera.get$projectionMatrix(), camera.get$matrixWorldInverse());
  this._frustum.setFromMatrix$1(t1);
  this._renderData = this.projectGraph$2(scene, false);
  var ol = $.get$length(this._renderData.get$objects());
  if (typeof ol !== 'number') return this.projectScene$3$bailout(3, camera, sort, near, far, t1, ol, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  for (var t2 = this._vertexPool, t3 = this._projScreenobjectMatrixWorld, t4 = this._clippedVertex1PositionScreen, t5 = this._clippedVertex2PositionScreen, v4 = null, vl = null, faceVertexUvs = null, u = null, faceVertexNormals = null, _face = null, objectMatrixWorld = null, v = null, objectMaterial = null, v3 = null, c = null, objectMatrixWorldRotation = null, cl = null, object = null, geometry = null, face = null, f = null, ul = null, n = null, fl = null, vertices = null, nl = null, v1 = null, geometryMaterials = null, faces = null, normal = null, v2 = null, o = 0; o < ol; ++o) {
    object = $.index(this._renderData.get$objects(), o).get$object();
    objectMatrixWorld = object.get$matrixWorld();
    objectMaterial = object.get$material();
    this._vertexCount = 0;
    if (typeof object === 'object' && object !== null && !!object.is$Mesh) {
      geometry = object.get$geometry();
      geometryMaterials = object.get$geometry().get$materials();
      if (typeof geometryMaterials !== 'string' && (typeof geometryMaterials !== 'object' || geometryMaterials === null || (geometryMaterials.constructor !== Array && !geometryMaterials.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(4, camera, sort, face, near, far, ul, t1, n, nl, v1, normal, v2, o, t2, objectMatrixWorld, objectMaterial, geometry, geometryMaterials, t3, ol, v4, t4, u, t5, faceVertexNormals, _face, v3, c, object, cl, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      vertices = geometry.get$vertices();
      if (typeof vertices !== 'string' && (typeof vertices !== 'object' || vertices === null || (vertices.constructor !== Array && !vertices.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(5, camera, sort, face, near, far, ul, t1, n, nl, v1, normal, v2, o, t2, objectMatrixWorld, objectMaterial, geometry, geometryMaterials, vertices, t3, ol, v4, t4, u, t5, faceVertexNormals, _face, v3, c, object, cl, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      faces = geometry.get$faces();
      if (typeof faces !== 'string' && (typeof faces !== 'object' || faces === null || (faces.constructor !== Array && !faces.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(6, camera, sort, face, near, far, ul, t1, n, nl, v1, normal, v2, o, t2, objectMatrixWorld, objectMaterial, geometry, geometryMaterials, vertices, faces, t3, ol, v4, t4, u, t5, faceVertexNormals, _face, v3, c, object, cl, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      faceVertexUvs = geometry.get$faceVertexUvs();
      if (typeof faceVertexUvs !== 'string' && (typeof faceVertexUvs !== 'object' || faceVertexUvs === null || (faceVertexUvs.constructor !== Array && !faceVertexUvs.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(7, camera, sort, face, near, far, ul, t1, n, nl, v1, normal, v2, o, t2, objectMatrixWorld, objectMaterial, geometry, geometryMaterials, vertices, faces, faceVertexUvs, t3, v4, ol, u, t5, faceVertexNormals, _face, t4, v3, c, object, cl, 0, 0, 0, 0, 0, 0, 0, 0);
      objectMatrixWorldRotation = object.matrixRotationWorld.extractRotation$1(objectMatrixWorld);
      vl = vertices.length;
      for (v = 0; v < vl; ++v) {
        this._vertex = this.getNextVertexInPool$0();
        var t6 = this._vertex.get$positionWorld();
        var t7 = vertices.length;
        if (v < 0 || v >= t7) throw $.ioore(v);
        t6.copy$1(vertices[v].get$position());
        objectMatrixWorld.multiplyVector3$1(this._vertex.get$positionWorld());
        this._vertex.get$positionScreen().copy$1(this._vertex.get$positionWorld());
        t1.multiplyVector4$1(this._vertex.get$positionScreen());
        t6 = this._vertex.get$positionScreen();
        t6.set$x($.div(t6.get$x(), this._vertex.get$positionScreen().get$w()));
        t6 = this._vertex.get$positionScreen();
        t6.set$y($.div(t6.get$y(), this._vertex.get$positionScreen().get$w()));
        t6 = $.gtB(this._vertex.get$positionScreen().get$z(), near) && $.ltB(this._vertex.get$positionScreen().get$z(), far);
        this._vertex.set$visible(t6);
      }
      fl = faces.length;
      for (t6 = !object.doubleSided, t7 = object.flipSided, f = 0; f < fl; ++f) {
        var t8 = faces.length;
        if (f < 0 || f >= t8) throw $.ioore(f);
        face = faces[f];
        if (typeof face === 'object' && face !== null && !!face.is$Face3) {
          t8 = face.get$a();
          if (t8 !== (t8 | 0)) throw $.iae(t8);
          var t9 = t2.length;
          if (t8 < 0 || t8 >= t9) throw $.ioore(t8);
          v1 = t2[t8];
          t8 = face.get$b();
          if (t8 !== (t8 | 0)) throw $.iae(t8);
          var t10 = t2.length;
          if (t8 < 0 || t8 >= t10) throw $.ioore(t8);
          v2 = t2[t8];
          t8 = face.get$c();
          if (t8 !== (t8 | 0)) throw $.iae(t8);
          var t11 = t2.length;
          if (t8 < 0 || t8 >= t11) throw $.ioore(t8);
          v3 = t2[t8];
          if (v1.get$visible() === true) {
            if (v2.get$visible() === true) {
              if (v3.get$visible() === true) {
                t8 = object.doubleSided || !(t7 === $.lt($.sub($.mul($.sub(v3.get$positionScreen().get$x(), v1.get$positionScreen().get$x()), $.sub(v2.get$positionScreen().get$y(), v1.get$positionScreen().get$y())), $.mul($.sub(v3.get$positionScreen().get$y(), v1.get$positionScreen().get$y()), $.sub(v2.get$positionScreen().get$x(), v1.get$positionScreen().get$x()))), 0));
              } else t8 = false;
            } else t8 = false;
          } else t8 = false;
          if (t8) {
            _face = this.getNextFace3InPool$0();
            _face.get$v1().copy$1(v1);
            _face.get$v2().copy$1(v2);
            _face.get$v3().copy$1(v3);
          } else continue;
        } else {
          if (typeof face === 'object' && face !== null && !!face.is$Face4) {
            t8 = face.get$a();
            if (t8 !== (t8 | 0)) throw $.iae(t8);
            t9 = t2.length;
            if (t8 < 0 || t8 >= t9) throw $.ioore(t8);
            v1 = t2[t8];
            t8 = face.get$b();
            if (t8 !== (t8 | 0)) throw $.iae(t8);
            t10 = t2.length;
            if (t8 < 0 || t8 >= t10) throw $.ioore(t8);
            v2 = t2[t8];
            t8 = face.get$c();
            if (t8 !== (t8 | 0)) throw $.iae(t8);
            t11 = t2.length;
            if (t8 < 0 || t8 >= t11) throw $.ioore(t8);
            v3 = t2[t8];
            t8 = face.get$d();
            if (t8 !== (t8 | 0)) throw $.iae(t8);
            var t12 = t2.length;
            if (t8 < 0 || t8 >= t12) throw $.ioore(t8);
            v4 = t2[t8];
            var bool1 = $.ltB($.sub($.mul($.sub(v4.get$positionScreen().get$x(), v1.get$positionScreen().get$x()), $.sub(v2.get$positionScreen().get$y(), v1.get$positionScreen().get$y())), $.mul($.sub(v4.get$positionScreen().get$y(), v1.get$positionScreen().get$y()), $.sub(v2.get$positionScreen().get$x(), v1.get$positionScreen().get$x()))), 0);
            var bool2 = $.ltB($.sub($.mul($.sub(v2.get$positionScreen().get$x(), v3.get$positionScreen().get$x()), $.sub(v4.get$positionScreen().get$y(), v3.get$positionScreen().get$y())), $.mul($.sub(v2.get$positionScreen().get$y(), v3.get$positionScreen().get$y()), $.sub(v4.get$positionScreen().get$x(), v3.get$positionScreen().get$x()))), 0);
            var bool3 = bool1 || bool2;
            if (v1.get$visible() === true) {
              if (v2.get$visible() === true) {
                if (v3.get$visible() === true) {
                  if (v4.get$visible() === true) {
                    t8 = object.doubleSided || !(t7 === bool3);
                  } else t8 = false;
                } else t8 = false;
              } else t8 = false;
            } else t8 = false;
            if (t8) {
              _face = this.getNextFace4InPool$0();
              _face.get$v1().copy$1(v1);
              _face.get$v2().copy$1(v2);
              _face.get$v3().copy$1(v3);
              _face.get$v4().copy$1(v4);
            } else continue;
          }
        }
        _face.get$normalWorld().copy$1(face.get$normal());
        objectMatrixWorldRotation.multiplyVector3$1(_face.get$normalWorld());
        _face.get$centroidWorld().copy$1(face.get$centroid());
        objectMatrixWorld.multiplyVector3$1(_face.get$centroidWorld());
        _face.get$centroidScreen().copy$1(_face.get$centroidWorld());
        t1.multiplyVector3$1(_face.get$centroidScreen());
        faceVertexNormals = face.get$vertexNormals();
        nl = $.get$length(faceVertexNormals);
        for (n = 0; $.ltB(n, nl); ++n) {
          normal = $.index(_face.get$vertexNormalsWorld(), n);
          normal.copy$1($.index(faceVertexNormals, n));
          objectMatrixWorldRotation.multiplyVector3$1(normal);
        }
        cl = faceVertexUvs.length;
        for (c = 0; c < cl; ++c) {
          t8 = faceVertexUvs.length;
          if (c < 0 || c >= t8) throw $.ioore(c);
          t9 = faceVertexUvs[c];
          if (typeof t9 !== 'string' && (typeof t9 !== 'object' || t9 === null || (t9.constructor !== Array && !t9.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(8, c, camera, sort, near, far, t1, ul, face, n, o, normal, v4, _face, t2, objectMatrixWorld, t9, v2, v1, objectMaterial, v3, t7, geometry, geometryMaterials, fl, vertices, faceVertexUvs, t3, objectMatrixWorldRotation, ol, vl, cl, faceVertexNormals, t6, nl, faces, t5, u, f, t4, v, object);
          t11 = t9.length;
          if (f < 0 || f >= t11) throw $.ioore(f);
          var uvs = t9[f];
          if (typeof uvs !== 'string' && (typeof uvs !== 'object' || uvs === null || (uvs.constructor !== Array && !uvs.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(9, c, camera, sort, near, far, t1, ul, face, n, o, normal, v4, _face, t2, objectMatrixWorld, v2, uvs, v1, objectMaterial, v3, t7, geometry, geometryMaterials, fl, vertices, faceVertexUvs, t3, objectMatrixWorldRotation, ol, vl, cl, faceVertexNormals, t6, nl, faces, t5, u, f, t4, v, object);
          ul = uvs.length;
          for (u = 0; u < ul; ++u) {
            var faceUVs = $.index(_face.get$uvs(), c);
            t8 = uvs.length;
            if (u < 0 || u >= t8) throw $.ioore(u);
            $.add$1(faceUVs, uvs[u]);
          }
        }
        _face.set$material(objectMaterial);
        if (!(face.get$materialIndex() == null)) {
          t8 = face.get$materialIndex();
          if (t8 !== (t8 | 0)) throw $.iae(t8);
          t9 = geometryMaterials.length;
          if (t8 < 0 || t8 >= t9) throw $.ioore(t8);
          t8 = geometryMaterials[t8];
        } else t8 = null;
        _face.set$faceMaterial(t8);
        _face.set$z(_face.get$centroidScreen().get$z());
        $.add$1(this._renderData.get$elements(), _face);
      }
      object = object;
    } else {
      if (typeof object === 'object' && object !== null && !!object.is$Line) {
        t3.multiply$2(t1, objectMatrixWorld);
        vertices = object.get$geometry().get$vertices();
        if (typeof vertices !== 'string' && (typeof vertices !== 'object' || vertices === null || (vertices.constructor !== Array && !vertices.is$JavaScriptIndexingBehavior()))) return this.projectScene$3$bailout(10, camera, geometry, face, f, ul, n, fl, far, nl, near, sort, geometryMaterials, faces, normal, v2, o, t1, t2, objectMatrixWorld, objectMaterial, vertices, t3, ol, v4, faceVertexUvs, t4, t5, u, faceVertexNormals, _face, v3, c, objectMatrixWorldRotation, cl, object, 0, 0, 0, 0, 0, 0);
        v1 = this.getNextVertexInPool$0();
        t7 = v1.get$positionScreen();
        t8 = vertices.length;
        if (0 >= t8) throw $.ioore(0);
        t7.copy$1(vertices[0].get$position());
        t3.multiplyVector4$1(v1.get$positionScreen());
        vl = vertices.length;
        for (v = 1; v < vl; ++v) {
          v1 = this.getNextVertexInPool$0();
          t6 = v1.get$positionScreen();
          t7 = vertices.length;
          if (v < 0 || v >= t7) throw $.ioore(v);
          t6.copy$1(vertices[v].get$position());
          t3.multiplyVector4$1(v1.get$positionScreen());
          t6 = $.sub(this._vertexCount, 2);
          if (t6 !== (t6 | 0)) throw $.iae(t6);
          t8 = t2.length;
          if (t6 < 0 || t6 >= t8) throw $.ioore(t6);
          v2 = t2[t6];
          t4.copy$1(v1.get$positionScreen());
          t5.copy$1(v2.get$positionScreen());
          if (this.clipLine$2(t4, t5) === true) {
            t6 = t4.get$w();
            if (typeof t6 !== 'number') throw $.iae(t6);
            t4.multiplyScalar$1(1 / t6);
            t7 = t5.get$w();
            if (typeof t7 !== 'number') throw $.iae(t7);
            t5.multiplyScalar$1(1 / t7);
            this._line = this.getNextLineInPool$0();
            this._line.get$v1().get$positionScreen().copy$1(t4);
            this._line.get$v2().get$positionScreen().copy$1(t5);
            t8 = $.Math_max(t4.get$z(), t5.get$z());
            this._line.set$z(t8);
            this._line.set$material(objectMaterial);
            $.add$1(this._renderData.get$elements(), this._line);
          }
        }
        object = object;
      }
    }
  }
  ol = $.get$length(this._renderData.get$sprites());
  if (typeof ol !== 'number') return this.projectScene$3$bailout(11, object, camera, sort, objectMatrixWorld, t1, ol, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  for (t2 = this._vector4, o = 0; o < ol; ++o) {
    object = $.index(this._renderData.get$sprites(), o).get$object();
    objectMatrixWorld = object.get$matrixWorld();
    if (typeof object === 'object' && object !== null && !!object.is$Particle) {
      t2.setValues$4(objectMatrixWorld.get$n14(), objectMatrixWorld.get$n24(), objectMatrixWorld.get$n34(), 1);
      t1.multiplyVector4$1(t2);
      t2.set$z($.div(t2.get$z(), t2.get$w()));
      if ($.gtB(t2.get$z(), 0) && $.ltB(t2.get$z(), 1)) {
        this._particle = this.getNextParticleInPool$0();
        t3 = $.div(t2.get$x(), t2.get$w());
        this._particle.set$x(t3);
        t3 = $.div(t2.get$y(), t2.get$w());
        this._particle.set$y(t3);
        t3 = t2.get$z();
        this._particle.set$z(t3);
        t3 = object.rotation.get$z();
        this._particle.set$rotation(t3);
        t3 = object.scale;
        t4 = $.mul(t3.get$x(), $.abs($.sub(this._particle.get$x(), $.div($.add(t2.get$x(), camera.get$projectionMatrix().get$n11()), $.add(t2.get$w(), camera.get$projectionMatrix().get$n14())))));
        this._particle.get$scale().set$x(t4);
        t4 = $.mul(t3.get$y(), $.abs($.sub(this._particle.get$y(), $.div($.add(t2.get$y(), camera.get$projectionMatrix().get$n22()), $.add(t2.get$w(), camera.get$projectionMatrix().get$n24())))));
        this._particle.get$scale().set$y(t4);
        t4 = object.material;
        this._particle.set$material(t4);
        $.add$1(this._renderData.get$elements(), this._particle);
      }
    }
  }
  sort === true && $.sort(this._renderData.get$elements(), this.get$painterSort());
  return this._renderData;
 },
 projectScene$3$bailout: function(state, env0, env1, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11, env12, env13, env14, env15, env16, env17, env18, env19, env20, env21, env22, env23, env24, env25, env26, env27, env28, env29, env30, env31, env32, env33, env34, env35, env36, env37, env38, env39, env40) {
  switch (state) {
    case 1:
      var scene = env0;
      var camera = env1;
      var sort = env2;
      near = env3;
      break;
    case 2:
      scene = env0;
      camera = env1;
      sort = env2;
      near = env3;
      far = env4;
      break;
    case 3:
      camera = env0;
      sort = env1;
      near = env2;
      far = env3;
      t1 = env4;
      ol = env5;
      break;
    case 4:
      camera = env0;
      sort = env1;
      face = env2;
      near = env3;
      far = env4;
      ul = env5;
      t1 = env6;
      n = env7;
      nl = env8;
      v1 = env9;
      normal = env10;
      v2 = env11;
      o = env12;
      t2 = env13;
      objectMatrixWorld = env14;
      objectMaterial = env15;
      geometry = env16;
      geometryMaterials = env17;
      t3 = env18;
      ol = env19;
      v4 = env20;
      t4 = env21;
      u = env22;
      t5 = env23;
      faceVertexNormals = env24;
      _face = env25;
      v3 = env26;
      c = env27;
      object = env28;
      cl = env29;
      break;
    case 5:
      camera = env0;
      sort = env1;
      face = env2;
      near = env3;
      far = env4;
      ul = env5;
      t1 = env6;
      n = env7;
      nl = env8;
      v1 = env9;
      normal = env10;
      v2 = env11;
      o = env12;
      t2 = env13;
      objectMatrixWorld = env14;
      objectMaterial = env15;
      geometry = env16;
      geometryMaterials = env17;
      vertices = env18;
      t3 = env19;
      ol = env20;
      v4 = env21;
      t4 = env22;
      u = env23;
      t5 = env24;
      faceVertexNormals = env25;
      _face = env26;
      v3 = env27;
      c = env28;
      object = env29;
      cl = env30;
      break;
    case 6:
      camera = env0;
      sort = env1;
      face = env2;
      near = env3;
      far = env4;
      ul = env5;
      t1 = env6;
      n = env7;
      nl = env8;
      v1 = env9;
      normal = env10;
      v2 = env11;
      o = env12;
      t2 = env13;
      objectMatrixWorld = env14;
      objectMaterial = env15;
      geometry = env16;
      geometryMaterials = env17;
      vertices = env18;
      faces = env19;
      t3 = env20;
      ol = env21;
      v4 = env22;
      t4 = env23;
      u = env24;
      t5 = env25;
      faceVertexNormals = env26;
      _face = env27;
      v3 = env28;
      c = env29;
      object = env30;
      cl = env31;
      break;
    case 7:
      camera = env0;
      sort = env1;
      face = env2;
      near = env3;
      far = env4;
      ul = env5;
      t1 = env6;
      n = env7;
      nl = env8;
      v1 = env9;
      normal = env10;
      v2 = env11;
      o = env12;
      t2 = env13;
      objectMatrixWorld = env14;
      objectMaterial = env15;
      geometry = env16;
      geometryMaterials = env17;
      vertices = env18;
      faces = env19;
      faceVertexUvs = env20;
      t3 = env21;
      v4 = env22;
      ol = env23;
      u = env24;
      t5 = env25;
      faceVertexNormals = env26;
      _face = env27;
      t4 = env28;
      v3 = env29;
      c = env30;
      object = env31;
      cl = env32;
      break;
    case 8:
      c = env0;
      camera = env1;
      sort = env2;
      near = env3;
      far = env4;
      t1 = env5;
      ul = env6;
      face = env7;
      n = env8;
      o = env9;
      normal = env10;
      v4 = env11;
      _face = env12;
      t2 = env13;
      objectMatrixWorld = env14;
      t8 = env15;
      v2 = env16;
      v1 = env17;
      objectMaterial = env18;
      v3 = env19;
      t7 = env20;
      geometry = env21;
      geometryMaterials = env22;
      fl = env23;
      vertices = env24;
      faceVertexUvs = env25;
      t3 = env26;
      objectMatrixWorldRotation = env27;
      ol = env28;
      vl = env29;
      cl = env30;
      faceVertexNormals = env31;
      t6 = env32;
      nl = env33;
      faces = env34;
      t5 = env35;
      u = env36;
      f = env37;
      t4 = env38;
      v = env39;
      object = env40;
      break;
    case 9:
      c = env0;
      camera = env1;
      sort = env2;
      near = env3;
      far = env4;
      t1 = env5;
      ul = env6;
      face = env7;
      n = env8;
      o = env9;
      normal = env10;
      v4 = env11;
      _face = env12;
      t2 = env13;
      objectMatrixWorld = env14;
      v2 = env15;
      uvs = env16;
      v1 = env17;
      objectMaterial = env18;
      v3 = env19;
      t7 = env20;
      geometry = env21;
      geometryMaterials = env22;
      fl = env23;
      vertices = env24;
      faceVertexUvs = env25;
      t3 = env26;
      objectMatrixWorldRotation = env27;
      ol = env28;
      vl = env29;
      cl = env30;
      faceVertexNormals = env31;
      t6 = env32;
      nl = env33;
      faces = env34;
      t5 = env35;
      u = env36;
      f = env37;
      t4 = env38;
      v = env39;
      object = env40;
      break;
    case 10:
      camera = env0;
      geometry = env1;
      face = env2;
      f = env3;
      ul = env4;
      n = env5;
      fl = env6;
      far = env7;
      nl = env8;
      near = env9;
      sort = env10;
      geometryMaterials = env11;
      faces = env12;
      normal = env13;
      v2 = env14;
      o = env15;
      t1 = env16;
      t2 = env17;
      objectMatrixWorld = env18;
      objectMaterial = env19;
      vertices = env20;
      t3 = env21;
      ol = env22;
      v4 = env23;
      faceVertexUvs = env24;
      t4 = env25;
      t5 = env26;
      u = env27;
      faceVertexNormals = env28;
      _face = env29;
      v3 = env30;
      c = env31;
      objectMatrixWorldRotation = env32;
      cl = env33;
      object = env34;
      break;
    case 11:
      object = env0;
      camera = env1;
      sort = env2;
      objectMatrixWorld = env3;
      t1 = env4;
      ol = env5;
      break;
  }
  switch (state) {
    case 0:
      var near = camera.get$near();
    case 1:
      state = 0;
      var far = camera.get$far();
    case 2:
      state = 0;
      this._face3Count = 0;
      this._face4Count = 0;
      this._lineCount = 0;
      this._particleCount = 0;
      var t3 = [];
      this._renderData.set$elements(t3);
      camera.get$parent() == null && $.add$1(scene, camera);
      scene.updateMatrixWorld$0();
      camera.get$matrixWorldInverse().getInverse$1(camera.get$matrixWorld());
      var t1 = this._projScreenMatrix;
      t1.multiply$2(camera.get$projectionMatrix(), camera.get$matrixWorldInverse());
      this._frustum.setFromMatrix$1(t1);
      this._renderData = this.projectGraph$2(scene, false);
      var ol = $.get$length(this._renderData.get$objects());
    case 3:
      state = 0;
      var t2 = this._vertexPool;
      t3 = this._projScreenobjectMatrixWorld;
      var t4 = this._clippedVertex1PositionScreen;
      var t5 = this._clippedVertex2PositionScreen;
      var v4 = null;
      var vl = null;
      var faceVertexUvs = null;
      var u = null;
      var faceVertexNormals = null;
      var _face = null;
      var objectMatrixWorld = null;
      var v = null;
      var objectMaterial = null;
      var v3 = null;
      var c = null;
      var objectMatrixWorldRotation = null;
      var cl = null;
      var object = null;
      var geometry = null;
      var face = null;
      var f = null;
      var ul = null;
      var n = null;
      var fl = null;
      var vertices = null;
      var nl = null;
      var v1 = null;
      var geometryMaterials = null;
      var faces = null;
      var normal = null;
      var v2 = null;
      var o = 0;
    default:
      L0: while (true) {
        switch (state) {
          case 0:
            if (!$.ltB(o, ol)) break L0;
            object = $.index(this._renderData.get$objects(), o).get$object();
            objectMatrixWorld = object.get$matrixWorld();
            objectMaterial = object.get$material();
            this._vertexCount = 0;
          default:
            if (state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || (state == 0 && ((typeof object === 'object' && object !== null) && !!object.is$Mesh))) {
              switch (state) {
                case 0:
                  geometry = object.get$geometry();
                  geometryMaterials = object.get$geometry().get$materials();
                case 4:
                  state = 0;
                  vertices = geometry.get$vertices();
                case 5:
                  state = 0;
                  faces = geometry.get$faces();
                case 6:
                  state = 0;
                  faceVertexUvs = geometry.get$faceVertexUvs();
                case 7:
                  state = 0;
                  objectMatrixWorldRotation = object.matrixRotationWorld.extractRotation$1(objectMatrixWorld);
                  vl = $.get$length(vertices);
                  for (v = 0; $.ltB(v, vl); ++v) {
                    this._vertex = this.getNextVertexInPool$0();
                    this._vertex.get$positionWorld().copy$1($.index(vertices, v).get$position());
                    objectMatrixWorld.multiplyVector3$1(this._vertex.get$positionWorld());
                    this._vertex.get$positionScreen().copy$1(this._vertex.get$positionWorld());
                    t1.multiplyVector4$1(this._vertex.get$positionScreen());
                    var t6 = this._vertex.get$positionScreen();
                    t6.set$x($.div(t6.get$x(), this._vertex.get$positionScreen().get$w()));
                    t6 = this._vertex.get$positionScreen();
                    t6.set$y($.div(t6.get$y(), this._vertex.get$positionScreen().get$w()));
                    t6 = $.gtB(this._vertex.get$positionScreen().get$z(), near) && $.ltB(this._vertex.get$positionScreen().get$z(), far);
                    this._vertex.set$visible(t6);
                  }
                  fl = $.get$length(faces);
                  t6 = object.doubleSided !== true;
                  var t7 = object.flipSided;
                  f = 0;
                default:
                  L1: while (true) {
                    switch (state) {
                      case 0:
                        if (!$.ltB(f, fl)) break L1;
                      default:
                        c$1:{
                          switch (state) {
                            case 0:
                              face = $.index(faces, f);
                              if (typeof face === 'object' && face !== null && !!face.is$Face3) {
                                var t8 = face.get$a();
                                if (t8 !== (t8 | 0)) throw $.iae(t8);
                                var t9 = t2.length;
                                if (t8 < 0 || t8 >= t9) throw $.ioore(t8);
                                v1 = t2[t8];
                                t8 = face.get$b();
                                if (t8 !== (t8 | 0)) throw $.iae(t8);
                                var t10 = t2.length;
                                if (t8 < 0 || t8 >= t10) throw $.ioore(t8);
                                v2 = t2[t8];
                                t8 = face.get$c();
                                if (t8 !== (t8 | 0)) throw $.iae(t8);
                                var t11 = t2.length;
                                if (t8 < 0 || t8 >= t11) throw $.ioore(t8);
                                v3 = t2[t8];
                                if (v1.get$visible() === true) {
                                  if (v2.get$visible() === true) {
                                    if (v3.get$visible() === true) {
                                      t8 = object.doubleSided === true || !(t7 === $.lt($.sub($.mul($.sub(v3.get$positionScreen().get$x(), v1.get$positionScreen().get$x()), $.sub(v2.get$positionScreen().get$y(), v1.get$positionScreen().get$y())), $.mul($.sub(v3.get$positionScreen().get$y(), v1.get$positionScreen().get$y()), $.sub(v2.get$positionScreen().get$x(), v1.get$positionScreen().get$x()))), 0));
                                    } else t8 = false;
                                  } else t8 = false;
                                } else t8 = false;
                                if (t8) {
                                  _face = this.getNextFace3InPool$0();
                                  _face.get$v1().copy$1(v1);
                                  _face.get$v2().copy$1(v2);
                                  _face.get$v3().copy$1(v3);
                                } else break c$1;
                              } else {
                                if (typeof face === 'object' && face !== null && !!face.is$Face4) {
                                  t8 = face.get$a();
                                  if (t8 !== (t8 | 0)) throw $.iae(t8);
                                  t9 = t2.length;
                                  if (t8 < 0 || t8 >= t9) throw $.ioore(t8);
                                  v1 = t2[t8];
                                  t8 = face.get$b();
                                  if (t8 !== (t8 | 0)) throw $.iae(t8);
                                  t10 = t2.length;
                                  if (t8 < 0 || t8 >= t10) throw $.ioore(t8);
                                  v2 = t2[t8];
                                  t8 = face.get$c();
                                  if (t8 !== (t8 | 0)) throw $.iae(t8);
                                  t11 = t2.length;
                                  if (t8 < 0 || t8 >= t11) throw $.ioore(t8);
                                  v3 = t2[t8];
                                  t8 = face.get$d();
                                  if (t8 !== (t8 | 0)) throw $.iae(t8);
                                  var t12 = t2.length;
                                  if (t8 < 0 || t8 >= t12) throw $.ioore(t8);
                                  v4 = t2[t8];
                                  var bool1 = $.ltB($.sub($.mul($.sub(v4.get$positionScreen().get$x(), v1.get$positionScreen().get$x()), $.sub(v2.get$positionScreen().get$y(), v1.get$positionScreen().get$y())), $.mul($.sub(v4.get$positionScreen().get$y(), v1.get$positionScreen().get$y()), $.sub(v2.get$positionScreen().get$x(), v1.get$positionScreen().get$x()))), 0);
                                  var bool2 = $.ltB($.sub($.mul($.sub(v2.get$positionScreen().get$x(), v3.get$positionScreen().get$x()), $.sub(v4.get$positionScreen().get$y(), v3.get$positionScreen().get$y())), $.mul($.sub(v2.get$positionScreen().get$y(), v3.get$positionScreen().get$y()), $.sub(v4.get$positionScreen().get$x(), v3.get$positionScreen().get$x()))), 0);
                                  var bool3 = bool1 || bool2;
                                  if (v1.get$visible() === true) {
                                    if (v2.get$visible() === true) {
                                      if (v3.get$visible() === true) {
                                        if (v4.get$visible() === true) {
                                          t8 = object.doubleSided === true || !(t7 === bool3);
                                        } else t8 = false;
                                      } else t8 = false;
                                    } else t8 = false;
                                  } else t8 = false;
                                  if (t8) {
                                    _face = this.getNextFace4InPool$0();
                                    _face.get$v1().copy$1(v1);
                                    _face.get$v2().copy$1(v2);
                                    _face.get$v3().copy$1(v3);
                                    _face.get$v4().copy$1(v4);
                                  } else break c$1;
                                }
                              }
                              _face.get$normalWorld().copy$1(face.get$normal());
                              objectMatrixWorldRotation.multiplyVector3$1(_face.get$normalWorld());
                              _face.get$centroidWorld().copy$1(face.get$centroid());
                              objectMatrixWorld.multiplyVector3$1(_face.get$centroidWorld());
                              _face.get$centroidScreen().copy$1(_face.get$centroidWorld());
                              t1.multiplyVector3$1(_face.get$centroidScreen());
                              faceVertexNormals = face.get$vertexNormals();
                              nl = $.get$length(faceVertexNormals);
                              for (n = 0; $.ltB(n, nl); ++n) {
                                normal = $.index(_face.get$vertexNormalsWorld(), n);
                                normal.copy$1($.index(faceVertexNormals, n));
                                objectMatrixWorldRotation.multiplyVector3$1(normal);
                              }
                              cl = $.get$length(faceVertexUvs);
                              c = 0;
                            default:
                              L2: while (true) {
                                switch (state) {
                                  case 0:
                                    if (!$.ltB(c, cl)) break L2;
                                  default:
                                    c$2:{
                                      switch (state) {
                                        case 0:
                                          t8 = $.index(faceVertexUvs, c);
                                        case 8:
                                          state = 0;
                                          var uvs = $.index(t8, f);
                                        case 9:
                                          state = 0;
                                          if (uvs == null) break c$2;
                                          ul = $.get$length(uvs);
                                          for (u = 0; $.ltB(u, ul); ++u) {
                                            $.add$1($.index(_face.get$uvs(), c), $.index(uvs, u));
                                          }
                                      }
                                    }
                                    ++c;
                                }
                              }
                              _face.set$material(objectMaterial);
                              _face.set$faceMaterial(!(face.get$materialIndex() == null) ? $.index(geometryMaterials, face.get$materialIndex()) : null);
                              _face.set$z(_face.get$centroidScreen().get$z());
                              $.add$1(this._renderData.get$elements(), _face);
                          }
                        }
                        ++f;
                    }
                  }
                  object = object;
              }
            } else {
              switch (state) {
                case 0:
                case 10:
                  if (state == 10 || (state == 0 && ((typeof object === 'object' && object !== null) && !!object.is$Line))) {
                    switch (state) {
                      case 0:
                        t3.multiply$2(t1, objectMatrixWorld);
                        vertices = object.get$geometry().get$vertices();
                      case 10:
                        state = 0;
                        v1 = this.getNextVertexInPool$0();
                        v1.get$positionScreen().copy$1($.index(vertices, 0).get$position());
                        t3.multiplyVector4$1(v1.get$positionScreen());
                        vl = $.get$length(vertices);
                        for (v = 1; $.ltB(v, vl); ++v) {
                          v1 = this.getNextVertexInPool$0();
                          v1.get$positionScreen().copy$1($.index(vertices, v).get$position());
                          t3.multiplyVector4$1(v1.get$positionScreen());
                          t6 = $.sub(this._vertexCount, 2);
                          if (t6 !== (t6 | 0)) throw $.iae(t6);
                          t7 = t2.length;
                          if (t6 < 0 || t6 >= t7) throw $.ioore(t6);
                          v2 = t2[t6];
                          t4.copy$1(v1.get$positionScreen());
                          t5.copy$1(v2.get$positionScreen());
                          if (this.clipLine$2(t4, t5) === true) {
                            t6 = t4.get$w();
                            if (typeof t6 !== 'number') throw $.iae(t6);
                            t4.multiplyScalar$1(1 / t6);
                            t7 = t5.get$w();
                            if (typeof t7 !== 'number') throw $.iae(t7);
                            t5.multiplyScalar$1(1 / t7);
                            this._line = this.getNextLineInPool$0();
                            this._line.get$v1().get$positionScreen().copy$1(t4);
                            this._line.get$v2().get$positionScreen().copy$1(t5);
                            t8 = $.Math_max(t4.get$z(), t5.get$z());
                            this._line.set$z(t8);
                            this._line.set$material(objectMaterial);
                            $.add$1(this._renderData.get$elements(), this._line);
                          }
                        }
                        object = object;
                    }
                  }
              }
            }
            ++o;
        }
      }
      ol = $.get$length(this._renderData.get$sprites());
    case 11:
      state = 0;
      for (t2 = this._vector4, o = 0; $.ltB(o, ol); ++o) {
        object = $.index(this._renderData.get$sprites(), o).get$object();
        objectMatrixWorld = object.get$matrixWorld();
        if (typeof object === 'object' && object !== null && !!object.is$Particle) {
          t2.setValues$4(objectMatrixWorld.get$n14(), objectMatrixWorld.get$n24(), objectMatrixWorld.get$n34(), 1);
          t1.multiplyVector4$1(t2);
          t2.set$z($.div(t2.get$z(), t2.get$w()));
          if ($.gtB(t2.get$z(), 0) && $.ltB(t2.get$z(), 1)) {
            this._particle = this.getNextParticleInPool$0();
            t3 = $.div(t2.get$x(), t2.get$w());
            this._particle.set$x(t3);
            t3 = $.div(t2.get$y(), t2.get$w());
            this._particle.set$y(t3);
            t3 = t2.get$z();
            this._particle.set$z(t3);
            t3 = object.rotation.get$z();
            this._particle.set$rotation(t3);
            t3 = object.scale;
            t4 = $.mul(t3.get$x(), $.abs($.sub(this._particle.get$x(), $.div($.add(t2.get$x(), camera.get$projectionMatrix().get$n11()), $.add(t2.get$w(), camera.get$projectionMatrix().get$n14())))));
            this._particle.get$scale().set$x(t4);
            t4 = $.mul(t3.get$y(), $.abs($.sub(this._particle.get$y(), $.div($.add(t2.get$y(), camera.get$projectionMatrix().get$n22()), $.add(t2.get$w(), camera.get$projectionMatrix().get$n24())))));
            this._particle.get$scale().set$y(t4);
            t4 = object.material;
            this._particle.set$material(t4);
            $.add$1(this._renderData.get$elements(), this._particle);
          }
        }
      }
      sort === true && $.sort(this._renderData.get$elements(), this.get$painterSort());
      return this._renderData;
  }
 },
 projectObject$1: function(object) {
  if (object.get$visible() === false) return;
  if (typeof object === 'object' && object !== null && !!object.is$Mesh || typeof object === 'object' && object !== null && !!object.is$Line) {
    var t1 = object.get$frustumCulled() === false || this._frustum.contains$1(object) === true;
  } else t1 = false;
  if (t1) {
    t1 = this._projScreenMatrix;
    var t2 = this._vector3;
    t1.multiplyVector3$1(t2.copy$1(object.get$position()));
    this._object = this.getNextObjectInPool$0();
    this._object.set$object(object);
    t2 = t2.get$z();
    this._object.set$z(t2);
    $.add$1(this._renderData.get$objects(), this._object);
  } else {
    if (typeof object === 'object' && object !== null && !!object.is$Sprite || typeof object === 'object' && object !== null && !!object.is$Particle) {
      t1 = this._projScreenMatrix;
      t2 = this._vector3;
      t1.multiplyVector3$1(t2.copy$1(object.get$position()));
      this._object = this.getNextObjectInPool$0();
      this._object.set$object(object);
      t2 = t2.get$z();
      this._object.set$z(t2);
      $.add$1(this._renderData.get$sprites(), this._object);
    } else {
      typeof object === 'object' && object !== null && !!object.is$Light && $.add$1(this._renderData.get$lights(), object);
    }
  }
  var cl = $.get$length(object.get$children());
  if (typeof cl !== 'number') return this.projectObject$1$bailout(1, object, cl, 0, 0);
  for (var c = 0; c < cl; ++c) {
    t1 = object.get$children();
    if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.projectObject$1$bailout(2, object, c, t1, cl);
    t1 = t1.length;
    if (c < 0 || c >= t1) throw $.ioore(c);
    var t3 = object.get$children();
    if (typeof t3 !== 'string' && (typeof t3 !== 'object' || t3 === null || (t3.constructor !== Array && !t3.is$JavaScriptIndexingBehavior()))) return this.projectObject$1$bailout(3, object, c, cl, t3);
    var t5 = t3.length;
    if (c < 0 || c >= t5) throw $.ioore(c);
    this.projectObject$1(t3[c]);
  }
 },
 projectObject$1$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var object = env0;
      cl = env1;
      break;
    case 2:
      object = env0;
      c = env1;
      t1 = env2;
      cl = env3;
      break;
    case 3:
      object = env0;
      c = env1;
      cl = env2;
      t1 = env3;
      break;
  }
  switch (state) {
    case 0:
      if (object.get$visible() === false) return;
      if (typeof object === 'object' && object !== null && !!object.is$Mesh || typeof object === 'object' && object !== null && !!object.is$Line) {
        var t1 = object.get$frustumCulled() === false || $.contains$1(this._frustum, object) === true;
      } else t1 = false;
      if (t1) {
        t1 = this._projScreenMatrix;
        var t2 = this._vector3;
        t1.multiplyVector3$1(t2.copy$1(object.get$position()));
        this._object = this.getNextObjectInPool$0();
        this._object.set$object(object);
        t2 = t2.get$z();
        this._object.set$z(t2);
        $.add$1(this._renderData.get$objects(), this._object);
      } else {
        if (typeof object === 'object' && object !== null && !!object.is$Sprite || typeof object === 'object' && object !== null && !!object.is$Particle) {
          t1 = this._projScreenMatrix;
          t2 = this._vector3;
          t1.multiplyVector3$1(t2.copy$1(object.get$position()));
          this._object = this.getNextObjectInPool$0();
          this._object.set$object(object);
          t2 = t2.get$z();
          this._object.set$z(t2);
          $.add$1(this._renderData.get$sprites(), this._object);
        } else {
          typeof object === 'object' && object !== null && !!object.is$Light && $.add$1(this._renderData.get$lights(), object);
        }
      }
      var cl = $.get$length(object.get$children());
    case 1:
      state = 0;
      var c = 0;
    default:
      L0: while (true) {
        switch (state) {
          case 0:
            if (!$.ltB(c, cl)) break L0;
            t1 = object.get$children();
          case 2:
            state = 0;
            $.index(t1, c);
            t1 = object.get$children();
          case 3:
            state = 0;
            this.projectObject$1($.index(t1, c));
            ++c;
        }
      }
  }
 },
 projectGraph$2: function(root, sort) {
  this._objectCount = 0;
  var t1 = [];
  this._renderData.set$objects(t1);
  t1 = [];
  this._renderData.set$sprites(t1);
  t1 = [];
  this._renderData.set$lights(t1);
  this.projectObject$1(root);
  sort === true && $.sort(this._renderData.get$objects(), this.get$painterSort());
  return this._renderData;
 },
 Projector$0: function() {
  this._objectPool = [];
  this._vertexPool = [];
  this._face3Pool = [];
  this._face4Pool = [];
  this._linePool = [];
  this._particlePool = [];
  this._renderData = $.ProjectorRenderData$();
  this._vector3 = $.Vector3$(0, 0, 0);
  this._vector4 = $.Vector4$(0, 0, 0, 1);
  this._projScreenMatrix = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this._projScreenobjectMatrixWorld = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  this._frustum = $.Frustum$();
  this._clippedVertex1PositionScreen = $.Vector4$(0, 0, 0, 1);
  this._clippedVertex2PositionScreen = $.Vector4$(0, 0, 0, 1);
 }
};

$$.ProjectorRenderData = {"":
 ["elements=", "lights=", "sprites=", "objects="],
 super: "Object",
 ProjectorRenderData$0: function() {
  this.objects = [];
  this.sprites = [];
  this.lights = [];
  this.elements = [];
 }
};

$$.Vector2 = {"":
 ["_y", "_x"],
 super: "Object",
 distanceToSquared$1: function(v) {
  var dx = $.sub(this._x, v.get$x());
  var dy = $.sub(this._y, v.get$y());
  return $.add($.mul(dx, dx), $.mul(dy, dy));
 },
 distanceTo$1: function(v) {
  return $.Math_sqrt(this.distanceToSquared$1(v));
 },
 normalize$0: function() {
  return this.divideScalar$1(this.length$0());
 },
 length$0: function() {
  return $.Math_sqrt(this.lengthSq$0());
 },
 get$length: function() { return new $.BoundClosure(this, 'length$0'); },
 lengthSq$0: function() {
  var t1 = this._x;
  t1 = $.mul(t1, t1);
  var t2 = this._y;
  return $.add(t1, $.mul(t2, t2));
 },
 dot$1: function(v) {
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.dot$1$bailout(1, v, t1, 0);
  var t3 = v.get$x();
  if (typeof t3 !== 'number') return this.dot$1$bailout(2, v, t3, t1);
  t3 *= t1;
  t1 = this._y;
  if (typeof t1 !== 'number') return this.dot$1$bailout(3, t1, v, t3);
  var t6 = v.get$y();
  if (typeof t6 !== 'number') return this.dot$1$bailout(4, t1, t6, t3);
  return t3 + t1 * t6;
 },
 dot$1$bailout: function(state, env0, env1, env2) {
  switch (state) {
    case 1:
      var v = env0;
      t1 = env1;
      break;
    case 2:
      v = env0;
      t3 = env1;
      t1 = env2;
      break;
    case 3:
      t1 = env0;
      v = env1;
      t3 = env2;
      break;
    case 4:
      t1 = env0;
      t6 = env1;
      t3 = env2;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._x;
    case 1:
      state = 0;
      var t3 = v.get$x();
    case 2:
      state = 0;
      t3 = $.mul(t1, t3);
      t1 = this._y;
    case 3:
      state = 0;
      var t6 = v.get$y();
    case 4:
      state = 0;
      return $.add(t3, $.mul(t1, t6));
  }
 },
 divideScalar$1: function(s) {
  if (typeof s !== 'number') return this.divideScalar$1$bailout(1, s, 0);
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.divideScalar$1$bailout(2, s, t1);
  this._x = t1 / s;
  var t3 = this._y;
  if (typeof t3 !== 'number') return this.divideScalar$1$bailout(3, s, t3);
  this._y = t3 / s;
  return this;
 },
 divideScalar$1$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      var s = env0;
      break;
    case 2:
      s = env0;
      t1 = env1;
      break;
    case 3:
      s = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
    default:
      if (state == 2 || state == 3 || (state == 0 && !(s == null))) {
        switch (state) {
          case 0:
            var t1 = this._x;
          case 2:
            state = 0;
            this._x = $.div(t1, s);
            var t3 = this._y;
          case 3:
            state = 0;
            this._y = $.div(t3, s);
        }
      } else {
        this.setValues$2(0, 0);
      }
      return this;
  }
 },
 multiplyScalar$1: function(s) {
  if (typeof s !== 'number') return this.multiplyScalar$1$bailout(1, s, 0);
  var t1 = this._x;
  if (typeof t1 !== 'number') return this.multiplyScalar$1$bailout(2, s, t1);
  this._x = t1 * s;
  var t3 = this._y;
  if (typeof t3 !== 'number') return this.multiplyScalar$1$bailout(3, s, t3);
  this._y = t3 * s;
  return this;
 },
 multiplyScalar$1$bailout: function(state, env0, env1) {
  switch (state) {
    case 1:
      var s = env0;
      break;
    case 2:
      s = env0;
      t1 = env1;
      break;
    case 3:
      s = env0;
      t3 = env1;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      var t1 = this._x;
    case 2:
      state = 0;
      this._x = $.mul(t1, s);
      var t3 = this._y;
    case 3:
      state = 0;
      this._y = $.mul(t3, s);
      return this;
  }
 },
 sub$2: function(v1, v2) {
  var t1 = v1.get$x();
  if (typeof t1 !== 'number') return this.sub$2$bailout(1, v1, v2, t1, 0);
  var t3 = v2.get$x();
  if (typeof t3 !== 'number') return this.sub$2$bailout(2, v1, v2, t1, t3);
  this._x = t1 - t3;
  var t5 = v1.get$y();
  if (typeof t5 !== 'number') return this.sub$2$bailout(3, t5, v2, 0, 0);
  var t7 = v2.get$y();
  if (typeof t7 !== 'number') return this.sub$2$bailout(4, t5, t7, 0, 0);
  this._y = t5 - t7;
  return this;
 },
 sub$2$bailout: function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      t1 = env2;
      break;
    case 2:
      v1 = env0;
      v2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      t5 = env0;
      v2 = env1;
      break;
    case 4:
      t5 = env0;
      t7 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = v1.get$x();
    case 1:
      state = 0;
      var t3 = v2.get$x();
    case 2:
      state = 0;
      this._x = $.sub(t1, t3);
      var t5 = v1.get$y();
    case 3:
      state = 0;
      var t7 = v2.get$y();
    case 4:
      state = 0;
      this._y = $.sub(t5, t7);
      return this;
  }
 },
 addSelf$1: function(v) {
  this._x = $.add(this._x, v.get$x());
  this._y = $.add(this._y, v.get$y());
  return this;
 },
 copy$1: function(v) {
  this._x = v.get$x();
  this._y = v.get$y();
  return this;
 },
 setValues$2: function(x, y) {
  this._x = x;
  this._y = y;
  return this;
 },
 set$y: function(value) {
  this._y = value;
 },
 get$y: function() {
  return this._y;
 },
 set$x: function(value) {
  this._x = value;
 },
 get$x: function() {
  return this._x;
 },
 Vector2$2: function(x, y) {
  this._x = !(x == null) ? x : 0;
  this._y = !(y == null) ? y : 0;
 }
};

$$.Rectangle = {"":
 ["_isEmpty", "_height", "_width", "_bottom", "_right", "_top", "_left"],
 super: "Object",
 isEmpty$0: function() {
  return this._isEmpty;
 },
 empty$0: function() {
  this._isEmpty = true;
  this._left = 0;
  this._top = 0;
  this._right = 0;
  this._bottom = 0;
  this.resize$0();
 },
 intersects$1: function(r) {
  var t1 = this._right;
  if (typeof t1 !== 'number') return this.intersects$1$bailout(1, r, t1, 0);
  var t3 = r.getLeft$0();
  if (typeof t3 !== 'number') return this.intersects$1$bailout(2, r, t3, t1);
  if (t1 < t3) return false;
  t1 = this._left;
  if (typeof t1 !== 'number') return this.intersects$1$bailout(3, r, t1, 0);
  t3 = r.getRight$0();
  if (typeof t3 !== 'number') return this.intersects$1$bailout(4, r, t1, t3);
  if (t1 > t3) return false;
  t1 = this._bottom;
  if (typeof t1 !== 'number') return this.intersects$1$bailout(5, r, t1, 0);
  t3 = r.getTop$0();
  if (typeof t3 !== 'number') return this.intersects$1$bailout(6, r, t1, t3);
  if (t1 < t3) return false;
  t1 = this._top;
  if (typeof t1 !== 'number') return this.intersects$1$bailout(7, r, t1, 0);
  t3 = r.getBottom$0();
  if (typeof t3 !== 'number') return this.intersects$1$bailout(8, t3, t1, 0);
  if (t1 > t3) return false;
  return true;
 },
 intersects$1$bailout: function(state, env0, env1, env2) {
  switch (state) {
    case 1:
      var r = env0;
      t1 = env1;
      break;
    case 2:
      r = env0;
      t3 = env1;
      t1 = env2;
      break;
    case 3:
      r = env0;
      t1 = env1;
      break;
    case 4:
      r = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 5:
      r = env0;
      t1 = env1;
      break;
    case 6:
      r = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 7:
      r = env0;
      t1 = env1;
      break;
    case 8:
      t3 = env0;
      t1 = env1;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._right;
    case 1:
      state = 0;
      var t3 = r.getLeft$0();
    case 2:
      state = 0;
      if ($.ltB(t1, t3)) return false;
      t1 = this._left;
    case 3:
      state = 0;
      t3 = r.getRight$0();
    case 4:
      state = 0;
      if ($.gtB(t1, t3)) return false;
      t1 = this._bottom;
    case 5:
      state = 0;
      t3 = r.getTop$0();
    case 6:
      state = 0;
      if ($.ltB(t1, t3)) return false;
      t1 = this._top;
    case 7:
      state = 0;
      t3 = r.getBottom$0();
    case 8:
      state = 0;
      if ($.gtB(t1, t3)) return false;
      return true;
  }
 },
 minSelf$1: function(r) {
  this._left = $.gtB(this._left, r.getLeft$0()) ? this._left : r.getLeft$0();
  this._top = $.gtB(this._top, r.getTop$0()) ? this._top : r.getTop$0();
  this._right = $.ltB(this._right, r.getRight$0()) ? this._right : r.getRight$0();
  this._bottom = $.ltB(this._bottom, r.getBottom$0()) ? this._bottom : r.getBottom$0();
  this.resize$0();
 },
 inflate$1: function(v) {
  this._left = $.sub(this._left, v);
  this._top = $.sub(this._top, v);
  this._right = $.add(this._right, v);
  this._bottom = $.add(this._bottom, v);
  this.resize$0();
 },
 addRectangle$1: function(r) {
  if (this._isEmpty) {
    this._isEmpty = false;
    this._left = r.getLeft$0();
    this._top = r.getTop$0();
    this._right = r.getRight$0();
    this._bottom = r.getBottom$0();
    this.resize$0();
  } else {
    var t1 = this._left;
    if (typeof t1 !== 'number') return this.addRectangle$1$bailout(1, r, t1, 0);
    var t3 = r.getLeft$0();
    if (typeof t3 !== 'number') return this.addRectangle$1$bailout(2, r, t1, t3);
    this._left = t1 < t3 ? this._left : r.getLeft$0();
    t1 = this._top;
    if (typeof t1 !== 'number') return this.addRectangle$1$bailout(3, r, t1, 0);
    t3 = r.getTop$0();
    if (typeof t3 !== 'number') return this.addRectangle$1$bailout(4, r, t1, t3);
    this._top = t1 < t3 ? this._top : r.getTop$0();
    t1 = this._right;
    if (typeof t1 !== 'number') return this.addRectangle$1$bailout(5, r, t1, 0);
    t3 = r.getRight$0();
    if (typeof t3 !== 'number') return this.addRectangle$1$bailout(6, r, t1, t3);
    this._right = t1 > t3 ? this._right : r.getRight$0();
    t1 = this._bottom;
    if (typeof t1 !== 'number') return this.addRectangle$1$bailout(7, r, t1, 0);
    t3 = r.getBottom$0();
    if (typeof t3 !== 'number') return this.addRectangle$1$bailout(8, r, t3, t1);
    this._bottom = t1 > t3 ? this._bottom : r.getBottom$0();
    this.resize$0();
  }
 },
 addRectangle$1$bailout: function(state, env0, env1, env2) {
  switch (state) {
    case 1:
      var r = env0;
      t1 = env1;
      break;
    case 2:
      r = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 3:
      r = env0;
      t1 = env1;
      break;
    case 4:
      r = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 5:
      r = env0;
      t1 = env1;
      break;
    case 6:
      r = env0;
      t1 = env1;
      t3 = env2;
      break;
    case 7:
      r = env0;
      t1 = env1;
      break;
    case 8:
      r = env0;
      t3 = env1;
      t1 = env2;
      break;
  }
  switch (state) {
    case 0:
    default:
      if ((state == 0 && this._isEmpty === true)) {
        this._isEmpty = false;
        this._left = r.getLeft$0();
        this._top = r.getTop$0();
        this._right = r.getRight$0();
        this._bottom = r.getBottom$0();
        this.resize$0();
      } else {
        switch (state) {
          case 0:
            var t1 = this._left;
          case 1:
            state = 0;
            var t3 = r.getLeft$0();
          case 2:
            state = 0;
            this._left = $.ltB(t1, t3) ? this._left : r.getLeft$0();
            t1 = this._top;
          case 3:
            state = 0;
            t3 = r.getTop$0();
          case 4:
            state = 0;
            this._top = $.ltB(t1, t3) ? this._top : r.getTop$0();
            t1 = this._right;
          case 5:
            state = 0;
            t3 = r.getRight$0();
          case 6:
            state = 0;
            this._right = $.gtB(t1, t3) ? this._right : r.getRight$0();
            t1 = this._bottom;
          case 7:
            state = 0;
            t3 = r.getBottom$0();
          case 8:
            state = 0;
            this._bottom = $.gtB(t1, t3) ? this._bottom : r.getBottom$0();
            this.resize$0();
        }
      }
  }
 },
 add3Points$6: function(x1, y1, x2, y2, x3, y3) {
  if (typeof x1 !== 'number') return this.add3Points$6$bailout(1, x1, y1, x2, y2, x3, y3, 0);
  if (typeof y1 !== 'number') return this.add3Points$6$bailout(1, x1, y1, x2, y2, x3, y3, 0);
  if (typeof x2 !== 'number') return this.add3Points$6$bailout(1, x1, y1, x2, y2, x3, y3, 0);
  if (typeof y2 !== 'number') return this.add3Points$6$bailout(1, x1, y1, x2, y2, x3, y3, 0);
  if (typeof x3 !== 'number') return this.add3Points$6$bailout(1, x1, y1, x2, y2, x3, y3, 0);
  if (typeof y3 !== 'number') return this.add3Points$6$bailout(1, x1, y1, x2, y2, x3, y3, 0);
  if (this._isEmpty) {
    this._isEmpty = false;
    if (x1 < x2) {
      if (x1 < x3) var t1 = x1;
      else t1 = x3;
    } else {
      if (x2 < x3) t1 = x2;
      else t1 = x3;
    }
    this._left = t1;
    if (y1 < y2) {
      if (y1 < y3) t1 = y1;
      else t1 = y3;
    } else {
      if (y2 < y3) t1 = y2;
      else t1 = y3;
    }
    this._top = t1;
    if (x1 > x2) {
      if (x1 > x3) t1 = x1;
      else t1 = x3;
    } else {
      if (x2 > x3) t1 = x2;
      else t1 = x3;
    }
    this._right = t1;
    if (y1 > y2) {
      if (y1 > y3) t1 = y1;
      else t1 = y3;
    } else {
      if (y2 > y3) t1 = y2;
      else t1 = y3;
    }
    this._bottom = t1;
    this.resize$0();
  } else {
    if (x1 < x2) {
      if (x1 < x3) {
        t1 = this._left;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(2, x1, y1, x2, y2, x3, y3, t1);
        if (x1 < t1) t1 = x1;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(3, x1, y1, x2, y2, x3, y3, t1);
        }
      } else {
        t1 = this._left;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(4, x1, y1, x2, y2, x3, y3, t1);
        if (x3 < t1) t1 = x3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(5, x1, y1, x2, y2, x3, y3, t1);
        }
      }
    } else {
      if (x2 < x3) {
        t1 = this._left;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(6, x1, y1, x2, y2, x3, y3, t1);
        if (x2 < t1) t1 = x2;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(7, x1, y1, x2, y2, x3, y3, t1);
        }
      } else {
        t1 = this._left;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(8, x1, y1, x2, y2, x3, y3, t1);
        if (x3 < t1) t1 = x3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(9, x1, y1, x2, y2, x3, y3, t1);
        }
      }
    }
    this._left = t1;
    if (y1 < y2) {
      if (y1 < y3) {
        t1 = this._top;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(10, x1, y1, x2, y2, x3, y3, t1);
        if (y1 < t1) t1 = y1;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(11, x1, y1, x2, y2, x3, y3, t1);
        }
      } else {
        t1 = this._top;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(12, x1, y1, x2, y2, x3, y3, t1);
        if (y3 < t1) t1 = y3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(13, x1, y1, x2, y2, x3, y3, t1);
        }
      }
    } else {
      if (y2 < y3) {
        t1 = this._top;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(14, x1, y1, x2, y2, x3, y3, t1);
        if (y2 < t1) t1 = y2;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(15, x1, y1, x2, y2, x3, y3, t1);
        }
      } else {
        t1 = this._top;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(16, x1, y1, x2, y2, x3, y3, t1);
        if (y3 < t1) t1 = y3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(17, x1, y1, x2, y2, x3, y3, t1);
        }
      }
    }
    this._top = t1;
    if (x1 > x2) {
      if (x1 > x3) {
        t1 = this._right;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(18, x1, y1, y2, t1, y3, 0, 0);
        if (x1 > t1) t1 = x1;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(19, y1, y2, y3, t1, 0, 0, 0);
        }
      } else {
        t1 = this._right;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(20, y1, y2, x3, y3, t1, 0, 0);
        if (x3 > t1) t1 = x3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(21, y1, y2, y3, t1, 0, 0, 0);
        }
      }
    } else {
      if (x2 > x3) {
        t1 = this._right;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(22, t1, y1, x2, y2, y3, 0, 0);
        if (x2 > t1) t1 = x2;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(23, y1, t1, y2, y3, 0, 0, 0);
        }
      } else {
        t1 = this._right;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(24, y1, t1, y2, x3, y3, 0, 0);
        if (x3 > t1) t1 = x3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(25, y1, y2, t1, y3, 0, 0, 0);
        }
      }
    }
    this._right = t1;
    if (y1 > y2) {
      if (y1 > y3) {
        t1 = this._bottom;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(26, y1, t1, 0, 0, 0, 0, 0);
        if (y1 > t1) t1 = y1;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(27, t1, 0, 0, 0, 0, 0, 0);
        }
      } else {
        t1 = this._bottom;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(28, y3, t1, 0, 0, 0, 0, 0);
        if (y3 > t1) t1 = y3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(29, t1, 0, 0, 0, 0, 0, 0);
        }
      }
    } else {
      if (y2 > y3) {
        t1 = this._bottom;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(30, t1, y2, 0, 0, 0, 0, 0);
        if (y2 > t1) t1 = y2;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(31, t1, 0, 0, 0, 0, 0, 0);
        }
      } else {
        t1 = this._bottom;
        if (typeof t1 !== 'number') return this.add3Points$6$bailout(32, t1, y3, 0, 0, 0, 0, 0);
        if (y3 > t1) t1 = y3;
        else {
          if (typeof t1 !== 'number') return this.add3Points$6$bailout(33, t1, 0, 0, 0, 0, 0, 0);
        }
      }
    }
    this._bottom = t1;
    this.resize$0();
  }
 },
 add3Points$6$bailout: function(state, env0, env1, env2, env3, env4, env5, env6) {
  switch (state) {
    case 1:
      var x1 = env0;
      var y1 = env1;
      var x2 = env2;
      var y2 = env3;
      var x3 = env4;
      var y3 = env5;
      break;
    case 2:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 3:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 4:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 5:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 6:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 7:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 8:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 9:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 10:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 11:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 12:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 13:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 14:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 15:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 16:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 17:
      x1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      x3 = env4;
      y3 = env5;
      t1 = env6;
      break;
    case 18:
      x1 = env0;
      y1 = env1;
      y2 = env2;
      t1 = env3;
      y3 = env4;
      break;
    case 19:
      y1 = env0;
      y2 = env1;
      y3 = env2;
      t1 = env3;
      break;
    case 20:
      y1 = env0;
      y2 = env1;
      x3 = env2;
      y3 = env3;
      t1 = env4;
      break;
    case 21:
      y1 = env0;
      y2 = env1;
      y3 = env2;
      t1 = env3;
      break;
    case 22:
      t1 = env0;
      y1 = env1;
      x2 = env2;
      y2 = env3;
      y3 = env4;
      break;
    case 23:
      y1 = env0;
      t1 = env1;
      y2 = env2;
      y3 = env3;
      break;
    case 24:
      y1 = env0;
      t1 = env1;
      y2 = env2;
      x3 = env3;
      y3 = env4;
      break;
    case 25:
      y1 = env0;
      y2 = env1;
      t1 = env2;
      y3 = env3;
      break;
    case 26:
      y1 = env0;
      t1 = env1;
      break;
    case 27:
      t1 = env0;
      break;
    case 28:
      y3 = env0;
      t1 = env1;
      break;
    case 29:
      t1 = env0;
      break;
    case 30:
      t1 = env0;
      y2 = env1;
      break;
    case 31:
      t1 = env0;
      break;
    case 32:
      t1 = env0;
      y3 = env1;
      break;
    case 33:
      t1 = env0;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
    default:
      if ((state == 0 && this._isEmpty === true)) {
        this._isEmpty = false;
        if ($.ltB(x1, x2)) {
          var t1 = $.ltB(x1, x3) ? x1 : x3;
        } else {
          t1 = $.ltB(x2, x3) ? x2 : x3;
        }
        this._left = t1;
        if ($.ltB(y1, y2)) {
          t1 = $.ltB(y1, y3) ? y1 : y3;
        } else {
          t1 = $.ltB(y2, y3) ? y2 : y3;
        }
        this._top = t1;
        if ($.gtB(x1, x2)) {
          t1 = $.gtB(x1, x3) ? x1 : x3;
        } else {
          t1 = $.gtB(x2, x3) ? x2 : x3;
        }
        this._right = t1;
        if ($.gtB(y1, y2)) {
          t1 = $.gtB(y1, y3) ? y1 : y3;
        } else {
          t1 = $.gtB(y2, y3) ? y2 : y3;
        }
        this._bottom = t1;
        this.resize$0();
      } else {
        switch (state) {
          case 0:
          default:
            if (state == 2 || state == 3 || state == 4 || state == 5 || (state == 0 && $.ltB(x1, x2))) {
              switch (state) {
                case 0:
                default:
                  if (state == 2 || state == 3 || (state == 0 && $.ltB(x1, x3))) {
                    switch (state) {
                      case 0:
                        t1 = this._left;
                      case 2:
                        state = 0;
                      case 3:
                        if ((state == 0 && $.ltB(x1, t1))) {
                          t1 = x1;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._left;
                            case 3:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._left;
                      case 4:
                        state = 0;
                      case 5:
                        if ((state == 0 && $.ltB(x3, t1))) {
                          t1 = x3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._left;
                            case 5:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 6 || state == 7 || (state == 0 && $.ltB(x2, x3))) {
                    switch (state) {
                      case 0:
                        t1 = this._left;
                      case 6:
                        state = 0;
                      case 7:
                        if ((state == 0 && $.ltB(x2, t1))) {
                          t1 = x2;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._left;
                            case 7:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._left;
                      case 8:
                        state = 0;
                      case 9:
                        if ((state == 0 && $.ltB(x3, t1))) {
                          t1 = x3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._left;
                            case 9:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            }
            this._left = t1;
          case 10:
          case 11:
          case 12:
          case 13:
          case 14:
          case 15:
          case 16:
          case 17:
            if (state == 10 || state == 11 || state == 12 || state == 13 || (state == 0 && $.ltB(y1, y2))) {
              switch (state) {
                case 0:
                default:
                  if (state == 10 || state == 11 || (state == 0 && $.ltB(y1, y3))) {
                    switch (state) {
                      case 0:
                        t1 = this._top;
                      case 10:
                        state = 0;
                      case 11:
                        if ((state == 0 && $.ltB(y1, t1))) {
                          t1 = y1;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._top;
                            case 11:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._top;
                      case 12:
                        state = 0;
                      case 13:
                        if ((state == 0 && $.ltB(y3, t1))) {
                          t1 = y3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._top;
                            case 13:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 14 || state == 15 || (state == 0 && $.ltB(y2, y3))) {
                    switch (state) {
                      case 0:
                        t1 = this._top;
                      case 14:
                        state = 0;
                      case 15:
                        if ((state == 0 && $.ltB(y2, t1))) {
                          t1 = y2;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._top;
                            case 15:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._top;
                      case 16:
                        state = 0;
                      case 17:
                        if ((state == 0 && $.ltB(y3, t1))) {
                          t1 = y3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._top;
                            case 17:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            }
            this._top = t1;
          case 18:
          case 19:
          case 20:
          case 21:
          case 22:
          case 23:
          case 24:
          case 25:
            if (state == 18 || state == 19 || state == 20 || state == 21 || (state == 0 && $.gtB(x1, x2))) {
              switch (state) {
                case 0:
                default:
                  if (state == 18 || state == 19 || (state == 0 && $.gtB(x1, x3))) {
                    switch (state) {
                      case 0:
                        t1 = this._right;
                      case 18:
                        state = 0;
                      case 19:
                        if ((state == 0 && $.gtB(x1, t1))) {
                          t1 = x1;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._right;
                            case 19:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._right;
                      case 20:
                        state = 0;
                      case 21:
                        if ((state == 0 && $.gtB(x3, t1))) {
                          t1 = x3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._right;
                            case 21:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 22 || state == 23 || (state == 0 && $.gtB(x2, x3))) {
                    switch (state) {
                      case 0:
                        t1 = this._right;
                      case 22:
                        state = 0;
                      case 23:
                        if ((state == 0 && $.gtB(x2, t1))) {
                          t1 = x2;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._right;
                            case 23:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._right;
                      case 24:
                        state = 0;
                      case 25:
                        if ((state == 0 && $.gtB(x3, t1))) {
                          t1 = x3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._right;
                            case 25:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            }
            this._right = t1;
          case 26:
          case 27:
          case 28:
          case 29:
          case 30:
          case 31:
          case 32:
          case 33:
            if (state == 26 || state == 27 || state == 28 || state == 29 || (state == 0 && $.gtB(y1, y2))) {
              switch (state) {
                case 0:
                default:
                  if (state == 26 || state == 27 || (state == 0 && $.gtB(y1, y3))) {
                    switch (state) {
                      case 0:
                        t1 = this._bottom;
                      case 26:
                        state = 0;
                      case 27:
                        if ((state == 0 && $.gtB(y1, t1))) {
                          t1 = y1;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._bottom;
                            case 27:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._bottom;
                      case 28:
                        state = 0;
                      case 29:
                        if ((state == 0 && $.gtB(y3, t1))) {
                          t1 = y3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._bottom;
                            case 29:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 30 || state == 31 || (state == 0 && $.gtB(y2, y3))) {
                    switch (state) {
                      case 0:
                        t1 = this._bottom;
                      case 30:
                        state = 0;
                      case 31:
                        if ((state == 0 && $.gtB(y2, t1))) {
                          t1 = y2;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._bottom;
                            case 31:
                              state = 0;
                          }
                        }
                    }
                  } else {
                    switch (state) {
                      case 0:
                        t1 = this._bottom;
                      case 32:
                        state = 0;
                      case 33:
                        if ((state == 0 && $.gtB(y3, t1))) {
                          t1 = y3;
                        } else {
                          switch (state) {
                            case 0:
                              t1 = this._bottom;
                            case 33:
                              state = 0;
                          }
                        }
                    }
                  }
              }
            }
            this._bottom = t1;
            this.resize$0();
        }
      }
  }
 },
 addPoint$2: function(x, y) {
  if (typeof x !== 'number') return this.addPoint$2$bailout(1, x, y, 0);
  if (typeof y !== 'number') return this.addPoint$2$bailout(1, x, y, 0);
  if (this._isEmpty) {
    this._isEmpty = false;
    this._left = x;
    this._top = y;
    this._right = x;
    this._bottom = y;
    this.resize$0();
  } else {
    var t1 = this._left;
    if (typeof t1 !== 'number') return this.addPoint$2$bailout(2, x, y, t1);
    if (t1 < x) {
      if (typeof t1 !== 'number') return this.addPoint$2$bailout(3, x, y, t1);
    } else t1 = x;
    this._left = t1;
    t1 = this._top;
    if (typeof t1 !== 'number') return this.addPoint$2$bailout(4, x, y, t1);
    if (t1 < y) {
      if (typeof t1 !== 'number') return this.addPoint$2$bailout(5, x, y, t1);
    } else t1 = y;
    this._top = t1;
    t1 = this._right;
    if (typeof t1 !== 'number') return this.addPoint$2$bailout(6, x, y, t1);
    if (t1 > x) {
      if (typeof t1 !== 'number') return this.addPoint$2$bailout(7, y, t1, 0);
    } else t1 = x;
    this._right = t1;
    t1 = this._bottom;
    if (typeof t1 !== 'number') return this.addPoint$2$bailout(8, y, t1, 0);
    if (t1 > y) {
      if (typeof t1 !== 'number') return this.addPoint$2$bailout(9, t1, 0, 0);
    } else t1 = y;
    this._bottom = t1;
    this.resize$0();
  }
 },
 addPoint$2$bailout: function(state, env0, env1, env2) {
  switch (state) {
    case 1:
      var x = env0;
      var y = env1;
      break;
    case 2:
      x = env0;
      y = env1;
      t1 = env2;
      break;
    case 3:
      x = env0;
      y = env1;
      t1 = env2;
      break;
    case 4:
      x = env0;
      y = env1;
      t1 = env2;
      break;
    case 5:
      x = env0;
      y = env1;
      t1 = env2;
      break;
    case 6:
      x = env0;
      y = env1;
      t1 = env2;
      break;
    case 7:
      y = env0;
      t1 = env1;
      break;
    case 8:
      y = env0;
      t1 = env1;
      break;
    case 9:
      t1 = env0;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
    default:
      if ((state == 0 && this._isEmpty === true)) {
        this._isEmpty = false;
        this._left = x;
        this._top = y;
        this._right = x;
        this._bottom = y;
        this.resize$0();
      } else {
        switch (state) {
          case 0:
            var t1 = this._left;
          case 2:
            state = 0;
          case 3:
            if (state == 3 || (state == 0 && $.ltB(t1, x))) {
              switch (state) {
                case 0:
                  t1 = this._left;
                case 3:
                  state = 0;
              }
            } else {
              t1 = x;
            }
            this._left = t1;
            t1 = this._top;
          case 4:
            state = 0;
          case 5:
            if (state == 5 || (state == 0 && $.ltB(t1, y))) {
              switch (state) {
                case 0:
                  t1 = this._top;
                case 5:
                  state = 0;
              }
            } else {
              t1 = y;
            }
            this._top = t1;
            t1 = this._right;
          case 6:
            state = 0;
          case 7:
            if (state == 7 || (state == 0 && $.gtB(t1, x))) {
              switch (state) {
                case 0:
                  t1 = this._right;
                case 7:
                  state = 0;
              }
            } else {
              t1 = x;
            }
            this._right = t1;
            t1 = this._bottom;
          case 8:
            state = 0;
          case 9:
            if (state == 9 || (state == 0 && $.gtB(t1, y))) {
              switch (state) {
                case 0:
                  t1 = this._bottom;
                case 9:
                  state = 0;
              }
            } else {
              t1 = y;
            }
            this._bottom = t1;
            this.resize$0();
        }
      }
  }
 },
 setValues$4: function(left, top$, right, bottom) {
  this._isEmpty = false;
  this._left = left;
  this._top = top$;
  this._right = right;
  this._bottom = bottom;
  this.resize$0();
 },
 getBottom$0: function() {
  return this._bottom;
 },
 getRight$0: function() {
  return this._right;
 },
 getTop$0: function() {
  return this._top;
 },
 getLeft$0: function() {
  return this._left;
 },
 getHeight$0: function() {
  return this._height;
 },
 getWidth$0: function() {
  return this._width;
 },
 getY$0: function() {
  return this._top;
 },
 getX$0: function() {
  return this._left;
 },
 resize$0: function() {
  this._width = $.sub(this._right, this._left);
  this._height = $.sub(this._bottom, this._top);
 }
};

$$.Material = {"":
 ["_id?"],
 super: "Object",
 get$blending: function() {
  return this._blending;
 },
 get$overdraw: function() {
  return this._overdraw;
 },
 get$opacity: function() {
  return this._opacity;
 },
 Material$1: function(parameters) {
  var _parameters = !(parameters == null) ? parameters : $.makeLiteralMap([]);
  this._name = '';
  var t1 = $.Three_MaterialCount;
  $.Three_MaterialCount = $.add(t1, 1);
  this._id = t1;
  this._opacity = !($.index(_parameters, 'opacity') == null) ? $.index(_parameters, 'opacity') : 1;
  this._transparent = !($.index(_parameters, 'transparent') == null) && $.index(_parameters, 'transparent');
  this._blending = !($.index(_parameters, 'blending') == null) ? $.toInt($.index(_parameters, 'blending')) : 0;
  this._depthTest = $.index(_parameters, 'depthTest') == null || $.index(_parameters, 'depthTest');
  this._depthWrite = $.index(_parameters, 'depthWrite') == null || $.index(_parameters, 'depthWrite');
  this._polygonOffset = !($.index(_parameters, 'polygonOffset') == null) && $.index(_parameters, 'polygonOffset');
  this._polygonOffsetFactor = !($.index(_parameters, 'polygonOffsetFactor') == null) ? $.toInt($.index(_parameters, 'polygonOffsetFactor')) : 0;
  this._polygonOffsetUnits = !($.index(_parameters, 'polygonOffsetUnits') == null) ? $.toInt($.index(_parameters, 'polygonOffsetUnits')) : 0;
  this._alphaTest = !($.index(_parameters, 'alphaTest') == null) ? $.toInt($.index(_parameters, 'alphaTest')) : 0;
  this._overdraw = !($.index(_parameters, 'overdraw') == null) && $.index(_parameters, 'overdraw');
 }
};

$$.ParticleCanvasMaterial = {"":
 ["program", "color?", "_overdraw", "_polygonOffset", "_depthWrite", "_depthTest", "_transparent", "_polygonOffsetUnits", "_polygonOffsetFactor", "_alphaTest", "_blending", "_opacity", "_id", "_name"],
 super: "Material",
 program$1: function(arg0) { return this.program.$call$1(arg0); },
 ParticleCanvasMaterial$1: function(parameters) {
  var _parameters = !(parameters == null) ? parameters : $.makeLiteralMap([]);
  this.color = !($.index(_parameters, 'color') == null) ? $.Color$($.index(_parameters, 'color')) : $.Color$(16777215);
  this.program = !($.index(_parameters, 'program') == null) ? $.index(_parameters, 'program') : new $.$$function();
 },
 is$ParticleCanvasMaterial: true
};

$$.LineBasicMaterial = {"":
 ["_fog", "_vertexColors", "_linejoin", "_linecap", "_linewidth", "_color", "_overdraw", "_polygonOffset", "_depthWrite", "_depthTest", "_transparent", "_polygonOffsetUnits", "_polygonOffsetFactor", "_alphaTest", "_blending", "_opacity", "_id", "_name"],
 super: "Material",
 get$color: function() {
  return this._color;
 },
 get$linejoin: function() {
  return this._linejoin;
 },
 get$linecap: function() {
  return this._linecap;
 },
 get$linewidth: function() {
  return this._linewidth;
 },
 LineBasicMaterial$1: function(parameters) {
  parameters = !(parameters == null) ? parameters : $.makeLiteralMap([]);
  this._color = !($.index(parameters, 'color') == null) ? $.Color$($.index(parameters, 'color')) : $.Color$(16777215);
  this._linewidth = !($.index(parameters, 'linewidth') == null) ? $.index(parameters, 'linewidth') : 1;
  this._linecap = !($.index(parameters, 'linecap') == null) ? $.index(parameters, 'linecap') : 'round';
  this._linejoin = !($.index(parameters, 'linejoin') == null) ? $.index(parameters, 'linejoin') : 'round';
  this._vertexColors = !(null == $.index(parameters, 'vertexColors')) && $.index(parameters, 'vertexColors');
  this._fog = $.index(parameters, 'fog') == null || $.index(parameters, 'fog');
 },
 is$LineBasicMaterial: true
};

$$.Line = {"":
 ["_lib0_type", "_material", "_geometry", "_vector", "frustumCulled", "receiveShadow", "castShadow", "visible", "boundRadiusScale", "boundRadius", "useQuaternion", "quaternion", "matrixWorldNeedsUpdate", "matrixAutoUpdate", "matrixRotationWorld", "matrixWorld", "matrix", "renderDepth", "rotationAutoUpdate", "flipSided", "doubleSided", "dynamic", "eulerOrder", "scale", "rotation", "position", "up", "children", "parent", "id", "_name"],
 super: "Object3D",
 get$material: function() {
  return this._material;
 },
 get$geometry: function() {
  return this._geometry;
 },
 Line$3: function(geometry, material, ltype) {
  this._geometry = geometry;
  this._material = material;
  this._lib0_type = ltype;
  var t1 = this._geometry;
  if (!(t1 == null)) {
    t1.get$boundingSphere() == null && t1.computeBoundingSphere$0();
  }
 },
 is$Line: true
};

$$.Particle = {"":
 ["material=", "_vector", "frustumCulled", "receiveShadow", "castShadow", "visible", "boundRadiusScale", "boundRadius", "useQuaternion", "quaternion", "matrixWorldNeedsUpdate", "matrixAutoUpdate", "matrixRotationWorld", "matrixWorld", "matrix", "renderDepth", "rotationAutoUpdate", "flipSided", "doubleSided", "dynamic", "eulerOrder", "scale", "rotation", "position", "up", "children", "parent", "id", "_name"],
 super: "Object3D",
 Particle$1: function(material) {
  this.material = material;
 },
 is$Particle: true
};

$$.RenderableObject = {"":
 ["z=", "object="],
 super: "Object"
};

$$.RenderableVertex = {"":
 ["visible=", "positionScreen?", "positionWorld?"],
 super: "Object",
 copy$1: function(vertex) {
  this.positionWorld.copy$1(vertex.get$positionWorld());
  this.positionScreen.copy$1(vertex.get$positionScreen());
 },
 RenderableVertex$0: function() {
  this.positionWorld = $.Vector3$(0, 0, 0);
  this.positionScreen = $.Vector4$(0, 0, 0, 1);
 }
};

$$.RenderableFace3 = {"":
 ["_z", "_faceMaterial", "_material", "_uvs", "_vertexNormalsWorld", "_normalWorld", "_centroidScreen", "_centroidWorld", "_v3", "_v2", "_v1"],
 super: "Object",
 get$z: function() {
  return this._z;
 },
 get$faceMaterial: function() {
  return this._faceMaterial;
 },
 get$material: function() {
  return this._material;
 },
 get$uvs: function() {
  return this._uvs;
 },
 get$vertexNormalsWorld: function() {
  return this._vertexNormalsWorld;
 },
 get$centroidScreen: function() {
  return this._centroidScreen;
 },
 get$centroidWorld: function() {
  return this._centroidWorld;
 },
 get$normalWorld: function() {
  return this._normalWorld;
 },
 get$v3: function() {
  return this._v3;
 },
 get$v2: function() {
  return this._v2;
 },
 get$v1: function() {
  return this._v1;
 },
 RenderableFace3$0: function() {
  this._v1 = $.RenderableVertex$();
  this._v2 = $.RenderableVertex$();
  this._v3 = $.RenderableVertex$();
  this._centroidWorld = $.Vector3$(0, 0, 0);
  this._centroidScreen = $.Vector3$(0, 0, 0);
  this._normalWorld = $.Vector3$(0, 0, 0);
  this._vertexNormalsWorld = [$.Vector3$(0, 0, 0), $.Vector3$(0, 0, 0), $.Vector3$(0, 0, 0)];
  this._material = null;
  this._faceMaterial = null;
  this._uvs = [[]];
  this._z = null;
 },
 is$RenderableFace3: true
};

$$.RenderableFace4 = {"":
 ["_z", "_faceMaterial", "_material", "_uvs", "_vertexNormalsWorld", "_normalWorld", "_centroidScreen", "_centroidWorld", "_v4", "_v3", "_v2", "_v1"],
 super: "Object",
 set$z: function(value) {
  this._z = value;
 },
 get$z: function() {
  return this._z;
 },
 set$faceMaterial: function(value) {
  this._faceMaterial = value;
 },
 get$faceMaterial: function() {
  return this._faceMaterial;
 },
 set$material: function(value) {
  this._material = value;
 },
 get$material: function() {
  return this._material;
 },
 get$uvs: function() {
  return this._uvs;
 },
 get$vertexNormalsWorld: function() {
  return this._vertexNormalsWorld;
 },
 get$centroidScreen: function() {
  return this._centroidScreen;
 },
 get$centroidWorld: function() {
  return this._centroidWorld;
 },
 get$normalWorld: function() {
  return this._normalWorld;
 },
 get$v4: function() {
  return this._v4;
 },
 get$v3: function() {
  return this._v3;
 },
 get$v2: function() {
  return this._v2;
 },
 get$v1: function() {
  return this._v1;
 },
 RenderableFace4$0: function() {
  this._v1 = $.RenderableVertex$();
  this._v2 = $.RenderableVertex$();
  this._v3 = $.RenderableVertex$();
  this._v4 = $.RenderableVertex$();
  this._centroidWorld = $.Vector3$(0, 0, 0);
  this._centroidScreen = $.Vector3$(0, 0, 0);
  this._normalWorld = $.Vector3$(0, 0, 0);
  this._vertexNormalsWorld = [$.Vector3$(0, 0, 0), $.Vector3$(0, 0, 0), $.Vector3$(0, 0, 0), $.Vector3$(0, 0, 0)];
  this._material = null;
  this._faceMaterial = null;
  this._uvs = [];
  $.add$1(this._uvs, $.ListFactory_List(null));
  this._z = null;
 },
 is$RenderableFace4: true
};

$$.RenderableLine = {"":
 ["material=", "v2?", "v1?", "z="],
 super: "Object",
 RenderableLine$0: function() {
  this.v1 = $.RenderableVertex$();
  this.v2 = $.RenderableVertex$();
 },
 is$RenderableLine: true
};

$$.RenderableParticle = {"":
 ["material=", "scale?", "rotation=", "z=", "y=", "x="],
 super: "Object",
 scale$1: function(arg0) { return this.scale.$call$1(arg0); },
 scale$2: function(arg0, arg1) { return this.scale.$call$2(arg0, arg1); },
 RenderableParticle$0: function() {
  this.scale = $.Vector2$(0, 0);
 },
 is$RenderableParticle: true
};

$$.CanvasRenderer = {"":
 ["debug", "_gradientMapContext", "_gradientMap", "_pixelMapContext", "_pixelMap", "_gradientMapQuality", "_pixelMapData", "_pixelMapImage", "_vector3", "_pi2", "_pointLights", "_directionalLights", "_ambientLight", "_enableLighting", "_uv3y", "_uv3x", "_uv2y", "_uv2x", "_uv1y", "_uv1x", "_uvs", "_image", "_far", "_near", "_imagedatas", "_patterns", "_color4", "_color3", "_color2", "_color1", "_color", "_v6y", "_v6x", "_v5y", "_v5x", "_v4y", "_v4x", "_v3y", "_v3x", "_v2y", "_v2x", "_v1y", "_v1x", "_v6", "_v5", "_projector", "_lights", "_elements", "_renderData", "_info", "_bboxRect", "_clearRect", "_clipRect", "_contextLineWidth", "_contextLineJoin", "_contextLineCap", "_contextFillStyle", "_contextStrokeStyle", "_contextGlobalCompositeOperation", "_contextGlobalAlpha", "_context", "_canvas", "_camera", "_clearOpacity", "_clearColor", "_canvasHeightHalf", "_canvasWidthHalf", "_canvasHeight", "_canvasWidth", "_sortElements", "_sortObjects", "_autoClear", "domElement?"],
 super: "Object",
 setFillStyle$1: function(style) {
  if (!$.eqB(this._contextFillStyle, style)) {
    this._contextFillStyle = style;
    var t1 = this._contextFillStyle;
    this._context.set$fillStyle(t1);
  }
 },
 setStrokeStyle$1: function(style) {
  if (!$.eqB(this._contextStrokeStyle, style)) {
    this._contextStrokeStyle = style;
    this._context.set$strokeStyle(style);
  }
 },
 setLineJoin$1: function(value) {
  if (!$.eqB(this._contextLineJoin, value)) {
    this._contextLineJoin = value;
    this._context.set$lineJoin(value);
  }
 },
 setLineCap$1: function(value) {
  if (!$.eqB(this._contextLineCap, value)) {
    this._contextLineCap = value;
    this._context.set$lineCap(value);
  }
 },
 setLineWidth$1: function(value) {
  if (!$.eqB(this._contextLineWidth, value)) {
    this._contextLineWidth = value;
    this._context.set$lineWidth(value);
  }
 },
 setBlending$1: function(value) {
  if (!$.eqB(this._contextGlobalCompositeOperation, value)) {
    switch (value) {
      case 0:
        this._context.set$globalCompositeOperation('source-over');
        break;
      case 1:
        this._context.set$globalCompositeOperation('lighter');
        break;
      case 2:
        this._context.set$globalCompositeOperation('darker');
        break;
    }
    this._contextGlobalCompositeOperation = value;
  }
 },
 setOpacity$1: function(value) {
  if (!$.eqB(this._contextGlobalAlpha, value)) {
    this._contextGlobalAlpha = value;
    this._context.set$globalAlpha(value);
  }
 },
 expand$2: function(v1, v2) {
  var t1 = v2.get$x();
  if (typeof t1 !== 'number') return this.expand$2$bailout(1, v1, v2, t1, 0, 0);
  var t3 = v1.get$x();
  if (typeof t3 !== 'number') return this.expand$2$bailout(2, v1, v2, t1, t3, 0);
  var x = t1 - t3;
  t3 = v2.get$y();
  if (typeof t3 !== 'number') return this.expand$2$bailout(3, v1, v2, t3, x, 0);
  var t5 = v1.get$y();
  if (typeof t5 !== 'number') return this.expand$2$bailout(4, v1, v2, t5, t3, x);
  var y = t3 - t5;
  var det = x * x + y * y;
  if (det === 0) return;
  t1 = $.Math_sqrt(det);
  if (typeof t1 !== 'number') throw $.iae(t1);
  var idet = 1 / t1;
  x *= idet;
  y *= idet;
  t1 = v2.get$x();
  if (typeof t1 !== 'number') return this.expand$2$bailout(5, v1, x, v2, y, t1);
  v2.set$x(t1 + x);
  t3 = v2.get$y();
  if (typeof t3 !== 'number') return this.expand$2$bailout(6, v1, x, v2, y, t3);
  v2.set$y(t3 + y);
  t5 = v1.get$x();
  if (typeof t5 !== 'number') return this.expand$2$bailout(7, v1, x, y, t5, 0);
  v1.set$x(t5 - x);
  var t7 = v1.get$y();
  if (typeof t7 !== 'number') return this.expand$2$bailout(8, v1, t7, y, 0, 0);
  v1.set$y(t7 - y);
 },
 expand$2$bailout: function(state, env0, env1, env2, env3, env4) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      t1 = env2;
      break;
    case 2:
      v1 = env0;
      v2 = env1;
      t1 = env2;
      t3 = env3;
      break;
    case 3:
      v1 = env0;
      v2 = env1;
      t3 = env2;
      x = env3;
      break;
    case 4:
      v1 = env0;
      v2 = env1;
      t5 = env2;
      t3 = env3;
      x = env4;
      break;
    case 5:
      v1 = env0;
      x = env1;
      v2 = env2;
      y = env3;
      t1 = env4;
      break;
    case 6:
      v1 = env0;
      x = env1;
      v2 = env2;
      y = env3;
      t3 = env4;
      break;
    case 7:
      v1 = env0;
      x = env1;
      y = env2;
      t5 = env3;
      break;
    case 8:
      v1 = env0;
      t7 = env1;
      y = env2;
      break;
  }
  switch (state) {
    case 0:
      var t1 = v2.get$x();
    case 1:
      state = 0;
      var t3 = v1.get$x();
    case 2:
      state = 0;
      var x = $.sub(t1, t3);
      t3 = v2.get$y();
    case 3:
      state = 0;
      var t5 = v1.get$y();
    case 4:
      state = 0;
      var y = $.sub(t3, t5);
      var det = $.add($.mul(x, x), $.mul(y, y));
      if ($.eqB(det, 0)) return;
      t1 = $.Math_sqrt(det);
      if (typeof t1 !== 'number') throw $.iae(t1);
      var idet = 1 / t1;
      x = $.mul(x, idet);
      y = $.mul(y, idet);
      t1 = v2.get$x();
    case 5:
      state = 0;
      v2.set$x($.add(t1, x));
      t3 = v2.get$y();
    case 6:
      state = 0;
      v2.set$y($.add(t3, y));
      t5 = v1.get$x();
    case 7:
      state = 0;
      v1.set$x($.sub(t5, x));
      var t7 = v1.get$y();
    case 8:
      state = 0;
      v1.set$y($.sub(t7, y));
  }
 },
 normalToComponent$1: function(normal) {
  var component = $.mul($.add(normal, 1), 0.5);
  if ($.ltB(component, 0)) var t1 = 0;
  else {
    t1 = $.gtB(component, 1) ? 1 : component;
  }
  return t1;
 },
 smoothstep$3: function(value, min, max) {
  var x = $.div($.sub(value, min), $.sub(max, min));
  var t1 = $.mul(x, x);
  if (typeof x !== 'number') throw $.iae(x);
  return $.mul(t1, 3 - 2 * x);
 },
 getGradientTexture$4: function(color1, color2, color3, color4) {
  var c1r = $.not($.not($.mul(color1.get$r(), 255)));
  var c1g = $.not($.not($.mul(color1.get$g(), 255)));
  var c1b = $.not($.not($.mul(color1.get$b(), 255)));
  var c2r = $.not($.not($.mul(color2.get$r(), 255)));
  var c2g = $.not($.not($.mul(color2.get$g(), 255)));
  var c2b = $.not($.not($.mul(color2.get$b(), 255)));
  var c3r = $.not($.not($.mul(color3.get$r(), 255)));
  var c3g = $.not($.not($.mul(color3.get$g(), 255)));
  var c3b = $.not($.not($.mul(color3.get$b(), 255)));
  var c4r = $.not($.not($.mul(color4.get$r(), 255)));
  var c4g = $.not($.not($.mul(color4.get$g(), 255)));
  var c4b = $.not($.not($.mul(color4.get$b(), 255)));
  var t1 = this._pixelMapData;
  if ($.ltB(c1r, 0)) var t2 = 0;
  else {
    t2 = $.gtB(c1r, 255) ? 255 : c1r;
  }
  $.indexSet(t1, 0, t2);
  if ($.ltB(c1g, 0)) t2 = 0;
  else {
    t2 = $.gtB(c1g, 255) ? 255 : c1g;
  }
  $.indexSet(t1, 1, t2);
  if ($.ltB(c1b, 0)) t2 = 0;
  else {
    t2 = $.gtB(c1b, 255) ? 255 : c1b;
  }
  $.indexSet(t1, 2, t2);
  if ($.ltB(c2r, 0)) t2 = 0;
  else {
    t2 = $.gtB(c2r, 255) ? 255 : c2r;
  }
  $.indexSet(t1, 4, t2);
  if ($.ltB(c2g, 0)) t2 = 0;
  else {
    t2 = $.gtB(c2g, 255) ? 255 : c2g;
  }
  $.indexSet(t1, 5, t2);
  if ($.ltB(c2b, 0)) t2 = 0;
  else {
    t2 = $.gtB(c2b, 255) ? 255 : c2b;
  }
  $.indexSet(t1, 6, t2);
  if ($.ltB(c3r, 0)) t2 = 0;
  else {
    t2 = $.gtB(c3r, 255) ? 255 : c3r;
  }
  $.indexSet(t1, 8, t2);
  if ($.ltB(c3g, 0)) t2 = 0;
  else {
    t2 = $.gtB(c3g, 255) ? 255 : c3g;
  }
  $.indexSet(t1, 9, t2);
  if ($.ltB(c3b, 0)) t2 = 0;
  else {
    t2 = $.gtB(c3b, 255) ? 255 : c3b;
  }
  $.indexSet(t1, 10, t2);
  if ($.ltB(c4r, 0)) t2 = 0;
  else {
    t2 = $.gtB(c4r, 255) ? 255 : c4r;
  }
  $.indexSet(t1, 12, t2);
  if ($.ltB(c4g, 0)) t2 = 0;
  else {
    t2 = $.gtB(c4g, 255) ? 255 : c4g;
  }
  $.indexSet(t1, 13, t2);
  if ($.ltB(c4b, 0)) t2 = 0;
  else {
    t2 = $.gtB(c4b, 255) ? 255 : c4b;
  }
  $.indexSet(t1, 14, t2);
  this._pixelMapContext.putImageData$3(this._pixelMapImage, 0, 0);
  this._gradientMapContext.drawImage$3(this._pixelMap, 0, 0);
  return this._gradientMap;
 },
 clipImage$13: function(x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, image) {
  var width = $.sub(image.get$width(), 1);
  var height = $.sub(image.get$height(), 1);
  u0 = $.mul(u0, width);
  v0 = $.mul(v0, height);
  u1 = $.mul(u1, width);
  v1 = $.mul(v1, height);
  u2 = $.mul(u2, width);
  v2 = $.mul(v2, height);
  x1 = $.sub(x1, x0);
  y1 = $.sub(y1, y0);
  x2 = $.sub(x2, x0);
  y2 = $.sub(y2, y0);
  u1 = $.sub(u1, u0);
  v1 = $.sub(v1, v0);
  u2 = $.sub(u2, u0);
  v2 = $.sub(v2, v0);
  var det = $.sub($.mul(u1, v2), $.mul(u2, v1));
  if (typeof det !== 'number') throw $.iae(det);
  var idet = 1 / det;
  var a = $.mul($.sub($.mul(v2, x1), $.mul(v1, x2)), idet);
  var b = $.mul($.sub($.mul(v2, y1), $.mul(v1, y2)), idet);
  var c = $.mul($.sub($.mul(u1, x2), $.mul(u2, x1)), idet);
  var d = $.mul($.sub($.mul(u1, y2), $.mul(u2, y1)), idet);
  var e = $.sub($.sub(x0, $.mul(a, u0)), $.mul(c, v0));
  var f = $.sub($.sub(y0, $.mul(b, u0)), $.mul(d, v0));
  var t1 = this._context;
  t1.save$0();
  t1.transform$6(a, b, c, d, e, f);
  t1.clip$0();
  t1.drawImage$3(image, 0, 0);
  t1.restore$0();
 },
 patternPath$13: function(x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, texture) {
  if ($.eqB(texture.get$image().get$width(), 0)) return;
  if (!$.eqB(texture.get$needsUpdate(), true)) {
    var t1 = this._patterns;
    var t2 = texture.get$id();
    if (t2 !== (t2 | 0)) throw $.iae(t2);
    var t3 = t1.length;
    if (t2 < 0 || t2 >= t3) throw $.ioore(t2);
    var t4 = t1[t2] == null;
    t1 = t4;
  } else t1 = true;
  if (t1) {
    var repeatX = $.eqB(texture.get$wrapS(), 0);
    var repeatY = $.eqB(texture.get$wrapT(), 0);
    t1 = this._patterns;
    t2 = texture.get$id();
    t3 = this._context;
    t4 = texture.get$image();
    if (repeatX && repeatY) var t5 = 'repeat';
    else {
      if (repeatX && !repeatY) t5 = 'repeat-x';
      else {
        t5 = !repeatX && repeatY ? 'repeat-y' : 'no-repeat';
      }
    }
    t5 = t3.createPattern$2(t4, t5);
    if (t2 !== (t2 | 0)) throw $.iae(t2);
    t4 = t1.length;
    if (t2 < 0 || t2 >= t4) throw $.ioore(t2);
    t1[t2] = t5;
    texture.set$needsUpdate(false);
  }
  t1 = this._patterns;
  t2 = texture.get$id();
  if (t2 !== (t2 | 0)) throw $.iae(t2);
  t3 = t1.length;
  if (t2 < 0 || t2 >= t3) throw $.ioore(t2);
  this.setFillStyle$1(t1[t2]);
  var offsetX = $.div(texture.get$offset().get$x(), texture.get$repeat().get$x());
  var offsetY = $.div(texture.get$offset().get$y(), texture.get$repeat().get$y());
  var width = $.mul(texture.get$image().get$width(), texture.get$repeat().get$x());
  var height = $.mul(texture.get$image().get$height(), texture.get$repeat().get$y());
  var u00 = $.mul($.add(u0, offsetX), width);
  var v00 = $.mul($.add(v0, offsetY), height);
  var u10 = $.mul($.add(u1, offsetX), width);
  var v10 = $.mul($.add(v1, offsetY), height);
  var u20 = $.mul($.add(u2, offsetX), width);
  var v20 = $.mul($.add(v2, offsetY), height);
  x1 = $.sub(x1, x0);
  y1 = $.sub(y1, y0);
  x2 = $.sub(x2, x0);
  y2 = $.sub(y2, y0);
  u10 = $.sub(u10, u00);
  v10 = $.sub(v10, v00);
  u20 = $.sub(u20, u00);
  v20 = $.sub(v20, v00);
  var det = $.sub($.mul(u10, v20), $.mul(u20, v10));
  if ($.eqB(det, 0)) {
    t1 = this._imagedatas;
    t2 = texture.get$id();
    if (t2 !== (t2 | 0)) throw $.iae(t2);
    t3 = t1.length;
    if (t2 < 0 || t2 >= t3) throw $.ioore(t2);
    if (t1[t2] == null) {
      var canvas = $._ElementFactoryProvider_Element$tag('canvas');
      canvas.set$width(texture.get$image().get$width());
      canvas.set$height(texture.get$image().get$height());
      var context = canvas.getContext$1('2d');
      context.drawImage$3(texture.get$image(), 0, 0);
      t2 = texture.get$id();
      t3 = context.getImageData$4(0, 0, texture.get$image().get$width(), texture.get$image().get$height()).get$data();
      if (t2 !== (t2 | 0)) throw $.iae(t2);
      t4 = t1.length;
      if (t2 < 0 || t2 >= t4) throw $.ioore(t2);
      t1[t2] = t3;
    }
    t2 = texture.get$id();
    if (t2 !== (t2 | 0)) throw $.iae(t2);
    t3 = t1.length;
    if (t2 < 0 || t2 >= t3) throw $.ioore(t2);
    var data = t1[t2];
    var index = $.mul($.add($.floor(u00), $.mul($.floor(v00), texture.get$image().get$width())), 4);
    t2 = this._color;
    t2.setRGB$3($.div($.index(data, index), 255), $.div($.index(data, $.add(index, 1)), 255), $.div($.index(data, $.add(index, 2)), 255));
    this.fillPath$1(t2);
    return;
  }
  if (typeof det !== 'number') throw $.iae(det);
  var idet = 1 / det;
  var a = $.mul($.sub($.mul(v20, x1), $.mul(v10, x2)), idet);
  var b = $.mul($.sub($.mul(v20, y1), $.mul(v10, y2)), idet);
  var c = $.mul($.sub($.mul(u10, x2), $.mul(u20, x1)), idet);
  var d = $.mul($.sub($.mul(u10, y2), $.mul(u20, y1)), idet);
  var e = $.sub($.sub(x0, $.mul(a, u00)), $.mul(c, v00));
  var f = $.sub($.sub(y0, $.mul(b, u00)), $.mul(d, v00));
  t1 = this._context;
  t1.save$0();
  t1.transform$6(a, b, c, d, e, f);
  t1.fill$0();
  t1.restore$0();
 },
 fillPath$1: function(color) {
  this.setFillStyle$1(color.getContextStyle$0());
  this._context.fill$0();
 },
 strokePath$4: function(color, linewidth, linecap, linejoin) {
  this.setLineWidth$1(linewidth);
  this.setLineCap$1(linecap);
  this.setLineJoin$1(linejoin);
  this.setStrokeStyle$1(color.getContextStyle$0());
  this._context.stroke$0();
  this._bboxRect.inflate$1($.mul(linewidth, 2));
 },
 drawQuad$8: function(x0, y0, x1, y1, x2, y2, x3, y3) {
  var t1 = this._context;
  t1.beginPath$0();
  t1.moveTo$2(x0, y0);
  t1.lineTo$2(x1, y1);
  t1.lineTo$2(x2, y2);
  t1.lineTo$2(x3, y3);
  t1.lineTo$2(x0, y0);
  t1.closePath$0();
 },
 drawTriangle$6: function(x0, y0, x1, y1, x2, y2) {
  var t1 = this._context;
  t1.beginPath$0();
  t1.moveTo$2(x0, y0);
  t1.lineTo$2(x1, y1);
  t1.lineTo$2(x2, y2);
  t1.lineTo$2(x0, y0);
  t1.closePath$0();
 },
 renderFace4$9: function(v1, v2, v3, v4, v5, v6, element, material, scene) {
  var t1 = this._info;
  var t2 = t1.render;
  var t3 = t2.get$vertices();
  if (typeof t3 !== 'number') return this.renderFace4$9$bailout(1, v1, v2, v3, v4, v5, v6, element, material, scene, t1, t2, t3);
  t2.set$vertices(t3 + 4);
  var t5 = t2.get$faces();
  if (typeof t5 !== 'number') return this.renderFace4$9$bailout(2, v1, v2, v3, v4, v5, v6, element, material, scene, t2, t5, 0);
  t2.set$faces(t5 + 1);
  this.setOpacity$1(material.get$opacity());
  this.setBlending$1(material.get$blending());
  if (typeof material === 'object' && material !== null && !!material.is$ITextureMapMaterial) {
    this.renderFace3$9(v1, v2, v4, 0, 1, 3, element, material, scene);
    this.renderFace3$9(v5, v3, v6, 1, 2, 3, element, material, scene);
    return;
  }
  this._v1x = v1.get$positionScreen().get$x();
  this._v1y = v1.get$positionScreen().get$y();
  this._v2x = v2.get$positionScreen().get$x();
  this._v2y = v2.get$positionScreen().get$y();
  this._v3x = v3.get$positionScreen().get$x();
  this._v3y = v3.get$positionScreen().get$y();
  this._v4x = v4.get$positionScreen().get$x();
  this._v4y = v4.get$positionScreen().get$y();
  this._v5x = v5.get$positionScreen().get$x();
  this._v5y = v5.get$positionScreen().get$y();
  this._v6x = v6.get$positionScreen().get$x();
  this._v6y = v6.get$positionScreen().get$y();
  if (typeof material === 'object' && material !== null && !!material.is$MeshBasicMaterial) {
    this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
    if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
    else this.fillPath$1(material.get$color());
  } else {
    if (typeof material === 'object' && material !== null && !!material.is$MeshLambertMaterial) {
      if (this._enableLighting === true) {
        if (material.get$wireframe() !== true) {
          t1 = material.get$shading();
          if (typeof t1 !== 'number') return this.renderFace4$9$bailout(3, material, t1, element, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          if (t1 === 2) {
            t1 = $.get$length(element.get$vertexNormalsWorld());
            if (typeof t1 !== 'number') return this.renderFace4$9$bailout(4, material, t1, element, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            t1 = t1 === 4;
          } else t1 = false;
        } else t1 = false;
        t2 = this._ambientLight;
        t3 = t2.r;
        if (t1) {
          t1 = this._color4;
          t1.r = t3;
          var t4 = this._color3;
          t4.r = t3;
          t5 = this._color2;
          t5.r = t3;
          var t6 = this._color1;
          t6.r = t3;
          t3 = t2.g;
          t1.g = t3;
          t4.g = t3;
          t5.g = t3;
          t6.g = t3;
          t2 = t2.b;
          t1.b = t2;
          t4.b = t2;
          t5.b = t2;
          t6.b = t2;
          t2 = this._lights;
          t3 = element.get$v1().get$positionWorld();
          var t7 = element.get$vertexNormalsWorld();
          if (typeof t7 !== 'string' && (typeof t7 !== 'object' || t7 === null || (t7.constructor !== Array && !t7.is$JavaScriptIndexingBehavior()))) return this.renderFace4$9$bailout(5, t1, t4, t5, t6, material, element, t7, t3, t2, 0, 0, 0);
          var t9 = t7.length;
          if (0 >= t9) throw $.ioore(0);
          this.calculateLight$4(t2, t3, t7[0], t6);
          t3 = this._lights;
          t2 = element.get$v2().get$positionWorld();
          var t10 = element.get$vertexNormalsWorld();
          if (typeof t10 !== 'string' && (typeof t10 !== 'object' || t10 === null || (t10.constructor !== Array && !t10.is$JavaScriptIndexingBehavior()))) return this.renderFace4$9$bailout(6, t1, t4, t5, t6, material, element, t2, t3, t10, 0, 0, 0);
          var t12 = t10.length;
          if (1 >= t12) throw $.ioore(1);
          this.calculateLight$4(t3, t2, t10[1], t5);
          t2 = this._lights;
          t3 = element.get$v4().get$positionWorld();
          var t13 = element.get$vertexNormalsWorld();
          if (typeof t13 !== 'string' && (typeof t13 !== 'object' || t13 === null || (t13.constructor !== Array && !t13.is$JavaScriptIndexingBehavior()))) return this.renderFace4$9$bailout(7, t1, t4, t5, t6, material, element, t2, t3, t13, 0, 0, 0);
          var t15 = t13.length;
          if (3 >= t15) throw $.ioore(3);
          this.calculateLight$4(t2, t3, t13[3], t4);
          t3 = this._lights;
          t2 = element.get$v3().get$positionWorld();
          var t16 = element.get$vertexNormalsWorld();
          if (typeof t16 !== 'string' && (typeof t16 !== 'object' || t16 === null || (t16.constructor !== Array && !t16.is$JavaScriptIndexingBehavior()))) return this.renderFace4$9$bailout(8, t1, t4, t5, t6, t3, material, t2, t16, 0, 0, 0, 0);
          var t18 = t16.length;
          if (2 >= t18) throw $.ioore(2);
          this.calculateLight$4(t3, t2, t16[2], t1);
          t2 = material.get$color().get$r();
          if (typeof t2 !== 'number') return this.renderFace4$9$bailout(9, t1, t4, t5, t6, t2, material, 0, 0, 0, 0, 0, 0);
          var t19 = t6.r;
          if (typeof t19 !== 'number') return this.renderFace4$9$bailout(10, t1, t4, t5, t6, t2, material, t19, 0, 0, 0, 0, 0);
          t6.r = $.Math_max(0, $.Math_min(t2 * t19, 1));
          var t21 = material.get$color().get$g();
          if (typeof t21 !== 'number') return this.renderFace4$9$bailout(11, t1, t4, t5, t6, material, t21, 0, 0, 0, 0, 0, 0);
          var t23 = t6.g;
          if (typeof t23 !== 'number') return this.renderFace4$9$bailout(12, t1, t4, t5, t6, material, t21, t23, 0, 0, 0, 0, 0);
          t6.g = $.Math_max(0, $.Math_min(t21 * t23, 1));
          var t25 = material.get$color().get$b();
          if (typeof t25 !== 'number') return this.renderFace4$9$bailout(13, t1, t4, t5, t6, material, t25, 0, 0, 0, 0, 0, 0);
          var t27 = t6.b;
          if (typeof t27 !== 'number') return this.renderFace4$9$bailout(14, t1, t4, t5, t6, material, t25, t27, 0, 0, 0, 0, 0);
          t6.b = $.Math_max(0, $.Math_min(t25 * t27, 1));
          var t29 = material.get$color().get$r();
          if (typeof t29 !== 'number') return this.renderFace4$9$bailout(15, t1, t4, t5, t6, material, t29, 0, 0, 0, 0, 0, 0);
          var t31 = t5.r;
          if (typeof t31 !== 'number') return this.renderFace4$9$bailout(16, t1, t4, t5, t6, material, t29, t31, 0, 0, 0, 0, 0);
          t5.r = $.Math_max(0, $.Math_min(t29 * t31, 1));
          var t33 = material.get$color().get$g();
          if (typeof t33 !== 'number') return this.renderFace4$9$bailout(17, t1, t4, t5, t6, t33, material, 0, 0, 0, 0, 0, 0);
          var t35 = t5.g;
          if (typeof t35 !== 'number') return this.renderFace4$9$bailout(18, t1, t4, t5, t6, t33, material, t35, 0, 0, 0, 0, 0);
          t5.g = $.Math_max(0, $.Math_min(t33 * t35, 1));
          var t37 = material.get$color().get$b();
          if (typeof t37 !== 'number') return this.renderFace4$9$bailout(19, t1, t4, t5, t6, material, t37, 0, 0, 0, 0, 0, 0);
          var t39 = t5.b;
          if (typeof t39 !== 'number') return this.renderFace4$9$bailout(20, t1, t4, t5, t6, material, t37, t39, 0, 0, 0, 0, 0);
          t5.b = $.Math_max(0, $.Math_min(t37 * t39, 1));
          var t41 = material.get$color().get$r();
          if (typeof t41 !== 'number') return this.renderFace4$9$bailout(21, t1, t4, t5, t6, material, t41, 0, 0, 0, 0, 0, 0);
          var t43 = t4.r;
          if (typeof t43 !== 'number') return this.renderFace4$9$bailout(22, t1, t4, t5, t6, material, t41, t43, 0, 0, 0, 0, 0);
          t4.r = $.Math_max(0, $.Math_min(t41 * t43, 1));
          var t45 = material.get$color().get$g();
          if (typeof t45 !== 'number') return this.renderFace4$9$bailout(23, t1, t4, t5, t6, material, t45, 0, 0, 0, 0, 0, 0);
          var t47 = t4.g;
          if (typeof t47 !== 'number') return this.renderFace4$9$bailout(24, t1, t4, t5, t6, material, t45, t47, 0, 0, 0, 0, 0);
          t4.g = $.Math_max(0, $.Math_min(t45 * t47, 1));
          var t49 = material.get$color().get$b();
          if (typeof t49 !== 'number') return this.renderFace4$9$bailout(25, t1, t4, t5, t6, t49, material, 0, 0, 0, 0, 0, 0);
          var t51 = t4.b;
          if (typeof t51 !== 'number') return this.renderFace4$9$bailout(26, t1, t4, t5, t6, t49, material, t51, 0, 0, 0, 0, 0);
          t4.b = $.Math_max(0, $.Math_min(t49 * t51, 1));
          var t53 = material.get$color().get$r();
          if (typeof t53 !== 'number') return this.renderFace4$9$bailout(27, t1, t4, t5, t6, material, t53, 0, 0, 0, 0, 0, 0);
          var t55 = t1.r;
          if (typeof t55 !== 'number') return this.renderFace4$9$bailout(28, t1, t4, t5, t6, material, t53, t55, 0, 0, 0, 0, 0);
          t1.r = $.Math_max(0, $.Math_min(t53 * t55, 1));
          var t57 = material.get$color().get$g();
          if (typeof t57 !== 'number') return this.renderFace4$9$bailout(29, t1, t4, t5, t6, material, t57, 0, 0, 0, 0, 0, 0);
          var t59 = t1.g;
          if (typeof t59 !== 'number') return this.renderFace4$9$bailout(30, t1, t4, t5, t6, material, t57, t59, 0, 0, 0, 0, 0);
          t1.g = $.Math_max(0, $.Math_min(t57 * t59, 1));
          var t61 = material.get$color().get$b();
          if (typeof t61 !== 'number') return this.renderFace4$9$bailout(31, t1, t4, t5, t6, t61, 0, 0, 0, 0, 0, 0, 0);
          var t63 = t1.b;
          if (typeof t63 !== 'number') return this.renderFace4$9$bailout(32, t1, t4, t5, t6, t61, t63, 0, 0, 0, 0, 0, 0);
          t1.b = $.Math_max(0, $.Math_min(t61 * t63, 1));
          this._image = this.getGradientTexture$4(t6, t5, t4, t1);
          this.drawTriangle$6(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y);
          this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y, 0, 0, 1, 0, 0, 1, this._image);
          this.drawTriangle$6(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y);
          this.clipImage$13(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y, 1, 0, 1, 1, 0, 1, this._image);
        } else {
          t1 = this._color;
          t1.r = t3;
          t1.g = t2.g;
          t1.b = t2.b;
          this.calculateLight$4(this._lights, element.get$centroidWorld(), element.get$normalWorld(), t1);
          t3 = material.get$color().get$r();
          if (typeof t3 !== 'number') return this.renderFace4$9$bailout(33, material, t1, t3, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t5 = t1.r;
          if (typeof t5 !== 'number') return this.renderFace4$9$bailout(34, t5, material, t1, t3, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.r = $.Math_max(0, $.Math_min(t3 * t5, 1));
          t7 = material.get$color().get$g();
          if (typeof t7 !== 'number') return this.renderFace4$9$bailout(35, material, t7, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t9 = t1.g;
          if (typeof t9 !== 'number') return this.renderFace4$9$bailout(36, material, t7, t9, t1, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.g = $.Math_max(0, $.Math_min(t7 * t9, 1));
          var t11 = material.get$color().get$b();
          if (typeof t11 !== 'number') return this.renderFace4$9$bailout(37, material, t1, t11, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t13 = t1.b;
          if (typeof t13 !== 'number') return this.renderFace4$9$bailout(38, t13, material, t1, t11, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.b = $.Math_max(0, $.Math_min(t11 * t13, 1));
          this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
          if (material.get$wireframe() === true) this.strokePath$4(t1, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
          else this.fillPath$1(t1);
        }
      } else {
        this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
        if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
        else this.fillPath$1(material.get$color());
      }
    } else {
      if (typeof material === 'object' && material !== null && !!material.is$MeshNormalMaterial) {
        t1 = this.normalToComponent$1(element.get$normalWorld().get$x());
        t2 = this._color;
        t2.r = t1;
        t2.g = this.normalToComponent$1(element.get$normalWorld().get$y());
        t2.b = this.normalToComponent$1(element.get$normalWorld().get$z());
        this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
        if (material.get$wireframe() === true) this.strokePath$4(t2, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
        else this.fillPath$1(t2);
      } else {
        if (typeof material === 'object' && material !== null && !!material.is$MeshDepthMaterial) {
          this._near = this._camera.get$near();
          this._far = this._camera.get$far();
          t1 = this.smoothstep$3(v1.get$positionScreen().get$z(), this._near, this._far);
          if (typeof t1 !== 'number') throw $.iae(t1);
          t1 = 1 - t1;
          t2 = this._color1;
          t2.b = t1;
          t2.g = t1;
          t2.r = t1;
          t1 = this.smoothstep$3(v2.get$positionScreen().get$z(), this._near, this._far);
          if (typeof t1 !== 'number') throw $.iae(t1);
          t1 = 1 - t1;
          t3 = this._color2;
          t3.b = t1;
          t3.g = t1;
          t3.r = t1;
          t1 = this.smoothstep$3(v4.get$positionScreen().get$z(), this._near, this._far);
          if (typeof t1 !== 'number') throw $.iae(t1);
          t1 = 1 - t1;
          t4 = this._color3;
          t4.b = t1;
          t4.g = t1;
          t4.r = t1;
          t1 = this.smoothstep$3(v3.get$positionScreen().get$z(), this._near, this._far);
          if (typeof t1 !== 'number') throw $.iae(t1);
          t1 = 1 - t1;
          t5 = this._color4;
          t5.b = t1;
          t5.g = t1;
          t5.r = t1;
          this._image = this.getGradientTexture$4(t2, t3, t4, t5);
          this.drawTriangle$6(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y);
          this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y, 0, 0, 1, 0, 0, 1, this._image);
          this.drawTriangle$6(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y);
          this.clipImage$13(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y, 1, 0, 1, 1, 0, 1, this._image);
        }
      }
    }
  }
 },
 renderFace4$9$bailout: function(state, env0, env1, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      var v3 = env2;
      var v4 = env3;
      var v5 = env4;
      var v6 = env5;
      var element = env6;
      var material = env7;
      var scene = env8;
      t1 = env9;
      t2 = env10;
      t3 = env11;
      break;
    case 2:
      v1 = env0;
      v2 = env1;
      v3 = env2;
      v4 = env3;
      v5 = env4;
      v6 = env5;
      element = env6;
      material = env7;
      scene = env8;
      t1 = env9;
      t2 = env10;
      break;
    case 3:
      material = env0;
      t1 = env1;
      element = env2;
      break;
    case 4:
      material = env0;
      t1 = env1;
      element = env2;
      break;
    case 5:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      element = env5;
      t7 = env6;
      t1 = env7;
      t2 = env8;
      break;
    case 6:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      element = env5;
      t2 = env6;
      t1 = env7;
      t9 = env8;
      break;
    case 7:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      element = env5;
      t2 = env6;
      t1 = env7;
      t11 = env8;
      break;
    case 8:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t1 = env4;
      material = env5;
      t2 = env6;
      t13 = env7;
      break;
    case 9:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t2 = env4;
      material = env5;
      break;
    case 10:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t2 = env4;
      material = env5;
      t15 = env6;
      break;
    case 11:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t17 = env5;
      break;
    case 12:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t17 = env5;
      t19 = env6;
      break;
    case 13:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t21 = env5;
      break;
    case 14:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t21 = env5;
      t23 = env6;
      break;
    case 15:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t25 = env5;
      break;
    case 16:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t25 = env5;
      t27 = env6;
      break;
    case 17:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t29 = env4;
      material = env5;
      break;
    case 18:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t29 = env4;
      material = env5;
      t31 = env6;
      break;
    case 19:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t33 = env5;
      break;
    case 20:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t33 = env5;
      t35 = env6;
      break;
    case 21:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t37 = env5;
      break;
    case 22:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t37 = env5;
      t39 = env6;
      break;
    case 23:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t41 = env5;
      break;
    case 24:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t41 = env5;
      t43 = env6;
      break;
    case 25:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t45 = env4;
      material = env5;
      break;
    case 26:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t45 = env4;
      material = env5;
      t47 = env6;
      break;
    case 27:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t49 = env5;
      break;
    case 28:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t49 = env5;
      t51 = env6;
      break;
    case 29:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t53 = env5;
      break;
    case 30:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      material = env4;
      t53 = env5;
      t55 = env6;
      break;
    case 31:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t57 = env4;
      break;
    case 32:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t6 = env3;
      t57 = env4;
      t59 = env5;
      break;
    case 33:
      material = env0;
      t3 = env1;
      t1 = env2;
      break;
    case 34:
      t5 = env0;
      material = env1;
      t3 = env2;
      t1 = env3;
      break;
    case 35:
      material = env0;
      t7 = env1;
      t3 = env2;
      break;
    case 36:
      material = env0;
      t7 = env1;
      t9 = env2;
      t3 = env3;
      break;
    case 37:
      material = env0;
      t3 = env1;
      t11 = env2;
      break;
    case 38:
      t13 = env0;
      material = env1;
      t3 = env2;
      t11 = env3;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._info;
      var t2 = t1.get$render();
      var t3 = t2.get$vertices();
    case 1:
      state = 0;
      t2.set$vertices($.add(t3, 4));
      t1 = t1.get$render();
      t2 = t1.get$faces();
    case 2:
      state = 0;
      t1.set$faces($.add(t2, 1));
      this.setOpacity$1(material.get$opacity());
      this.setBlending$1(material.get$blending());
      if (typeof material === 'object' && material !== null && !!material.is$ITextureMapMaterial) {
        this.renderFace3$9(v1, v2, v4, 0, 1, 3, element, material, scene);
        this.renderFace3$9(v5, v3, v6, 1, 2, 3, element, material, scene);
        return;
      }
      this._v1x = v1.get$positionScreen().get$x();
      this._v1y = v1.get$positionScreen().get$y();
      this._v2x = v2.get$positionScreen().get$x();
      this._v2y = v2.get$positionScreen().get$y();
      this._v3x = v3.get$positionScreen().get$x();
      this._v3y = v3.get$positionScreen().get$y();
      this._v4x = v4.get$positionScreen().get$x();
      this._v4y = v4.get$positionScreen().get$y();
      this._v5x = v5.get$positionScreen().get$x();
      this._v5y = v5.get$positionScreen().get$y();
      this._v6x = v6.get$positionScreen().get$x();
      this._v6y = v6.get$positionScreen().get$y();
    default:
      if ((state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$MeshBasicMaterial))) {
        this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
        if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
        else this.fillPath$1(material.get$color());
      } else {
        switch (state) {
          case 0:
          default:
            if (state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || state == 25 || state == 26 || state == 27 || state == 28 || state == 29 || state == 30 || state == 31 || state == 32 || state == 33 || state == 34 || state == 35 || state == 36 || state == 37 || state == 38 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$MeshLambertMaterial))) {
              switch (state) {
                case 0:
                default:
                  if (state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || state == 25 || state == 26 || state == 27 || state == 28 || state == 29 || state == 30 || state == 31 || state == 32 || state == 33 || state == 34 || state == 35 || state == 36 || state == 37 || state == 38 || (state == 0 && this._enableLighting === true)) {
                    switch (state) {
                      case 0:
                      default:
                        if (state == 3 || state == 4 || (state == 0 && material.get$wireframe() !== true)) {
                          switch (state) {
                            case 0:
                              t1 = material.get$shading();
                            case 3:
                              state = 0;
                            case 4:
                              if (state == 4 || (state == 0 && $.eqB(t1, 2))) {
                                switch (state) {
                                  case 0:
                                    t1 = $.get$length(element.get$vertexNormalsWorld());
                                  case 4:
                                    state = 0;
                                    t1 = $.eqB(t1, 4);
                                }
                              } else {
                                t1 = false;
                              }
                          }
                        } else {
                          t1 = false;
                        }
                        t2 = this._ambientLight;
                      case 5:
                      case 6:
                      case 7:
                      case 8:
                      case 9:
                      case 10:
                      case 11:
                      case 12:
                      case 13:
                      case 14:
                      case 15:
                      case 16:
                      case 17:
                      case 18:
                      case 19:
                      case 20:
                      case 21:
                      case 22:
                      case 23:
                      case 24:
                      case 25:
                      case 26:
                      case 27:
                      case 28:
                      case 29:
                      case 30:
                      case 31:
                      case 32:
                      case 33:
                      case 34:
                      case 35:
                      case 36:
                      case 37:
                      case 38:
                        if (state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || state == 25 || state == 26 || state == 27 || state == 28 || state == 29 || state == 30 || state == 31 || state == 32 || (state == 0 && t1)) {
                          switch (state) {
                            case 0:
                              t1 = t2.get$r();
                              t3 = this._color4;
                              t3.set$r(t1);
                              var t4 = this._color3;
                              t4.set$r(t1);
                              var t5 = this._color2;
                              t5.set$r(t1);
                              var t6 = this._color1;
                              t6.set$r(t1);
                              t1 = t2.get$g();
                              t3.set$g(t1);
                              t4.set$g(t1);
                              t5.set$g(t1);
                              t6.set$g(t1);
                              t2 = t2.get$b();
                              t3.set$b(t2);
                              t4.set$b(t2);
                              t5.set$b(t2);
                              t6.set$b(t2);
                              t2 = this._lights;
                              t1 = element.get$v1().get$positionWorld();
                              var t7 = element.get$vertexNormalsWorld();
                            case 5:
                              state = 0;
                              this.calculateLight$4(t2, t1, $.index(t7, 0), t6);
                              t1 = this._lights;
                              t2 = element.get$v2().get$positionWorld();
                              var t9 = element.get$vertexNormalsWorld();
                            case 6:
                              state = 0;
                              this.calculateLight$4(t1, t2, $.index(t9, 1), t5);
                              t2 = this._lights;
                              t1 = element.get$v4().get$positionWorld();
                              var t11 = element.get$vertexNormalsWorld();
                            case 7:
                              state = 0;
                              this.calculateLight$4(t2, t1, $.index(t11, 3), t4);
                              t1 = this._lights;
                              t2 = element.get$v3().get$positionWorld();
                              var t13 = element.get$vertexNormalsWorld();
                            case 8:
                              state = 0;
                              this.calculateLight$4(t1, t2, $.index(t13, 2), t3);
                              t2 = material.get$color().get$r();
                            case 9:
                              state = 0;
                              var t15 = t6.get$r();
                            case 10:
                              state = 0;
                              t6.set$r($.Math_max(0, $.Math_min($.mul(t2, t15), 1)));
                              var t17 = material.get$color().get$g();
                            case 11:
                              state = 0;
                              var t19 = t6.get$g();
                            case 12:
                              state = 0;
                              t6.set$g($.Math_max(0, $.Math_min($.mul(t17, t19), 1)));
                              var t21 = material.get$color().get$b();
                            case 13:
                              state = 0;
                              var t23 = t6.get$b();
                            case 14:
                              state = 0;
                              t6.set$b($.Math_max(0, $.Math_min($.mul(t21, t23), 1)));
                              var t25 = material.get$color().get$r();
                            case 15:
                              state = 0;
                              var t27 = t5.get$r();
                            case 16:
                              state = 0;
                              t5.set$r($.Math_max(0, $.Math_min($.mul(t25, t27), 1)));
                              var t29 = material.get$color().get$g();
                            case 17:
                              state = 0;
                              var t31 = t5.get$g();
                            case 18:
                              state = 0;
                              t5.set$g($.Math_max(0, $.Math_min($.mul(t29, t31), 1)));
                              var t33 = material.get$color().get$b();
                            case 19:
                              state = 0;
                              var t35 = t5.get$b();
                            case 20:
                              state = 0;
                              t5.set$b($.Math_max(0, $.Math_min($.mul(t33, t35), 1)));
                              var t37 = material.get$color().get$r();
                            case 21:
                              state = 0;
                              var t39 = t4.get$r();
                            case 22:
                              state = 0;
                              t4.set$r($.Math_max(0, $.Math_min($.mul(t37, t39), 1)));
                              var t41 = material.get$color().get$g();
                            case 23:
                              state = 0;
                              var t43 = t4.get$g();
                            case 24:
                              state = 0;
                              t4.set$g($.Math_max(0, $.Math_min($.mul(t41, t43), 1)));
                              var t45 = material.get$color().get$b();
                            case 25:
                              state = 0;
                              var t47 = t4.get$b();
                            case 26:
                              state = 0;
                              t4.set$b($.Math_max(0, $.Math_min($.mul(t45, t47), 1)));
                              var t49 = material.get$color().get$r();
                            case 27:
                              state = 0;
                              var t51 = t3.get$r();
                            case 28:
                              state = 0;
                              t3.set$r($.Math_max(0, $.Math_min($.mul(t49, t51), 1)));
                              var t53 = material.get$color().get$g();
                            case 29:
                              state = 0;
                              var t55 = t3.get$g();
                            case 30:
                              state = 0;
                              t3.set$g($.Math_max(0, $.Math_min($.mul(t53, t55), 1)));
                              var t57 = material.get$color().get$b();
                            case 31:
                              state = 0;
                              var t59 = t3.get$b();
                            case 32:
                              state = 0;
                              t3.set$b($.Math_max(0, $.Math_min($.mul(t57, t59), 1)));
                              this._image = this.getGradientTexture$4(t6, t5, t4, t3);
                              this.drawTriangle$6(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y);
                              this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y, 0, 0, 1, 0, 0, 1, this._image);
                              this.drawTriangle$6(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y);
                              this.clipImage$13(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y, 1, 0, 1, 1, 0, 1, this._image);
                          }
                        } else {
                          switch (state) {
                            case 0:
                              t1 = t2.get$r();
                              t3 = this._color;
                              t3.set$r(t1);
                              t3.set$g(t2.get$g());
                              t3.set$b(t2.get$b());
                              this.calculateLight$4(this._lights, element.get$centroidWorld(), element.get$normalWorld(), t3);
                              t1 = material.get$color().get$r();
                            case 33:
                              state = 0;
                              t5 = t3.get$r();
                            case 34:
                              state = 0;
                              t3.set$r($.Math_max(0, $.Math_min($.mul(t1, t5), 1)));
                              t7 = material.get$color().get$g();
                            case 35:
                              state = 0;
                              t9 = t3.get$g();
                            case 36:
                              state = 0;
                              t3.set$g($.Math_max(0, $.Math_min($.mul(t7, t9), 1)));
                              t11 = material.get$color().get$b();
                            case 37:
                              state = 0;
                              t13 = t3.get$b();
                            case 38:
                              state = 0;
                              t3.set$b($.Math_max(0, $.Math_min($.mul(t11, t13), 1)));
                              this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
                              if (material.get$wireframe() === true) this.strokePath$4(t3, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                              else this.fillPath$1(t3);
                          }
                        }
                    }
                  } else {
                    this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
                    if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                    else this.fillPath$1(material.get$color());
                  }
              }
            } else {
              if (typeof material === 'object' && material !== null && !!material.is$MeshNormalMaterial) {
                t1 = this.normalToComponent$1(element.get$normalWorld().get$x());
                t2 = this._color;
                t2.set$r(t1);
                t2.set$g(this.normalToComponent$1(element.get$normalWorld().get$y()));
                t2.set$b(this.normalToComponent$1(element.get$normalWorld().get$z()));
                this.drawQuad$8(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._v4x, this._v4y);
                if (material.get$wireframe() === true) this.strokePath$4(t2, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                else this.fillPath$1(t2);
              } else {
                if (typeof material === 'object' && material !== null && !!material.is$MeshDepthMaterial) {
                  this._near = this._camera.get$near();
                  this._far = this._camera.get$far();
                  t1 = this.smoothstep$3(v1.get$positionScreen().get$z(), this._near, this._far);
                  if (typeof t1 !== 'number') throw $.iae(t1);
                  t1 = 1 - t1;
                  t2 = this._color1;
                  t2.set$b(t1);
                  t2.set$g(t1);
                  t2.set$r(t1);
                  t1 = this.smoothstep$3(v2.get$positionScreen().get$z(), this._near, this._far);
                  if (typeof t1 !== 'number') throw $.iae(t1);
                  t1 = 1 - t1;
                  t3 = this._color2;
                  t3.set$b(t1);
                  t3.set$g(t1);
                  t3.set$r(t1);
                  t1 = this.smoothstep$3(v4.get$positionScreen().get$z(), this._near, this._far);
                  if (typeof t1 !== 'number') throw $.iae(t1);
                  t1 = 1 - t1;
                  t4 = this._color3;
                  t4.set$b(t1);
                  t4.set$g(t1);
                  t4.set$r(t1);
                  t1 = this.smoothstep$3(v3.get$positionScreen().get$z(), this._near, this._far);
                  if (typeof t1 !== 'number') throw $.iae(t1);
                  t1 = 1 - t1;
                  t5 = this._color4;
                  t5.set$b(t1);
                  t5.set$g(t1);
                  t5.set$r(t1);
                  this._image = this.getGradientTexture$4(t2, t3, t4, t5);
                  this.drawTriangle$6(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y);
                  this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v4x, this._v4y, 0, 0, 1, 0, 0, 1, this._image);
                  this.drawTriangle$6(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y);
                  this.clipImage$13(this._v5x, this._v5y, this._v3x, this._v3y, this._v6x, this._v6y, 1, 0, 1, 1, 0, 1, this._image);
                }
              }
            }
        }
      }
  }
 },
 renderFace3$9: function(v1, v2, v3, uv1, uv2, uv3, element, material, scene) {
  var t1 = this._info;
  var t2 = t1.render;
  var t3 = t2.get$vertices();
  if (typeof t3 !== 'number') return this.renderFace3$9$bailout(1, v1, v2, v3, uv1, uv2, uv3, element, material, t1, t2, t3, 0, 0, 0, 0);
  t2.set$vertices(t3 + 3);
  var t5 = t2.get$faces();
  if (typeof t5 !== 'number') return this.renderFace3$9$bailout(2, v1, v2, v3, uv1, uv2, uv3, element, material, t2, t5, 0, 0, 0, 0, 0);
  t2.set$faces(t5 + 1);
  this.setOpacity$1(material.get$opacity());
  this.setBlending$1(material.get$blending());
  this._v1x = v1.get$positionScreen().get$x();
  this._v1y = v1.get$positionScreen().get$y();
  this._v2x = v2.get$positionScreen().get$x();
  this._v2y = v2.get$positionScreen().get$y();
  this._v3x = v3.get$positionScreen().get$x();
  this._v3y = v3.get$positionScreen().get$y();
  this.drawTriangle$6(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y);
  if (typeof material === 'object' && material !== null && !!material.is$MeshBasicMaterial) {
    if (!(material.get$map() == null)) {
      t1 = material.get$map().get$mapping();
      if (typeof t1 === 'object' && t1 !== null && !!t1.is$UVMapping) {
        t1 = element.get$uvs();
        if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(3, t1, uv1, uv2, uv3, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t3 = t1.length;
        if (0 >= t3) throw $.ioore(0);
        this._uvs = t1[0];
        var t4 = this._v1x;
        t5 = this._v1y;
        var t6 = this._v2x;
        var t7 = this._v2y;
        var t8 = this._v3x;
        var t9 = this._v3y;
        var t10 = this._uvs;
        if (typeof t10 !== 'string' && (typeof t10 !== 'object' || t10 === null || (t10.constructor !== Array && !t10.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(4, uv1, uv2, uv3, t5, t4, t7, t6, t9, t8, t10, material, 0, 0, 0, 0);
        if (uv1 !== (uv1 | 0)) throw $.iae(uv1);
        var t12 = t10.length;
        if (uv1 < 0 || uv1 >= t12) throw $.ioore(uv1);
        var t13 = t10[uv1].get$u();
        var t14 = this._uvs;
        if (typeof t14 !== 'string' && (typeof t14 !== 'object' || t14 === null || (t14.constructor !== Array && !t14.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(5, uv1, uv2, uv3, t4, t5, t6, t7, t8, t9, t13, t14, material, 0, 0, 0);
        var t16 = t14.length;
        if (uv1 < 0 || uv1 >= t16) throw $.ioore(uv1);
        var t17 = t14[uv1].get$v();
        var t18 = this._uvs;
        if (typeof t18 !== 'string' && (typeof t18 !== 'object' || t18 === null || (t18.constructor !== Array && !t18.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(6, uv2, uv3, t4, t5, t6, t7, t8, t9, t13, t17, t18, material, 0, 0, 0);
        if (uv2 !== (uv2 | 0)) throw $.iae(uv2);
        var t20 = t18.length;
        if (uv2 < 0 || uv2 >= t20) throw $.ioore(uv2);
        var t21 = t18[uv2].get$u();
        var t22 = this._uvs;
        if (typeof t22 !== 'string' && (typeof t22 !== 'object' || t22 === null || (t22.constructor !== Array && !t22.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(7, material, uv2, uv3, t4, t5, t6, t7, t8, t9, t13, t17, t22, t21, 0, 0);
        var t24 = t22.length;
        if (uv2 < 0 || uv2 >= t24) throw $.ioore(uv2);
        var t25 = t22[uv2].get$v();
        var t26 = this._uvs;
        if (typeof t26 !== 'string' && (typeof t26 !== 'object' || t26 === null || (t26.constructor !== Array && !t26.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(8, t21, t25, uv3, t4, t5, t6, t7, t8, t9, t13, t17, t26, material, 0, 0);
        if (uv3 !== (uv3 | 0)) throw $.iae(uv3);
        var t28 = t26.length;
        if (uv3 < 0 || uv3 >= t28) throw $.ioore(uv3);
        var t29 = t26[uv3].get$u();
        var t30 = this._uvs;
        if (typeof t30 !== 'string' && (typeof t30 !== 'object' || t30 === null || (t30.constructor !== Array && !t30.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(9, t30, t21, t25, uv3, t29, t4, t5, t6, t7, t8, t9, t13, t17, material, 0);
        var t32 = t30.length;
        if (uv3 < 0 || uv3 >= t32) throw $.ioore(uv3);
        this.patternPath$13(t4, t5, t6, t7, t8, t9, t13, t17, t21, t25, t29, t30[uv3].get$v(), material.get$map());
      }
    } else {
      if (!(null == material.get$envMap())) {
        t1 = material.get$envMap().get$mapping();
        if (typeof t1 === 'object' && t1 !== null && !!t1.is$SphericalReflectionMapping) {
          var cameraMatrix = this._camera.get$matrixWorldInverse();
          t1 = this._vector3;
          t2 = element.get$vertexNormalsWorld();
          if (typeof t2 !== 'string' && (typeof t2 !== 'object' || t2 === null || (t2.constructor !== Array && !t2.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(10, cameraMatrix, t1, t2, uv2, uv3, element, uv1, material, 0, 0, 0, 0, 0, 0, 0);
          if (uv1 !== (uv1 | 0)) throw $.iae(uv1);
          t4 = t2.length;
          if (uv1 < 0 || uv1 >= t4) throw $.ioore(uv1);
          t1.copy$1(t2[uv1]);
          t5 = t1.get$x();
          if (typeof t5 !== 'number') return this.renderFace3$9$bailout(11, cameraMatrix, t1, uv2, uv3, element, t5, material, 0, 0, 0, 0, 0, 0, 0, 0);
          t7 = cameraMatrix.get$n11();
          if (typeof t7 !== 'number') return this.renderFace3$9$bailout(12, cameraMatrix, t1, uv2, uv3, element, t5, t7, material, 0, 0, 0, 0, 0, 0, 0);
          t7 *= t5;
          t5 = t1.get$y();
          if (typeof t5 !== 'number') return this.renderFace3$9$bailout(13, cameraMatrix, t1, uv2, uv3, element, t7, t5, material, 0, 0, 0, 0, 0, 0, 0);
          t10 = cameraMatrix.get$n12();
          if (typeof t10 !== 'number') return this.renderFace3$9$bailout(14, cameraMatrix, t1, uv2, uv3, element, t7, t5, t10, material, 0, 0, 0, 0, 0, 0);
          t7 += t5 * t10;
          t12 = t1.get$z();
          if (typeof t12 !== 'number') return this.renderFace3$9$bailout(15, cameraMatrix, t1, t7, t12, uv2, uv3, element, material, 0, 0, 0, 0, 0, 0, 0);
          t14 = cameraMatrix.get$n13();
          if (typeof t14 !== 'number') return this.renderFace3$9$bailout(16, cameraMatrix, t1, t7, t12, uv2, uv3, element, t14, material, 0, 0, 0, 0, 0, 0);
          this._uv1x = (t7 + t12 * t14) * 0.5 + 0.5;
          t16 = t1.get$x();
          if (typeof t16 !== 'number') return this.renderFace3$9$bailout(17, cameraMatrix, t1, t16, uv2, uv3, element, material, 0, 0, 0, 0, 0, 0, 0, 0);
          t18 = cameraMatrix.get$n21();
          if (typeof t18 !== 'number') return this.renderFace3$9$bailout(18, cameraMatrix, t1, t18, t16, uv2, uv3, element, material, 0, 0, 0, 0, 0, 0, 0);
          t18 *= t16;
          t16 = t1.get$y();
          if (typeof t16 !== 'number') return this.renderFace3$9$bailout(19, cameraMatrix, t1, t18, uv2, uv3, element, t16, material, 0, 0, 0, 0, 0, 0, 0);
          t21 = cameraMatrix.get$n22();
          if (typeof t21 !== 'number') return this.renderFace3$9$bailout(20, cameraMatrix, t1, t18, uv2, uv3, element, t21, t16, material, 0, 0, 0, 0, 0, 0);
          t18 += t16 * t21;
          var t23 = t1.get$z();
          if (typeof t23 !== 'number') return this.renderFace3$9$bailout(21, cameraMatrix, t1, uv2, uv3, element, t18, t23, material, 0, 0, 0, 0, 0, 0, 0);
          t25 = cameraMatrix.get$n23();
          if (typeof t25 !== 'number') return this.renderFace3$9$bailout(22, cameraMatrix, t1, uv2, uv3, element, t18, t23, t25, material, 0, 0, 0, 0, 0, 0);
          this._uv1y = -(t18 + t23 * t25) * 0.5 + 0.5;
          var t27 = element.get$vertexNormalsWorld();
          if (typeof t27 !== 'string' && (typeof t27 !== 'object' || t27 === null || (t27.constructor !== Array && !t27.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(23, cameraMatrix, t1, uv2, uv3, element, t27, material, 0, 0, 0, 0, 0, 0, 0, 0);
          if (uv2 !== (uv2 | 0)) throw $.iae(uv2);
          t29 = t27.length;
          if (uv2 < 0 || uv2 >= t29) throw $.ioore(uv2);
          t1.copy$1(t27[uv2]);
          t30 = t1.get$x();
          if (typeof t30 !== 'number') return this.renderFace3$9$bailout(24, cameraMatrix, t1, material, uv3, element, t30, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t32 = cameraMatrix.get$n11();
          if (typeof t32 !== 'number') return this.renderFace3$9$bailout(25, cameraMatrix, t1, material, t32, uv3, element, t30, 0, 0, 0, 0, 0, 0, 0, 0);
          t32 *= t30;
          t30 = t1.get$y();
          if (typeof t30 !== 'number') return this.renderFace3$9$bailout(26, cameraMatrix, t1, t32, t30, uv3, element, material, 0, 0, 0, 0, 0, 0, 0, 0);
          var t35 = cameraMatrix.get$n12();
          if (typeof t35 !== 'number') return this.renderFace3$9$bailout(27, cameraMatrix, t1, t32, t30, uv3, element, t35, material, 0, 0, 0, 0, 0, 0, 0);
          t32 += t30 * t35;
          var t37 = t1.get$z();
          if (typeof t37 !== 'number') return this.renderFace3$9$bailout(28, cameraMatrix, t1, uv3, element, t32, t37, material, 0, 0, 0, 0, 0, 0, 0, 0);
          var t39 = cameraMatrix.get$n13();
          if (typeof t39 !== 'number') return this.renderFace3$9$bailout(29, cameraMatrix, t1, uv3, element, t32, t37, t39, material, 0, 0, 0, 0, 0, 0, 0);
          this._uv2x = (t32 + t37 * t39) * 0.5 + 0.5;
          var t41 = t1.get$x();
          if (typeof t41 !== 'number') return this.renderFace3$9$bailout(30, cameraMatrix, t1, uv3, element, t41, material, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t43 = cameraMatrix.get$n21();
          if (typeof t43 !== 'number') return this.renderFace3$9$bailout(31, cameraMatrix, t1, uv3, element, t41, t43, material, 0, 0, 0, 0, 0, 0, 0, 0);
          t43 *= t41;
          t41 = t1.get$y();
          if (typeof t41 !== 'number') return this.renderFace3$9$bailout(32, cameraMatrix, t1, uv3, element, t43, t41, material, 0, 0, 0, 0, 0, 0, 0, 0);
          var t46 = cameraMatrix.get$n22();
          if (typeof t46 !== 'number') return this.renderFace3$9$bailout(33, cameraMatrix, t1, uv3, element, t43, t41, t46, material, 0, 0, 0, 0, 0, 0, 0);
          t43 += t41 * t46;
          var t48 = t1.get$z();
          if (typeof t48 !== 'number') return this.renderFace3$9$bailout(34, cameraMatrix, t1, t43, t48, uv3, element, material, 0, 0, 0, 0, 0, 0, 0, 0);
          var t50 = cameraMatrix.get$n23();
          if (typeof t50 !== 'number') return this.renderFace3$9$bailout(35, cameraMatrix, t1, t43, t48, t50, uv3, element, material, 0, 0, 0, 0, 0, 0, 0);
          this._uv2y = -(t43 + t48 * t50) * 0.5 + 0.5;
          var t52 = element.get$vertexNormalsWorld();
          if (typeof t52 !== 'string' && (typeof t52 !== 'object' || t52 === null || (t52.constructor !== Array && !t52.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(36, cameraMatrix, t1, t52, uv3, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          if (uv3 !== (uv3 | 0)) throw $.iae(uv3);
          var t54 = t52.length;
          if (uv3 < 0 || uv3 >= t54) throw $.ioore(uv3);
          t1.copy$1(t52[uv3]);
          var t55 = t1.get$x();
          if (typeof t55 !== 'number') return this.renderFace3$9$bailout(37, cameraMatrix, t1, t55, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t57 = cameraMatrix.get$n11();
          if (typeof t57 !== 'number') return this.renderFace3$9$bailout(38, cameraMatrix, t1, material, t55, t57, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t57 *= t55;
          t55 = t1.get$y();
          if (typeof t55 !== 'number') return this.renderFace3$9$bailout(39, cameraMatrix, t1, t57, t55, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t60 = cameraMatrix.get$n12();
          if (typeof t60 !== 'number') return this.renderFace3$9$bailout(40, cameraMatrix, t1, t57, t55, t60, material, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t57 += t55 * t60;
          var t62 = t1.get$z();
          if (typeof t62 !== 'number') return this.renderFace3$9$bailout(41, cameraMatrix, t1, t62, t57, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t64 = cameraMatrix.get$n13();
          if (typeof t64 !== 'number') return this.renderFace3$9$bailout(42, cameraMatrix, t1, t62, t57, t64, material, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          this._uv3x = (t57 + t62 * t64) * 0.5 + 0.5;
          var t66 = t1.get$x();
          if (typeof t66 !== 'number') return this.renderFace3$9$bailout(43, cameraMatrix, t1, t66, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t68 = cameraMatrix.get$n21();
          if (typeof t68 !== 'number') return this.renderFace3$9$bailout(44, cameraMatrix, t1, material, t66, t68, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t68 *= t66;
          t66 = t1.get$y();
          if (typeof t66 !== 'number') return this.renderFace3$9$bailout(45, cameraMatrix, t1, t68, t66, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t71 = cameraMatrix.get$n22();
          if (typeof t71 !== 'number') return this.renderFace3$9$bailout(46, cameraMatrix, t1, t68, t66, t71, material, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t68 += t66 * t71;
          t1 = t1.get$z();
          if (typeof t1 !== 'number') return this.renderFace3$9$bailout(47, cameraMatrix, t68, t1, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t74 = cameraMatrix.get$n23();
          if (typeof t74 !== 'number') return this.renderFace3$9$bailout(48, t68, t1, t74, material, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          this._uv3y = -(t68 + t1 * t74) * 0.5 + 0.5;
          this.patternPath$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._uv1x, this._uv1y, this._uv2x, this._uv2y, this._uv3x, this._uv3y, material.get$envMap());
        }
      } else {
        if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
        else this.fillPath$1(material.get$color());
      }
    }
  } else {
    if (typeof material === 'object' && material !== null && !!material.is$MeshLambertMaterial) {
      if (!(material.get$map() == null) && material.get$wireframe() !== true) {
        t1 = material.get$map().get$mapping();
        if (typeof t1 === 'object' && t1 !== null && !!t1.is$UVMapping) {
          t1 = element.get$uvs();
          if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(49, material, uv1, uv2, uv3, element, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t3 = t1.length;
          if (0 >= t3) throw $.ioore(0);
          this._uvs = t1[0];
          t4 = this._v1x;
          t5 = this._v1y;
          t6 = this._v2x;
          t7 = this._v2y;
          t8 = this._v3x;
          t9 = this._v3y;
          t10 = this._uvs;
          if (typeof t10 !== 'string' && (typeof t10 !== 'object' || t10 === null || (t10.constructor !== Array && !t10.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(50, material, uv1, uv2, uv3, element, t4, t5, t6, t7, t8, t9, t10, 0, 0, 0);
          if (uv1 !== (uv1 | 0)) throw $.iae(uv1);
          t12 = t10.length;
          if (uv1 < 0 || uv1 >= t12) throw $.ioore(uv1);
          t13 = t10[uv1].get$u();
          t14 = this._uvs;
          if (typeof t14 !== 'string' && (typeof t14 !== 'object' || t14 === null || (t14.constructor !== Array && !t14.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(51, material, uv1, uv2, uv3, element, t4, t5, t6, t7, t8, t9, t14, t13, 0, 0);
          t16 = t14.length;
          if (uv1 < 0 || uv1 >= t16) throw $.ioore(uv1);
          t17 = t14[uv1].get$v();
          t18 = this._uvs;
          if (typeof t18 !== 'string' && (typeof t18 !== 'object' || t18 === null || (t18.constructor !== Array && !t18.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(52, material, uv2, uv3, element, t4, t5, t6, t7, t8, t9, t18, t13, t17, 0, 0);
          if (uv2 !== (uv2 | 0)) throw $.iae(uv2);
          t20 = t18.length;
          if (uv2 < 0 || uv2 >= t20) throw $.ioore(uv2);
          t21 = t18[uv2].get$u();
          t22 = this._uvs;
          if (typeof t22 !== 'string' && (typeof t22 !== 'object' || t22 === null || (t22.constructor !== Array && !t22.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(53, material, uv2, uv3, element, t4, t5, t6, t7, t8, t9, t22, t13, t17, t21, 0);
          t24 = t22.length;
          if (uv2 < 0 || uv2 >= t24) throw $.ioore(uv2);
          t25 = t22[uv2].get$v();
          t26 = this._uvs;
          if (typeof t26 !== 'string' && (typeof t26 !== 'object' || t26 === null || (t26.constructor !== Array && !t26.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(54, material, t25, uv3, element, t4, t5, t6, t7, t8, t9, t26, t13, t17, t21, 0);
          if (uv3 !== (uv3 | 0)) throw $.iae(uv3);
          t28 = t26.length;
          if (uv3 < 0 || uv3 >= t28) throw $.ioore(uv3);
          t29 = t26[uv3].get$u();
          t30 = this._uvs;
          if (typeof t30 !== 'string' && (typeof t30 !== 'object' || t30 === null || (t30.constructor !== Array && !t30.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(55, material, t25, t29, uv3, element, t4, t5, t6, t7, t8, t9, t13, t30, t17, t21);
          t32 = t30.length;
          if (uv3 < 0 || uv3 >= t32) throw $.ioore(uv3);
          this.patternPath$13(t4, t5, t6, t7, t8, t9, t13, t17, t21, t25, t29, t30[uv3].get$v(), material.get$map());
        }
        this.setBlending$1(2);
      }
      if (this._enableLighting === true) {
        if (material.get$wireframe() !== true) {
          t1 = material.get$shading();
          if (typeof t1 !== 'number') return this.renderFace3$9$bailout(56, material, element, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          if (t1 === 2) {
            t1 = $.get$length(element.get$vertexNormalsWorld());
            if (typeof t1 !== 'number') return this.renderFace3$9$bailout(57, material, element, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            t1 = t1 === 3;
          } else t1 = false;
        } else t1 = false;
        t2 = this._ambientLight;
        t3 = t2.r;
        if (t1) {
          t1 = this._color3;
          t1.r = t3;
          t4 = this._color2;
          t4.r = t3;
          t5 = this._color1;
          t5.r = t3;
          t3 = t2.g;
          t1.g = t3;
          t4.g = t3;
          t5.g = t3;
          t2 = t2.b;
          t1.b = t2;
          t4.b = t2;
          t5.b = t2;
          t2 = this._lights;
          t3 = element.get$v1().get$positionWorld();
          t6 = element.get$vertexNormalsWorld();
          if (typeof t6 !== 'string' && (typeof t6 !== 'object' || t6 === null || (t6.constructor !== Array && !t6.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(58, material, t2, element, t1, t4, t5, t3, t6, 0, 0, 0, 0, 0, 0, 0);
          t8 = t6.length;
          if (0 >= t8) throw $.ioore(0);
          this.calculateLight$4(t2, t3, t6[0], t5);
          t3 = this._lights;
          t2 = element.get$v2().get$positionWorld();
          t9 = element.get$vertexNormalsWorld();
          if (typeof t9 !== 'string' && (typeof t9 !== 'object' || t9 === null || (t9.constructor !== Array && !t9.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(59, material, t3, t2, element, t1, t4, t5, t9, 0, 0, 0, 0, 0, 0, 0);
          var t11 = t9.length;
          if (1 >= t11) throw $.ioore(1);
          this.calculateLight$4(t3, t2, t9[1], t4);
          t2 = this._lights;
          t3 = element.get$v3().get$positionWorld();
          t12 = element.get$vertexNormalsWorld();
          if (typeof t12 !== 'string' && (typeof t12 !== 'object' || t12 === null || (t12.constructor !== Array && !t12.is$JavaScriptIndexingBehavior()))) return this.renderFace3$9$bailout(60, material, t2, t1, t4, t5, t3, t12, 0, 0, 0, 0, 0, 0, 0, 0);
          t14 = t12.length;
          if (2 >= t14) throw $.ioore(2);
          this.calculateLight$4(t2, t3, t12[2], t1);
          t3 = material.get$color().get$r();
          if (typeof t3 !== 'number') return this.renderFace3$9$bailout(61, material, t4, t5, t3, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t15 = t5.r;
          if (typeof t15 !== 'number') return this.renderFace3$9$bailout(62, material, t3, t1, t4, t5, t15, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t5.r = $.Math_max(0, $.Math_min(t3 * t15, 1));
          t17 = material.get$color().get$g();
          if (typeof t17 !== 'number') return this.renderFace3$9$bailout(63, material, t4, t17, t5, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t19 = t5.g;
          if (typeof t19 !== 'number') return this.renderFace3$9$bailout(64, material, t17, t19, t1, t4, t5, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t5.g = $.Math_max(0, $.Math_min(t17 * t19, 1));
          t21 = material.get$color().get$b();
          if (typeof t21 !== 'number') return this.renderFace3$9$bailout(65, material, t4, t5, t21, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t23 = t5.b;
          if (typeof t23 !== 'number') return this.renderFace3$9$bailout(66, material, t23, t1, t4, t5, t21, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t5.b = $.Math_max(0, $.Math_min(t21 * t23, 1));
          t25 = material.get$color().get$r();
          if (typeof t25 !== 'number') return this.renderFace3$9$bailout(67, material, t4, t5, t25, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t27 = t4.r;
          if (typeof t27 !== 'number') return this.renderFace3$9$bailout(68, material, t1, t4, t5, t25, t27, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t4.r = $.Math_max(0, $.Math_min(t25 * t27, 1));
          t29 = material.get$color().get$g();
          if (typeof t29 !== 'number') return this.renderFace3$9$bailout(69, material, t4, t5, t29, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t31 = t4.g;
          if (typeof t31 !== 'number') return this.renderFace3$9$bailout(70, material, t29, t1, t4, t5, t31, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t4.g = $.Math_max(0, $.Math_min(t29 * t31, 1));
          var t33 = material.get$color().get$b();
          if (typeof t33 !== 'number') return this.renderFace3$9$bailout(71, material, t4, t33, t5, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t35 = t4.b;
          if (typeof t35 !== 'number') return this.renderFace3$9$bailout(72, material, t33, t35, t1, t4, t5, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t4.b = $.Math_max(0, $.Math_min(t33 * t35, 1));
          t37 = material.get$color().get$r();
          if (typeof t37 !== 'number') return this.renderFace3$9$bailout(73, material, t4, t5, t37, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t39 = t1.r;
          if (typeof t39 !== 'number') return this.renderFace3$9$bailout(74, material, t39, t1, t4, t5, t37, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.r = $.Math_max(0, $.Math_min(t37 * t39, 1));
          t41 = material.get$color().get$g();
          if (typeof t41 !== 'number') return this.renderFace3$9$bailout(75, material, t4, t5, t41, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t43 = t1.g;
          if (typeof t43 !== 'number') return this.renderFace3$9$bailout(76, material, t1, t4, t5, t41, t43, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.g = $.Math_max(0, $.Math_min(t41 * t43, 1));
          var t45 = material.get$color().get$b();
          if (typeof t45 !== 'number') return this.renderFace3$9$bailout(77, t4, t5, t45, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t47 = t1.b;
          if (typeof t47 !== 'number') return this.renderFace3$9$bailout(78, t4, t5, t47, t45, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.b = $.Math_max(0, $.Math_min(t45 * t47, 1));
          var t49 = t4.r;
          if (typeof t49 !== 'number') return this.renderFace3$9$bailout(79, t49, t4, t5, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t51 = t1.r;
          if (typeof t51 !== 'number') return this.renderFace3$9$bailout(80, t49, t4, t51, t5, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t53 = (t49 + t51) * 0.5;
          t54 = this._color4;
          t54.r = t53;
          t53 = t4.g;
          if (typeof t53 !== 'number') return this.renderFace3$9$bailout(81, t4, t5, t53, t54, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          var t56 = t1.g;
          if (typeof t56 !== 'number') return this.renderFace3$9$bailout(82, t1, t4, t5, t53, t54, t56, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t54.g = (t53 + t56) * 0.5;
          var t58 = t4.b;
          if (typeof t58 !== 'number') return this.renderFace3$9$bailout(83, t4, t5, t58, t54, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t60 = t1.b;
          if (typeof t60 !== 'number') return this.renderFace3$9$bailout(84, t58, t60, t1, t4, t5, t54, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t54.b = (t58 + t60) * 0.5;
          this._image = this.getGradientTexture$4(t5, t4, t1, t54);
          this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, 0, 0, 1, 0, 0, 1, this._image);
        } else {
          t1 = this._color;
          t1.r = t3;
          t1.g = t2.g;
          t1.b = t2.b;
          this.calculateLight$4(this._lights, element.get$centroidWorld(), element.get$normalWorld(), t1);
          t3 = material.get$color().get$r();
          if (typeof t3 !== 'number') return this.renderFace3$9$bailout(85, t1, material, t3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t5 = t1.r;
          if (typeof t5 !== 'number') return this.renderFace3$9$bailout(86, t1, material, t5, t3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.r = $.Math_max(0, $.Math_min(t3 * t5, 1));
          t7 = material.get$color().get$g();
          if (typeof t7 !== 'number') return this.renderFace3$9$bailout(87, t1, material, t7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t9 = t1.g;
          if (typeof t9 !== 'number') return this.renderFace3$9$bailout(88, t1, material, t7, t9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.g = $.Math_max(0, $.Math_min(t7 * t9, 1));
          t11 = material.get$color().get$b();
          if (typeof t11 !== 'number') return this.renderFace3$9$bailout(89, t1, material, t11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t13 = t1.b;
          if (typeof t13 !== 'number') return this.renderFace3$9$bailout(90, t1, material, t13, t11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          t1.b = $.Math_max(0, $.Math_min(t11 * t13, 1));
          if (material.get$wireframe() === true) this.strokePath$4(t1, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
          else this.fillPath$1(t1);
        }
      } else {
        if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
        else this.fillPath$1(material.get$color());
      }
    } else {
      if (typeof material === 'object' && material !== null && !!material.is$MeshDepthMaterial) {
        this._near = this._camera.get$near();
        this._far = this._camera.get$far();
        t1 = this.smoothstep$3(v1.get$positionScreen().get$z(), this._near, this._far);
        if (typeof t1 !== 'number') throw $.iae(t1);
        t1 = 1 - t1;
        t2 = this._color1;
        t2.b = t1;
        t2.g = t1;
        t2.r = t1;
        t1 = this.smoothstep$3(v2.get$positionScreen().get$z(), this._near, this._far);
        if (typeof t1 !== 'number') throw $.iae(t1);
        t1 = 1 - t1;
        t3 = this._color2;
        t3.b = t1;
        t3.g = t1;
        t3.r = t1;
        t1 = this.smoothstep$3(v3.get$positionScreen().get$z(), this._near, this._far);
        if (typeof t1 !== 'number') throw $.iae(t1);
        t1 = 1 - t1;
        t4 = this._color3;
        t4.b = t1;
        t4.g = t1;
        t4.r = t1;
        t1 = t3.r;
        if (typeof t1 !== 'number') return this.renderFace3$9$bailout(91, t3, t1, t2, t4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t6 = t4.r;
        if (typeof t6 !== 'number') return this.renderFace3$9$bailout(92, t3, t1, t2, t6, t4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t8 = (t1 + t6) * 0.5;
        t9 = this._color4;
        t9.r = t8;
        t8 = t3.g;
        if (typeof t8 !== 'number') return this.renderFace3$9$bailout(93, t3, t9, t2, t8, t4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t11 = t4.g;
        if (typeof t11 !== 'number') return this.renderFace3$9$bailout(94, t4, t9, t2, t3, t8, t11, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t9.g = (t8 + t11) * 0.5;
        t13 = t3.b;
        if (typeof t13 !== 'number') return this.renderFace3$9$bailout(95, t4, t3, t9, t2, t13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t15 = t4.b;
        if (typeof t15 !== 'number') return this.renderFace3$9$bailout(96, t9, t2, t13, t15, t3, t4, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        t9.b = (t13 + t15) * 0.5;
        this._image = this.getGradientTexture$4(t2, t3, t4, t9);
        this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, 0, 0, 1, 0, 0, 1, this._image);
      } else {
        if (typeof material === 'object' && material !== null && !!material.is$MeshNormalMaterial) {
          t1 = this.normalToComponent$1(element.get$normalWorld().get$x());
          t2 = this._color;
          t2.r = t1;
          t2.g = this.normalToComponent$1(element.get$normalWorld().get$y());
          t2.b = this.normalToComponent$1(element.get$normalWorld().get$z());
          if (material.get$wireframe() === true) this.strokePath$4(t2, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
          else this.fillPath$1(t2);
        }
      }
    }
  }
 },
 renderFace3$9$bailout: function(state, env0, env1, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11, env12, env13, env14) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      var v3 = env2;
      var uv1 = env3;
      var uv2 = env4;
      var uv3 = env5;
      var element = env6;
      var material = env7;
      t1 = env8;
      t2 = env9;
      t3 = env10;
      break;
    case 2:
      v1 = env0;
      v2 = env1;
      v3 = env2;
      uv1 = env3;
      uv2 = env4;
      uv3 = env5;
      element = env6;
      material = env7;
      t1 = env8;
      t2 = env9;
      break;
    case 3:
      t1 = env0;
      uv1 = env1;
      uv2 = env2;
      uv3 = env3;
      material = env4;
      break;
    case 4:
      uv1 = env0;
      uv2 = env1;
      uv3 = env2;
      t4 = env3;
      t3 = env4;
      t6 = env5;
      t5 = env6;
      t8 = env7;
      t7 = env8;
      t9 = env9;
      material = env10;
      break;
    case 5:
      uv1 = env0;
      uv2 = env1;
      uv3 = env2;
      t3 = env3;
      t4 = env4;
      t5 = env5;
      t6 = env6;
      t7 = env7;
      t8 = env8;
      t11 = env9;
      t12 = env10;
      material = env11;
      break;
    case 6:
      uv2 = env0;
      uv3 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t6 = env5;
      t7 = env6;
      t8 = env7;
      t11 = env8;
      t14 = env9;
      t15 = env10;
      material = env11;
      break;
    case 7:
      material = env0;
      uv2 = env1;
      uv3 = env2;
      t3 = env3;
      t4 = env4;
      t5 = env5;
      t6 = env6;
      t7 = env7;
      t8 = env8;
      t11 = env9;
      t14 = env10;
      t18 = env11;
      t17 = env12;
      break;
    case 8:
      t17 = env0;
      t20 = env1;
      uv3 = env2;
      t3 = env3;
      t4 = env4;
      t5 = env5;
      t6 = env6;
      t7 = env7;
      t8 = env8;
      t11 = env9;
      t14 = env10;
      t21 = env11;
      material = env12;
      break;
    case 9:
      t24 = env0;
      t17 = env1;
      t20 = env2;
      uv3 = env3;
      t23 = env4;
      t3 = env5;
      t4 = env6;
      t5 = env7;
      t6 = env8;
      t7 = env9;
      t8 = env10;
      t11 = env11;
      t14 = env12;
      material = env13;
      break;
    case 10:
      cameraMatrix = env0;
      t1 = env1;
      t2 = env2;
      uv2 = env3;
      uv3 = env4;
      element = env5;
      uv1 = env6;
      material = env7;
      break;
    case 11:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t4 = env5;
      material = env6;
      break;
    case 12:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t4 = env5;
      t6 = env6;
      material = env7;
      break;
    case 13:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t6 = env5;
      t4 = env6;
      material = env7;
      break;
    case 14:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t6 = env5;
      t4 = env6;
      t9 = env7;
      material = env8;
      break;
    case 15:
      cameraMatrix = env0;
      t1 = env1;
      t6 = env2;
      t11 = env3;
      uv2 = env4;
      uv3 = env5;
      element = env6;
      material = env7;
      break;
    case 16:
      cameraMatrix = env0;
      t1 = env1;
      t6 = env2;
      t11 = env3;
      uv2 = env4;
      uv3 = env5;
      element = env6;
      t13 = env7;
      material = env8;
      break;
    case 17:
      cameraMatrix = env0;
      t1 = env1;
      t15 = env2;
      uv2 = env3;
      uv3 = env4;
      element = env5;
      material = env6;
      break;
    case 18:
      cameraMatrix = env0;
      t1 = env1;
      t17 = env2;
      t15 = env3;
      uv2 = env4;
      uv3 = env5;
      element = env6;
      material = env7;
      break;
    case 19:
      cameraMatrix = env0;
      t1 = env1;
      t17 = env2;
      uv2 = env3;
      uv3 = env4;
      element = env5;
      t15 = env6;
      material = env7;
      break;
    case 20:
      cameraMatrix = env0;
      t1 = env1;
      t17 = env2;
      uv2 = env3;
      uv3 = env4;
      element = env5;
      t20 = env6;
      t15 = env7;
      material = env8;
      break;
    case 21:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t17 = env5;
      t22 = env6;
      material = env7;
      break;
    case 22:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t17 = env5;
      t22 = env6;
      t24 = env7;
      material = env8;
      break;
    case 23:
      cameraMatrix = env0;
      t1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t26 = env5;
      material = env6;
      break;
    case 24:
      cameraMatrix = env0;
      t1 = env1;
      material = env2;
      uv3 = env3;
      element = env4;
      t28 = env5;
      break;
    case 25:
      cameraMatrix = env0;
      t1 = env1;
      material = env2;
      t30 = env3;
      uv3 = env4;
      element = env5;
      t28 = env6;
      break;
    case 26:
      cameraMatrix = env0;
      t1 = env1;
      t30 = env2;
      t28 = env3;
      uv3 = env4;
      element = env5;
      material = env6;
      break;
    case 27:
      cameraMatrix = env0;
      t1 = env1;
      t30 = env2;
      t28 = env3;
      uv3 = env4;
      element = env5;
      t33 = env6;
      material = env7;
      break;
    case 28:
      cameraMatrix = env0;
      t1 = env1;
      uv3 = env2;
      element = env3;
      t30 = env4;
      t35 = env5;
      material = env6;
      break;
    case 29:
      cameraMatrix = env0;
      t1 = env1;
      uv3 = env2;
      element = env3;
      t30 = env4;
      t35 = env5;
      t37 = env6;
      material = env7;
      break;
    case 30:
      cameraMatrix = env0;
      t1 = env1;
      uv3 = env2;
      element = env3;
      t39 = env4;
      material = env5;
      break;
    case 31:
      cameraMatrix = env0;
      t1 = env1;
      uv3 = env2;
      element = env3;
      t39 = env4;
      t41 = env5;
      material = env6;
      break;
    case 32:
      cameraMatrix = env0;
      t1 = env1;
      uv3 = env2;
      element = env3;
      t41 = env4;
      t39 = env5;
      material = env6;
      break;
    case 33:
      cameraMatrix = env0;
      t1 = env1;
      uv3 = env2;
      element = env3;
      t41 = env4;
      t39 = env5;
      t44 = env6;
      material = env7;
      break;
    case 34:
      cameraMatrix = env0;
      t1 = env1;
      t41 = env2;
      t46 = env3;
      uv3 = env4;
      element = env5;
      material = env6;
      break;
    case 35:
      cameraMatrix = env0;
      t1 = env1;
      t41 = env2;
      t46 = env3;
      t48 = env4;
      uv3 = env5;
      element = env6;
      material = env7;
      break;
    case 36:
      cameraMatrix = env0;
      t1 = env1;
      t50 = env2;
      uv3 = env3;
      material = env4;
      break;
    case 37:
      cameraMatrix = env0;
      t1 = env1;
      t52 = env2;
      material = env3;
      break;
    case 38:
      cameraMatrix = env0;
      t1 = env1;
      material = env2;
      t52 = env3;
      t54 = env4;
      break;
    case 39:
      cameraMatrix = env0;
      t1 = env1;
      t54 = env2;
      t52 = env3;
      material = env4;
      break;
    case 40:
      cameraMatrix = env0;
      t1 = env1;
      t54 = env2;
      t52 = env3;
      t57 = env4;
      material = env5;
      break;
    case 41:
      cameraMatrix = env0;
      t1 = env1;
      t59 = env2;
      t54 = env3;
      material = env4;
      break;
    case 42:
      cameraMatrix = env0;
      t1 = env1;
      t59 = env2;
      t54 = env3;
      t61 = env4;
      material = env5;
      break;
    case 43:
      cameraMatrix = env0;
      t1 = env1;
      t63 = env2;
      material = env3;
      break;
    case 44:
      cameraMatrix = env0;
      t1 = env1;
      material = env2;
      t63 = env3;
      t65 = env4;
      break;
    case 45:
      cameraMatrix = env0;
      t1 = env1;
      t65 = env2;
      t63 = env3;
      material = env4;
      break;
    case 46:
      cameraMatrix = env0;
      t1 = env1;
      t65 = env2;
      t63 = env3;
      t68 = env4;
      material = env5;
      break;
    case 47:
      cameraMatrix = env0;
      t65 = env1;
      t1 = env2;
      material = env3;
      break;
    case 48:
      t65 = env0;
      t1 = env1;
      t71 = env2;
      material = env3;
      break;
    case 49:
      material = env0;
      uv1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t1 = env5;
      break;
    case 50:
      material = env0;
      uv1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t3 = env5;
      t4 = env6;
      t5 = env7;
      t6 = env8;
      t7 = env9;
      t8 = env10;
      t9 = env11;
      break;
    case 51:
      material = env0;
      uv1 = env1;
      uv2 = env2;
      uv3 = env3;
      element = env4;
      t3 = env5;
      t4 = env6;
      t5 = env7;
      t6 = env8;
      t7 = env9;
      t8 = env10;
      t12 = env11;
      t11 = env12;
      break;
    case 52:
      material = env0;
      uv2 = env1;
      uv3 = env2;
      element = env3;
      t3 = env4;
      t4 = env5;
      t5 = env6;
      t6 = env7;
      t7 = env8;
      t8 = env9;
      t15 = env10;
      t11 = env11;
      t14 = env12;
      break;
    case 53:
      material = env0;
      uv2 = env1;
      uv3 = env2;
      element = env3;
      t3 = env4;
      t4 = env5;
      t5 = env6;
      t6 = env7;
      t7 = env8;
      t8 = env9;
      t18 = env10;
      t11 = env11;
      t14 = env12;
      t17 = env13;
      break;
    case 54:
      material = env0;
      t20 = env1;
      uv3 = env2;
      element = env3;
      t3 = env4;
      t4 = env5;
      t5 = env6;
      t6 = env7;
      t7 = env8;
      t8 = env9;
      t21 = env10;
      t11 = env11;
      t14 = env12;
      t17 = env13;
      break;
    case 55:
      material = env0;
      t20 = env1;
      t23 = env2;
      uv3 = env3;
      element = env4;
      t3 = env5;
      t4 = env6;
      t5 = env7;
      t6 = env8;
      t7 = env9;
      t8 = env10;
      t11 = env11;
      t24 = env12;
      t14 = env13;
      t17 = env14;
      break;
    case 56:
      material = env0;
      element = env1;
      t1 = env2;
      break;
    case 57:
      material = env0;
      element = env1;
      t1 = env2;
      break;
    case 58:
      material = env0;
      t2 = env1;
      element = env2;
      t3 = env3;
      t4 = env4;
      t5 = env5;
      t1 = env6;
      t6 = env7;
      break;
    case 59:
      material = env0;
      t1 = env1;
      t2 = env2;
      element = env3;
      t3 = env4;
      t4 = env5;
      t5 = env6;
      t8 = env7;
      break;
    case 60:
      material = env0;
      t2 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t1 = env5;
      t10 = env6;
      break;
    case 61:
      material = env0;
      t4 = env1;
      t5 = env2;
      t1 = env3;
      t3 = env4;
      break;
    case 62:
      material = env0;
      t1 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t12 = env5;
      break;
    case 63:
      material = env0;
      t4 = env1;
      t14 = env2;
      t5 = env3;
      t3 = env4;
      break;
    case 64:
      material = env0;
      t14 = env1;
      t16 = env2;
      t3 = env3;
      t4 = env4;
      t5 = env5;
      break;
    case 65:
      material = env0;
      t4 = env1;
      t5 = env2;
      t18 = env3;
      t3 = env4;
      break;
    case 66:
      material = env0;
      t20 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t18 = env5;
      break;
    case 67:
      material = env0;
      t4 = env1;
      t5 = env2;
      t22 = env3;
      t3 = env4;
      break;
    case 68:
      material = env0;
      t3 = env1;
      t4 = env2;
      t5 = env3;
      t22 = env4;
      t24 = env5;
      break;
    case 69:
      material = env0;
      t4 = env1;
      t5 = env2;
      t26 = env3;
      t3 = env4;
      break;
    case 70:
      material = env0;
      t26 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t28 = env5;
      break;
    case 71:
      material = env0;
      t4 = env1;
      t30 = env2;
      t5 = env3;
      t3 = env4;
      break;
    case 72:
      material = env0;
      t30 = env1;
      t32 = env2;
      t3 = env3;
      t4 = env4;
      t5 = env5;
      break;
    case 73:
      material = env0;
      t4 = env1;
      t5 = env2;
      t34 = env3;
      t3 = env4;
      break;
    case 74:
      material = env0;
      t36 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t34 = env5;
      break;
    case 75:
      material = env0;
      t4 = env1;
      t5 = env2;
      t38 = env3;
      t3 = env4;
      break;
    case 76:
      material = env0;
      t3 = env1;
      t4 = env2;
      t5 = env3;
      t38 = env4;
      t40 = env5;
      break;
    case 77:
      t4 = env0;
      t5 = env1;
      t42 = env2;
      t3 = env3;
      break;
    case 78:
      t4 = env0;
      t5 = env1;
      t44 = env2;
      t42 = env3;
      t3 = env4;
      break;
    case 79:
      t46 = env0;
      t4 = env1;
      t5 = env2;
      t3 = env3;
      break;
    case 80:
      t46 = env0;
      t4 = env1;
      t48 = env2;
      t5 = env3;
      t3 = env4;
      break;
    case 81:
      t4 = env0;
      t5 = env1;
      t50 = env2;
      t51 = env3;
      t3 = env4;
      break;
    case 82:
      t3 = env0;
      t4 = env1;
      t5 = env2;
      t50 = env3;
      t51 = env4;
      t53 = env5;
      break;
    case 83:
      t4 = env0;
      t5 = env1;
      t55 = env2;
      t51 = env3;
      t3 = env4;
      break;
    case 84:
      t55 = env0;
      t57 = env1;
      t3 = env2;
      t4 = env3;
      t5 = env4;
      t51 = env5;
      break;
    case 85:
      t3 = env0;
      material = env1;
      t1 = env2;
      break;
    case 86:
      t3 = env0;
      material = env1;
      t5 = env2;
      t1 = env3;
      break;
    case 87:
      t3 = env0;
      material = env1;
      t7 = env2;
      break;
    case 88:
      t3 = env0;
      material = env1;
      t7 = env2;
      t9 = env3;
      break;
    case 89:
      t3 = env0;
      material = env1;
      t11 = env2;
      break;
    case 90:
      t3 = env0;
      material = env1;
      t13 = env2;
      t11 = env3;
      break;
    case 91:
      t3 = env0;
      t1 = env1;
      t2 = env2;
      t4 = env3;
      break;
    case 92:
      t3 = env0;
      t1 = env1;
      t2 = env2;
      t6 = env3;
      t4 = env4;
      break;
    case 93:
      t3 = env0;
      t9 = env1;
      t2 = env2;
      t8 = env3;
      t4 = env4;
      break;
    case 94:
      t4 = env0;
      t9 = env1;
      t2 = env2;
      t3 = env3;
      t8 = env4;
      t11 = env5;
      break;
    case 95:
      t4 = env0;
      t3 = env1;
      t9 = env2;
      t2 = env3;
      t13 = env4;
      break;
    case 96:
      t9 = env0;
      t2 = env1;
      t13 = env2;
      t15 = env3;
      t3 = env4;
      t4 = env5;
      break;
  }
  switch (state) {
    case 0:
      var t1 = this._info;
      var t2 = t1.get$render();
      var t3 = t2.get$vertices();
    case 1:
      state = 0;
      t2.set$vertices($.add(t3, 3));
      t1 = t1.get$render();
      t2 = t1.get$faces();
    case 2:
      state = 0;
      t1.set$faces($.add(t2, 1));
      this.setOpacity$1(material.get$opacity());
      this.setBlending$1(material.get$blending());
      this._v1x = v1.get$positionScreen().get$x();
      this._v1y = v1.get$positionScreen().get$y();
      this._v2x = v2.get$positionScreen().get$x();
      this._v2y = v2.get$positionScreen().get$y();
      this._v3x = v3.get$positionScreen().get$x();
      this._v3y = v3.get$positionScreen().get$y();
      this.drawTriangle$6(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y);
    default:
      if (state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || state == 25 || state == 26 || state == 27 || state == 28 || state == 29 || state == 30 || state == 31 || state == 32 || state == 33 || state == 34 || state == 35 || state == 36 || state == 37 || state == 38 || state == 39 || state == 40 || state == 41 || state == 42 || state == 43 || state == 44 || state == 45 || state == 46 || state == 47 || state == 48 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$MeshBasicMaterial))) {
        switch (state) {
          case 0:
          default:
            if (state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || (state == 0 && !(material.get$map() == null))) {
              switch (state) {
                case 0:
                  t1 = material.get$map().get$mapping();
                default:
                  if (state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || (state == 0 && ((typeof t1 === 'object' && t1 !== null) && !!t1.is$UVMapping))) {
                    switch (state) {
                      case 0:
                        t1 = element.get$uvs();
                      case 3:
                        state = 0;
                        this._uvs = $.index(t1, 0);
                        t3 = this._v1x;
                        var t4 = this._v1y;
                        var t5 = this._v2x;
                        var t6 = this._v2y;
                        var t7 = this._v3x;
                        var t8 = this._v3y;
                        var t9 = this._uvs;
                      case 4:
                        state = 0;
                        var t11 = $.index(t9, uv1).get$u();
                        var t12 = this._uvs;
                      case 5:
                        state = 0;
                        var t14 = $.index(t12, uv1).get$v();
                        var t15 = this._uvs;
                      case 6:
                        state = 0;
                        var t17 = $.index(t15, uv2).get$u();
                        var t18 = this._uvs;
                      case 7:
                        state = 0;
                        var t20 = $.index(t18, uv2).get$v();
                        var t21 = this._uvs;
                      case 8:
                        state = 0;
                        var t23 = $.index(t21, uv3).get$u();
                        var t24 = this._uvs;
                      case 9:
                        state = 0;
                        this.patternPath$13(t3, t4, t5, t6, t7, t8, t11, t14, t17, t20, t23, $.index(t24, uv3).get$v(), material.get$map());
                    }
                  }
              }
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || state == 25 || state == 26 || state == 27 || state == 28 || state == 29 || state == 30 || state == 31 || state == 32 || state == 33 || state == 34 || state == 35 || state == 36 || state == 37 || state == 38 || state == 39 || state == 40 || state == 41 || state == 42 || state == 43 || state == 44 || state == 45 || state == 46 || state == 47 || state == 48 || (state == 0 && !(null == material.get$envMap()))) {
                    switch (state) {
                      case 0:
                        t1 = material.get$envMap().get$mapping();
                      default:
                        if (state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || state == 25 || state == 26 || state == 27 || state == 28 || state == 29 || state == 30 || state == 31 || state == 32 || state == 33 || state == 34 || state == 35 || state == 36 || state == 37 || state == 38 || state == 39 || state == 40 || state == 41 || state == 42 || state == 43 || state == 44 || state == 45 || state == 46 || state == 47 || state == 48 || (state == 0 && ((typeof t1 === 'object' && t1 !== null) && !!t1.is$SphericalReflectionMapping))) {
                          switch (state) {
                            case 0:
                              var cameraMatrix = this._camera.get$matrixWorldInverse();
                              t1 = this._vector3;
                              t2 = element.get$vertexNormalsWorld();
                            case 10:
                              state = 0;
                              t1.copy$1($.index(t2, uv1));
                              t4 = t1.get$x();
                            case 11:
                              state = 0;
                              t6 = cameraMatrix.get$n11();
                            case 12:
                              state = 0;
                              t6 = $.mul(t4, t6);
                              t4 = t1.get$y();
                            case 13:
                              state = 0;
                              t9 = cameraMatrix.get$n12();
                            case 14:
                              state = 0;
                              t6 = $.add(t6, $.mul(t4, t9));
                              t11 = t1.get$z();
                            case 15:
                              state = 0;
                              var t13 = cameraMatrix.get$n13();
                            case 16:
                              state = 0;
                              this._uv1x = $.add($.mul($.add(t6, $.mul(t11, t13)), 0.5), 0.5);
                              t15 = t1.get$x();
                            case 17:
                              state = 0;
                              t17 = cameraMatrix.get$n21();
                            case 18:
                              state = 0;
                              t17 = $.mul(t15, t17);
                              t15 = t1.get$y();
                            case 19:
                              state = 0;
                              t20 = cameraMatrix.get$n22();
                            case 20:
                              state = 0;
                              t17 = $.add(t17, $.mul(t15, t20));
                              var t22 = t1.get$z();
                            case 21:
                              state = 0;
                              t24 = cameraMatrix.get$n23();
                            case 22:
                              state = 0;
                              this._uv1y = $.add($.mul($.neg($.add(t17, $.mul(t22, t24))), 0.5), 0.5);
                              var t26 = element.get$vertexNormalsWorld();
                            case 23:
                              state = 0;
                              t1.copy$1($.index(t26, uv2));
                              var t28 = t1.get$x();
                            case 24:
                              state = 0;
                              var t30 = cameraMatrix.get$n11();
                            case 25:
                              state = 0;
                              t30 = $.mul(t28, t30);
                              t28 = t1.get$y();
                            case 26:
                              state = 0;
                              var t33 = cameraMatrix.get$n12();
                            case 27:
                              state = 0;
                              t30 = $.add(t30, $.mul(t28, t33));
                              var t35 = t1.get$z();
                            case 28:
                              state = 0;
                              var t37 = cameraMatrix.get$n13();
                            case 29:
                              state = 0;
                              this._uv2x = $.add($.mul($.add(t30, $.mul(t35, t37)), 0.5), 0.5);
                              var t39 = t1.get$x();
                            case 30:
                              state = 0;
                              var t41 = cameraMatrix.get$n21();
                            case 31:
                              state = 0;
                              t41 = $.mul(t39, t41);
                              t39 = t1.get$y();
                            case 32:
                              state = 0;
                              var t44 = cameraMatrix.get$n22();
                            case 33:
                              state = 0;
                              t41 = $.add(t41, $.mul(t39, t44));
                              var t46 = t1.get$z();
                            case 34:
                              state = 0;
                              var t48 = cameraMatrix.get$n23();
                            case 35:
                              state = 0;
                              this._uv2y = $.add($.mul($.neg($.add(t41, $.mul(t46, t48))), 0.5), 0.5);
                              var t50 = element.get$vertexNormalsWorld();
                            case 36:
                              state = 0;
                              t1.copy$1($.index(t50, uv3));
                              var t52 = t1.get$x();
                            case 37:
                              state = 0;
                              var t54 = cameraMatrix.get$n11();
                            case 38:
                              state = 0;
                              t54 = $.mul(t52, t54);
                              t52 = t1.get$y();
                            case 39:
                              state = 0;
                              var t57 = cameraMatrix.get$n12();
                            case 40:
                              state = 0;
                              t54 = $.add(t54, $.mul(t52, t57));
                              var t59 = t1.get$z();
                            case 41:
                              state = 0;
                              var t61 = cameraMatrix.get$n13();
                            case 42:
                              state = 0;
                              this._uv3x = $.add($.mul($.add(t54, $.mul(t59, t61)), 0.5), 0.5);
                              var t63 = t1.get$x();
                            case 43:
                              state = 0;
                              var t65 = cameraMatrix.get$n21();
                            case 44:
                              state = 0;
                              t65 = $.mul(t63, t65);
                              t63 = t1.get$y();
                            case 45:
                              state = 0;
                              var t68 = cameraMatrix.get$n22();
                            case 46:
                              state = 0;
                              t65 = $.add(t65, $.mul(t63, t68));
                              t1 = t1.get$z();
                            case 47:
                              state = 0;
                              var t71 = cameraMatrix.get$n23();
                            case 48:
                              state = 0;
                              this._uv3y = $.add($.mul($.neg($.add(t65, $.mul(t1, t71))), 0.5), 0.5);
                              this.patternPath$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, this._uv1x, this._uv1y, this._uv2x, this._uv2y, this._uv3x, this._uv3y, material.get$envMap());
                          }
                        }
                    }
                  } else {
                    if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                    else this.fillPath$1(material.get$color());
                  }
              }
            }
        }
      } else {
        switch (state) {
          case 0:
          default:
            if (state == 49 || state == 50 || state == 51 || state == 52 || state == 53 || state == 54 || state == 55 || state == 56 || state == 57 || state == 58 || state == 59 || state == 60 || state == 61 || state == 62 || state == 63 || state == 64 || state == 65 || state == 66 || state == 67 || state == 68 || state == 69 || state == 70 || state == 71 || state == 72 || state == 73 || state == 74 || state == 75 || state == 76 || state == 77 || state == 78 || state == 79 || state == 80 || state == 81 || state == 82 || state == 83 || state == 84 || state == 85 || state == 86 || state == 87 || state == 88 || state == 89 || state == 90 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$MeshLambertMaterial))) {
              switch (state) {
                case 0:
                default:
                  if (state == 49 || state == 50 || state == 51 || state == 52 || state == 53 || state == 54 || state == 55 || (state == 0 && (!(material.get$map() == null) && material.get$wireframe() !== true))) {
                    switch (state) {
                      case 0:
                        t1 = material.get$map().get$mapping();
                      default:
                        if (state == 49 || state == 50 || state == 51 || state == 52 || state == 53 || state == 54 || state == 55 || (state == 0 && ((typeof t1 === 'object' && t1 !== null) && !!t1.is$UVMapping))) {
                          switch (state) {
                            case 0:
                              t1 = element.get$uvs();
                            case 49:
                              state = 0;
                              this._uvs = $.index(t1, 0);
                              t3 = this._v1x;
                              t4 = this._v1y;
                              t5 = this._v2x;
                              t6 = this._v2y;
                              t7 = this._v3x;
                              t8 = this._v3y;
                              t9 = this._uvs;
                            case 50:
                              state = 0;
                              t11 = $.index(t9, uv1).get$u();
                              t12 = this._uvs;
                            case 51:
                              state = 0;
                              t14 = $.index(t12, uv1).get$v();
                              t15 = this._uvs;
                            case 52:
                              state = 0;
                              t17 = $.index(t15, uv2).get$u();
                              t18 = this._uvs;
                            case 53:
                              state = 0;
                              t20 = $.index(t18, uv2).get$v();
                              t21 = this._uvs;
                            case 54:
                              state = 0;
                              t23 = $.index(t21, uv3).get$u();
                              t24 = this._uvs;
                            case 55:
                              state = 0;
                              this.patternPath$13(t3, t4, t5, t6, t7, t8, t11, t14, t17, t20, t23, $.index(t24, uv3).get$v(), material.get$map());
                          }
                        }
                        this.setBlending$1(2);
                    }
                  }
                case 56:
                case 57:
                case 58:
                case 59:
                case 60:
                case 61:
                case 62:
                case 63:
                case 64:
                case 65:
                case 66:
                case 67:
                case 68:
                case 69:
                case 70:
                case 71:
                case 72:
                case 73:
                case 74:
                case 75:
                case 76:
                case 77:
                case 78:
                case 79:
                case 80:
                case 81:
                case 82:
                case 83:
                case 84:
                case 85:
                case 86:
                case 87:
                case 88:
                case 89:
                case 90:
                  if (state == 56 || state == 57 || state == 58 || state == 59 || state == 60 || state == 61 || state == 62 || state == 63 || state == 64 || state == 65 || state == 66 || state == 67 || state == 68 || state == 69 || state == 70 || state == 71 || state == 72 || state == 73 || state == 74 || state == 75 || state == 76 || state == 77 || state == 78 || state == 79 || state == 80 || state == 81 || state == 82 || state == 83 || state == 84 || state == 85 || state == 86 || state == 87 || state == 88 || state == 89 || state == 90 || (state == 0 && this._enableLighting === true)) {
                    switch (state) {
                      case 0:
                      default:
                        if (state == 56 || state == 57 || (state == 0 && material.get$wireframe() !== true)) {
                          switch (state) {
                            case 0:
                              t1 = material.get$shading();
                            case 56:
                              state = 0;
                            case 57:
                              if (state == 57 || (state == 0 && $.eqB(t1, 2))) {
                                switch (state) {
                                  case 0:
                                    t1 = $.get$length(element.get$vertexNormalsWorld());
                                  case 57:
                                    state = 0;
                                    t1 = $.eqB(t1, 3);
                                }
                              } else {
                                t1 = false;
                              }
                          }
                        } else {
                          t1 = false;
                        }
                        t2 = this._ambientLight;
                      case 58:
                      case 59:
                      case 60:
                      case 61:
                      case 62:
                      case 63:
                      case 64:
                      case 65:
                      case 66:
                      case 67:
                      case 68:
                      case 69:
                      case 70:
                      case 71:
                      case 72:
                      case 73:
                      case 74:
                      case 75:
                      case 76:
                      case 77:
                      case 78:
                      case 79:
                      case 80:
                      case 81:
                      case 82:
                      case 83:
                      case 84:
                      case 85:
                      case 86:
                      case 87:
                      case 88:
                      case 89:
                      case 90:
                        if (state == 58 || state == 59 || state == 60 || state == 61 || state == 62 || state == 63 || state == 64 || state == 65 || state == 66 || state == 67 || state == 68 || state == 69 || state == 70 || state == 71 || state == 72 || state == 73 || state == 74 || state == 75 || state == 76 || state == 77 || state == 78 || state == 79 || state == 80 || state == 81 || state == 82 || state == 83 || state == 84 || (state == 0 && t1)) {
                          switch (state) {
                            case 0:
                              t1 = t2.get$r();
                              t3 = this._color3;
                              t3.set$r(t1);
                              t4 = this._color2;
                              t4.set$r(t1);
                              t5 = this._color1;
                              t5.set$r(t1);
                              t1 = t2.get$g();
                              t3.set$g(t1);
                              t4.set$g(t1);
                              t5.set$g(t1);
                              t2 = t2.get$b();
                              t3.set$b(t2);
                              t4.set$b(t2);
                              t5.set$b(t2);
                              t2 = this._lights;
                              t1 = element.get$v1().get$positionWorld();
                              t6 = element.get$vertexNormalsWorld();
                            case 58:
                              state = 0;
                              this.calculateLight$4(t2, t1, $.index(t6, 0), t5);
                              t1 = this._lights;
                              t2 = element.get$v2().get$positionWorld();
                              t8 = element.get$vertexNormalsWorld();
                            case 59:
                              state = 0;
                              this.calculateLight$4(t1, t2, $.index(t8, 1), t4);
                              t2 = this._lights;
                              t1 = element.get$v3().get$positionWorld();
                              var t10 = element.get$vertexNormalsWorld();
                            case 60:
                              state = 0;
                              this.calculateLight$4(t2, t1, $.index(t10, 2), t3);
                              t1 = material.get$color().get$r();
                            case 61:
                              state = 0;
                              t12 = t5.get$r();
                            case 62:
                              state = 0;
                              t5.set$r($.Math_max(0, $.Math_min($.mul(t1, t12), 1)));
                              t14 = material.get$color().get$g();
                            case 63:
                              state = 0;
                              var t16 = t5.get$g();
                            case 64:
                              state = 0;
                              t5.set$g($.Math_max(0, $.Math_min($.mul(t14, t16), 1)));
                              t18 = material.get$color().get$b();
                            case 65:
                              state = 0;
                              t20 = t5.get$b();
                            case 66:
                              state = 0;
                              t5.set$b($.Math_max(0, $.Math_min($.mul(t18, t20), 1)));
                              t22 = material.get$color().get$r();
                            case 67:
                              state = 0;
                              t24 = t4.get$r();
                            case 68:
                              state = 0;
                              t4.set$r($.Math_max(0, $.Math_min($.mul(t22, t24), 1)));
                              t26 = material.get$color().get$g();
                            case 69:
                              state = 0;
                              t28 = t4.get$g();
                            case 70:
                              state = 0;
                              t4.set$g($.Math_max(0, $.Math_min($.mul(t26, t28), 1)));
                              t30 = material.get$color().get$b();
                            case 71:
                              state = 0;
                              var t32 = t4.get$b();
                            case 72:
                              state = 0;
                              t4.set$b($.Math_max(0, $.Math_min($.mul(t30, t32), 1)));
                              var t34 = material.get$color().get$r();
                            case 73:
                              state = 0;
                              var t36 = t3.get$r();
                            case 74:
                              state = 0;
                              t3.set$r($.Math_max(0, $.Math_min($.mul(t34, t36), 1)));
                              var t38 = material.get$color().get$g();
                            case 75:
                              state = 0;
                              var t40 = t3.get$g();
                            case 76:
                              state = 0;
                              t3.set$g($.Math_max(0, $.Math_min($.mul(t38, t40), 1)));
                              var t42 = material.get$color().get$b();
                            case 77:
                              state = 0;
                              t44 = t3.get$b();
                            case 78:
                              state = 0;
                              t3.set$b($.Math_max(0, $.Math_min($.mul(t42, t44), 1)));
                              t46 = t4.get$r();
                            case 79:
                              state = 0;
                              t48 = t3.get$r();
                            case 80:
                              state = 0;
                              t50 = $.mul($.add(t46, t48), 0.5);
                              var t51 = this._color4;
                              t51.set$r(t50);
                              t50 = t4.get$g();
                            case 81:
                              state = 0;
                              var t53 = t3.get$g();
                            case 82:
                              state = 0;
                              t51.set$g($.mul($.add(t50, t53), 0.5));
                              var t55 = t4.get$b();
                            case 83:
                              state = 0;
                              t57 = t3.get$b();
                            case 84:
                              state = 0;
                              t51.set$b($.mul($.add(t55, t57), 0.5));
                              this._image = this.getGradientTexture$4(t5, t4, t3, t51);
                              this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, 0, 0, 1, 0, 0, 1, this._image);
                          }
                        } else {
                          switch (state) {
                            case 0:
                              t1 = t2.get$r();
                              t3 = this._color;
                              t3.set$r(t1);
                              t3.set$g(t2.get$g());
                              t3.set$b(t2.get$b());
                              this.calculateLight$4(this._lights, element.get$centroidWorld(), element.get$normalWorld(), t3);
                              t1 = material.get$color().get$r();
                            case 85:
                              state = 0;
                              t5 = t3.get$r();
                            case 86:
                              state = 0;
                              t3.set$r($.Math_max(0, $.Math_min($.mul(t1, t5), 1)));
                              t7 = material.get$color().get$g();
                            case 87:
                              state = 0;
                              t9 = t3.get$g();
                            case 88:
                              state = 0;
                              t3.set$g($.Math_max(0, $.Math_min($.mul(t7, t9), 1)));
                              t11 = material.get$color().get$b();
                            case 89:
                              state = 0;
                              t13 = t3.get$b();
                            case 90:
                              state = 0;
                              t3.set$b($.Math_max(0, $.Math_min($.mul(t11, t13), 1)));
                              if (material.get$wireframe() === true) this.strokePath$4(t3, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                              else this.fillPath$1(t3);
                          }
                        }
                    }
                  } else {
                    if (material.get$wireframe() === true) this.strokePath$4(material.get$color(), material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                    else this.fillPath$1(material.get$color());
                  }
              }
            } else {
              switch (state) {
                case 0:
                default:
                  if (state == 91 || state == 92 || state == 93 || state == 94 || state == 95 || state == 96 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$MeshDepthMaterial))) {
                    switch (state) {
                      case 0:
                        this._near = this._camera.get$near();
                        this._far = this._camera.get$far();
                        t1 = this.smoothstep$3(v1.get$positionScreen().get$z(), this._near, this._far);
                        if (typeof t1 !== 'number') throw $.iae(t1);
                        t1 = 1 - t1;
                        t2 = this._color1;
                        t2.set$b(t1);
                        t2.set$g(t1);
                        t2.set$r(t1);
                        t1 = this.smoothstep$3(v2.get$positionScreen().get$z(), this._near, this._far);
                        if (typeof t1 !== 'number') throw $.iae(t1);
                        t1 = 1 - t1;
                        t3 = this._color2;
                        t3.set$b(t1);
                        t3.set$g(t1);
                        t3.set$r(t1);
                        t1 = this.smoothstep$3(v3.get$positionScreen().get$z(), this._near, this._far);
                        if (typeof t1 !== 'number') throw $.iae(t1);
                        t1 = 1 - t1;
                        t4 = this._color3;
                        t4.set$b(t1);
                        t4.set$g(t1);
                        t4.set$r(t1);
                        t1 = t3.get$r();
                      case 91:
                        state = 0;
                        t6 = t4.get$r();
                      case 92:
                        state = 0;
                        t8 = $.mul($.add(t1, t6), 0.5);
                        t9 = this._color4;
                        t9.set$r(t8);
                        t8 = t3.get$g();
                      case 93:
                        state = 0;
                        t11 = t4.get$g();
                      case 94:
                        state = 0;
                        t9.set$g($.mul($.add(t8, t11), 0.5));
                        t13 = t3.get$b();
                      case 95:
                        state = 0;
                        t15 = t4.get$b();
                      case 96:
                        state = 0;
                        t9.set$b($.mul($.add(t13, t15), 0.5));
                        this._image = this.getGradientTexture$4(t2, t3, t4, t9);
                        this.clipImage$13(this._v1x, this._v1y, this._v2x, this._v2y, this._v3x, this._v3y, 0, 0, 1, 0, 0, 1, this._image);
                    }
                  } else {
                    if (typeof material === 'object' && material !== null && !!material.is$MeshNormalMaterial) {
                      t1 = this.normalToComponent$1(element.get$normalWorld().get$x());
                      t2 = this._color;
                      t2.set$r(t1);
                      t2.set$g(this.normalToComponent$1(element.get$normalWorld().get$y()));
                      t2.set$b(this.normalToComponent$1(element.get$normalWorld().get$z()));
                      if (material.get$wireframe() === true) this.strokePath$4(t2, material.get$wireframeLinewidth(), material.get$wireframeLinecap(), material.get$wireframeLinejoin());
                      else this.fillPath$1(t2);
                    }
                  }
              }
            }
        }
      }
  }
 },
 renderLine$5: function(v1, v2, element, material, scene) {
  this.setOpacity$1(material.get$opacity());
  this.setBlending$1(material.get$blending());
  var t1 = this._context;
  t1.beginPath$0();
  t1.moveTo$2(v1.get$positionScreen().get$x(), v1.get$positionScreen().get$y());
  t1.lineTo$2(v2.get$positionScreen().get$x(), v2.get$positionScreen().get$y());
  t1.closePath$0();
  if (typeof material === 'object' && material !== null && !!material.is$LineBasicMaterial) {
    this.setLineWidth$1(material.get$linewidth());
    this.setLineCap$1(material.get$linecap());
    this.setLineJoin$1(material.get$linejoin());
    this.setStrokeStyle$1(material.get$color().getContextStyle$0());
    t1.stroke$0();
    t1 = this._bboxRect;
    var t2 = material.get$linewidth();
    if (typeof t2 !== 'number') return this.renderLine$5$bailout(1, v1, v2, element, t2, t1);
    t1.inflate$1(t2 * 2);
  }
  this.debug === true && $.print('renderLine ' + $.S(element) + ' at (' + $.S(v1.get$positionScreen().get$x()) + ', ' + $.S(v1.get$positionScreen().get$y()) + ') to (' + $.S(v2.get$positionScreen().get$x()) + ', ' + $.S(v2.get$positionScreen().get$y()) + ')');
 },
 renderLine$5$bailout: function(state, env0, env1, env2, env3, env4) {
  switch (state) {
    case 1:
      var v1 = env0;
      var v2 = env1;
      var element = env2;
      t2 = env3;
      t1 = env4;
      break;
  }
  switch (state) {
    case 0:
      this.setOpacity$1(material.get$opacity());
      this.setBlending$1(material.get$blending());
      var t1 = this._context;
      t1.beginPath$0();
      t1.moveTo$2(v1.get$positionScreen().get$x(), v1.get$positionScreen().get$y());
      t1.lineTo$2(v2.get$positionScreen().get$x(), v2.get$positionScreen().get$y());
      t1.closePath$0();
    case 1:
      if (state == 1 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$LineBasicMaterial))) {
        switch (state) {
          case 0:
            this.setLineWidth$1(material.get$linewidth());
            this.setLineCap$1(material.get$linecap());
            this.setLineJoin$1(material.get$linejoin());
            this.setStrokeStyle$1(material.get$color().getContextStyle$0());
            t1.stroke$0();
            t1 = this._bboxRect;
            var t2 = material.get$linewidth();
          case 1:
            state = 0;
            t1.inflate$1($.mul(t2, 2));
        }
      }
      this.debug === true && $.print('renderLine ' + $.S(element) + ' at (' + $.S(v1.get$positionScreen().get$x()) + ', ' + $.S(v1.get$positionScreen().get$y()) + ') to (' + $.S(v2.get$positionScreen().get$x()) + ', ' + $.S(v2.get$positionScreen().get$y()) + ')');
  }
 },
 renderParticle$4: function(v1, element, material, scene) {
  this.setOpacity$1(material.get$opacity());
  this.setBlending$1(material.get$blending());
  if (typeof material === 'object' && material !== null && !!material.is$ParticleBasicMaterial) {
    if (material.get$map() === true) {
      var bitmap = material.get$map().get$image();
      var t1 = bitmap.get$width();
      if (t1 !== (t1 | 0)) return this.renderParticle$4$bailout(1, v1, element, bitmap, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      var bitmapWidth = $.shr(t1, 1);
      t1 = bitmap.get$height();
      if (t1 !== (t1 | 0)) return this.renderParticle$4$bailout(2, v1, element, t1, bitmapWidth, bitmap, 0, 0, 0, 0, 0, 0, 0, 0);
      var bitmapHeight = $.shr(t1, 1);
      t1 = element.get$scale().get$x();
      if (typeof t1 !== 'number') return this.renderParticle$4$bailout(3, v1, element, bitmap, bitmapWidth, bitmapHeight, t1, 0, 0, 0, 0, 0, 0, 0);
      var t5 = this._canvasWidthHalf;
      if (typeof t5 !== 'number') return this.renderParticle$4$bailout(4, v1, element, bitmap, bitmapWidth, bitmapHeight, t1, t5, 0, 0, 0, 0, 0, 0);
      var scaleX = t1 * t5;
      t5 = element.get$scale().get$y();
      if (typeof t5 !== 'number') return this.renderParticle$4$bailout(5, v1, scaleX, element, t5, bitmap, bitmapWidth, bitmapHeight, 0, 0, 0, 0, 0, 0);
      var t7 = this._canvasHeightHalf;
      if (typeof t7 !== 'number') return this.renderParticle$4$bailout(6, v1, scaleX, element, t5, bitmap, t7, bitmapWidth, bitmapHeight, 0, 0, 0, 0, 0);
      var scaleY = t5 * t7;
      var width = scaleX * bitmapWidth;
      var height = scaleY * bitmapHeight;
      t7 = this._bboxRect;
      t5 = v1.get$x();
      if (typeof t5 !== 'number') return this.renderParticle$4$bailout(7, v1, scaleX, element, t7, scaleY, width, bitmapWidth, height, bitmap, t5, bitmapHeight, 0, 0);
      t5 -= width;
      var t10 = v1.get$y();
      if (typeof t10 !== 'number') return this.renderParticle$4$bailout(8, v1, scaleX, element, scaleY, width, height, t5, t10, t7, bitmap, bitmapWidth, bitmapHeight, 0);
      t10 -= height;
      var t12 = v1.get$x();
      if (typeof t12 !== 'number') return this.renderParticle$4$bailout(9, v1, scaleX, element, scaleY, width, height, t5, t10, t7, t12, bitmap, bitmapWidth, bitmapHeight);
      t12 += width;
      var t14 = v1.get$y();
      if (typeof t14 !== 'number') return this.renderParticle$4$bailout(10, v1, scaleX, element, scaleY, height, t5, t10, t7, t12, bitmap, t14, bitmapWidth, bitmapHeight);
      t7.setValues$4(t5, t10, t12, t14 + height);
      if (this._clipRect.intersects$1(t7) !== true) return;
      t1 = this._context;
      t1.save$0();
      t1.translate$2(v1.get$x(), v1.get$y());
      var t2 = element.get$rotation();
      if (typeof t2 !== 'number') return this.renderParticle$4$bailout(11, v1, scaleX, t1, bitmap, scaleY, bitmapWidth, t2, bitmapHeight, 0, 0, 0, 0, 0);
      t1.rotate$1(-t2);
      t1.scale$2(scaleX, -scaleY);
      t1.translate$2(-bitmapWidth, -bitmapHeight);
      t1.drawImage$3(bitmap, 0, 0);
      t1.restore$0();
    }
    t1 = this.debug === true;
    if (t1) {
      t2 = this._context;
      t2.beginPath$0();
      var t3 = v1.get$x();
      if (typeof t3 !== 'number') return this.renderParticle$4$bailout(12, v1, t2, t3, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      t2.moveTo$2(t3 - 10, v1.get$y());
      t5 = v1.get$x();
      if (typeof t5 !== 'number') return this.renderParticle$4$bailout(13, v1, t5, t2, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      t2.lineTo$2(t5 + 10, v1.get$y());
      t7 = v1.get$x();
      var t8 = v1.get$y();
      if (typeof t8 !== 'number') return this.renderParticle$4$bailout(14, v1, t7, t8, t2, t1, 0, 0, 0, 0, 0, 0, 0, 0);
      t2.moveTo$2(t7, t8 - 10);
      t7 = v1.get$x();
      t10 = v1.get$y();
      if (typeof t10 !== 'number') return this.renderParticle$4$bailout(15, v1, t10, t7, t2, t1, 0, 0, 0, 0, 0, 0, 0, 0);
      t2.lineTo$2(t7, t10 + 10);
      t2.closePath$0();
      t2.set$strokeStyle('rgb(255,255,0)');
      t2.stroke$0();
      t1 && $.print('renderParticle ' + $.S(v1) + ' at (' + $.S(v1.get$x()) + ', ' + $.S(v1.get$y()) + ')');
    }
  } else {
    if (typeof material === 'object' && material !== null && !!material.is$ParticleCanvasMaterial) {
      t1 = element.get$scale().get$x();
      if (typeof t1 !== 'number') return this.renderParticle$4$bailout(16, v1, element, material, t1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
      t3 = this._canvasWidthHalf;
      if (typeof t3 !== 'number') return this.renderParticle$4$bailout(17, v1, element, t3, material, t1, 0, 0, 0, 0, 0, 0, 0, 0);
      width = t1 * t3;
      t3 = element.get$scale().get$y();
      if (typeof t3 !== 'number') return this.renderParticle$4$bailout(18, v1, element, width, t3, material, 0, 0, 0, 0, 0, 0, 0, 0);
      t5 = this._canvasHeightHalf;
      if (typeof t5 !== 'number') return this.renderParticle$4$bailout(19, v1, element, t5, width, t3, material, 0, 0, 0, 0, 0, 0, 0);
      height = t3 * t5;
      t5 = this._bboxRect;
      t3 = v1.get$x();
      if (typeof t3 !== 'number') return this.renderParticle$4$bailout(20, v1, element, t3, t5, width, material, height, 0, 0, 0, 0, 0, 0);
      t3 -= width;
      t8 = v1.get$y();
      if (typeof t8 !== 'number') return this.renderParticle$4$bailout(21, v1, element, t3, t8, t5, width, material, height, 0, 0, 0, 0, 0);
      t8 -= height;
      t10 = v1.get$x();
      if (typeof t10 !== 'number') return this.renderParticle$4$bailout(22, v1, element, t3, t8, t5, t10, width, material, height, 0, 0, 0, 0);
      t10 += width;
      t12 = v1.get$y();
      if (typeof t12 !== 'number') return this.renderParticle$4$bailout(23, v1, element, t3, t8, t5, t10, width, t12, material, height, 0, 0, 0);
      t5.setValues$4(t3, t8, t10, t12 + height);
      if (this._clipRect.intersects$1(t5) !== true) return;
      t1 = material.color;
      this.setStrokeStyle$1(t1.getContextStyle$0());
      this.setFillStyle$1(t1.getContextStyle$0());
      t2 = this._context;
      t2.save$0();
      t2.translate$2(v1.get$x(), v1.get$y());
      t3 = element.get$rotation();
      if (typeof t3 !== 'number') return this.renderParticle$4$bailout(24, width, t2, t3, material, height, 0, 0, 0, 0, 0, 0, 0, 0);
      t2.rotate$1(-t3);
      t2.scale$2(width, height);
      material.program$1(t2);
      t2.restore$0();
    }
  }
 },
 renderParticle$4$bailout: function(state, env0, env1, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11, env12) {
  switch (state) {
    case 1:
      var v1 = env0;
      var element = env1;
      bitmap = env2;
      t1 = env3;
      break;
    case 2:
      v1 = env0;
      element = env1;
      t1 = env2;
      bitmapWidth = env3;
      bitmap = env4;
      break;
    case 3:
      v1 = env0;
      element = env1;
      bitmap = env2;
      bitmapWidth = env3;
      bitmapHeight = env4;
      t1 = env5;
      break;
    case 4:
      v1 = env0;
      element = env1;
      bitmap = env2;
      bitmapWidth = env3;
      bitmapHeight = env4;
      t1 = env5;
      t5 = env6;
      break;
    case 5:
      v1 = env0;
      scaleX = env1;
      element = env2;
      t5 = env3;
      bitmap = env4;
      bitmapWidth = env5;
      bitmapHeight = env6;
      break;
    case 6:
      v1 = env0;
      scaleX = env1;
      element = env2;
      t5 = env3;
      bitmap = env4;
      t7 = env5;
      bitmapWidth = env6;
      bitmapHeight = env7;
      break;
    case 7:
      v1 = env0;
      scaleX = env1;
      element = env2;
      t7 = env3;
      scaleY = env4;
      width = env5;
      bitmapWidth = env6;
      height = env7;
      bitmap = env8;
      t5 = env9;
      bitmapHeight = env10;
      break;
    case 8:
      v1 = env0;
      scaleX = env1;
      element = env2;
      scaleY = env3;
      width = env4;
      height = env5;
      t5 = env6;
      t10 = env7;
      t7 = env8;
      bitmap = env9;
      bitmapWidth = env10;
      bitmapHeight = env11;
      break;
    case 9:
      v1 = env0;
      scaleX = env1;
      element = env2;
      scaleY = env3;
      width = env4;
      height = env5;
      t5 = env6;
      t10 = env7;
      t7 = env8;
      t12 = env9;
      bitmap = env10;
      bitmapWidth = env11;
      bitmapHeight = env12;
      break;
    case 10:
      v1 = env0;
      scaleX = env1;
      element = env2;
      scaleY = env3;
      height = env4;
      t5 = env5;
      t10 = env6;
      t7 = env7;
      t12 = env8;
      bitmap = env9;
      t14 = env10;
      bitmapWidth = env11;
      bitmapHeight = env12;
      break;
    case 11:
      v1 = env0;
      scaleX = env1;
      t1 = env2;
      bitmap = env3;
      scaleY = env4;
      bitmapWidth = env5;
      t2 = env6;
      bitmapHeight = env7;
      break;
    case 12:
      v1 = env0;
      t2 = env1;
      t3 = env2;
      t1 = env3;
      break;
    case 13:
      v1 = env0;
      t5 = env1;
      t2 = env2;
      t1 = env3;
      break;
    case 14:
      v1 = env0;
      t7 = env1;
      t8 = env2;
      t2 = env3;
      t1 = env4;
      break;
    case 15:
      v1 = env0;
      t10 = env1;
      t7 = env2;
      t2 = env3;
      t1 = env4;
      break;
    case 16:
      v1 = env0;
      element = env1;
      var material = env2;
      t1 = env3;
      break;
    case 17:
      v1 = env0;
      element = env1;
      t3 = env2;
      material = env3;
      t1 = env4;
      break;
    case 18:
      v1 = env0;
      element = env1;
      width = env2;
      t3 = env3;
      material = env4;
      break;
    case 19:
      v1 = env0;
      element = env1;
      t5 = env2;
      width = env3;
      t3 = env4;
      material = env5;
      break;
    case 20:
      v1 = env0;
      element = env1;
      t3 = env2;
      t5 = env3;
      width = env4;
      material = env5;
      height = env6;
      break;
    case 21:
      v1 = env0;
      element = env1;
      t3 = env2;
      t8 = env3;
      t5 = env4;
      width = env5;
      material = env6;
      height = env7;
      break;
    case 22:
      v1 = env0;
      element = env1;
      t3 = env2;
      t8 = env3;
      t5 = env4;
      t10 = env5;
      width = env6;
      material = env7;
      height = env8;
      break;
    case 23:
      v1 = env0;
      element = env1;
      t3 = env2;
      t8 = env3;
      t5 = env4;
      t10 = env5;
      width = env6;
      t12 = env7;
      material = env8;
      height = env9;
      break;
    case 24:
      width = env0;
      t2 = env1;
      t3 = env2;
      material = env3;
      height = env4;
      break;
  }
  switch (state) {
    case 0:
      this.setOpacity$1(material.get$opacity());
      this.setBlending$1(material.get$blending());
    default:
      if (state == 1 || state == 2 || state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 11 || state == 12 || state == 13 || state == 14 || state == 15 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$ParticleBasicMaterial))) {
        switch (state) {
          case 0:
          default:
            if (state == 1 || state == 2 || state == 3 || state == 4 || state == 5 || state == 6 || state == 7 || state == 8 || state == 9 || state == 10 || state == 11 || (state == 0 && material.get$map() === true)) {
              switch (state) {
                case 0:
                  var bitmap = material.get$map().get$image();
                  var t1 = bitmap.get$width();
                case 1:
                  state = 0;
                  var bitmapWidth = $.shr(t1, 1);
                  t1 = bitmap.get$height();
                case 2:
                  state = 0;
                  var bitmapHeight = $.shr(t1, 1);
                  t1 = element.get$scale().get$x();
                case 3:
                  state = 0;
                  var t5 = this._canvasWidthHalf;
                case 4:
                  state = 0;
                  var scaleX = $.mul(t1, t5);
                  t5 = element.get$scale().get$y();
                case 5:
                  state = 0;
                  var t7 = this._canvasHeightHalf;
                case 6:
                  state = 0;
                  var scaleY = $.mul(t5, t7);
                  var width = $.mul(scaleX, bitmapWidth);
                  var height = $.mul(scaleY, bitmapHeight);
                  t7 = this._bboxRect;
                  t5 = v1.get$x();
                case 7:
                  state = 0;
                  t5 = $.sub(t5, width);
                  var t10 = v1.get$y();
                case 8:
                  state = 0;
                  t10 = $.sub(t10, height);
                  var t12 = v1.get$x();
                case 9:
                  state = 0;
                  t12 = $.add(t12, width);
                  var t14 = v1.get$y();
                case 10:
                  state = 0;
                  t7.setValues$4(t5, t10, t12, $.add(t14, height));
                  if (this._clipRect.intersects$1(t7) !== true) return;
                  t1 = this._context;
                  t1.save$0();
                  t1.translate$2(v1.get$x(), v1.get$y());
                  var t2 = element.get$rotation();
                case 11:
                  state = 0;
                  t1.rotate$1($.neg(t2));
                  t1.scale$2(scaleX, $.neg(scaleY));
                  t1.translate$2($.neg(bitmapWidth), $.neg(bitmapHeight));
                  t1.drawImage$3(bitmap, 0, 0);
                  t1.restore$0();
              }
            }
            t1 = this.debug === true;
          case 12:
          case 13:
          case 14:
          case 15:
            if (state == 12 || state == 13 || state == 14 || state == 15 || (state == 0 && t1)) {
              switch (state) {
                case 0:
                  t2 = this._context;
                  t2.beginPath$0();
                  var t3 = v1.get$x();
                case 12:
                  state = 0;
                  t2.moveTo$2($.sub(t3, 10), v1.get$y());
                  t5 = v1.get$x();
                case 13:
                  state = 0;
                  t2.lineTo$2($.add(t5, 10), v1.get$y());
                  t7 = v1.get$x();
                  var t8 = v1.get$y();
                case 14:
                  state = 0;
                  t2.moveTo$2(t7, $.sub(t8, 10));
                  t7 = v1.get$x();
                  t10 = v1.get$y();
                case 15:
                  state = 0;
                  t2.lineTo$2(t7, $.add(t10, 10));
                  t2.closePath$0();
                  t2.set$strokeStyle('rgb(255,255,0)');
                  t2.stroke$0();
                  t1 && $.print('renderParticle ' + $.S(v1) + ' at (' + $.S(v1.get$x()) + ', ' + $.S(v1.get$y()) + ')');
              }
            }
        }
      } else {
        switch (state) {
          case 0:
          default:
            if (state == 16 || state == 17 || state == 18 || state == 19 || state == 20 || state == 21 || state == 22 || state == 23 || state == 24 || (state == 0 && ((typeof material === 'object' && material !== null) && !!material.is$ParticleCanvasMaterial))) {
              switch (state) {
                case 0:
                  t1 = element.get$scale().get$x();
                case 16:
                  state = 0;
                  t3 = this._canvasWidthHalf;
                case 17:
                  state = 0;
                  width = $.mul(t1, t3);
                  t3 = element.get$scale().get$y();
                case 18:
                  state = 0;
                  t5 = this._canvasHeightHalf;
                case 19:
                  state = 0;
                  height = $.mul(t3, t5);
                  t5 = this._bboxRect;
                  t3 = v1.get$x();
                case 20:
                  state = 0;
                  t3 = $.sub(t3, width);
                  t8 = v1.get$y();
                case 21:
                  state = 0;
                  t8 = $.sub(t8, height);
                  t10 = v1.get$x();
                case 22:
                  state = 0;
                  t10 = $.add(t10, width);
                  t12 = v1.get$y();
                case 23:
                  state = 0;
                  t5.setValues$4(t3, t8, t10, $.add(t12, height));
                  if (this._clipRect.intersects$1(t5) !== true) return;
                  t1 = material.color;
                  this.setStrokeStyle$1(t1.getContextStyle$0());
                  this.setFillStyle$1(t1.getContextStyle$0());
                  t2 = this._context;
                  t2.save$0();
                  t2.translate$2(v1.get$x(), v1.get$y());
                  t3 = element.get$rotation();
                case 24:
                  state = 0;
                  t2.rotate$1($.neg(t3));
                  t2.scale$2(width, height);
                  material.program$1(t2);
                  t2.restore$0();
              }
            }
        }
      }
  }
 },
 calculateLight$4: function(lights, position, normal, color) {
  if (typeof lights !== 'string' && (typeof lights !== 'object' || lights === null || (lights.constructor !== Array && !lights.is$JavaScriptIndexingBehavior()))) return this.calculateLight$4$bailout(1, lights, position, normal, color);
  var ll = lights.length;
  for (var t1 = this._vector3, amount = null, lightPosition = null, light = null, lightColor = null, l = 0; l < ll; ++l) {
    var t2 = lights.length;
    if (l < 0 || l >= t2) throw $.ioore(l);
    light = lights[l];
    lightColor = light.get$color();
    if (typeof light === 'object' && light !== null && !!light.is$DirectionalLight) {
      lightPosition = light.matrixWorld.getPosition$0();
      amount = normal.dot$1(lightPosition);
      if ($.leB(amount, 0)) continue;
      amount = $.mul(amount, light.get$intensity());
      color.set$r($.add(color.get$r(), $.mul(lightColor.get$r(), amount)));
      color.set$g($.add(color.get$g(), $.mul(lightColor.get$g(), amount)));
      color.set$b($.add(color.get$b(), $.mul(lightColor.get$b(), amount)));
    } else {
      if (typeof light === 'object' && light !== null && !!light.is$PointLight) {
        lightPosition = light.matrixWorld.getPosition$0();
        amount = normal.dot$1(t1.sub$2(lightPosition, position).normalize$0());
        if ($.leB(amount, 0)) continue;
        if ($.eqB(light.get$distance(), 0)) t2 = 1;
        else {
          t2 = $.Math_min($.div(position.distanceTo$1(lightPosition), light.get$distance()), 1);
          if (typeof t2 !== 'number') throw $.iae(t2);
          t2 = 1 - t2;
        }
        amount = $.mul(amount, t2);
        if ($.eqB(amount, 0)) continue;
        amount = $.mul(amount, light.get$intensity());
        color.set$r($.add(color.get$r(), $.mul(lightColor.get$r(), amount)));
        color.set$g($.add(color.get$g(), $.mul(lightColor.get$g(), amount)));
        color.set$b($.add(color.get$b(), $.mul(lightColor.get$b(), amount)));
      }
    }
  }
 },
 calculateLight$4$bailout: function(state, lights, position, normal, color) {
  var ll = $.get$length(lights);
  for (var t1 = this._vector3, amount = null, lightPosition = null, light = null, lightColor = null, l = 0; $.ltB(l, ll); ++l) {
    light = $.index(lights, l);
    lightColor = light.get$color();
    if (typeof light === 'object' && light !== null && !!light.is$DirectionalLight) {
      lightPosition = light.get$matrixWorld().getPosition$0();
      amount = normal.dot$1(lightPosition);
      if ($.leB(amount, 0)) continue;
      amount = $.mul(amount, light.get$intensity());
      color.set$r($.add(color.get$r(), $.mul(lightColor.get$r(), amount)));
      color.set$g($.add(color.get$g(), $.mul(lightColor.get$g(), amount)));
      color.set$b($.add(color.get$b(), $.mul(lightColor.get$b(), amount)));
    } else {
      if (typeof light === 'object' && light !== null && !!light.is$PointLight) {
        lightPosition = light.get$matrixWorld().getPosition$0();
        amount = normal.dot$1(t1.sub$2(lightPosition, position).normalize$0());
        if ($.leB(amount, 0)) continue;
        if ($.eqB(light.get$distance(), 0)) var t2 = 1;
        else {
          t2 = $.Math_min($.div(position.distanceTo$1(lightPosition), light.get$distance()), 1);
          if (typeof t2 !== 'number') throw $.iae(t2);
          t2 = 1 - t2;
        }
        amount = $.mul(amount, t2);
        if ($.eqB(amount, 0)) continue;
        amount = $.mul(amount, light.get$intensity());
        color.set$r($.add(color.get$r(), $.mul(lightColor.get$r(), amount)));
        color.set$g($.add(color.get$g(), $.mul(lightColor.get$g(), amount)));
        color.set$b($.add(color.get$b(), $.mul(lightColor.get$b(), amount)));
      }
    }
  }
 },
 calculateLights$1: function(lights) {
  if (typeof lights !== 'string' && (typeof lights !== 'object' || lights === null || (lights.constructor !== Array && !lights.is$JavaScriptIndexingBehavior()))) return this.calculateLights$1$bailout(1, lights);
  var t1 = this._ambientLight;
  t1.setRGB$3(0, 0, 0);
  var t2 = this._directionalLights;
  t2.setRGB$3(0, 0, 0);
  var t3 = this._pointLights;
  t3.setRGB$3(0, 0, 0);
  var ll = lights.length;
  for (var light = null, lightColor = null, l = 0; l < ll; ++l) {
    var t4 = lights.length;
    if (l < 0 || l >= t4) throw $.ioore(l);
    light = lights[l];
    lightColor = light.get$color();
    if (typeof light === 'object' && light !== null && !!light.is$AmbientLight) {
      t1.r = $.add(t1.r, lightColor.get$r());
      t1.g = $.add(t1.g, lightColor.get$g());
      t1.b = $.add(t1.b, lightColor.get$b());
    } else {
      if (typeof light === 'object' && light !== null && !!light.is$DirectionalLight) {
        t2.r = $.add(t2.r, lightColor.get$r());
        t2.g = $.add(t2.g, lightColor.get$g());
        t2.b = $.add(t2.b, lightColor.get$b());
      } else {
        if (typeof light === 'object' && light !== null && !!light.is$PointLight) {
          t3.r = $.add(t3.r, lightColor.get$r());
          t3.g = $.add(t3.g, lightColor.get$g());
          t3.b = $.add(t3.b, lightColor.get$b());
        }
      }
    }
  }
 },
 calculateLights$1$bailout: function(state, lights) {
  var t1 = this._ambientLight;
  t1.setRGB$3(0, 0, 0);
  var t2 = this._directionalLights;
  t2.setRGB$3(0, 0, 0);
  var t3 = this._pointLights;
  t3.setRGB$3(0, 0, 0);
  var ll = $.get$length(lights);
  for (var light = null, lightColor = null, l = 0; $.ltB(l, ll); ++l) {
    light = $.index(lights, l);
    lightColor = light.get$color();
    if (typeof light === 'object' && light !== null && !!light.is$AmbientLight) {
      t1.set$r($.add(t1.get$r(), lightColor.get$r()));
      t1.set$g($.add(t1.get$g(), lightColor.get$g()));
      t1.set$b($.add(t1.get$b(), lightColor.get$b()));
    } else {
      if (typeof light === 'object' && light !== null && !!light.is$DirectionalLight) {
        t2.set$r($.add(t2.get$r(), lightColor.get$r()));
        t2.set$g($.add(t2.get$g(), lightColor.get$g()));
        t2.set$b($.add(t2.get$b(), lightColor.get$b()));
      } else {
        if (typeof light === 'object' && light !== null && !!light.is$PointLight) {
          t3.set$r($.add(t3.get$r(), lightColor.get$r()));
          t3.set$g($.add(t3.get$g(), lightColor.get$g()));
          t3.set$b($.add(t3.get$b(), lightColor.get$b()));
        }
      }
    }
  }
 },
 render$2: function(scene, camera) {
  this._camera = camera;
  if (this._autoClear) this.clear$0();
  else this._context.setTransform$6(1, 0, 0, -1, this._canvasWidthHalf, this._canvasHeightHalf);
  this._info.render.reset$0();
  this._renderData = this._projector.projectScene$3(scene, camera, this._sortElements);
  this._elements = this._renderData.get$elements();
  this._lights = this._renderData.get$lights();
  var t1 = this.debug === true;
  if (t1) {
    var t2 = this._context;
    t2.set$fillStyle('rgba( 0, 255, 255, 0.5 )');
    var t3 = this._clipRect;
    t2.fillRect$4(t3.getX$0(), t3.getY$0(), t3.getWidth$0(), t3.getHeight$0());
  }
  this._enableLighting = $.gt($.get$length(this._lights), 0);
  this._enableLighting === true && this.calculateLights$1(this._lights);
  var el = $.get$length(this._elements);
  if (typeof el !== 'number') return this.render$2$bailout(1, scene, t1, el);
  for (t2 = this._bboxRect, t3 = this._clipRect, t4 = this._v5, t5 = this._v6, t6 = this._context, t7 = this._clearRect, t8 = t4.positionScreen, t9 = t5.positionScreen, e = 0, element = null, material = null; e < el; ++e) {
    element = $.index(this._elements, e);
    material = element.get$material();
    if (typeof material === 'object' && material !== null && !!material.is$MeshFaceMaterial) material = element.get$faceMaterial();
    if (material == null || $.eqB(material.get$opacity(), 0)) continue;
    t2.empty$0();
    t1 && $.print($.S(element));
    if (typeof element === 'object' && element !== null && !!element.is$RenderableParticle) {
      element.x = $.mul(element.x, this._canvasWidthHalf);
      element.y = $.mul(element.y, this._canvasHeightHalf);
      this.renderParticle$4(element, element, material, scene);
    } else {
      if (typeof element === 'object' && element !== null && !!element.is$RenderableLine) {
        var _v1 = element.v1;
        var _v2 = element.v2;
        var t10 = _v1.get$positionScreen();
        t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
        t10 = _v1.get$positionScreen();
        t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
        t10 = _v2.positionScreen;
        t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
        t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
        t2.addPoint$2(_v1.get$positionScreen().get$x(), _v1.get$positionScreen().get$y());
        t2.addPoint$2(t10.get$x(), t10.get$y());
        t3.intersects$1(t2) === true && this.renderLine$5(_v1, _v2, element, material, scene);
      } else {
        if (typeof element === 'object' && element !== null && !!element.is$RenderableFace3) {
          _v1 = element.get$v1();
          _v2 = element.get$v2();
          var _v3 = element.get$v3();
          t10 = _v1.get$positionScreen();
          t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
          t10 = _v1.get$positionScreen();
          t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
          t10 = _v2.get$positionScreen();
          t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
          t10 = _v2.get$positionScreen();
          t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
          t10 = _v3.get$positionScreen();
          t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
          t10 = _v3.get$positionScreen();
          t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
          if (material.get$overdraw() === true) {
            this.expand$2(_v1.get$positionScreen(), _v2.get$positionScreen());
            this.expand$2(_v2.get$positionScreen(), _v3.get$positionScreen());
            this.expand$2(_v3.get$positionScreen(), _v1.get$positionScreen());
          }
          t2.add3Points$6(_v1.get$positionScreen().get$x(), _v1.get$positionScreen().get$y(), _v2.get$positionScreen().get$x(), _v2.get$positionScreen().get$y(), _v3.get$positionScreen().get$x(), _v3.get$positionScreen().get$y());
          t3.intersects$1(t2) === true && this.renderFace3$9(_v1, _v2, _v3, 0, 1, 2, element, material, scene);
        } else {
          if (typeof element === 'object' && element !== null && !!element.is$RenderableFace4) {
            _v1 = element.get$v1();
            _v2 = element.get$v2();
            _v3 = element.get$v3();
            var _v4 = element.get$v4();
            t10 = _v1.get$positionScreen();
            t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
            t10 = _v1.get$positionScreen();
            t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
            t10 = _v2.get$positionScreen();
            t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
            t10 = _v2.get$positionScreen();
            t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
            t10 = _v3.get$positionScreen();
            t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
            t10 = _v3.get$positionScreen();
            t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
            t10 = _v4.get$positionScreen();
            t10.set$x($.mul(t10.get$x(), this._canvasWidthHalf));
            t10 = _v4.get$positionScreen();
            t10.set$y($.mul(t10.get$y(), this._canvasHeightHalf));
            t8.copy$1(_v2.get$positionScreen());
            t9.copy$1(_v4.get$positionScreen());
            if (material.get$overdraw() === true) {
              this.expand$2(_v1.get$positionScreen(), _v2.get$positionScreen());
              this.expand$2(_v2.get$positionScreen(), _v4.get$positionScreen());
              this.expand$2(_v4.get$positionScreen(), _v1.get$positionScreen());
              this.expand$2(_v3.get$positionScreen(), t8);
              this.expand$2(_v3.get$positionScreen(), t9);
            }
            t2.addPoint$2(_v1.get$positionScreen().get$x(), _v1.get$positionScreen().get$y());
            t2.addPoint$2(_v2.get$positionScreen().get$x(), _v2.get$positionScreen().get$y());
            t2.addPoint$2(_v3.get$positionScreen().get$x(), _v3.get$positionScreen().get$y());
            t2.addPoint$2(_v4.get$positionScreen().get$x(), _v4.get$positionScreen().get$y());
            t3.intersects$1(t2) === true && this.renderFace4$9(_v1, _v2, _v3, _v4, t4, t5, element, material, scene);
          }
        }
      }
    }
    if (t1) {
      t6.set$lineWidth(1);
      t6.set$strokeStyle('rgba( 0, 255, 0, 0.5 )');
      t6.strokeRect$4(t2.getX$0(), t2.getY$0(), t2.getWidth$0(), t2.getHeight$0());
    }
    t7.addRectangle$1(t2);
  }
  if (t1) {
    t6.set$lineWidth(1);
    t6.set$strokeStyle('rgba( 255, 0, 0, 0.5 )');
    t6.strokeRect$4(t7.getX$0(), t7.getY$0(), t7.getWidth$0(), t7.getHeight$0());
  }
  t6.setTransform$6(1, 0, 0, 1, 0, 0);
  var e, t7, t4, t8, t9, t6, t5, element, material;
 },
 render$2$bailout: function(state, scene, t1, el) {
  for (var t2 = this._bboxRect, t3 = this._clipRect, t4 = this._v5, t5 = this._v6, t6 = this._context, t7 = this._clearRect, e = 0, element = null, material = null; $.ltB(e, el); ++e) {
    element = $.index(this._elements, e);
    material = element.get$material();
    if (typeof material === 'object' && material !== null && !!material.is$MeshFaceMaterial) material = element.get$faceMaterial();
    if (material == null || $.eqB(material.get$opacity(), 0)) continue;
    t2.empty$0();
    t1 && $.print($.S(element));
    if (typeof element === 'object' && element !== null && !!element.is$RenderableParticle) {
      element.x = $.mul(element.get$x(), this._canvasWidthHalf);
      element.y = $.mul(element.y, this._canvasHeightHalf);
      this.renderParticle$4(element, element, material, scene);
    } else {
      if (typeof element === 'object' && element !== null && !!element.is$RenderableLine) {
        var _v1 = element.get$v1();
        var _v2 = element.v2;
        var t8 = _v1.get$positionScreen();
        t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
        t8 = _v1.get$positionScreen();
        t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
        t8 = _v2.get$positionScreen();
        t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
        t8 = _v2.get$positionScreen();
        t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
        t2.addPoint$2(_v1.get$positionScreen().get$x(), _v1.get$positionScreen().get$y());
        t2.addPoint$2(_v2.get$positionScreen().get$x(), _v2.get$positionScreen().get$y());
        t3.intersects$1(t2) === true && this.renderLine$5(_v1, _v2, element, material, scene);
      } else {
        if (typeof element === 'object' && element !== null && !!element.is$RenderableFace3) {
          _v1 = element.get$v1();
          _v2 = element.get$v2();
          var _v3 = element.get$v3();
          t8 = _v1.get$positionScreen();
          t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
          t8 = _v1.get$positionScreen();
          t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
          t8 = _v2.get$positionScreen();
          t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
          t8 = _v2.get$positionScreen();
          t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
          t8 = _v3.get$positionScreen();
          t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
          t8 = _v3.get$positionScreen();
          t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
          if (material.get$overdraw() === true) {
            this.expand$2(_v1.get$positionScreen(), _v2.get$positionScreen());
            this.expand$2(_v2.get$positionScreen(), _v3.get$positionScreen());
            this.expand$2(_v3.get$positionScreen(), _v1.get$positionScreen());
          }
          t2.add3Points$6(_v1.get$positionScreen().get$x(), _v1.get$positionScreen().get$y(), _v2.get$positionScreen().get$x(), _v2.get$positionScreen().get$y(), _v3.get$positionScreen().get$x(), _v3.get$positionScreen().get$y());
          t3.intersects$1(t2) === true && this.renderFace3$9(_v1, _v2, _v3, 0, 1, 2, element, material, scene);
        } else {
          if (typeof element === 'object' && element !== null && !!element.is$RenderableFace4) {
            _v1 = element.get$v1();
            _v2 = element.get$v2();
            _v3 = element.get$v3();
            var _v4 = element.get$v4();
            t8 = _v1.get$positionScreen();
            t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
            t8 = _v1.get$positionScreen();
            t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
            t8 = _v2.get$positionScreen();
            t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
            t8 = _v2.get$positionScreen();
            t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
            t8 = _v3.get$positionScreen();
            t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
            t8 = _v3.get$positionScreen();
            t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
            t8 = _v4.get$positionScreen();
            t8.set$x($.mul(t8.get$x(), this._canvasWidthHalf));
            t8 = _v4.get$positionScreen();
            t8.set$y($.mul(t8.get$y(), this._canvasHeightHalf));
            t4.get$positionScreen().copy$1(_v2.get$positionScreen());
            t5.get$positionScreen().copy$1(_v4.get$positionScreen());
            if (material.get$overdraw() === true) {
              this.expand$2(_v1.get$positionScreen(), _v2.get$positionScreen());
              this.expand$2(_v2.get$positionScreen(), _v4.get$positionScreen());
              this.expand$2(_v4.get$positionScreen(), _v1.get$positionScreen());
              this.expand$2(_v3.get$positionScreen(), t4.get$positionScreen());
              this.expand$2(_v3.get$positionScreen(), t5.get$positionScreen());
            }
            t2.addPoint$2(_v1.get$positionScreen().get$x(), _v1.get$positionScreen().get$y());
            t2.addPoint$2(_v2.get$positionScreen().get$x(), _v2.get$positionScreen().get$y());
            t2.addPoint$2(_v3.get$positionScreen().get$x(), _v3.get$positionScreen().get$y());
            t2.addPoint$2(_v4.get$positionScreen().get$x(), _v4.get$positionScreen().get$y());
            t3.intersects$1(t2) === true && this.renderFace4$9(_v1, _v2, _v3, _v4, t4, t5, element, material, scene);
          }
        }
      }
    }
    if (t1) {
      t6.set$lineWidth(1);
      t6.set$strokeStyle('rgba( 0, 255, 0, 0.5 )');
      t6.strokeRect$4(t2.getX$0(), t2.getY$0(), t2.getWidth$0(), t2.getHeight$0());
    }
    t7.addRectangle$1(t2);
  }
  if (t1) {
    t6.set$lineWidth(1);
    t6.set$strokeStyle('rgba( 255, 0, 0, 0.5 )');
    t6.strokeRect$4(t7.getX$0(), t7.getY$0(), t7.getWidth$0(), t7.getHeight$0());
  }
  t6.setTransform$6(1, 0, 0, 1, 0, 0);
 },
 get$render: function() { return new $.BoundClosure2(this, 'render$2'); },
 clear$0: function() {
  var t1 = this._context;
  t1.setTransform$6(1, 0, 0, -1, this._canvasWidthHalf, this._canvasHeightHalf);
  var t2 = this._clearRect;
  if ($.isEmpty(t2) !== true) {
    t2.minSelf$1(this._clipRect);
    t2.inflate$1(2);
    var t3 = this._clearOpacity;
    t3 < 1 && t1.clearRect$4($.floor(t2.getX$0()), $.floor(t2.getY$0()), $.floor(t2.getWidth$0()), $.floor(t2.getHeight$0()));
    if (t3 > 0) {
      this.setBlending$1(0);
      this.setOpacity$1(1);
      var t4 = this._clearColor;
      this.setFillStyle$1('rgba(' + $.S($.floor($.mul(t4.get$r(), 255))) + ', ' + $.S($.floor($.mul(t4.get$g(), 255))) + ',' + $.S($.floor($.mul(t4.get$b(), 255))) + ',' + $.S(t3) + ')');
      t1.fillRect$4($.floor(t2.getX$0()), $.floor(t2.getY$0()), $.floor(t2.getWidth$0()), $.floor(t2.getHeight$0()));
    }
    t2.empty$0();
  }
 },
 setSize$2: function(width, height) {
  this._canvasWidth = width;
  this._canvasHeight = height;
  this._canvasWidthHalf = $.floor($.div(this._canvasWidth, 2));
  this._canvasHeightHalf = $.floor($.div(this._canvasHeight, 2));
  var t1 = this._canvasWidth;
  var t2 = this._canvas;
  t2.set$width(t1);
  t2.set$height(this._canvasHeight);
  this._clipRect.setValues$4($.neg(this._canvasWidthHalf), $.neg(this._canvasHeightHalf), this._canvasWidthHalf, this._canvasHeightHalf);
  this._clearRect.setValues$4($.neg(this._canvasWidthHalf), $.neg(this._canvasHeightHalf), this._canvasWidthHalf, this._canvasHeightHalf);
  this._contextGlobalAlpha = 1;
  this._contextGlobalCompositeOperation = 0;
  this._contextStrokeStyle = null;
  this._contextFillStyle = null;
  this._contextLineWidth = null;
  this._contextLineCap = null;
  this._contextLineJoin = null;
 },
 CanvasRenderer$1: function(parameters) {
  parameters = !(parameters == null) ? parameters : $.makeLiteralMap([]);
  this._projector = $.Projector$();
  this._canvas = !($.index(parameters, 'canvas') == null) ? $.index(parameters, 'canvas') : $._ElementFactoryProvider_Element$tag('canvas');
  var t1 = this._canvas;
  this._context = t1.getContext$1('2d');
  this.debug = !($.index(parameters, 'debug') == null) && $.index(parameters, 'debug');
  this._clearColor = $.Color$(0);
  this._clearOpacity = 0;
  this._contextGlobalAlpha = 1;
  this._contextGlobalCompositeOperation = 0;
  this._contextStrokeStyle = null;
  this._contextFillStyle = null;
  this._contextLineWidth = null;
  this._contextLineCap = null;
  this._contextLineJoin = null;
  this._v5 = $.RenderableVertex$();
  this._v6 = $.RenderableVertex$();
  this._color = $.Color$(null);
  this._color1 = $.Color$(null);
  this._color2 = $.Color$(null);
  this._color3 = $.Color$(null);
  this._color4 = $.Color$(null);
  this._patterns = [];
  this._imagedatas = [];
  this._clipRect = $.Rectangle$();
  this._clearRect = $.Rectangle$();
  this._bboxRect = $.Rectangle$();
  this._enableLighting = false;
  this._ambientLight = $.Color$(null);
  this._directionalLights = $.Color$(null);
  this._pointLights = $.Color$(null);
  this._vector3 = $.Vector3$(0, 0, 0);
  this._gradientMapQuality = 16;
  this._pixelMap = $._ElementFactoryProvider_Element$tag('canvas');
  var t2 = this._pixelMap;
  t2.set$height(2);
  t2.set$width(2);
  this._pixelMapContext = t2.getContext$1('2d');
  var t3 = this._pixelMapContext;
  t3.set$fillStyle('rgba(0,0,0,1)');
  t3.fillRect$4(0, 0, 2, 2);
  this._pixelMapImage = t3.getImageData$4(0, 0, 2, 2);
  this._pixelMapData = this._pixelMapImage.get$data();
  this._gradientMap = $._ElementFactoryProvider_Element$tag('canvas');
  var t4 = this._gradientMapQuality;
  var t5 = this._gradientMap;
  t5.set$height(t4);
  t5.set$width(t4);
  this._gradientMapContext = t5.getContext$1('2d');
  var t6 = this._gradientMapContext;
  t6.translate$2($.div($.neg(t4), 2), $.div($.neg(t4), 2));
  t6.scale$2(t4, t4);
  this._gradientMapQuality = $.sub(t4, 1);
  this.domElement = t1;
  this._autoClear = true;
  this._sortObjects = true;
  this._sortElements = true;
  this._info = $.CanvasRenderData$();
 }
};

$$.CanvasRenderData = {"":
 ["render?"],
 super: "Object",
 render$2: function(arg0, arg1) { return this.render.$call$2(arg0, arg1); },
 CanvasRenderData$0: function() {
  this.render = $.RenderInts$();
 }
};

$$.RenderInts = {"":
 ["faces=", "vertices="],
 super: "Object",
 reset$0: function() {
  this.vertices = 0;
  this.faces = 0;
 },
 RenderInts$0: function() {
  this.reset$0();
 }
};

$$.Scene = {"":
 ["__objectsRemoved", "__objectsAdded", "lights=", "objects=", "overrideMaterial", "fog", "_vector", "frustumCulled", "receiveShadow", "castShadow", "visible", "boundRadiusScale", "boundRadius", "useQuaternion", "quaternion", "matrixWorldNeedsUpdate", "matrixAutoUpdate", "matrixRotationWorld", "matrixWorld", "matrix", "renderDepth", "rotationAutoUpdate", "flipSided", "doubleSided", "dynamic", "eulerOrder", "scale", "rotation", "position", "up", "children", "parent", "id", "_name"],
 super: "Object3D",
 removeObject$1: function(object) {
  if (typeof object === 'object' && object !== null && !!object.is$Light) {
    var i = $.indexOf$1(this.lights, object);
    !(i === -1) && $.removeRange(this.lights, i, 1);
  } else {
    if (!((typeof object === 'object' && object !== null) && !!object.is$Camera)) {
      i = $.indexOf$1(this.objects, object);
      if (!(i === -1)) {
        $.removeRange(this.objects, i, 1);
        $.add$1(this.__objectsRemoved, object);
        var t1 = this.__objectsAdded;
        var ai = $.indexOf$1(t1, object);
        !(ai === -1) && $.removeRange(t1, ai, 1);
      }
    }
  }
  var c = 0;
  while (true) {
    t1 = $.get$length(object.get$children());
    if (typeof t1 !== 'number') return this.removeObject$1$bailout(1, object, c, t1);
    if (!(c < t1)) break;
    t1 = object.get$children();
    if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.removeObject$1$bailout(2, object, c, t1);
    var t3 = t1.length;
    if (c < 0 || c >= t3) throw $.ioore(c);
    this.removeObject$1(t1[c]);
    ++c;
  }
 },
 removeObject$1$bailout: function(state, env0, env1, env2) {
  switch (state) {
    case 1:
      var object = env0;
      c = env1;
      t1 = env2;
      break;
    case 2:
      object = env0;
      c = env1;
      t1 = env2;
      break;
  }
  switch (state) {
    case 0:
      if (typeof object === 'object' && object !== null && !!object.is$Light) {
        var i = $.indexOf$1(this.lights, object);
        !(i === -1) && $.removeRange(this.lights, i, 1);
      } else {
        if (!((typeof object === 'object' && object !== null) && !!object.is$Camera)) {
          i = $.indexOf$1(this.objects, object);
          if (!(i === -1)) {
            $.removeRange(this.objects, i, 1);
            $.add$1(this.__objectsRemoved, object);
            var t1 = this.__objectsAdded;
            var ai = $.indexOf$1(t1, object);
            !(ai === -1) && $.removeRange(t1, ai, 1);
          }
        }
      }
      var c = 0;
    default:
      L0: while (true) {
        switch (state) {
          case 0:
            t1 = $.get$length(object.get$children());
          case 1:
            state = 0;
            if (!$.ltB(c, t1)) break L0;
            t1 = object.get$children();
          case 2:
            state = 0;
            this.removeObject$1($.index(t1, c));
            ++c;
        }
      }
  }
 },
 addObject$1: function(object) {
  if (typeof object === 'object' && object !== null && !!object.is$Light) {
    $.indexOf$1(this.lights, object) === -1 && $.add$1(this.lights, object);
  } else {
    if (!(typeof object === 'object' && object !== null && !!object.is$Camera || typeof object === 'object' && object !== null && !!object.is$Bone)) {
      if ($.indexOf$1(this.objects, object) === -1) {
        $.add$1(this.objects, object);
        $.add$1(this.__objectsAdded, object);
        var t1 = this.__objectsRemoved;
        var i = $.indexOf$1(t1, object);
        !(i === -1) && $.removeRange(t1, i, 1);
      }
    }
  }
  var c = 0;
  while (true) {
    t1 = $.get$length(object.get$children());
    if (typeof t1 !== 'number') return this.addObject$1$bailout(1, object, c, t1);
    if (!(c < t1)) break;
    t1 = object.get$children();
    if (typeof t1 !== 'string' && (typeof t1 !== 'object' || t1 === null || (t1.constructor !== Array && !t1.is$JavaScriptIndexingBehavior()))) return this.addObject$1$bailout(2, object, c, t1);
    var t3 = t1.length;
    if (c < 0 || c >= t3) throw $.ioore(c);
    this.addObject$1(t1[c]);
    ++c;
  }
 },
 addObject$1$bailout: function(state, env0, env1, env2) {
  switch (state) {
    case 1:
      var object = env0;
      c = env1;
      t1 = env2;
      break;
    case 2:
      object = env0;
      c = env1;
      t1 = env2;
      break;
  }
  switch (state) {
    case 0:
      if (typeof object === 'object' && object !== null && !!object.is$Light) {
        $.indexOf$1(this.lights, object) === -1 && $.add$1(this.lights, object);
      } else {
        if (!(typeof object === 'object' && object !== null && !!object.is$Camera || typeof object === 'object' && object !== null && !!object.is$Bone)) {
          if ($.indexOf$1(this.objects, object) === -1) {
            $.add$1(this.objects, object);
            $.add$1(this.__objectsAdded, object);
            var t1 = this.__objectsRemoved;
            var i = $.indexOf$1(t1, object);
            !(i === -1) && $.removeRange(t1, i, 1);
          }
        }
      }
      var c = 0;
    default:
      L0: while (true) {
        switch (state) {
          case 0:
            t1 = $.get$length(object.get$children());
          case 1:
            state = 0;
            if (!$.ltB(c, t1)) break L0;
            t1 = object.get$children();
          case 2:
            state = 0;
            this.addObject$1($.index(t1, c));
            ++c;
        }
      }
  }
 },
 Scene$0: function() {
  this.fog = null;
  this.overrideMaterial = null;
  this.matrixAutoUpdate = false;
  this.objects = [];
  this.lights = [];
  this.__objectsAdded = [];
  this.__objectsRemoved = [];
 },
 is$Scene: true
};

$$.Maps__emitMap_anon = {"":
 ["result_3", "box_0", "visiting_2"],
 super: "Closure",
 $call$2: function(k, v) {
  this.box_0.first_1 !== true && $.add$1(this.result_3, ', ');
  this.box_0.first_1 = false;
  $.Collections__emitObject(k, this.result_3, this.visiting_2);
  $.add$1(this.result_3, ': ');
  $.Collections__emitObject(v, this.result_3, this.visiting_2);
 }
};

$$.Canvas_Lines_init_function = {"":
 ["Tau_0"],
 super: "Closure",
 $call$1: function(context) {
  context.beginPath$0();
  context.arc$6(0, 0, 1, 0, this.Tau_0, false);
  context.closePath$0();
  context.fill$0();
 }
};

$$.Canvas_Lines_init_f = {"":
 ["this_1"],
 super: "Closure",
 $call$0: function() {
  return this.this_1.animate$0();
 }
};

$$.invokeClosure_anon = {"":
 ["closure_0"],
 super: "Closure",
 $call$0: function() {
  return this.closure_0.$call$0();
 }
};

$$.invokeClosure_anon0 = {"":
 ["closure_2", "arg1_1"],
 super: "Closure",
 $call$0: function() {
  return this.closure_2.$call$1(this.arg1_1);
 }
};

$$.invokeClosure_anon1 = {"":
 ["closure_5", "arg1_4", "arg2_3"],
 super: "Closure",
 $call$0: function() {
  return this.closure_5.$call$2(this.arg1_4, this.arg2_3);
 }
};

$$.DoubleLinkedQueue_length__ = {"":
 ["box_0"],
 super: "Closure",
 $call$1: function(element) {
  var counter = $.add(this.box_0.counter_1, 1);
  this.box_0.counter_1 = counter;
 }
};

$$.LinkedHashMapImplementation_forEach__ = {"":
 ["f_0"],
 super: "Closure",
 $call$1: function(entry) {
  this.f_0.$call$2(entry.get$key(), entry.get$value());
 }
};

$$.$$function = {"":
 [],
 super: "Closure",
 $call$2: function(context, newColor) {
 }
};

$$.FilteredElementList__filtered_anon = {"":
 [],
 super: "Closure",
 $call$1: function(n) {
  return typeof n === 'object' && n !== null && n.is$Element();
 }
};

$$._ChildrenElementList_filter_anon = {"":
 ["f_1", "output_0"],
 super: "Closure",
 $call$1: function(element) {
  this.f_1.$call$1(element) === true && $.add$1(this.output_0, element);
 }
};

$$.FilteredElementList_removeRange_anon = {"":
 [],
 super: "Closure",
 $call$1: function(el) {
  return el.remove$0();
 }
};

$$.HashSetImplementation_addAll__ = {"":
 ["this_0"],
 super: "Closure",
 $call$1: function(value) {
  this.this_0.add$1(value);
 }
};

$$.HashSetImplementation_forEach__ = {"":
 ["f_0"],
 super: "Closure",
 $call$2: function(key, value) {
  this.f_0.$call$1(key);
 }
};

$$.HashSetImplementation_filter__ = {"":
 ["result_1", "f_0"],
 super: "Closure",
 $call$2: function(key, value) {
  this.f_0.$call$1(key) === true && $.add$1(this.result_1, key);
 }
};

$$._StorageImpl_getValues_anon = {"":
 ["values_0"],
 super: "Closure",
 $call$2: function(k, v) {
  return $.add$1(this.values_0, v);
 }
};

$$.LinkedHashMapImplementation_getValues__ = {"":
 ["list_2", "box_0"],
 super: "Closure",
 $call$1: function(entry) {
  var t1 = this.list_2;
  var t2 = this.box_0.index_1;
  var index = $.add(t2, 1);
  this.box_0.index_1 = index;
  $.indexSet(t1, t2, entry.get$value());
 }
};

$$.HashMapImplementation_getValues__ = {"":
 ["list_2", "box_0"],
 super: "Closure",
 $call$2: function(key, value) {
  var t1 = this.list_2;
  var t2 = this.box_0.i_1;
  var i = $.add(t2, 1);
  this.box_0.i_1 = i;
  $.indexSet(t1, t2, value);
 }
};

$$._StorageImpl_getKeys_anon = {"":
 ["keys_0"],
 super: "Closure",
 $call$2: function(k, v) {
  return $.add$1(this.keys_0, k);
 }
};

$$.LinkedHashMapImplementation_getKeys__ = {"":
 ["list_2", "box_0"],
 super: "Closure",
 $call$1: function(entry) {
  var t1 = this.list_2;
  var t2 = this.box_0.index_10;
  var index = $.add(t2, 1);
  this.box_0.index_10 = index;
  $.indexSet(t1, t2, entry.get$key());
 }
};

$$.HashMapImplementation_getKeys__ = {"":
 ["list_2", "box_0"],
 super: "Closure",
 $call$2: function(key, value) {
  var t1 = this.list_2;
  var t2 = this.box_0.i_10;
  var i = $.add(t2, 1);
  this.box_0.i_10 = i;
  $.indexSet(t1, t2, key);
 }
};

$$._Copier_visitMap_anon = {"":
 ["this_2", "box_0"],
 super: "Closure",
 $call$2: function(key, val) {
  $.indexSet(this.box_0.copy_1, this.this_2._dispatch$1(key), this.this_2._dispatch$1(val));
 }
};

$$._EventLoop__runHelper_next = {"":
 ["this_0"],
 super: "Closure",
 $call$0: function() {
  if (this.this_0.runIteration$0() !== true) return;
  $._window().setTimeout$2(this, 0);
 }
};

$$.Closure = {"":
 [],
 super: "Object",
 toString$0: function() {
  return 'Closure';
 }
};

$$.BoundClosure = {'':
 ['self', 'target'],
 'super': 'Closure',
$call$0: function() { return this.self[this.target](); }
};
$$.BoundClosure0 = {'':
 ['self', 'target'],
 'super': 'Closure',
$call$1: function(p0) { return this.self[this.target](p0); }
};
$$.BoundClosure1 = {'':
 ['self', 'target'],
 'super': 'Closure',
$call$3: function(p0, p1, p2) { return this.self[this.target](p0, p1, p2); }
};
$$.BoundClosure2 = {'':
 ['self', 'target'],
 'super': 'Closure',
$call$2: function(p0, p1) { return this.self[this.target](p0, p1); }
};
$.mul$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a * b;
  return a.operator$mul$1(b);
};

$.startRootIsolate = function(entry) {
  var t1 = $._Manager$();
  $._globalState0(t1);
  if ($._globalState().get$isWorker() === true) return;
  var rootContext = $._IsolateContext$();
  $._globalState().set$rootContext(rootContext);
  $._fillStatics(rootContext);
  $._globalState().set$currentContext(rootContext);
  rootContext.eval$1(entry);
  $._globalState().get$topEventLoop().run$0();
};

$._ChildNodeListLazy$ = function(_this) {
  return new $._ChildNodeListLazy(_this);
};

$._AudioContextEventsImpl$ = function(_ptr) {
  return new $._AudioContextEventsImpl(_ptr);
};

$._window = function() {
  return typeof window != 'undefined' ? window : (void 0);;
};

$.floor = function(receiver) {
  if (!(typeof receiver === 'number')) return receiver.floor$0();
  return Math.floor(receiver);
};

$.eqB = function(a, b) {
  if (a == null) return b == null;
  if (b == null) return false;
  if (typeof a === "object") {
    if (!!a.operator$eq$1) return a.operator$eq$1(b) === true;
  }
  return a === b;
};

$.Collections__containsRef = function(c, ref) {
  for (var t1 = $.iterator(c); t1.hasNext$0() === true; ) {
    var t2 = t1.next$0();
    if (t2 == null ? ref == null : t2 === ref) return true;
  }
  return false;
};

$._NodeListWrapper$ = function(list) {
  return new $._NodeListWrapper(list);
};

$.isJsArray = function(value) {
  return !(value == null) && (value.constructor === Array);
};

$.indexSet$slow = function(a, index, value) {
  if ($.isJsArray(a) === true) {
    if (!((typeof index === 'number') && (index === (index | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(index));
    if (index < 0 || $.geB(index, $.get$length(a))) throw $.captureStackTrace($.IndexOutOfRangeException$(index));
    $.checkMutable(a, 'indexed set');
    a[index] = value;
    return;
  }
  a.operator$indexSet$2(index, value);
};

$.HashMapImplementation__nextProbe = function(currentProbe, numberOfProbes, length$) {
  return $.and($.add(currentProbe, numberOfProbes), $.sub(length$, 1));
};

$.allMatches = function(receiver, str) {
  if (!(typeof receiver === 'string')) return receiver.allMatches$1(str);
  $.checkString(str);
  return $.allMatchesInStringUnchecked(receiver, str);
};

$.substringUnchecked = function(receiver, startIndex, endIndex) {
  return receiver.substring(startIndex, endIndex);
};

$.get$length = function(receiver) {
  if (typeof receiver === 'string' || $.isJsArray(receiver) === true) return receiver.length;
  return receiver.get$length();
};

$.ge$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a >= b;
  return a.operator$ge$1(b);
};

$.CanvasRenderData$ = function() {
  var t1 = new $.CanvasRenderData(null);
  t1.CanvasRenderData$0();
  return t1;
};

$.IllegalJSRegExpException$ = function(_pattern, _errmsg) {
  return new $.IllegalJSRegExpException(_errmsg, _pattern);
};

$._IDBOpenDBRequestEventsImpl$ = function(_ptr) {
  return new $._IDBOpenDBRequestEventsImpl(_ptr);
};

$.typeNameInIE = function(obj) {
  var name$ = $.constructorNameFallback(obj);
  if ($.eqB(name$, 'Window')) return 'DOMWindow';
  if ($.eqB(name$, 'Document')) {
    if (!!obj.xmlVersion) return 'Document';
    return 'HTMLDocument';
  }
  if ($.eqB(name$, 'CanvasPixelArray')) return 'Uint8ClampedArray';
  if ($.eqB(name$, 'HTMLDDElement')) return 'HTMLElement';
  if ($.eqB(name$, 'HTMLDTElement')) return 'HTMLElement';
  if ($.eqB(name$, 'HTMLTableDataCellElement')) return 'HTMLTableCellElement';
  if ($.eqB(name$, 'HTMLTableHeaderCellElement')) return 'HTMLTableCellElement';
  if ($.eqB(name$, 'HTMLPhraseElement')) return 'HTMLElement';
  if ($.eqB(name$, 'MSStyleCSSProperties')) return 'CSSStyleDeclaration';
  if ($.eqB(name$, 'MouseWheelEvent')) return 'WheelEvent';
  return name$;
};

$.constructorNameFallback = function(obj) {
  var constructor$ = (obj.constructor);
  if ((typeof(constructor$)) === 'function') {
    var name$ = (constructor$.name);
    if ((typeof(name$)) === 'string' && ($.isEmpty(name$) !== true && (!(name$ === 'Object') && !(name$ === 'Function.prototype')))) return name$;
  }
  var string = (Object.prototype.toString.call(obj));
  return $.substring$2(string, 8, string.length - 1);
};

$.regExpMatchStart = function(m) {
  return m.index;
};

$.clear = function(receiver) {
  if ($.isJsArray(receiver) !== true) return receiver.clear$0();
  $.set$length(receiver, 0);
};

$.NullPointerException$ = function(functionName, arguments$) {
  return new $.NullPointerException(arguments$, functionName);
};

$._serializeMessage = function(message) {
  if ($._globalState().get$needSerialization() === true) return $._JsSerializer$().traverse$1(message);
  return $._JsCopier$().traverse$1(message);
};

$.Math_max = function(a, b) {
  if (typeof a === 'number') {
    if (typeof b === 'number') {
      if (a > b) return a;
      if (a < b) return b;
      if (typeof b === 'number') {
        if (typeof a === 'number') {
          if (a === 0.0) return a + b;
        }
        if ($.isNaN(b) === true) return b;
        return a;
      }
      if (b === 0 && $.isNegative(a) === true) return b;
      return a;
    }
    throw $.captureStackTrace($.IllegalArgumentException$(b));
  }
  throw $.captureStackTrace($.IllegalArgumentException$(a));
};

$.tdiv = function(a, b) {
  if ($.checkNumbers(a, b) === true) return $.truncate((a) / (b));
  return a.operator$tdiv$1(b);
};

$.Primitives_printString = function(string) {
  if (typeof dartPrint == "function") {
    dartPrint(string);
    return;
  }
  if (typeof console == "object") {
    console.log(string);
    return;
  }
  if (typeof write == "function") {
    write(string);
    write("\n");
  }
};

$.JSSyntaxRegExp$_globalVersionOf = function(other) {
  var t1 = other.get$pattern();
  var t2 = other.get$multiLine();
  t1 = new $.JSSyntaxRegExp(other.get$ignoreCase(), t2, t1);
  t1.JSSyntaxRegExp$_globalVersionOf$1(other);
  return t1;
};

$.removeRange = function(receiver, start, length$) {
  if ($.isJsArray(receiver) !== true) return receiver.removeRange$2(start, length$);
  $.checkGrowable(receiver, 'removeRange');
  if ($.eqB(length$, 0)) return;
  $.checkNull(start);
  $.checkNull(length$);
  if (!((typeof start === 'number') && (start === (start | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(start));
  if (!((typeof length$ === 'number') && (length$ === (length$ | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(length$));
  if (length$ < 0) throw $.captureStackTrace($.IllegalArgumentException$(length$));
  var receiverLength = (receiver.length);
  if (start < 0 || start >= receiverLength) throw $.captureStackTrace($.IndexOutOfRangeException$(start));
  var t1 = start + length$;
  if (t1 > receiverLength) throw $.captureStackTrace($.IndexOutOfRangeException$(t1));
  var t2 = receiverLength - length$;
  $.Arrays_copy(receiver, t1, receiver, start, t2 - start);
  $.set$length(receiver, t2);
};

$.Color$ = function(hex) {
  var t1 = new $.Color(null, null, null);
  t1.Color$1(hex);
  return t1;
};

$.typeNameInChrome = function(obj) {
  var name$ = (obj.constructor.name);
  if (name$ === 'Window') return 'DOMWindow';
  if (name$ === 'CanvasPixelArray') return 'Uint8ClampedArray';
  if (name$ === 'WebKitMutationObserver') return 'MutationObserver';
  return name$;
};

$.ParticleCanvasMaterial$ = function(parameters) {
  var t1 = new $.ParticleCanvasMaterial(null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Material$1(parameters);
  t1.ParticleCanvasMaterial$1(parameters);
  return t1;
};

$.Math_sqrt = function(x) {
  return $.MathNatives_sqrt(x);
};

$.MathNatives_sqrt = function(value) {
  return Math.sqrt($.checkNum(value));
};

$.shr = function(a, b) {
  if ($.checkNumbers(a, b) === true) {
    a = (a);
    b = (b);
    if (b < 0) throw $.captureStackTrace($.IllegalArgumentException$(b));
    if (a > 0) {
      if (b > 31) return 0;
      return a >>> b;
    }
    if (b > 31) b = 31;
    return (a >> b) >>> 0;
  }
  return a.operator$shr$1(b);
};

$.DualPivotQuicksort__dualPivotQuicksort = function(a, left, right, compare) {
  if (typeof a !== 'object' || a === null || ((a.constructor !== Array || !!a.immutable$list) && !a.is$JavaScriptIndexingBehavior())) return $.DualPivotQuicksort__dualPivotQuicksort$bailout(1, a, left, right, compare, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  var sixth = $.tdiv($.add($.sub(right, left), 1), 6);
  var index1 = $.add(left, sixth);
  var index5 = $.sub(right, sixth);
  var index3 = $.tdiv($.add(left, right), 2);
  var index2 = $.sub(index3, sixth);
  var index4 = $.add(index3, sixth);
  if (index1 !== (index1 | 0)) throw $.iae(index1);
  var t1 = a.length;
  if (index1 < 0 || index1 >= t1) throw $.ioore(index1);
  var el1 = a[index1];
  if (index2 !== (index2 | 0)) throw $.iae(index2);
  if (index2 < 0 || index2 >= t1) throw $.ioore(index2);
  var el2 = a[index2];
  if (index3 !== (index3 | 0)) throw $.iae(index3);
  if (index3 < 0 || index3 >= t1) throw $.ioore(index3);
  var el3 = a[index3];
  if (index4 !== (index4 | 0)) throw $.iae(index4);
  if (index4 < 0 || index4 >= t1) throw $.ioore(index4);
  var el4 = a[index4];
  if (index5 !== (index5 | 0)) throw $.iae(index5);
  if (index5 < 0 || index5 >= t1) throw $.ioore(index5);
  var el5 = a[index5];
  if ($.gtB(compare.$call$2(el1, el2), 0)) {
    var t0 = el1;
    el1 = el2;
    el2 = t0;
  }
  if ($.gtB(compare.$call$2(el4, el5), 0)) {
    t0 = el5;
    el5 = el4;
    el4 = t0;
  }
  if ($.gtB(compare.$call$2(el1, el3), 0)) {
    t0 = el3;
    el3 = el1;
    el1 = t0;
  }
  if ($.gtB(compare.$call$2(el2, el3), 0)) {
    t0 = el3;
    el3 = el2;
    el2 = t0;
  }
  if ($.gtB(compare.$call$2(el1, el4), 0)) {
    t0 = el1;
    el1 = el4;
    el4 = t0;
  }
  if ($.gtB(compare.$call$2(el3, el4), 0)) {
    t0 = el3;
    el3 = el4;
    el4 = t0;
  }
  if ($.gtB(compare.$call$2(el2, el5), 0)) {
    t0 = el2;
    el2 = el5;
    el5 = t0;
  }
  if ($.gtB(compare.$call$2(el2, el3), 0)) {
    t0 = el3;
    el3 = el2;
    el2 = t0;
  }
  if ($.gtB(compare.$call$2(el4, el5), 0)) {
    t0 = el5;
    el5 = el4;
    el4 = t0;
  }
  t1 = a.length;
  if (index1 < 0 || index1 >= t1) throw $.ioore(index1);
  a[index1] = el1;
  var t2 = a.length;
  if (index3 < 0 || index3 >= t2) throw $.ioore(index3);
  a[index3] = el3;
  var t3 = a.length;
  if (index5 < 0 || index5 >= t3) throw $.ioore(index5);
  a[index5] = el5;
  if (left !== (left | 0)) throw $.iae(left);
  var t4 = a.length;
  if (left < 0 || left >= t4) throw $.ioore(left);
  var t5 = a[left];
  if (index2 < 0 || index2 >= t4) throw $.ioore(index2);
  a[index2] = t5;
  if (right !== (right | 0)) throw $.iae(right);
  t5 = a.length;
  if (right < 0 || right >= t5) throw $.ioore(right);
  var t6 = a[right];
  if (index4 < 0 || index4 >= t5) throw $.ioore(index4);
  a[index4] = t6;
  var less = left + 1;
  if (typeof less !== 'number') return $.DualPivotQuicksort__dualPivotQuicksort$bailout(2, a, left, right, compare, index5, el2, index1, el4, less, 0, 0, 0, 0, 0);
  var great = right - 1;
  if (typeof great !== 'number') return $.DualPivotQuicksort__dualPivotQuicksort$bailout(3, a, left, right, compare, index5, el2, great, less, el4, index1, 0, 0, 0, 0);
  var pivots_are_equal = $.eqB(compare.$call$2(el2, el4), 0);
  if (pivots_are_equal) {
    for (var k = less; k <= great; ++k) {
      if (k !== (k | 0)) throw $.iae(k);
      t1 = a.length;
      if (k < 0 || k >= t1) throw $.ioore(k);
      var ak = a[k];
      var comp = compare.$call$2(ak, el2);
      if (typeof comp !== 'number') return $.DualPivotQuicksort__dualPivotQuicksort$bailout(4, a, less, k, compare, left, right, great, index1, index5, el2, pivots_are_equal, ak, comp, el4);
      if (comp === 0) continue;
      if (comp < 0) {
        if (!(k === less)) {
          if (less !== (less | 0)) throw $.iae(less);
          t1 = a.length;
          if (less < 0 || less >= t1) throw $.ioore(less);
          t2 = a[less];
          if (k < 0 || k >= t1) throw $.ioore(k);
          a[k] = t2;
          t2 = a.length;
          if (less < 0 || less >= t2) throw $.ioore(less);
          a[less] = ak;
        }
        ++less;
      } else {
        for (; true; ) {
          if (great !== (great | 0)) throw $.iae(great);
          t1 = a.length;
          if (great < 0 || great >= t1) throw $.ioore(great);
          comp = compare.$call$2(a[great], el2);
          if ($.gtB(comp, 0)) {
            --great;
            continue;
          } else {
            t1 = $.ltB(comp, 0);
            var great0 = great - 1;
            t2 = a.length;
            if (t1) {
              if (less !== (less | 0)) throw $.iae(less);
              if (less < 0 || less >= t2) throw $.ioore(less);
              t1 = a[less];
              if (k < 0 || k >= t2) throw $.ioore(k);
              a[k] = t1;
              var less0 = less + 1;
              t1 = a.length;
              if (great < 0 || great >= t1) throw $.ioore(great);
              t3 = a[great];
              if (less < 0 || less >= t1) throw $.ioore(less);
              a[less] = t3;
              t3 = a.length;
              if (great < 0 || great >= t3) throw $.ioore(great);
              a[great] = ak;
              great = great0;
              less = less0;
              break;
            } else {
              if (great < 0 || great >= t2) throw $.ioore(great);
              t1 = a[great];
              if (k < 0 || k >= t2) throw $.ioore(k);
              a[k] = t1;
              t1 = a.length;
              if (great < 0 || great >= t1) throw $.ioore(great);
              a[great] = ak;
              great = great0;
              break;
            }
          }
        }
      }
    }
  } else {
    for (k = less; k <= great; ++k) {
      if (k !== (k | 0)) throw $.iae(k);
      t1 = a.length;
      if (k < 0 || k >= t1) throw $.ioore(k);
      ak = a[k];
      if ($.ltB(compare.$call$2(ak, el2), 0)) {
        if (!(k === less)) {
          if (less !== (less | 0)) throw $.iae(less);
          t1 = a.length;
          if (less < 0 || less >= t1) throw $.ioore(less);
          t2 = a[less];
          if (k < 0 || k >= t1) throw $.ioore(k);
          a[k] = t2;
          t2 = a.length;
          if (less < 0 || less >= t2) throw $.ioore(less);
          a[less] = ak;
        }
        ++less;
      } else {
        if ($.gtB(compare.$call$2(ak, el4), 0)) {
          for (; true; ) {
            if (great !== (great | 0)) throw $.iae(great);
            t1 = a.length;
            if (great < 0 || great >= t1) throw $.ioore(great);
            if ($.gtB(compare.$call$2(a[great], el4), 0)) {
              --great;
              if (great < k) break;
              continue;
            } else {
              t1 = a.length;
              if (great < 0 || great >= t1) throw $.ioore(great);
              t1 = $.ltB(compare.$call$2(a[great], el2), 0);
              great0 = great - 1;
              t2 = a.length;
              if (t1) {
                if (less !== (less | 0)) throw $.iae(less);
                if (less < 0 || less >= t2) throw $.ioore(less);
                t1 = a[less];
                if (k < 0 || k >= t2) throw $.ioore(k);
                a[k] = t1;
                less0 = less + 1;
                t1 = a.length;
                if (great < 0 || great >= t1) throw $.ioore(great);
                t3 = a[great];
                if (less < 0 || less >= t1) throw $.ioore(less);
                a[less] = t3;
                t3 = a.length;
                if (great < 0 || great >= t3) throw $.ioore(great);
                a[great] = ak;
                great = great0;
                less = less0;
              } else {
                if (great < 0 || great >= t2) throw $.ioore(great);
                t1 = a[great];
                if (k < 0 || k >= t2) throw $.ioore(k);
                a[k] = t1;
                t1 = a.length;
                if (great < 0 || great >= t1) throw $.ioore(great);
                a[great] = ak;
                great = great0;
              }
              break;
            }
          }
        }
      }
    }
  }
  t1 = less - 1;
  if (t1 !== (t1 | 0)) throw $.iae(t1);
  t2 = a.length;
  if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
  t3 = a[t1];
  if (left < 0 || left >= t2) throw $.ioore(left);
  a[left] = t3;
  t3 = a.length;
  if (t1 < 0 || t1 >= t3) throw $.ioore(t1);
  a[t1] = el2;
  t1 = great + 1;
  if (t1 !== (t1 | 0)) throw $.iae(t1);
  t4 = a.length;
  if (t1 < 0 || t1 >= t4) throw $.ioore(t1);
  t5 = a[t1];
  if (right < 0 || right >= t4) throw $.ioore(right);
  a[right] = t5;
  t5 = a.length;
  if (t1 < 0 || t1 >= t5) throw $.ioore(t1);
  a[t1] = el4;
  $.DualPivotQuicksort__doSort(a, left, less - 2, compare);
  $.DualPivotQuicksort__doSort(a, great + 2, right, compare);
  if (pivots_are_equal) return;
  if (less < index1 && great > index5) {
    while (true) {
      if (less !== (less | 0)) throw $.iae(less);
      t1 = a.length;
      if (less < 0 || less >= t1) throw $.ioore(less);
      if (!$.eqB(compare.$call$2(a[less], el2), 0)) break;
      ++less;
    }
    while (true) {
      if (great !== (great | 0)) throw $.iae(great);
      t1 = a.length;
      if (great < 0 || great >= t1) throw $.ioore(great);
      if (!$.eqB(compare.$call$2(a[great], el4), 0)) break;
      --great;
    }
    for (k = less; k <= great; ++k) {
      if (k !== (k | 0)) throw $.iae(k);
      t1 = a.length;
      if (k < 0 || k >= t1) throw $.ioore(k);
      ak = a[k];
      if ($.eqB(compare.$call$2(ak, el2), 0)) {
        if (!(k === less)) {
          if (less !== (less | 0)) throw $.iae(less);
          t1 = a.length;
          if (less < 0 || less >= t1) throw $.ioore(less);
          t2 = a[less];
          if (k < 0 || k >= t1) throw $.ioore(k);
          a[k] = t2;
          t2 = a.length;
          if (less < 0 || less >= t2) throw $.ioore(less);
          a[less] = ak;
        }
        ++less;
      } else {
        if ($.eqB(compare.$call$2(ak, el4), 0)) {
          for (; true; ) {
            if (great !== (great | 0)) throw $.iae(great);
            t1 = a.length;
            if (great < 0 || great >= t1) throw $.ioore(great);
            if ($.eqB(compare.$call$2(a[great], el4), 0)) {
              --great;
              if (great < k) break;
              continue;
            } else {
              t1 = a.length;
              if (great < 0 || great >= t1) throw $.ioore(great);
              t1 = $.ltB(compare.$call$2(a[great], el2), 0);
              t2 = a.length;
              great0 = great - 1;
              if (t1) {
                if (less !== (less | 0)) throw $.iae(less);
                if (less < 0 || less >= t2) throw $.ioore(less);
                t1 = a[less];
                if (k < 0 || k >= t2) throw $.ioore(k);
                a[k] = t1;
                less0 = less + 1;
                t1 = a.length;
                if (great < 0 || great >= t1) throw $.ioore(great);
                t3 = a[great];
                if (less < 0 || less >= t1) throw $.ioore(less);
                a[less] = t3;
                t3 = a.length;
                if (great < 0 || great >= t3) throw $.ioore(great);
                a[great] = ak;
                great = great0;
                less = less0;
              } else {
                if (great < 0 || great >= t2) throw $.ioore(great);
                t1 = a[great];
                if (k < 0 || k >= t2) throw $.ioore(k);
                a[k] = t1;
                t1 = a.length;
                if (great < 0 || great >= t1) throw $.ioore(great);
                a[great] = ak;
                great = great0;
              }
              break;
            }
          }
        }
      }
    }
    $.DualPivotQuicksort__doSort(a, less, great, compare);
  } else $.DualPivotQuicksort__doSort(a, less, great, compare);
};

$.RenderableObject$ = function() {
  return new $.RenderableObject(null, null);
};

$.and = function(a, b) {
  if ($.checkNumbers(a, b) === true) return (a & b) >>> 0;
  return a.operator$and$1(b);
};

$.substring$2 = function(receiver, startIndex, endIndex) {
  if (!(typeof receiver === 'string')) return receiver.substring$2(startIndex, endIndex);
  $.checkNum(startIndex);
  var length$ = receiver.length;
  if (endIndex == null) endIndex = length$;
  $.checkNum(endIndex);
  if ($.ltB(startIndex, 0)) throw $.captureStackTrace($.IndexOutOfRangeException$(startIndex));
  if ($.gtB(startIndex, endIndex)) throw $.captureStackTrace($.IndexOutOfRangeException$(startIndex));
  if ($.gtB(endIndex, length$)) throw $.captureStackTrace($.IndexOutOfRangeException$(endIndex));
  return $.substringUnchecked(receiver, startIndex, endIndex);
};

$.indexSet = function(a, index, value) {
  if (a.constructor === Array && !a.immutable$list) {
    var key = (index >>> 0);
    if (key === index && key < (a.length)) {
      a[key] = value;
      return;
    }
  }
  $.indexSet$slow(a, index, value);
};

$._DOMApplicationCacheEventsImpl$ = function(_ptr) {
  return new $._DOMApplicationCacheEventsImpl(_ptr);
};

$.ExceptionImplementation$ = function(msg) {
  return new $.ExceptionImplementation(msg);
};

$.StringMatch$ = function(_start, str, pattern) {
  return new $.StringMatch(pattern, str, _start);
};

$.invokeClosure = function(closure, isolate, numberOfArguments, arg1, arg2) {
  if ($.eqB(numberOfArguments, 0)) return $._callInIsolate(isolate, new $.invokeClosure_anon(closure));
  if ($.eqB(numberOfArguments, 1)) return $._callInIsolate(isolate, new $.invokeClosure_anon0(closure, arg1));
  if ($.eqB(numberOfArguments, 2)) return $._callInIsolate(isolate, new $.invokeClosure_anon1(closure, arg1, arg2));
  throw $.captureStackTrace($.ExceptionImplementation$('Unsupported number of arguments for wrapped closure'));
};

$.Rectangle$ = function() {
  return new $.Rectangle(true, null, null, null, null, null, null);
};

$.stringJoinUnchecked = function(array, separator) {
  return array.join(separator);
};

$.gt = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a > b) : $.gt$slow(a, b);
};

$.last = function(receiver) {
  if ($.isJsArray(receiver) !== true) return receiver.last$0();
  return $.index(receiver, $.sub($.get$length(receiver), 1));
};

$.buildDynamicMetadata = function(inputTable) {
  if (typeof inputTable !== 'string' && (typeof inputTable !== 'object' || inputTable === null || (inputTable.constructor !== Array && !inputTable.is$JavaScriptIndexingBehavior()))) return $.buildDynamicMetadata$bailout(1, inputTable, 0, 0, 0, 0, 0, 0);
  var result = [];
  for (var i = 0; t1 = inputTable.length, i < t1; ++i) {
    if (i < 0 || i >= t1) throw $.ioore(i);
    var tag = $.index(inputTable[i], 0);
    var t2 = inputTable.length;
    if (i < 0 || i >= t2) throw $.ioore(i);
    var tags = $.index(inputTable[i], 1);
    var set = $.HashSetImplementation$();
    $.setRuntimeTypeInfo(set, ({E: 'String'}));
    var tagNames = $.split(tags, '|');
    if (typeof tagNames !== 'string' && (typeof tagNames !== 'object' || tagNames === null || (tagNames.constructor !== Array && !tagNames.is$JavaScriptIndexingBehavior()))) return $.buildDynamicMetadata$bailout(2, inputTable, result, tagNames, tag, i, tags, set);
    for (var j = 0; t1 = tagNames.length, j < t1; ++j) {
      if (j < 0 || j >= t1) throw $.ioore(j);
      set.add$1(tagNames[j]);
    }
    $.add$1(result, $.MetaInfo$(tag, tags, set));
  }
  return result;
  var t1;
};

$.filter = function(receiver, predicate) {
  if ($.isJsArray(receiver) !== true) return receiver.filter$1(predicate);
  return $.Collections_filter(receiver, [], predicate);
};

$.contains$1 = function(receiver, other) {
  if (!(typeof receiver === 'string')) return receiver.contains$1(other);
  return $.contains$2(receiver, other, 0);
};

$._EventSourceEventsImpl$ = function(_ptr) {
  return new $._EventSourceEventsImpl(_ptr);
};

$.Collections_filter = function(source, destination, f) {
  for (var t1 = $.iterator(source); t1.hasNext$0() === true; ) {
    var t2 = t1.next$0();
    f.$call$1(t2) === true && $.add$1(destination, t2);
  }
  return destination;
};

$.mul = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a * b) : $.mul$slow(a, b);
};

$._NotificationEventsImpl$ = function(_ptr) {
  return new $._NotificationEventsImpl(_ptr);
};

$.Frustum$ = function() {
  var t1 = new $.Frustum(null);
  t1.Frustum$0();
  return t1;
};

$._Collections_filter = function(source, destination, f) {
  for (var t1 = $.iterator(source); t1.hasNext$0() === true; ) {
    var t2 = t1.next$0();
    f.$call$1(t2) === true && $.add$1(destination, t2);
  }
  return destination;
};

$._browserPrefix = function() {
  if ($._cachedBrowserPrefix == null) {
    if ($._Device_isFirefox() === true) $._cachedBrowserPrefix = '-moz-';
    else $._cachedBrowserPrefix = '-webkit-';
  }
  return $._cachedBrowserPrefix;
};

$._MessageTraverser_isPrimitive = function(x) {
  return x == null || (typeof x === 'string' || (typeof x === 'number' || typeof x === 'boolean'));
};

$.neg = function(a) {
  if (typeof a === "number") return -a;
  return a.operator$negate$0();
};

$.Collections__emitCollection = function(c, result, visiting) {
  $.add$1(visiting, c);
  var isList = typeof c === 'object' && c !== null && (c.constructor === Array || c.is$List());
  $.add$1(result, isList ? '[' : '{');
  for (var t1 = $.iterator(c), first = true; t1.hasNext$0() === true; ) {
    var t2 = t1.next$0();
    !first && $.add$1(result, ', ');
    $.Collections__emitObject(t2, result, visiting);
    first = false;
  }
  $.add$1(result, isList ? ']' : '}');
  $.removeLast(visiting);
};

$.checkMutable = function(list, reason) {
  if (!!(list.immutable$list)) throw $.captureStackTrace($.UnsupportedOperationException$(reason));
};

$.sub$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a - b;
  return a.operator$sub$1(b);
};

$.toStringWrapper = function() {
  return $.toString((this.dartException));
};

$.Vector3$ = function(x, y, z) {
  var t1 = new $.Vector3(null, null, null);
  t1.Vector3$3(x, y, z);
  return t1;
};

$._PeerConnection00EventsImpl$ = function(_ptr) {
  return new $._PeerConnection00EventsImpl(_ptr);
};

$._ElementList$ = function(list) {
  return new $._ElementList(list);
};

$._WorkerContextEventsImpl$ = function(_ptr) {
  return new $._WorkerContextEventsImpl(_ptr);
};

$._DocumentEventsImpl$ = function(_ptr) {
  return new $._DocumentEventsImpl(_ptr);
};

$.DoubleLinkedQueueEntry$ = function(e) {
  var t1 = new $.DoubleLinkedQueueEntry(null, null, null);
  t1.DoubleLinkedQueueEntry$1(e);
  return t1;
};

$.regExpTest = function(regExp, str) {
  return $.regExpGetNative(regExp).test(str);
};

$.typeNameInOpera = function(obj) {
  var name$ = $.constructorNameFallback(obj);
  if ($.eqB(name$, 'Window')) return 'DOMWindow';
  return name$;
};

$.Particle$ = function(material) {
  var t1 = new $.Particle(null, null, false, false, false, false, null, null, null, null, false, false, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Object3D$0();
  t1.Particle$1(material);
  return t1;
};

$._EventsImpl$ = function(_ptr) {
  return new $._EventsImpl(_ptr);
};

$.RenderableLine$ = function() {
  var t1 = new $.RenderableLine(null, null, null, null);
  t1.RenderableLine$0();
  return t1;
};

$._IDBRequestEventsImpl$ = function(_ptr) {
  return new $._IDBRequestEventsImpl(_ptr);
};

$.stringSplitUnchecked = function(receiver, pattern) {
  if (typeof pattern === 'string') return receiver.split(pattern);
  if (typeof pattern === 'object' && pattern !== null && !!pattern.is$JSSyntaxRegExp) return receiver.split($.regExpGetNative(pattern));
  throw $.captureStackTrace('StringImplementation.split(Pattern) UNIMPLEMENTED');
};

$.checkGrowable = function(list, reason) {
  if (!!(list.fixed$length)) throw $.captureStackTrace($.UnsupportedOperationException$(reason));
};

$.HashSetImplementation$ = function() {
  var t1 = new $.HashSetImplementation(null);
  t1.HashSetImplementation$0();
  return t1;
};

$._SpeechRecognitionEventsImpl$ = function(_ptr) {
  return new $._SpeechRecognitionEventsImpl(_ptr);
};

$._SVGElementInstanceEventsImpl$ = function(_ptr) {
  return new $._SVGElementInstanceEventsImpl(_ptr);
};

$.Geometry$ = function() {
  var t1 = new $.Geometry(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Geometry$0();
  return t1;
};

$.add$1 = function(receiver, value) {
  if ($.isJsArray(receiver) === true) {
    $.checkGrowable(receiver, 'add');
    receiver.push(value);
    return;
  }
  return receiver.add$1(value);
};

$.regExpExec = function(regExp, str) {
  var result = ($.regExpGetNative(regExp).exec(str));
  if (result === null) return;
  return result;
};

$.RenderableFace3$ = function() {
  var t1 = new $.RenderableFace3(null, null, null, null, null, null, null, null, null, null, null);
  t1.RenderableFace3$0();
  return t1;
};

$.geB = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a >= b) : $.ge$slow(a, b) === true;
};

$.Math_atan2 = function(a, b) {
  return $.MathNatives_atan2(a, b);
};

$.stringContainsUnchecked = function(receiver, other, startIndex) {
  if (typeof other === 'string') return !($.indexOf$2(receiver, other, startIndex) === -1);
  if (typeof other === 'object' && other !== null && !!other.is$JSSyntaxRegExp) return other.hasMatch$1($.substring$1(receiver, startIndex));
  return $.iterator($.allMatches(other, $.substring$1(receiver, startIndex))).hasNext$0();
};

$.ObjectNotClosureException$ = function() {
  return new $.ObjectNotClosureException();
};

$.window = function() {
  return window;;
};

$.MathNatives_atan2 = function(a, b) {
  return Math.atan2($.checkNum(a), $.checkNum(b));
};

$.abs = function(receiver) {
  if (!(typeof receiver === 'number')) return receiver.abs$0();
  return Math.abs(receiver);
};

$.Primitives_objectTypeName = function(object) {
  var name$ = $.constructorNameFallback(object);
  if ($.eqB(name$, 'Object')) {
    var decompiled = (String(object.constructor).match(/^\s*function\s*(\S*)\s*\(/)[1]);
    if (typeof decompiled === 'string') name$ = decompiled;
  }
  return $.charCodeAt(name$, 0) === 36 ? $.substring$1(name$, 1) : name$;
};

$.regExpAttachGlobalNative = function(regExp) {
  regExp._re = $.regExpMakeNative(regExp, true);
};

$.leB = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a <= b) : $.le$slow(a, b) === true;
};

$.isNegative = function(receiver) {
  if (typeof receiver === 'number') {
    return receiver === 0 ? 1 / receiver < 0 : receiver < 0;
  }
  return receiver.isNegative$0();
};

$.regExpMakeNative = function(regExp, global) {
  var pattern = regExp.get$pattern();
  var multiLine = regExp.get$multiLine();
  var ignoreCase = regExp.get$ignoreCase();
  $.checkString(pattern);
  var sb = $.StringBufferImpl$('');
  multiLine === true && $.add$1(sb, 'm');
  ignoreCase === true && $.add$1(sb, 'i');
  global === true && $.add$1(sb, 'g');
  try {
    return new RegExp(pattern, $.toString(sb));
  } catch (exception) {
    var t1 = $.unwrapException(exception);
    var e = t1;
    throw $.captureStackTrace($.IllegalJSRegExpException$(pattern, (String(e))));
  }
};

$.BadNumberFormatException$ = function(_s) {
  return new $.BadNumberFormatException(_s);
};

$.Matrix4$createMatrices = function(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  var t1 = new $.Matrix4(n44, n43, n42, n41, n34, n33, n32, n31, n24, n23, n22, n21, n14, n13, n12, n11, null, null);
  t1.Matrix4$createMatrices$16(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44);
  return t1;
};

$._FrozenElementListIterator$ = function(_list) {
  return new $._FrozenElementListIterator(0, _list);
};

$.Maps_mapToString = function(m) {
  var result = $.StringBufferImpl$('');
  $.Maps__emitMap(m, result, $.ListFactory_List(null));
  return result.toString$0();
};

$.iterator = function(receiver) {
  if ($.isJsArray(receiver) === true) return $.ListIterator$(receiver);
  return receiver.iterator$0();
};

$._XMLHttpRequestEventsImpl$ = function(_ptr) {
  return new $._XMLHttpRequestEventsImpl(_ptr);
};

$._JavaScriptAudioNodeEventsImpl$ = function(_ptr) {
  return new $._JavaScriptAudioNodeEventsImpl(_ptr);
};

$.Collections__emitObject = function(o, result, visiting) {
  if (typeof o === 'object' && o !== null && (o.constructor === Array || o.is$Collection())) {
    if ($.Collections__containsRef(visiting, o) === true) {
      $.add$1(result, typeof o === 'object' && o !== null && (o.constructor === Array || o.is$List()) ? '[...]' : '{...}');
    } else $.Collections__emitCollection(o, result, visiting);
  } else {
    if (typeof o === 'object' && o !== null && o.is$Map()) {
      if ($.Collections__containsRef(visiting, o) === true) $.add$1(result, '{...}');
      else $.Maps__emitMap(o, result, visiting);
    } else {
      $.add$1(result, o == null ? 'null' : o);
    }
  }
};

$.Maps__emitMap = function(m, result, visiting) {
  var t1 = ({});
  $.add$1(visiting, m);
  $.add$1(result, '{');
  t1.first_1 = true;
  $.forEach(m, new $.Maps__emitMap_anon(result, t1, visiting));
  $.add$1(result, '}');
  $.removeLast(visiting);
};

$._IDBDatabaseEventsImpl$ = function(_ptr) {
  return new $._IDBDatabaseEventsImpl(_ptr);
};

$._Device_isFirefox = function() {
  return $.contains$2($._Device_userAgent(), 'Firefox', 0);
};

$.compareTo = function(a, b) {
  if ($.checkNumbers(a, b) === true) {
    if ($.ltB(a, b)) return -1;
    if ($.gtB(a, b)) return 1;
    if ($.eqB(a, b)) {
      if ($.eqB(a, 0)) {
        var aIsNegative = $.isNegative(a);
        if ($.eqB(aIsNegative, $.isNegative(b))) return 0;
        if (aIsNegative === true) return -1;
        return 1;
      }
      return 0;
    }
    if ($.isNaN(a) === true) {
      if ($.isNaN(b) === true) return 0;
      return 1;
    }
    return -1;
  }
  if (typeof a === 'string') {
    if (!(typeof b === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(b));
    if (a == b) var t1 = 0;
    else {
      t1 = (a < b) ? -1 : 1;
    }
    return t1;
  }
  return a.compareTo$1(b);
};

$.Vector4$ = function(x, y, z, w) {
  var t1 = new $.Vector4(null, null, null, null);
  t1.Vector4$4(x, y, z, w);
  return t1;
};

$.add = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a + b) : $.add$slow(a, b);
};

$._TextTrackCueEventsImpl$ = function(_ptr) {
  return new $._TextTrackCueEventsImpl(_ptr);
};

$.Matrix3$ = function() {
  var t1 = new $.Matrix3(null);
  t1.Matrix3$0();
  return t1;
};

$.RenderableVertex$ = function() {
  var t1 = new $.RenderableVertex(true, null, null);
  t1.RenderableVertex$0();
  return t1;
};

$.isEmpty = function(receiver) {
  if (typeof receiver === 'string' || $.isJsArray(receiver) === true) return receiver.length === 0;
  return receiver.isEmpty$0();
};

$.MatchImplementation$ = function(pattern, str, _start, _end, _groups) {
  return new $.MatchImplementation(_groups, _end, _start, str, pattern);
};

$.UnsupportedOperationException$ = function(_message) {
  return new $.UnsupportedOperationException(_message);
};

$.indexOf$2 = function(receiver, element, start) {
  if ($.isJsArray(receiver) === true) {
    if (!((typeof start === 'number') && (start === (start | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(start));
    return $.Arrays_indexOf(receiver, element, start, (receiver.length));
  }
  if (typeof receiver === 'string') {
    $.checkNull(element);
    if (!((typeof start === 'number') && (start === (start | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(start));
    if (!(typeof element === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(element));
    if (start < 0) return -1;
    return receiver.indexOf(element, start);
  }
  return receiver.indexOf$2(element, start);
};

$._DedicatedWorkerContextEventsImpl$ = function(_ptr) {
  return new $._DedicatedWorkerContextEventsImpl(_ptr);
};

$.RenderableFace4$ = function() {
  var t1 = new $.RenderableFace4(null, null, null, null, null, null, null, null, null, null, null, null);
  t1.RenderableFace4$0();
  return t1;
};

$._FileReaderEventsImpl$ = function(_ptr) {
  return new $._FileReaderEventsImpl(_ptr);
};

$.RenderInts$ = function() {
  var t1 = new $.RenderInts(null, null);
  t1.RenderInts$0();
  return t1;
};

$._JsCopier$ = function() {
  var t1 = new $._JsCopier($._MessageTraverserVisitedMap$());
  t1._JsCopier$0();
  return t1;
};

$.NoMoreElementsException$ = function() {
  return new $.NoMoreElementsException();
};

$.Scene$ = function() {
  var t1 = new $.Scene(null, null, null, null, null, null, null, false, false, false, false, null, null, null, null, false, false, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Object3D$0();
  t1.Scene$0();
  return t1;
};

$._Manager$ = function() {
  var t1 = new $._Manager(null, null, null, null, null, null, null, null, null, 1, 0, 0);
  t1._Manager$0();
  return t1;
};

$._ElementFactoryProvider_Element$tag = function(tag) {
  return document.createElement(tag);
};

$._FrameSetElementEventsImpl$ = function(_ptr) {
  return new $._FrameSetElementEventsImpl(_ptr);
};

$.add$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a + b;
  return a.operator$add$1(b);
};

$.ListFactory_List$from = function(other) {
  var result = $.ListFactory_List(null);
  $.setRuntimeTypeInfo(result, ({E: 'E'}));
  var iterator = $.iterator(other);
  for (; iterator.hasNext$0() === true; ) {
    result.push(iterator.next$0());
  }
  return result;
};

$.addLast = function(receiver, value) {
  if ($.isJsArray(receiver) !== true) return receiver.addLast$1(value);
  $.checkGrowable(receiver, 'addLast');
  receiver.push(value);
};

$.Primitives_newList = function(length$) {
  if (length$ == null) return new Array();
  if (!((typeof length$ === 'number') && (length$ === (length$ | 0))) || length$ < 0) throw $.captureStackTrace($.IllegalArgumentException$(length$));
  var result = (new Array(length$));
  result.fixed$length = true;
  return result;
};

$.main = function() {
  $.Canvas_Lines$().run$0();
};

$._AbstractWorkerEventsImpl$ = function(_ptr) {
  return new $._AbstractWorkerEventsImpl(_ptr);
};

$._WorkerSendPort$ = function(_workerId, isolateId, _receivePortId) {
  return new $._WorkerSendPort(_receivePortId, _workerId, isolateId);
};

$.HashMapImplementation__computeLoadLimit = function(capacity) {
  return $.tdiv($.mul(capacity, 3), 4);
};

$.HashSetIterator$ = function(set_) {
  var t1 = new $.HashSetIterator(-1, set_.get$_backingMap().get$_keys());
  t1.HashSetIterator$1(set_);
  return t1;
};

$.IllegalArgumentException$ = function(arg) {
  return new $.IllegalArgumentException(arg);
};

$._MediaElementEventsImpl$ = function(_ptr) {
  return new $._MediaElementEventsImpl(_ptr);
};

$._BodyElementEventsImpl$ = function(_ptr) {
  return new $._BodyElementEventsImpl(_ptr);
};

$._IDBTransactionEventsImpl$ = function(_ptr) {
  return new $._IDBTransactionEventsImpl(_ptr);
};

$._AllMatchesIterator$ = function(re, _str) {
  return new $._AllMatchesIterator(false, null, _str, $.JSSyntaxRegExp$_globalVersionOf(re));
};

$.iae = function(argument) {
  throw $.captureStackTrace($.IllegalArgumentException$(argument));
};

$._IsolateContext$ = function() {
  var t1 = new $._IsolateContext(null, null, null);
  t1._IsolateContext$0();
  return t1;
};

$.truncate = function(receiver) {
  if (!(typeof receiver === 'number')) return receiver.truncate$0();
  return receiver < 0 ? $.ceil(receiver) : $.floor(receiver);
};

$.CanvasRenderer$ = function(parameters) {
  var t1 = new $.CanvasRenderer(null, null, null, null, null, null, null, null, null, 6.283185307179586, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.CanvasRenderer$1(parameters);
  return t1;
};

$.isNaN = function(receiver) {
  if (typeof receiver === 'number') return isNaN(receiver);
  return receiver.isNaN$0();
};

$.isInfinite = function(receiver) {
  if (!(typeof receiver === 'number')) return receiver.isInfinite$0();
  return (receiver == Infinity) || (receiver == -Infinity);
};

$.allMatchesInStringUnchecked = function(needle, haystack) {
  var result = $.ListFactory_List(null);
  $.setRuntimeTypeInfo(result, ({E: 'Match'}));
  var length$ = $.get$length(haystack);
  var patternLength = $.get$length(needle);
  if (patternLength !== (patternLength | 0)) return $.allMatchesInStringUnchecked$bailout(1, needle, haystack, length$, patternLength, result);
  for (var startIndex = 0; true; ) {
    var position = $.indexOf$2(haystack, needle, startIndex);
    if ($.eqB(position, -1)) break;
    result.push($.StringMatch$(position, haystack, needle));
    var endIndex = $.add(position, patternLength);
    if ($.eqB(endIndex, length$)) break;
    else {
      startIndex = $.eqB(position, endIndex) ? $.add(startIndex, 1) : endIndex;
    }
  }
  return result;
};

$.Matrix4_makeFrustum = function(left, right, bottom, top$, near, far) {
  var m = $.Matrix4$(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  if (typeof near !== 'number') throw $.iae(near);
  var t1 = 2 * near;
  var t2 = $.sub(right, left);
  if (typeof t2 !== 'number') throw $.iae(t2);
  var x = t1 / t2;
  t2 = $.sub(top$, bottom);
  if (typeof t2 !== 'number') throw $.iae(t2);
  var y = t1 / t2;
  var a = $.div($.add(right, left), $.sub(right, left));
  var b = $.div($.add(top$, bottom), $.sub(top$, bottom));
  var c = $.div($.neg($.add(far, near)), $.sub(far, near));
  if (typeof far !== 'number') throw $.iae(far);
  var d = -2 * far * near / (far - near);
  m.n11 = x;
  m.n12 = 0;
  m.n13 = a;
  m.n14 = 0;
  m.n21 = 0;
  m.n22 = y;
  m.n23 = b;
  m.n24 = 0;
  m.n31 = 0;
  m.n32 = 0;
  m.n33 = c;
  m.n34 = d;
  m.n41 = 0;
  m.n42 = 0;
  m.n43 = -1;
  m.n44 = 0;
  return m;
};

$.le$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a <= b;
  return a.operator$le$1(b);
};

$._ChildrenElementList$_wrap = function(element) {
  return new $._ChildrenElementList(element.get$$$dom_children(), element);
};

$._AllMatchesIterable$ = function(_re, _str) {
  return new $._AllMatchesIterable(_str, _re);
};

$.Vertex$ = function(position) {
  var t1 = new $.Vertex(null);
  t1.Vertex$1(position);
  return t1;
};

$.dynamicSetMetadata = function(inputTable) {
  var t1 = $.buildDynamicMetadata(inputTable);
  $._dynamicMetadata(t1);
};

$.endsWith = function(receiver, other) {
  if (!(typeof receiver === 'string')) return receiver.endsWith$1(other);
  $.checkString(other);
  var receiverLength = receiver.length;
  var otherLength = $.get$length(other);
  if ($.gtB(otherLength, receiverLength)) return false;
  if (typeof otherLength !== 'number') throw $.iae(otherLength);
  return $.eq(other, $.substring$1(receiver, receiverLength - otherLength));
};

$.ListIterator$ = function(list) {
  return new $.ListIterator(list, 0);
};

$.checkNum = function(value) {
  if (!(typeof value === 'number')) {
    $.checkNull(value);
    throw $.captureStackTrace($.IllegalArgumentException$(value));
  }
  return value;
};

$.Projector$ = function() {
  var t1 = new $.Projector(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Projector$0();
  return t1;
};

$.Arrays_copy = function(src, srcStart, dst, dstStart, count) {
  if (typeof src !== 'string' && (typeof src !== 'object' || src === null || (src.constructor !== Array && !src.is$JavaScriptIndexingBehavior()))) return $.Arrays_copy$bailout(1, src, srcStart, dst, dstStart, count);
  if (typeof dst !== 'object' || dst === null || ((dst.constructor !== Array || !!dst.immutable$list) && !dst.is$JavaScriptIndexingBehavior())) return $.Arrays_copy$bailout(1, src, srcStart, dst, dstStart, count);
  if (typeof count !== 'number') return $.Arrays_copy$bailout(1, src, srcStart, dst, dstStart, count);
  if (srcStart == null) srcStart = 0;
  if (typeof srcStart !== 'number') return $.Arrays_copy$bailout(2, src, dst, dstStart, count, srcStart);
  if (dstStart == null) dstStart = 0;
  if (typeof dstStart !== 'number') return $.Arrays_copy$bailout(3, src, dst, count, srcStart, dstStart);
  if (srcStart < dstStart) {
    for (var i = srcStart + count - 1, j = dstStart + count - 1; i >= srcStart; --i, --j) {
      if (i !== (i | 0)) throw $.iae(i);
      var t1 = src.length;
      if (i < 0 || i >= t1) throw $.ioore(i);
      var t2 = src[i];
      if (j !== (j | 0)) throw $.iae(j);
      var t3 = dst.length;
      if (j < 0 || j >= t3) throw $.ioore(j);
      dst[j] = t2;
    }
  } else {
    for (t1 = srcStart + count, i = srcStart, j = dstStart; i < t1; ++i, ++j) {
      if (i !== (i | 0)) throw $.iae(i);
      t2 = src.length;
      if (i < 0 || i >= t2) throw $.ioore(i);
      t3 = src[i];
      if (j !== (j | 0)) throw $.iae(j);
      var t4 = dst.length;
      if (j < 0 || j >= t4) throw $.ioore(j);
      dst[j] = t3;
    }
  }
};

$.Math_asin = function(x) {
  return $.MathNatives_asin(x);
};

$._WorkerEventsImpl$ = function(_ptr) {
  return new $._WorkerEventsImpl(_ptr);
};

$.ltB = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a < b) : $.lt$slow(a, b) === true;
};

$._currentIsolate = function() {
  return $._globalState().get$currentContext();
};

$.MathNatives_asin = function(value) {
  return Math.asin($.checkNum(value));
};

$.FilteredElementList$ = function(node) {
  return new $.FilteredElementList(node.get$nodes(), node);
};

$.convertDartClosureToJS = function(closure, arity) {
  if (closure == null) return;
  var function$ = (closure.$identity);
  if (!!function$) return function$;
  function$ = (function() {
    return $.invokeClosure.$call$5(closure, $._currentIsolate(), arity, arguments[0], arguments[1]);
  });
  closure.$identity = function$;
  return function$;
};

$._FixedSizeListIterator$ = function(array) {
  return new $._FixedSizeListIterator($.get$length(array), 0, array);
};

$._JsSerializer$ = function() {
  var t1 = new $._JsSerializer(0, $._MessageTraverserVisitedMap$());
  t1._JsSerializer$0();
  return t1;
};

$._FrozenElementList$_wrap = function(_nodeList) {
  return new $._FrozenElementList(_nodeList);
};

$.split = function(receiver, pattern) {
  if (!(typeof receiver === 'string')) return receiver.split$1(pattern);
  $.checkNull(pattern);
  return $.stringSplitUnchecked(receiver, pattern);
};

$.StringBase_concatAll = function(strings) {
  return $.stringJoinUnchecked($.StringBase__toJsStringArray(strings), '');
};

$._Device_userAgent = function() {
  return $.window().get$navigator().get$userAgent();
};

$._InputElementEventsImpl$ = function(_ptr) {
  return new $._InputElementEventsImpl(_ptr);
};

$.getRange = function(receiver, start, length$) {
  if ($.isJsArray(receiver) !== true) return receiver.getRange$2(start, length$);
  if (0 === length$) return [];
  $.checkNull(start);
  $.checkNull(length$);
  if (!((typeof start === 'number') && (start === (start | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(start));
  if (!((typeof length$ === 'number') && (length$ === (length$ | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(length$));
  var t1 = length$ < 0;
  if (t1) throw $.captureStackTrace($.IllegalArgumentException$(length$));
  if (start < 0) throw $.captureStackTrace($.IndexOutOfRangeException$(start));
  var end = start + length$;
  if ($.gtB(end, $.get$length(receiver))) throw $.captureStackTrace($.IndexOutOfRangeException$(length$));
  if (t1) throw $.captureStackTrace($.IllegalArgumentException$(length$));
  return receiver.slice(start, end);
};

$._Lists_getRange = function(a, start, length$, accumulator) {
  if (typeof a !== 'string' && (typeof a !== 'object' || a === null || (a.constructor !== Array && !a.is$JavaScriptIndexingBehavior()))) return $._Lists_getRange$bailout(1, a, start, length$, accumulator);
  if (typeof start !== 'number') return $._Lists_getRange$bailout(1, a, start, length$, accumulator);
  if ($.ltB(length$, 0)) throw $.captureStackTrace($.IllegalArgumentException$('length'));
  if (start < 0) throw $.captureStackTrace($.IndexOutOfRangeException$(start));
  if (typeof length$ !== 'number') throw $.iae(length$);
  var end = start + length$;
  if (end > a.length) throw $.captureStackTrace($.IndexOutOfRangeException$(end));
  for (var i = start; i < end; ++i) {
    if (i !== (i | 0)) throw $.iae(i);
    var t1 = a.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    $.add$1(accumulator, a[i]);
  }
  return accumulator;
};

$._DoubleLinkedQueueIterator$ = function(_sentinel) {
  var t1 = new $._DoubleLinkedQueueIterator(null, _sentinel);
  t1._DoubleLinkedQueueIterator$1(_sentinel);
  return t1;
};

$.S = function(value) {
  var res = $.toString(value);
  if (!(typeof res === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(value));
  return res;
};

$._TextTrackListEventsImpl$ = function(_ptr) {
  return new $._TextTrackListEventsImpl(_ptr);
};

$._dynamicMetadata = function(table) {
  $dynamicMetadata = table;
};

$._dynamicMetadata0 = function() {
  if ((typeof($dynamicMetadata)) === 'undefined') {
    var t1 = [];
    $._dynamicMetadata(t1);
  }
  return $dynamicMetadata;
};

$.LinkedHashMapImplementation$ = function() {
  var t1 = new $.LinkedHashMapImplementation(null, null);
  t1.LinkedHashMapImplementation$0();
  return t1;
};

$._DeprecatedPeerConnectionEventsImpl$ = function(_ptr) {
  return new $._DeprecatedPeerConnectionEventsImpl(_ptr);
};

$.Vector2$ = function(x, y) {
  var t1 = new $.Vector2(null, null);
  t1.Vector2$2(x, y);
  return t1;
};

$.regExpGetNative = function(regExp) {
  var r = (regExp._re);
  return r == null ? (regExp._re = $.regExpMakeNative(regExp, false)) : r;
};

$.checkNull = function(object) {
  if (object == null) throw $.captureStackTrace($.NullPointerException$(null, $.CTC));
  return object;
};

$.throwNoSuchMethod = function(obj, name$, arguments$) {
  throw $.captureStackTrace($.NoSuchMethodException$(obj, name$, arguments$, null));
};

$.PerspectiveCamera$ = function(fov, aspect, near, far) {
  var t1 = new $.PerspectiveCamera(null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, false, false, null, null, null, null, false, false, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Object3D$0();
  t1.Camera$0();
  t1.PerspectiveCamera$4(fov, aspect, near, far);
  return t1;
};

$.StackTrace$ = function(stack) {
  return new $.StackTrace(stack);
};

$._EventListenerListImpl$ = function(_ptr, _type) {
  return new $._EventListenerListImpl(_type, _ptr);
};

$._fillStatics = function(context) {
    $globals = context.isolateStatics;
  $static_init();
;
};

$._WindowEventsImpl$ = function(_ptr) {
  return new $._WindowEventsImpl(_ptr);
};

$.DoubleLinkedQueue$ = function() {
  var t1 = new $.DoubleLinkedQueue(null);
  t1.DoubleLinkedQueue$0();
  return t1;
};

$.DualPivotQuicksort_insertionSort_ = function(a, left, right, compare) {
  if (typeof a !== 'object' || a === null || ((a.constructor !== Array || !!a.immutable$list) && !a.is$JavaScriptIndexingBehavior())) return $.DualPivotQuicksort_insertionSort_$bailout(1, a, left, right, compare);
  if (typeof left !== 'number') return $.DualPivotQuicksort_insertionSort_$bailout(1, a, left, right, compare);
  if (typeof right !== 'number') return $.DualPivotQuicksort_insertionSort_$bailout(1, a, left, right, compare);
  for (var i = left + 1; i <= right; ++i) {
    if (i !== (i | 0)) throw $.iae(i);
    var t1 = a.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    var el = a[i];
    var j = i;
    while (true) {
      if (j > left) {
        t1 = j - 1;
        if (t1 !== (t1 | 0)) throw $.iae(t1);
        var t2 = a.length;
        if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
        var t3 = $.gtB(compare.$call$2(a[t1], el), 0);
        t1 = t3;
      } else t1 = false;
      if (!t1) break;
      t1 = j - 1;
      if (t1 !== (t1 | 0)) throw $.iae(t1);
      t2 = a.length;
      if (t1 < 0 || t1 >= t2) throw $.ioore(t1);
      t1 = a[t1];
      if (j !== (j | 0)) throw $.iae(j);
      if (j < 0 || j >= t2) throw $.ioore(j);
      a[j] = t1;
      --j;
    }
    if (j !== (j | 0)) throw $.iae(j);
    t1 = a.length;
    if (j < 0 || j >= t1) throw $.ioore(j);
    a[j] = el;
  }
};

$.checkNumbers = function(a, b) {
  if (typeof a === 'number') {
    if (typeof b === 'number') return true;
    $.checkNull(b);
    throw $.captureStackTrace($.IllegalArgumentException$(b));
  }
  return false;
};

$.Math_random = function() {
  return $.MathNatives_random();
};

$._DoubleLinkedQueueEntrySentinel$ = function() {
  var t1 = new $._DoubleLinkedQueueEntrySentinel(null, null, null);
  t1.DoubleLinkedQueueEntry$1(null);
  t1._DoubleLinkedQueueEntrySentinel$0();
  return t1;
};

$.MathNatives_random = function() {
  return Math.random();
};

$.lt$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a < b;
  return a.operator$lt$1(b);
};

$.index$slow = function(a, index) {
  if (typeof a === 'string' || $.isJsArray(a) === true) {
    if (!((typeof index === 'number') && (index === (index | 0)))) {
      if (!(typeof index === 'number')) throw $.captureStackTrace($.IllegalArgumentException$(index));
      if (!($.truncate(index) === index)) throw $.captureStackTrace($.IllegalArgumentException$(index));
    }
    if ($.ltB(index, 0) || $.geB(index, $.get$length(a))) throw $.captureStackTrace($.IndexOutOfRangeException$(index));
    return a[index];
  }
  return a.operator$index$1(index);
};

$._globalState = function() {
  return $globalState;;
};

$._globalState0 = function(val) {
  $globalState = val;;
};

$.toString = function(value) {
  if (typeof value == "object" && value !== null) {
    if ($.isJsArray(value) === true) return $.Collections_collectionToString(value);
    return value.toString$0();
  }
  if (value === 0 && (1 / value) < 0) return '-0.0';
  if (value == null) return 'null';
  if (typeof value == "function") return 'Closure';
  return String(value);
};

$.LineBasicMaterial$ = function(parameters) {
  var t1 = new $.LineBasicMaterial(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Material$1(parameters);
  t1.LineBasicMaterial$1(parameters);
  return t1;
};

$.contains$2 = function(receiver, other, startIndex) {
  if (!(typeof receiver === 'string')) return receiver.contains$2(other, startIndex);
  $.checkNull(other);
  return $.stringContainsUnchecked(receiver, other, startIndex);
};

$.Quaternion$ = function(x, y, z, w) {
  return new $.Quaternion(w, z, y, x);
};

$._MainManagerStub$ = function() {
  return new $._MainManagerStub();
};

$.StringBase__toJsStringArray = function(strings) {
  if (typeof strings !== 'object' || strings === null || ((strings.constructor !== Array || !!strings.immutable$list) && !strings.is$JavaScriptIndexingBehavior())) return $.StringBase__toJsStringArray$bailout(1, strings);
  $.checkNull(strings);
  var length$ = strings.length;
  if ($.isJsArray(strings) === true) {
    for (var i = 0; i < length$; ++i) {
      var t1 = strings.length;
      if (i < 0 || i >= t1) throw $.ioore(i);
      var string = strings[i];
      $.checkNull(string);
      if (!(typeof string === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(string));
    }
    var array = strings;
  } else {
    array = $.ListFactory_List(length$);
    for (i = 0; i < length$; ++i) {
      t1 = strings.length;
      if (i < 0 || i >= t1) throw $.ioore(i);
      string = strings[i];
      $.checkNull(string);
      if (!(typeof string === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(string));
      t1 = array.length;
      if (i < 0 || i >= t1) throw $.ioore(i);
      array[i] = string;
    }
  }
  return array;
};

$.IndexOutOfRangeException$ = function(_value) {
  return new $.IndexOutOfRangeException(_value);
};

$._MessageTraverserVisitedMap$ = function() {
  return new $._MessageTraverserVisitedMap();
};

$.getTraceFromException = function(exception) {
  return $.StackTrace$((exception.stack));
};

$._TextTrackEventsImpl$ = function(_ptr) {
  return new $._TextTrackEventsImpl(_ptr);
};

$.charCodeAt = function(receiver, index) {
  if (typeof receiver === 'string') {
    if (!(typeof index === 'number')) throw $.captureStackTrace($.IllegalArgumentException$(index));
    if (index < 0) throw $.captureStackTrace($.IndexOutOfRangeException$(index));
    if (index >= receiver.length) throw $.captureStackTrace($.IndexOutOfRangeException$(index));
    return receiver.charCodeAt(index);
  }
  return receiver.charCodeAt$1(index);
};

$._BatteryManagerEventsImpl$ = function(_ptr) {
  return new $._BatteryManagerEventsImpl(_ptr);
};

$.Matrix4$ = function(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44) {
  var t1 = new $.Matrix4(n44, n43, n42, n41, n34, n33, n32, n31, n24, n23, n22, n21, n14, n13, n12, n11, null, null);
  t1.Matrix4$16(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44);
  return t1;
};

$._MediaStreamTrackListEventsImpl$ = function(_ptr) {
  return new $._MediaStreamTrackListEventsImpl(_ptr);
};

$.toInt = function(receiver) {
  if (!(typeof receiver === 'number')) return receiver.toInt$0();
  if ($.isNaN(receiver) === true) throw $.captureStackTrace($.BadNumberFormatException$('NaN'));
  if ($.isInfinite(receiver) === true) throw $.captureStackTrace($.BadNumberFormatException$('Infinity'));
  var truncated = $.truncate(receiver);
  return (truncated == -0.0) ? 0 : truncated;
};

$._EventLoop$ = function() {
  var t1 = $.DoubleLinkedQueue$();
  $.setRuntimeTypeInfo(t1, ({E: '_IsolateEvent'}));
  return new $._EventLoop(t1);
};

$._WebSocketEventsImpl$ = function(_ptr) {
  return new $._WebSocketEventsImpl(_ptr);
};

$.KeyValuePair$ = function(key, value) {
  return new $.KeyValuePair(value, key);
};

$.Collections_collectionToString = function(c) {
  var result = $.StringBufferImpl$('');
  $.Collections__emitCollection(c, result, $.ListFactory_List(null));
  return result.toString$0();
};

$.MetaInfo$ = function(tag, tags, set) {
  return new $.MetaInfo(set, tags, tag);
};

$._MediaStreamEventsImpl$ = function(_ptr) {
  return new $._MediaStreamEventsImpl(_ptr);
};

$.Canvas_Lines$ = function() {
  return new $.Canvas_Lines(0, 0, 0, 0, null, null, null, null, null, null);
};

$._NativeJsSendPort$ = function(_receivePort, isolateId) {
  return new $._NativeJsSendPort(_receivePort, isolateId);
};

$.defineProperty = function(obj, property, value) {
  Object.defineProperty(obj, property,
      {value: value, enumerable: false, writable: true, configurable: true});
};

$.dynamicFunction = function(name$) {
  var f = (Object.prototype[name$]);
  if (!(f == null) && (!!f.methods)) return f.methods;
  var methods = ({});
  var dartMethod = (Object.getPrototypeOf($.CTC9)[name$]);
  !(dartMethod == null) && (methods['Object'] = dartMethod);
  var bind = (function() {return $.dynamicBind.$call$4(this, name$, methods, Array.prototype.slice.call(arguments));});
  bind.methods = methods;
  $.defineProperty((Object.prototype), name$, bind);
  return methods;
};

$.print = function(obj) {
  return $.Primitives_printString($.toString(obj));
};

$.checkString = function(value) {
  if (!(typeof value === 'string')) {
    $.checkNull(value);
    throw $.captureStackTrace($.IllegalArgumentException$(value));
  }
  return value;
};

$.div = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a / b) : $.div$slow(a, b);
};

$.Math_tan = function(x) {
  return $.MathNatives_tan(x);
};

$.MathNatives_tan = function(value) {
  return Math.tan($.checkNum(value));
};

$._callInIsolate = function(isolate, function$) {
  isolate.eval$1(function$);
  $._globalState().get$topEventLoop().run$0();
};

$.addAll = function(receiver, collection) {
  if ($.isJsArray(receiver) !== true) return receiver.addAll$1(collection);
  var iterator = $.iterator(collection);
  for (; iterator.hasNext$0() === true; ) {
    $.add$1(receiver, iterator.next$0());
  }
};

$.RenderableParticle$ = function() {
  var t1 = new $.RenderableParticle(null, null, null, null, null, null);
  t1.RenderableParticle$0();
  return t1;
};

$.Primitives_objectToString = function(object) {
  return 'Instance of \'' + $.S($.Primitives_objectTypeName(object)) + '\'';
};

$.HashMapImplementation__firstProbe = function(hashCode, length$) {
  return $.and(hashCode, $.sub(length$, 1));
};

$.set$length = function(receiver, newLength) {
  if ($.isJsArray(receiver) === true) {
    $.checkNull(newLength);
    if (!((typeof newLength === 'number') && (newLength === (newLength | 0)))) throw $.captureStackTrace($.IllegalArgumentException$(newLength));
    if (newLength < 0) throw $.captureStackTrace($.IndexOutOfRangeException$(newLength));
    $.checkGrowable(receiver, 'set length');
    receiver.length = newLength;
  } else receiver.set$length(newLength);
  return newLength;
};

$.ioore = function(index) {
  throw $.captureStackTrace($.IndexOutOfRangeException$(index));
};

$.typeNameInFirefox = function(obj) {
  var name$ = $.constructorNameFallback(obj);
  if ($.eqB(name$, 'Window')) return 'DOMWindow';
  if ($.eqB(name$, 'Document')) return 'HTMLDocument';
  if ($.eqB(name$, 'XMLDocument')) return 'Document';
  if ($.eqB(name$, 'WorkerMessageEvent')) return 'MessageEvent';
  return name$;
};

$.gt$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a > b;
  return a.operator$gt$1(b);
};

$._Lists_indexOf = function(a, element, startIndex, endIndex) {
  if (typeof a !== 'string' && (typeof a !== 'object' || a === null || (a.constructor !== Array && !a.is$JavaScriptIndexingBehavior()))) return $._Lists_indexOf$bailout(1, a, element, startIndex, endIndex);
  if (typeof endIndex !== 'number') return $._Lists_indexOf$bailout(1, a, element, startIndex, endIndex);
  if ($.geB(startIndex, a.length)) return -1;
  if ($.ltB(startIndex, 0)) startIndex = 0;
  if (typeof startIndex !== 'number') return $._Lists_indexOf$bailout(2, a, element, startIndex, endIndex);
  for (var i = startIndex; i < endIndex; ++i) {
    if (i !== (i | 0)) throw $.iae(i);
    var t1 = a.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    if ($.eqB(a[i], element)) return i;
  }
  return -1;
};

$.hashCode = function(receiver) {
  if (typeof receiver === 'number') return receiver & 0x1FFFFFFF;
  if (!(typeof receiver === 'string')) return receiver.hashCode$0();
  var length$ = (receiver.length);
  for (var hash = 0, i = 0; i < length$; ++i) {
    var hash0 = 536870911 & hash + (receiver.charCodeAt(i));
    var hash1 = 536870911 & hash0 + (524287 & hash0 << 10);
    hash1 = (hash1 ^ $.shr(hash1, 6)) >>> 0;
    hash = hash1;
  }
  hash0 = 536870911 & hash + (67108863 & hash << 3);
  hash0 = (hash0 ^ $.shr(hash0, 11)) >>> 0;
  return 536870911 & hash0 + (16383 & hash0 << 15);
};

$._JsVisitedMap$ = function() {
  return new $._JsVisitedMap(null);
};

$.makeLiteralMap = function(keyValuePairs) {
  var iterator = $.iterator(keyValuePairs);
  var result = $.LinkedHashMapImplementation$();
  for (; iterator.hasNext$0() === true; ) {
    result.operator$indexSet$2(iterator.next$0(), iterator.next$0());
  }
  return result;
};

$.Math_min = function(a, b) {
  if (typeof a === 'number') {
    if (typeof b === 'number') {
      if (a > b) return b;
      if (a < b) return a;
      if (typeof b === 'number') {
        if (typeof a === 'number') {
          if (a === 0.0) return (a + b) * a * b;
        }
        if (a === 0 && $.isNegative(b) === true || $.isNaN(b) === true) return b;
        return a;
      }
      return a;
    }
    throw $.captureStackTrace($.IllegalArgumentException$(b));
  }
  throw $.captureStackTrace($.IllegalArgumentException$(a));
};

$.startsWith = function(receiver, other) {
  if (!(typeof receiver === 'string')) return receiver.startsWith$1(other);
  $.checkString(other);
  var length$ = $.get$length(other);
  if ($.gtB(length$, receiver.length)) return false;
  return other == receiver.substring(0, length$);
};

$.Collections_forEach = function(iterable, f) {
  for (var t1 = $.iterator(iterable); t1.hasNext$0() === true; ) {
    f.$call$1(t1.next$0());
  }
};

$.toStringForNativeObject = function(obj) {
  return 'Instance of ' + $.S($.getTypeNameOf(obj));
};

$.forEach = function(receiver, f) {
  if ($.isJsArray(receiver) !== true) return receiver.forEach$1(f);
  return $.Collections_forEach(receiver, f);
};

$.removeLast = function(receiver) {
  if ($.isJsArray(receiver) === true) {
    $.checkGrowable(receiver, 'removeLast');
    if ($.get$length(receiver) === 0) throw $.captureStackTrace($.IndexOutOfRangeException$(-1));
    return receiver.pop();
  }
  return receiver.removeLast$0();
};

$.Matrix4_makePerspective = function(fov, aspect, near, far) {
  var ymax = $.mul(near, $.Math_tan($.div($.mul(fov, 3.141592653589793), 360)));
  var ymin = $.neg(ymax);
  return $.Matrix4_makeFrustum($.mul(ymin, aspect), $.mul(ymax, aspect), ymin, ymax, near, far);
};

$._MessagePortEventsImpl$ = function(_ptr) {
  return new $._MessagePortEventsImpl(_ptr);
};

$._Collections_forEach = function(iterable, f) {
  for (var t1 = $.iterator(iterable); t1.hasNext$0() === true; ) {
    f.$call$1(t1.next$0());
  }
};

$.index = function(a, index) {
  if (typeof a == "string" || a.constructor === Array) {
    var key = (index >>> 0);
    if (key === index && key < (a.length)) return a[key];
  }
  return $.index$slow(a, index);
};

$.sort = function(receiver, compare) {
  if ($.isJsArray(receiver) !== true) return receiver.sort$1(compare);
  $.checkMutable(receiver, 'sort');
  $.DualPivotQuicksort_sort(receiver, compare);
};

$.DualPivotQuicksort_sort = function(a, compare) {
  $.DualPivotQuicksort__doSort(a, 0, $.sub($.get$length(a), 1), compare);
};

$._ElementEventsImpl$ = function(_ptr) {
  return new $._ElementEventsImpl(_ptr);
};

$.ProjectorRenderData$ = function() {
  var t1 = new $.ProjectorRenderData(null, null, null, null);
  t1.ProjectorRenderData$0();
  return t1;
};

$.xor = function(a, b) {
  if ($.checkNumbers(a, b) === true) return (a ^ b) >>> 0;
  return a.operator$xor$1(b);
};

$.dynamicBind = function(obj, name$, methods, arguments$) {
  var tag = $.getTypeNameOf(obj);
  var method = (methods[tag]);
  if (method == null && !($._dynamicMetadata0() == null)) {
    for (var i = 0; $.ltB(i, $.get$length($._dynamicMetadata0())); ++i) {
      var entry = $.index($._dynamicMetadata0(), i);
      if ($.contains$1(entry.get$set(), tag) === true) {
        method = (methods[entry.get$tag()]);
        if (!(method == null)) break;
      }
    }
  }
  if (method == null) method = (methods['Object']);
  var proto = (Object.getPrototypeOf(obj));
  if (method == null) method = (function () {if (Object.getPrototypeOf(this) === proto) {$.throwNoSuchMethod.$call$3(this, name$, Array.prototype.slice.call(arguments));} else {return Object.prototype[name$].apply(this, arguments);}});
  (!proto.hasOwnProperty(name$)) && $.defineProperty(proto, name$, method);
  return method.apply(obj, arguments$);
};

$.Math_sin = function(x) {
  return $.MathNatives_sin(x);
};

$.DualPivotQuicksort__doSort = function(a, left, right, compare) {
  if ($.leB($.sub(right, left), 32)) $.DualPivotQuicksort_insertionSort_(a, left, right, compare);
  else $.DualPivotQuicksort__dualPivotQuicksort(a, left, right, compare);
};

$.MathNatives_sin = function(value) {
  return Math.sin($.checkNum(value));
};

$.ListFactory_List = function(length$) {
  return $.Primitives_newList(length$);
};

$._XMLHttpRequestUploadEventsImpl$ = function(_ptr) {
  return new $._XMLHttpRequestUploadEventsImpl(_ptr);
};

$.getFunctionForTypeNameOf = function() {
  if (!((typeof(navigator)) === 'object')) return $.typeNameInChrome;
  var userAgent = (navigator.userAgent);
  if ($.contains$1(userAgent, $.CTC8) === true) return $.typeNameInChrome;
  if ($.contains$1(userAgent, 'Firefox') === true) return $.typeNameInFirefox;
  if ($.contains$1(userAgent, 'MSIE') === true) return $.typeNameInIE;
  if ($.contains$1(userAgent, 'Opera') === true) return $.typeNameInOpera;
  return $.constructorNameFallback;
};

$.captureStackTrace = function(ex) {
  if (ex == null) ex = $.CTC0;
  var jsError = (new Error());
  jsError.dartException = ex;
  jsError.toString = $.toStringWrapper.$call$0;
  return jsError;
};

$.indexOf$1 = function(receiver, element) {
  if ($.isJsArray(receiver) === true) return $.Arrays_indexOf(receiver, element, 0, (receiver.length));
  if (typeof receiver === 'string') {
    $.checkNull(element);
    if (!(typeof element === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(element));
    return receiver.indexOf(element);
  }
  return receiver.indexOf$1(element);
};

$.not = function(a) {
  if (typeof a === "number") return (~a) >>> 0;
  return a.operator$not$0();
};

$.StackOverflowException$ = function() {
  return new $.StackOverflowException();
};

$.eq = function(a, b) {
  if (a == null) return b == null;
  if (b == null) return false;
  if (typeof a === "object") {
    if (!!a.operator$eq$1) return a.operator$eq$1(b);
  }
  return a === b;
};

$.StringBufferImpl$ = function(content$) {
  var t1 = new $.StringBufferImpl(null, null);
  t1.StringBufferImpl$1(content$);
  return t1;
};

$.HashMapImplementation$ = function() {
  var t1 = new $.HashMapImplementation(null, null, null, null, null);
  t1.HashMapImplementation$0();
  return t1;
};

$.substring$1 = function(receiver, startIndex) {
  if (!(typeof receiver === 'string')) return receiver.substring$1(startIndex);
  return $.substring$2(receiver, startIndex, null);
};

$.div$slow = function(a, b) {
  if ($.checkNumbers(a, b) === true) return a / b;
  return a.operator$div$1(b);
};

$.Line$ = function(geometry, material, ltype) {
  var t1 = new $.Line(0, null, null, null, false, false, false, false, null, null, null, null, false, false, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
  t1.Object3D$0();
  t1.Line$3(geometry, material, ltype);
  return t1;
};

$.Arrays_indexOf = function(a, element, startIndex, endIndex) {
  if (typeof a !== 'string' && (typeof a !== 'object' || a === null || (a.constructor !== Array && !a.is$JavaScriptIndexingBehavior()))) return $.Arrays_indexOf$bailout(1, a, element, startIndex, endIndex);
  if (typeof endIndex !== 'number') return $.Arrays_indexOf$bailout(1, a, element, startIndex, endIndex);
  if ($.geB(startIndex, a.length)) return -1;
  if ($.ltB(startIndex, 0)) startIndex = 0;
  if (typeof startIndex !== 'number') return $.Arrays_indexOf$bailout(2, a, element, startIndex, endIndex);
  for (var i = startIndex; i < endIndex; ++i) {
    if (i !== (i | 0)) throw $.iae(i);
    var t1 = a.length;
    if (i < 0 || i >= t1) throw $.ioore(i);
    if ($.eqB(a[i], element)) return i;
  }
  return -1;
};

$._SharedWorkerContextEventsImpl$ = function(_ptr) {
  return new $._SharedWorkerContextEventsImpl(_ptr);
};

$._IDBVersionChangeRequestEventsImpl$ = function(_ptr) {
  return new $._IDBVersionChangeRequestEventsImpl(_ptr);
};

$.gtB = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a > b) : $.gt$slow(a, b) === true;
};

$.setRuntimeTypeInfo = function(target, typeInfo) {
  !(target == null) && (target.builtin$typeInfo = typeInfo);
};

$.document = function() {
  return document;;
};

$._FileWriterEventsImpl$ = function(_ptr) {
  return new $._FileWriterEventsImpl(_ptr);
};

$.NoSuchMethodException$ = function(_receiver, _functionName, _arguments, existingArgumentNames) {
  return new $.NoSuchMethodException(existingArgumentNames, _arguments, _functionName, _receiver);
};

$.lt = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a < b) : $.lt$slow(a, b);
};

$.unwrapException = function(ex) {
  if ("dartException" in ex) return ex.dartException;
  var message = (ex.message);
  if (ex instanceof TypeError) {
    var type = (ex.type);
    var name$ = (ex.arguments ? ex.arguments[0] : "");
    if ($.eqB(type, 'property_not_function') || ($.eqB(type, 'called_non_callable') || ($.eqB(type, 'non_object_property_call') || $.eqB(type, 'non_object_property_load')))) {
      if (typeof name$ === 'string' && $.startsWith(name$, '$call$') === true) return $.ObjectNotClosureException$();
      return $.NullPointerException$(null, $.CTC);
    }
    if ($.eqB(type, 'undefined_method')) {
      if (typeof name$ === 'string' && $.startsWith(name$, '$call$') === true) return $.ObjectNotClosureException$();
      return $.NoSuchMethodException$('', name$, [], null);
    }
    if (typeof message === 'string') {
      if ($.endsWith(message, 'is null') === true || ($.endsWith(message, 'is undefined') === true || $.endsWith(message, 'is null or undefined') === true)) return $.NullPointerException$(null, $.CTC);
      if ($.endsWith(message, 'is not a function') === true) return $.NoSuchMethodException$('', '<unknown>', [], null);
    }
    return $.ExceptionImplementation$(typeof message === 'string' ? message : '');
  }
  if (ex instanceof RangeError) {
    if (typeof message === 'string' && $.contains$1(message, 'call stack') === true) return $.StackOverflowException$();
    return $.IllegalArgumentException$('');
  }
  if (typeof InternalError == 'function' && ex instanceof InternalError) {
    if (typeof message === 'string' && message === 'too much recursion') return $.StackOverflowException$();
  }
  return ex;
};

$.shl = function(a, b) {
  if ($.checkNumbers(a, b) === true) {
    a = (a);
    b = (b);
    if (b < 0) throw $.captureStackTrace($.IllegalArgumentException$(b));
    if (b > 31) return 0;
    return (a << b) >>> 0;
  }
  return a.operator$shl$1(b);
};

$.ceil = function(receiver) {
  if (!(typeof receiver === 'number')) return receiver.ceil$0();
  return Math.ceil(receiver);
};

$.getTypeNameOf = function(obj) {
  if ($._getTypeNameOf == null) $._getTypeNameOf = $.getFunctionForTypeNameOf();
  return $._getTypeNameOf.$call$1(obj);
};

$.Math_cos = function(x) {
  return $.MathNatives_cos(x);
};

$.MathNatives_cos = function(value) {
  return Math.cos($.checkNum(value));
};

$.sub = function(a, b) {
  return typeof a === 'number' && typeof b === 'number' ? (a - b) : $.sub$slow(a, b);
};

$._Lists_indexOf$bailout = function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var a = env0;
      var element = env1;
      var startIndex = env2;
      var endIndex = env3;
      break;
    case 2:
      a = env0;
      element = env1;
      startIndex = env2;
      endIndex = env3;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      if ($.geB(startIndex, $.get$length(a))) return -1;
      if ($.ltB(startIndex, 0)) startIndex = 0;
    case 2:
      state = 0;
      for (var i = startIndex; $.ltB(i, endIndex); i = $.add(i, 1)) {
        if ($.eqB($.index(a, i), element)) return i;
      }
      return -1;
  }
};

$.Arrays_indexOf$bailout = function(state, env0, env1, env2, env3) {
  switch (state) {
    case 1:
      var a = env0;
      var element = env1;
      var startIndex = env2;
      var endIndex = env3;
      break;
    case 2:
      a = env0;
      element = env1;
      startIndex = env2;
      endIndex = env3;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      if ($.geB(startIndex, $.get$length(a))) return -1;
      if ($.ltB(startIndex, 0)) startIndex = 0;
    case 2:
      state = 0;
      for (var i = startIndex; $.ltB(i, endIndex); i = $.add(i, 1)) {
        if ($.eqB($.index(a, i), element)) return i;
      }
      return -1;
  }
};

$.DualPivotQuicksort__dualPivotQuicksort$bailout = function(state, env0, env1, env2, env3, env4, env5, env6, env7, env8, env9, env10, env11, env12, env13) {
  switch (state) {
    case 1:
      var a = env0;
      var left = env1;
      var right = env2;
      var compare = env3;
      break;
    case 2:
      a = env0;
      left = env1;
      right = env2;
      compare = env3;
      index5 = env4;
      el2 = env5;
      index1 = env6;
      el4 = env7;
      less = env8;
      break;
    case 3:
      a = env0;
      left = env1;
      right = env2;
      compare = env3;
      index5 = env4;
      el2 = env5;
      great = env6;
      less = env7;
      el4 = env8;
      index1 = env9;
      break;
    case 4:
      a = env0;
      less = env1;
      k = env2;
      compare = env3;
      left = env4;
      right = env5;
      great = env6;
      index1 = env7;
      index5 = env8;
      el2 = env9;
      t1 = env10;
      ak = env11;
      comp = env12;
      el4 = env13;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      var sixth = $.tdiv($.add($.sub(right, left), 1), 6);
      var index1 = $.add(left, sixth);
      var index5 = $.sub(right, sixth);
      var index3 = $.tdiv($.add(left, right), 2);
      var index2 = $.sub(index3, sixth);
      var index4 = $.add(index3, sixth);
      var el1 = $.index(a, index1);
      var el2 = $.index(a, index2);
      var el3 = $.index(a, index3);
      var el4 = $.index(a, index4);
      var el5 = $.index(a, index5);
      if ($.gtB(compare.$call$2(el1, el2), 0)) {
        var t0 = el1;
        el1 = el2;
        el2 = t0;
      }
      if ($.gtB(compare.$call$2(el4, el5), 0)) {
        t0 = el5;
        el5 = el4;
        el4 = t0;
      }
      if ($.gtB(compare.$call$2(el1, el3), 0)) {
        t0 = el3;
        el3 = el1;
        el1 = t0;
      }
      if ($.gtB(compare.$call$2(el2, el3), 0)) {
        t0 = el3;
        el3 = el2;
        el2 = t0;
      }
      if ($.gtB(compare.$call$2(el1, el4), 0)) {
        t0 = el1;
        el1 = el4;
        el4 = t0;
      }
      if ($.gtB(compare.$call$2(el3, el4), 0)) {
        t0 = el3;
        el3 = el4;
        el4 = t0;
      }
      if ($.gtB(compare.$call$2(el2, el5), 0)) {
        t0 = el2;
        el2 = el5;
        el5 = t0;
      }
      if ($.gtB(compare.$call$2(el2, el3), 0)) {
        t0 = el3;
        el3 = el2;
        el2 = t0;
      }
      if ($.gtB(compare.$call$2(el4, el5), 0)) {
        t0 = el5;
        el5 = el4;
        el4 = t0;
      }
      $.indexSet(a, index1, el1);
      $.indexSet(a, index3, el3);
      $.indexSet(a, index5, el5);
      $.indexSet(a, index2, $.index(a, left));
      $.indexSet(a, index4, $.index(a, right));
      var less = $.add(left, 1);
    case 2:
      state = 0;
      var great = $.sub(right, 1);
    case 3:
      state = 0;
      var t1 = $.eq(compare.$call$2(el2, el4), 0) === true;
    case 4:
      if (state == 4 || (state == 0 && t1)) {
        switch (state) {
          case 0:
            var k = less;
          case 4:
            L0: while (true) {
              switch (state) {
                case 0:
                  if (!$.leB(k, great)) break L0;
                case 4:
                  c$0:{
                    switch (state) {
                      case 0:
                        var ak = $.index(a, k);
                        var comp = compare.$call$2(ak, el2);
                      case 4:
                        state = 0;
                        if ($.eqB(comp, 0)) break c$0;
                        if ($.ltB(comp, 0)) {
                          if (!$.eqB(k, less)) {
                            $.indexSet(a, k, $.index(a, less));
                            $.indexSet(a, less, ak);
                          }
                          less = $.add(less, 1);
                        } else {
                          for (; true; ) {
                            comp = compare.$call$2($.index(a, great), el2);
                            if ($.gtB(comp, 0)) {
                              great = $.sub(great, 1);
                              continue;
                            } else {
                              if ($.ltB(comp, 0)) {
                                $.indexSet(a, k, $.index(a, less));
                                var less0 = $.add(less, 1);
                                $.indexSet(a, less, $.index(a, great));
                                var great0 = $.sub(great, 1);
                                $.indexSet(a, great, ak);
                                great = great0;
                                less = less0;
                                break;
                              } else {
                                $.indexSet(a, k, $.index(a, great));
                                great0 = $.sub(great, 1);
                                $.indexSet(a, great, ak);
                                great = great0;
                                break;
                              }
                            }
                          }
                        }
                    }
                  }
                  k = $.add(k, 1);
              }
            }
        }
      } else {
        for (k = less; $.leB(k, great); k = $.add(k, 1)) {
          ak = $.index(a, k);
          if ($.ltB(compare.$call$2(ak, el2), 0)) {
            if (!$.eqB(k, less)) {
              $.indexSet(a, k, $.index(a, less));
              $.indexSet(a, less, ak);
            }
            less = $.add(less, 1);
          } else {
            if ($.gtB(compare.$call$2(ak, el4), 0)) {
              for (; true; ) {
                if ($.gtB(compare.$call$2($.index(a, great), el4), 0)) {
                  great = $.sub(great, 1);
                  if ($.ltB(great, k)) break;
                  continue;
                } else {
                  if ($.ltB(compare.$call$2($.index(a, great), el2), 0)) {
                    $.indexSet(a, k, $.index(a, less));
                    less0 = $.add(less, 1);
                    $.indexSet(a, less, $.index(a, great));
                    great0 = $.sub(great, 1);
                    $.indexSet(a, great, ak);
                    great = great0;
                    less = less0;
                  } else {
                    $.indexSet(a, k, $.index(a, great));
                    great0 = $.sub(great, 1);
                    $.indexSet(a, great, ak);
                    great = great0;
                  }
                  break;
                }
              }
            }
          }
        }
      }
      $.indexSet(a, left, $.index(a, $.sub(less, 1)));
      $.indexSet(a, $.sub(less, 1), el2);
      $.indexSet(a, right, $.index(a, $.add(great, 1)));
      $.indexSet(a, $.add(great, 1), el4);
      $.DualPivotQuicksort__doSort(a, left, $.sub(less, 2), compare);
      $.DualPivotQuicksort__doSort(a, $.add(great, 2), right, compare);
      if (t1) return;
      if ($.ltB(less, index1) && $.gtB(great, index5)) {
        for (; $.eqB(compare.$call$2($.index(a, less), el2), 0); ) {
          less = $.add(less, 1);
        }
        for (; $.eqB(compare.$call$2($.index(a, great), el4), 0); ) {
          great = $.sub(great, 1);
        }
        for (k = less; $.leB(k, great); k = $.add(k, 1)) {
          ak = $.index(a, k);
          if ($.eqB(compare.$call$2(ak, el2), 0)) {
            if (!$.eqB(k, less)) {
              $.indexSet(a, k, $.index(a, less));
              $.indexSet(a, less, ak);
            }
            less = $.add(less, 1);
          } else {
            if ($.eqB(compare.$call$2(ak, el4), 0)) {
              for (; true; ) {
                if ($.eqB(compare.$call$2($.index(a, great), el4), 0)) {
                  great = $.sub(great, 1);
                  if ($.ltB(great, k)) break;
                  continue;
                } else {
                  if ($.ltB(compare.$call$2($.index(a, great), el2), 0)) {
                    $.indexSet(a, k, $.index(a, less));
                    less0 = $.add(less, 1);
                    $.indexSet(a, less, $.index(a, great));
                    great0 = $.sub(great, 1);
                    $.indexSet(a, great, ak);
                    great = great0;
                    less = less0;
                  } else {
                    $.indexSet(a, k, $.index(a, great));
                    great0 = $.sub(great, 1);
                    $.indexSet(a, great, ak);
                    great = great0;
                  }
                  break;
                }
              }
            }
          }
        }
        $.DualPivotQuicksort__doSort(a, less, great, compare);
      } else $.DualPivotQuicksort__doSort(a, less, great, compare);
  }
};

$.allMatchesInStringUnchecked$bailout = function(state, needle, haystack, length$, patternLength, result) {
  for (var startIndex = 0; true; ) {
    var position = $.indexOf$2(haystack, needle, startIndex);
    if ($.eqB(position, -1)) break;
    result.push($.StringMatch$(position, haystack, needle));
    var endIndex = $.add(position, patternLength);
    if ($.eqB(endIndex, length$)) break;
    else {
      startIndex = $.eqB(position, endIndex) ? $.add(startIndex, 1) : endIndex;
    }
  }
  return result;
};

$.DualPivotQuicksort_insertionSort_$bailout = function(state, a, left, right, compare) {
  for (var i = $.add(left, 1); $.leB(i, right); i = $.add(i, 1)) {
    var el = $.index(a, i);
    var j = i;
    while (true) {
      if (!($.gtB(j, left) && $.gtB(compare.$call$2($.index(a, $.sub(j, 1)), el), 0))) break;
      $.indexSet(a, j, $.index(a, $.sub(j, 1)));
      j = $.sub(j, 1);
    }
    $.indexSet(a, j, el);
  }
};

$.Arrays_copy$bailout = function(state, env0, env1, env2, env3, env4) {
  switch (state) {
    case 1:
      var src = env0;
      var srcStart = env1;
      var dst = env2;
      var dstStart = env3;
      var count = env4;
      break;
    case 2:
      src = env0;
      dst = env1;
      dstStart = env2;
      count = env3;
      srcStart = env4;
      break;
    case 3:
      src = env0;
      dst = env1;
      count = env2;
      srcStart = env3;
      dstStart = env4;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      if (srcStart == null) srcStart = 0;
    case 2:
      state = 0;
      if (dstStart == null) dstStart = 0;
    case 3:
      state = 0;
      if ($.ltB(srcStart, dstStart)) {
        for (var i = $.sub($.add(srcStart, count), 1), j = $.sub($.add(dstStart, count), 1); $.geB(i, srcStart); i = $.sub(i, 1), j = $.sub(j, 1)) {
          $.indexSet(dst, j, $.index(src, i));
        }
      } else {
        for (i = srcStart, j = dstStart; $.ltB(i, $.add(srcStart, count)); i = $.add(i, 1), j = $.add(j, 1)) {
          $.indexSet(dst, j, $.index(src, i));
        }
      }
  }
};

$.buildDynamicMetadata$bailout = function(state, env0, env1, env2, env3, env4, env5, env6) {
  switch (state) {
    case 1:
      var inputTable = env0;
      break;
    case 2:
      inputTable = env0;
      result = env1;
      tagNames = env2;
      tag = env3;
      i = env4;
      tags = env5;
      set = env6;
      break;
  }
  switch (state) {
    case 0:
    case 1:
      state = 0;
      var result = [];
      var i = 0;
    case 2:
      L0: while (true) {
        switch (state) {
          case 0:
            if (!$.ltB(i, $.get$length(inputTable))) break L0;
            var tag = $.index($.index(inputTable, i), 0);
            var tags = $.index($.index(inputTable, i), 1);
            var set = $.HashSetImplementation$();
            $.setRuntimeTypeInfo(set, ({E: 'String'}));
            var tagNames = $.split(tags, '|');
          case 2:
            state = 0;
            for (var j = 0; $.ltB(j, $.get$length(tagNames)); ++j) {
              set.add$1($.index(tagNames, j));
            }
            $.add$1(result, $.MetaInfo$(tag, tags, set));
            ++i;
        }
      }
      return result;
  }
};

$._Lists_getRange$bailout = function(state, a, start, length$, accumulator) {
  if ($.ltB(length$, 0)) throw $.captureStackTrace($.IllegalArgumentException$('length'));
  if ($.ltB(start, 0)) throw $.captureStackTrace($.IndexOutOfRangeException$(start));
  var end = $.add(start, length$);
  if ($.gtB(end, $.get$length(a))) throw $.captureStackTrace($.IndexOutOfRangeException$(end));
  for (var i = start; $.ltB(i, end); i = $.add(i, 1)) {
    $.add$1(accumulator, $.index(a, i));
  }
  return accumulator;
};

$.StringBase__toJsStringArray$bailout = function(state, strings) {
  $.checkNull(strings);
  var length$ = $.get$length(strings);
  if ($.isJsArray(strings) === true) {
    for (var i = 0; $.ltB(i, length$); ++i) {
      var string = $.index(strings, i);
      $.checkNull(string);
      if (!(typeof string === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(string));
    }
    var array = strings;
  } else {
    array = $.ListFactory_List(length$);
    for (i = 0; $.ltB(i, length$); ++i) {
      string = $.index(strings, i);
      $.checkNull(string);
      if (!(typeof string === 'string')) throw $.captureStackTrace($.IllegalArgumentException$(string));
      var t1 = array.length;
      if (i < 0 || i >= t1) throw $.ioore(i);
      array[i] = string;
    }
  }
  return array;
};

$.dynamicBind.$call$4 = $.dynamicBind;
$.dynamicBind.$name = "dynamicBind";
$.typeNameInOpera.$call$1 = $.typeNameInOpera;
$.typeNameInOpera.$name = "typeNameInOpera";
$.throwNoSuchMethod.$call$3 = $.throwNoSuchMethod;
$.throwNoSuchMethod.$name = "throwNoSuchMethod";
$.typeNameInIE.$call$1 = $.typeNameInIE;
$.typeNameInIE.$name = "typeNameInIE";
$.typeNameInChrome.$call$1 = $.typeNameInChrome;
$.typeNameInChrome.$name = "typeNameInChrome";
$.toStringWrapper.$call$0 = $.toStringWrapper;
$.toStringWrapper.$name = "toStringWrapper";
$.invokeClosure.$call$5 = $.invokeClosure;
$.invokeClosure.$name = "invokeClosure";
$.typeNameInFirefox.$call$1 = $.typeNameInFirefox;
$.typeNameInFirefox.$name = "typeNameInFirefox";
$.constructorNameFallback.$call$1 = $.constructorNameFallback;
$.constructorNameFallback.$name = "constructorNameFallback";
Isolate.$finishClasses($$);
$$ = {};
Isolate.makeConstantList = function(list) {
  list.immutable$list = true;
  list.fixed$length = true;
  return list;
};
$.CTC = Isolate.makeConstantList([]);
$.CTC4 = new Isolate.$isolateProperties.UnsupportedOperationException('');
$.CTC5 = new Isolate.$isolateProperties.IllegalArgumentException('Invalid list length');
$.CTC9 = new Isolate.$isolateProperties.Object();
$.CTC6 = new Isolate.$isolateProperties.UnsupportedOperationException('TODO(jacobr): should we impl?');
$.CTC3 = new Isolate.$isolateProperties._DeletedKeySentinel();
$.CTC7 = new Isolate.$isolateProperties.NotImplementedException(null);
$.CTC8 = new Isolate.$isolateProperties.JSSyntaxRegExp(false, false, 'Chrome|DumpRenderTree');
$.CTC0 = new Isolate.$isolateProperties.NullPointerException(Isolate.$isolateProperties.CTC, null);
$.CTC1 = new Isolate.$isolateProperties.NoMoreElementsException();
$.CTC2 = new Isolate.$isolateProperties.EmptyQueueException();
$.Matrix4___m2 = null;
$._getTypeNameOf = null;
$.Matrix4___v1 = null;
$.Frustum___v1 = null;
$._cachedBrowserPrefix = null;
$.Three_Object3DCount = 0;
$.Matrix4___m1 = null;
$.Matrix4___v2 = null;
$.Matrix4___v3 = null;
$.dynamicUnknownElementDispatcher = null;
$.Three_GeometryCount = 0;
$.Three_MaterialCount = 0;
var $ = null;
Isolate.$finishClasses($$);
$$ = {};
Isolate = Isolate.$finishIsolateConstructor(Isolate);
var $ = new Isolate();
$.$defineNativeClass = function(cls, fields, methods) {
  var generateGetterSetter = function(field, prototype) {
  var len = field.length;
  var lastChar = field[len - 1];
  var needsGetter = lastChar == '?' || lastChar == '=';
  var needsSetter = lastChar == '!' || lastChar == '=';
  if (needsGetter || needsSetter) field = field.substring(0, len - 1);
  if (needsGetter) {
    var getterString = "return this." + field + ";";
    prototype["get$" + field] = new Function(getterString);
  }
  if (needsSetter) {
    var setterString = "this." + field + " = v;";
    prototype["set$" + field] = new Function("v", setterString);
  }
  return field;
};
  for (var i = 0; i < fields.length; i++) {
    generateGetterSetter(fields[i], methods);
  }
  for (var method in methods) {
    $.dynamicFunction(method)[cls] = methods[method];
  }
};
$.defineProperty(Object.prototype, 'is$Element', function() { return false; });
$.defineProperty(Object.prototype, 'is$List', function() { return false; });
$.defineProperty(Object.prototype, 'is$Map', function() { return false; });
$.defineProperty(Object.prototype, 'is$JavaScriptIndexingBehavior', function() { return false; });
$.defineProperty(Object.prototype, 'is$Collection', function() { return false; });
$.defineProperty(Object.prototype, 'toString$0', function() { return $.toStringForNativeObject(this); });
$.$defineNativeClass('AbstractWorker', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
    return $._AbstractWorkerEventsImpl$(this);
  } else {
    return Object.prototype.get$on.call(this);
  }
 }
});

$.$defineNativeClass('HTMLAnchorElement', [], {
 toString$0: function() {
  return this.toString();
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('WebKitAnimationList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('HTMLAppletElement', ["width=", "object=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLAreaElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Attr', ["value="], {
});

$.$defineNativeClass('AudioBuffer', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('AudioContext', [], {
 get$on: function() {
  return $._AudioContextEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLAudioElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('AudioParam', ["value="], {
});

$.$defineNativeClass('HTMLBRElement', [], {
 clear$0: function() { return this.clear.$call$0(); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('BarInfo', ["visible?"], {
});

$.$defineNativeClass('HTMLBaseElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLBaseFontElement', ["color?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('BatteryManager', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._BatteryManagerEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLBodyElement', [], {
 get$on: function() {
  return $._BodyElementEventsImpl$(this);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLButtonElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('WebKitCSSMatrix', ["b="], {
 toString$0: function() {
  return this.toString();
 },
 scale$3: function(scaleX, scaleY, scaleZ) {
  return this.scale(scaleX,scaleY,scaleZ);
 },
 get$scale: function() { return new $.BoundClosure1(this, 'scale$3'); }
});

$.$defineNativeClass('CSSRuleList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('CSSStyleDeclaration', ["length?"], {
 set$width: function(value) {
  this.setProperty$3('width', value, '');
 },
 get$width: function() {
  return this.getPropertyValue$1('width');
 },
 get$transform: function() {
  return this.getPropertyValue$1($.S($._browserPrefix()) + 'transform');
 },
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.get$transform().$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 get$position: function() {
  return this.getPropertyValue$1('position');
 },
 get$opacity: function() {
  return this.getPropertyValue$1('opacity');
 },
 set$height: function(value) {
  this.setProperty$3('height', value, '');
 },
 get$height: function() {
  return this.getPropertyValue$1('height');
 },
 get$filter: function() {
  return this.getPropertyValue$1($.S($._browserPrefix()) + 'filter');
 },
 filter$1: function(arg0) { return this.get$filter().$call$1(arg0); },
 get$color: function() {
  return this.getPropertyValue$1('color');
 },
 get$clip: function() {
  return this.getPropertyValue$1('clip');
 },
 clip$0: function() { return this.get$clip().$call$0(); },
 get$clear: function() {
  return this.getPropertyValue$1('clear');
 },
 clear$0: function() { return this.get$clear().$call$0(); },
 setProperty$3: function(propertyName, value, priority) {
  return this.setProperty(propertyName,value,priority);
 },
 getPropertyValue$1: function(propertyName) {
  return this.getPropertyValue(propertyName);
 },
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('CSSValueList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('HTMLCanvasElement', ["width=", "height="], {
 getContext$1: function(contextId) {
  return this.getContext(contextId);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('CanvasRenderingContext2D', ["strokeStyle!", "lineWidth!", "lineJoin!", "lineCap!", "globalCompositeOperation!", "globalAlpha!", "fillStyle!"], {
 translate$2: function(tx, ty) {
  return this.translate(tx,ty);
 },
 transform$6: function(m11, m12, m21, m22, dx, dy) {
  return this.transform(m11,m12,m21,m22,dx,dy);
 },
 strokeRect$5: function(x, y, width, height, lineWidth) {
  return this.strokeRect(x,y,width,height,lineWidth);
 },
 strokeRect$4: function(x,y,width,height) {
  return this.strokeRect(x,y,width,height);
},
 stroke$0: function() {
  return this.stroke();
 },
 setTransform$6: function(m11, m12, m21, m22, dx, dy) {
  return this.setTransform(m11,m12,m21,m22,dx,dy);
 },
 scale$2: function(sx, sy) {
  return this.scale(sx,sy);
 },
 get$scale: function() { return new $.BoundClosure2(this, 'scale$2'); },
 save$0: function() {
  return this.save();
 },
 rotate$1: function(angle) {
  return this.rotate(angle);
 },
 restore$0: function() {
  return this.restore();
 },
 putImageData$7: function(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight) {
  return this.putImageData(imagedata,dx,dy,dirtyX,dirtyY,dirtyWidth,dirtyHeight);
 },
 putImageData$3: function(imagedata,dx,dy) {
  return this.putImageData(imagedata,dx,dy);
},
 moveTo$2: function(x, y) {
  return this.moveTo(x,y);
 },
 lineTo$2: function(x, y) {
  return this.lineTo(x,y);
 },
 getImageData$4: function(sx, sy, sw, sh) {
  return this.getImageData(sx,sy,sw,sh);
 },
 fillRect$4: function(x, y, width, height) {
  return this.fillRect(x,y,width,height);
 },
 fill$0: function() {
  return this.fill();
 },
 drawImage$9: function(canvas_OR_image_OR_video, sx_OR_x, sy_OR_y, sw_OR_width, height_OR_sh, dx, dy, dw, dh) {
  return this.drawImage(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y,sw_OR_width,height_OR_sh,dx,dy,dw,dh);
 },
 drawImage$3: function(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y) {
  return this.drawImage(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y);
},
 createPattern$2: function(canvas_OR_image, repetitionType) {
  return this.createPattern(canvas_OR_image,repetitionType);
 },
 closePath$0: function() {
  return this.closePath();
 },
 clip$0: function() {
  return this.clip();
 },
 clearRect$4: function(x, y, width, height) {
  return this.clearRect(x,y,width,height);
 },
 beginPath$0: function() {
  return this.beginPath();
 },
 arc$6: function(x, y, radius, startAngle, endAngle, anticlockwise) {
  return this.arc(x,y,radius,startAngle,endAngle,anticlockwise);
 }
});

$.$defineNativeClass('CharacterData', ["length?", "data?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('ClientRect', ["width?", "height?"], {
});

$.$defineNativeClass('ClientRectList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('CompositionEvent', ["data?"], {
});

_ConsoleImpl = (typeof console == 'undefined' ? {} : console);
$.$defineNativeClass('HTMLContentElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ConvolverNode', [], {
 normalize$0: function() { return this.normalize.$call$0(); }
});

$.$defineNativeClass('HTMLDListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('DOMApplicationCache', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._DOMApplicationCacheEventsImpl$(this);
 }
});

$.$defineNativeClass('DOMException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('DOMMimeTypeArray', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('DOMPlugin', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('DOMPluginArray', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('DOMSelection', [], {
 toString$0: function() {
  return this.toString();
 },
 empty$0: function() {
  return this.empty();
 }
});

$.$defineNativeClass('DOMSettableTokenList', ["value="], {
});

$.$defineNativeClass('DOMStringList', ["length?"], {
 contains$1: function(string) {
  return this.contains(string);
 },
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'String'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('DOMTokenList', ["length?"], {
 toString$0: function() {
  return this.toString();
 },
 remove$1: function(token) {
  return this.remove(token);
 },
 contains$1: function(token) {
  return this.contains(token);
 },
 add$1: function(token) {
  return this.add(token);
 },
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('DataTransferItemList', ["length?"], {
 clear$0: function() {
  return this.clear();
 },
 add$2: function(data_OR_file, type) {
  return this.add(data_OR_file,type);
 },
 add$1: function(data_OR_file) {
  return this.add(data_OR_file);
},
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('DedicatedWorkerContext', [], {
 postMessage$2: function(message, messagePorts) {
  return this.postMessage(message,messagePorts);
 },
 postMessage$1: function(message) {
  return this.postMessage(message);
},
 get$on: function() {
  return $._DedicatedWorkerContextEventsImpl$(this);
 }
});

$.$defineNativeClass('DeprecatedPeerConnection', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._DeprecatedPeerConnectionEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLDetailsElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDirectoryElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDivElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDocument', ["body?"], {
 get$on: function() {
  return $._DocumentEventsImpl$(this);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('DocumentFragment', [], {
 get$on: function() {
  return $._ElementEventsImpl$(this);
 },
 get$parent: function() {
  return;
 },
 get$$$dom_lastElementChild: function() {
  return $.last(this.get$elements());
 },
 get$$$dom_firstElementChild: function() {
  return this.get$elements().first$0();
 },
 get$id: function() {
  return '';
 },
 get$translate: function() {
  return false;
 },
 translate$2: function(arg0, arg1) { return this.get$translate().$call$2(arg0, arg1); },
 set$elements: function(value) {
  var copy = $.ListFactory_List$from(value);
  var elements = this.get$elements();
  $.clear(elements);
  $.addAll(elements, copy);
 },
 get$elements: function() {
  if (this._lib_elements == null) this._lib_elements = $.FilteredElementList$(this);
  return this._lib_elements;
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('Element', ["id?"], {
 get$$$dom_lastElementChild: function() {
  return this.lastElementChild;;
 },
 get$$$dom_firstElementChild: function() {
  return this.firstElementChild;;
 },
 translate$2: function(arg0, arg1) { return this.translate.$call$2(arg0, arg1); },
 get$$$dom_children: function() {
  return this.children;;
 },
 get$on: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
    return $._ElementEventsImpl$(this);
  } else {
    return Object.prototype.get$on.call(this);
  }
 },
 get$elements: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$elements')) {
    return $._ChildrenElementList$_wrap(this);
  } else {
    return Object.prototype.get$elements.call(this);
  }
 },
 set$elements: function(value) {
  if (Object.getPrototypeOf(this).hasOwnProperty('set$elements')) {
    var elements = this.get$elements();
  $.clear(elements);
  $.addAll(elements, value);
  } else {
    return Object.prototype.set$elements.call(this, value);
  }
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLEmbedElement', ["width=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Entry', [], {
 remove$2: function(successCallback, errorCallback) {
  return this.remove($.convertDartClosureToJS(successCallback, 0),$.convertDartClosureToJS(errorCallback, 1));
 },
 remove$1: function(successCallback) {
  successCallback = $.convertDartClosureToJS(successCallback, 0);
  return this.remove(successCallback);
},
 moveTo$4: function(parent, name, successCallback, errorCallback) {
  return this.moveTo(parent,name,$.convertDartClosureToJS(successCallback, 1),$.convertDartClosureToJS(errorCallback, 1));
 },
 moveTo$2: function(parent$,name$) {
  return this.moveTo(parent$,name$);
}
});

$.$defineNativeClass('EntryArray', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('EntryArraySync', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('EntrySync', [], {
 remove$0: function() {
  return this.remove();
 },
 moveTo$2: function(parent, name) {
  return this.moveTo(parent,name);
 }
});

$.$defineNativeClass('Event', [], {
 preventDefault$0: function() {
  return this.preventDefault();
 }
});

$.$defineNativeClass('EventException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('EventSource', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._EventSourceEventsImpl$(this);
 }
});

$.$defineNativeClass('EventTarget', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_removeEventListener$3')) {
    return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
  } else {
    return Object.prototype.$dom_removeEventListener$3.call(this, type, listener, useCapture);
  }
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_addEventListener$3')) {
    return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
  } else {
    return Object.prototype.$dom_addEventListener$3.call(this, type, listener, useCapture);
  }
 },
 get$on: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
    return $._EventsImpl$(this);
  } else {
    return Object.prototype.get$on.call(this);
  }
 }
});

$.$defineNativeClass('HTMLFieldSetElement', ["lib$_FieldSetElementImpl$elements?"], {
 get$elements: function() {
  return this.lib$_FieldSetElementImpl$elements;
 },
 set$elements: function(x) {
  this.lib$_FieldSetElementImpl$elements = x;
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('FileException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('FileList', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'File'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('FileReader', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._FileReaderEventsImpl$(this);
 }
});

$.$defineNativeClass('FileWriter', ["position?", "length?"], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 length$0: function() { return this.length.$call$0(); },
 get$on: function() {
  return $._FileWriterEventsImpl$(this);
 }
});

$.$defineNativeClass('FileWriterSync', ["position?", "length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('Float32Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'num'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Float64Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'num'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLFontElement', ["color?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLFormElement', ["length?"], {
 reset$0: function() {
  return this.reset();
 },
 length$0: function() { return this.length.$call$0(); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLFrameElement', ["width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLFrameSetElement', [], {
 get$on: function() {
  return $._FrameSetElementEventsImpl$(this);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('Gamepad', ["id?"], {
});

$.$defineNativeClass('GamepadList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('HTMLHRElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLAllCollection', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('HTMLCollection', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'Node'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLOptionsCollection', [], {
 remove$1: function(index) {
  return this.remove(index);
 },
 set$length: function(value) {
  this.length = value;;
 },
 get$length: function() {
  return this.length;;
 },
 length$0: function() { return this.get$length().$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLHeadElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLHeadingElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('History', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('HTMLHtmlElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('IDBCursor', ["key?"], {
});

$.$defineNativeClass('IDBCursorWithValue', ["value?"], {
});

$.$defineNativeClass('IDBDatabase', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._IDBDatabaseEventsImpl$(this);
 }
});

$.$defineNativeClass('IDBDatabaseException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('IDBObjectStore', [], {
 clear$0: function() {
  return this.clear();
 },
 add$2: function(value, key) {
  return this.add(value,key);
 },
 add$1: function(value) {
  return this.add(value);
}
});

$.$defineNativeClass('IDBRequest', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_removeEventListener$3')) {
    return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
  } else {
    return Object.prototype.$dom_removeEventListener$3.call(this, type, listener, useCapture);
  }
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_addEventListener$3')) {
    return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
  } else {
    return Object.prototype.$dom_addEventListener$3.call(this, type, listener, useCapture);
  }
 },
 get$on: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
    return $._IDBRequestEventsImpl$(this);
  } else {
    return Object.prototype.get$on.call(this);
  }
 }
});

$.$defineNativeClass('IDBTransaction', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._IDBTransactionEventsImpl$(this);
 }
});

$.$defineNativeClass('IDBVersionChangeRequest', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._IDBVersionChangeRequestEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLIFrameElement', ["width=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ImageData', ["width?", "height?", "data?"], {
});

$.$defineNativeClass('HTMLImageElement', ["y?", "x?", "width=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLInputElement', ["width=", "value=", "pattern?", "height="], {
 get$on: function() {
  return $._InputElementEventsImpl$(this);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('Int16Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'int'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Int32Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'int'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Int8Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'int'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('JavaScriptAudioNode', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._JavaScriptAudioNodeEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLKeygenElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLIElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLabelElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLegendElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLinkElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('LocalMediaStream', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 }
});

$.$defineNativeClass('Location', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('HTMLMapElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLMarqueeElement', ["width=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('MediaController', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 }
});

$.$defineNativeClass('HTMLMediaElement', [], {
 get$on: function() {
  return $._MediaElementEventsImpl$(this);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('MediaList', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'String'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('MediaStream', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_removeEventListener$3')) {
    return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
  } else {
    return Object.prototype.$dom_removeEventListener$3.call(this, type, listener, useCapture);
  }
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_addEventListener$3')) {
    return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
  } else {
    return Object.prototype.$dom_addEventListener$3.call(this, type, listener, useCapture);
  }
 },
 get$on: function() {
  return $._MediaStreamEventsImpl$(this);
 }
});

$.$defineNativeClass('MediaStreamList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('MediaStreamTrackList', ["length?"], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 remove$1: function(track) {
  return this.remove(track);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 add$1: function(track) {
  return this.add(track);
 },
 length$0: function() { return this.length.$call$0(); },
 get$on: function() {
  return $._MediaStreamTrackListEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLMenuElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('MessageEvent', ["ports?", "data?"], {
});

$.$defineNativeClass('MessagePort', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 postMessage$2: function(message, messagePorts) {
  return this.postMessage(message,messagePorts);
 },
 postMessage$1: function(message) {
  return this.postMessage(message);
},
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._MessagePortEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLMetaElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLMeterElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLModElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('MouseEvent', ["y?", "x?", "clientY?", "clientX?"], {
});

$.$defineNativeClass('NamedNodeMap', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'Node'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Navigator', ["userAgent?"], {
});

$.$defineNativeClass('Node', [], {
 $dom_replaceChild$2: function(newChild, oldChild) {
  return this.replaceChild(newChild,oldChild);
 },
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_removeChild$1: function(oldChild) {
  return this.removeChild(oldChild);
 },
 contains$1: function(other) {
  return this.contains(other);
 },
 $dom_appendChild$1: function(newChild) {
  return this.appendChild(newChild);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 set$text: function(value) {
  this.textContent = value;;
 },
 get$parent: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$parent')) {
    return this.parentNode;;
  } else {
    return Object.prototype.get$parent.call(this);
  }
 },
 get$$$dom_childNodes: function() {
  return this.childNodes;;
 },
 replaceWith$1: function(otherNode) {
  try {
    var parent$ = this.get$parent();
    parent$.$dom_replaceChild$2(otherNode, this);
  } catch (exception) {
    $.unwrapException(exception);
  }
  return this;
 },
 remove$0: function() {
  !(this.get$parent() == null) && this.get$parent().$dom_removeChild$1(this);
  return this;
 },
 get$nodes: function() {
  return $._ChildNodeListLazy$(this);
 }
});

$.$defineNativeClass('NodeIterator', [], {
 filter$1: function(arg0) { return this.filter.$call$1(arg0); }
});

$.$defineNativeClass('NodeList', ["length?"], {
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 getRange$2: function(start, rangeLength) {
  return $._NodeListWrapper$($._Lists_getRange(this, start, rangeLength, []));
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 get$first: function() {
  return this.operator$index$1(0);
 },
 first$0: function() { return this.get$first().$call$0(); },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._NodeListWrapper$($._Collections_filter(this, [], f));
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 operator$indexSet$2: function(index, value) {
  this._parent.$dom_replaceChild$2(value, this.operator$index$1(index));
 },
 clear$0: function() {
  this._parent.set$text('');
 },
 removeLast$0: function() {
  var result = this.last$0();
  !(result == null) && this._parent.$dom_removeChild$1(result);
  return result;
 },
 addAll$1: function(collection) {
  for (var t1 = $.iterator(collection), t2 = this._parent; t1.hasNext$0() === true; ) {
    t2.$dom_appendChild$1(t1.next$0());
  }
 },
 addLast$1: function(value) {
  this._parent.$dom_appendChild$1(value);
 },
 add$1: function(value) {
  this._parent.$dom_appendChild$1(value);
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'Node'}));
  return t1;
 },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Notification', ["tag?"], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._NotificationEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLOListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLObjectElement', ["width=", "height=", "data?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLOptGroupElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLOptionElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLOutputElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLParagraphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLParamElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('PeerConnection00', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._PeerConnection00EventsImpl$(this);
 }
});

$.$defineNativeClass('WebKitPoint', ["y=", "x="], {
});

$.$defineNativeClass('HTMLPreElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ProcessingInstruction', ["data?"], {
});

$.$defineNativeClass('HTMLProgressElement', ["value=", "position?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLQuoteElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('RadioNodeList', ["value="], {
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Range', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('RangeException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('SQLResultSetRowList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('SVGAElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAltGlyphDefElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAltGlyphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAltGlyphItemElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAngle', ["value="], {
});

$.$defineNativeClass('SVGAnimateColorElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimateElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimateMotionElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimateTransformElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimationElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGCircleElement', ["r?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGClipPathElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGComponentTransferFunctionElement', ["offset?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGCursorElement', ["y?", "x?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGDefsElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGDescElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGDocument', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGElement', [], {
 get$id: function() {
  return this.id;;
 },
 set$elements: function(value) {
  var elements = this.get$elements();
  $.clear(elements);
  $.addAll(elements, value);
 },
 get$elements: function() {
  return $.FilteredElementList$(this);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGElementInstance', [], {
 get$on: function() {
  return $._SVGElementInstanceEventsImpl$(this);
 }
});

$.$defineNativeClass('SVGElementInstanceList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('SVGEllipseElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('SVGFEBlendElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEColorMatrixElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEComponentTransferElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFECompositeElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEConvolveMatrixElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDiffuseLightingElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDisplacementMapElement', ["y?", "x?", "width?", "height?", "scale?"], {
 scale$1: function(arg0) { return this.scale.$call$1(arg0); },
 scale$2: function(arg0, arg1) { return this.scale.$call$2(arg0, arg1); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDistantLightElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDropShadowElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFloodElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncAElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncBElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncGElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncRElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEGaussianBlurElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEImageElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEMergeElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEMergeNodeElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEMorphologyElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEOffsetElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEPointLightElement', ["z?", "y?", "x?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFESpecularLightingElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFESpotLightElement', ["z?", "y?", "x?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFETileElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFETurbulenceElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFilterElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceFormatElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceNameElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceSrcElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceUriElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGForeignObjectElement', ["y?", "x?", "width?", "height?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGlyphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGlyphRefElement', ["y=", "x="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGradientElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGHKernElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGImageElement', ["y?", "x?", "width?", "height?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGLength', ["value="], {
});

$.$defineNativeClass('SVGLengthList', [], {
 clear$0: function() {
  return this.clear();
 }
});

$.$defineNativeClass('SVGLineElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGLinearGradientElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMPathElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMarkerElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMaskElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMatrix', ["b="], {
 translate$2: function(x, y) {
  return this.translate(x,y);
 },
 scale$1: function(scaleFactor) {
  return this.scale(scaleFactor);
 },
 get$scale: function() { return new $.BoundClosure0(this, 'scale$1'); },
 rotate$1: function(angle) {
  return this.rotate(angle);
 }
});

$.$defineNativeClass('SVGMetadataElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMissingGlyphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGNumber', ["value="], {
});

$.$defineNativeClass('SVGNumberList', [], {
 clear$0: function() {
  return this.clear();
 }
});

$.$defineNativeClass('SVGPathElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGPathSegArcAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegArcRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicSmoothAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicSmoothRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticSmoothAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticSmoothRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegLinetoAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegLinetoHorizontalAbs', ["x="], {
});

$.$defineNativeClass('SVGPathSegLinetoHorizontalRel', ["x="], {
});

$.$defineNativeClass('SVGPathSegLinetoRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegLinetoVerticalAbs', ["y="], {
});

$.$defineNativeClass('SVGPathSegLinetoVerticalRel', ["y="], {
});

$.$defineNativeClass('SVGPathSegList', [], {
 clear$0: function() {
  return this.clear();
 }
});

$.$defineNativeClass('SVGPathSegMovetoAbs', ["y=", "x="], {
});

$.$defineNativeClass('SVGPathSegMovetoRel', ["y=", "x="], {
});

$.$defineNativeClass('SVGPatternElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGPoint', ["y=", "x="], {
});

$.$defineNativeClass('SVGPointList', [], {
 clear$0: function() {
  return this.clear();
 }
});

$.$defineNativeClass('SVGPolygonElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGPolylineElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGRadialGradientElement', ["r?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGRect', ["y=", "x=", "width=", "height="], {
});

$.$defineNativeClass('SVGRectElement', ["y?", "x?", "width?", "height?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSVGElement', ["y?", "x?", "width?", "height?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGScriptElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSetElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGStopElement', ["offset?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGStringList', [], {
 clear$0: function() {
  return this.clear();
 }
});

$.$defineNativeClass('SVGStyleElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSwitchElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSymbolElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTRefElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTSpanElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextContentElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextPathElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextPositioningElement', ["y?", "x?"], {
 rotate$1: function(arg0) { return this.rotate.$call$1(arg0); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTitleElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTransformList', [], {
 clear$0: function() {
  return this.clear();
 }
});

$.$defineNativeClass('SVGUseElement', ["y?", "x?", "width?", "height?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGVKernElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGViewElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGViewSpec', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.$call$6(arg0, arg1, arg2, arg3, arg4, arg5); }
});

$.$defineNativeClass('Screen', ["width?", "height?"], {
});

$.$defineNativeClass('HTMLScriptElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ScriptProfileNode', ["visible?"], {
 children$0: function() {
  return this.children();
 },
 get$children: function() { return new $.BoundClosure(this, 'children$0'); }
});

$.$defineNativeClass('HTMLSelectElement', ["value=", "length="], {
 length$0: function() { return this.length.$call$0(); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLShadowElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ShadowRoot', [], {
 get$innerHTML: function() {
  return this.lib$_ShadowRootImpl$innerHTML;
 },
 set$innerHTML: function(x) {
  this.lib$_ShadowRootImpl$innerHTML = x;
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SharedWorkerContext', [], {
 get$on: function() {
  return $._SharedWorkerContextEventsImpl$(this);
 }
});

$.$defineNativeClass('HTMLSourceElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLSpanElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SpeechGrammarList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('SpeechInputResultList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('SpeechRecognition', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._SpeechRecognitionEventsImpl$(this);
 }
});

$.$defineNativeClass('SpeechRecognitionResult', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('SpeechRecognitionResultList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('Storage', [], {
 $dom_setItem$2: function(key, data) {
  return this.setItem(key,data);
 },
 $dom_removeItem$1: function(key) {
  return this.removeItem(key);
 },
 $dom_key$1: function(index) {
  return this.key(index);
 },
 $dom_getItem$1: function(key) {
  return this.getItem(key);
 },
 $dom_clear$0: function() {
  return this.clear();
 },
 get$$$dom_length: function() {
  return this.length;;
 },
 isEmpty$0: function() {
  return this.$dom_key$1(0) == null;
 },
 get$length: function() {
  return this.get$$$dom_length();
 },
 length$0: function() { return this.get$length().$call$0(); },
 getValues$0: function() {
  var values = [];
  this.forEach$1(new $._StorageImpl_getValues_anon(values));
  return values;
 },
 getKeys$0: function() {
  var keys = [];
  this.forEach$1(new $._StorageImpl_getKeys_anon(keys));
  return keys;
 },
 forEach$1: function(f) {
  for (var i = 0; true; ++i) {
    var key = this.$dom_key$1(i);
    if (key == null) return;
    f.$call$2(key, this.operator$index$1(key));
  }
 },
 clear$0: function() {
  return this.$dom_clear$0();
 },
 remove$1: function(key) {
  var value = this.operator$index$1(key);
  this.$dom_removeItem$1(key);
  return value;
 },
 operator$indexSet$2: function(key, value) {
  return this.$dom_setItem$2(key, value);
 },
 operator$index$1: function(key) {
  return this.$dom_getItem$1(key);
 },
 containsKey$1: function(key) {
  return !(this.$dom_getItem$1(key) == null);
 },
 is$Map: function() { return true; }
});

$.$defineNativeClass('StorageEvent', ["key?"], {
});

$.$defineNativeClass('HTMLStyleElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('StyleSheetList', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'StyleSheet'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLTableCaptionElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableCellElement', ["width=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableColElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableRowElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableSectionElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTextAreaElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('TextEvent', ["data?"], {
});

$.$defineNativeClass('TextMetrics', ["width?"], {
});

$.$defineNativeClass('TextTrack', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._TextTrackEventsImpl$(this);
 }
});

$.$defineNativeClass('TextTrackCue', ["text!", "position?", "id?"], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._TextTrackCueEventsImpl$(this);
 }
});

$.$defineNativeClass('TextTrackCueList', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('TextTrackList', ["length?"], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 length$0: function() { return this.length.$call$0(); },
 get$on: function() {
  return $._TextTrackListEventsImpl$(this);
 }
});

$.$defineNativeClass('TimeRanges', ["length?"], {
 length$0: function() { return this.length.$call$0(); }
});

$.$defineNativeClass('HTMLTitleElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Touch', ["pageY?", "pageX?", "clientY?", "clientX?"], {
});

$.$defineNativeClass('TouchEvent', ["touches?"], {
});

$.$defineNativeClass('TouchList', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'Touch'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot assign element of immutable List.'));
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLTrackElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('TreeWalker', [], {
 filter$1: function(arg0) { return this.filter.$call$1(arg0); }
});

$.$defineNativeClass('UIEvent', ["pageY?", "pageX?"], {
});

$.$defineNativeClass('HTMLUListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Uint16Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'int'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Uint32Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'int'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Uint8Array', ["length?"], {
 getRange$2: function(start, rangeLength) {
  return $._Lists_getRange(this, start, rangeLength, []);
 },
 removeRange$2: function(start, rangeLength) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));
 },
 removeLast$0: function() {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot removeLast on immutable List.'));
 },
 last$0: function() {
  return this.operator$index$1($.sub($.get$length(this), 1));
 },
 indexOf$2: function(element, start) {
  return $._Lists_indexOf(this, element, start, $.get$length(this));
 },
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 sort$1: function(compare) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot sort immutable List.'));
 },
 isEmpty$0: function() {
  return $.eq($.get$length(this), 0);
 },
 filter$1: function(f) {
  return $._Collections_filter(this, [], f);
 },
 forEach$1: function(f) {
  return $._Collections_forEach(this, f);
 },
 addAll$1: function(collection) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 addLast$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 add$1: function(value) {
  throw $.captureStackTrace($.UnsupportedOperationException$('Cannot add to immutable List.'));
 },
 iterator$0: function() {
  var t1 = $._FixedSizeListIterator$(this);
  $.setRuntimeTypeInfo(t1, ({T: 'int'}));
  return t1;
 },
 operator$indexSet$2: function(index, value) {
  this[index] = value;
 },
 operator$index$1: function(index) {
  return this[index];;
 },
 length$0: function() { return this.length.$call$0(); },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Uint8ClampedArray', [], {
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLUnknownElement', [], {
 noSuchMethod$2: function(name$, args) {
  if ($.dynamicUnknownElementDispatcher == null) throw $.captureStackTrace($.NoSuchMethodException$(this, name$, args, null));
  return $.dynamicUnknownElementDispatcher.$call$3(this, name$, args);
 },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLVideoElement', ["width=", "height="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('WebGLRenderingContext', [], {
 lineWidth$1: function(width) {
  return this.lineWidth(width);
 }
});

$.$defineNativeClass('WebSocket', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._WebSocketEventsImpl$(this);
 }
});

$.$defineNativeClass('DOMWindow', ["parent?", "navigator?", "length?", "innerWidth?", "innerHeight?"], {
 setTimeout$2: function(handler, timeout) {
  return this.setTimeout($.convertDartClosureToJS(handler, 0),timeout);
 },
 setInterval$2: function(handler, timeout) {
  return this.setInterval($.convertDartClosureToJS(handler, 0),timeout);
 },
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 moveTo$2: function(x, y) {
  return this.moveTo(x,y);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 length$0: function() { return this.length.$call$0(); },
 get$on: function() {
  return $._WindowEventsImpl$(this);
 }
});

$.$defineNativeClass('Worker', [], {
 postMessage$2: function(message, messagePorts) {
  return this.postMessage(message,messagePorts);
 },
 postMessage$1: function(message) {
  return this.postMessage(message);
},
 get$on: function() {
  return $._WorkerEventsImpl$(this);
 }
});

$.$defineNativeClass('WorkerContext', ["navigator?"], {
 setTimeout$2: function(handler, timeout) {
  return this.setTimeout($.convertDartClosureToJS(handler, 0),timeout);
 },
 setInterval$2: function(handler, timeout) {
  return this.setInterval($.convertDartClosureToJS(handler, 0),timeout);
 },
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
    return $._WorkerContextEventsImpl$(this);
  } else {
    return Object.prototype.get$on.call(this);
  }
 }
});

$.$defineNativeClass('WorkerLocation', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('WorkerNavigator', ["userAgent?"], {
});

$.$defineNativeClass('XMLHttpRequest', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._XMLHttpRequestEventsImpl$(this);
 }
});

$.$defineNativeClass('XMLHttpRequestException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('XMLHttpRequestProgressEvent', ["position?"], {
});

$.$defineNativeClass('XMLHttpRequestUpload', [], {
 $dom_removeEventListener$3: function(type, listener, useCapture) {
  return this.removeEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 $dom_addEventListener$3: function(type, listener, useCapture) {
  return this.addEventListener(type,$.convertDartClosureToJS(listener, 1),useCapture);
 },
 get$on: function() {
  return $._XMLHttpRequestUploadEventsImpl$(this);
 }
});

$.$defineNativeClass('XPathException', [], {
 toString$0: function() {
  return this.toString();
 }
});

$.$defineNativeClass('XSLTProcessor', [], {
 reset$0: function() {
  return this.reset();
 }
});

$.$defineNativeClass('IDBOpenDBRequest', [], {
 get$on: function() {
  return $._IDBOpenDBRequestEventsImpl$(this);
 }
});

$.$defineNativeClass('DOMWindow', [], {
 setTimeout$2: function(handler, timeout) {
  return this.setTimeout($.convertDartClosureToJS(handler, 0),timeout);
 }
});

$.$defineNativeClass('Worker', [], {
 postMessage$1: function(msg) {
  return this.postMessage(msg);;
 },
 get$id: function() {
  return this.id;;
 }
});

// 323 dynamic classes.
// 368 classes
// 31 !leaf
(function(){
  var v0/*class(_SVGTextPositioningElementImpl)*/ = 'SVGTextPositioningElement|SVGTextElement|SVGTSpanElement|SVGTRefElement|SVGAltGlyphElement|SVGTextElement|SVGTSpanElement|SVGTRefElement|SVGAltGlyphElement';
  var v1/*class(_MouseEventImpl)*/ = 'MouseEvent|WheelEvent|WheelEvent';
  var v2/*class(_SVGTextContentElementImpl)*/ = [v0/*class(_SVGTextPositioningElementImpl)*/,v0/*class(_SVGTextPositioningElementImpl)*/,'SVGTextContentElement|SVGTextPathElement|SVGTextPathElement'].join('|');
  var v3/*class(_SVGGradientElementImpl)*/ = 'SVGGradientElement|SVGRadialGradientElement|SVGLinearGradientElement|SVGRadialGradientElement|SVGLinearGradientElement';
  var v4/*class(_SVGComponentTransferFunctionElementImpl)*/ = 'SVGComponentTransferFunctionElement|SVGFEFuncRElement|SVGFEFuncGElement|SVGFEFuncBElement|SVGFEFuncAElement|SVGFEFuncRElement|SVGFEFuncGElement|SVGFEFuncBElement|SVGFEFuncAElement';
  var v5/*class(_SVGAnimationElementImpl)*/ = 'SVGAnimationElement|SVGSetElement|SVGAnimateTransformElement|SVGAnimateMotionElement|SVGAnimateElement|SVGAnimateColorElement|SVGSetElement|SVGAnimateTransformElement|SVGAnimateMotionElement|SVGAnimateElement|SVGAnimateColorElement';
  var v6/*class(_SVGElementImpl)*/ = [v2/*class(_SVGTextContentElementImpl)*/,v3/*class(_SVGGradientElementImpl)*/,v4/*class(_SVGComponentTransferFunctionElementImpl)*/,v5/*class(_SVGAnimationElementImpl)*/,v2/*class(_SVGTextContentElementImpl)*/,v3/*class(_SVGGradientElementImpl)*/,v4/*class(_SVGComponentTransferFunctionElementImpl)*/,v5/*class(_SVGAnimationElementImpl)*/,'SVGElement|SVGViewElement|SVGVKernElement|SVGUseElement|SVGTitleElement|SVGSymbolElement|SVGSwitchElement|SVGStyleElement|SVGStopElement|SVGScriptElement|SVGSVGElement|SVGRectElement|SVGPolylineElement|SVGPolygonElement|SVGPatternElement|SVGPathElement|SVGMissingGlyphElement|SVGMetadataElement|SVGMaskElement|SVGMarkerElement|SVGMPathElement|SVGLineElement|SVGImageElement|SVGHKernElement|SVGGlyphRefElement|SVGGlyphElement|SVGGElement|SVGForeignObjectElement|SVGFontFaceUriElement|SVGFontFaceSrcElement|SVGFontFaceNameElement|SVGFontFaceFormatElement|SVGFontFaceElement|SVGFontElement|SVGFilterElement|SVGFETurbulenceElement|SVGFETileElement|SVGFESpotLightElement|SVGFESpecularLightingElement|SVGFEPointLightElement|SVGFEOffsetElement|SVGFEMorphologyElement|SVGFEMergeNodeElement|SVGFEMergeElement|SVGFEImageElement|SVGFEGaussianBlurElement|SVGFEFloodElement|SVGFEDropShadowElement|SVGFEDistantLightElement|SVGFEDisplacementMapElement|SVGFEDiffuseLightingElement|SVGFEConvolveMatrixElement|SVGFECompositeElement|SVGFEComponentTransferElement|SVGFEColorMatrixElement|SVGFEBlendElement|SVGEllipseElement|SVGDescElement|SVGDefsElement|SVGCursorElement|SVGClipPathElement|SVGCircleElement|SVGAltGlyphItemElement|SVGAltGlyphDefElement|SVGAElement|SVGViewElement|SVGVKernElement|SVGUseElement|SVGTitleElement|SVGSymbolElement|SVGSwitchElement|SVGStyleElement|SVGStopElement|SVGScriptElement|SVGSVGElement|SVGRectElement|SVGPolylineElement|SVGPolygonElement|SVGPatternElement|SVGPathElement|SVGMissingGlyphElement|SVGMetadataElement|SVGMaskElement|SVGMarkerElement|SVGMPathElement|SVGLineElement|SVGImageElement|SVGHKernElement|SVGGlyphRefElement|SVGGlyphElement|SVGGElement|SVGForeignObjectElement|SVGFontFaceUriElement|SVGFontFaceSrcElement|SVGFontFaceNameElement|SVGFontFaceFormatElement|SVGFontFaceElement|SVGFontElement|SVGFilterElement|SVGFETurbulenceElement|SVGFETileElement|SVGFESpotLightElement|SVGFESpecularLightingElement|SVGFEPointLightElement|SVGFEOffsetElement|SVGFEMorphologyElement|SVGFEMergeNodeElement|SVGFEMergeElement|SVGFEImageElement|SVGFEGaussianBlurElement|SVGFEFloodElement|SVGFEDropShadowElement|SVGFEDistantLightElement|SVGFEDisplacementMapElement|SVGFEDiffuseLightingElement|SVGFEConvolveMatrixElement|SVGFECompositeElement|SVGFEComponentTransferElement|SVGFEColorMatrixElement|SVGFEBlendElement|SVGEllipseElement|SVGDescElement|SVGDefsElement|SVGCursorElement|SVGClipPathElement|SVGCircleElement|SVGAltGlyphItemElement|SVGAltGlyphDefElement|SVGAElement'].join('|');
  var v7/*class(_MediaElementImpl)*/ = 'HTMLMediaElement|HTMLVideoElement|HTMLAudioElement|HTMLVideoElement|HTMLAudioElement';
  var v8/*class(_UIEventImpl)*/ = [v1/*class(_MouseEventImpl)*/,v1/*class(_MouseEventImpl)*/,'UIEvent|TouchEvent|TextEvent|SVGZoomEvent|KeyboardEvent|CompositionEvent|TouchEvent|TextEvent|SVGZoomEvent|KeyboardEvent|CompositionEvent'].join('|');
  var v9/*class(_ElementImpl)*/ = [v6/*class(_SVGElementImpl)*/,v7/*class(_MediaElementImpl)*/,v6/*class(_SVGElementImpl)*/,v7/*class(_MediaElementImpl)*/,'Element|HTMLUnknownElement|HTMLUListElement|HTMLTrackElement|HTMLTitleElement|HTMLTextAreaElement|HTMLTableSectionElement|HTMLTableRowElement|HTMLTableElement|HTMLTableColElement|HTMLTableCellElement|HTMLTableCaptionElement|HTMLStyleElement|HTMLSpanElement|HTMLSourceElement|HTMLShadowElement|HTMLSelectElement|HTMLScriptElement|HTMLQuoteElement|HTMLProgressElement|HTMLPreElement|HTMLParamElement|HTMLParagraphElement|HTMLOutputElement|HTMLOptionElement|HTMLOptGroupElement|HTMLObjectElement|HTMLOListElement|HTMLModElement|HTMLMeterElement|HTMLMetaElement|HTMLMenuElement|HTMLMarqueeElement|HTMLMapElement|HTMLLinkElement|HTMLLegendElement|HTMLLabelElement|HTMLLIElement|HTMLKeygenElement|HTMLInputElement|HTMLImageElement|HTMLIFrameElement|HTMLHtmlElement|HTMLHeadingElement|HTMLHeadElement|HTMLHRElement|HTMLFrameSetElement|HTMLFrameElement|HTMLFormElement|HTMLFontElement|HTMLFieldSetElement|HTMLEmbedElement|HTMLDivElement|HTMLDirectoryElement|HTMLDetailsElement|HTMLDListElement|HTMLContentElement|HTMLCanvasElement|HTMLButtonElement|HTMLBodyElement|HTMLBaseFontElement|HTMLBaseElement|HTMLBRElement|HTMLAreaElement|HTMLAppletElement|HTMLAnchorElement|HTMLElement|HTMLUnknownElement|HTMLUListElement|HTMLTrackElement|HTMLTitleElement|HTMLTextAreaElement|HTMLTableSectionElement|HTMLTableRowElement|HTMLTableElement|HTMLTableColElement|HTMLTableCellElement|HTMLTableCaptionElement|HTMLStyleElement|HTMLSpanElement|HTMLSourceElement|HTMLShadowElement|HTMLSelectElement|HTMLScriptElement|HTMLQuoteElement|HTMLProgressElement|HTMLPreElement|HTMLParamElement|HTMLParagraphElement|HTMLOutputElement|HTMLOptionElement|HTMLOptGroupElement|HTMLObjectElement|HTMLOListElement|HTMLModElement|HTMLMeterElement|HTMLMetaElement|HTMLMenuElement|HTMLMarqueeElement|HTMLMapElement|HTMLLinkElement|HTMLLegendElement|HTMLLabelElement|HTMLLIElement|HTMLKeygenElement|HTMLInputElement|HTMLImageElement|HTMLIFrameElement|HTMLHtmlElement|HTMLHeadingElement|HTMLHeadElement|HTMLHRElement|HTMLFrameSetElement|HTMLFrameElement|HTMLFormElement|HTMLFontElement|HTMLFieldSetElement|HTMLEmbedElement|HTMLDivElement|HTMLDirectoryElement|HTMLDetailsElement|HTMLDListElement|HTMLContentElement|HTMLCanvasElement|HTMLButtonElement|HTMLBodyElement|HTMLBaseFontElement|HTMLBaseElement|HTMLBRElement|HTMLAreaElement|HTMLAppletElement|HTMLAnchorElement|HTMLElement'].join('|');
  var v10/*class(_DocumentFragmentImpl)*/ = 'DocumentFragment|ShadowRoot|ShadowRoot';
  var v11/*class(_DocumentImpl)*/ = 'HTMLDocument|SVGDocument|SVGDocument';
  var v12/*class(_CharacterDataImpl)*/ = 'CharacterData|Text|CDATASection|CDATASection|Comment|Text|CDATASection|CDATASection|Comment';
  var v13/*class(_WorkerContextImpl)*/ = 'WorkerContext|SharedWorkerContext|DedicatedWorkerContext|SharedWorkerContext|DedicatedWorkerContext';
  var v14/*class(_NodeImpl)*/ = [v9/*class(_ElementImpl)*/,v10/*class(_DocumentFragmentImpl)*/,v11/*class(_DocumentImpl)*/,v12/*class(_CharacterDataImpl)*/,v9/*class(_ElementImpl)*/,v10/*class(_DocumentFragmentImpl)*/,v11/*class(_DocumentImpl)*/,v12/*class(_CharacterDataImpl)*/,'Node|ProcessingInstruction|Notation|EntityReference|Entity|DocumentType|Attr|ProcessingInstruction|Notation|EntityReference|Entity|DocumentType|Attr'].join('|');
  var v15/*class(_MediaStreamImpl)*/ = 'MediaStream|LocalMediaStream|LocalMediaStream';
  var v16/*class(_IDBRequestImpl)*/ = 'IDBRequest|IDBOpenDBRequest|IDBVersionChangeRequest|IDBOpenDBRequest|IDBVersionChangeRequest';
  var v17/*class(_AbstractWorkerImpl)*/ = 'AbstractWorker|Worker|SharedWorker|Worker|SharedWorker';
  var table = [
    // [dynamic-dispatch-tag, tags of classes implementing dynamic-dispatch-tag]
    ['SVGTextPositioningElement', v0/*class(_SVGTextPositioningElementImpl)*/],
    ['SVGTextContentElement', v2/*class(_SVGTextContentElementImpl)*/],
    ['MouseEvent', v1/*class(_MouseEventImpl)*/],
    ['UIEvent', v8/*class(_UIEventImpl)*/],
    ['AbstractWorker', v17/*class(_AbstractWorkerImpl)*/],
    ['Uint8Array', 'Uint8Array|Uint8ClampedArray|Uint8ClampedArray'],
    ['AudioParam', 'AudioParam|AudioGain|AudioGain'],
    ['WorkerContext', v13/*class(_WorkerContextImpl)*/],
    ['CSSValueList', 'CSSValueList|WebKitCSSFilterValue|WebKitCSSTransformValue|WebKitCSSFilterValue|WebKitCSSTransformValue'],
    ['CharacterData', v12/*class(_CharacterDataImpl)*/],
    ['DOMTokenList', 'DOMTokenList|DOMSettableTokenList|DOMSettableTokenList'],
    ['HTMLDocument', v11/*class(_DocumentImpl)*/],
    ['DocumentFragment', v10/*class(_DocumentFragmentImpl)*/],
    ['SVGGradientElement', v3/*class(_SVGGradientElementImpl)*/],
    ['SVGComponentTransferFunctionElement', v4/*class(_SVGComponentTransferFunctionElementImpl)*/],
    ['SVGAnimationElement', v5/*class(_SVGAnimationElementImpl)*/],
    ['SVGElement', v6/*class(_SVGElementImpl)*/],
    ['HTMLMediaElement', v7/*class(_MediaElementImpl)*/],
    ['Element', v9/*class(_ElementImpl)*/],
    ['Entry', 'Entry|FileEntry|DirectoryEntry|FileEntry|DirectoryEntry'],
    ['EntrySync', 'EntrySync|FileEntrySync|DirectoryEntrySync|FileEntrySync|DirectoryEntrySync'],
    ['Event', [v8/*class(_UIEventImpl)*/,v8/*class(_UIEventImpl)*/,'Event|WebGLContextEvent|WebKitTransitionEvent|TrackEvent|StorageEvent|SpeechRecognitionEvent|SpeechRecognitionError|SpeechInputEvent|ProgressEvent|XMLHttpRequestProgressEvent|XMLHttpRequestProgressEvent|PopStateEvent|PageTransitionEvent|OverflowEvent|OfflineAudioCompletionEvent|MutationEvent|MessageEvent|MediaStreamTrackEvent|MediaStreamEvent|MediaKeyEvent|IDBVersionChangeEvent|HashChangeEvent|ErrorEvent|DeviceOrientationEvent|DeviceMotionEvent|CustomEvent|CloseEvent|BeforeLoadEvent|AudioProcessingEvent|WebKitAnimationEvent|WebGLContextEvent|WebKitTransitionEvent|TrackEvent|StorageEvent|SpeechRecognitionEvent|SpeechRecognitionError|SpeechInputEvent|ProgressEvent|XMLHttpRequestProgressEvent|XMLHttpRequestProgressEvent|PopStateEvent|PageTransitionEvent|OverflowEvent|OfflineAudioCompletionEvent|MutationEvent|MessageEvent|MediaStreamTrackEvent|MediaStreamEvent|MediaKeyEvent|IDBVersionChangeEvent|HashChangeEvent|ErrorEvent|DeviceOrientationEvent|DeviceMotionEvent|CustomEvent|CloseEvent|BeforeLoadEvent|AudioProcessingEvent|WebKitAnimationEvent'].join('|')],
    ['Node', v14/*class(_NodeImpl)*/],
    ['MediaStream', v15/*class(_MediaStreamImpl)*/],
    ['IDBRequest', v16/*class(_IDBRequestImpl)*/],
    ['EventTarget', [v13/*class(_WorkerContextImpl)*/,v14/*class(_NodeImpl)*/,v15/*class(_MediaStreamImpl)*/,v16/*class(_IDBRequestImpl)*/,v17/*class(_AbstractWorkerImpl)*/,v13/*class(_WorkerContextImpl)*/,v14/*class(_NodeImpl)*/,v15/*class(_MediaStreamImpl)*/,v16/*class(_IDBRequestImpl)*/,v17/*class(_AbstractWorkerImpl)*/,'EventTarget|XMLHttpRequestUpload|XMLHttpRequest|DOMWindow|WebSocket|TextTrackList|TextTrackCue|TextTrack|SpeechRecognition|Performance|PeerConnection00|Notification|MessagePort|MediaStreamTrackList|MediaController|IDBTransaction|IDBDatabase|FileWriter|FileReader|EventSource|DeprecatedPeerConnection|DOMApplicationCache|BatteryManager|AudioContext|XMLHttpRequestUpload|XMLHttpRequest|DOMWindow|WebSocket|TextTrackList|TextTrackCue|TextTrack|SpeechRecognition|Performance|PeerConnection00|Notification|MessagePort|MediaStreamTrackList|MediaController|IDBTransaction|IDBDatabase|FileWriter|FileReader|EventSource|DeprecatedPeerConnection|DOMApplicationCache|BatteryManager|AudioContext'].join('|')],
    ['HTMLCollection', 'HTMLCollection|HTMLOptionsCollection|HTMLOptionsCollection'],
    ['IDBCursor', 'IDBCursor|IDBCursorWithValue|IDBCursorWithValue'],
    ['NodeList', 'NodeList|RadioNodeList|RadioNodeList']];
$.dynamicSetMetadata(table);
})();

var $globalThis = $;
var $globalState;
var $globals;
var $isWorker;
var $supportsWorkers;
var $thisScriptUrl;
function $static_init(){};

function $initGlobals(context) {
  context.isolateStatics = new Isolate();
}
function $setGlobals(context) {
  $ = context.isolateStatics;
  $globalThis = $;
}
$.main.$call$0 = $.main
if (typeof document != 'undefined' && document.readyState != 'complete') {
  document.addEventListener('readystatechange', function () {
    if (document.readyState == 'complete') {
      $.startRootIsolate($.main);
    }
  }, false);
} else {
  $.startRootIsolate($.main);
}
function init() {
Isolate.$isolateProperties = {};
Isolate.$defineClass = function(cls, fields, prototype) {
  var generateGetterSetter = function(field, prototype) {
  var len = field.length;
  var lastChar = field[len - 1];
  var needsGetter = lastChar == '?' || lastChar == '=';
  var needsSetter = lastChar == '!' || lastChar == '=';
  if (needsGetter || needsSetter) field = field.substring(0, len - 1);
  if (needsGetter) {
    var getterString = "return this." + field + ";";
    prototype["get$" + field] = new Function(getterString);
  }
  if (needsSetter) {
    var setterString = "this." + field + " = v;";
    prototype["set$" + field] = new Function("v", setterString);
  }
  return field;
};
  var constructor;
  if (typeof fields == 'function') {
    constructor = fields;
  } else {
    var str = "function " + cls + "(";
    var body = "";
    for (var i = 0; i < fields.length; i++) {
      if (i != 0) str += ", ";
      var field = fields[i];
      field = generateGetterSetter(field, prototype);
      str += field;
      body += "this." + field + " = " + field + ";\n";
    }
    str += ") {" + body + "}\n";
    str += "return " + cls + ";";
    constructor = new Function(str)();
  }
  constructor.prototype = prototype;
  return constructor;
};
var supportsProto = false;
var tmp = Isolate.$defineClass('c', ['f?'], {}).prototype;
if (tmp.__proto__) {
  tmp.__proto__ = {};
  if (typeof tmp.get$f !== "undefined") supportsProto = true;
}
Isolate.$pendingClasses = {};
Isolate.$finishClasses = function(collectedClasses) {
  for (var cls in collectedClasses) {
    if (Object.prototype.hasOwnProperty.call(collectedClasses, cls)) {
      var desc = collectedClasses[cls];
      Isolate.$isolateProperties[cls] = Isolate.$defineClass(cls, desc[''], desc);
      if (desc['super'] !== "") Isolate.$pendingClasses[cls] = desc['super'];
    }
  }
  var pendingClasses = Isolate.$pendingClasses;
  Isolate.$pendingClasses = {};
  var finishedClasses = {};
  function finishClass(cls) {
    if (finishedClasses[cls]) return;
    finishedClasses[cls] = true;
    var superclass = pendingClasses[cls];
    if (!superclass) return;
    finishClass(superclass);
    var constructor = Isolate.$isolateProperties[cls];
    var superConstructor = Isolate.$isolateProperties[superclass];
    var prototype = constructor.prototype;
    if (supportsProto) {
      prototype.__proto__ = superConstructor.prototype;
      prototype.constructor = constructor;
    } else {
      function tmp() {};
      tmp.prototype = superConstructor.prototype;
      var newPrototype = new tmp();
      constructor.prototype = newPrototype;
      newPrototype.constructor = constructor;
      var hasOwnProperty = Object.prototype.hasOwnProperty;
      for (var member in prototype) {
        if (member == '' || member == 'super') continue;
        if (hasOwnProperty.call(prototype, member)) {
          newPrototype[member] = prototype[member];
        }
      }
    }
  }
  for (var cls in pendingClasses) finishClass(cls);
};
Isolate.$finishIsolateConstructor = function(oldIsolate) {
  var isolateProperties = oldIsolate.$isolateProperties;
  var isolatePrototype = oldIsolate.prototype;
  var str = "{\n";
  str += "var properties = Isolate.$isolateProperties;\n";
  for (var staticName in isolateProperties) {
    if (Object.prototype.hasOwnProperty.call(isolateProperties, staticName)) {
      str += "this." + staticName + "= properties." + staticName + ";\n";
    }
  }
  str += "}\n";
  var newIsolate = new Function(str);
  newIsolate.prototype = isolatePrototype;
  isolatePrototype.constructor = newIsolate;
  newIsolate.$isolateProperties = isolateProperties;
  return newIsolate;
};
}
