import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/media_widget.dart';
import '../../../data/models/question.dart';
import 'answer_button.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final bool showResult;
  final Function(String)? onAnswerSelected;
  final bool isEnabled;

  const QuestionWidget({
    super.key,
    required this.question,
    this.selectedAnswer,
    this.showResult = false,
    this.onAnswerSelected,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(),
          const SizedBox(height: 16),
          _buildQuestionContent(),
          if (question.hasMedia) ...[
            const SizedBox(height: 16),
            _buildMediaSection(context),
          ],
          const SizedBox(height: 24),
          _buildAnswerOptions(),
          if (question.ansHint != null &&
              question.ansHint!.isNotEmpty &&
              showResult) ...[
            const SizedBox(height: 16),
            _buildHintSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.mandatory)
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
        if (question.mandatory) const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question.difficultyText,
            style: TextStyle(
              color: _getDifficultyColor(),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor() {
    switch (question.difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.title != null && question.title!.isNotEmpty) ...[
          Text(
            question.title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          question.content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ✅ SỬA: Media section với responsive design
  Widget _buildMediaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxHeight: 400, // ✅ Giới hạn chiều cao tối đa
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Stack(
          children: [
            // ✅ Media widget với responsive container
            if (question.hasImage)
              _buildResponsiveImage(context)
            else if (question.hasAudio)
            // Audio player với fixed height
              SizedBox(
                height: 80,
                child: MediaWidget(
                  mediaPath: question.audio,
                  mediaType: question.mediaType,
                ),
              )
            else
            // Default MediaWidget
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: MediaWidget(
                  mediaPath: question.audio,
                  mediaType: question.mediaType,
                  height: question.hasImage ? 250 : null,
                ),
              ),

            // ✅ Zoom indicator cho image
            if (question.hasImage)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Nhấn để phóng to',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ THÊM: Responsive image với tap to zoom
  Widget _buildResponsiveImage(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxHeight: 300, // ✅ Giới hạn chiều cao trong card
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: MediaWidget(
                mediaPath: question.audio, // Assuming this contains image path
                mediaType: question.mediaType,
                height: constraints.maxHeight, // ✅ Sử dụng height có sẵn
              ),
            );
          },
        ),
      ),
    );
  }

  // ✅ THÊM: Full screen image viewer
  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageViewer(
          imagePath: question.audio!, // Assuming this contains image path
          questionTitle: question.title ?? 'Hình ảnh câu hỏi',
        ),
        fullscreenDialog: true,
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
          child: AnswerOptionButton(
            option: option,
            text: answerText,
            isSelected: isSelected,
            isCorrect: isCorrect,
            isWrong: isWrong,
            showResult: showResult,
            isEnabled: isEnabled,
            onPressed: () => onAnswerSelected?.call(option),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHintSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(color: Colors.amber[200]!),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Gợi ý:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.ansHint!,
            style: TextStyle(
              color: Colors.amber[800],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ THÊM: Full screen image viewer
class _FullScreenImageViewer extends StatelessWidget {
  final String imagePath;
  final String questionTitle;

  const _FullScreenImageViewer({
    required this.imagePath,
    required this.questionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          questionTitle,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // ✅ Cho phép pan
          scaleEnabled: true, // ✅ Cho phép zoom
          minScale: 0.5,
          maxScale: 4.0,
          child: MediaWidget(
            mediaPath: imagePath,
            mediaType: 'image',
            // ✅ Không dùng fit parameter
          ),
        ),
      ),
    );
  }
}

// ✅ CẢI TIẾN: Wrapper cho MediaWidget để handle sizing tốt hơn
class ResponsiveMediaWidget extends StatelessWidget {
  final String? mediaPath;
  final String? mediaType;
  final double? height;
  final double? maxHeight;

  const ResponsiveMediaWidget({
    super.key,
    this.mediaPath,
    this.mediaType,
    this.height,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaPath == null || mediaPath!.isEmpty) {
      return Container(
        height: height ?? 200,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }

    Widget mediaWidget = MediaWidget(
      mediaPath: mediaPath,
      mediaType: mediaType!,
      height: height,
    );

    if (maxHeight != null) {
      mediaWidget = Container(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: mediaWidget,
      );
    }

    return mediaWidget;
  }
}

// Các widget khác giữ nguyên...
class QuestionProgressIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int answeredQuestions;
  final bool showProgress;

  const QuestionProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.answeredQuestions,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
      child: Column(
        children: [
          Row(
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
              if (showProgress)
                Text(
                  'Đã làm: $answeredQuestions/${totalQuestions}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          if (showProgress) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : Colors.blue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class QuestionNavigationGrid extends StatelessWidget {
  final List<Question> questions;
  final int currentIndex;
  final Map<int, String> userAnswers;
  final bool showResults;
  final Function(int) onQuestionTap;

  const QuestionNavigationGrid({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.userAnswers,
    required this.onQuestionTap,
    this.showResults = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final hasAnswer = userAnswers.containsKey(question.id);
        final isCurrent = index == currentIndex;
        final isMandatory = question.mandatory;
        final isCorrect = showResults && hasAnswer
            ? userAnswers[question.id] == question.ansRight
            : null;

        return InkWell(
          onTap: () => onQuestionTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: _getButtonColor(hasAnswer, isCurrent, isMandatory, isCorrect),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCurrent ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: hasAnswer || isCurrent ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (isMandatory)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getButtonColor(bool hasAnswer, bool isCurrent, bool isMandatory, bool? isCorrect) {
    if (isCurrent) return Colors.blue;

    if (hasAnswer) {
      if (showResults && isCorrect != null) {
        return isCorrect ? Colors.green : Colors.red;
      }
      return isMandatory ? Colors.orange : Colors.green;
    }

    return Colors.grey[300]!;
  }
}
