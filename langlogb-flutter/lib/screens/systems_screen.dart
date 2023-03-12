import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/models/user.dart';
import 'package:lang_log_b/screens/market_page.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/base-screen.dart';
import 'package:lang_log_b/screens/common/top-panel.dart';
import 'package:lang_log_b/screens/phonetics_screen.dart';
import 'package:lang_log_b/screens/system_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../main.dart';
import 'Common/buttons.dart';
import 'common/alert.dart';

class SystemsPage extends StatefulWidget {
  final SystemPageType pageType;
  SystemsPage({this.pageType = SystemPageType.LogicalContextSystem});

  @override
  _SystemsPageState createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> {
  bool _isPremium = false;

  void _premium() async {
    final premium = await AppSharedData().isPremium();
    if (_isPremium != premium) {
      setState(() {
        _isPremium = premium;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _titleText() {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          style: const TextStyle(
              color: const Color(0xffa51d01),
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          text: "Р"),
      TextSpan(
          style: const TextStyle(
              color: const Color(0xff333333),
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          text: "ЕФЛЕКСИВНАЯ "),
      TextSpan(
          style: const TextStyle(
              color: const Color(0xff02af50),
              fontWeight: FontWeight.w900,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          text: "С"),
      TextSpan(
          style: const TextStyle(
              color: const Color(0xff333333),
              fontWeight: FontWeight.w900,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          text: "ИСТЕМА")
    ]));
  }

  Widget _systemCell(int index, BuildContext context) {
    bool isActive = true;
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 45),
          child: ButtonTheme(
            minWidth: 36,
            height: 36,
            child: TextButton(
                child: Image.asset(
                    (isActive
                        ? "assets/buttons/cell-speaker-enabled.png"
                        : "assets/buttons/cell-speaker-disabled.png"),
                    fit: BoxFit.fill),
                onPressed: () {
                  var screenName =
                      widget.pageType == SystemPageType.DerivativesSystem
                          ? 'Производные'
                          : 'Логический контекст';
                  // if (index < 4 || _isPremium) {
                  //   LangLogBApp.analytics.logEvent(
                  //       name: screenName +
                  //           '_Фонетика_' +
                  //           index.toString() +
                  //           '_Премиум');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhoneticsPage(
                            index: index,
                            type: widget.pageType ==
                                    SystemPageType.DerivativesSystem
                                ? PageType.Derivatives
                                : PageType.LogicalContext)));
                  // } else {
                  //   LangLogBApp.analytics.logEvent(
                  //       name: screenName +
                  //           '_Фонетика_' +
                  //           index.toString() +
                  //           '_Купить');
                  //   Alert.showAlert('Система доступна только после покупки.');
                  //   Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (context) => MarketPage()));
                  // }
                }),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: LLCellShadowRoundedButton(index, isActive, () {
              var screenName =
                  widget.pageType == SystemPageType.DerivativesSystem
                      ? 'Производные'
                      : 'ЛогическийКонтекст';
              // if (index < 4 || _isPremium) {
              //   LangLogBApp.analytics.logEvent(
              //       name: screenName +
              //           '_Контекст' +
              //           index.toString() +
              //           '_Премиум');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SystemPage(index: index, pageType: widget.pageType)));
              // } else {
              //   LangLogBApp.analytics.logEvent(
              //       name: screenName +
              //           '_Контекст_' +
              //           index.toString() +
              //           '_Купить');
              //   Alert.showAlert('Система доступна только после покупки.');
              //   Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context) => MarketPage()));
              // }
            }))
      ],
    );
  }

  Widget _systemsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      padding: EdgeInsets.only(top: 10, left: 20, bottom: 0, right: 20),
      crossAxisSpacing: 7,
      mainAxisSpacing: 5,
      childAspectRatio: 0.5,
      children: List.generate(
          widget.pageType == SystemPageType.LogicalContextSystem ? 31 : 28,
          (index) {
        return _systemCell(index + 1, context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _premium();
    return Material(
      child: Stack(
        children: <Widget>[
          BasePage(
              index: 0,
              type: widget.pageType == SystemPageType.LogicalContextSystem
                  ? PageType.LogicalContext
                  : PageType.Derivatives),
          Padding(
            padding: const EdgeInsets.only(top: 105.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: _titleText()),
                Expanded(child: _systemsGrid(context))
              ],
            ),
          )
        ],
      ),
    );
  }
}
