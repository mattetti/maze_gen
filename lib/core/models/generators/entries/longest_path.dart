import 'dart:math';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';
import 'package:maze_gen/core/models/solvers/dijkstra.dart';

// LongestPath finds the longest path from a starting point and walk back from
// the end to try to find a starting point that would be even further.
class LongestPath implements GridModifier {
  Grid on(Grid grid) {
    final _rand = Random();
    int row = _rand.nextInt(grid.rows);

    // find the furthest cell from our random starting point
    var solver = Dijkstra(grid, startRow: row, startCol: 0);
    var furthestOffset = solver.furthestCell()[0];
    final endCell = grid.getCellAt(furthestOffset);

    // walk back from the furthest point to see if we can further than out start
    solver = Dijkstra(grid, startRow: endCell.row, startCol: endCell.col);
    furthestOffset = solver.furthestCell()[0];
    final bestStartCell = grid.getCellAt(furthestOffset);

    // start
    bestStartCell.entry = true;
    grid.entryOffset = grid.offset(bestStartCell.row, bestStartCell.col);

    // end
    endCell.exit = true;
    grid.exitOffset = grid.offset(endCell.row, endCell.col);
    return grid;
  }
}
