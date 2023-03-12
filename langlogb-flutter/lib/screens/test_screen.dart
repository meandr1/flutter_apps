import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/database/database-helper.dart';
import 'package:lang_log_b/data/models/word.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/base-screen.dart';
import 'package:lang_log_b/screens/cells/test_list_cell.dart';
import 'package:lang_log_b/screens/test_answer_wrong.dart';
import 'package:lang_log_b/screens/test_completed.dart';
import 'package:lang_log_b/screens/tests_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'common/top-panel.dart';

class TestPage extends StatefulWidget {
  final TestType testType;
  final PageType pageType;
  final testId;
  final results;
  final isPassed;

  TestPage(
      {this.testType = TestType.Tests,
      this.pageType,
      @required this.testId,
      this.results,
      this.isPassed = false});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final databaseHelper = DatabaseHelper.instance;

  //words to test
  var _words = List<Word>();
  //words for variants
  var _variantsWords = List<Word>();
  //translate variants for current word index
  var _translateVariants = List<String>();

  var _currentWordIndex = 0;
  var _totalWords = 1;
  var _currentVariantIndex;

  var _wrongWords = List<Word>();

  @override
  void initState() {
    _readWords();
    super.initState();
  }

  void _readWords() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    switch (widget.testType) {
      case TestType.Tests:
        if (widget.testId == 0) {
          _words = shuffle(await helper.queryWordsForStartTest());
          _variantsWords = _words;
        } else {
          _words = widget.pageType == PageType.LogicalContext
              ? shuffle(await helper.queryWordsForTest(widget.testId))
              : shuffle(await helper.queryDerivativesForTest(widget.testId));
          _variantsWords = _words;
        }
        break;
      case TestType.Controls:
        _words = widget.pageType == PageType.LogicalContext
        ? shuffle(await helper.queryWordsForControl(widget.testId))
        : shuffle(await helper.queryDerivativesForControl(widget.testId));
        _variantsWords = _words;
        break;
      case TestType.TestsResults:
        _variantsWords = widget.pageType == PageType.LogicalContext
            ? shuffle(await helper.queryWordsForTest(widget.testId))
            : shuffle(await helper.queryDerivativesForTest(widget.testId));
        _words = shuffle(await helper.queryWordsForTestResult(widget.results));
        break;
      case TestType.ControlsResults:
        _variantsWords = widget.pageType == PageType.LogicalContext
            ? shuffle(await helper.queryWordsForControl(widget.testId))
            : shuffle(await helper.queryDerivativesForControl(widget.testId));
        _words = shuffle(await helper.queryWordsForTestResult(widget.results));
        break;
    }
    _totalWords = _words.length;
    _variants();
  }

  void _variants() {
    if (_words.length == 0) {
      return null;
    }
    var resultList = List<String>();
    final word = _words[_currentWordIndex];
    resultList.add(word.fullWord());
    do {
      final newId = Random().nextInt(_variantsWords.length);
      final newWord = _variantsWords[newId];
      final newWordString = newWord.fullWord();
      if (newId != word.id &&
          resultList.contains(newWordString) == false &&
          word.translation != newWord.translation &&
          newWordString.length > 0) {
        resultList.add(newWordString);
      }
    } while (resultList.length < 4);

    _translateVariants = shuffle(resultList);
    setState(() {});
  }

  List shuffle(List items) {
    var random = new Random();
    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  Widget _progressBackground(BuildContext context) => Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.79,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.5)),
                  color: const Color(0xffe7f3f9))),
        ],
      );

  Widget _progressLine(BuildContext context, int progress) => Container(
      width: MediaQuery.of(context).size.width * 0.79 * (progress / _totalWords),
      height: 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.5)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [const Color(0xff477efd), const Color(0xff96d6ff)])));

  Widget _progressText(int currentIndex) => RichText(
          text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff092330),
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            text: "$currentIndex"),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff477efd),
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            text: "/$_totalWords")
      ]));

  Widget _progress(BuildContext context, int currentIndex) => Row(
        children: [
          Stack(
            children: [
              _progressBackground(context),
              _progressLine(context, currentIndex)
            ],
          ),
          SizedBox(width: 10),
          _progressText(currentIndex)
        ],
      );

  Widget _subtitleText() => Text("Выберите правильный ответ",
      style: const TextStyle(
          color: const Color(0xff092330),
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 10.0),
      textAlign: TextAlign.center);

  Widget _wordText(String text) => Text(text,
      style: const TextStyle(
          color: const Color(0xff333333),
          fontWeight: FontWeight.w900,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 20.0),
      textAlign: TextAlign.center);

  String screenName() {
    var screenName = '';
    switch (widget.pageType) {
      case PageType.LogicalContext:
        screenName = 'Контекст';
        break;
      case PageType.Derivatives:
        screenName = 'Производные';
        break;
    }

    switch (widget.testType) {
      case TestType.Tests:
        screenName = screenName + '_Тест_';
        break;
      case TestType.TestsResults:
        screenName = screenName + '_ТестРезультат_';
        break;
      case TestType.Controls:
        screenName = screenName + '_Контроль_';
        break;
      case TestType.ControlsResults:
        screenName = screenName + '_КонтрольРезультат_';
        break;
    }
    return screenName;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          BasePage(
              index: widget.testType == TestType.Tests ||
                      widget.testType == TestType.TestsResults
                  ? 1
                  : 3,
              type: widget.pageType),
          Padding(
            padding: const EdgeInsets.only(top: 105.0, left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _progress(context, _currentWordIndex + 1),
                SizedBox(height: 12),
                _subtitleText(),
                SizedBox(height: 31),
                _wordText(_currentWordIndex < _words.length
                    ? (_words[_currentWordIndex].testTranslation)
                    : ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 190, left: 15, right: 15),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 13),
              itemCount: 4,
              itemBuilder: (context, index) => Listener(
                onPointerDown: (_) {
                  setState(() {
                    _currentVariantIndex = index;
                  });
                },
                onPointerUp: (_) {
                  setState(() {
                    _currentVariantIndex = null;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    if (_currentWordIndex < _words.length - 1) {
                      tapGoToNextWord(index, context);
                    } else {
                      //Send test result to server
                      tapGoToEnd(context);
                    }
                  },
                  child: TestListItem(
                      text: (index < _translateVariants.length
                          ? _translateVariants[index]
                          : ''),
                      selected: _currentVariantIndex == index),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void tapGoToEnd(BuildContext context) async {
    if (!widget.isPassed) {
      // LangLogBApp.analytics.logEvent(name: screenName() + '_Неправильно');
      var wrongWordsIds =
          _wrongWords.map((word) => word.id).toList();
    
      switch (widget.testType) {
        case TestType.Tests:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var testsResults = prefs.getStringList('testsResults');
          if (testsResults == null) {
            testsResults = List<String>();
          }
          if (testsResults.contains(widget.testId.toString()) == false) {
            testsResults.add(widget.testId.toString());
            prefs.setStringList('testsResults', testsResults);
          }
          if (AppSharedData().isLoggedIn == true) {
            widget.pageType == PageType.LogicalContext
                ? RealtimeDatabaseService().createUpdateWordsTestResult(
                widget.testId, wrongWordsIds)
                : RealtimeDatabaseService().createUpdateDerivativesTestResult(
                widget.testId, wrongWordsIds);
          }
          break;
        case TestType.Controls:
          if (AppSharedData().isLoggedIn == true) {
            widget.pageType == PageType.LogicalContext
                ? RealtimeDatabaseService().createUpdateWordsControlResult(
                widget.testId, wrongWordsIds)
                : RealtimeDatabaseService()
                .createUpdateDerivativesControlResult(
                widget.testId, wrongWordsIds);
          }
          break;
        case TestType.TestsResults:
          break;
        case TestType.ControlsResults:
          break;
      }
    } else {
      // LangLogBApp.analytics.logEvent(name: screenName() + '_ПовторноНеправильно');
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TestCompletedPage(
              correctAnswersCount:
                  _words.length - _wrongWords.length,
              wrongAnswersCount: _wrongWords.length,
              testId: widget.testId,
              testType: widget.testType,
              pageType: widget.pageType,
              completedPageType: widget.testId == 0
                  ? TestCompletedPageType.Start
                  : TestCompletedPageType.Regular,
              results: widget.results,
              isPassed: widget.isPassed),
        ));
  }

  void tapGoToNextWord(int index, BuildContext context) {
     final sourceWord = _words[_currentWordIndex].fullWord();
    // LangLogBApp.analytics.logEvent(name: screenName() + sourceWord + '_Правильно');
    final selectedWord = _translateVariants[index];
    if (sourceWord != selectedWord) {
      _wrongWords.add(_words[_currentWordIndex]);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return TestAnswerWrongDialog(
              answer: selectedWord,
              word: _words[_currentWordIndex],
              words: _words
                  .where((word) =>
                      word.categoryId ==
                      _words[_currentWordIndex].categoryId)
                  .toList(),
              onContinue: () {},
            );
          }).then((val) {
        goNext();
      });
    } else {
      goNext();
    }
  }

  void goNext() {
    _currentWordIndex += 1;
    _variants();
  }
}
