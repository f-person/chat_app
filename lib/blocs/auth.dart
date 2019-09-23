import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  final String backendUrl = 'https://BACKEND';

  void loginWithGoogle(String idToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('idToken', idToken);
  }
}
