import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:maze_gen/core/models/generators/binary_tree.dart';
import 'package:maze_gen/core/models/generators/sidewinder.dart';
import 'package:maze_gen/core/models/grid.dart';
import 'package:maze_gen/core/models/solvers/dijkstra.dart';
import 'package:maze_gen/ui/cell/cell_view.dart';

import 'core/models/cell.dart';

void main() => runApp(MyApp());

int gridWidth = 20;
int gridHeight = 20;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mazes',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: "Mazes"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Grid _grid = Grid(gridWidth, gridHeight);
  // HashMap<int, int> distances;
  Iterable<int> _visitedOffsets;
  Iterator<Cell> _iterator;

  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _resetGrid();
    // generate();
  }

  // void generate() {
  //   final nextGridContent = newGrid();
  //   _iterator = nextGridContent.cellsByRow().iterator;
  //   Timer.periodic(Duration(microseconds: 50), onTick);
  // }

  // void onTick(Timer timer) {
  //   if (_iterator.moveNext()) {
  //     var visited = _iterator.current;
  //     final cell = _grid.getCell(visited.row, visited.col);
  //     cell.connections = visited.connections;
  //     setState(() {});
  //     // debugPrint('visited: ${visited.row}, ${visited.col}');
  //   } else {
  //     timer.cancel();
  //     _iterator = null;
  //     setState(() {});
  //     // debugPrint('done');
  //   }
  // }

  void _resetGrid() {
    setState(() {
      _visitedOffsets = [];
      _grid = newGrid();
    });
  }

  Grid newGrid() {
    switch (_currentIndex) {
      case 0:
        return BinaryTree.on(Grid(gridWidth, gridHeight));
        break;
      case 1:
        return Sidewinder.on(Grid(gridWidth, gridHeight));
        break;
      default:
        return BinaryTree.on(Grid(gridWidth, gridHeight));
    }
  }

  void onTabTapped(int index) {
    if (index == 2) {
      setState(() {
        final solver = Dijkstra(_grid);
        final exitCell = _grid.getCellAt(_grid.exitOffset);
        _visitedOffsets = solver.pathTo(exitCell.row, exitCell.col);
        debugPrint("${_visitedOffsets.length} steps to the solution");
      });
      return;
    }

    if (index == _currentIndex) {
      return;
    }

    _currentIndex = index;
    _resetGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.import_export),
            title: new Text('Binary Tree'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.rowing),
            title: new Text('Sidewinder'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye), title: Text('Solve'))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Column(
              children: [
                for (var row = 0; row != _grid.rows; ++row)
                  Expanded(
                    child: Row(
                      children: [
                        for (var col = 0; col != _grid.cols; ++col)
                          Expanded(
                            child: cellViewForCell(row, col),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGrid,
        tooltip: 'New Maze',
        child: Icon(Icons.gesture),
      ),
    );
  }

  CellView cellViewForCell(int row, int col) {
    final isVisited = _visitedOffsets == null ? false : _visitedOffsets.contains(_grid.offset(row, col));
    return CellView(_grid.getCell(row, col), _grid.rows)..visited = isVisited;
  }
}

// TODO: prerender the 16 kind of cells and use them accordingly
