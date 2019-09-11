import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatelessWidget {
  final _channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  final List<String> _messages = [];
  final _messageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder(
        stream: _channel.stream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          print('rebuild');

          if (snapshot.hasData && !_messages.contains(snapshot.data)) {
            _messages.add(snapshot.data as String);
          }

          return ListView.builder(
            itemCount: _messages.length + 1,
            itemBuilder: (_, index) {
              if (index == _messages.length) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextField(
                          controller: _messageInputController,
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        print(_messageInputController.text);
                        _channel.sink.add(_messageInputController.text);
                      },
                    )
                  ],
                );
              }

              return Bubble(
                child: Text(_messages[index]),
              );
            },
          );
        },
      ),
    );
  }
}
