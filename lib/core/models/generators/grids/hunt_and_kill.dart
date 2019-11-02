import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';

class HuntAndKill implements GridModifier {
  Grid on(Grid grid) {
    var current = grid.randomCell();
    Cell neighbor;

    while (current != null) {
      final unvisitedNeighbors = grid.neighborCells(current).where((Cell c) => !c.visited);

      if (unvisitedNeighbors.isNotEmpty) {
        neighbor = (unvisitedNeighbors.toList()..shuffle()).first;

        grid.link(current, grid.sharedWall(current, neighbor));
        current.visited = true;
        current = neighbor;
      } else {
        current = null;
        for (Cell cell in grid.cellsByRow()) {
          final visitedNeighbors = grid.neighborCells(cell).where((Cell c) => c.visited);

          if (!cell.visited && visitedNeighbors.isNotEmpty) {
            current = cell;
            current.visited = true;

            neighbor = (visitedNeighbors.toList()..shuffle()).first;
            grid.link(current, grid.sharedWall(current, neighbor));
            break;
          }
        }
      }
    }

    return grid;
  }
}
