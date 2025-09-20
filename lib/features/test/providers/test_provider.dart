import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/question.dart';
import '../../../data/models/test_result.dart';
import '../../../data/models/answer_detail.dart';
import '../../../data/repositories/result_repository.dart';

class TestProvider with ChangeNotifier {
  final ResultRepository _resultRepository = ResultRepository();

  // Test state
  List<Question> _questions = [];
  String _testType = AppConstants.testTypePractice;
  int? _timeLimit;
  DateTime? _startTime;
  DateTime? _endTime;

  // Current question state
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  Map<int, DateTime> _answerTimes = {};

  // Test result
  TestResult? _testResult;
  List<AnswerDetail> _answerDetails = [];

  // Loading state
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Question> get questions => _questions;
  String get testType => _testType;
  int? get timeLimit => _timeLimit;
  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;

  int get currentQuestionIndex => _currentQuestionIndex;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;

  Map<int, String> get userAnswers => Map.unmodifiable(_userAnswers);
  TestResult? get testResult => _testResult;
  List<AnswerDetail> get answerDetails => List.unmodifiable(_answerDetails);

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Test progress
  int get answeredQuestionsCount => _userAnswers.length;
  double get progressPercentage =>
      _questions.isNotEmpty ? answeredQuestionsCount / _questions.length : 0.0;

  bool get isTestCompleted => _testResult != null;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  Duration? get elapsedTime {
    if (_startTime == null) return null;
    final endTime = _endTime ?? DateTime.now();
    return endTime.difference(_startTime!);
  }

  // Initialize test
  Future<void> initializeTest({
    required List<Question> questions,
    required String testType,
    int? timeLimit,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      _questions = List.from(questions);
      _testType = testType;
      _timeLimit = timeLimit;
      _startTime = DateTime.now();
      _endTime = null;

      _currentQuestionIndex = 0;
      _userAnswers.clear();
      _answerTimes.clear();
      _testResult = null;
      _answerDetails.clear();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize test: $e');
    }
  }

  // Navigation methods
  void setCurrentQuestionIndex(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    setCurrentQuestionIndex(index);
  }

  // Answer methods
  void setAnswer(int questionId, String answer) {
    _userAnswers[questionId] = answer;
    _answerTimes[questionId] = DateTime.now();
    notifyListeners();
  }

  String? getUserAnswer(int questionId) {
    return _userAnswers[questionId];
  }

  void removeAnswer(int questionId) {
    _userAnswers.remove(questionId);
    _answerTimes.remove(questionId);
    notifyListeners();
  }

  void clearAllAnswers() {
    _userAnswers.clear();
    _answerTimes.clear();
    notifyListeners();
  }

  // Get answered questions count
  int getAnsweredQuestionsCount() {
    return _userAnswers.length;
  }

  // Get unanswered questions
  List<Question> getUnansweredQuestions() {
    return _questions.where((q) => !_userAnswers.containsKey(q.id)).toList();
  }

  // Get answered questions
  List<Question> getAnsweredQuestions() {
    return _questions.where((q) => _userAnswers.containsKey(q.id)).toList();
  }

  // Check if question is answered
  bool isQuestionAnswered(int questionId) {
    return _userAnswers.containsKey(questionId);
  }

  // Get time spent on question
  Duration? getTimeSpentOnQuestion(int questionId) {
    final answerTime = _answerTimes[questionId];
    if (answerTime == null || _startTime == null) return null;
    return answerTime.difference(_startTime!);
  }

  // Finish test
  Future<void> finishTest() async {
    try {
      _setLoading(true);
      _clearError();

      _endTime = DateTime.now();

      // Calculate results
      final correctAnswers = _calculateCorrectAnswers();
      final score = _calculateScore(correctAnswers);
      final isPassed = _calculateIsPassed(correctAnswers, score);

      // Create test result
      _testResult = TestResult(
        startTime: _startTime!,
        endTime: _endTime,
        totalQuestions: _questions.length,
        correctAnswers: correctAnswers,
        score: score,
        isPassed: isPassed,
        testType: _testType,
      );

      // Create answer details
      _answerDetails = _createAnswerDetails();

      // Save to database
      await _resultRepository.saveCompleteTestResult(_testResult!, _answerDetails);

      _setLoading(false);
    } catch (e) {
      _setError('Failed to finish test: $e');
    }
  }

  // Calculate correct answers
  int _calculateCorrectAnswers() {
    int correct = 0;
    for (final question in _questions) {
      final userAnswer = _userAnswers[question.id];
      if (userAnswer != null && userAnswer.toUpperCase() == question.ansRight.toUpperCase()) {
        correct++;
      }
    }
    return correct;
  }

  // Calculate score
  double _calculateScore(int correctAnswers) {
    if (_questions.isEmpty) return 0.0;
    return (correctAnswers / _questions.length) * 100;
  }

  // Calculate if passed
  bool _calculateIsPassed(int correctAnswers, double score) {
    if (_testType == AppConstants.testTypeExam) {
      // For exam: must pass score threshold AND not exceed mandatory wrong limit
      final mandatoryWrong = _getMandatoryWrongCount();
      return score >= AppConstants.passingScore &&
          mandatoryWrong <= AppConstants.maxMandatoryWrong;
    } else {
      // For practice: only need to pass score threshold
      return score >= AppConstants.passingScore;
    }
  }

  // Get mandatory wrong count
  int _getMandatoryWrongCount() {
    int mandatoryWrong = 0;
    for (final question in _questions) {
      if (question.mandatory) {
        final userAnswer = _userAnswers[question.id];
        if (userAnswer == null || userAnswer.toUpperCase() != question.ansRight.toUpperCase()) {
          mandatoryWrong++;
        }
      }
    }
    return mandatoryWrong;
  }

  // Create answer details
  List<AnswerDetail> _createAnswerDetails() {
    final List<AnswerDetail> details = [];

    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final userAnswer = _userAnswers[question.id];
      final isCorrect = userAnswer != null &&
          userAnswer.toUpperCase() == question.ansRight.toUpperCase();

      final timeSpent = _calculateTimeSpentOnQuestion(question.id, i);

      final detail = AnswerDetail(
        resultId: 0, // Will be set when saving to database
        questionId: question.id,
        userAnswer: userAnswer,
        isCorrect: isCorrect,
        timeSpent: timeSpent,
        isMandatory: question.mandatory,
      );

      details.add(detail);
    }

    return details;
  }

  // Calculate time spent on specific question
  int _calculateTimeSpentOnQuestion(int questionId, int questionIndex) {
    if (_startTime == null) return 0;

    final answerTime = _answerTimes[questionId];
    if (answerTime != null) {
      return answerTime.difference(_startTime!).inSeconds;
    }

    // If no answer time recorded, estimate based on average
    final totalTime = elapsedTime?.inSeconds ?? 0;
    final avgTimePerQuestion = _questions.isNotEmpty ? totalTime ~/ _questions.length : 0;
    return avgTimePerQuestion;
  }

  // Get statistics
  Map<String, dynamic> getCurrentStatistics() {
    final answeredCount = getAnsweredQuestionsCount();
    final totalCount = _questions.length;
    final mandatoryAnswered = _questions
        .where((q) => q.mandatory && _userAnswers.containsKey(q.id))
        .length;
    final mandatoryTotal = _questions.where((q) => q.mandatory).length;

    return {
      'answered_count': answeredCount,
      'total_count': totalCount,
      'progress_percentage': progressPercentage,
      'mandatory_answered': mandatoryAnswered,
      'mandatory_total': mandatoryTotal,
      'elapsed_time': elapsedTime,
    };
  }

  // Get question by ID
  Question? getQuestionById(int questionId) {
    try {
      return _questions.firstWhere((q) => q.id == questionId);
    } catch (e) {
      return null;
    }
  }

  // Reset test
  void resetTest() {
    _questions.clear();
    _testType = AppConstants.testTypePractice;
    _timeLimit = null;
    _startTime = null;
    _endTime = null;

    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _answerTimes.clear();

    _testResult = null;
    _answerDetails.clear();

    _isLoading = false;
    _error = null;

    notifyListeners();
  }

  // Auto-save progress (could be used for resuming tests)
  Map<String, dynamic> saveProgress() {
    return {
      'questions': _questions.map((q) => q.toMap()).toList(),
      'test_type': _testType,
      'time_limit': _timeLimit,
      'start_time': _startTime?.toIso8601String(),
      'current_question_index': _currentQuestionIndex,
      'user_answers': _userAnswers,
      'answer_times': _answerTimes.map((k, v) => MapEntry(k.toString(), v.toIso8601String())),
    };
  }

  // Restore progress
  void restoreProgress(Map<String, dynamic> data) {
    try {
      _questions = (data['questions'] as List)
          .map((q) => Question.fromMap(q))
          .toList();
      _testType = data['test_type'] ?? AppConstants.testTypePractice;
      _timeLimit = data['time_limit'];
      _startTime = data['start_time'] != null
          ? DateTime.parse(data['start_time'])
          : null;
      _currentQuestionIndex = data['current_question_index'] ?? 0;
      _userAnswers = Map<int, String>.from(data['user_answers'] ?? {});

      final answerTimesData = data['answer_times'] as Map<String, dynamic>? ?? {};
      _answerTimes = answerTimesData.map(
            (k, v) => MapEntry(int.parse(k), DateTime.parse(v)),
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to restore progress: $e');
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Get test summary
  Map<String, dynamic> getTestSummary() {
    if (_testResult == null) {
      return getCurrentStatistics();
    }

    return {
      'test_result': _testResult!.toMap(),
      'answer_details': _answerDetails.map((d) => d.toMap()).toList(),
      'statistics': {
        'total_questions': _testResult!.totalQuestions,
        'correct_answers': _testResult!.correctAnswers,
        'wrong_answers': _testResult!.wrongAnswers,
        'score': _testResult!.score,
        'is_passed': _testResult!.isPassed,
        'test_duration': _testResult!.testDurationText,
        'mandatory_wrong': _testResult!.mandatoryWrong,
      },
    };
  }
}