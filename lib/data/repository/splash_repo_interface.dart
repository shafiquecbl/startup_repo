import 'package:http/http.dart';

abstract class SplashRepoInterface {
  void initSharedData();
  Future<Response?> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
