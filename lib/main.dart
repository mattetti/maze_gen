import 'package:flutter/material.dart';
import 'package:maze_gen/core/models/grid.dart';

import 'core/models/binary_tree.dart';
import 'core/models/cell.dart';
import 'core/models/sidewinder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matt\'s Maze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Matt's Maze"),
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
  Grid _grid = BinaryTree.on(Grid(30, 30));
  var _currentIndex = 0;

  _resetGrid() {
    setState(() {
      switch (_currentIndex) {
        case 0:
          _grid = BinaryTree.on(Grid(30, 30));
          break;
        case 1:
          _grid = Sidewinder.on(Grid(30, 30));
          break;
        default:
          _grid = BinaryTree.on(Grid(30, 30));
      }
    });
  }

  void onTabTapped(int index) {
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
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Column(
            children: [
              for (var row = 0; row != _grid.rows; ++row)
                Expanded(
                  child: Row(
                    children: [
                      for (var col = 0; col != _grid.cols; ++col)
                        Expanded(
                          child: CellView(_grid.getCell(row, col), _grid.rows),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGrid,
        tooltip: 'Regen',
        child: Icon(Icons.gesture),
      ),
    );
  }
}

class CellView extends StatelessWidget {
  final Cell cell;
  final int gridRows;
  CellView(this.cell, this.gridRows);

  @override
  Widget build(BuildContext context) {
    // TODO: switch to custom painter
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: _getBorderSide(Wall.north),
          left: _getBorderSide(Wall.west),
          right: _getBorderSide(Wall.east),
          bottom: _getBorderSide(Wall.south),
        ),
        color:
            cell.entry ? Colors.green.withOpacity(0.3) : cell.exit ? Colors.greenAccent.withOpacity(0.3) : Colors.white,
      ),
    );
  }

  BorderSide _getBorderSide(Wall wall) {
    // west wall is only drawn when we are in the first column
    if (wall == Wall.west) {
      if (cell.col == 0 && !cell.connections[wall.index]) {
        return BorderSide(width: 5.0, style: BorderStyle.solid, color: Colors.blueGrey);
      }
      return BorderSide.none;
    }

    if (wall == Wall.south) {
      if (cell.row == gridRows - 1) {
        return BorderSide(width: 5.0, style: BorderStyle.solid, color: Colors.blueGrey);
      }
      return BorderSide.none;
    }

    if (cell.connections[wall.index]) {
      return BorderSide.none;
    }
    return BorderSide(width: 5.0, style: BorderStyle.solid, color: Colors.blueGrey);
  }
}
