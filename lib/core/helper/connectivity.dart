import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../imports.dart';

class ConnectivityService {
  static Future<bool> checkAndNotify() async {
    if (!await isConnected()) {
      showOfflineDialog();
      return false;
    }
    return true;
  }

  static void showOfflineDialog() {
    SmartDialog.show(
      alignment: Alignment.topCenter,
      keepSingle: true,
      builder: (_) => Material(
        child: Container(
          height: 100.sp,
          padding: AppPadding.p16.copyWith(top: 32),
          decoration: const BoxDecoration(color: AppColors.primary),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('no_internet_message'.tr, style: const TextStyle(color: Colors.white)),
              ),
              const TextButton(
                onPressed: SmartDialog.dismiss,
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);
  }
}
