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
              trailing: const InkWell(
                child: Icon(Icons.save),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
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
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
