import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/models/user.dart';
import 'package:lang_log_b/data/services/auth_service.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/Common/buttons.dart';

import 'common/alert.dart';

class AuthorizationPage extends StatefulWidget {
  bool showLogin = true;
  AuthorizationPage({Key key, this.showLogin = true}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  AuthService _authService = AuthService();

  void _loginButtonAction() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Alert.showAlert("Не удалось войти! Проверьте Ваш Имейл и Пароль.");
      return;
    }
    LLUser user = await _authService.signInWithEmailAndPassword(
        email.trim(), password.trim());
    if (user == null) {
      Alert.showAlert("Не удалось войти! Проверьте Ваш Имейл и Пароль.");
      return;
    } else {
    }Navigator.of(context).pushNamedAndRemoveUntil(
        '/home', ModalRoute.withName('/'));
  }

  void _registerButtonAction() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final repeatPassword = _repeatPasswordController.text;

    if (password != repeatPassword) {
      Alert.showAlert('Пароли не совпадают! Введите еще раз.');
      return;
    }

    LLUser user = await _authService.registerWithEmailAndPassword(
        email.trim(), password.trim());
    if (user == null) {
      Alert.showAlert(
          "Не удалось зарегистрироваться. Проверьте Ваш Имейл и Пароль.");
    } else {
      RealtimeDatabaseService().createUser(user.id, user.firebaseUser.email);
      await user.firebaseUser.sendEmailVerification();
      // AppSharedData().userInfo = await RealtimeDatabaseService().getUserInfo();
      Alert.showAlert("Вы успешно зарегистрировались.");
      if (AppSharedData().isSecondStart == true) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/instruction');
      }
    }
  }

  Widget _bottomPanel() => Container(
        padding: EdgeInsets.only(bottom: 10),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _underlineButton('У Вас нет аккаунта?', Color(0xff4fafff), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthorizationPage(
                          showLogin: false,
                        )),
              );
            }),
            _underlineButton('Регистрация', Color(0xff4fafff), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthorizationPage(
                    showLogin: false,
                  ),
                ),
              );
            }),
          ],
        ),
      );

  Widget _input(String hint, TextEditingController controller, bool obscure) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Color(0x3302589f), spreadRadius: 1, blurRadius: 7),
        ],
      ),
      height: 35,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 12,
            color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 12,
              color: Color(0xff333333)),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _underlineButton(String title, Color titleColor, void action()) {
    return TextButton(
      child: Text(title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w700,
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.center),
      onPressed: () {
        action();
      },
    );
  }

  Widget _form(void func()) {
    final margin = MediaQuery.of(context).size.width * 0.04;
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color(0x3302589f),
                spreadRadius: 2,
                blurRadius: 35,
              ),
            ],
            image: DecorationImage(
                image: AssetImage('assets/backgrounds/form_background.png'),
                fit: BoxFit.fill)),
        child: Column(
          children: <Widget>[
            SizedBox(height: margin * 1.7),
            _input('E-mail', _emailController, false),
            SizedBox(height: margin),
            _input('Пароль', _passwordController, true),
            SizedBox(height: widget.showLogin ? margin / 2 : margin),
            (widget.showLogin
                ? _underlineButton('Забыли пароль?', Color(0xff4fafff),
                    () async {
                    _authService.resetPasswordWithEmail(_emailController.text);
                    Alert.showAlert(
                        'Письмо со ссылкой на восстановление паролья отправлено на почту.');
                  })
                : _input('Повторите Пароль', _repeatPasswordController, true)),
            SizedBox(height: widget.showLogin ? margin / 2 : margin),
            LLButton(
                text: widget.showLogin ? 'ВХОД' : 'РЕГИСТРАЦИЯ',
                titleColor: Color(0xffffffff),
                backgroundColor: Color(0xff02af50),
                onPressed: func),
            SizedBox(height: margin * 1.7),
          ],
        ),
      ),
    );
  }

  Widget _enterText(String firstPart, String secondPart) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          style: const TextStyle(
              color: const Color(0xff02af50),
              fontWeight: FontWeight.w900,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          text: firstPart),
      TextSpan(
          style: const TextStyle(
              color: const Color(0xff333333),
              fontWeight: FontWeight.w900,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          text: secondPart)
    ]));
  }

  Widget _descriptionText(String text) {
    return Text(text,
        style: const TextStyle(
            color: const Color(0xff092330),
            fontWeight: FontWeight.w400,
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 10),
        textAlign: TextAlign.center);
  }

  Widget _skipButton() => SizedBox(
      width: 190,
      child: LLButton(
          text: 'ПРОПУСТИТЬ',
          titleColor: Color(0xff00ad5d),
          backgroundColor: Color(0xffffffff),
          onPressed: () {
            if (AppSharedData().isSecondStart == true) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              Navigator.of(context).pushReplacementNamed('/instruction');
            }
          }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/backgrounds/home_background.png'),
                    fit: BoxFit.cover)),
            child: (widget.showLogin
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 120),
                      _enterText('В', 'ХОД'),
                      SizedBox(height: 9),
                      _descriptionText(
                          "Пожалуйста введите Ваши данные чтобы продолжить"),
                      SizedBox(height: 25),
                      _form(_loginButtonAction),
                      Expanded(child: SizedBox(height: 0)),
                      Expanded(child: _bottomPanel()),
                      // _bottomPanel(),
                      _skipButton(),
                      SizedBox(height: 10)
                    ],
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(height: 120),
                      _enterText('Р', 'ЕГИСТРАЦИЯ'),
                      SizedBox(height: 9),
                      _descriptionText(
                          "Пожалуйста введите Ваши данные чтобы продолжить"),
                      SizedBox(height: 25),
                      _form(_registerButtonAction)
                    ],
                  ))));
  }
}
