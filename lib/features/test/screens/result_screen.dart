import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/test_result.dart';
import '../../../data/models/answer_detail.dart';
import '../../../data/models/question.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../routes/app_routes.dart';

class ResultScreen extends StatefulWidget {
  final TestResult testResult;
  final List<AnswerDetail> answerDetails;

  const ResultScreen({
    super.key,
    required this.testResult,
    required this.answerDetails,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final QuestionRepository _questionRepository = QuestionRepository();
  List<Question> _questions = [];
  bool _isLoadingQuestions = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadQuestions();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  Future<void> _loadQuestions() async {
    try {
      final List<Question> questions = [];
      for (final detail in widget.answerDetails) {
        final question = await _questionRepository.getQuestionById(detail.questionId);
        if (question != null) {
          questions.add(question);
        }
      }
      setState(() {
        _questions = questions;
        _isLoadingQuestions = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingQuestions = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Kết quả thi'),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          _buildResultCard(),
          const SizedBox(height: 20),
          _buildStatisticsCard(),
          const SizedBox(height: 20),
          if (!_isLoadingQuestions) _buildAnswerReviewCard(),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.largePadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.testResult.isPassed
                        ? [Colors.green[400]!, Colors.green[600]!]
                        : [Colors.red[400]!, Colors.red[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: Column(
                  children: [
                    Icon(
                      widget.testResult.isPassed
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.testResult.isPassed ? 'ĐẬU' : 'KHÔNG ĐẬU',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.testResult.resultText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Điểm: ${widget.testResult.scoreText}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!widget.testResult.isPassed) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.testResult.failReason,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCard() {
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
                  'Thống kê chi tiết',
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
                    'Tổng câu',
                    '${widget.testResult.totalQuestions}',
                    Icons.quiz,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Trả lời đúng',
                    '${widget.testResult.correctAnswers}',
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
                    'Trả lời sai',
                    '${widget.testResult.wrongAnswers}',
                    Icons.cancel,
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Thời gian',
                    widget.testResult.testDurationText,
                    Icons.timer,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            if (widget.testResult.isExam) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Câu liệt sai',
                      '${widget.testResult.mandatoryWrong}',
                      Icons.warning,
                      Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Loại thi',
                      widget.testResult.testTypeText,
                      Icons.school,
                      Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
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
              fontSize: 16,
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

  Widget _buildAnswerReviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'Chi tiết câu trả lời',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.answerDetails.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final detail = widget.answerDetails[index];
                final question = _questions.firstWhere(
                      (q) => q.id == detail.questionId,
                  orElse: () => Question(
                    id: detail.questionId,
                    content: 'Không tìm thấy câu hỏi',
                    ansRight: 'A',
                    topicId: 0,
                  ),
                );

                return _buildAnswerDetailItem(detail, question, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerDetailItem(AnswerDetail detail, Question question, int questionNumber) {
    final userAnswerText = detail.userAnswer != null
        ? question.getAnswerByOption(detail.userAnswer!) ?? 'Không xác định'
        : 'Không trả lời';

    final correctAnswerText = question.getAnswerByOption(question.ansRight) ?? 'Không xác định';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: detail.isCorrect ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: detail.isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ HEADER ROW - Số câu hỏi và trạng thái
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: detail.isCorrect ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$questionNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      detail.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: detail.isCorrect ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      detail.isCorrect ? 'ĐÚNG' : 'SAI',
                      style: TextStyle(
                        color: detail.isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (question.mandatory)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'CÂU LIỆT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ✅ QUESTION CONTENT - Toàn bộ chiều rộng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              question.content,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ USER ANSWER - Toàn bộ chiều rộng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: detail.isCorrect
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Câu trả lời của bạn:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: detail.isCorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        detail.userAnswer ?? "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userAnswerText,
                        style: TextStyle(
                          fontSize: 13,
                          color: detail.isCorrect ? Colors.green[700] : Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ CORRECT ANSWER - Chỉ hiển thị khi sai
          if (!detail.isCorrect) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đáp án đúng:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          question.ansRight,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          correctAnswerText,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                    (route) => false,
              ),
              icon: const Icon(Icons.home),
              label: const Text('Về trang chủ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _retakeTest,
              icon: const Icon(Icons.refresh),
              label: const Text('Thi lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _retakeTest() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
          (route) => false,
    );
  }
}