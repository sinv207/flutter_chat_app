import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference messageCollection =
      Firestore.instance.collection('qmessages');

  // brew list from snapshot
  List<Message> _messagesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      // print(doc.data);
      return Message(
        sender: james,
        time: doc.data['timestamp'] ?? '',
        text: doc.data['text'] ?? '',
        isLiked: true,
        unread: true,
      );
    }).toList();
  }

  Future sendMessage(User sender, String text) async {
    return await messageCollection.document().setData({
      'sender': sender != null ? sender.name : '',
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
        .where('sender', isNull: false)
        .orderBy('timestamp')
        .snapshots()
        .map(_messagesFromSnapshot);
  }
}
