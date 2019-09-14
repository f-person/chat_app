import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../screens/chat.dart';

class MessagesBloc {
  final _messagesSubject = BehaviorSubject<String>();
  var _channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  int _notificationIndex = 0;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Observable get messages => _messagesSubject.stream;

  Future onSelectNotification(String payload) async {
    print('payload: $payload');
  }

  Future _showNotificationWithDefaultSound(String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      _notificationIndex,
      'New Message',
      '$body',
      platformChannelSpecifics,
      payload: '$body',
    );
  }

  MessagesBloc() {
    final _initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final _initializationSettingsIOS = IOSInitializationSettings();
    final _initializationSettings = InitializationSettings(
        _initializationSettingsAndroid, _initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onSelectNotification: onSelectNotification);

    _channel.stream.listen((data) {
      print(data);
      _messagesSubject.sink.add('echoed: $data');

      _showNotificationWithDefaultSound(data);
      _notificationIndex++;

      ChatScreen.animateToBottom();
    }, onDone: () {
      print('-----------------------------');
      _channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
    }, onError: (err) {
      print('/////////////////////////////');
      _channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
    });
  }

  void dispose() {
    _messagesSubject.close();
  }

  void sendMessage(String text) {
    _messagesSubject.sink.add(text);
    _channel.sink.add(text);
  }
}
