import 'dart:math';
import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get lastWeekPoints {
  final qrCodes = <double>[1, 2, 7, 4, 9, 6, 3];

  return qrCodes
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element),)
      .toList();
}

List<PricePoint> get thisWeekPoints {
  final qrCodes = <double>[5, 2, 3, 4, 4, 2, 0];

  return qrCodes
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element),)
      .toList();
}
