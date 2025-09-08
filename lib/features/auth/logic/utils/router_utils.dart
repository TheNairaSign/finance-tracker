import 'dart:async';
import 'package:flutter/foundation.dart';

/// Wraps a Stream into a Listenable so GoRouter can refresh when the stream emits
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    if (kDebugMode) {
      print('GoRouterRefreshStream: $stream');
    }
    notifyListeners(); // trigger immediately
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
