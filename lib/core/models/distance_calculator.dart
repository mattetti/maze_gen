import 'dart:collection';

import 'package:maze_gen/core/models/grid.dart';

class DistanceCalculator {
  Grid grid;
  final distances = HashMap<int, int>();
  int _startOffset;

  DistanceCalculator(this.grid, {int startRow, int startCol}) {
    if (startRow != null && startCol != null) {
      _startOffset = grid.offset(startRow, startCol);
    } else {
      _startOffset = grid.entryOffset;
    }
  }

  // calculateDistances from a start point the returned hash map is the cell
  // offset and the distance to the start cell.
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
}
