import 'package:flutter/material.dart';
import 'package:maze_gen/core/models/cell.dart';

class CellView extends StatefulWidget {
  final Cell cell;
  final int gridRows;
  bool visited;
  CellView(this.cell, int gridRows) : gridRows = gridRows;

  @override
  _CellViewState createState() => _CellViewState();
}

class _CellViewState extends State<CellView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: _getBorderSide(Wall.north),
          left: _getBorderSide(Wall.west),
          right: _getBorderSide(Wall.east),
          bottom: _getBorderSide(Wall.south),
        ),
        color: _cellColor(widget.cell),
      ),
      // child: Text(widget.text, style: TextStyle(fontSize: 11.0)),
    );
  }

  Color _cellColor(Cell cell) {
    if (widget.visited) {
      return Colors.orange;
    }
    if (cell.entry) {
      return Colors.red.withOpacity(0.4);
    }
    if (cell.exit) {
      return Colors.green.withOpacity(0.4);
    }

    return Colors.white;
  }

  BorderSide _getBorderSide(Wall wall) {
    // west wall is only drawn when we are in the first column
    if (wall == Wall.west) {
      if (widget.cell.col == 0 && !widget.cell.connections[wall.index]) {
        return BorderSide(width: 5.0, style: BorderStyle.solid, color: Colors.blueGrey);
      }
      return BorderSide.none;
    }

    if (wall == Wall.south) {
      if (widget.cell.row == widget.gridRows - 1) {
        return BorderSide(width: 5.0, style: BorderStyle.solid, color: Colors.blueGrey);
      }
      return BorderSide.none;
    }

    if (widget.cell.connections[wall.index]) {
      return BorderSide.none;
    }
    return BorderSide(width: 5.0, style: BorderStyle.solid, color: Colors.blueGrey);
  }
}
