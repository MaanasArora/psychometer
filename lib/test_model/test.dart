import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:psychometer/likert/model.dart';

class LikertTestSerializer {
  static Future<LikertTest> fromResource(String resourceName) async {
    final String response = await rootBundle.loadString(resourceName);
    final jsonData = json.decode(response);

    List<String> questions = jsonData['questions'].cast<String>();
    List<LikertScore> scores = jsonData['scores']
        .map<LikertScore>((score) => LikertScore(
            score['name'],
            Set.from(score['weights'].keys.map((key) => int.parse(key)))
                .cast<int>(),
            score['weights']
                .map((key, value) => MapEntry(int.parse(key), value))
                .cast<int, double>(),
            score['mean'],
            score['stdev'],
            score['description']))
        .toList();

    LikertTest test = LikertTest(jsonData['name'], questions, scores);
    return test;
  }
}
