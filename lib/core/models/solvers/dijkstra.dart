import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';

class Dijkstra {
  Grid grid;
  int _startOffset;
  final distances = HashMap<int, int>();

  Dijkstra(this.grid, {int startX, int startY}) {
    if (startX != null && startY != null) {
      _startOffset = grid.offset(startX, startY);
    } else {
      _startOffset = grid.entryOffset;
    }
  }

  // calculateDistances from a start point
  HashMap<int, int> calculateDistances() {
    distances.clear();
    distances[_startOffset] = 0;

    List<int> frontiers = [_startOffset];

    while (frontiers.isNotEmpty) {
      List<int> newFrontiers = [];
      frontiers.forEach((int targetOffset) {
        var current = grid.getCellAt(targetOffset);
        grid.connectedCells(current).forEach((c) {
          final neighborOffset = grid.offset(c.row, c.col);
          if (distances.containsKey(neighborOffset)) {
            return;
          }
          distances[neighborOffset] = distances[targetOffset] + 1;
          newFrontiers.add(neighborOffset);
        });
      });
      frontiers = newFrontiers;
    }
    return distances;
  }

  // pathTo returns a list of cells used to go from the start to a given
  // destination.

  Iterable<int> pathTo(int x, int y) {
    final breadcrumbs = HashMap<int, int>();

    // start from the end/goal
    var currentOffset = grid.offset(x, y);
    var current = grid.getCellAt(currentOffset);
    final start = grid.getCellAt(_startOffset);
    if (distances.length < 1) {
      calculateDistances();
    }

    debugPrint("solving from ${current.row} ${current.col} to ${start.row} ${start.col}");

    while (current.col != start.col || current.row != start.row) {
      var linkedCells = grid.connectedCells(current);
      // debugPrint(linkedCells.length.toString() + " linked cells");
      for (final Cell c in linkedCells) {
        var neighborOffset = grid.offset(c.row, c.col);
        if (distances[neighborOffset] < distances[currentOffset]) {
          breadcrumbs[neighborOffset] = distances[neighborOffset];
          currentOffset = neighborOffset;
          current = grid.getCellAt(currentOffset);
          break;
        }
      }
    }
    if (current.col != start.col && current.row != start.row) {
      print("we reached the start cell");
    }

    return breadcrumbs.keys;
  }
}
