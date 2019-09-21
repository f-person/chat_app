import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../blocs/users.dart';
import '../blocs/messages.dart';

class ChatScreen extends StatelessWidget {
  final List<Message> _messages = [];
  final _messageInputController = TextEditingController();
  static final ScrollController _scrollController = new ScrollController();
  final messagesBloc = MessagesBloc();
  final usersBloc = UsersBloc();
  final _authenticatedUser = User.empty();

  ChatScreen() {
    usersBloc.getUserFromPrefs().then((User user) {
      _authenticatedUser.update(user.id, user.name);
    });
  }

  static void animateToBottom() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

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
              stream: messagesBloc.messages,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                print('rebuild');

                if (snapshot.hasData) {
                  _messages.insert(0, snapshot.data as Message);
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, index) {
                    print(_messages);

                    bool sentByMe =
                        _messages[index].author.id == _authenticatedUser.id;
                    return Bubble(
                      child: Text(
                        _messages[index].body,
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
                  if (_messageInputController.text.isNotEmpty) {
                    messagesBloc.sendMessage(_messageInputController.text);
                    _messageInputController.clear();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
