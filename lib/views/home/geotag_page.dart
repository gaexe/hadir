import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoTagPage extends StatefulWidget {
  const GeoTagPage({super.key});

  @override
  State<StatefulWidget> createState() => _GeoTagPage();
}

class _GeoTagPage extends State<StatefulWidget> {
  //google map
  final Completer<GoogleMapController> _mapController = Completer();
  late GoogleMapController _controller;
  static const _latitudeDefault = -2.4152971; //default location Indonesia
  static const _longitudeDefault = 108.8471018; //default location Indonesia
  var camZoom = 5.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: const LatLng(_latitudeDefault, _longitudeDefault),
              zoom: camZoom,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 82, right: 58, left: 58),
            child: TextFormField(
              onChanged: (value) {},
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
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 32),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.api),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 82),
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.radio_button_checked),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 32),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Get.back();
                  _controller.dispose();
                },
                label: const Text('SIMPAN'),
                icon: const Icon(Icons.pin_drop_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
