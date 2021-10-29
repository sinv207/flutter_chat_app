import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:flutter_chat_app/shared/performance.dart';
// import 'dart:developer' as developer;

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('qchats');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('qmessages');

  // brew list from snapshot
  List<Message> _messagesFromSnapshot(QuerySnapshot snapshot) {
    // print(snapshot);
    return snapshot.docs.map((doc) {
      // print(doc.data());
      return Message(
        sender: users[doc.data()['sender'] ?? 0], // get user from sender_id
        time: doc.data()['timestamp'] ?? '',
        text: doc.data()['text'] ?? '',
        isLiked: true,
        unread: true,
      );
    }).toList();
  }

  Future removeMessage(String text) async {
    // test: random sender
    // TODO: replace by current user (from this.uid)
    User sender = users[Random().nextInt(7)];
    return await messageCollection.doc().set({
      'sender': sender != null ? sender.id : '',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text ?? '',
      'isLiked': true,
      'unread': true
    });
  }

  Future sendMessage(String text) async {
    // test: random sender
    // TODO: replace by current user (from this.uid)
    User sender = users[Random().nextInt(7)];

    Performance().time('sendMessage');
    final result = await messageCollection.doc().set({
      'sender': sender != null ? sender.id : '',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text ?? '',
      'isLiked': true,
      'unread': true
    });
    Performance().timeEnd('sendMessage');
    return result;
  }

  Future reset() async {
    print('reset');
    QuerySnapshot snapshot = await messageCollection.get();
    snapshot.docs.forEach((doc) => messageCollection.doc(doc.id).delete());
  }

  Future multiQueries() async {
    QuerySnapshot snapshot = await messageCollection.get();
    snapshot.docs.forEach((doc) {
      print(doc.id);
      messageCollection.doc(doc.id);
    });
  }

  // get qmessages stream
  Stream<List<Message>> get qMessages {
    return messageCollection
        // .where('sender', isEqualTo: '')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_messagesFromSnapshot);
  }
}
