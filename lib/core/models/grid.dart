import 'package:test_task2/core/models/coordinate.dart';

class Grid {
  List<List<String>> grid;
  late int size;

  Grid(this.grid) : size = grid.length {
    size = grid.length;
  }

  List<Coordinate> shortestPath(Coordinate start, Coordinate end) {
    List<Coordinate> path = [];

    bool isValid(int x, int y) {
      return x >= 0 && x < size && y >= 0 && y < size;
    }

    bool isUnblocked(int x, int y) {
      return isValid(x, y) && grid[x][y] != 'X';
    }

    List<Coordinate> getAdjacent(Coordinate coord) {
      List<Coordinate> adjacent = [];
      List<List<int>> directions = [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
        [-1, -1],
        [-1, 1],
        [1, -1],
        [1, 1]
      ];

      for (var dir in directions) {
        int newX = coord.x + dir[0];
        int newY = coord.y + dir[1];
        if (isUnblocked(newX, newY)) {
          adjacent.add(Coordinate(newX, newY));
        }
      }

      return adjacent;
    }

    Map<Coordinate, Coordinate?> parentMap = {};
    List<Coordinate> queue = [start];
    parentMap[start] = null;

    while (queue.isNotEmpty) {
      Coordinate? current = queue.removeAt(0);

      if (current.x == end.x && current.y == end.y) {
        while (current != null) {
          path.insert(0, current);
          current = parentMap[current];
        }
        break;
      }

      List<Coordinate> adjacent = getAdjacent(current);
      for (var next in adjacent) {
        if (!parentMap.containsKey(next)) {
          queue.add(next);
          parentMap[next] = current;
        }
      }
    }

    return path;
  }
}
