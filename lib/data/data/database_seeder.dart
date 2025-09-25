import '../../core/database/database_service.dart';
import '../../core/database/database_helper.dart';
import '../repositories/topic_repository.dart';
import '../repositories/question_repository.dart';
import '../data/topics_data.dart';
import '../data/questions_data.dart';

class DatabaseSeeder {
  final DatabaseService _databaseService = DatabaseService();
  final TopicRepository _topicRepository = TopicRepository();
  final QuestionRepository _questionRepository = QuestionRepository();

  Future<void> addRealData() async {
    try {
      print('🚀 Starting to add real driving test data...');

      // Add topics first
      await _addTopics();

      // Add questions
      await _addQuestions();

      // Update topic question counts - SỬ DỤNG CÁCH ĐẾM TRỰC TIẾP
      await _updateTopicQuestionCountsDirect();

      print('✅ Real data added successfully!');
    } catch (e) {
      print('❌ Error adding real data: $e');
      rethrow;
    }
  }

  Future<void> _addTopics() async {
    print('📚 Adding topics...');

    final topics = TopicsData.getTopics();

    for (final topic in topics) {
      try {
        await _topicRepository.insertTopic(topic);
        print('  ✓ Added topic: ${topic.title}');
      } catch (e) {
        print('  ❌ Error adding topic ${topic.title}: $e');
      }
    }
  }

  Future<void> _addQuestions() async {
    print('❓ Adding questions...');

    final questions = QuestionsData.getQuestions();

    int addedCount = 0;
    for (final question in questions) {
      try {
        await _questionRepository.insertQuestion(question);
        addedCount++;

        if (addedCount % 50 == 0) {
          print('  ✓ Added $addedCount questions...');
        }
      } catch (e) {
        print('  ❌ Error adding question ${question.id}: $e');
      }
    }

    print('  ✅ Total questions added: $addedCount');

    final mandatoryCount = questions.where((q) => q.mandatory).length;
    print('  📍 Mandatory questions: $mandatoryCount');
  }

  // SỬ DỤNG CÁCH ĐẾM TRỰC TIẾP
  Future<void> _updateTopicQuestionCountsDirect() async {
    print('🔄 Updating topic question counts using direct counting...');

    try {
      // Đếm câu hỏi cho từng topic ID cụ thể
      final topicQuestionCounts = <int, int>{};

      // Đếm từng topic một cách trực tiếp
      final allQuestions = QuestionsData.getQuestions();

      // Khởi tạo count = 0 cho tất cả topics
      for (int topicId = 1; topicId <= 6; topicId++) {
        topicQuestionCounts[topicId] = 0;
      }

      // Đếm questions theo topic_id
      for (final question in allQuestions) {
        topicQuestionCounts[question.topicId] = (topicQuestionCounts[question.topicId] ?? 0) + 1;
      }

      print('📊 Question counts per topic:');
      topicQuestionCounts.forEach((topicId, count) {
        print('  Topic $topicId: $count questions');
      });

      // Update database trực tiếp
      final db = await DatabaseHelper.instance.database;

      for (final entry in topicQuestionCounts.entries) {
        final topicId = entry.key;
        final questionCount = entry.value;

        await db.rawUpdate(
            'UPDATE topics SET question_count = ? WHERE id = ?',
            [questionCount, topicId]
        );

        print('  ✓ Updated topic $topicId with $questionCount questions');
      }

      // Verify ngay lập tức
      await _verifyTopicCountsDirect(topicQuestionCounts);

      print('  ✅ Topic question counts updated successfully');

    } catch (e) {
      print('  ❌ Error updating topic question counts: $e');
      rethrow;
    }
  }

  Future<void> _verifyTopicCountsDirect(Map<int, int> expectedCounts) async {
    print('🔍 Verifying topic question counts...');

    try {
      final db = await DatabaseHelper.instance.database;

      bool allCorrect = true;

      for (final entry in expectedCounts.entries) {
        final topicId = entry.key;
        final expectedCount = entry.value;

        // Lấy stored count từ database
        final result = await db.query(
          'topics',
          columns: ['question_count'],
          where: 'id = ?',
          whereArgs: [topicId],
        );

        if (result.isNotEmpty) {
          final storedCount = result.first['question_count'] as int? ?? 0;

          if (storedCount == expectedCount) {
            print('  ✓ Topic $topicId: $storedCount questions (correct)');
          } else {
            print('  ❌ Topic $topicId: expected $expectedCount, got $storedCount');
            allCorrect = false;

            // Fix ngay lập tức
            await db.rawUpdate(
                'UPDATE topics SET question_count = ? WHERE id = ?',
                [expectedCount, topicId]
            );
            print('  🔧 Fixed topic $topicId');
          }
        } else {
          print('  ❌ Topic $topicId not found in database');
          allCorrect = false;
        }
      }

      if (allCorrect) {
        print('  ✅ All topic question counts are correct');
      } else {
        print('  ⚠️ Some counts were incorrect but have been fixed');
      }

    } catch (e) {
      print('  ❌ Error verifying topic counts: $e');
    }
  }

  // Debug method để kiểm tra kết quả cuối cùng
  Future<void> debugFinalResults() async {
    try {
      print('🔍 Final Database State:');

      final db = await DatabaseHelper.instance.database;

      // Lấy tất cả topics với question_count
      final topics = await db.query('topics', orderBy: 'id');

      print('📊 Topics with question counts:');
      for (final topic in topics) {
        final topicId = topic['id'];
        final title = topic['title'];
        final questionCount = topic['question_count'];

        print('  ID: $topicId');
        print('  Title: $title');
        print('  Question Count: $questionCount');
        print('  ---');
      }

      // Đếm tổng số questions
      final totalQuestionsResult = await db.rawQuery('SELECT COUNT(*) as count FROM questions');
      final totalQuestions = totalQuestionsResult.first['count'];
      print('📈 Total questions in database: $totalQuestions');

      // Đếm questions theo topic từ database
      print('📈 Actual questions per topic in database:');
      for (int i = 1; i <= 6; i++) {
        final countResult = await db.rawQuery(
            'SELECT COUNT(*) as count FROM questions WHERE topic_id = ?',
            [i]
        );
        final count = countResult.first['count'];
        print('  Topic $i: $count questions');
      }

    } catch (e) {
      print('❌ Debug error: $e');
    }
  }

  // Utility methods
  Future<void> seedDatabase() async {
    await addRealData();
    await debugFinalResults();
  }

  Future<bool> isDatabaseEmpty() async {
    try {
      return await _databaseService.isDatabaseEmpty();
    } catch (e) {
      print('Error checking if database is empty: $e');
      return true;
    }
  }

  Future<void> seedIfEmpty() async {
    try {
      final isEmpty = await isDatabaseEmpty();
      if (isEmpty) {
        print('Database is empty, adding real data...');
        await addRealData();
        await debugFinalResults();
      } else {
        print('Database already contains data');
        await debugFinalResults();
      }
    } catch (e) {
      print('Error in seedIfEmpty: $e');
      rethrow;
    }
  }

  Future<void> clearAllData() async {
    try {
      print('Clearing all data from database...');
      await _databaseService.clearAllData();
      print('All data cleared successfully');
    } catch (e) {
      print('Error clearing data: $e');
      rethrow;
    }
  }

  // Recreate database method
  Future<void> recreateDatabase() async {
    try {
      print('🗑️ Recreating database...');

      // Clear all data
      await clearAllData();

      // Add fresh data
      await addRealData();

      // Debug final state
      await debugFinalResults();

      print('✅ Database recreated successfully!');
    } catch (e) {
      print('❌ Error recreating database: $e');
      rethrow;
    }
  }

  // Method để force fix question counts bất cứ lúc nào
  Future<void> fixQuestionCounts() async {
    print('🔧 Force fixing question counts...');
    await _updateTopicQuestionCountsDirect();
    await debugFinalResults();
  }
}
