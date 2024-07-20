import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadir/app/helper/common.dart';
import 'package:hadir/models/model_location.dart';

import '../../controllers/geotag_controller.dart';

class GeoTagPage extends StatefulWidget {
  const GeoTagPage({super.key});

  @override
  State<StatefulWidget> createState() => _GeoTagPage();
}

class _GeoTagPage extends State<StatefulWidget> {
  final Completer<GoogleMapController> _mapController = Completer();
  late GoogleMapController _controller;
  late GeotagController _geotagCtrl;
  var camZoom = 5.0;
  var address = "";
  final defaultRadius = 50; //in meter

  @override
  void initState() {
    _geotagCtrl = Get.put(GeotagController());
    _geotagCtrl.enableService();
    _geotagCtrl.checkPermission();
    _geotagCtrl.fetchLocation();
    _geotagCtrl.initMarker();
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
      _geotagCtrl.getMarkerPosition();

      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_geotagCtrl.latitudeDefault, _geotagCtrl.longitudeDefault),
                zoom: camZoom,
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
                trailing: InkWell(
                  child: const Icon(Icons.save),
                  onTap: () async {
                    if (_geotagCtrl.name.value.value.text.isNotEmpty && address.isNotEmpty) {
                      final response = await _geotagCtrl.newLocation(
                        ModelLocation(
                          name: _geotagCtrl.name.value.value.text,
                          latitude: ord.latitude.toString(),
                          longitude: ord.longitude.toString(),
                          radius: defaultRadius,
                          address: address,
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
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
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
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(right: 24, bottom: 32),
            //         child: FloatingActionButton(
            //           onPressed: () {},
            //           child: const Icon(Icons.api),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 24, bottom: 82),
            //         child: FloatingActionButton(
            //           onPressed: () {},
            //           child: const Icon(Icons.radio_button_checked),
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //     ],
            //   ),
            // ),
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
}
