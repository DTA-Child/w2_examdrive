import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AnswerOptionButton extends StatefulWidget {
  final String option;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool showResult;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const AnswerOptionButton({
    super.key,
    required this.option,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.showResult = false,
    this.isEnabled = true,
    this.onPressed,
  });

  @override
  State<AnswerOptionButton> createState() => _AnswerOptionButtonState();
}

class _AnswerOptionButtonState extends State<AnswerOptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(),
        );
      },
    );
  }

  Widget _buildButton() {
    final colors = _getButtonColors();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: colors['background'],
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        elevation: widget.isSelected && !widget.showResult ? 2 : 0,
        child: InkWell(
          onTap: widget.isEnabled && !widget.showResult ? _handleTap : null,
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
          child: AnimatedContainer(
            duration: AppConstants.shortAnimation,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: colors['border']!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            ),
            child: Row(
              children: [
                _buildOptionCircle(colors),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: colors['text'],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                if (widget.showResult) _buildResultIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, Color> _getButtonColors() {
    if (widget.showResult) {
      if (widget.isCorrect) {
        return {
          'background': Colors.green[50]!,
          'border': Colors.green,
          'text': Colors.green[800]!,
          'circle': Colors.green,
        };
      } else if (widget.isWrong) {
        return {
          'background': Colors.red[50]!,
          'border': Colors.red,
          'text': Colors.red[800]!,
          'circle': Colors.red,
        };
      }
    }

    if (widget.isSelected) {
      return {
        'background': Colors.blue[50]!,
        'border': Colors.blue,
        'text': Colors.blue[800]!,
        'circle': Colors.blue,
      };
    }

    return {
      'background': Colors.white,
      'border': Colors.grey[300]!,
      'text': Colors.black87,
      'circle': Colors.grey[400]!,
    };
  }

  Widget _buildOptionCircle(Map<String, Color> colors) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colors['circle'],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.option,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    if (widget.isCorrect) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 24,
      );
    } else if (widget.isWrong) {
      return const Icon(
        Icons.cancel,
        color: Colors.red,
        size: 24,
      );
    }
    return const SizedBox.shrink();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onPressed!();
    }
  }
}

class MultipleChoiceAnswer extends StatelessWidget {
  final List<String> options;
  final List<String> answers;
  final String correctAnswer;
  final String? selectedAnswer;
  final bool showResult;
  final bool isEnabled;
  final Function(String)? onAnswerSelected;

  const MultipleChoiceAnswer({
    super.key,
    required this.options,
    required this.answers,
    required this.correctAnswer,
    this.selectedAnswer,
    this.showResult = false,
    this.isEnabled = true,
    this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        if (index >= answers.length || answers[index].isEmpty) {
          return const SizedBox.shrink();
        }

        final answerText = answers[index];
        final isSelected = selectedAnswer == option;
        final isCorrect = showResult && correctAnswer == option;
        final isWrong = showResult && isSelected && correctAnswer != option;

        return AnswerOptionButton(
          option: option,
          text: answerText,
          isSelected: isSelected,
          isCorrect: isCorrect,
          isWrong: isWrong,
          showResult: showResult,
          isEnabled: isEnabled,
          onPressed: () => onAnswerSelected?.call(option),
        );
      }).toList(),
    );
  }
}

class AnswerSummary extends StatelessWidget {
  final Map<String, String> answers;
  final Map<String, String> correctAnswers;
  final List<String> options;

  const AnswerSummary({
    super.key,
    required this.answers,
    required this.correctAnswers,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tóm tắt câu trả lời:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map((option) {
          final userAnswer = answers[option];
          final correctAnswer = correctAnswers[option];
          final isCorrect = userAnswer == correctAnswer;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green[50] : Colors.red[50],
              border: Border.all(
                color: isCorrect ? Colors.green : Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bạn chọn: ${userAnswer ?? "Không trả lời"}',
                        style: TextStyle(
                          color: isCorrect ? Colors.green[800] : Colors.red[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!isCorrect) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Đáp án đúng: $correctAnswer',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 20,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}