import '../../core/constants/database_constants.dart';

class Topic {
  final int id;
  final String title;
  final String? description;
  final String? iconPath;
  final int questionCount;

  Topic({
    required this.id,
    required this.title,
    this.description,
    this.iconPath,
    this.questionCount = 0,
  });

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map[DatabaseConstants.topicId] as int,
      title: map[DatabaseConstants.topicTitle] as String,
      description: map[DatabaseConstants.topicDescription] as String?,
      iconPath: map[DatabaseConstants.topicIconPath] as String?,
      questionCount: map[DatabaseConstants.topicQuestionCount] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.topicId: id,
      DatabaseConstants.topicTitle: title,
      DatabaseConstants.topicDescription: description,
      DatabaseConstants.topicIconPath: iconPath,
      DatabaseConstants.topicQuestionCount: questionCount,
    };
  }

  Topic copyWith({
    int? id,
    String? title,
    String? description,
    String? iconPath,
    int? questionCount,
  }) {
    return Topic(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      questionCount: questionCount ?? this.questionCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Topic && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Topic{id: $id, title: $title, questionCount: $questionCount}';
  }
}