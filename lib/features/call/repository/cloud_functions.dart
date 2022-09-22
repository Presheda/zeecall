import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsRepository {

 const CloudFunctionsRepository ();
  Future callFunction(
      {required String name, Map<String, dynamic>? data}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(name);


    await Future.delayed(Duration(milliseconds: 2000));

    try {
      var result = await callable.call(data);

      return result.data;
    } catch (_) {
      return -1;
    }
  }
}
