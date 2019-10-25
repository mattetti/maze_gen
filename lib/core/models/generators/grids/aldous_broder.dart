import 'package:flutter/material.dart';
import 'package:maze_gen/core/models/cell.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';

class AldousBroder implements GridModifier {
  Grid on(Grid grid) {
    var cell = grid.randomCell();
    var unvisited = grid.size() - 1;
    Cell neighbor;

    while (unvisited > 0) {
      neighbor = (grid.neighborCells(cell)..shuffle()).first;

      if (grid.connectedCells(neighbor).isEmpty) {
        grid.link(cell, grid.sharedWall(cell, neighbor));
        unvisited--;
      }

      neighbor.color = Colors.lightBlue;
      cell = neighbor;
    }

    return grid;
  }
}
