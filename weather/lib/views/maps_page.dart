import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/services/storage_service.dart';
import 'package:weather/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markers = [];
  final LatLng _defPos = const LatLng(48.7493927, 30.2214499);

  @override
  void initState() {
    super.initState();
    getMyPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Google Map'),
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          markers: _markers.toSet(),
          onMapCreated: (controller) => _controller.complete(controller),
          initialCameraPosition: CameraPosition(
            target: _defPos,
            zoom: 6,
          ),
        ));
  }

  void getMyPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng myPos = LatLng(position.latitude, position.longitude);
    setCameraPosition(myPos);
  }

  void setCameraPosition(LatLng position) async {
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 7);
    await getMarker();
    (await _controller.future)
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  getMarker() async {
    final lastViewed = await StorageService.findInStorage('lastViewed');
    if (lastViewed != null) {
      final placeWeather = await WeatherService.fetchWeather(
          lastViewed.lat, lastViewed.lon);
      _markers.add(Marker(
          markerId: const MarkerId('1'),
          position: LatLng(double.parse(lastViewed.lat),
              double.parse(lastViewed.lon)),
          infoWindow: InfoWindow(
            title: 'Temp is ${placeWeather[0].temp}°C',
          )));
    }
  }
}
