import 'package:flutter/material.dart';
import 'package:lang_log_b/main.dart';

enum PageType {
  LogicalContext,
  Derivatives,
}

class LLTopPanel extends StatelessWidget {
  final int index;
  final PageType type;

  LLTopPanel({@required this.index, @required this.type});

  Widget _topPanelButton(String text, bool selected, void action()) {
    return SizedBox(
      width: 62,
      child: TextButton(
        child: Column(children: <Widget>[
          SizedBox(
              child: Image.asset((selected
                  ? "assets/icons/point-selected.png"
                  : "assets/icons/point.png")),
              height: 6),
          SizedBox(height: 6),
          Text(text,
              style: TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 10)),
        ]),
        onPressed: () {
          // LangLogBApp.analytics.logEvent(name: 'Навигация_Кнопка_' + text);
          action();
        },
      ),
    );
  }

  Widget _topPanel(BuildContext context, int index) {
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.only(left: 15, right: 0),
          child: Image.asset("assets/backgrounds/toppanel-background.png",
              fit: BoxFit.fill)),
      Container(
        padding: EdgeInsets.only(top: 3, left: 20, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Container(
                padding: EdgeInsets.only(left: 0),
                height: 65,
                width: 65,
                child: TextButton(
                  child: Image.asset("assets/buttons/home-button.png",
                      fit: BoxFit.fill),
                  onPressed: () {
                    // LangLogBApp.analytics.logEvent(name: 'Навигация_Кнопка_Домой');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', ModalRoute.withName('/'));
                  },
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _topPanelButton('СИСТЕМА', index == 0, () {
                  switch (type) {
                    case PageType.LogicalContext:
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/systems', ModalRoute.withName('/home'));
                      break;
                    case PageType.Derivatives:
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/derivativesSystems', ModalRoute.withName('/home'));
                      break;
                  }
                }),
                _topPanelButton('ТЕСТЫ', index == 1, () {
                  switch (type) {
                    case PageType.LogicalContext:
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/tests', ModalRoute.withName('/home'));
                      break;
                    case PageType.Derivatives:
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/derivativesTests', ModalRoute.withName('/home'));
                      break;
                  }
                }),
                (type == PageType.LogicalContext
                    ? _topPanelButton('ПРИМЕРЫ', index == 2, () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/dialogs', ModalRoute.withName('/home'));
                      })
                    : SizedBox()),
                _topPanelButton('КОНТРОЛЬ', index == 3, () {
                  switch (type) {
                    case PageType.LogicalContext:
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/controls', ModalRoute.withName('/home'));
                      break;
                    case PageType.Derivatives:
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/derivativesControls', ModalRoute.withName('/home'));
                      break;
                  }
                }),
                SizedBox(width: 0),
              ],
            ),
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _topPanel(context, index);
  }
}
