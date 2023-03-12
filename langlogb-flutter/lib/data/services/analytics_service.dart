
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {

  AnalyticsService._privateConstructor();

  static final AnalyticsService _instance = AnalyticsService._privateConstructor();
  // static FirebaseAnalytics analytics = FirebaseAnalytics();

  factory AnalyticsService() {
    return _instance;
  }
}