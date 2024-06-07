import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.path, required this.grid}) : super(key: key);

  final String? path;

  final List<List<String>> grid;

  List<String> mapGrid() {
    List<String> mappedGrid = [];
    for (int i = 0; i < grid.length; i++) {
      String line = '';
      for (int j = 0; j < grid[i].length; j++) {
        line += grid[i][j];
      }
      mappedGrid.add(line);
    }

    return mappedGrid;
  }

  @override
  Widget build(BuildContext context) {
    List<List<Color>> colors = generateColors();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Preview Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: grid.length,
              itemBuilder: (context, rowIndex) {
                String line = mapGrid()[rowIndex];
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: line.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: line.length,
                  ),
                  itemBuilder: (BuildContext context, int columnIndex) {
                    Color backgroundColor =
                        line[columnIndex] == 'X' ? Colors.black : colors[rowIndex][columnIndex];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: backgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          '$rowIndex.$columnIndex',
                          style: TextStyle(
                            color: line[columnIndex] == '.' ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (path != null)
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text('Path: $path'),
            ),
        ],
      ),
    );
  }

  List<List<Color>> generateColors() {
    List<List<Color>> colors =
        List.generate(grid.length, (_) => List.filled(grid[0].length, Colors.white));

    if (path != null) {
      List<String> steps = path!.split(')->(');
      steps[0] = steps[0].substring(1);
      steps[steps.length - 1] =
          steps[steps.length - 1].substring(0, steps[steps.length - 1].length - 1);

      for (String step in steps) {
        List<String> coordinates = step.split(',');
        int row = int.parse(coordinates[0]);
        int col = int.parse(coordinates[1]);
        if (step == steps.first) {
          colors[row][col] = const Color(0xFF64FFDA);
        } else if (step == steps.last) {
          colors[row][col] = const Color(0xFF009688);
        } else {
          colors[row][col] = const Color(0xFF4CAF50);
        }
      }
    }

    return colors;
  }
}
