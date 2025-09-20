import '../models/topic.dart';
import '../../core/database/database_service.dart';

class TopicRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Topic>> getAllTopics() async {
    try {
      final maps = await _databaseService.getAllTopics();
      return maps.map((map) => Topic.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get topics: $e');
    }
  }

  Future<Topic?> getTopicById(int id) async {
    try {
      final map = await _databaseService.getTopicById(id);
      return map != null ? Topic.fromMap(map) : null;
    } catch (e) {
      throw Exception('Failed to get topic by id: $e');
    }
  }

  Future<int> insertTopic(Topic topic) async {
    try {
      return await _databaseService.insertTopic(topic.toMap());
    } catch (e) {
      throw Exception('Failed to insert topic: $e');
    }
  }

  Future<void> insertTopics(List<Topic> topics) async {
    try {
      for (final topic in topics) {
        await insertTopic(topic);
      }
    } catch (e) {
      throw Exception('Failed to insert topics: $e');
    }
  }

  Future<void> updateTopicQuestionCount(int topicId, int count) async {
    try {
      final topic = await getTopicById(topicId);
      if (topic != null) {
        final updatedTopic = topic.copyWith(questionCount: count);
        await _databaseService.updateTopicQuestionCounts();
      }
    } catch (e) {
      throw Exception('Failed to update topic question count: $e');
    }
  }

  Future<void> updateAllTopicQuestionCounts() async {
    try {
      await _databaseService.updateTopicQuestionCounts();
    } catch (e) {
      throw Exception('Failed to update all topic question counts: $e');
    }
  }

  Future<bool> hasTopics() async {
    try {
      final topics = await getAllTopics();
      return topics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<int> getTopicsCount() async {
    try {
      final topics = await getAllTopics();
      return topics.length;
    } catch (e) {
      return 0;
    }
  }
}