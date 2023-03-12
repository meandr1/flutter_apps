import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lang_log_b/data/database/app_shared_data.dart';
import 'package:lang_log_b/data/services/realtime_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

final String premiumID = 'com.langlogb.premium';  //'android.test.purchased';

class MarketPage extends StatefulWidget {
  createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketPage> {

  bool _isPurchased = false;

  void _isPremium() async {
    final premium = await AppSharedData().isPremium();
    setState(() {
      _isPurchased = premium;
    });
  }

  // Initialize data
  void _initialize() async {
    // Check availability of In App Purchases
    final available = await _iap.isAvailable();

    if (available) {
      await _getProducts();
    }
  }

  // The In App Purchase plugin
  InAppPurchase _iap = InAppPurchase.instance;

  // Products for sale
  List<ProductDetails> _products = [];

  @override
  void initState() {
    _initialize();
    _isPremium();
    super.initState();
  }

  // Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([premiumID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    if (response.notFoundIDs.isEmpty) {
      setState(() {
        _products = response.productDetails;
      });
    }
  }

  void _restore() {
    InAppPurchase.instance.restorePurchases();
  }

  // Purchase a product
  void _buyProduct(ProductDetails prod) {
    // LangLogBApp.analytics.logEvent(name: 'Маркет_ЗапросПокупки');
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Премиум доступ'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text("""
              LangLogB Premium расширяет ваши возможности: 
- доступ ко всем контекстам;
- доступ ко всем тестам;
- доступ ко всем примерам;
- доступ ко всем производным;
- доступ ко всей фонетике.
              """, style: TextStyle(color: Colors.black, fontSize: 12)),
              for (var prod in _products)

                // UI if already purchased
                if (_isPurchased) ...[
                  Text(prod.title != null ? prod.title : "Премиум"),
                  Text(prod.description != null ? prod.description : ""),
                  Text(prod.price,
                      style: TextStyle(color: Colors.greenAccent, fontSize: 60)),
                  TextButton(
                    child: Text('Куплено'),
                    onPressed: () {},
                  )
                ]

                // UI if NOT purchased
                else ...[
                  Text(prod.title != null ? prod.title : ""),
                  Text(prod.description != null ? prod.description : ""),
                  Text(prod.price,
                      style: TextStyle(color: Colors.greenAccent, fontSize: 60)),
                  TextButton(
                    child: Text('Купить доступ'),
                    onPressed: () => _buyProduct(prod),
                  ),
                ],
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("""
Единоразовый платёж. Стоимость пдатежа будет снята с вашей карты через ваш аккаунт. Вы не сможете отменить платеж после осуществления. Нажимая "Купить Премиум" Вы соглашаетесь с Политикой конфиденциальности и Условиями использования.
                """, style: TextStyle(color: Colors.black, fontSize: 12)),
              ),
              TextButton(
                child: Text('Восстановить'),
                onPressed: () => _restore(),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
