import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadir/app/styles/color.dart';
import 'package:hadir/controllers/location_controller.dart';
import 'package:hadir/views/location/location_page.dart';
import 'package:hadir/views/visit/visit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late LocationController _locationCtrl;

  @override
  void initState() {
    _locationCtrl = Get.put(LocationController());
    _locationCtrl.fetchLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: MyColors.greyBackground,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ..._locationCtrl.locations.value.map((e) {
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
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
              tooltip: 'Tambah lokasi baru',
              onPressed: () {
                Get.to(const LocationPage(title: "Hadir"));
              },
              child: const Icon(Icons.map),
            ),
            const SizedBox(width: 24),
            FloatingActionButton(
              tooltip: 'Tambah lokasi baru',
              onPressed: () {
                Get.to(const VisitPage());
              },
              child: const Icon(Icons.pin_drop_sharp),
            ),
          ],
        ),
      );
    });
  }
}
