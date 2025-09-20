import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/audio_player.dart';
import '../utils/image_loader.dart';

class MediaWidget extends StatefulWidget {
  final String? mediaPath;
  final String mediaType;
  final double? width;
  final double? height;

  const MediaWidget({
    super.key,
    this.mediaPath,
    required this.mediaType,
    this.width,
    this.height,
  });

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == AppConstants.mediaTypeAudio) {
      AudioPlayerUtil.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = AudioPlayerUtil.isPlaying &&
                AudioPlayerUtil.currentAudio == widget.mediaPath;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaPath == null || widget.mediaType == AppConstants.mediaTypeNone) {
      return const SizedBox.shrink();
    }

    switch (widget.mediaType) {
      case AppConstants.mediaTypeImage:
        return _buildImageWidget();
      case AppConstants.mediaTypeAudio:
        return _buildAudioWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageWidget() {
    final imagePath = ImageLoaderUtil.getImagePath(widget.mediaPath, widget.mediaType);

    if (imagePath == null) {
      return _buildErrorWidget('Không thể tải hình ảnh');
    }

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: ImageLoaderUtil.loadAssetImage(
          imagePath,
          width: widget.width,
          height: widget.height ?? 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildAudioWidget() {
    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.audiotrack,
            color: Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nhấn để phát âm thanh',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: _handleAudioTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.grey[600],
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleAudioTap() async {
    if (widget.mediaPath == null) return;

    try {
      // Remove 'assets/' prefix and file extension for AssetSource
      String audioPath = widget.mediaPath!;
      if (audioPath.startsWith('assets/')) {
        audioPath = audioPath.substring(7);
      }
      if (audioPath.startsWith('/')) {
        audioPath = audioPath.substring(1);
      }

      await AudioPlayerUtil.play(audioPath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể phát âm thanh'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}