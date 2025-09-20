import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/topic.dart';
import '../../../data/repositories/topic_repository.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../data/repositories/result_repository.dart';
import '../../../routes/app_routes.dart';
import '../widgets/topic_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TopicRepository _topicRepository = TopicRepository();
  final QuestionRepository _questionRepository = QuestionRepository();
  final ResultRepository _resultRepository = ResultRepository();

  List<Topic> _topics = [];
  Map<String, dynamic>? _statistics;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final topics = await _topicRepository.getAllTopics();
      final stats = await _resultRepository.getStatistics();

      setState(() {
        _topics = topics;
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading
          ? const LoadingWidget(message: 'Đang tải dữ liệu...')
          : _error != null
          ? _buildErrorWidget()
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        AppConstants.appName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildStatisticsCard(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildTopicsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chào mừng đến với',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ứng dụng thi sát hạch lái xe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Luyện tập ${_topics.length} chủ đề với hàng trăm câu hỏi',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    if (_statistics == null) return const SizedBox.shrink();

    final totalTests = _statistics!['total_tests'] ?? 0;
    final passedTests = _statistics!['passed_tests'] ?? 0;
    final avgScore = (_statistics!['average_score'] ?? 0.0).toDouble();
    final passRate = (_statistics!['pass_rate'] ?? 0.0).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'Thống kê của bạn',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Số lần thi',
                    totalTests.toString(),
                    Icons.quiz,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Số lần đậu',
                    passedTests.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Điểm TB',
                    avgScore.toStringAsFixed(1),
                    Icons.grade,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Tỷ lệ đậu',
                    '${passRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bắt đầu ngay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    'Thi thử',
                    'Làm bài thi 30 câu',
                    Icons.assignment,
                    Colors.red,
                        () => _startExamTest(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    'Luyện tập',
                    'Ôn tập 20 câu',
                    Icons.school,
                    Colors.green,
                        () => _startPracticeTest(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: _buildQuickActionButton(
                'Lịch sử thi',
                'Xem kết quả các lần thi trước',
                Icons.history,
                Colors.blue,
                    () => Navigator.pushNamed(context, AppRoutes.history),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chủ đề ôn tập',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_topics.isEmpty)
          const EmptyWidget(
            message: 'Chưa có chủ đề nào',
            icon: Icons.topic,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _topics.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return TopicCard(
                topic: _topics[index],
                onTap: () => _navigateToTopicTest(_topics[index]),
              );
            },
          ),
      ],
    );
  }

  void _startExamTest() async {
    try {
      final questions = await _questionRepository.getExamQuestions();
      if (questions.isEmpty) {
        _showSnackBar('Không có câu hỏi nào để thi');
        return;
      }

      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.test,
          arguments: {
            'questions': questions,
            'testType': AppConstants.testTypeExam,
            'timeLimit': AppConstants.examTimeMinutes,
          },
        );
      }
    } catch (e) {
      _showSnackBar('Có lỗi khi tải câu hỏi thi: $e');
    }
  }

  void _startPracticeTest() async {
    try {
      final questions = await _questionRepository.getPracticeQuestions(
        AppConstants.practiceQuestionCount,
      );
      if (questions.isEmpty) {
        _showSnackBar('Không có câu hỏi nào để luyện tập');
        return;
      }

      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.practice,
          arguments: {
            'questions': questions,
            'testType': AppConstants.testTypePractice,
          },
        );
      }
    } catch (e) {
      _showSnackBar('Có lỗi khi tải câu hỏi luyện tập: $e');
    }
  }

  void _navigateToTopicTest(Topic topic) async {
    try {
      final questions = await _questionRepository.getQuestionsByTopic(topic.id);
      if (questions.isEmpty) {
        _showSnackBar('Chủ đề này chưa có câu hỏi');
        return;
      }

      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.practice,
          arguments: {
            'questions': questions,
            'testType': AppConstants.testTypeByTopic,
            'topicTitle': topic.title,
          },
        );
      }
    } catch (e) {
      _showSnackBar('Có lỗi khi tải câu hỏi chủ đề: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}