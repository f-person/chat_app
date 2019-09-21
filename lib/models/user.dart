import 'package:flutter/foundation.dart';

class User {
  String id;
  String name;

  User({
    @required this.id,
    @required this.name,
  });

  User.empty();

  void update(String newId, String newName) {
    id = newId;
    name = newName;
  }
}
