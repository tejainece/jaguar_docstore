part of jaguar_docstore.base;

class _Statics {
  static Stopwatch _stopwatch;
  static startStopwatch() => _stopwatch = new Stopwatch()..start();
  static stopStopwatch() => _stopwatch.stop();
  static Duration getElapsedTime() {
    _stopwatch.stop();
    return new Duration(milliseconds: _stopwatch.elapsedMilliseconds);
  }

  static int _current_increment = new Random().nextInt(0xFFFFFFFF);
  static int get nextIncrement {
    return _current_increment++;
  }

  static int _requestId;
  static int get nextRequestId {
    if (_requestId == null) {
      _requestId = 1;
    }
    return ++_requestId;
  }

  static List<int> _maxBits;
  static int MaxBits(int bits) {
    if (_maxBits == null) {
      _maxBits = new List<int>(65);
      _maxBits[0] = 0;
      for (var i = 1; i < 65; i++) {
        _maxBits[i] = (2 << i - 1);
      }
    }
    return _maxBits[bits];
  }

  /// Returns a 32-bit random number
  static final int getRandomId = new Random().nextInt(0xFFFFFFFF);

  static final Map<String, List<int>> keys = new Map<String, List<int>>();
  static getKeyUtf8(String key) {
    if (!keys.containsKey(key)) {
      keys[key] = UTF8.encode(key);
    }
    return keys[key];
  }
}

class Timestamp {
  int seconds;

  int increment;

  Timestamp([this.seconds, this.increment]) {
    if (seconds == null) {
      seconds = (new DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
    }
    if (increment == null) {
      increment = _Statics.nextIncrement;
    }
  }

  String toString() => "Timestamp($seconds, $increment)";
}

class Id {
  final String id;

  /// Const constructor that can be used to create const Ids
  const Id.make(this.id);

  factory Id.fromSeconds(int seconds) {
    final String id = createId(seconds);
    return new Id.make(id);
  }

  factory Id() {
    int seconds = new Timestamp(null, 0).seconds;
    return new Id.fromSeconds(seconds);
  }

  factory Id.fromHexString(String hexString) {
    if (hexString.length != 24 || !_objectIdMatcher.everyOf(hexString)) {
      throw new ArgumentError(
          'Expected hexadecimal string with length of 24, got $hexString');
    }
    return new Id.make(hexString);
  }

  static Id get create => new Id();

  static Id parse(String hexString) => new Id.fromHexString(hexString);

  static String createId(int seconds) {
    getOctet(int value) {
      String res = value.toRadixString(16);
      while (res.length < 8) {
        res = '0$res';
      }
      return res;
    }

    String s =
        '${getOctet(seconds)}${getOctet(_Statics.getRandomId)}${getOctet(_Statics.nextIncrement)}';
    return s;
  }

  int get hashCode => id.hashCode;

  bool operator ==(other) => other is Id && id == other.id;

  String toString() => 'Id("$id")';

  String toJson() => id;

  // Equivalent to mongo shell's "getTimestamp".
  DateTime get dateTime => new DateTime.fromMillisecondsSinceEpoch(
      int.parse(id.substring(0, 8), radix: 16) * 1000);

  static final _objectIdMatcher =
      new CharMatcher.inRange('a', 'f') | new CharMatcher.digit();
}
