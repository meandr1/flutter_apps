import 'package:firebase_database/firebase_database.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/models/test_results.dart';
import 'package:lang_log_b/data/models/user_detail_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class RealtimeDatabaseService {
  AuthService _authService = AuthService();
  final databaseReference = FirebaseDatabase.instance.reference();

  //allow Firebase to cache data and work offline
  // databaseReference.setPersistenceEnabled(true);

  // User
  //
  void createUser(String id, String email) async {
    final user = await userIdentifier();
    databaseReference.child(user).set({
      'email': email,
      'isPremium': false,
      'startDate': DateTime.now().millisecondsSinceEpoch
    });
  }

  // Future<UserDetailInfo> getUserInfo() async {
  //   final user = await userIdentifier();
  //   if (user == null) {
  //     final userInfo = UserDetailInfo();
  //     userInfo.isPremium = false;
  //     userInfo.startDate = DateTime.now();
  //     return userInfo;
  //   }
  //   final userInfo = UserDetailInfo();
  //   databaseReference.child(user).once().then((DataSnapshot snapshot) async {
  //     if (snapshot != null) {
  //       if (snapshot.value['startDate'] != null)
  //           userInfo.startDate =
  //             DateTime.fromMillisecondsSinceEpoch(snapshot.value['startDate']);
  //
  //       if (snapshot.value['isPremium'])
  //           userInfo.isPremium = snapshot.value['isPremium'];
  //     }
  //   });
  //   return userInfo;
  // }

  void updateUserSubscryption(bool subscryption) async {
    final user = await userIdentifier();
    databaseReference.child(user).set({'isPremium': subscryption});
    AppSharedData().userInfo.isPremium = subscryption;
  }

  Future<String> userIdentifier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user-id');
  }

  Future<bool> isSecondStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSecondStart');
  }

  //Word Test results
  //
  List<TestResults> mapTestResults(DataSnapshot snapshot) {
    var resultsList = List<TestResults>();

    if (snapshot.value is Map) {
      Map<dynamic, dynamic> tests = snapshot.value;

      tests.forEach((key, value) {
        final wordsIds = value["wordsIds"];
        if (wordsIds != null) {
          List<int> intList = wordsIds.cast<int>();
          resultsList.add(TestResults.from(key, intList));
        }
      });
    } else if (snapshot.value is List) {
      print('list');
      List<dynamic> resultList = snapshot.value;
      for (var index = 0; index < resultList.length; index++) {
        if (resultList[index] == null) {
          continue;
        }
        Map<dynamic, dynamic> map = Map.from(resultList[index]);
        final wordsIds = map["wordsIds"];
        if (wordsIds != null) {
          List<int> intList = wordsIds.cast<int>();
          resultsList.add(TestResults.from(index.toString(), intList));
        }
      }
    }

    return resultsList;
  }

  Future<List<TestResults>> getWordsTestsResults() async {
    final user = await userIdentifier();
    DataSnapshot data;
    await databaseReference
        .child(user)
        .child('wordsTests')
        .once()
        .then((Object snapshot) {
      data = snapshot;
    });
    return mapTestResults(data);
  }

  void createUpdateWordsTestResult(int testId, List<int> wordsIds) async {
    final user = await userIdentifier();
    databaseReference
        .child(user)
        .child('wordsTests')
        .child('$testId')
        .set({'wordsIds': wordsIds});
  }

  // Word Control results
  //
  Future<List<TestResults>> getWordsControlsResults() async {
    final user = await userIdentifier();
    DataSnapshot data;
    await databaseReference
        .child(user)
        .child('wordsControls')
        .once()
        .then((Object snapshot) {
      data = snapshot;
    });
    return mapTestResults(data);
  }

  void createUpdateWordsControlResult(int testId, List<int> wordsIds) async {
    final user = await userIdentifier();
    databaseReference
        .child(user)
        .child('wordsControls')
        .child('$testId')
        .set({'wordsIds': wordsIds});
  }

  // Derivative tests results
  //
  Future<List<TestResults>> getDerivativesTestsResults() async {
    final user = await userIdentifier();
    DataSnapshot data;
    await databaseReference
        .child(user)
        .child('derivativesTests')
        .once()
        .then((Object snapshot) {
      data = snapshot;
    });
    return mapTestResults(data);
  }

  void createUpdateDerivativesTestResult(int testId, List<int> wordsIds) async {
    final user = await userIdentifier();
    databaseReference
        .child(user)
        .child('derivativesTests')
        .child('$testId')
        .set({'wordsIds': wordsIds});
  }

  // Derivative controls results
  //
  Future<List<TestResults>> getDerivativesControlsResults() async {
    final user = await userIdentifier();
    DataSnapshot data;
    await databaseReference
        .child(user)
        .child('derivativesControls')
        .once()
        .then((Object snapshot) {
      data = snapshot;
    });
    return mapTestResults(data);
  }

  void createUpdateDerivativesControlResult(
      int testId, List<int> wordsIds) async {
    final user = await userIdentifier();
    databaseReference
        .child(user)
        .child('derivativesControls')
        .child('$testId')
        .set({'wordsIds': wordsIds});
  }
}
