import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_task2/core/models/coordinate.dart';
import 'package:test_task2/core/models/grid.dart';
import 'package:test_task2/features/process/ui/pages/process_page.dart';
import 'package:test_task2/features/result_list/ui/pages/result_list_page.dart';
import 'package:test_task2/widgets/dialogs/error_dialog.dart';

class ProcessProvider extends ChangeNotifier {
  ProcessProvider();

  List<Coordinate>? path1;
  List<Coordinate>? path2;

  List<List<String>> grid1 = [];
  List<List<String>> grid2 = [];

  List<Map<String, int>> convertedPath1 = [];
  List<Map<String, int>> convertedPath2 = [];

  String id1 = '';
  String id2 = '';

  String mainApiUrl = '';

  String resultPath1 = '';
  String resultPath2 = '';

  int _progress = 0;

  int get progress => _progress;

  void setProgress(int value) {
    _progress = value;
    notifyListeners();
  }

  Future<void> checkAndFetchData(String apiUrl, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonResponse = jsonDecode(response.body);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessPage(apiUrl: apiUrl),
        ),
      );
      fetchData(apiUrl, context);
    } catch (e) {
      showErrorDialog('Invalid URL. Please enter a valid API base URL.', context);
    }

    notifyListeners();
  }

  Future<void> fetchData(String apiUrl, BuildContext context) async {
    try {
      setProgress(0);

      final response = await http.get(Uri.parse(apiUrl));
      final jsonResponse = jsonDecode(response.body);
      setProgress(30);

      var data1 = jsonResponse['data'][0];
      var data2 = jsonResponse['data'][1];
      var result1 = processGrid(data1);
      setProgress(70);
      var result2 = processGrid(data2);
      setProgress(100);
      path1 = result1['path'];
      path2 = result2['path'];
      grid1 = result1['grid'];
      grid2 = result2['grid'];
      id1 = result1['id'];
      id2 = result2['id'];
      mainApiUrl = apiUrl;

      convertedPath1 = convertPath(path1);
      convertedPath2 = convertPath(path2);
    } catch (e) {
      showErrorDialog('Invalid URL. Please enter a valid API base URL.', context);
    }
    notifyListeners();
  }

  Map<String, dynamic> processGrid(dynamic data) {
    List<String> field = (data['field'] as List).cast<String>();
    int startX = data['start']['x'];
    int startY = data['start']['y'];
    int endX = data['end']['x'];
    int endY = data['end']['y'];
    String id = data['id'];

    List<List<String>> grid = field.map((row) => row.split('')).toList();

    List<Coordinate> path = getShortestPath(grid, startX, startY, endX, endY);

    return {
      'grid': grid,
      'path': path,
      'id': id,
    };
  }

  List<Map<String, int>> convertPath(List<Coordinate>? path) {
    return path?.map((coordinate) => {'x': coordinate.y, 'y': coordinate.x}).toList() ?? [];
  }

  List<Coordinate> getShortestPath(
      List<List<String>> grid, int startX, int startY, int endX, int endY) {
    Grid gameGrid = Grid(grid);
    Coordinate start = Coordinate(startY, startX);
    Coordinate end = Coordinate(endY, endX);
    List<Coordinate> path = gameGrid.shortestPath(start, end);
    return path;
  }

  Future<void> sendResults(BuildContext context) async {
    await _sendResultsToServer(convertedPath1, mainApiUrl, id1);
    resultPath1 = convertedPath1.map((step) => '(${step['x']},${step['y']})').join('->');

    await _sendResultsToServer(convertedPath2, mainApiUrl, id2);
    resultPath2 = convertedPath2.map((step) => '(${step['x']},${step['y']})').join('->');

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultListPage(),
        ));
  }

  Future<String> _sendResultsToServer(List<Map<String, int>> path, String apiUrl, String id) async {
    try {
      List<Map<String, dynamic>> steps = path
          .map((step) => {
                'x': step['x'].toString(),
                'y': step['y'].toString(),
              })
          .toList();

      String pathString = path.map((step) => '(${step['x']},${step['y']})').join('->');

      final requestBody = [
        {
          'id': id,
          'result': {
            'steps': steps,
            'path': pathString,
          }
        }
      ];

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      return pathString;
    } catch (e) {}
    return '';
  }
}
