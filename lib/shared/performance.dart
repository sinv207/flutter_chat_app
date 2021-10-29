import 'dart:developer' as developer;

class Performance {
  static const String name = 'Perf';
  final Map<String, int> _profile = Map();

  ///
  /// Trace time
  ///
  void time(String task) {
    try {
      final curr = _profile[task];
      // already exists
      if (curr != null) {
        // return print('Perf - \'$task\' already exists');
      }
      _profile[task] = DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      print(e);
    }
  }

  ///
  /// Calculate and log time
  ///
  void timeEnd(String task) {
    try {
      final prev = _profile[task];
      // already exists
      if (prev != null) {
        final diff = DateTime.now().millisecondsSinceEpoch - prev;
        _profile.remove(task);
        return developer.log('\'$task\': $diff ms', name: name);
      }
      // return print('Perf - \'$task\' does not exist');
    } catch (e) {
      print(e);
    }
  }

  /// Singleton pattern
  static final Performance _performance = Performance._internal();

  factory Performance() {
    return _performance;
  }

  Performance._internal();
}
