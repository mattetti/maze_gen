import 'dart:math';

import 'cell.dart';

class Grid {
  final int rows;
  final int cols;
  final List<Cell> _cells;
  final _rand = Random();

  // Translate 2D row, column pair into a 1D offset
  int _offset(int row, int col) => row * rows + col;

  // Create a grid with all cells having walls up
  Grid(this.rows, this.cols) : _cells = List<Cell>(rows * cols) {
    int row;
    int offset;
    for (var col = 0; col < cols; col++) {
      for (row = 0; row < rows; row++) {
        offset = _offset(row, col);
        _cells[offset] = Cell(row, col);
      }
    }
  }

  Cell getCell(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) {
      return null;
    }
    return _cells[_offset(row, col)];
  }

  Cell getCellAt(int index) {
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
      default:
        assert(false);
    }
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
    switch (wall) {
      case Wall.north:
        return getCell(cellFrom.row - 1, cellFrom.col);
      case Wall.west:
        return getCell(cellFrom.row, cellFrom.col - 1);
      case Wall.south:
        return getCell(cellFrom.row + 1, cellFrom.col);
      case Wall.east:
        return getCell(cellFrom.row, cellFrom.col + 1);
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
    int offset;
    for (var row = 0; row < rows; row++) {
      for (col = 0; col < cols; col++) {
        offset = _offset(row, col);
        yield _cells[offset];
      }
    }
  }

  // TODO: rotate (transpose as a matrix)
}
