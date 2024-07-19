import 'package:flutter/material.dart';
import 'package:hadir/app/styles/color.dart';
import 'package:hadir/models/dummies.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...MyDummies.dummyLocation.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Card(
                child: ListTile(
                  title: Text(e.name),
                  subtitle: Text("${e.radius} m"),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah lokasi baru',
        onPressed: () {},
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
