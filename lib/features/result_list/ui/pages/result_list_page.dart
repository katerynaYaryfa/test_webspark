import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task2/features/process/providers/process_provider.dart';
import 'package:test_task2/features/result_list/ui/widgets/result_item_widget.dart';

class ResultListPage extends StatelessWidget {
  const ResultListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final path1 = context.watch<ProcessProvider>().resultPath1;
    final path2 = context.watch<ProcessProvider>().resultPath2;
    final grid1 = context.watch<ProcessProvider>().grid1;
    final grid2 = context.watch<ProcessProvider>().grid2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result List Page'),
      ),
      body: Column(
        children: [
          ResultItemWidget(path: path1, grid: grid1),
          ResultItemWidget(path: path2, grid: grid2),
        ],
      ),
    );
  }
}
