import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadir/app/helper/common.dart';
import 'package:hadir/controllers/location_controller.dart';
import 'package:hadir/models/model_ordinate.dart';

import '../../controllers/geotag_controller.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<StatefulWidget> createState() => _VisitPage();
}

class _VisitPage extends State<StatefulWidget> {
  final Completer<GoogleMapController> _mapController = Completer();
  late GoogleMapController _controller;
  late GeotagController _geotagCtrl;
  late LocationController _locationCtrl;
  var address = "";
  final defaultRadius = 50; //in meter

  @override
  void initState() {
    _geotagCtrl = Get.put(GeotagController());
    _locationCtrl = Get.put(LocationController());
    _locationCtrl.fetchLocations();
    _geotagCtrl.enableService();
    _geotagCtrl.checkPermission();
    _geotagCtrl.fetchLocation();
    _geotagCtrl.initMarkerLocation();
    _geotagCtrl.initMarkerIam();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ord = _geotagCtrl.ordinate.value;
      if (ord.latitude != null && ord.longitude != null) {
        MyCommon.getAddress(ord.latitude!, ord.longitude!).then((adr) {
          address = adr;
        });
      }
      _geotagCtrl.getMarkerIam();
      _mapController.future.then((value) {
        _controller = value;
        _controller.animateCamera(CameraUpdate.newCameraPosition(_geotagCtrl.getCameraPosition()));
      });

      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_geotagCtrl.latitudeDefault, _geotagCtrl.longitudeDefault),
                zoom: _geotagCtrl.camZoom.value,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(_geotagCtrl.markers.values),
            ),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(vertical: 62, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.0),
                color: Colors.white,
              ),
              child: ListTile(
                leading: InkWell(
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.arrow_back, size: 28),
                  ),
                  onTap: () => Get.back(),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    onTap: () => Get.bottomSheet(sheetLocation()),
                    controller: _geotagCtrl.name.value,
                    onChanged: (value) {},
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Nama Lokasi',
                      hintStyle: const TextStyle(
                        fontSize: 15.0,
                        color: Color(0xffA9A9A9),
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24, bottom: 82),
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.pin_drop_sharp),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 42,
                width: double.infinity,
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(address),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget sheetLocation() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: const Text("Pilih lokasi"),
            trailing: InkWell(
              child: const Icon(Icons.close),
              onTap: () => Get.back(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shrinkWrap: true,
              children: [
                ..._locationCtrl.locations.value.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: ListTile(
                        title: Text(e.name),
                        subtitle: Text("${e.radius} m"),
                        onTap: () {
                          _geotagCtrl.name.value.text = e.name;
                          _geotagCtrl.setSelectedLocation(
                            ModelOrdinate(
                              latitude: double.parse(e.latitude),
                              longitude: double.parse(e.longitude),
                            ),
                          );
                          _geotagCtrl.getMarkerLocation(true);
                          Get.back();
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
