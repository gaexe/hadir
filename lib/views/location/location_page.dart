import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadir/app/styles/color.dart';
import 'package:hadir/controllers/location_controller.dart';
import 'package:hadir/views/location/geotag_page.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.title});

  final String title;

  @override
  State<LocationPage> createState() => _LocationPage();
}

class _LocationPage extends State<LocationPage> {
  late LocationController _locationCtrl;

  @override
  void initState() {
    _locationCtrl = Get.put(LocationController());
    _locationCtrl.fetchLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Obx(() {
        return _locationCtrl.isLoadingLocation.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _locationCtrl.locations.length,
                itemBuilder: (context, index) {
                  final item = _locationCtrl.locations.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.address),
                      ),
                    ),
                  );
                });
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah lokasi baru',
        onPressed: () {
          Get.to(const GeoTagPage())?.then((value) {
            _locationCtrl.fetchLocations(); //refresh data
          });
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
