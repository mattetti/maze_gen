import 'dart:math';

import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';
import 'package:maze_gen/core/models/solvers/dijkstra.dart';

class LongestPath implements GridModifier {
  Grid on(Grid grid) {
    final _rand = Random();
    int row = _rand.nextInt(grid.rows);

    final startCell = grid.getCell(row, 0);

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
    final altStartCell = grid.getCellAt(furthestOffset);

    // startCell.connections[Wall.west.index] = true;
    startCell.entry = true;
    altStartCell.entry = true;
    grid.entryOffset = grid.offset(altStartCell.row, altStartCell.col);

    // exit
    // endCell.connections[Wall.east.index] = true;
    endCell.exit = true;
    grid.exitOffset = grid.offset(endCell.row, endCell.col);
    return grid;
  }
}
