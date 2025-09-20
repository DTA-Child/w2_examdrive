import '../models/test_result.dart';
import '../models/answer_detail.dart';
import '../../core/database/database_service.dart';

class ResultRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<int> insertTestResult(TestResult result) async {
    try {
      return await _databaseService.insertTestResult(result.toMap());
    } catch (e) {
      throw Exception('Failed to insert test result: $e');
    }
  }

  Future<void> insertAnswerDetail(AnswerDetail detail) async {
    try {
      await _databaseService.insertAnswerDetail(detail.toMap());
    } catch (e) {
      throw Exception('Failed to insert answer detail: $e');
    }
  }

  Future<void> insertAnswerDetails(List<AnswerDetail> details) async {
    try {
      await _databaseService.insertAnswerDetails(details.map((d) => d.toMap()).toList());
    } catch (e) {
      throw Exception('Failed to insert answer details: $e');
    }
  }

  Future<int> saveCompleteTestResult(TestResult result, List<AnswerDetail> answerDetails) async {
    try {
      // Insert test result first
      final resultId = await insertTestResult(result);

      // Update answer details with result ID and insert them
      final updatedDetails = answerDetails.map((detail) =>
          detail.copyWith(resultId: resultId)).toList();

      await insertAnswerDetails(updatedDetails);

      return resultId;
    } catch (e) {
      throw Exception('Failed to save complete test result: $e');
    }
  }

  Future<List<TestResult>> getAllTestResults() async {
    try {
      final maps = await _databaseService.getAllTestResults();
      return maps.map((map) => TestResult.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all test results: $e');
    }
  }

  Future<List<TestResult>> getRecentTestResults({int limit = 10}) async {
    try {
      final maps = await _databaseService.getRecentTestResults(limit: limit);
      return maps.map((map) => TestResult.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get recent test results: $e');
    }
  }

  Future<TestResult?> getTestResultById(int id) async {
    try {
      final map = await _databaseService.getTestResultById(id);
      return map != null ? TestResult.fromMap(map) : null;
    } catch (e) {
      throw Exception('Failed to get test result by id: $e');
    }
  }

  Future<List<AnswerDetail>> getAnswerDetailsByResult(int resultId) async {
    try {
      final maps = await _databaseService.getAnswerDetailsByResult(resultId);
      return maps.map((map) => AnswerDetail.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get answer details by result: $e');
    }
  }

  Future<TestResult?> getTestResultWithDetails(int resultId) async {
    try {
      final result = await getTestResultById(resultId);
      if (result == null) return null;

      final answerDetails = await getAnswerDetailsByResult(resultId);
      return result.copyWith(answerDetails: answerDetails);
    } catch (e) {
      throw Exception('Failed to get test result with details: $e');
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _databaseService.getStatistics();
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }

  Future<List<TestResult>> getTestResultsByType(String testType) async {
    try {
      final allResults = await getAllTestResults();
      return allResults.where((result) => result.testType == testType).toList();
    } catch (e) {
      throw Exception('Failed to get test results by type: $e');
    }
  }

  Future<List<TestResult>> getPassedTestResults() async {
    try {
      final allResults = await getAllTestResults();
      return allResults.where((result) => result.isPassed).toList();
    } catch (e) {
      throw Exception('Failed to get passed test results: $e');
    }
  }

  Future<List<TestResult>> getFailedTestResults() async {
    try {
      final allResults = await getAllTestResults();
      return allResults.where((result) => !result.isPassed).toList();
    } catch (e) {
      throw Exception('Failed to get failed test results: $e');
    }
  }

  Future<double> getAverageScore() async {
    try {
      final stats = await getStatistics();
      return stats['average_score']?.toDouble() ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getPassRate() async {
    try {
      final stats = await getStatistics();
      return stats['pass_rate']?.toDouble() ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<int> getTotalTestsCount() async {
    try {
      final results = await getAllTestResults();
      return results.length;
    } catch (e) {
      return 0;
    }
  }

  Future<TestResult?> getLastTestResult() async {
    try {
      final results = await getRecentTestResults(limit: 1);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      return null;
    }
  }

  Future<TestResult?> getBestScore() async {
    try {
      final results = await getAllTestResults();
      if (results.isEmpty) return null;

      results.sort((a, b) => b.score.compareTo(a.score));
      return results.first;
    } catch (e) {
      return null;
    }
  }

  Future<List<int>> getWrongAnsweredQuestionIds({int? limit}) async {
    try {
      final allResults = await getAllTestResults();
      final Set<int> wrongQuestionIds = {};

      for (final result in allResults) {
        final details = await getAnswerDetailsByResult(result.id!);
        final wrongDetails = details.where((d) => !d.isCorrect);

        for (final detail in wrongDetails) {
          wrongQuestionIds.add(detail.questionId);
        }
      }

      final wrongList = wrongQuestionIds.toList();
      if (limit != null && wrongList.length > limit) {
        return wrongList.take(limit).toList();
      }

      return wrongList;
    } catch (e) {
      throw Exception('Failed to get wrong answered question ids: $e');
    }
  }

  Future<Map<int, int>> getQuestionAccuracy() async {
    try {
      final Map<int, int> correctCounts = {};
      final Map<int, int> totalCounts = {};

      final allResults = await getAllTestResults();

      for (final result in allResults) {
        final details = await getAnswerDetailsByResult(result.id!);

        for (final detail in details) {
          totalCounts[detail.questionId] = (totalCounts[detail.questionId] ?? 0) + 1;

          if (detail.isCorrect) {
            correctCounts[detail.questionId] = (correctCounts[detail.questionId] ?? 0) + 1;
          }
        }
      }

      final Map<int, int> accuracy = {};
      for (final questionId in totalCounts.keys) {
        final correct = correctCounts[questionId] ?? 0;
        final total = totalCounts[questionId] ?? 1;
        accuracy[questionId] = ((correct / total) * 100).round();
      }

      return accuracy;
    } catch (e) {
      throw Exception('Failed to get question accuracy: $e');
    }
  }

  Future<bool> hasTestResults() async {
    try {
      final results = await getRecentTestResults(limit: 1);
      return results.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteTestResult(int resultId) async {
    try {
      // This would need to be implemented in DatabaseService
      // For now, we'll throw an exception
      throw UnimplementedError('Delete test result not implemented');
    } catch (e) {
      throw Exception('Failed to delete test result: $e');
    }
  }

  Future<void> clearAllResults() async {
    try {
      // This would need to be implemented in DatabaseService
      throw UnimplementedError('Clear all results not implemented');
    } catch (e) {
      throw Exception('Failed to clear all results: $e');
    }
  }
}