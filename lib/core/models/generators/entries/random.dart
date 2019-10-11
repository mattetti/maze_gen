import 'dart:math';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';

class RandomEntries implements GridModifier {
  // set the entry and the exit randomly
  Grid on(Grid grid) {
    // TODO: should we check if we already have entries and clear them?
    final _rand = Random();
    // entry
    int idx = _rand.nextInt(grid.rows);
    var cell = grid.getCell(idx, 0);
    cell.connections[Wall.west.index] = true;
    cell.entry = true;
    grid.entryOffset = grid.offset(idx, 0);
    // exit
    idx = _rand.nextInt(grid.cols);
    cell = grid.getCell(idx, grid.cols - 1);
    cell.connections[Wall.east.index] = true;
    cell.exit = true;
    grid.exitOffset = grid.offset(cell.row, cell.col);
    return grid;
  }
}
