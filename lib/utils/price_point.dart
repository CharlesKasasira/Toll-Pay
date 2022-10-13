import 'dart:math';
import 'package:collection/collection.dart';

class PricePoint {
  final double x;
  final double y;

  PricePoint({required this.x, required this.y});
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  final randomNumbers = <double>[1, 2, 7, 4, 9, 6, 3];
  // for (var i = 0; i <= 6; i++) {
  //   randomNumbers.add(random.nextDouble());
  // }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element),)
      .toList();
}
