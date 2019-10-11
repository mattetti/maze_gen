import 'dart:math';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';

class Sidewinder implements GridModifier {
  Grid on(Grid grid) {
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
    return grid;
  }
}
