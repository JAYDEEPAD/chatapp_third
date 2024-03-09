import 'package:chatapp_third/allConstants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatModel {
  String? id;
  String? photoURL;
  String? nickname;
  String? aboutMe;
  String? phoneNumber;
  UserChatModel(
      {required this.id,
      required this.photoURL,
      required this.nickname,
      required this.aboutMe,
      required this.phoneNumber});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickname: nickname!,
      FirestoreConstants.aboutMe: aboutMe!,
      FirestoreConstants.photoUrl: photoURL!,
      FirestoreConstants.phoneNumber: phoneNumber!,
    };
  }

  factory UserChatModel.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String photoURL = "";
    String nickname = "";
    String phoneNumber = "";
    try {
      aboutMe = doc.get(FirestoreConstants.aboutMe);
    } catch (e) {}
    try {
      aboutMe = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    try {
      phoneNumber = doc.get(FirestoreConstants.phoneNumber);
    } catch (e) {}
    return UserChatModel(
        id: doc.id,
        photoURL: photoURL,
        nickname: nickname,
        aboutMe: aboutMe,
        phoneNumber: phoneNumber);
  }
}
