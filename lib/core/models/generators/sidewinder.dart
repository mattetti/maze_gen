import 'dart:math';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';

class Sidewinder {
  static Grid on(Grid grid) {
    final _iterator = grid.cellsByRow().iterator;
    final _rand = Random();

    Cell cell;
    List<Cell> run = List();

    for (var i = 0; i < grid.size(); i++) {
      _iterator.moveNext();
      cell = _iterator.current;
      run.add(cell);

      // if we reach the eastern boundry (end of row) or we aren't at the
      // nothern boundary but randomly won a toss, then we should close the run
      // and pick a winner (to link to its northern neighbor)
      final shouldCloseOut = grid.isEasternBoundary(cell) || (!grid.isNothernBoundary(cell) && _rand.nextInt(2) == 0);

      if (shouldCloseOut) {
        final rando = run[_rand.nextInt(run.length)];
        if (!grid.isNothernBoundary(rando)) {
          grid.link(rando, Wall.north);
        }
        run.clear();
      } else {
        grid.link(cell, Wall.east);
      }
    }
    return _setEntryAndExits(grid);
  }

  static Grid _setEntryAndExits(Grid grid) {
    final _rand = Random();
    // entry
    int row = _rand.nextInt(grid.rows);
    var cell = grid.getCell(row, 0);
    cell.connections[Wall.west.index] = true;
    cell.entry = true;
    grid.entryOffset = grid.offset(row, 0);
    // exit
    row = _rand.nextInt(grid.rows);
    cell = grid.getCell(row, grid.cols - 1);
    cell.connections[Wall.east.index] = true;
    cell.exit = true;
    grid.exitOffset = grid.offset(row, 0);
    return grid;
  }
}
