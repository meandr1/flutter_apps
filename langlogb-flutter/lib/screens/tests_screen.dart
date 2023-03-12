import 'package:flutter/material.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/models/test_results.dart';
import 'package:lang_log_b/data/models/user.dart';
import 'package:lang_log_b/screens/market_page.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/Common/texts.dart';
import 'package:lang_log_b/screens/base-screen.dart';
import 'package:lang_log_b/screens/test_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../main.dart';
import 'Common/buttons.dart';
import 'common/alert.dart';
import 'common/top-panel.dart';

enum TestType {
  Tests,
  Controls,
  TestsResults,
  ControlsResults
}

class TestsPage extends StatefulWidget {
  final TestType testType;
  final PageType pageType;

  TestsPage(
      {this.pageType = PageType.LogicalContext, this.testType = TestType.Tests});

  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  var _itemsArray = List<TestResults>();
  bool _isPremium = false;

  void _premium() async {
    final premium = await AppSharedData().isPremium();
    if (_isPremium != premium) {
      setState(() {
        _isPremium = premium;
      });
    }
  }

  void initState() {
    super.initState();
    _loadItems();
  }

  Widget _systemCell({int index, bool isEnabled, bool isPassed, BuildContext context}) {
    return Column(
      children: [
        LLCellShadowRoundedButton(index, isEnabled, () {
          // LangLogBApp.analytics.logEvent(name: screenName() + '_Тест_' + index.toString() + '_Премиум');
      // if (index < 4 || _isPremium == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                TestPage(
                  isPassed: isPassed,
                  testType: widget.testType,
                  pageType: widget.pageType,
                  testId: index,
                )));
      // } else {
      //   LangLogBApp.analytics.logEvent(name: screenName() + '_Тест_' + index.toString() + '_Купить');
      //   Alert.showAlert('Тест доступен только после покупки.');
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) =>
      //           MarketPage()));
      // }
        }),
        SizedBox(height: 7),
        ButtonTheme(
          minWidth: 29,
          height: 17,
          child: TextButton(
              child: Image.asset(
                  (isPassed
                      ? "assets/icons/cell-hat-enabled.png"
                      : "assets/icons/cell-hat-disabled.png"),
                  fit: BoxFit.fill),
              onPressed: (isPassed ? () {
                var result = _itemsArray.firstWhere((element) => element.testId == index);
                // LangLogBApp.analytics.logEvent(name: screenName() + '_ТестПоСловарю_' + index.toString());
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TestPage(
                      results: result.wordsIds,
                      isPassed: isPassed,
                      testType: widget.testType == TestType.Tests ? TestType.TestsResults : TestType.ControlsResults,
                      pageType: widget.pageType,
                      testId: index,
                    )));
              } : null)),
        ),
      ],
    );
  }

  Widget _systemsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      padding: EdgeInsets.only(top: 10, left: 20, bottom: 0, right: 20),
      crossAxisSpacing: 7,
      mainAxisSpacing: 5,
      childAspectRatio: 0.55,
      children: List.generate(widget.testType == TestType.Tests ? (widget.pageType == PageType.LogicalContext ? 31 : 28) : 6, (index) {
        final textIndex = index + 1;
        var items = null;
        if (_itemsArray != null && _itemsArray.isNotEmpty) {
          items = _itemsArray.where((element) => element.testId == textIndex).toList() ?? null;
        }
        return _systemCell(index: textIndex, isEnabled: true, isPassed: (items != null && items.length > 0), context: context);
      }),
    );
  }

  void _loadItems() async {
    if (AppSharedData().isLoggedIn == true) {
      if (widget.testType == TestType.Tests) {
        _itemsArray = widget.pageType == PageType.LogicalContext
            ? await RealtimeDatabaseService().getWordsTestsResults()
            : await RealtimeDatabaseService().getDerivativesTestsResults();
      } else {
        _itemsArray = widget.pageType == PageType.LogicalContext
            ? await RealtimeDatabaseService().getWordsControlsResults()
            : await RealtimeDatabaseService().getDerivativesControlsResults();
      }
      setState(() {});
    }
  }

  String screenName() {
    var name = '';
    switch (widget.testType) {
      case TestType.Controls:
        name = 'Controls';
        break;
      case TestType.TestsResults:
        name = 'TestsResults';
        break;
      case TestType.ControlsResults:
        name = 'ControlsResults';
        break;
      default:
        name = 'Tests';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    _premium();
    return Material(
      child: Stack(
        children: <Widget>[
          BasePage(index: widget.testType == TestType.Tests ? 1 : 3, type: widget.pageType),
          Padding(
            padding: const EdgeInsets.only(top: 105.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (widget.testType == TestType.Tests
                    ? LLTitleText(first: 'Т', second: 'ЕСТЫ')
                    : LLTitleText(first: 'К', second: 'ОНТРОЛЬ')),
                Expanded(child: _systemsGrid(context))
              ],
            ),
          )
        ],
      ),
    );
  }
}
