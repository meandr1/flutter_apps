import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
import 'package:lang_log_b/data/models/word.dart';
import 'package:lang_log_b/screens/common/blink_button.dart';
import '../system_screen.dart';

enum SystemListItemType { fullTranslation, testTranslation }

class SystemListItem extends StatelessWidget {
  final Word word;
  final double columnWidth;
  final SystemListItemType type;
  final SystemPageType pageType;

  SystemListItem(this.word,
      {this.columnWidth = 80,
      this.type = SystemListItemType.fullTranslation,
      this.pageType = SystemPageType.LogicalContextSystem});

  TextStyle _columnTextStyle({Color color = const Color(0xff092330)}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 11.0);

  @override
  Widget build(BuildContext context) {
    final double leftPadding = 15;
    return Container(
        padding: const EdgeInsets.all(0.0),
        child: Row(children: [
          SizedBox(
              width: columnWidth + leftPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 2),
                  (pageType == SystemPageType.Dialog
                      ? Flexible(
                    child: Html(data: word.firstWord,
    // style: {
                    //   "body": Style(
                    //       fontFamily: 'Montserrat',
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: FontSize(11.0),
                    //       fontStyle: FontStyle.normal,
                    //       color: const Color(0xff092330),
                    //       margin: EdgeInsets.only(
                    //           top: 0, bottom: 0, left: 15, right: 0)),
                    // },
                    ),
                  )
                      : Text(word.firstWord != null ? word.firstWord : '',
                      style: _columnTextStyle(), textAlign: TextAlign.right)),
                  Text(
                      (word.firstWord.length > 0 && word.secondWord.length > 0)
                          ? '|'
                          : '',
                      style: _columnTextStyle(color: const Color(0xff02af50)),
                      textAlign: TextAlign.right),
                  Text(word.secondWord.length > 0 ? word.secondWord : '',
                      style: _columnTextStyle(), textAlign: TextAlign.right),
                ],
              )),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Align(
                alignment: Alignment.topLeft,
                child: (type == SystemListItemType.fullTranslation
                    ? Html(data: word.translation,
                    // style: {
                    //     "body": Style(
                    //         fontFamily: 'Montserrat',
                    //         // fontSize: FontSize(11.0),
                    //         color: Colors.blueAccent,
                    //         margin: EdgeInsets.only(top: 0, bottom: 0))
                    //   }
                      )
                    : Text(word.testTranslation,
                        style: const TextStyle(
                            color: const Color(0xff092330),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0),
                        textAlign: TextAlign.left))),
          ),
          SizedBox(
            width: 5,
          ),
          /*
        Uncomment to show transcryption

          SizedBox(
              width: 80.0,
              child: Text(word.transcryption,
                  style: const TextStyle(
                      color: const Color(0xff092330),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.normal,
                      fontSize: 10.0),
                  textAlign: TextAlign.left)),
          */
        ]));
  }
}
