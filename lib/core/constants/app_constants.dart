class AppConstants {
  // App Info
  static const String appName = 'Thi Sát Hạch Lái Xe';
  static const String appVersion = '1.0.0';

  // Auth Constants
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  static const Duration tokenExpiry = Duration(days: 30);

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

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

// Auth Messages
  static const String messageLoginSuccess = 'Đăng nhập thành công';
  static const String messageLoginFailed = 'Tên đăng nhập hoặc mật khẩu không đúng';
  static const String messageRegisterSuccess = 'Đăng ký thành công';
  static const String messageRegisterFailed = 'Đăng ký thất bại';
  static const String messageLogoutSuccess = 'Đăng xuất thành công';
  static const String messageInvalidEmail = 'Email không hợp lệ';
  static const String messagePasswordTooShort = 'Mật khẩu phải có ít nhất 6 ký tự';
  static const String messageUsernameExists = 'Tên đăng nhập đã tồn tại';
  static const String messageEmailExists = 'Email đã được sử dụng';

// User Status
  static const int userStatusInactive = 0;
  static const int userStatusActive = 1;
  static const int userStatusBlocked = 2;

// Gender
  static const String genderMale = 'M';
  static const String genderFemale = 'F';
}