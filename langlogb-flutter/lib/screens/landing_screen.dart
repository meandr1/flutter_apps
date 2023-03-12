import 'package:flutter/material.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/database/database-helper.dart';
import 'package:lang_log_b/data/models/user.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/instruction_screen.dart';
import 'package:lang_log_b/screens/login_screen.dart';
import 'package:lang_log_b/screens/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isSecondStart = false;

  void _checkFirstStart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isSecondStart = prefs.getBool('isSecondStart');
    if (isSecondStart == null || isSecondStart == false) {
      prefs.setBool('isSecondStart', true);
      _isSecondStart = false;
    } else {
      _isSecondStart = true
;    }
    setState(() {
    });
  }

  void _getUserDetail() async {
    // if (AppSharedData().isLoggedIn == true) {
    //   AppSharedData().userInfo = await RealtimeDatabaseService().getUserInfo();
    // }
}

  @override
  void initState() {
    super.initState();
    _checkFirstStart();
    _getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    final LLUser user = Provider.of<LLUser>(context);
    bool _isLoggedIn = user != null;
    // AppSharedData().isLoggedIn = _isLoggedIn;
    // AppSharedData().isSecondStart = _isSecondStart;
    // return _isLoggedIn ? (_isSecondStart ? HomePage() : InstructionPage()) : AuthorizationPage();
    return HomePage();
  }
}
