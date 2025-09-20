import '../models/question.dart';
import '../../core/database/database_service.dart';
import '../../core/constants/app_constants.dart';

class QuestionRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Question>> getQuestionsByTopic(int topicId) async {
    try {
      final maps = await _databaseService.getQuestionsByTopic(topicId);
      return maps.map((map) => Question.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get questions by topic: $e');
    }
  }

  Future<List<Question>> getRandomQuestions(int count, {int? topicId}) async {
    try {
      final maps = await _databaseService.getRandomQuestions(count, topicId: topicId);
      return maps.map((map) => Question.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get random questions: $e');
    }
  }

  Future<List<Question>> getMandatoryQuestions({int? topicId}) async {
    try {
      final maps = await _databaseService.getMandatoryQuestions(topicId: topicId);
      return maps.map((map) => Question.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get mandatory questions: $e');
    }
  }

  Future<List<Question>> getExamQuestions() async {
    try {
      final maps = await _databaseService.getExamQuestions();
      return maps.map((map) => Question.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get exam questions: $e');
    }
  }

  Future<List<Question>> getPracticeQuestions(int count, {int? topicId}) async {
    try {
      final maps = await _databaseService.getRandomQuestions(count, topicId: topicId);
      return maps.map((map) => Question.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get practice questions: $e');
    }
  }

  Future<Question?> getQuestionById(int id) async {
    try {
      final map = await _databaseService.getQuestionById(id);
      return map != null ? Question.fromMap(map) : null;
    } catch (e) {
      throw Exception('Failed to get question by id: $e');
    }
  }

  Future<int> insertQuestion(Question question) async {
    try {
      return await _databaseService.insertQuestion(question.toMap());
    } catch (e) {
      throw Exception('Failed to insert question: $e');
    }
  }

  Future<void> insertQuestions(List<Question> questions) async {
    try {
      for (final question in questions) {
        await insertQuestion(question);
      }
    } catch (e) {
      throw Exception('Failed to insert questions: $e');
    }
  }

  Future<int> getQuestionCountByTopic(int topicId) async {
    try {
      return await _databaseService.getQuestionCountByTopic(topicId);
    } catch (e) {
      throw Exception('Failed to get question count by topic: $e');
    }
  }

  Future<List<Question>> getQuestionsByDifficulty(int difficulty, {int? topicId}) async {
    try {
      // This would need to be implemented in DatabaseService
      final allQuestions = topicId != null
          ? await getQuestionsByTopic(topicId)
          : await getAllQuestions();

      return allQuestions.where((q) => q.difficulty == difficulty).toList();
    } catch (e) {
      throw Exception('Failed to get questions by difficulty: $e');
    }
  }

  Future<List<Question>> getAllQuestions() async {
    try {
      final maps = await _databaseService.getRandomQuestions(10000); // Large number to get all
      return maps.map((map) => Question.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all questions: $e');
    }
  }

  Future<List<Question>> getQuestionsWithMedia({String? mediaType}) async {
    try {
      final allQuestions = await getAllQuestions();

      if (mediaType != null) {
        return allQuestions.where((q) => q.mediaType == mediaType).toList();
      } else {
        return allQuestions.where((q) => q.hasMedia).toList();
      }
    } catch (e) {
      throw Exception('Failed to get questions with media: $e');
    }
  }

  Future<bool> hasQuestions() async {
    try {
      final questions = await getRandomQuestions(1);
      return questions.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<int> getTotalQuestionsCount() async {
    try {
      final questions = await getAllQuestions();
      return questions.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getMandatoryQuestionsCount() async {
    try {
      final mandatoryQuestions = await getMandatoryQuestions();
      return mandatoryQuestions.length;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<int, int>> getQuestionCountsByTopic() async {
    try {
      final Map<int, int> counts = {};
      final allQuestions = await getAllQuestions();

      for (final question in allQuestions) {
        counts[question.topicId] = (counts[question.topicId] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get question counts by topic: $e');
    }
  }

  Future<List<Question>> searchQuestions(String query, {int? topicId}) async {
    try {
      final allQuestions = topicId != null
          ? await getQuestionsByTopic(topicId)
          : await getAllQuestions();

      final lowercaseQuery = query.toLowerCase();

      return allQuestions.where((question) {
        final titleMatch = question.title?.toLowerCase().contains(lowercaseQuery) ?? false;
        final contentMatch = question.content.toLowerCase().contains(lowercaseQuery);
        return titleMatch || contentMatch;
      }).toList();
    } catch (e) {
      throw Exception('Failed to search questions: $e');
    }
  }

  Future<List<Question>> getWrongAnsweredQuestions(List<int> questionIds) async {
    try {
      final List<Question> questions = [];

      for (final id in questionIds) {
        final question = await getQuestionById(id);
        if (question != null) {
          questions.add(question);
        }
      }

      return questions;
    } catch (e) {
      throw Exception('Failed to get wrong answered questions: $e');
    }
  }

  Future<List<Question>> getMixedTestQuestions({
    required int totalCount,
    int? topicId,
    bool includeMandatory = true,
  }) async {
    try {
      List<Question> selectedQuestions = [];

      if (includeMandatory) {
        // Get mandatory questions first
        final mandatoryQuestions = await getMandatoryQuestions(topicId: topicId);
        final mandatoryCount = mandatoryQuestions.length > AppConstants.mandatoryQuestionCount
            ? AppConstants.mandatoryQuestionCount
            : mandatoryQuestions.length;

        if (mandatoryQuestions.isNotEmpty) {
          mandatoryQuestions.shuffle();
          selectedQuestions.addAll(mandatoryQuestions.take(mandatoryCount));
        }
      }

      // Get remaining random questions
      final remainingCount = totalCount - selectedQuestions.length;
      if (remainingCount > 0) {
        final randomQuestions = await getRandomQuestions(remainingCount * 2, topicId: topicId); // Get more to filter

        // Filter out already selected questions
        final filteredQuestions = randomQuestions
            .where((q) => !selectedQuestions.any((selected) => selected.id == q.id))
            .toList();

        filteredQuestions.shuffle();
        selectedQuestions.addAll(filteredQuestions.take(remainingCount));
      }

      // Shuffle final list
      selectedQuestions.shuffle();
      return selectedQuestions;
    } catch (e) {
      throw Exception('Failed to get mixed test questions: $e');
    }
  }
}