import 'package:http/http.dart';

abstract class SplashRepo {
  Future<Response?> getConfig();
  Future<bool> saveFirstTime();
  bool getFirstTime();
}
