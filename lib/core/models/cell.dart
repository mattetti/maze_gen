enum Wall {
  north,
  south,
  west,
  east,
}

class Cell {
  final int row;
  final int col;
  var entry = false;
  var exit = false;
  var visited = false;
  var connections = List<bool>(Wall.values.length);

  Cell(this.row, this.col) {
    for (var i = 0; i != connections.length; ++i) {
      connections[i] = false;
    }
  }

  reset() {
    entry = false;
    exit = false;
    visited = false;
    for (var i = 0; i != connections.length; ++i) {
      connections[i] = false;
    }
  }
}
