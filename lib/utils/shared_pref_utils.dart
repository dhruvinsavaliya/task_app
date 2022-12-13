import 'package:get_storage/get_storage.dart';

class SharedPreferenceUtils {
  static GetStorage getStorage = GetStorage();

  static String isLogin = 'isLogin';
  static String token = 'token';

  /// IS LOGIN
  static Future setIsLogin(String value) async {
    await getStorage.write(isLogin, value);
  }

  static String getIsLogin() {
    return getStorage.read(isLogin) ?? '';
  }

  /// Token
  static Future setToken(String value) async {
    await getStorage.write(token, value);
  }

  static String getToken() {
    return getStorage.read(token) ?? '';
  }

  static Future clearLocalData() async {
    await getStorage.erase();
  }
}
