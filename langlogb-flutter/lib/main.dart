import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lang_log_b/data/models/user.dart';
import 'package:lang_log_b/data/services/auth_service.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:lang_log_b/screens/dialogs_screen.dart';
import 'package:lang_log_b/screens/home_screen.dart';
import 'package:lang_log_b/screens/instruction_screen.dart';
import 'package:lang_log_b/screens/landing_screen.dart';
import 'package:lang_log_b/screens/system_screen.dart';
import 'package:lang_log_b/screens/systems_screen.dart';
import 'package:lang_log_b/screens/tests_screen.dart';
import 'package:provider/provider.dart';
import 'package:lang_log_b/screens/common/top-panel.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  runApp(LangLogBAppWidget());
}

class LangLogBAppWidget extends StatefulWidget {
  @override
  LangLogBApp createState() => LangLogBApp();
}

class LangLogBApp extends State<LangLogBAppWidget> {

  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver observer =
  // FirebaseAnalyticsObserver(analytics: analytics);
  StreamSubscription<List<PurchaseDetails>> _subscription;

  void initState() {
    final Stream purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          RealtimeDatabaseService().updateUserSubscryption(true);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isPremium', true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/systems', ModalRoute.withName('/home'));
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<LLUser>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        title: 'LangLogB',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => LandingPage(),
          '/home': (context) => HomePage(),
          '/instruction' : (context) => InstructionPage(),
          '/systems' : (context) => SystemsPage(pageType: SystemPageType.LogicalContextSystem),
          '/derivativesSystems' : (context) => SystemsPage(pageType: SystemPageType.DerivativesSystem),
          '/tests' : (context) => TestsPage(testType: TestType.Tests),
          '/derivativesTests' : (context) => TestsPage(pageType: PageType.Derivatives, testType: TestType.Tests),
          '/dialogs' : (context) => DialogsPage(),
          '/controls' : (context) => TestsPage(testType: TestType.Controls),
          '/derivativesControls' : (context) => TestsPage(pageType: PageType.Derivatives, testType: TestType.Controls),
        },
        theme: ThemeData(
            primaryColor: Color.fromRGBO(50, 65, 85, 1),
            textTheme: TextTheme(headline6: TextStyle(color: Colors.white))
        ),
        // navigatorObservers: <NavigatorObserver>[observer],
        // home: LandingPage(),
      ),
    );
  }
}
