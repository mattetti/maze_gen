import 'dart:math';

import 'cell.dart';
import 'grid.dart';

class Sidewinder {
  static Grid on(Grid grid) {
    final _iterator = grid.cellsByRow().iterator;
    final _rand = Random();

    Cell cell;
    List<Cell> run = List();

    for (var i = 0; i < grid.size(); i++) {
      _iterator.moveNext();
      cell = _iterator.current;

      // if we are at the nothern boundary, only go right up to the eastern
      // boundary.
      if (grid.isNothernBoundary(cell)) {
        if (!grid.isEasternBoundary(cell)) {
          grid.link(cell, Wall.east);
        }
        continue;
      }
      run.add(cell);

      if (grid.isEasternBoundary(cell) || _rand.nextInt(2) == 0) {
        final rando = run[_rand.nextInt(run.length)];
        grid.link(rando, Wall.north);
        run.clear();
      } else {
        grid.link(cell, Wall.east);
      }
    }

    // openings
    // entry
    int row = _rand.nextInt(grid.rows);
    cell = grid.getCell(row, 0);
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
