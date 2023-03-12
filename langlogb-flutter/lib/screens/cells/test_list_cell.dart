import 'package:flutter/material.dart';

class TestListItem extends StatelessWidget {
  final String text;
  bool selected;

  TestListItem({this.text, this.selected = false});

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
              height: 67,
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x3302589f),
                        offset: Offset(0, 0),
                        blurRadius: 60,
                        spreadRadius: 0)
                  ],
                  gradient: (selected
                      ?
                  LinearGradient(
                          begin: (selected
                              ? Alignment.centerLeft
                              : Alignment(0, 0)),
                          end: (selected
                              ? Alignment.centerRight
                              : Alignment(0, 0)),
                          colors: [const Color(0xffffffff),
                              const Color(0xffe7f3f9),
                            ])
                      : null)),
              child: Row(
                children: [
                  Image.asset(selected
                      ? 'assets/icons/test_cell_selected_icon.png'
                      : 'assets/icons/test_cell_unselected_icon.png'),
                  Text(text,
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left)
                ],
              )),
        ],
      );
}
