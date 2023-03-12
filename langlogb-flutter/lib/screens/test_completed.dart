import 'package:flutter/material.dart';
import 'package:lang_log_b/screens/common/buttons.dart';
import 'package:lang_log_b/screens/common/top-panel.dart';
import 'package:lang_log_b/screens/test_screen.dart';
import 'package:lang_log_b/screens/tests_screen.dart';
import '../main.dart';

enum TestCompletedPageType {
  Start,
  Regular,
}

class TestCompletedPage extends StatelessWidget {
  final int correctAnswersCount;
  final int wrongAnswersCount;
  final int testId;
  final TestCompletedPageType completedPageType;
  final TestType testType;
  final PageType pageType;
  final results;
  final isPassed;

  TestCompletedPage(
      {
        @required this.correctAnswersCount,
        @required this.wrongAnswersCount,
        this.testId,
        this.testType = TestType.Tests,
        this.completedPageType = TestCompletedPageType.Regular,
        this.pageType,
        this.results,
        this.isPassed
      });

  Widget _title(String text, Color color) => Text(
        text,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 20.0),
      );

  Widget _testCompletedButton(BuildContext context) => Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width * 0.3,
        child: TextButton(
            onPressed: null,
            //     () {
            //   Navigator.of(context).pop();
            // },
            child: Image.asset('assets/buttons/test-completed-button.png',
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
              var route;
              if (completedPageType == TestCompletedPageType.Start) {
                route = '/systems';
                Navigator.of(context).pushReplacementNamed(route);
              } else {

                if (wrongAnswersCount != 0 && (testType == TestType.TestsResults || testType == TestType.ControlsResults)) {
                  final repeatTestRoute = MaterialPageRoute(
                      builder: (context) =>
                          TestPage(
                            results: results,
                            isPassed: isPassed,
                            testType: testType,
                            pageType: pageType,
                            testId: testId,
                          ));
                  Navigator.of(context).pushReplacement(repeatTestRoute);
                } else  if (testType == TestType.Tests || testType == TestType.TestsResults) {
                  route = (pageType == PageType.LogicalContext)
                      ? '/tests'
                      : '/derivativesTests';
                  Navigator.of(context).pushReplacementNamed(route);
                } else if (testType == TestType.Controls || testType == TestType.ControlsResults) {
                  route = (pageType == PageType.LogicalContext)
                      ? '/controls'
                      : '/derivativesControls';
                  Navigator.of(context).pushReplacementNamed(route);
                }
              }
            }),
      );

  Widget _subtitleContainer(String subtext, Color subtextBackgroundStartColor,
          Color subtextBackgroundEndColor) =>
      Container(
        alignment: Alignment.center,
        width: 40,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(17),
              topRight: Radius.circular(17),
            ),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  subtextBackgroundStartColor,
                  subtextBackgroundEndColor
                ])),
        child: Text(subtext,
            style: const TextStyle(
                color: const Color(0xfffefefe),
                fontWeight: FontWeight.w700,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
            textAlign: TextAlign.left),
      );

  Widget _answerWidget(BuildContext context, String text, String subtext,
          Color subtextBackgroundStartColor, Color subtextBackgroundEndColor) =>
      Container(
        padding: EdgeInsets.only(left: 15),
        width: MediaQuery.of(context).size.width - 100,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(17),
              topRight: Radius.circular(17),
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x3302589f),
                  offset: Offset(0, 0),
                  blurRadius: 60,
                  spreadRadius: 0)
            ],
            color: const Color(0xffffffff)),
        child: Row(
          children: [
            Text(text,
                style: const TextStyle(
                    color: const Color(0xff092330),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
                textAlign: TextAlign.left),
            Spacer(),
            _subtitleContainer(
                subtext, subtextBackgroundStartColor, subtextBackgroundEndColor)
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final _wrongAnswersPercent =
        (wrongAnswersCount / (correctAnswersCount + wrongAnswersCount) * 100)
            .toInt();
    final _correctAnswersPercent = 100 - _wrongAnswersPercent;

    return Material(
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/backgrounds/test-completed-background.png'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 142),
                child: Image.asset(
                  'assets/backgrounds/test-completed-form-background.png',
                  fit: BoxFit.scaleDown,
                )),
            Padding(
              padding: EdgeInsets.only(top: 100, left: 50, right: 50),
              child: Column(
                children: [
                  _testCompletedButton(context),
                  SizedBox(height: 20),
                  _title(
                      completedPageType == TestCompletedPageType.Start
                          ? 'НАЧАЛЬНЫЙ ТЕСТ'
                          : 'ТЕСТ $testId',
                      const Color(0xff333333)),
                  SizedBox(height: 7),
                  _title('ВЫПОЛНЕН', const Color(0xff02af50)),
                  SizedBox(height: 25),
                  _answerWidget(
                      context,
                      'Правильные ответы - $correctAnswersCount',
                      '$_correctAnswersPercent%',
                      const Color(0xff02af50),
                      const Color(0xff5eef9f)),
                  SizedBox(height: 12),
                  _answerWidget(
                      context,
                      'Неправильные ответы - $wrongAnswersCount',
                      '$_wrongAnswersPercent%',
                      const Color(0xffa51d01),
                      const Color(0xffe41e1e)),
                  SizedBox(height: 25),
                  _continueButton(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
