import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../shape/TriangleClipper.dart';

Marker  markerDisplayFun(coordinate, index, markersNumber, deleteOrSelectFunction, selectedMarkerIndex1, selectedMarkerIndex2) {

  return Marker(
      point: coordinate,
      width: 50.0,
      height: 80.0,
      builder: (context) => ClipPath(
        clipper: TriangleClipper(),
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: IconButton(
            hoverColor: index == markersNumber -1 ? Colors
                .blue.withOpacity(0.6) : null,
            padding: EdgeInsets.zero,
            alignment: Alignment.topCenter,
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 50.0,
                  color: (index == selectedMarkerIndex1 || index == selectedMarkerIndex2 || ((selectedMarkerIndex2 != null && selectedMarkerIndex1 != null) && (index < selectedMarkerIndex2 && index > selectedMarkerIndex1)))
                      ? Colors.green
                      : (index == markersNumber - 1 ? Colors.indigo[400] : Colors.red),
                  shadows: index == markersNumber - 1 ? [const Shadow(color: Colors.red, blurRadius: 6.0)] : null,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                        color: Colors.white
                    ),

                  ),
                ),
              ],
            ),
            onPressed: () {
              deleteOrSelectFunction(index);
            },
          ),
        ),
      ));
}

Polyline polylineFun(coordinatesMapped){
  return Polyline(
    strokeWidth: 4,
    points: coordinatesMapped,
    color: Colors.blue,
  );
}