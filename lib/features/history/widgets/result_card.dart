import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/test_result.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  final TestResult result;
  final VoidCallback? onTap;
  final bool showDetails;

  const ResultCard({
    super.key,
    required this.result,
    this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildScoreSection(),
              if (showDetails) ...[
                const SizedBox(height: 12),
                _buildDetailsSection(),
              ],
              const SizedBox(height: 8),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTestTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            result.testTypeText,
            style: TextStyle(
              color: _getTestTypeColor(),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: result.isPassed ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                result.isPassed ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                result.isPassed ? 'ĐẬU' : 'RỚT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Điểm số',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                result.scoreText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildDetailsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            'Đúng',
            '${result.correctAnswers}',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            'Sai',
            '${result.wrongAnswers}',
            Icons.cancel,
            Colors.red,
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            'Tổng',
            '${result.totalQuestions}',
            Icons.quiz,
            Colors.blue,
          ),
        ),
        if (result.isExam)
          Expanded(
            child: _buildDetailItem(
              'Liệt sai',
              '${result.mandatoryWrong}',
              Icons.warning,
              Colors.orange,
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          _formatDateTime(result.startTime),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        if (result.testDuration != null) ...[
          Icon(
            Icons.timer,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            result.testDurationText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Color _getTestTypeColor() {
    switch (result.testType) {
      case AppConstants.testTypeExam:
        return Colors.red;
      case AppConstants.testTypePractice:
        return Colors.green;
      case AppConstants.testTypeByTopic:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor() {
    if (result.score >= 90) {
      return Colors.green;
    } else if (result.score >= 80) {
      return Colors.lightGreen;
    } else if (result.score >= 70) {
      return Colors.orange;
    } else if (result.score >= 60) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Hôm nay ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Hôm qua ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
  }
}

class ResultSummaryCard extends StatelessWidget {
  final List<TestResult> results;

  const ResultSummaryCard({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalTests = results.length;
    final passedTests = results.where((r) => r.isPassed).length;
    final avgScore = results.fold<double>(0, (sum, r) => sum + r.score) / totalTests;
    final passRate = (passedTests / totalTests) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tóm tắt kết quả',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Tổng số lần thi',
                    totalTests.toString(),
                    Icons.quiz,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
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
                  child: _buildSummaryItem(
                    'Điểm trung bình',
                    avgScore.toStringAsFixed(1),
                    Icons.grade,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
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

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CompactResultCard extends StatelessWidget {
  final TestResult result;
  final VoidCallback? onTap;

  const CompactResultCard({
    super.key,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: result.isPassed ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.isPassed ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.testTypeText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatDateTime(result.startTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    result.scoreText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: result.isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    '${result.correctAnswers}/${result.totalQuestions}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM HH:mm').format(dateTime);
  }
}