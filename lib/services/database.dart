import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
// import 'dart:developer' as developer;

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference chatCollection =
      Firestore.instance.collection('qchats');

  final CollectionReference messageCollection =
      Firestore.instance.collection('qmessages');

  // brew list from snapshot
  List<Message> _messagesFromSnapshot(QuerySnapshot snapshot) {
    print(snapshot);
    return snapshot.documents.map((doc) {
      // print(doc.data);
      return Message(
        sender: users[doc.data['sender'] ?? 0], // get user from sender_id
        time: doc.data['timestamp'] ?? '',
        text: doc.data['text'] ?? '',
        isLiked: true,
        unread: true,
      );
    }).toList();
  }

  Future removeMessage(String text) async {
    // test: random sender
    // TODO: replace by current user (from this.uid)
    User sender = users[Random().nextInt(7)];
    return await messageCollection.document().setData({
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
    return await messageCollection.document().setData({
      'sender': sender != null ? sender.id : '',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text ?? '',
      'isLiked': true,
      'unread': true
    });
  }

  Future reset() async {
    print('reset');
    QuerySnapshot snapshot = await messageCollection.getDocuments();
    snapshot.documents
        .forEach((doc) => messageCollection.document(doc.documentID).delete());
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
