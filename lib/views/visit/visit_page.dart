import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadir/app/helper/common.dart';
import 'package:hadir/app/styles/color.dart';
import 'package:hadir/controllers/location_controller.dart';
import 'package:hadir/models/model_location.dart';
import 'package:hadir/models/model_ordinate.dart';

import '../../controllers/geotag_controller.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<StatefulWidget> createState() => _VisitPage();
}

class _VisitPage extends State<StatefulWidget> {
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _controller;
  late GeotagController _geotagCtrl;
  late LocationController _locationCtrl;
  final defaultRadius = 50; //in meter

  @override
  void initState() {
    _mapController.future.then((value) {
      _controller = value;
    });
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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ord = _geotagCtrl.ordinate.value;
      _geotagCtrl.getMarkerIam();
      _geotagCtrl.runValidator();
      _controller?.animateCamera(CameraUpdate.newCameraPosition(_geotagCtrl.getCameraPosition()));

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
              circles: {
                _geotagCtrl.selectedOrdinate.value.latitude != null
                    ? Circle(
                        circleId: const CircleId('mrk_location'),
                        center: LatLng(_geotagCtrl.selectedOrdinate.value.latitude!, _geotagCtrl.selectedOrdinate.value.longitude!),
                        radius: defaultRadius.toDouble(),
                        fillColor: _geotagCtrl.isMyPositionValid.value ? MyColors.greenBackground : MyColors.redBackground,
                        strokeColor: Colors.transparent,
                      )
                    : const Circle(circleId: CircleId('mrk_location'))
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 42, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.0),
                color: MyColors.greyTransparent,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.arrow_back, size: 24),
                    ),
                    onTap: () => Get.back(),
                  ),
                ),
                title: TextFormField(
                  onTap: () => Get.bottomSheet(sheetLocation()),
                  controller: _geotagCtrl.name.value,
                  onChanged: (value) {},
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Pilih Lokasi',
                    hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffA9A9A9),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, bottom: 82),
                child: Visibility(
                  visible: _geotagCtrl.isMyPositionValid.value,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final response = await _geotagCtrl.newAttendance(
                        ModelLocation(
                          name: "Hadir!",
                          latitude: ord.latitude.toString(),
                          longitude: ord.longitude.toString(),
                          radius: defaultRadius,
                          address: _geotagCtrl.address.value,
                          time: MyCommon.dateNowDisplay(),
                        ),
                      );
                      Get.snackbar(
                        response.name != null ? "Sukses" : "Gagal",
                        response.name != null ? "ID ${response.name}" : "Error ${response.error}",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Icon(Icons.pin_drop_sharp),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_geotagCtrl.address.value),
                ),
              ),
            ),
            Visibility(
              visible: !_mapController.isCompleted,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                color: Colors.white70,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text("Memuat map..", style: TextStyle(height: 4)),
                  ],
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
            title: const Text("Pilih Lokasi"),
            trailing: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.close, size: 24),
                ),
                onTap: () => Get.back(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                itemCount: _locationCtrl.locations.length,
                itemBuilder: (context, index) {
                  final item = _locationCtrl.locations.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text("${item.radius} m"),
                        onTap: () {
                          _geotagCtrl.name.value.text = "${item.name}, radius:${item.radius}m";
                          _geotagCtrl.setSelectedLocation(
                            ModelOrdinate(
                              latitude: double.parse(item.latitude),
                              longitude: double.parse(item.longitude),
                            ),
                          );
                          _geotagCtrl.getMarkerLocation(true);
                          Get.back();
                        },
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
