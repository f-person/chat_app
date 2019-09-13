import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

import '../blocs/messages.dart';

class ChatScreen extends StatelessWidget {
  final List<String> _messages = [];
  final _messageInputController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  final bloc = MessagesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: bloc.messages,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                print('rebuild');

                if (snapshot.hasData) {
                  _messages.insert(0, snapshot.data as String);
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, index) {
                    print(_messages);

                    _scrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );

                    bool sentByMe = _messages[index].length < 7 ||
                        _messages[index].substring(0, 7) != 'echoed:';
                    return Bubble(
                      child: Text(
                        _messages[index],
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      elevation: 5,
                      margin: const BubbleEdges.only(top: 10.0),
                      color: sentByMe
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                      nip: sentByMe ? BubbleNip.rightTop : BubbleNip.leftTop,
                      alignment:
                          sentByMe ? Alignment.topRight : Alignment.topLeft,
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: TextField(
                    controller: _messageInputController,
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  print(_messageInputController.text);
                  bloc.sendMessage(_messageInputController.text);
                  _messageInputController.clear();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
