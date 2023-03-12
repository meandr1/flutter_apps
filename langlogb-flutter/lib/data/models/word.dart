

// database column names
final String columnId = '_id';
final String columnSystemId = 'systemId';
final String columnCategoryId = 'categoryId';
final String columnFirstWord = 'firstWord';
final String columnSecondWord = 'secondWord';
final String columnTranslation = 'translation';
final String columnTestTranslation = 'testTranslation';
final String columnTranscryption = 'transcryption';
final String columnTestId = 'testId';
final String columnControlId = 'controlId';
final String columnPageId = 'pageId';
final String columnIsStartTest = 'isStartTest';

class Word {
  int id;
  int systemId;
  int categoryId;
  String firstWord;
  String secondWord;
  String translation;
  String testTranslation;
  String transcryption;
  int testId;
  int controlId;
  int pageId;
  bool isStartTest;

  String fullWord() {
    return firstWord + secondWord;
  }
  // SystemItem();

  Word(this.id, this.systemId, this.categoryId, this.firstWord, this.secondWord,
      this.translation, this.transcryption, this.isStartTest);

  // convenience constructor to create a SystemItem object
  Word.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    systemId = map[columnSystemId];
    categoryId = map[columnCategoryId];
    firstWord = map[columnFirstWord] ?? '';
    secondWord = map[columnSecondWord] ?? '';
    translation = map[columnTranslation] ?? '';
    testTranslation = map[columnTestTranslation] ?? '';
    transcryption = map[columnTranscryption] ?? '';
    testId = map[columnTestId] ?? -1;
    controlId = map[columnControlId] ?? -1;
    pageId = map[columnPageId] ?? 0;
    isStartTest = map[columnIsStartTest] != 0 ?? false;
  }

  // convenience method to create a Map from this SystemItem object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSystemId: systemId,
      columnCategoryId: categoryId,
      columnFirstWord: firstWord,
      columnSecondWord: secondWord,
      columnTranslation: translation,
      columnTestTranslation: testTranslation,
      columnTranscryption: transcryption,
      columnTestId: testId,
      columnControlId: controlId,
      columnPageId: pageId,
      columnIsStartTest: isStartTest == true ? 1 : false
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
