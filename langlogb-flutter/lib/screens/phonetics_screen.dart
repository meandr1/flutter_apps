import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lang_log_b/data/database/database-helper.dart';
import 'package:lang_log_b/data/models/word.dart';
import 'package:lang_log_b/screens/base-screen.dart';
import 'package:lang_log_b/screens/common/top-panel.dart';
import 'Common/buttons.dart';
import 'common/blink_button.dart';
import 'common/texts.dart';

enum TtsState { playing, stopped, paused, continued }

class PhoneticsPage extends StatefulWidget {
  final index;
  final PageType type;
  PhoneticsPage({this.index = 1, this.type = PageType.LogicalContext});

  @override
  PhoneticsPageState createState() => PhoneticsPageState();
}

class PhoneticsPageState extends State<PhoneticsPage> {
  var _words = List<Word>();
  FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;
  var _currentIndex = 0;
  var _firstCategoryIndex = 0;
  var _shouldRepeat = true;
  Timer _latestTimer;
  var _currentWord = '';

  final _delayInsideCategoryMS = 1100;
  final _delayBetweenCategoriesMS = 2000;
  final _delayBetweenWordsMS = 900;

  @override
  void initState() {
    super.initState();
    _setupSpeech();
    _readWords();
  }

  _readWords() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    _words = widget.type == PageType.LogicalContext
        ? await helper.queryWordsForSystem(widget.index)
        : await helper.queryDerivativesForSystem(widget.index);
    setState(() {});
  }

  _setupSpeech() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    // await _flutterTts.setSpeechRate(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {});

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _currentWord = '';
      });

      if (_words == null || _words.isEmpty || _ttsState == TtsState.paused) {
        // || _categoryWords.last.fullWord() != _currentWord) {
        return;
      }

      int delay = 0;
      if (_isNextCategoryForIndex(_currentIndex) == true) {
        if (_shouldRepeat == true) {
          _shouldRepeat = false;
          _currentIndex = _firstCategoryIndex;
          delay = _delayInsideCategoryMS;
        } else {
          _shouldRepeat = true;
          _firstCategoryIndex = ++_currentIndex;
          delay = _delayBetweenCategoriesMS;
        }
      } else if (_currentIndex + 1 >= _words.length) {
        _currentIndex = 0;
        return;
      } else {
        _currentIndex++;
        delay = _delayBetweenWordsMS;
      }
      Word word = _words[_currentIndex];
      _latestTimer = Timer(Duration(milliseconds: delay), () {
        _speak(word.fullWord());
      });
    });

    _flutterTts.setProgressHandler(
        (String text, int startOffset, int endOffset, String word) {
      setState(() {});
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });
  }

  _speak(String text) async {
    await _flutterTts.speak(text);
    setState(() {
      _currentWord = text;
    });
  }

  _pause() async {
    _flutterTts.stop();
    _latestTimer.cancel();
    setState(() {
      _ttsState = TtsState.paused;
    });
  }

  _speakAll() async {
    if (_words.isEmpty == true) {
      return;
    }
    setState(() {
      _ttsState = TtsState.playing;
    });
    _speak(_words[_currentIndex].fullWord());
  }

  Widget _content() => Padding(
        padding: const EdgeInsets.only(
            top: 10.0, left: 10.0, bottom: 20.0, right: 0.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _phoneticsColumn(
                      words: _words.where((word) => word.pageId == 1).toList(),
                      align: TextAlign.right,
                      topLeft: 15,
                      bottomLeft: 15),
                  _phoneticsColumn(
                      words: _words.where((word) => word.pageId == 1).toList(),
                      isTranscryption: true),
                  SizedBox(width: 5),
                  _phoneticsColumn(
                      words: _words.where((word) => word.pageId == 2).toList(),
                      align: TextAlign.right),
                  _phoneticsColumn(
                      words: _words.where((word) => word.pageId == 2).toList(),
                      isTranscryption: true,
                      topRight: 15,
                      bottomRight: 15),
                ],
              ),
            ),
            // LLCenterSmallTitle('-e')
          ],
        ),
      );

  bool _isNextCategoryForIndex(int index) {
    final item = _words[index];
    if (index + 1 < _words.length) {
      final nextItem = _words[index + 1];
      if (nextItem.categoryId != item.categoryId) {
        return true;
      }
    }
    return false;
  }

  bool _isDividerForIndex(List<Word> words, int index) {
    final item = words[index];
    if (index + 1 < words.length) {
      final nextItem = words[index + 1];
      if (nextItem.categoryId != item.categoryId) {
        return true;
      }
    }
    return false;
  }

  Widget _dividerFor(List<Word> words, int index) {
    if (_isDividerForIndex(words, index)) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Container(
          color: Colors.grey,
          height: 1,
          width: MediaQuery.of(context).size.width / 4 - 15,
        ),
      );
    }
    return SizedBox();
  }

  Widget _rowText(List<Word> words, String text, int index, TextAlign align) {
    return Column(
      children: [
        Container(
          width: align == TextAlign.right
              ? MediaQuery.of(context).size.width / 5 + 17
              : MediaQuery.of(context).size.width / 5 - 10,
          padding: const EdgeInsets.only(
              top: 1.0, left: 0.0, bottom: 1.0, right: 5.0),
          child: Row(
            mainAxisAlignment: align == TextAlign.left
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              (align == TextAlign.right && _currentWord == text
                  ? BlinkButton()
                  : SizedBox()),
              SizedBox(width: 5),
              (align == TextAlign.right && _currentWord == text
                  ? Text(
                      '$text',
                      style: const TextStyle(
                          color: const Color(0xFFCA1C12),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                    )
                  : (align == TextAlign.right
                      ? Text(
                          '$text',
                          style: const TextStyle(
                              color: const Color(0xff092330),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                        )
                      : Text('$text',
                          style: const TextStyle(
                              color: const Color(0xff092330),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 8.0)))),
            ],
          ),
        ),
        _dividerFor(words, index)
      ],
    );
  }

  Widget _phoneticsColumn(
          {List<Word> words,
          int startIndex = 0,
          bool isTranscryption = false,
          TextAlign align = TextAlign.left,
          double topLeft = 0,
          double topRight: 0,
          double bottomLeft: 0,
          double bottomRight: 0}) =>
      Stack(
        children: [
          Container(
            width: isTranscryption == true
                ? MediaQuery.of(context).size.width / 4 - 6 - 10
                : MediaQuery.of(context).size.width / 4 -
                    6 +
                    10, // 15- center padding
            height: MediaQuery.of(context).size.height - 175,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeft),
                bottomLeft: Radius.circular(bottomLeft),
                topRight: Radius.circular(topRight),
                bottomRight: Radius.circular(bottomRight),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color(0x3302589f),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset:
                        Offset(topLeft == 0 ? 1 : 0, topRight == 0 ? 1 : 0)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 0, right: 0),
            child: Column(
                children: List.generate(
                    words.length,
                    (index) => _rowText(
                        words,
                        (isTranscryption == true
                            ? words[index].transcryption
                            : words[index].fullWord()),
                        startIndex + index,
                        align))),
          )
        ],
      );

  Widget _soundButton() => Container(
        padding: EdgeInsets.only(right: 20.0),
        alignment: Alignment.topRight,
        child: LLSoundButton(action: () {
          _ttsState == TtsState.playing ? _pause() : _speakAll();
        }),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          BasePage(index: 0, type: widget.type),
          Padding(
            padding: const EdgeInsets.only(top: 105.0, left: 0, right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: LLTitleText(
                          first: 'Ф',
                          second: 'ОНЕТИКА',
                          alignment: Alignment.center),
                    ),
                    _soundButton()
                  ],
                ),
                _content()
              ],
            ),
          )
        ],
      ),
    );
  }
}
