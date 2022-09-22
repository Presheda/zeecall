import 'package:zeecall/features/call/repository/agorauser_data_provider.dart';
import 'package:zeecall/features/model/agora_user.dart';
import 'package:zeecall/presentation/utils/logger.dart';

/// this is a repository, it's job is to create abstraction
class AgoraUserRepository {
  AgoraUserDataProvider? dataProvider;

  AgoraUserRepository({this.dataProvider}) {
    dataProvider ??= AgoraUserDataProvider();
  }

  Future saveUser(
      {required AgoraUser agoraUser, required String channelName}) async {
    try {
      await dataProvider!
          .saveUser(agoraUser: agoraUser, channelName: channelName);
    } on Exception catch (e) {
      AppLogger.log("d", "Error occured while saving user :: $e");
    }

    return;
  }

  Stream<List<AgoraUser>> fetchUsers({required String channelName}) async* {
    yield* dataProvider!.fetchUsers(channelName: channelName);
  }

  Future deleteLocalUser({required AgoraUser user, required String channelName}) async {
    try {
      await dataProvider!
        .deleteLocalUser(agoraUser: user, channelName: channelName);


      AppLogger.log("w", "Deleting user ::: $channelName, ::: $user");
    }  catch (e) {
    AppLogger.log("d", "Error occured while saving user :: $e");
    }

    return;
  }
}
