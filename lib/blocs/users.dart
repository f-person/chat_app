import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UsersBloc {
  Future<User> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('_id');
    final name = prefs.getString('name');

    return User(id: id, name: name);
  }
}
