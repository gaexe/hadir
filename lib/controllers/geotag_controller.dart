import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadir/models/model_ordinate.dart';
import 'package:hadir/models/response_default.dart';
import 'package:location/location.dart';

import '../app/helper/common.dart';
import '../app/repository/remote/api_config.dart';
import '../app/repository/repository.dart';
import '../models/model_location.dart';

class GeotagController extends GetxController {
  /// protocol
  final _remote = Repository(apiConfig: ApiConfig());

  /// common
  Location location = Location();
  final markers = <MarkerId, Marker>{};
  static const _markerLocation = MarkerId('mrk_location');
  static const _markerIam = MarkerId('mrk_iam');
  var _iconLocation = BitmapDescriptor.defaultMarker;
  var _iconIam = BitmapDescriptor.defaultMarker;

  final latitudeDefault = -2.4152971; //default location Indonesia
  final longitudeDefault = 108.8471018; //default location Indonesia
  final isMyPositionValid = false.obs;

  var camZoom = 5.0.obs;
  final ordinate = ModelOrdinate().obs;
  final selectedOrdinate = ModelOrdinate().obs;
  final address = "".obs;
  final name = TextEditingController(text: '').obs;

  Future<ResponseDefault> newLocation(ModelLocation payload) => _remote.postNewLocation(payload);

  Future<ResponseDefault> newAttendance(ModelLocation payload) => _remote.postNewAttendance(payload);

  enableService() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
  }

  checkPermission() async {
    var permissionGranted = await location.hasPermission();
    final permissionLocation = await Geolocator.checkPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if (permissionLocation == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
  }

  fetchLocation() {
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      ordinate.value = ModelOrdinate(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      );
      _getAddress(currentLocation);
    });
    camZoom.value = 18;
  }

  _getAddress(LocationData? ord) async {
    address.value = await MyCommon.getAddress(ord?.latitude, ord?.longitude);
  }

  initMarkerLocation() async {
    _iconLocation = await BitmapDescriptor.asset(const ImageConfiguration(), "assets/images/ic_pin_android.png");
  }

  initMarkerIam() async {
    _iconIam = await BitmapDescriptor.asset(const ImageConfiguration(), "assets/images/ic_my_position.png");
  }

  runValidator() {
    final latStatic = selectedOrdinate.value.latitude;
    final lgtStatic = selectedOrdinate.value.longitude;
    final latDynamic = ordinate.value.latitude;
    final lgtDynamic = ordinate.value.longitude;
    if (latStatic != null && lgtStatic != null && latDynamic != null && lgtDynamic != null) {
      double distance = Geolocator.distanceBetween(latStatic, lgtStatic, latDynamic, lgtDynamic);
      isMyPositionValid.value = distance <= 50; //SOP soal ujian
    }
  }

  CameraPosition getCameraPosition() {
    final ord = ordinate.value;
    return CameraPosition(
      target:
          (ord.latitude != null && ord.longitude != null) ? LatLng(ord.latitude!, ord.longitude!) : LatLng(latitudeDefault, longitudeDefault),
      zoom: camZoom.value,
    );
  }

  setSelectedLocation(ModelOrdinate ordinateLocation) {
    selectedOrdinate.value = ordinateLocation;
  }

  getMarkerLocation(bool isStatic) {
    final ord = isStatic ? selectedOrdinate.value : ordinate.value;
    final markerLocation = Marker(
      markerId: _markerLocation,
      position:
          (ord.latitude != null && ord.longitude != null) ? LatLng(ord.latitude!, ord.longitude!) : LatLng(latitudeDefault, longitudeDefault),
      icon: _iconLocation,
    );
    markers[_markerLocation] = markerLocation;
  }

  getMarkerIam() {
    final ord = ordinate.value;
    final markerIam = Marker(
      markerId: _markerIam,
      position:
          (ord.latitude != null && ord.longitude != null) ? LatLng(ord.latitude!, ord.longitude!) : LatLng(latitudeDefault, longitudeDefault),
      icon: _iconIam,
    );
    markers[_markerIam] = markerIam;
  }
}
