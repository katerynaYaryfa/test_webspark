import 'package:flutter/material.dart';
import 'package:test_task2/features/preview/ui/pages/preview_page.dart';

class ResultItemWidget extends StatelessWidget {
  const ResultItemWidget({super.key, required this.path, required this.grid});

  final String path;
  final List<List<String>> grid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewPage(path: path, grid: grid),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          path ?? '',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
