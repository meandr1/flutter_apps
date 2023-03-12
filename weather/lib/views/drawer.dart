import 'package:flutter/material.dart';
import 'package:weather/services/storage_service.dart';
import 'package:weather/views/user_defaults_page.dart';
import 'package:weather/views/maps_page.dart';
import 'package:weather/models/place_model.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer(this.context, this.callback, {super.key});
  final BuildContext context;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          ),
          ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              }),
          ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('User defaults'),
              onTap: () async {
                final places = await StorageService.getPlaces();
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserDefaultsPage(this.context, callback, places)));
              }),
          ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Show map'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MapsPage()));
              }),
        ],
      ),
    );
  }
}
