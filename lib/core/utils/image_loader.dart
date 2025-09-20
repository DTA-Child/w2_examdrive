import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class ImageLoaderUtil {
  static Widget loadAssetImage(
      String imagePath, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.contain,
        Widget? placeholder,
        Widget? errorWidget,
      }) {
    return FutureBuilder<bool>(
      future: _assetExists(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? _buildPlaceholder(width, height);
        }

        if (snapshot.hasData && snapshot.data == true) {
          return Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ?? _buildErrorWidget(width, height);
            },
          );
        }

        return errorWidget ?? _buildErrorWidget(width, height);
      },
    );
  }

  static Widget loadTrafficSign(
      String signName, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.contain,
      }) {
    final imagePath = '${AppConstants.trafficSignsPath}$signName';
    return loadAssetImage(
      imagePath,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget loadDiagram(
      String diagramName, {
        double? width,
        double? height,
        BoxFit fit = BoxFit.contain,
      }) {
    final imagePath = '${AppConstants.diagramsPath}$diagramName';
    return loadAssetImage(
      imagePath,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget _buildErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 40,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'Không thể tải hình ảnh',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String? getImagePath(String? mediaPath, String mediaType) {
    if (mediaPath == null || mediaType != AppConstants.mediaTypeImage) {
      return null;
    }

    // Remove leading slash if present
    String cleanPath = mediaPath.startsWith('/') ? mediaPath.substring(1) : mediaPath;

    // Convert to assets path
    if (!cleanPath.startsWith('assets/')) {
      cleanPath = 'assets/$cleanPath';
    }

    return cleanPath;
  }

  static Future<void> preloadImages(List<String> imagePaths) async {
    for (final path in imagePaths) {
      try {
        await rootBundle.load(path);
      } catch (e) {
        debugPrint('Failed to preload image: $path');
      }
    }
  }
}