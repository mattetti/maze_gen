import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maze_gen/core/models/distance_calculator.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';

class Colorize implements GridModifier {
  Grid on(Grid grid) {
    final calculator = DistanceCalculator(grid);
    final distances = calculator.calculateDistances();
    final maxDistance = distances.values.reduce(max);
    if (maxDistance.isNaN) {
      assert(false);
    }
    double intensity;
    int dark;
    int bright;
    distances.forEach((int offset, int distance) {
      intensity = (maxDistance - distance).toDouble() / maxDistance;
      if (intensity.isNaN) {
        intensity = 0.0;
      }
      dark = (255 * intensity).round();
      bright = 128 + (127 * intensity).round();
      grid.getCellAt(offset).color = Color.fromRGBO(dark, bright, dark, 0.8);
    });
    return grid;
  }
}
