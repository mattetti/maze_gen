import 'package:maze_gen/core/models/grid.dart';

// Gridder is an interface for classes turning a grid into a maze.
class GridModifier {
  Grid on(Grid grid) {
    return grid;
  }
}
