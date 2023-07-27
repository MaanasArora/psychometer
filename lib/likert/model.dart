class LikertTest {
  const LikertTest(this.name, this.questions, this.scores);

  final String name;
  final List<String> questions;
  final List<LikertScore> scores;

  LikertResult score(List<int> responses) {
    List<LikertResultScore> resultScores = [];

    for (LikertScore score in scores) {
      double value = score.evaluate(responses);

      resultScores.add(LikertResultScore(score, value));
    }

    return LikertResult(resultScores);
  }

  LikertTest shuffled() {
    List<int> shuffledIndices =
        List.generate(questions.length, (index) => index);
    shuffledIndices.shuffle();

    Map<int, int> shuffleLookup =
        shuffledIndices.asMap().map((key, value) => MapEntry(value, key));

    List<String> newQuestions =
        shuffledIndices.map((index) => questions[index]).toList();

    List<LikertScore> newScores = scores
        .map((score) => LikertScore(
            score.name,
            score.questionIndices.map((index) => shuffleLookup[index]!).toSet(),
            score.weights.map(
                (index, weight) => MapEntry(shuffleLookup[index]!, weight)),
            score.mean,
            score.stdev,
            score.description))
        .toList();

    return LikertTest(name, newQuestions, newScores);
  }
}

class LikertScore {
  const LikertScore(this.name, this.questionIndices, this.weights, this.mean,
      this.stdev, this.description);

  final String name;
  final Set<int> questionIndices;
  final Map<int, double> weights;

  final double? mean;
  final double? stdev;

  final String description;

  double getMaxScore() {
    double maxPositive = 5 *
        weights.values.where((value) => value > 0).reduce(
              (value, element) => value + element,
            );
    double minNegative = 1 *
        weights.values
            .where((value) => value < 0)
            .reduce((value, element) => value + element);

    return maxPositive + minNegative;
  }

  double getMinScore() {
    double minPositive = 1 *
        weights.values.where((value) => value > 0).reduce(
              (value, element) => value + element,
            );
    double maxNegative = 5 *
        weights.values
            .where((value) => value < 0)
            .reduce((value, element) => value + element);

    return minPositive + maxNegative;
  }

  double evaluate(List<int> responses) {
    double value = 0;

    for (int index in questionIndices) {
      value += weights[index]! * responses[index];
      if (weights[index]! < 0) value += 6;
    }

    return value / questionIndices.length;
  }
}

class LikertResultScore {
  const LikertResultScore(this.score, this.value);

  final LikertScore score;
  final double value;

  double deviation() {
    return (value - score.mean!) / score.stdev!;
  }

  String describeLevel() {
    double dev = deviation();

    if (dev < -2.5) {
      return "Very Low";
    } else if (dev < -1.5) {
      return "Low";
    } else if (dev < -0.5) {
      return "Slightly Low";
    } else if (dev < 0.5) {
      return "Average";
    } else if (dev < 1.5) {
      return "Slightly high";
    } else if (dev < 2.5) {
      return "High";
    } else {
      return "Very High";
    }
  }
}

class LikertResult {
  const LikertResult(this.scores);

  final List<LikertResultScore> scores;
}
