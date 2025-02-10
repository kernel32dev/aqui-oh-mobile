import 'dart:async';

import 'package:aqui_oh_mobile/views/mapa.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaState extends State<Mapa> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final markers = widget.list
        .where((e) => e.mensagem != null)
        .map((e) => Marker(
            markerId: MarkerId(e.id),
            position: LatLng(e.mensagem!.lat, e.mensagem!.lng),
            infoWindow: InfoWindow(title: e.title)))
        .toSet();
    if (markers.isEmpty) {
      return Center(child: Text("Você ainda não fez nenhuma denúncia"));
    }
    var lat = 0.0;
    var lng = 0.0;
    for (final i in markers) {
      lat += i.position.latitude;
      lng += i.position.longitude;
    }
    lat /= markers.length;
    lng /= markers.length;

    return Scaffold(
      body: GoogleMap(
        markers: markers,
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, lng), zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
