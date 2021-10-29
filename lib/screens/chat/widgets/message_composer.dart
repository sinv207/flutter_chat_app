import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/shared/performance.dart';
import 'dart:math';

class MessageComposer extends StatefulWidget {
  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  // text field state
  String text = '';

  final textController = TextEditingController();

  // register with email and password
  Future send() async {
    try {
      // test: delete
      if (text == 'Del') {
        return await DatabaseService().reset();
      }

      // create a new document for new message from current user
      return await DatabaseService()
          .sendMessage(text + messages[Random().nextInt(6)].text);

      // for (var i = 0; i < 2; i++) {
      //   DatabaseService().multiQueries();
      // }

      // for (var i = 0; i < 200; i++) {
      //   await DatabaseService().sendMessage(messages[Random().nextInt(6)].text);
      // }
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() => text = value);
              },
              onSubmitted: (value) {
                // developer.log('test1');
                try {
                  Performance().time('test1');
                  // print('Message = ' + text);
                  send();
                  textController.clear();
                } catch (e) {
                  print(e);
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Performance().time('test1');
              // print('Message = ' + text);
              send();
              textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
