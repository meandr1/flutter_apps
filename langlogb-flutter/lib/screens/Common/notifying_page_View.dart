import 'package:flutter/material.dart';

class NotifyingPageView extends StatefulWidget {
  final ValueNotifier<double> notifier;

  const NotifyingPageView({Key key, this.notifier}) : super(key: key);

  @override
  _NotifyingPageViewState createState() => _NotifyingPageViewState();
}

class _NotifyingPageViewState extends State<NotifyingPageView> {
  int _previousPage;
  PageController _pageController;

  void _onScroll() {
    if (_pageController.page.toInt() == _pageController.page) {
      _previousPage = _pageController.page.toInt();
    }
    widget.notifier?.value = _pageController.page - _previousPage;
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0
    )..addListener(_onScroll);

    _previousPage = _pageController.initialPage;
    super.initState();
  }

  List<Widget> _pages; //pages generation omitted for the sake of brevity

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: _pages,
      controller: _pageController,
    );
  }
}