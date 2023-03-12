


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlinkButton extends StatefulWidget {
  @override
  _BlinkButtonState createState() => _BlinkButtonState();
}

class _BlinkButtonState extends State<BlinkButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        width: 3,
        height: 3,
        child: MaterialButton(
          onPressed: () => null,
          child: Text(""),
          color: Color(0xFFCA1C12)
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}