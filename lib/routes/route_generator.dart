import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/test/screens/test_screen.dart';
import '../features/test/screens/practice_screen.dart';
import '../features/test/screens/result_screen.dart';
import '../features/history/screens/history_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../data/models/question.dart';
import '../data/models/test_result.dart';
import '../data/models/answer_detail.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _buildRoute(const HomeScreen(), settings);

      case AppRoutes.test:
        return _buildTestRoute(settings, isExam: true);

      case AppRoutes.practice:
        return _buildTestRoute(settings, isExam: false);

      case AppRoutes.result:
        return _buildResultRoute(settings);

      case AppRoutes.history:
        return _buildRoute(const HistoryScreen(), settings);

      case AppRoutes.settings:
        return _buildRoute(const SettingsScreen(), settings);

      default:
        return _buildErrorRoute(settings);
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }

  static MaterialPageRoute _buildTestRoute(RouteSettings settings, {required bool isExam}) {
    final args = settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return _buildErrorRoute(settings, message: 'Thiếu dữ liệu câu hỏi');
    }

    final questions = args['questions'] as List<Question>?;
    final testType = args['testType'] as String?;
    final timeLimit = args['timeLimit'] as int?;
    final topicTitle = args['topicTitle'] as String?;

    if (questions == null || questions.isEmpty) {
      return _buildErrorRoute(settings, message: 'Không có câu hỏi nào');
    }

    if (testType == null) {
      return _buildErrorRoute(settings, message: 'Thiếu thông tin loại bài thi');
    }

    Widget screen;
    if (isExam) {
      screen = TestScreen(
        questions: questions,
        testType: testType,
        timeLimit: timeLimit,
        topicTitle: topicTitle,
      );
    } else {
      screen = PracticeScreen(
        questions: questions,
        testType: testType,
        topicTitle: topicTitle,
      );
    }

    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
    );
  }

  static MaterialPageRoute _buildResultRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return _buildErrorRoute(settings, message: 'Thiếu dữ liệu kết quả');
    }

    final testResult = args['testResult'] as TestResult?;
    final answerDetails = args['answerDetails'] as List<AnswerDetail>?;

    if (testResult == null) {
      return _buildErrorRoute(settings, message: 'Không có kết quả thi');
    }

    if (answerDetails == null) {
      return _buildErrorRoute(settings, message: 'Thiếu chi tiết câu trả lời');
    }

    return MaterialPageRoute(
      builder: (_) => ResultScreen(
        testResult: testResult,
        answerDetails: answerDetails,
      ),
      settings: settings,
    );
  }

  static MaterialPageRoute _buildErrorRoute(RouteSettings settings, {String? message}) {
    return MaterialPageRoute(
      builder: (_) => ErrorScreen(
        routeName: settings.name ?? 'Unknown',
        message: message ?? 'Không tìm thấy trang',
      ),
      settings: settings,
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String routeName;
  final String message;

  const ErrorScreen({
    super.key,
    required this.routeName,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lỗi'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                'Có lỗi xảy ra',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Route: $routeName',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                          (route) => false,
                    ),
                    icon: const Icon(Icons.home),
                    label: const Text('Trang chủ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Route transition animations
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;

  ScaleRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      );
    },
  );
}

// Route guards
class RouteGuard {
  static bool canNavigateToTest(List<Question>? questions) {
    return questions != null && questions.isNotEmpty;
  }

  static bool canNavigateToResult(TestResult? testResult) {
    return testResult != null;
  }

  static String? validateTestArguments(Map<String, dynamic>? args) {
    if (args == null) return 'Thiếu dữ liệu';

    final questions = args['questions'] as List<Question>?;
    if (questions == null || questions.isEmpty) {
      return 'Không có câu hỏi';
    }

    final testType = args['testType'] as String?;
    if (testType == null || testType.isEmpty) {
      return 'Thiếu loại bài thi';
    }

    return null; // Valid
  }

  static String? validateResultArguments(Map<String, dynamic>? args) {
    if (args == null) return 'Thiếu dữ liệu kết quả';

    final testResult = args['testResult'] as TestResult?;
    if (testResult == null) return 'Không có kết quả thi';

    final answerDetails = args['answerDetails'] as List<AnswerDetail>?;
    if (answerDetails == null) return 'Thiếu chi tiết câu trả lời';

    return null; // Valid
  }
}