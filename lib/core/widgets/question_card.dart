import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../data/models/question.dart';
import 'media_widget.dart';
import 'custom_button.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final bool showResult;
  final Function(String)? onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    this.showResult = false,
    this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (question.title != null && question.title!.isNotEmpty)
                _buildQuestionTitle(),

              _buildQuestionContent(),

              if (question.hasMedia)
                _buildMediaSection(),

              const SizedBox(height: 20),

              _buildAnswerOptions(),

              if (question.ansHint != null && question.ansHint!.isNotEmpty && showResult)
                _buildHintSection(),

              // Thêm padding bottom để tránh bị cắt
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        question.title!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(
        question.content,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      constraints: const BoxConstraints(
        maxHeight: 250, // Giới hạn chiều cao tối đa cho media
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MediaWidget(
          mediaPath: question.audio,
          mediaType: question.mediaType,
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final answers = question.getAnswersList();

    return Column(
      children: AppConstants.answerOptions.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        if (index >= answers.length || answers[index].isEmpty) {
          return const SizedBox.shrink();
        }

        final answerText = answers[index];
        final isSelected = selectedAnswer == option;
        final isCorrect = showResult && question.ansRight == option;
        final isWrong = showResult && isSelected && question.ansRight != option;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AnswerButton(
            option: option,
            text: answerText,
            isSelected: isSelected,
            isCorrect: isCorrect,
            isWrong: isWrong,
            showResult: showResult,
            onPressed: () => onAnswerSelected?.call(option),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHintSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(color: Colors.amber[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.amber[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gợi ý:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question.ansHint!,
                  style: TextStyle(
                    color: Colors.amber[800],
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final bool isMandatory;

  const QuestionHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Câu $currentQuestion/$totalQuestions',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (isMandatory)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Câu liệt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}