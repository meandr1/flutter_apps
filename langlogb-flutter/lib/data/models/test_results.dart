
import 'package:firebase_database/firebase_database.dart';

class TestResults {
  int testId;
  List<int> wordsIds;

  TestResults(this.testId, this.wordsIds);

  TestResults.from(String id, List<int> wordsIds) :
        testId = int.parse(id) ,
        wordsIds = wordsIds;

  toJson() {
    return {
      "testId": testId,
      "wordsIds": wordsIds,
    };
  }
}