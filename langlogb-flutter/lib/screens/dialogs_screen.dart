import 'package:flutter/material.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/screens/market_page.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/Common/texts.dart';
import 'package:lang_log_b/screens/base-screen.dart';
import 'package:lang_log_b/screens/common/top-panel.dart';
import 'package:lang_log_b/screens/system_screen.dart';
import 'dart:math';
import 'Common/buttons.dart';
import 'common/alert.dart';

class DialogsPage extends StatefulWidget {
  @override
  _DialogsPageState createState() => _DialogsPageState();
}

class _DialogsPageState extends State<DialogsPage> {
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

  @override
  Widget build(BuildContext context) {
    _premium();
    Widget _systemCell(int index) {
      bool isActive = true;
      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: LLCellShadowRoundedButton(index, isActive, () {
            // if (index < 4 || _isPremium == true) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SystemPage(
                      index: index, pageType: SystemPageType.Dialog)));
            // } else {
            //   Alert.showAlert('Тест доступен только после покупки.');
            //   Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) =>
            //           MarketPage()));
            // }
          }));
    }

    Widget _systemsGrid() {
      return GridView.count(
        crossAxisCount: 7,
        padding: EdgeInsets.only(top: 10, left: 20, bottom: 0, right: 20),
        crossAxisSpacing: 7,
        mainAxisSpacing: 25,
        // childAspectRatio: 0.6,
        children: List.generate(31, (index) {
          return _systemCell(index + 1);
        }),
      );
    }

    return Material(
      child: Stack(
        children: <Widget>[
          BasePage(
            index: 2,
            type: PageType.LogicalContext,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 105.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LLTitleText(first: 'П', second: 'РИМЕРЫ'),
                Expanded(child: _systemsGrid())
              ],
            ),
          )
        ],
      ),
    );
  }
}
