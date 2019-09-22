import 'dart:math';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';

class BinaryTree {
  static Grid on(Grid grid) {
    final _rand = Random();

    for (var i = 0; i < grid.size(); i++) {
      final c = grid.getCellAt(i);
      // we have a north wall (grid edge), we can only go east
      if (grid.isNothernBoundary(c) && !grid.isEasternBoundary(c)) {
        grid.link(c, Wall.east);
        continue;
      }
      // we have a east wall (grid edge), we can only go north
      if (grid.isEasternBoundary(c)) {
        if (c.row == 0) {
          continue;
        }
        grid.link(c, Wall.north);
        continue;
      }
      // pick randomly between north and east
      if (_rand.nextInt(2) == 0) {
        grid.link(c, Wall.north);
      } else {
        grid.link(c, Wall.east);
      }
    }
    // openings
    // entry
    int row = _rand.nextInt(grid.rows);
    var cell = grid.getCell(row, 0);
    cell.connections[Wall.west.index] = true;
    cell.entry = true;
    // exit
    row = _rand.nextInt(grid.rows);
    cell = grid.getCell(row, grid.cols - 1);
    cell.connections[Wall.east.index] = true;
    cell.exit = true;

    return grid;
  }
}
