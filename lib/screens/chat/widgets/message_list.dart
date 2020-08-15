import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/screens/chat/widgets/message_item.dart';
import 'package:flutter_chat_app/screens/chat/widgets/message_composer.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    final qMessages = Provider.of<List<Message>>(context) ?? messages;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: qMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message message = qMessages[index];
                    final bool isMe = message.sender.id == currentUser.id;
                    return MessageItem(message: message, isMe: isMe);
                  },
                ),
              ),
            ),
          ),
          MessageComposer(),
        ],
      ),
    );
  }
}
