import 'package:flutter/material.dart';
import 'package:maze_gen/core/models/cell.dart';

class CellView extends StatelessWidget {
  final Cell cell;
  final int gridRows;
  CellView(this.cell, int gridRows) : gridRows = gridRows;

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
        color: _cellColor(cell),
      ),
      // child: cell.entry || cell.exit ? Text(cellText(cell), style: TextStyle(fontSize: 11.0)) : null,
    );
  }

  String cellText(Cell cell) {
    if (cell.entry) {
      return "S";
    }
    if (cell.exit) {
      return "E";
    }
    return "";
  }

  Color _cellColor(Cell cell) {
    if (cell.visited) {
      return Colors.orange;
    }
    if (cell.entry) {
      return Colors.red.withOpacity(0.4);
    }
    if (cell.exit) {
      return Colors.green.withOpacity(0.4);
    }
    if (cell.color != null) {
      return cell.color;
    }

    return Colors.white;
  }

  BorderSide _getBorderSide(Wall wall) {
    // west wall is only drawn when we are in the first column
    if (wall == Wall.west) {
      if (cell.col == 0 && !cell.entry && !cell.connections[wall.index]) {
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
