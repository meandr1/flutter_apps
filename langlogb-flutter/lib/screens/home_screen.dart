import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/models/test_results.dart';
import 'package:lang_log_b/data/services/auth_service.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Common/alert.dart';
import 'market_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _email = '';
  var _isDerivativeOpen = false;

  @override
  void initState() {
    super.initState();
    _getEmail();
    _checkDerivativeOpen();
  }

  void _checkDerivativeOpen() async {
    if (AppSharedData().isLoggedIn == true) {
      final itemsArray = await RealtimeDatabaseService().getWordsTestsResults();
      _isDerivativeOpen = itemsArray.length >= 20;
      setState(() {});
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final testResultsNotSignedIn = prefs.getStringList('testsResults');
      _isDerivativeOpen = testResultsNotSignedIn.length >= 20;
      setState(() {});
    }
  }

  Widget _logoText() => RichText(
          text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff02af50),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 40.0),
            text: "L"),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 40.0),
            text: "ANG"),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xffa51d01),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 40.0),
            text: "L"),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 40.0),
            text: "OG"),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff4fafff),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 40.0),
            text: "B")
      ]));

  Widget _itemText(String firstString, String secondString) => RichText(
          text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
                color: const Color(0xffa51d01),
                fontWeight: FontWeight.w700,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            text: firstString),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w700,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
            text: secondString)
      ]));

  Widget _button(
          {BuildContext context,
          String titlePartOne,
          String titlePartTwo,
          String subtitlePartOne = '',
          String subtitlePartTwo = '',
          String imageName,
          int index,
          bool onTop = false,
          bool isOpen = false,
          Function action}) =>
      Container(
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        child: TextButton(
          child: Stack(
            children: [
              (isOpen == false
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.2), BlendMode.dstATop),
                      child: Image.asset(imageName, fit: BoxFit.fill),
                    )
                  : Image.asset(imageName, fit: BoxFit.fill)),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.width *
                            (onTop == true ? 0.1 : 0.35)),
                        left: 0,
                        bottom: 0,
                        right: 0),
                    alignment: Alignment.center,
                    child: _itemText(titlePartOne, titlePartTwo),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.center,
                    child: _itemText(subtitlePartOne, subtitlePartTwo),
                  ),
                ],
              ),
            ],
          ),
          onPressed: () {
            // LangLogBApp.analytics.logEvent(
            //     name: 'Главный_Кнопка_' + titlePartOne + titlePartTwo);
            action();
          },
        ),
        // ),
      );

  Widget _mainButtons(context) => Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _button(
                      context: context,
                      titlePartOne: 'И',
                      titlePartTwo: 'НСТРУКЦИЯ',
                      imageName: 'assets/home/home_instr_btn.png',
                      index: 1,
                      isOpen: true,
                      action: () {
                        Navigator.of(context).pushNamed('/instruction');
                      }),
                  _button(
                      context: context,
                      titlePartOne: 'Л',
                      titlePartTwo: 'ОГИЧЕСКИЙ',
                      subtitlePartOne: 'К',
                      subtitlePartTwo: 'ОНТЕКСТ',
                      imageName: 'assets/home/home_context_btn.png',
                      index: 2,
                      isOpen: true,
                      action: () {
                        Navigator.of(context).pushNamed('/systems');
                      }),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _button(
                      context: context,
                      titlePartOne: 'П',
                      titlePartTwo: 'РОИЗВОДНЫЕ',
                      onTop: true,
                      imageName: 'assets/home/home_no_active_btn.png',
                      index: 3,
                      isOpen: _isDerivativeOpen,
                      action: () {
                        if (_isDerivativeOpen == true)
                          Navigator.of(context)
                              .pushNamed('/derivativesSystems');
                        else
                          Alert.showAlert(
                              'Пройдите 20 тестов в Логическом контексте.');
                      }),
                  // _button(
                  //     context: context,
                  //     titlePartOne: 'З',
                  //     titlePartTwo: 'АКРЫТЬ',
                  //     onTop: true,
                  //     imageName: 'assets/home/home_close_btn.png',
                  //     index: 4,
                  //     isOpen: true,
                  //     action: () {
                  //       if (AppSharedData().userInfo == null) {
                  //         Alert.showAlert(
                  //             'Пожалуйста зарегистрирутесь чтобы управлять данными.');
                  //       } else {
                  //         showAlertDialog(context);
                  //       }
                  //     }),
                ],
              )
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2.7,
            top: MediaQuery.of(context).size.height / 5,
            child: Container(
                height: 100,
                child: Image.asset('assets/home/home_deco_red_circle.png')),
          ),
        ],
      );

  showAlertDialog(BuildContext context) {
    // LangLogBApp.analytics.logEvent(name: 'Главный_КнопкаВыход');
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Отмена"),
      onPressed: () {
        // LangLogBApp.analytics.logEvent(name: 'Главный_ОкноВыход_КнопкаОтмена');
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Выйти"),
      onPressed: () {
        // LangLogBApp.analytics.logEvent(name: 'Главный_ОкноВыход_КнопкаВыйти');
        AuthService authService = AuthService();
        authService.logOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthorizationPage()),
            ModalRoute.withName('/'));
        Alert.showAlert('Вы успешно вышли из учетной записи');
        setState(() {});
      },
    );

    var text = "Вы действительно хотите выйти из учетной записи?";

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(text),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user-email');
    if (savedEmail != null) {
      _email = savedEmail;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/backgrounds/home_background.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 45.0, bottom: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_email,
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                            textAlign: TextAlign.center),
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          child: TextButton(
                            child: Image.asset(
                              'assets/icons/icon-logout.png',
                              fit: BoxFit.fill,
                            ),
                            onPressed: () {
                              if (_email != null && _email.length > 0) {
                                showAlertDialog(context);
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AuthorizationPage()),
                                    ModalRoute.withName('/'));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: TextButton(
                      child: Image.asset(
                        'assets/buttons/market-button.png',
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {

                        // LangLogBApp.analytics
                        //     .logEvent(name: 'Главный_КнопкаКупитьПремиум');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MarketPage()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Text("ПРИВЕТСТВУЕМ В",
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
            _logoText(),
            _mainButtons(context),
            SizedBox(height: 50),
            Text('Copyright  ©  V.G.Batyuk, 2021.'),
          ],
        ),
      ),
    );
  }
}
