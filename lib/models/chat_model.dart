import 'package:flutter_chat_app/models/user_model.dart';

import 'message_model.dart';

class Chat {
  final User owner;
  // Would usually be type DateTime or Firebase Timestamp in production apps
  final String time;
  final List<Message> messages;

  Chat({
    this.owner,
    this.time,
    this.messages,
  });
}
