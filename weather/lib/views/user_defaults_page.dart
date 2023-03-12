import 'package:flutter/material.dart';

class UserDefaultsPage extends StatelessWidget {
  final List<String?>? places;
  final Function callback;
  final BuildContext context;

  const UserDefaultsPage(this.context, this.callback, this.places, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('User defaults'),
        ),
        body: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: places != null ? places!.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text('${places![index]}'),
                  onTap: () {
                    callback(this.context, places![index]);
                    Navigator.pop(context);
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
            }));
  }
}
