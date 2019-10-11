import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';

class Dijkstra {
  Grid grid;
  int _startOffset;
  final distances = HashMap<int, int>();

  Dijkstra(this.grid, {int startRow, int startCol}) {
    if (startRow != null && startCol != null) {
      _startOffset = grid.offset(startRow, startCol);
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

  // shortestPathTo returns a list of cells used to go from the start to a given
  // destination.
  Iterable<int> shortestPathTo(int row, int col) {
    final breadcrumbs = HashMap<int, int>();

    // start from the end/goal
    var currentOffset = grid.offset(row, col);
    breadcrumbs[currentOffset] = 0; // mark the end as visited
    var current = grid.getCellAt(currentOffset);
    final start = grid.getCellAt(_startOffset);
    if (distances.length < 1) {
      calculateDistances();
    }

    // debugPrint("solving from ${current.row} ${current.col} to ${start.row} ${start.col}");

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

    return breadcrumbs.keys;
  }

  // find the furthest cell and return its offset and the distance to the start
  // point
  List<int> furthestCell() {
    var maxDistance = 0;
    var furthestOffset = _startOffset;

    if (distances.length < 1) {
      calculateDistances();
    }

    distances.forEach((int offset, int distance) {
      if (distance > maxDistance) {
        furthestOffset = offset;
        maxDistance = distance;
      }
    });

    return [furthestOffset, maxDistance];
  }
}
