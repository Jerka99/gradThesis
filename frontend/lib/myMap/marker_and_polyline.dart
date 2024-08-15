import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../shape/TriangleClipper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../shape/TriangleClipper.dart';

class MapUtils {
  // Method to create a Marker
  Marker createMarker({
    required LatLng coordinate,
    required int index,
    required int markersNumber,
    required Function(int) deleteOrSelectFunction,
    int? selectedMarkerIndex1,
    int? selectedMarkerIndex2,
    int? stationCapacity,
    double? maxCapacity,
    required MaterialColor markerColor,
  }) {
    return Marker(
      point: coordinate,
      width: 50.0,
      height: 80.0,
      builder: (context) => ClipPath(
        clipper: TriangleClipper(),
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: IconButton(
            hoverColor: index == markersNumber - 1
                ? Colors.blue.withOpacity(0.6)
                : null,
            padding: EdgeInsets.zero,
            alignment: Alignment.topCenter,
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 50.0,
                  color: markerColor,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            onPressed: () {
              deleteOrSelectFunction(index);
            },
          ),
        ),
      ),
    );
  }

  // Method to create a Polyline
  Polyline createPolyline(List<LatLng> coordinatesMapped) {
    return Polyline(
      strokeWidth: 4,
      points: coordinatesMapped,
      color: Colors.blue,
    );
  }
}