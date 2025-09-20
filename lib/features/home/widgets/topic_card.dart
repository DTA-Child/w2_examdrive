import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/topic.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const TopicCard({
    super.key,
    required this.topic,
    this.onTap,
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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              _buildTopicIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTopicInfo(),
              ),
              _buildQuestionCount(),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: _getTopicColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: _getTopicIconWidget(),
      ),
    );
  }

  Widget _getTopicIconWidget() {
    if (topic.iconPath != null && topic.iconPath!.isNotEmpty) {
      return Image.asset(
        topic.iconPath!,
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) => _getDefaultIcon(),
      );
    }
    return _getDefaultIcon();
  }

  Widget _getDefaultIcon() {
    return Icon(
      _getTopicIconData(),
      size: 32,
      color: _getTopicColor(),
    );
  }

  IconData _getTopicIconData() {
    final title = topic.title.toLowerCase();

    if (title.contains('biển báo')) {
      return Icons.traffic;
    } else if (title.contains('luật') || title.contains('quy tắc')) {
      return Icons.gavel;
    } else if (title.contains('kỹ thuật') || title.contains('lái xe')) {
      return Icons.drive_eta;
    } else if (title.contains('sa hình') || title.contains('tình huống')) {
      return Icons.map;
    } else if (title.contains('cấu tạo') || title.contains('động cơ')) {
      return Icons.build;
    } else if (title.contains('an toàn')) {
      return Icons.security;
    } else if (title.contains('văn hóa')) {
      return Icons.people;
    } else {
      return Icons.quiz;
    }
  }

  Color _getTopicColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    return colors[topic.id % colors.length];
  }

  Widget _buildTopicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topic.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (topic.description != null && topic.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            topic.description!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildQuestionCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTopicColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.quiz,
            size: 16,
            color: _getTopicColor(),
          ),
          const SizedBox(width: 4),
          Text(
            '${topic.questionCount}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getTopicColor(),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicGridCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const TopicGridCard({
    super.key,
    required this.topic,
    this.onTap,
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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _getTopicColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    _getTopicIconData(),
                    size: 36,
                    color: _getTopicColor(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                topic.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTopicColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${topic.questionCount} câu',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getTopicColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTopicIconData() {
    final title = topic.title.toLowerCase();

    if (title.contains('biển báo')) {
      return Icons.traffic;
    } else if (title.contains('luật') || title.contains('quy tắc')) {
      return Icons.gavel;
    } else if (title.contains('kỹ thuật') || title.contains('lái xe')) {
      return Icons.drive_eta;
    } else if (title.contains('sa hình') || title.contains('tình huống')) {
      return Icons.map;
    } else if (title.contains('cấu tạo') || title.contains('động cơ')) {
      return Icons.build;
    } else if (title.contains('an toàn')) {
      return Icons.security;
    } else if (title.contains('văn hóa')) {
      return Icons.people;
    } else {
      return Icons.quiz;
    }
  }

  Color _getTopicColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    return colors[topic.id % colors.length];
  }
}