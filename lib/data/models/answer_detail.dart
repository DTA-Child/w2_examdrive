import '../../core/constants/database_constants.dart';

class AnswerDetail {
  final int? id;
  final int resultId;
  final int questionId;
  final String? userAnswer;
  final bool isCorrect;
  final int timeSpent;
  final bool isMandatory;

  AnswerDetail({
    this.id,
    required this.resultId,
    required this.questionId,
    this.userAnswer,
    required this.isCorrect,
    this.timeSpent = 0,
    this.isMandatory = false,
  });

  factory AnswerDetail.fromMap(Map<String, dynamic> map) {
    return AnswerDetail(
      id: map[DatabaseConstants.detailId] as int?,
      resultId: map[DatabaseConstants.detailResultId] as int,
      questionId: map[DatabaseConstants.detailQuestionId] as int,
      userAnswer: map[DatabaseConstants.detailUserAnswer] as String?,
      isCorrect: (map[DatabaseConstants.detailIsCorrect] as int) == 1,
      timeSpent: map[DatabaseConstants.detailTimeSpent] as int? ?? 0,
      isMandatory: false, // This needs to be joined from question table
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DatabaseConstants.detailId: id,
      DatabaseConstants.detailResultId: resultId,
      DatabaseConstants.detailQuestionId: questionId,
      DatabaseConstants.detailUserAnswer: userAnswer,
      DatabaseConstants.detailIsCorrect: isCorrect ? 1 : 0,
      DatabaseConstants.detailTimeSpent: timeSpent,
    };
  }

  String get timeSpentText {
    if (timeSpent < 60) {
      return '${timeSpent}s';
    } else {
      final minutes = timeSpent ~/ 60;
      final seconds = timeSpent % 60;
      return '${minutes}p ${seconds}s';
    }
  }

  String get resultIcon {
    if (userAnswer == null) return '⚪'; // Not answered
    return isCorrect ? '✅' : '❌';
  }

  String get resultText {
    if (userAnswer == null) return 'Không trả lời';
    return isCorrect ? 'Đúng' : 'Sai';
  }

  AnswerDetail copyWith({
    int? id,
    int? resultId,
    int? questionId,
    String? userAnswer,
    bool? isCorrect,
    int? timeSpent,
    bool? isMandatory,
  }) {
    return AnswerDetail(
      id: id ?? this.id,
      resultId: resultId ?? this.resultId,
      questionId: questionId ?? this.questionId,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      timeSpent: timeSpent ?? this.timeSpent,
      isMandatory: isMandatory ?? this.isMandatory,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnswerDetail &&
        other.resultId == resultId &&
        other.questionId == questionId;
  }

  @override
  int get hashCode => Object.hash(resultId, questionId);

  @override
  String toString() {
    return 'AnswerDetail{questionId: $questionId, userAnswer: $userAnswer, isCorrect: $isCorrect, timeSpent: ${timeSpentText}}';
  }

  static AnswerDetail create({
    required int resultId,
    required int questionId,
    String? userAnswer,
    required String correctAnswer,
    int timeSpent = 0,
    bool isMandatory = false,
  }) {
    final isCorrect = userAnswer != null &&
        userAnswer.toUpperCase() == correctAnswer.toUpperCase();

    return AnswerDetail(
      resultId: resultId,
      questionId: questionId,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
      timeSpent: timeSpent,
      isMandatory: isMandatory,
    );
  }
}

class DetailedAnswerResult {
  final AnswerDetail answerDetail;
  final String questionContent;
  final String? questionTitle;
  final String correctAnswer;
  final String? userAnswerText;
  final String? correctAnswerText;
  final String? hint;

  DetailedAnswerResult({
    required this.answerDetail,
    required this.questionContent,
    this.questionTitle,
    required this.correctAnswer,
    this.userAnswerText,
    this.correctAnswerText,
    this.hint,
  });

  bool get isCorrect => answerDetail.isCorrect;
  bool get isMandatory => answerDetail.isMandatory;
  String get userAnswer => answerDetail.userAnswer ?? '';
  int get timeSpent => answerDetail.timeSpent;
  String get resultIcon => answerDetail.resultIcon;
  String get resultText => answerDetail.resultText;
  String get timeSpentText => answerDetail.timeSpentText;
}