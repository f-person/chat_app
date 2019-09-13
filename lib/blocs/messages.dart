import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class MessagesBloc {
  final _messagesSubject = BehaviorSubject<String>();
  final _channel = IOWebSocketChannel.connect('ws://echo.websocket.org');

  MessagesBloc() {
    _channel.stream.listen((data) {
      print(data);

      _messagesSubject.sink.add('echoed: $data');
    });
  }

  Observable get messages => _messagesSubject.stream;

  void dispose() {
    _messagesSubject.close();
  }

  void sendMessage(String text) {
    _messagesSubject.sink.add(text);
    _channel.sink.add(text);
  }
}
