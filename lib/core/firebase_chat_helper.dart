import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_messages.dart';
import 'fire_store_constant.dart';

class FirebaseChatHelpersMethods {
  static final FirebaseChatHelpersMethods _helperMethods =
      FirebaseChatHelpersMethods._internal();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  factory FirebaseChatHelpersMethods() {
    return _helperMethods;
  }

  FirebaseChatHelpersMethods._internal();

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    try {
      return firebaseFirestore
          .collection(collectionPath)
          .doc(path)
          .update(updateData);
    } catch (e) {
      print(e.toString());
    }
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    try {
      DocumentReference documentReference = firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      ChatMessages chatMessages = ChatMessages(
          idFrom: currentUserId,
          idTo: peerId,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          type: type);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, chatMessages.toJson());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
