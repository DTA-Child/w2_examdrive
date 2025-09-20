import '../../core/constants/database_constants.dart';
import '../../core/constants/app_constants.dart';

class Question {
  final int id;
  final String? title;
  final String content;
  final String? audio;
  final String mediaType;
  final String? ansA;
  final String? ansB;
  final String? ansC;
  final String? ansD;
  final String ansRight;
  final String? ansHint;
  final int topicId;
  final bool mandatory;
  final int difficulty;

  Question({
    required this.id,
    this.title,
    required this.content,
    this.audio,
    this.mediaType = AppConstants.mediaTypeNone,
    this.ansA,
    this.ansB,
    this.ansC,
    this.ansD,
    required this.ansRight,
    this.ansHint,
    required this.topicId,
    this.mandatory = false,
    this.difficulty = 1,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map[DatabaseConstants.questionId] as int,
      title: map[DatabaseConstants.questionTitle] as String?,
      content: map[DatabaseConstants.questionContent] as String,
      audio: map[DatabaseConstants.questionAudio] as String?,
      mediaType: map[DatabaseConstants.questionMediaType] as String? ?? AppConstants.mediaTypeNone,
      ansA: map[DatabaseConstants.questionAnsA] as String?,
      ansB: map[DatabaseConstants.questionAnsB] as String?,
      ansC: map[DatabaseConstants.questionAnsC] as String?,
      ansD: map[DatabaseConstants.questionAnsD] as String?,
      ansRight: map[DatabaseConstants.questionAnsRight] as String,
      ansHint: map[DatabaseConstants.questionAnsHint] as String?,
      topicId: map[DatabaseConstants.questionTopicId] as int,
      mandatory: (map[DatabaseConstants.questionMandatory] as int? ?? 0) == 1,
      difficulty: map[DatabaseConstants.questionDifficulty] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.questionId: id,
      DatabaseConstants.questionTitle: title,
      DatabaseConstants.questionContent: content,
      DatabaseConstants.questionAudio: audio,
      DatabaseConstants.questionMediaType: mediaType,
      DatabaseConstants.questionAnsA: ansA,
      DatabaseConstants.questionAnsB: ansB,
      DatabaseConstants.questionAnsC: ansC,
      DatabaseConstants.questionAnsD: ansD,
      DatabaseConstants.questionAnsRight: ansRight,
      DatabaseConstants.questionAnsHint: ansHint,
      DatabaseConstants.questionTopicId: topicId,
        DatabaseConstants.questionMandatory: mandatory ? 1 : 0,
      DatabaseConstants.questionDifficulty: difficulty,
    };
  }

  List<String> getAnswersList() {
    final answers = <String>[];
    if (ansA != null && ansA!.isNotEmpty) answers.add(ansA!);
    if (ansB != null && ansB!.isNotEmpty) answers.add(ansB!);
    if (ansC != null && ansC!.isNotEmpty) answers.add(ansC!);
    if (ansD != null && ansD!.isNotEmpty) answers.add(ansD!);
    return answers;
  }

  String? getAnswerByOption(String option) {
    switch (option.toUpperCase()) {
      case 'A':
        return ansA;
      case 'B':
        return ansB;
      case 'C':
        return ansC;
      case 'D':
        return ansD;
      default:
        return null;
    }
  }

  bool get hasMedia => audio != null && audio!.isNotEmpty && mediaType != AppConstants.mediaTypeNone;

  bool get hasImage => mediaType == AppConstants.mediaTypeImage;

  bool get hasAudio => mediaType == AppConstants.mediaTypeAudio;

  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Dễ';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Khó';
      default:
        return 'Không xác định';
    }
  }

  Question copyWith({
    int? id,
    String? title,
    String? content,
    String? audio,
    String? mediaType,
    String? ansA,
    String? ansB,
    String? ansC,
    String? ansD,
    String? ansRight,
    String? ansHint,
    int? topicId,
    bool? mandatory,
    int? difficulty,
  }) {
    return Question(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      audio: audio ?? this.audio,
      mediaType: mediaType ?? this.mediaType,
      ansA: ansA ?? this.ansA,
      ansB: ansB ?? this.ansB,
      ansC: ansC ?? this.ansC,
      ansD: ansD ?? this.ansD,
      ansRight: ansRight ?? this.ansRight,
      ansHint: ansHint ?? this.ansHint,
      topicId: topicId ?? this.topicId,
      mandatory: mandatory ?? this.mandatory,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Question{id: $id, content: ${content.length > 50 ? content.substring(0, 50) + '...' : content}, mandatory: $mandatory}';
  }
}