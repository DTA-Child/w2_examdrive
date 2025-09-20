class AppConstants {
  // App Info
  static const String appName = 'Thi Sát Hạch Lái Xe';
  static const String appVersion = '1.0.0';

  // Test Configuration
  static const int examQuestionCount = 30;
  static const int examTimeMinutes = 22;
  static const int practiceQuestionCount = 20;
  static const int mandatoryQuestionCount = 7;
  static const double passingScore = 80.0;
  static const int maxMandatoryWrong = 1;

  // UI Constants
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Media Constants
  static const String imagesPath = 'assets/images/';
  static const String audioPath = 'assets/audio/';
  static const String trafficSignsPath = 'assets/images/traffic_signs/';
  static const String diagramsPath = 'assets/images/diagrams/';

  // Test Types
  static const String testTypeExam = 'exam';
  static const String testTypePractice = 'practice';
  static const String testTypeByTopic = 'by_topic';

  // Answer Options
  static const List<String> answerOptions = ['A', 'B', 'C', 'D'];

  // Difficulty Levels
  static const int difficultyEasy = 1;
  static const int difficultyMedium = 2;
  static const int difficultyHard = 3;

  // Media Types
  static const String mediaTypeNone = 'none';
  static const String mediaTypeImage = 'image';
  static const String mediaTypeAudio = 'audio';

  // Status
  static const String statusActive = 'active';
  static const String statusInactive = 'inactive';

  // Messages
  static const String messageExamPassed = 'Chúc mừng! Bạn đã đậu kỳ thi';
  static const String messageExamFailed = 'Bạn chưa đậu. Hãy luyện tập thêm!';
  static const String messageNoQuestions = 'Không có câu hỏi nào';
  static const String messageLoadingData = 'Đang tải dữ liệu...';
  static const String messageNoInternet = 'Không có kết nối mạng';
}