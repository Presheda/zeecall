import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeecall/features/model/agora_user.dart';
import 'package:zeecall/presentation/utils/logger.dart';

class AgoraUserDataProvider {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future saveUser(
      {required AgoraUser agoraUser, required String channelName}) async {


    firebaseFirestore
        .collection("calls")
        .doc(channelName)
        .collection(channelName)
        .doc(agoraUser.userId.toString())
        .set(agoraUser.toMap());

    return;
  }

  Stream<List<AgoraUser>> fetchUsers({required String channelName}) async* {
    yield* firebaseFirestore
        .collection("calls")
        .doc(channelName)
        .collection(channelName)
        .snapshots()
        .map((event) => mapData(event.docs));
  }

 List<AgoraUser> mapData(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    if (docs.isEmpty) return [];

    List<AgoraUser> users = [];

    docs.forEach((element) {
      users.add(AgoraUser.fromMap(element.data()));
    });

    return users;
  }

 Future deleteLocalUser({required AgoraUser agoraUser, required String channelName}) async {


   AppLogger.log("w", "Deleting user ::: $channelName, ::: ${agoraUser.userId.toString()}");

  return  firebaseFirestore
        .collection("calls")
        .doc(channelName)
        .collection(channelName)
        .doc(agoraUser.userId.toString())
        .delete();
  }
}
