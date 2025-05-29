import 'dart:convert';

class MatchResult {
  final int fitScore;
  final Explanation explanation;

  MatchResult({required this.fitScore, required this.explanation});

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    dynamic explanationData = json['explanation'];
    Map<String, dynamic> explanationMap;

    if (explanationData is String) {
      // PATCH: Remove markdown code block if present (e.g., ```json ... ```)
      String cleaned = explanationData.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7).trimLeft();
      }
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3).trimLeft();
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3).trimRight();
      }
      if (cleaned.isEmpty) {
        print(
          'Explanation string is empty, defaulting to empty explanation map.',
        );
        explanationMap = {};
      } else {
        try {
          explanationMap = jsonDecode(cleaned) as Map<String, dynamic>;
        } catch (e) {
          print(
            'Failed to decode non-empty explanation string: "$cleaned". Error: $e',
          );
          explanationMap = {};
        }
      }
    } else if (explanationData is Map<String, dynamic>) {
      explanationMap = explanationData;
    } else {
      if (explanationData != null) {
        print(
          'Explanation data is not a String or Map, defaulting to empty explanation map. Type: ${explanationData.runtimeType}',
        );
      }
      explanationMap = {};
    }

    return MatchResult(
      fitScore: (json['fit_score'] as num?)?.toInt() ?? 0,
      explanation: Explanation.fromJson(explanationMap),
    );
  }
}

class Explanation {
  final List<String> matchAreas;
  final List<String> mismatches;
  final String summary;

  Explanation({
    required this.matchAreas,
    required this.mismatches,
    required this.summary,
  });

  factory Explanation.fromJson(Map<String, dynamic> json) {
    return Explanation(
      matchAreas:
          (json['match_areas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      mismatches:
          (json['mismatches'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary:
          json['summary'] as String? ?? 'No explanation summary available.',
    );
  }
}
