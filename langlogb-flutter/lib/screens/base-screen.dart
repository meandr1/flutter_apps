import 'package:flutter/material.dart';
import 'package:lang_log_b/screens/common/top-panel.dart';

class BasePage extends StatelessWidget {
  final index;
  final PageType type;
  BasePage({@required this.index, @required this.type });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/backgrounds/main-background.png'),
                fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            LLTopPanel(index: index, type: type,),
          ],
        ),
      ),
    );
  }
}
