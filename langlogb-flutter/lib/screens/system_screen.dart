import 'package:flutter/material.dart';
import 'package:lang_log_b/data/models/word.dart';
import 'package:lang_log_b/screens/base-screen.dart';
import 'package:lang_log_b/screens/cells/system-list-item.dart';
import 'package:lang_log_b/screens/common/buttons.dart';
import 'package:lang_log_b/data/database/database-helper.dart';
import '../main.dart';
import 'common/top-panel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

enum SystemPageType { LogicalContextSystem, Dialog, DerivativesSystem }

class SystemPage extends StatefulWidget {
  final index;
  final SystemPageType pageType;

  SystemPage(
      {this.pageType = SystemPageType.LogicalContextSystem, this.index = 0});

  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  var _firstPageWords = List<Word>();
  var _secondPageWords = List<Word>();
  final _widthsMap = Map<int, double>();
  var _isFirstPage = true;
  PageController _pageController;

  TextStyle columnTextStyle({Color color = const Color(0xff092330)}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 10.0);

  void _readWords() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    switch (widget.pageType) {
      case SystemPageType.LogicalContextSystem:
        final words = await helper.queryWordsForSystem(widget.index);
        _firstPageWords = words.where((word) => word.pageId == 1).toList();
        _secondPageWords = words.where((word) => word.pageId == 2).toList();
        break;
      case SystemPageType.Dialog:
        final words = await helper.queryDialogsForSystem(widget.index);
        _firstPageWords = words.sublist(0, (words.length + 0.5) ~/ 2);
        _secondPageWords = words.sublist((words.length + 0.5) ~/ 2 + 1);
        break;
      case SystemPageType.DerivativesSystem:
        final words = await helper.queryDerivativesForSystem(widget.index);
        _firstPageWords = words.where((word) => word.pageId == 1).toList();
        _secondPageWords = words.where((word) => word.pageId == 2).toList();
        break;
    }
    setState(() {});
  }

  Size _textWidgetSize(String text, BuildContext context) => (TextPainter(
          text: TextSpan(text: text, style: columnTextStyle()),
          maxLines: 1,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;

  double _maxWidthForCategory(int categoryId, BuildContext context) {
    final allWords = _firstPageWords + _secondPageWords;
    final categoryWords =
        allWords.where((word) => word.categoryId == categoryId).toList();
    double maxWidth = 0;
    for (var word in categoryWords) {
      final width = _textWidgetSize(word.fullWord() + '|', context).width;
      if (width > maxWidth) {
        maxWidth = width + 10;
      }
    }
    final screenWidth = MediaQuery.of(context).size.width;
    return maxWidth > screenWidth / 2.5 ? screenWidth / 2.5 : maxWidth;
  }

  void _calculateFirstColumnWidth(BuildContext context) {
    final allWords = _firstPageWords + _secondPageWords;
    final categoriesSet = Set();
    for (var word in allWords) {
      categoriesSet.add(word.categoryId);
    }
    for (var categoryId in categoriesSet) {
      _widthsMap[categoryId] = _maxWidthForCategory(categoryId, context);
    }
  }

  @override
  void initState() {
    _readWords();
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  TextStyle _blueTextStyle() => TextStyle(
      color: const Color(0xff447bfd),
      fontWeight: FontWeight.w500,
      fontFamily: "Montserrat",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);

  Widget _navigationButton(String title, Function onPressed) => ButtonTheme(
      height: 20,
      minWidth: 20,
      child: TextButton(
        child: Text(title, style: _blueTextStyle()),
        onPressed: () {},
      ));

  Widget _navigationRow() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _navigationButton('Логический контекст', () {}),
          Text(' •', style: _blueTextStyle()),
          _navigationButton('Система', () {}),
          Text(' • ', style: _blueTextStyle()),
          Text(
              _isFirstPage == true
                  ? 'Страница ${widget.index} /1'
                  : 'Страница ${widget.index}/2',
              style: const TextStyle(
                  color: const Color(0xff092330),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0))
        ],
      );

  //TODO: Uncomment to show navigation buttons on top
  // Widget _buttonsRow() => Stack(
  //       children: [
  //         Container(
  //             padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
  //             width: MediaQuery.of(context).size.width,
  //             child: Image.asset('assets/line.png', fit: BoxFit.fill)),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             // Uncomment to show round with -e inside
  //             //LLCenterSmallTitle('-e'),
  //             Spacer(),
  //             // (widget.pageType == SystemPageType.System ? LLSoundButton(action: () {}) : SizedBox()),
  //             SizedBox(width: 14),
  //             Container(
  //                 width: 26,
  //                 height: 26,
  //                 child: FlatButton(
  //                   padding: const EdgeInsets.all(0),
  //                   child: Image.asset(
  //                     'assets/buttons/printer-button.png',
  //                     fit: BoxFit.fill,
  //                   ),
  //                   onPressed: () {},
  //                 ))
  //           ],
  //         ),
  //       ],
  //     );

  Widget _dividerForIndex(int index, List<Word> words) {
    final item = words[index];
    if (index + 1 < words.length) {
      final nextItem = words[index + 1];
      if (nextItem.categoryId != item.categoryId) {
        return Divider(
          color: Colors.grey, // (0xffb8ddf1),
          height: 13,
        );
      }
    }
    return SizedBox();
  }

  //MARK: - Scroll
  void _toStart() {
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      _isFirstPage = true;
    });
  }

  void _toEnd() {
    _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      _isFirstPage = false;
    });
  }
  //MARK: -

  Widget _contentRow() => Container(
        width: MediaQuery.of(context).size.width - 2 * 15,
        height: MediaQuery.of(context).size.height - 140,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3302589f),
                spreadRadius: 2,
                blurRadius: 7,
              )
            ]),
        child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return ListView.separated(
                    separatorBuilder: (context, index) =>
                        _dividerForIndex(index, _firstPageWords),
                    itemCount: _firstPageWords.length,
                    itemBuilder: (context, index) {
                      return SystemListItem(_firstPageWords[index],
                          columnWidth:
                              _widthsMap[_firstPageWords[index].categoryId],
                          pageType: widget.pageType);
                    });
              } else {
                return ListView.separated(
                    separatorBuilder: (context, index) =>
                        _dividerForIndex(index, _secondPageWords),
                    itemCount: _secondPageWords.length,
                    itemBuilder: (context, index) {
                      return SystemListItem(_secondPageWords[index],
                          columnWidth:
                              _widthsMap[_secondPageWords[index].categoryId],
                          pageType: widget.pageType);
                    });
              }
            }),

        //       GridView.builder(
        //           gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, crossAxisSpacing: 0, mainAxisSpacing: 0),
        //           itemCount: 2,
        //           controller: _scrollController,
        //           scrollDirection: Axis.horizontal,
        //           itemBuilder: (BuildContext context, int index) {
        //       if (index == 0) {
        //        return ListView.separated(
        //                       separatorBuilder: (context, index) =>
        //                           _dividerForIndex(index, _firstPageWords),
        //                       itemCount: _firstPageWords.length,
        //                       itemBuilder: (context, index) {
        //                         return SystemListItem(_firstPageWords[index],
        //                             columnWidth:
        //                                 _widthsMap[_firstPageWords[index].categoryId],
        //                             pageType: widget.pageType);
        //                       });
        //       } else {
        //         return ListView.separated(
        //                       separatorBuilder: (context, index) =>
        //                           _dividerForIndex(index, _secondPageWords),
        //                       itemCount: _secondPageWords.length,
        //                       itemBuilder: (context, index) {
        //                         return SystemListItem(_secondPageWords[index],
        //                             columnWidth:
        //                                 _widthsMap[_secondPageWords[index].categoryId],
        //                             pageType: widget.pageType);
        //                       });
        //       }
        // }),

        // GridView.count(
        //   physics: const NeverScrollableScrollPhysics(),
        //   childAspectRatio: (MediaQuery.of(context).size.height/(MediaQuery.of(context).size.width)), //((MediaQuery.of(context).size.width-30)/(MediaQuery.of(context).size.height-140)),
        //   scrollDirection: Axis.horizontal,
        //   // shrinkWrap: true,
        //   crossAxisCount: 1,
        //   crossAxisSpacing: 0,
        //   mainAxisSpacing: 0,
        //   controller: _scrollController,
        //   children: [
        //       ListView.separated(
        //           separatorBuilder: (context, index) =>
        //               _dividerForIndex(index, _firstPageWords),
        //           itemCount: _firstPageWords.length,
        //           itemBuilder: (context, index) {
        //             return SystemListItem(_firstPageWords[index],
        //                 columnWidth:
        //                     _widthsMap[_firstPageWords[index].categoryId],
        //                 pageType: widget.pageType);
        //           }),
        //       ListView.separated(
        //           separatorBuilder: (context, index) =>
        //               _dividerForIndex(index, _secondPageWords),
        //           itemCount: _secondPageWords.length,
        //           itemBuilder: (context, index) {
        //             return SystemListItem(_secondPageWords[index],
        //                 columnWidth:
        //                     _widthsMap[_secondPageWords[index].categoryId],
        //                 pageType: widget.pageType);
        //           }),
        //   ],
        // ),
      );

  void _printPage() async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        })); // Page
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  String screenName() {
    var screenName = '';
    switch (widget.pageType) {
      case SystemPageType.LogicalContextSystem:
        screenName = 'Контекст';
        break;
      case SystemPageType.Dialog:
        screenName = 'Диалог';
        break;
      case SystemPageType.DerivativesSystem:
        screenName = 'Производные';
        break;
    }
    return screenName;
  }

  @override
  Widget build(BuildContext context) {
    _calculateFirstColumnWidth(context);
    return Material(
        child: Stack(children: <Widget>[
      BasePage(
          index: widget.pageType == SystemPageType.Dialog ? 2 : 0,
          type: widget.pageType == SystemPageType.DerivativesSystem
              ? PageType.Derivatives
              : PageType.LogicalContext),
      Padding(
          padding: const EdgeInsets.only(
              top: 77.0, left: 15.0, bottom: 15.0, right: 15.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_navigationRow(), _contentRow()],
              ),
            ],
          )),
      (_isFirstPage == true
          ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                  height: 50,
                  width: 50,
                  child: TextButton(
                      onPressed: () {
                        // LangLogBApp.analytics.logEvent(name: screenName() + widget.index.toString() + '_КнопкаВтораяСтраница');
                        _toEnd();
                      },
                      child: Image.asset(
                          'assets/buttons/arrow-right-button.png'))),
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  height: 50,
                  width: 50,
                  child: TextButton(
                      onPressed: () {
                        // LangLogBApp.analytics.logEvent(name: screenName() + widget.index.toString() + '_КнопкаПерваяСтраница');
                        _toStart();
                      },
                      child:
                          Image.asset('assets/buttons/arrow-left-button.png'))),
            )),
      //TODO: Uncomment to show print button
      // Container(
      //   padding: EdgeInsets.only(bottom: 15, right: 10),
      //   alignment: Alignment.bottomRight,
      //   child: Container(
      //       width: 40,
      //       height: 40,
      //       child: FlatButton(
      //         padding: const EdgeInsets.all(0),
      //         child: Image.asset(
      //           'assets/buttons/printer-button.png',
      //           fit: BoxFit.fill,
      //         ),
      //         onPressed: () {
      //           _printPage();
      //         },
      //       )),
      // )
    ]));
  }
}
