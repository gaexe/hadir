import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadir/models/model_ordinate.dart';
import 'package:hadir/models/response_default.dart';
import 'package:location/location.dart';

import '../app/repository/remote/api_config.dart';
import '../app/repository/repository.dart';
import '../models/model_location.dart';

class GeotagController extends GetxController {
  /// protocol
  final _remote = Repository(apiConfig: ApiConfig());

  /// common
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  final markers = <MarkerId, Marker>{};
  static const _markerId = MarkerId('hadirin');
  final latitudeDefault = -2.4152971; //default location Indonesia
  final longitudeDefault = 108.8471018; //default location Indonesia
  var _iconMarker = BitmapDescriptor.defaultMarker;
  var camZoom = 15.0;
  final ordinate = ModelOrdinate().obs;
  final address = "".obs;
  final name = TextEditingController(text: '').obs;

  Future<ResponseDefault> newLocation(ModelLocation payload) => _remote.postLogin(payload);

  enableService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  checkPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  fetchLocation() async {
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      ordinate.value = ModelOrdinate(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      );
    });
  }

  initMarker() async {
    _iconMarker = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/images/ic_pin_android.png");
  }

  getMarkerPosition() {
    final ord = ordinate.value;
    final marker = Marker(
      markerId: _markerId,
      position:
          (ord.latitude != null && ord.longitude != null) ? LatLng(ord.latitude!, ord.longitude!) : LatLng(latitudeDefault, longitudeDefault),
      icon: _iconMarker,
    );
    markers[_markerId] = marker;
  }
}
