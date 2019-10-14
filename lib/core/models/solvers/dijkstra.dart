import 'dart:collection';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/distance_calculator.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_solver.dart';

class Dijkstra implements GridSolver {
  Grid grid;
  int _startOffset;
  DistanceCalculator distanceCalculator;

  Dijkstra(this.grid, {int startRow, int startCol}) {
    if (startRow != null && startCol != null) {
      _startOffset = grid.offset(startRow, startCol);
    } else {
      _startOffset = grid.entryOffset;
    }

    distanceCalculator = DistanceCalculator(grid, startRow: startRow, startCol: startCol);
  }

  int solve(Grid grid) {
    grid.resetVisits();
    final exitCell = grid.getCellAt(grid.exitOffset);
    final pathOffsets = pathTo(exitCell.row, exitCell.col);
    pathOffsets.forEach((int offset) => grid.getCellAt(offset).visited = true);
    return pathOffsets.length;
  }

  // shortestPathTo returns a list of cells used to go from the start to a given
  // destination.
  Iterable<int> pathTo(int row, int col) {
    final breadcrumbs = HashMap<int, int>();

    // start from the end/goal
    var currentOffset = grid.offset(row, col);
    breadcrumbs[currentOffset] = 0; // mark the end as visited
    var current = grid.getCellAt(currentOffset);
    final start = grid.getCellAt(_startOffset);
    if (distanceCalculator.distances.length < 1) {
      distanceCalculator.calculateDistances();
    }

    // debugPrint("solving from ${current.row} ${current.col} to ${start.row} ${start.col}");

    while (current.col != start.col || current.row != start.row) {
      var linkedCells = grid.connectedCells(current);
      // debugPrint(linkedCells.length.toString() + " linked cells");
      for (final Cell c in linkedCells) {
        var neighborOffset = grid.offset(c.row, c.col);
        if (distanceCalculator.distances[neighborOffset] < distanceCalculator.distances[currentOffset]) {
          breadcrumbs[neighborOffset] = distanceCalculator.distances[neighborOffset];
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

    if (distanceCalculator.distances.length < 1) {
      distanceCalculator.calculateDistances();
    }

    distanceCalculator.distances.forEach((int offset, int distance) {
      if (distance > maxDistance) {
        furthestOffset = offset;
        maxDistance = distance;
      }
    });

    return [furthestOffset, maxDistance];
  }
}
