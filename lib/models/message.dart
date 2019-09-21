import 'package:flutter/foundation.dart';

import './user.dart';

class Message {
  final String body;
  final User author;

  Message({
    @required this.body,
    @required this.author,
  });
}
