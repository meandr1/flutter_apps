import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lang_log_b/data/models/word.dart';
import 'package:lang_log_b/screens/common/buttons.dart';
import '../main.dart';
import 'cells/system-list-item.dart';

class TestAnswerWrongDialog extends StatelessWidget {
  final Word word;
  var words = List<Word>();
  final String answer;
  final Function onContinue;

  TestAnswerWrongDialog(
      {@required this.answer,
      @required this.word,
      @required this.words,
      @required this.onContinue});

  Widget _title() => RichText(
          text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 20.0),
            text: "ВЫ ОТВЕТИЛИ "),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xffa51d01),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 20.0),
            text: "НЕВЕРНО")
      ]));

  Widget _subtitle() => RichText(
          text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff092330),
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            text: "Правильный ответ: "),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff02af50),
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            text: word.fullWord())
      ]));

  Widget _description() => Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 26, right: 26),
        child: Text("Группа слов:",
            style: const TextStyle(
                color: const Color(0xff092330),
                fontWeight: FontWeight.w700,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            textAlign: TextAlign.left),
      );

  Widget _wrongAnswerButton(BuildContext context) => Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width * 0.3,
        child: TextButton(
            onPressed: null,
            child: Image.asset('assets/buttons/test-answer-wrong-button.png',
                fit: BoxFit.fitHeight)),
      );

  Widget _continueButton(BuildContext context) => Container(
        height: 33,
        width: MediaQuery.of(context).size.width - 100,
        child: LLTopBarButton(
            text: 'ПРОДОЛЖИТЬ',
            titleColor: const Color(0xffffffff),
            backgroundColor: const Color(0xff02af50),
            onPressed: () {
              // LangLogBApp.analytics.logEvent(name: 'ОкноНеправильно_КнопкаПродолжить');
              onContinue();
              Navigator.of(context).pop();
            }),
      );

  Widget _contentRow(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width - 100,
      height: MediaQuery.of(context).size.width * 1.08 - 330,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x3302589f),
              spreadRadius: 2,
              blurRadius: 7,
            )
          ]),
      child: ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            return SystemListItem(
              words[index],
              type: SystemListItemType.testTranslation,
            );
          }));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 1.08,
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/backgrounds/test-completed-form-background.png',
                  fit: BoxFit.fill,
                )),
            Padding(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Column(
                children: [
                  _wrongAnswerButton(context),
                  SizedBox(height: 15),
                  _title(),
                  SizedBox(height: 12),
                  _subtitle(),
                  SizedBox(height: 24),
                  _description(),
                  SizedBox(height: 9),
                  _contentRow(context),
                  SizedBox(height: 10),
                  _continueButton(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
