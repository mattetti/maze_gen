import 'dart:math';

import 'package:maze_gen/core/models/interfaces/grid_modifier.dart';
import 'package:maze_gen/core/models/interfaces/grid_solver.dart';

import 'cell.dart';

class Grid {
  final int rows;
  final int cols;
  final List<Cell> _cells;
  int entryOffset = 0;
  int exitOffset = 0;
  final _rand = Random();

  // Translate 2D row, column pair into a 1D offset
  int offset(int row, int col) => row * rows + col;

  // Create a grid with all cells having walls up
  Grid(this.rows, this.cols) : _cells = List<Cell>(rows * cols) {
    int row;
    int _offset;
    for (var col = 0; col < cols; col++) {
      for (row = 0; row < rows; row++) {
        _offset = offset(row, col);
        _cells[_offset] = Cell(row, col);
      }
    }
    exitOffset = size();
  }

  Grid reset() {
    for (var cell in _cells) {
      cell.reset();
    }
    return this;
  }

  Grid resetVisits() {
    for (var c in _cells) {
      c.visited = false;
    }
  }

  // apply modifies the grid as per the passed grider (such as the "texture",
  // entries/exits etc...).
  Grid apply(GridModifier gridder) {
    return gridder.on(this);
  }

  // solve finds a path and mark the cells as visited. It also returns the number of steps needed to solve the grid.
  int solve(GridSolver solver) {
    resetVisits();
    return solver.solve(this);
  }

  Cell getCell(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) {
      return null;
    }
    return _cells[offset(row, col)];
  }

  Cell getCellAt(int index) {
    if (index < 0 || index > _cells.length) {
      return null;
    }
    return _cells[index];
  }

  link(Cell cell, Wall wall) {
    switch (wall) {
      case Wall.north:
        cell.connections[Wall.north.index] = true;
        final bidiCell = adjacentCell(cell, Wall.north);
        if (bidiCell != null) {
          bidiCell.connections[Wall.south.index] = true;
        }
        break;
      case Wall.east:
        cell.connections[Wall.east.index] = true;
        final bidiCell = adjacentCell(cell, Wall.east);
        if (bidiCell != null) {
          bidiCell.connections[Wall.west.index] = true;
        }
        break;
      case Wall.west:
        cell.connections[Wall.west.index] = true;
        final bidiCell = adjacentCell(cell, Wall.west);
        if (bidiCell != null) {
          bidiCell.connections[Wall.east.index] = true;
        }
        break;
      case Wall.south:
        cell.connections[Wall.south.index] = true;
        final bidiCell = adjacentCell(cell, Wall.south);
        if (bidiCell != null) {
          bidiCell.connections[Wall.north.index] = true;
        }
        break;
      default:
        assert(false);
    }
  }

  List<Cell> neighborCells(Cell cell) {
    List<Cell> neighbors = [];
    // remove the boundary walls
    final walls = Wall.values.toList();
    if (isEasternBoundary(cell)) {
      walls.removeAt(walls.indexOf(Wall.east));
    }
    if (isNothernBoundary(cell)) {
      walls.removeAt(walls.indexOf(Wall.north));
    }
    if (isWesternBoundary(cell)) {
      walls.removeAt(walls.indexOf(Wall.west));
    }
    if (isSouthernBoundary(cell)) {
      walls.removeAt(walls.indexOf(Wall.south));
    }
    walls.forEach((Wall w) {
      neighbors.add(adjacentCell(cell, w));
    });
    return neighbors;
  }

  // connectedCells returns a list of cells that are directly connected to the
  // passed cell.
  List<Cell> connectedCells(Cell cell) {
    List<Cell> neighbors = [];
    cell.connections.asMap().forEach((idx, isConnected) {
      if (isConnected) {
        var connectedCell = adjacentCell(cell, Wall.values[idx]);
        if (connectedCell != null) {
          neighbors.add(connectedCell);
        }
      }
    });
    return neighbors;
  }

  Cell randomCell() {
    final row = _rand.nextInt(rows);
    final col = _rand.nextInt(cols);

    return getCell(row, col);
  }

  int size() {
    return _cells.length;
  }

  Cell adjacentCell(Cell cellFrom, Wall wall) {
    return getCellAt(adjacentCellOffset(cellFrom, wall));
  }

  // sharedWall returns the wall (relative to a) that is shared with b, null is
  // returned if they don't share a wall.
  Wall sharedWall(Cell a, Cell b) {
    if (b.row == a.row - 1 && a.col == b.col) {
      return Wall.north;
    }
    if (b.row == a.row + 1 && a.col == b.col) {
      return Wall.south;
    }
    if (a.row == b.row && b.col == a.col + 1) {
      return Wall.east;
    }
    if (a.row == b.row && b.col == a.col - 1) {
      return Wall.west;
    }
    print("${a.row}/${a.col}, ${b.row}/${b.col} don't share a wall");
    return null;
  }

  int adjacentCellOffset(Cell cellFrom, Wall wall) {
    switch (wall) {
      case Wall.north:
        return offset(cellFrom.row - 1, cellFrom.col);
      case Wall.west:
        return offset(cellFrom.row, cellFrom.col - 1);
      case Wall.south:
        return offset(cellFrom.row + 1, cellFrom.col);
      case Wall.east:
        return offset(cellFrom.row, cellFrom.col + 1);
      default:
        assert(false);
        return null;
    }
  }

  bool isNothernBoundary(Cell cell) {
    if (cell.row == 0) {
      return true;
    }
    return false;
  }

  bool isEasternBoundary(Cell cell) {
    if (cell.col == cols - 1) {
      return true;
    }
    return false;
  }

  bool isWesternBoundary(Cell cell) {
    if (cell.col == 0) {
      return true;
    }
    return false;
  }

  bool isSouthernBoundary(Cell cell) {
    if (cell.row == rows - 1) {
      return true;
    }
    return false;
  }

  Iterable<Cell> cellsByRow() sync* {
    int col;
    int _offset;
    for (var row = 0; row < rows; row++) {
      for (col = 0; col < cols; col++) {
        _offset = offset(row, col);
        yield _cells[_offset];
      }
    }
  }

  // TODO: rotate (transpose as a matrix)
}
