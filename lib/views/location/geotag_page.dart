import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadir/app/styles/color.dart';
import 'package:hadir/models/model_location.dart';

import '../../controllers/geotag_controller.dart';

class GeoTagPage extends StatefulWidget {
  const GeoTagPage({super.key});

  @override
  State<StatefulWidget> createState() => _GeoTagPage();
}

class _GeoTagPage extends State<StatefulWidget> {
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _controller;
  late GeotagController _geotagCtrl;
  final defaultRadius = 50; //in meter

  @override
  void initState() {
    _mapController.future.then((value) {
      _controller = value;
    });
    _geotagCtrl = Get.put(GeotagController());
    _geotagCtrl.enableService();
    _geotagCtrl.checkPermission();
    _geotagCtrl.fetchLocation();
    _geotagCtrl.initMarkerLocation();
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
      _geotagCtrl.getMarkerLocation(false);
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
              compassEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              markers: Set<Marker>.of(_geotagCtrl.markers.values),
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
                trailing: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.save),
                    ),
                    onTap: () async {
                      if (_geotagCtrl.name.value.value.text.isNotEmpty && _geotagCtrl.address.value.isNotEmpty) {
                        final response = await _geotagCtrl.newLocation(
                          ModelLocation(
                            name: _geotagCtrl.name.value.value.text,
                            latitude: ord.latitude.toString(),
                            longitude: ord.longitude.toString(),
                            radius: defaultRadius,
                            address: _geotagCtrl.address.value,
                          ),
                        );
                        Get.snackbar(
                          response.name != null ? "Sukses" : "Gagal",
                          response.name != null ? "ID ${response.name}" : "Error ${response.error}",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar(
                          "Validator",
                          "Nama lokasi tidak boleh kosong!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                ),
                title: TextFormField(
                  controller: _geotagCtrl.name.value,
                  onChanged: (value) {},
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
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
}
