import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;

import './users.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../screens/chat.dart';

class MessagesBloc {
  static String wsUrl = 'ws://echo.websocket.org';
  final _messagesSubject = BehaviorSubject<Message>();
  var _channel = IOWebSocketChannel.connect('$wsUrl');
  int _notificationIndex = 0;
  User authenticatedUser;

  void init() async {
    authenticatedUser = await UsersBloc().getUserFromPrefs();

    final _initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    final _initializationSettingsIOS = fln.IOSInitializationSettings();
    final _initializationSettings = fln.InitializationSettings(
        _initializationSettingsAndroid, _initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    _channel.stream.listen((data) {
      final messageData = json.decode(data);
      print(messageData);
      final message = Message(
        author: User(
          id: messageData['author']['_id'],
          name: messageData['author']['name'],
        ),
        body: messageData['body'],
      );

      _messagesSubject.sink.add(message);

      _showNotificationWithDefaultSound(data);
      _notificationIndex++;

      ChatScreen.animateToBottom();
    }, onDone: () {
      print('-----------------------------');
      _channel = IOWebSocketChannel.connect('$wsUrl');
    }, onError: (err) {
      print('/////////////////////////////');
      _channel = IOWebSocketChannel.connect('$wsUrl');
    });
  }

  final flutterLocalNotificationsPlugin = fln.FlutterLocalNotificationsPlugin();

  Observable get messages => _messagesSubject.stream;

  Future onSelectNotification(String payload) async {
    print('payload: $payload');
  }

  Future _showNotificationWithDefaultSound(String body) async {
    var androidPlatformChannelSpecifics = new fln.AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: fln.Importance.Max, priority: fln.Priority.High);
    var iOSPlatformChannelSpecifics = new fln.IOSNotificationDetails();
    var platformChannelSpecifics = new fln.NotificationDetails(
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
    init();
  }

  void dispose() {
    _messagesSubject.close();
  }

  void sendMessage(String text) {
    // TODO also encode to json and add to stream
    _channel.sink.add(text);
  }
}
