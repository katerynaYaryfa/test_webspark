import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task2/features/process/providers/process_provider.dart';
import 'package:test_task2/widgets/dialogs/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  void _validateAndNavigate() async {
    String url = _urlController.text;
    if (_isValidUrl(url)) {
      await context.read<ProcessProvider>().checkAndFetchData(url, context);
    } else {
      showErrorDialog('Invalid URL. Please enter a valid API base URL.', context);
    }
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home page'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Set valid API base URL in order to continue'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: 'API base URL',
              ),
            ),
          ),
          const Spacer(),
          FilledButton.tonal(
            onPressed: () {
              _validateAndNavigate();
            },
            child: const Text('Start counting process'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
