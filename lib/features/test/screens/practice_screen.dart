import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/question_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/question.dart';
import '../../../routes/app_routes.dart';
import '../providers/test_provider.dart';
class PracticeScreen extends StatefulWidget {
  final List<Question> questions;
  final String testType;
  final String? topicTitle;

  const PracticeScreen({
    super.key,
    required this.questions,
    required this.testType,
    this.topicTitle,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late TestProvider _testProvider;
  final PageController _pageController = PageController();
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _testProvider = Provider.of<TestProvider>(context, listen: false);
    _initializePractice();
  }

  void _initializePractice() {
    _testProvider.initializeTest(
      questions: widget.questions,
      testType: widget.testType,
      timeLimit: null, // No time limit for practice
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: LoadingWidget(message: 'Đang chuẩn bị bài luyện tập...'),
          );
        }

        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(),
            bottomNavigationBar: _buildBottomBar(),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_showResults) {
      return true; // Allow back navigation when showing results
    }
    return await _showExitDialog() ?? false;
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thoát luyện tập'),
        content: const Text(
          'Bạn có chắc chắn muốn thoát? Tiến độ sẽ không được lưu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tiếp tục'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_getAppBarTitle()),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: _toggleShowResults,
          icon: Icon(
            _showResults ? Icons.visibility_off : Icons.visibility,
          ),
          tooltip: _showResults ? 'Ẩn đáp án' : 'Hiện đáp án',
        ),
      ],
    );
  }

  String _getAppBarTitle() {
    if (widget.topicTitle != null) {
      return widget.topicTitle!;
    }
    return 'Luyện tập';
  }

  Widget _buildBody() {
    return Column(
      children: [
        Consumer<TestProvider>(
          builder: (context, provider, child) {
            return QuestionHeader(
              currentQuestion: provider.currentQuestionIndex + 1,
              totalQuestions: provider.questions.length,
              isMandatory: provider.currentQuestion?.mandatory ?? false,
            );
          },
        ),
        if (_showResults)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.amber[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, color: Colors.amber[800], size: 16),
                const SizedBox(width: 4),
                Text(
                  'Đang hiển thị đáp án',
                  style: TextStyle(
                    color: Colors.amber[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              return Consumer<TestProvider>(
                builder: (context, provider, child) {
                  final question = provider.questions[index];
                  final selectedAnswer = provider.getUserAnswer(question.id);

                  return QuestionCard(
                    question: question,
                    selectedAnswer: selectedAnswer,
                    showResult: _showResults,
                    onAnswerSelected: (answer) {
                      if (!_showResults) {
                        provider.setAnswer(question.id, answer);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Consumer<TestProvider>(
      builder: (context, provider, child) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_showResults) _buildProgressBar(),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (provider.currentQuestionIndex > 0)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _previousQuestion,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Câu trước'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                        ),
                      ),
                    ),
                  if (provider.currentQuestionIndex > 0)
                    const SizedBox(width: 12),
                  if (provider.currentQuestionIndex == 0)
                    Expanded(
                      flex: 2,
                      child: _buildMainButton(),
                    ),
                  if (provider.currentQuestionIndex > 0)
                    Expanded(
                      flex: 1,
                      child: _buildMainButton(),
                    ),
                  if (provider.currentQuestionIndex < provider.questions.length - 1)
                    const SizedBox(width: 12),
                  if (provider.currentQuestionIndex < provider.questions.length - 1)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _nextQuestion,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Câu tiếp'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Consumer<TestProvider>(
      builder: (context, provider, child) {
        final answeredCount = provider.getAnsweredQuestionsCount();
        final totalCount = provider.questions.length;
        final progress = totalCount > 0 ? answeredCount / totalCount : 0.0;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ: $answeredCount/$totalCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainButton() {
    return Consumer<TestProvider>(
      builder: (context, provider, child) {
        if (provider.currentQuestionIndex == provider.questions.length - 1) {
          return ElevatedButton.icon(
            onPressed: _finishPractice,
            icon: const Icon(Icons.check),
            label: const Text('Hoàn thành'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          );
        } else {
          return ElevatedButton(
            onPressed: _showQuestionNavigation,
            child: Text(
              'Câu ${provider.currentQuestionIndex + 1}/${provider.questions.length}',
            ),
          );
        }
      },
    );
  }

  void _onPageChanged(int index) {
    _testProvider.setCurrentQuestionIndex(index);
  }

  void _previousQuestion() {
    if (_testProvider.currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: AppConstants.shortAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextQuestion() {
    if (_testProvider.currentQuestionIndex < _testProvider.questions.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.shortAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleShowResults() {
    setState(() {
      _showResults = !_showResults;
    });
  }

  void _showQuestionNavigation() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildQuestionNavigationSheet(),
    );
  }

  Widget _buildQuestionNavigationSheet() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Điều hướng câu hỏi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<TestProvider>(
            builder: (context, provider, child) {
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: provider.questions.length,
                itemBuilder: (context, index) {
                  final question = provider.questions[index];
                  final hasAnswer = provider.getUserAnswer(question.id) != null;
                  final isCurrent = index == provider.currentQuestionIndex;
                  final isMandatory = question.mandatory;
                  final isCorrect = _showResults && hasAnswer ?
                  provider.getUserAnswer(question.id) == question.ansRight : null;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pageController.animateToPage(
                        index,
                        duration: AppConstants.shortAnimation,
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getQuestionButtonColor(hasAnswer, isCurrent, isMandatory, isCorrect),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: hasAnswer || isCurrent ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          _buildNavigationLegend(),
        ],
      ),
    );
  }

  Color _getQuestionButtonColor(bool hasAnswer, bool isCurrent, bool isMandatory, bool? isCorrect) {
    if (isCurrent) return Colors.blue;
    if (hasAnswer) {
      if (_showResults && isCorrect != null) {
        return isCorrect ? Colors.green : Colors.red;
      }
      return isMandatory ? Colors.orange : Colors.green;
    }
    return Colors.grey[300]!;
  }

  Widget _buildNavigationLegend() {
    List<Widget> legendItems = [
      _buildLegendItem('Chưa làm', Colors.grey[300]!),
      _buildLegendItem('Đã làm', Colors.green),
      _buildLegendItem('Hiện tại', Colors.blue),
    ];

    if (_showResults) {
      legendItems.addAll([
        _buildLegendItem('Đúng', Colors.green),
        _buildLegendItem('Sai', Colors.red),
      ]);
    } else {
      legendItems.add(_buildLegendItem('Câu liệt', Colors.orange));
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legendItems,
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _finishPractice() async {
    final confirmed = await _showFinishConfirmDialog();
    if (confirmed == true) {
      await _testProvider.finishTest();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.result,
          arguments: {
            'testResult': _testProvider.testResult,
            'answerDetails': _testProvider.answerDetails,
          },
        );
      }
    }
  }

  Future<bool?> _showFinishConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => Consumer<TestProvider>(
        builder: (context, provider, child) {
          final answeredCount = provider.getAnsweredQuestionsCount();
          final totalCount = provider.questions.length;
          final unansweredCount = totalCount - answeredCount;

          return AlertDialog(
            title: const Text('Hoàn thành luyện tập'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bạn đã hoàn thành $answeredCount/$totalCount câu hỏi.'),
                if (unansweredCount > 0)
                  Text(
                    'Còn $unansweredCount câu chưa trả lời.',
                    style: const TextStyle(color: Colors.orange),
                  ),
                const SizedBox(height: 8),
                const Text('Bạn có muốn xem kết quả?'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tiếp tục'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xem kết quả'),
              ),
            ],
          );
        },
      ),
    );
  }
}