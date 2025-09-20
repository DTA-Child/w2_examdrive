class AppRoutes {
  // Main routes
  static const String home = '/';
  static const String splash = '/splash';

  // Test routes
  static const String test = '/test';
  static const String practice = '/practice';
  static const String result = '/result';

  // History routes
  static const String history = '/history';

  // Settings routes
  static const String settings = '/settings';

  // Topic routes
  static const String topicDetail = '/topic-detail';
  static const String topicTest = '/topic-test';

  // Question routes
  static const String questionDetail = '/question-detail';

  // Result routes
  static const String resultDetail = '/result-detail';

  // Error routes
  static const String error = '/error';
  static const String notFound = '/not-found';

  // Route names for easy access
  static const Map<String, String> routeNames = {
    home: 'Trang chủ',
    test: 'Thi thử',
    practice: 'Luyện tập',
    result: 'Kết quả',
    history: 'Lịch sử',
    settings: 'Cài đặt',
    topicDetail: 'Chi tiết chủ đề',
    questionDetail: 'Chi tiết câu hỏi',
    resultDetail: 'Chi tiết kết quả',
  };

  // Get route name
  static String getRouteName(String route) {
    return routeNames[route] ?? 'Không xác định';
  }

  // Check if route exists
  static bool isValidRoute(String route) {
    return routeNames.containsKey(route);
  }

  // Get all routes
  static List<String> get allRoutes => routeNames.keys.toList();
}