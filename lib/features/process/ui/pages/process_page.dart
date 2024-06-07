import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task2/features/process/providers/process_provider.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key, required this.apiUrl});

  final String apiUrl;

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Process page'),
      ),
      body: Center(
        child: Consumer<ProcessProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provider.progress == 100)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child:
                        Text('All calculations has finished, you can send your results to server'),
                  ),
                Text('${provider.progress}%'),
                const SizedBox(height: 20),
                CircularProgressIndicator(value: provider.progress / 100),
                const SizedBox(height: 20),
                if (provider.progress == 100)
                  FilledButton.tonal(
                    onPressed: () {
                      context.read<ProcessProvider>().sendResults(context);
                    },
                    child: const Text('Send results to server'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
