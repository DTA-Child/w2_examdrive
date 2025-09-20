import '../../core/constants/database_constants.dart';
import '../../core/constants/app_constants.dart';
import 'answer_detail.dart';

class TestResult {
  final int? id;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalQuestions;
  final int correctAnswers;
  final double score;
  final bool isPassed;
  final String testType;
  final List<AnswerDetail>? answerDetails;

  TestResult({
    this.id,
    required this.startTime,
    this.endTime,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.isPassed,
    this.testType = AppConstants.testTypePractice,
    this.answerDetails,
  });

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      id: map[DatabaseConstants.resultId] as int?,
      startTime: DateTime.parse(map[DatabaseConstants.resultStartTime] as String),
      endTime: map[DatabaseConstants.resultEndTime] != null
          ? DateTime.parse(map[DatabaseConstants.resultEndTime] as String)
          : null,
      totalQuestions: map[DatabaseConstants.resultTotalQuestions] as int,
      correctAnswers: map[DatabaseConstants.resultCorrectAnswers] as int,
      score: (map[DatabaseConstants.resultScore] as num).toDouble(),
      isPassed: (map[DatabaseConstants.resultIsPassed] as int) == 1,
      testType: map[DatabaseConstants.resultTestType] as String? ?? AppConstants.testTypePractice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DatabaseConstants.resultId: id,
      DatabaseConstants.resultStartTime: startTime.toIso8601String(),
      DatabaseConstants.resultEndTime: endTime?.toIso8601String(),
      DatabaseConstants.resultTotalQuestions: totalQuestions,
      DatabaseConstants.resultCorrectAnswers: correctAnswers,
      DatabaseConstants.resultScore: score,
      DatabaseConstants.resultIsPassed: isPassed ? 1 : 0,
      DatabaseConstants.resultTestType: testType,
    };
  }

  int get wrongAnswers => totalQuestions - correctAnswers;

  double get accuracy => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  Duration? get testDuration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  String get testDurationText {
    final duration = testDuration;
    if (duration == null) return 'Chưa hoàn thành';

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}p ${seconds}s';
  }

  String get testTypeText {
    switch (testType) {
      case AppConstants.testTypeExam:
        return 'Thi thử';
      case AppConstants.testTypePractice:
        return 'Luyện tập';
      case AppConstants.testTypeByTopic:
        return 'Theo chủ đề';
      default:
        return 'Không xác định';
    }
  }

  String get resultText {
    if (isPassed) {
      return AppConstants.messageExamPassed;
    } else {
      return AppConstants.messageExamFailed;
    }
  }

  String get scoreText => '${score.toStringAsFixed(1)}/100';

  bool get isExam => testType == AppConstants.testTypeExam;

  int get mandatoryWrong {
    if (answerDetails == null) return 0;
    return answerDetails!
        .where((detail) => detail.isMandatory && !detail.isCorrect)
        .length;
  }

  String get failReason {
    if (isPassed) return '';

    if (isExam) {
      if (mandatoryWrong > AppConstants.maxMandatoryWrong) {
        return 'Sai ${mandatoryWrong} câu liệt';
      }
      if (score < AppConstants.passingScore) {
        return 'Điểm số không đạt (${scoreText})';
      }
    }

    return 'Chưa đạt yêu cầu';
  }

  TestResult copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    int? totalQuestions,
    int? correctAnswers,
    double? score,
    bool? isPassed,
    String? testType,
    List<AnswerDetail>? answerDetails,
  }) {
    return TestResult(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      score: score ?? this.score,
      isPassed: isPassed ?? this.isPassed,
      testType: testType ?? this.testType,
      answerDetails: answerDetails ?? this.answerDetails,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TestResult{id: $id, score: $score, isPassed: $isPassed, testType: $testType}';
  }

  static TestResult createNew({
    required int totalQuestions,
    String testType = AppConstants.testTypePractice,
  }) {
    return TestResult(
      startTime: DateTime.now(),
      totalQuestions: totalQuestions,
      correctAnswers: 0,
      score: 0.0,
      isPassed: false,
      testType: testType,
    );
  }

  TestResult finishTest({
    required int correctAnswers,
    List<AnswerDetail>? answerDetails,
  }) {
    final score = totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;
    bool isPassed = false;

    if (testType == AppConstants.testTypeExam) {
      // Exam passing criteria
      final mandatoryWrong = answerDetails?.where((d) => d.isMandatory && !d.isCorrect).length ?? 0;
      isPassed = score >= AppConstants.passingScore && mandatoryWrong <= AppConstants.maxMandatoryWrong;
    } else {
      // Practice passing criteria
      isPassed = score >= AppConstants.passingScore;
    }

    return copyWith(
      endTime: DateTime.now(),
      correctAnswers: correctAnswers,
      score: score,
      isPassed: isPassed,
      answerDetails: answerDetails,
    );
  }
}