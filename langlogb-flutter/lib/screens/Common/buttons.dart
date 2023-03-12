import 'package:flutter/material.dart';

class LLButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color titleColor;
  final Color backgroundColor;

  LLButton(
      {@required this.text,
      @required this.titleColor,
      @required this.backgroundColor,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
      width: MediaQuery.of(context).size.width - 24,
      height: 35,
      decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
        BoxShadow(
          color: Color(0x3302589f),
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ]),
      child: TextButton(
        child: Text(text,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 10,
            )),
        onPressed: onPressed,
      ),
    );
  }
}

class LLTopBarButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color titleColor;
  final Color backgroundColor;
  final Color borderColor;

  LLTopBarButton(
      {@required this.text,
      @required this.titleColor,
      @required this.backgroundColor,
      this.borderColor = Colors.transparent,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Color(0x3302589f),
              spreadRadius: 0,
              blurRadius: 60,
            ),
          ]),
      child: TextButton(
        child: Text(text,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 10,
            )),
        onPressed: onPressed),
    );
  }
}

class LLCellShadowRoundedButton extends StatelessWidget {
  final bool isEnabled;
  final int index;
  final Function action;

  LLCellShadowRoundedButton(
    this.index,
    this.isEnabled,
    this.action,
  );

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 45,
      height: 45,
      child: TextButton(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(0),
                height: 45,
                width: 45,
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
                      blurRadius: 7,
                    ),
                  ],
                ),
              ),
              Image.asset(
                  (isEnabled
                      ? "assets/buttons/cell-enabled.png"
                      : "assets/buttons/cell-disabled.png"),
                  fit: BoxFit.fill),
              Container(
                  padding:
                      EdgeInsets.only(top: 13, left: 5, bottom: 5, right: 5),
                  width: 45,
                  child: Text('$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (isEnabled ? Color(0xff447bfd) : Colors.black),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ))),
            ],
          ),
          onPressed: (isEnabled ? action : null)),
    );
  }
}

class LLSoundButton extends StatelessWidget {
  final bool isActive;
  final Function action;

  LLSoundButton({this.isActive = true, @required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 26,
        height: 26,
        child: TextButton(
          child: Image.asset(
            'assets/buttons/speaker-button.png',
            fit: BoxFit.fill,
          ),
          onPressed: action,
        ));
  }
}
