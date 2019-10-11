import 'dart:math';

import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/solvers/dijkstra.dart';

class LongestPath {
  static Grid on(Grid grid) {
    final _rand = Random();
    int row = _rand.nextInt(grid.rows);

    // find the furthest cell from our random starting point
    var solver = Dijkstra(grid, startRow: row, startCol: 0);
    var furthest = solver.furthestCell();
    var furthestOffset = furthest[0];
    // var furthestDistance = furthest[1];
    final endCell = grid.getCellAt(furthestOffset);

    // walk back from the furthest point to see if we can further than out start
    solver = Dijkstra(grid, startRow: endCell.row, startCol: endCell.col);
    furthest = solver.furthestCell();
    furthestOffset = furthest[0];
    // furthestDistance = furthest[1];
    final startCell = grid.getCellAt(furthestOffset);

// new_distances = new_start.distances
// goal, distance = new_distances.max

// grid.distances = new_distances.path_to(goal)
  }
}
