import 'package:flutter/material.dart';

class LLTitleText extends StatelessWidget {
  final String first;
  final String second;
  final Alignment alignment;

  LLTitleText(
      {this.first = '', this.second = '', this.alignment = Alignment.topLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff02af50),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 20.0),
            text: first),
        TextSpan(
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat",
                fontStyle: FontStyle.normal,
                fontSize: 20.0),
            text: second)
      ])),
    );
  }
}

class LLCenterSmallTitle extends StatelessWidget {
  final String text;

  LLCenterSmallTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x4d02589f),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0),
            ],
            color: const Color(0xffffffff)),
        child: Text(
          text,
          style: const TextStyle(
              color: const Color(0xff333333),
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 10.0),
        ),
        // )
      ),
    );
  }
}
