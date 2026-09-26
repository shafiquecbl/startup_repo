import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final class ConnectivityService extends GetxService with WidgetsBindingObserver {
  final InternetConnection _internetConnection = InternetConnection();

  final ValueNotifier<InternetStatus?> _status = ValueNotifier<InternetStatus?>(null);
  ValueListenable<InternetStatus?> get status => _status;

  bool get isOnline => _status.value == InternetStatus.connected;

  StreamSubscription<InternetStatus>? _internetSubscription;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _internetSubscription = _internetConnection.onStatusChange.listen(
      (InternetStatus status) => _status.value = status,
      onError: (Object _, StackTrace _) => _status.value = InternetStatus.disconnected,
    );
  }

  Future<void> retry() async {
    _status.value = await _internetConnection.internetStatus;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(retry());
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_internetSubscription?.cancel());
    _status.dispose();
    super.onClose();
  }
}
