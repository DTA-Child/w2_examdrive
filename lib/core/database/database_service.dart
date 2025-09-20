import '../constants/database_constants.dart';
import 'database_helper.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Topics operations
  Future<List<Map<String, dynamic>>> getAllTopics() async {
    return await _dbHelper.query(
      DatabaseConstants.tableTopics,
      orderBy: '${DatabaseConstants.topicId} ASC',
    );
  }

  Future<Map<String, dynamic>?> getTopicById(int id) async {
    return await _dbHelper.queryById(DatabaseConstants.tableTopics, id);
  }

  Future<int> insertTopic(Map<String, dynamic> topic) async {
    return await _dbHelper.insert(DatabaseConstants.tableTopics, topic);
  }

  // Questions operations
  Future<List<Map<String, dynamic>>> getQuestionsByTopic(int topicId) async {
    return await _dbHelper.query(
      DatabaseConstants.tableQuestions,
      where: '${DatabaseConstants.questionTopicId} = ?',
      whereArgs: [topicId],
    );
  }

  Future<List<Map<String, dynamic>>> getRandomQuestions(int count, {int? topicId}) async {
    String sql = '''
      SELECT * FROM ${DatabaseConstants.tableQuestions}
      ${topicId != null ? 'WHERE ${DatabaseConstants.questionTopicId} = ?' : ''}
      ORDER BY RANDOM()
      LIMIT ?
    ''';

    List<dynamic> args = topicId != null ? [topicId, count] : [count];
    return await _dbHelper.rawQuery(sql, args);
  }

  Future<List<Map<String, dynamic>>> getMandatoryQuestions({int? topicId}) async {
    String whereClause = '${DatabaseConstants.questionMandatory} = ?';
    List<dynamic> whereArgs = [1];  // ← Args tương ứng

    if (topicId != null) {
      whereClause += ' AND ${DatabaseConstants.questionTopicId} = ?';
      whereArgs.add(topicId);
    }

    return await _dbHelper.query(
      DatabaseConstants.tableQuestions,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }


  Future<List<Map<String, dynamic>>> getExamQuestions() async {
    // Get mandatory questions first
    final mandatoryQuestions = await getMandatoryQuestions();
    final mandatoryCount = mandatoryQuestions.length;

    // Get remaining random questions
    final remainingCount = 30 - mandatoryCount;
    final randomQuestions = await _dbHelper.rawQuery('''
      SELECT * FROM ${DatabaseConstants.tableQuestions}
      WHERE ${DatabaseConstants.questionMandatory} = 0
      ORDER BY RANDOM()
      LIMIT ?
    ''', [remainingCount]);

    // Combine and shuffle
    final allQuestions = [...mandatoryQuestions, ...randomQuestions];
    allQuestions.shuffle();
    return allQuestions;
  }

  Future<Map<String, dynamic>?> getQuestionById(int id) async {
    return await _dbHelper.queryById(DatabaseConstants.tableQuestions, id);
  }

  Future<int> insertQuestion(Map<String, dynamic> question) async {
    return await _dbHelper.insert(DatabaseConstants.tableQuestions, question);
  }

  Future<int> getQuestionCountByTopic(int topicId) async {
    return await _dbHelper.getCount(
      DatabaseConstants.tableQuestions,
      where: '${DatabaseConstants.questionTopicId} = ?',
      whereArgs: [topicId],
    );
  }

  // Test Results operations
  Future<int> insertTestResult(Map<String, dynamic> result) async {
    return await _dbHelper.insert(DatabaseConstants.tableTestResults, result);
  }

  Future<List<Map<String, dynamic>>> getAllTestResults() async {
    return await _dbHelper.query(
      DatabaseConstants.tableTestResults,
      orderBy: '${DatabaseConstants.resultStartTime} DESC',
    );
  }

  Future<Map<String, dynamic>?> getTestResultById(int id) async {
    return await _dbHelper.queryById(DatabaseConstants.tableTestResults, id);
  }

  Future<List<Map<String, dynamic>>> getRecentTestResults({int limit = 10}) async {
    return await _dbHelper.query(
      DatabaseConstants.tableTestResults,
      orderBy: '${DatabaseConstants.resultStartTime} DESC',
      limit: limit,
    );
  }

  // Answer Details operations
  Future<int> insertAnswerDetail(Map<String, dynamic> detail) async {
    return await _dbHelper.insert(DatabaseConstants.tableAnswerDetails, detail);
  }

  Future<List<Map<String, dynamic>>> getAnswerDetailsByResult(int resultId) async {
    return await _dbHelper.query(
      DatabaseConstants.tableAnswerDetails,
      where: '${DatabaseConstants.detailResultId} = ?',
      whereArgs: [resultId],
    );
  }

  Future<void> insertAnswerDetails(List<Map<String, dynamic>> details) async {
    for (final detail in details) {
      await insertAnswerDetail(detail);
    }
  }

  // Statistics operations
  Future<Map<String, dynamic>> getStatistics() async {
    final totalTests = await _dbHelper.getCount(DatabaseConstants.tableTestResults);

    final passedTests = await _dbHelper.getCount(
      DatabaseConstants.tableTestResults,
      where: '${DatabaseConstants.resultIsPassed} = ?',
      whereArgs: [1],
    );

    final avgScoreResult = await _dbHelper.rawQuery('''
      SELECT AVG(${DatabaseConstants.resultScore}) as avg_score
      FROM ${DatabaseConstants.tableTestResults}
    ''');

    final avgScore = avgScoreResult.first['avg_score'] ?? 0.0;
    final passRate = totalTests > 0 ? (passedTests / totalTests) * 100 : 0.0;

    return {
      'total_tests': totalTests,
      'passed_tests': passedTests,
      'failed_tests': totalTests - passedTests,
      'pass_rate': passRate,
      'average_score': avgScore,
    };
  }

  // Utility operations
  Future<bool> isDatabaseEmpty() async {
    final topicCount = await _dbHelper.getCount(DatabaseConstants.tableTopics);
    return topicCount == 0;
  }

  Future<void> clearAllData() async {
    await _dbHelper.rawDelete('DELETE FROM ${DatabaseConstants.tableAnswerDetails}');
    await _dbHelper.rawDelete('DELETE FROM ${DatabaseConstants.tableTestResults}');
    await _dbHelper.rawDelete('DELETE FROM ${DatabaseConstants.tableQuestions}');
    await _dbHelper.rawDelete('DELETE FROM ${DatabaseConstants.tableTopics}');
  }

  Future<void> updateTopicQuestionCounts() async {
    final topics = await getAllTopics();
    for (final topic in topics) {
      final count = await getQuestionCountByTopic(topic['id']);
      await _dbHelper.update(DatabaseConstants.tableTopics, {
        'id': topic['id'],
        'question_count': count,
        ...topic,
      });
    }
  }
}