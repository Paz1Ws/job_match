import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/domain/models/match_result_model.dart';

class JobMatchService {
  final Dio _dio;

  JobMatchService(this._dio);

  Future<MatchResult?> fetchMatchResult(
    String candidateId,
    String jobOfferId,
  ) async {
    final url =
        'https://zdvibikloongkbsesogk.supabase.co/functions/v1/job-match';
    if (candidateId.isEmpty || jobOfferId.isEmpty) {
      print(
        'Error: Candidate ID or Job Offer ID is empty. Cannot fetch match result.',
      );
      return null;
    }

    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({
          'candidateId': candidateId,
          'jobOfferId': jobOfferId,
        }),
      );

      if (response.statusCode == 200) {
        // Extract the explanation value which contains the markdown-wrapped JSON
        var rawData = response.data;
        String jsonData;

        // Handle nested response structure based on your specific format
        if (rawData is Map && rawData.containsKey('explanation')) {
          // The explanation field contains the markdown-wrapped JSON
          String markdown = rawData['explanation'] as String;
          jsonData = _cleanMarkdown(markdown);
        } else if (response.toString().contains('```json')) {
          // Alternative approach if data is directly in the response string
          jsonData = _cleanMarkdown(response.toString());
        } else {
          // Fallback to using the data directly if it's already in the right format
          return MatchResult.fromJson(rawData);
        }

        // Parse the cleaned JSON string
        try {
          final parsedData = jsonDecode(jsonData) as Map<String, dynamic>;
          print('Compatibilidad: ${parsedData["fit_score"]}');
          if (parsedData.containsKey("explanation")) {
            print(
              'Explicación encontrada con ${parsedData["explanation"]["match_areas"]?.length ?? 0} áreas de match',
            );
          }
          return MatchResult.fromJson(parsedData);
        } catch (e) {
          print('Error parsing JSON: $e');
          print('Raw JSON string: $jsonData');
          return null;
        }
      } else {
        print(
          'Error fetching match result: ${response.statusCode} - ${response.data}',
        );
        return null;
      }
    } catch (e) {
      print('Exception during fetchMatchResult: $e');
      return null;
    }
  }

  // Helper method to clean markdown code blocks from the response
  String _cleanMarkdown(String markdown) {
    // Remove ```json prefix
    String cleaned = markdown.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }

    // Remove trailing ```
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }

    return cleaned.trim();
  }
}

final dioProvider = Provider<Dio>((ref) => Dio());

final jobMatchServiceProvider = Provider<JobMatchService>((ref) {
  final dio = ref.watch(dioProvider);
  return JobMatchService(dio);
});

final matchResultProvider =
    FutureProvider.family<MatchResult?, MatchRequestParams>((
      ref,
      params,
    ) async {
      final jobMatchService = ref.watch(jobMatchServiceProvider);
      if (params.candidateId == null || params.candidateId!.isEmpty) {
        return null;
      }
      return jobMatchService.fetchMatchResult(
        params.candidateId!,
        params.jobOfferId,
      );
    });

class MatchRequestParams {
  final String? candidateId;
  final String jobOfferId;

  MatchRequestParams({required this.candidateId, required this.jobOfferId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchRequestParams &&
          runtimeType == other.runtimeType &&
          candidateId == other.candidateId &&
          jobOfferId == other.jobOfferId;

  @override
  int get hashCode => candidateId.hashCode ^ jobOfferId.hashCode;
}
