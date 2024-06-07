import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task2/features/home/ui/pages/home_page.dart';
import 'package:test_task2/features/process/providers/process_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProcessProvider>(
          create: (context) => ProcessProvider(),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
