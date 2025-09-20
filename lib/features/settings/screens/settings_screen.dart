import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_helper.dart';
import '../../../data/sample_data/database_seeder.dart';
import '../../../data/repositories/result_repository.dart';
import '../../../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ResultRepository _resultRepository = ResultRepository();

  bool _isLoading = false;
  Map<String, dynamic>? _statistics;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _resultRepository.getStatistics();
      setState(() {
        _statistics = stats;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Cài đặt'),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppInfoSection(),
          const SizedBox(height: 20),
          _buildStatisticsSection(),
          const SizedBox(height: 20),
          _buildDataSection(),
          const SizedBox(height: 20),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.drive_eta,
                    size: 32,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phiên bản ${AppConstants.appVersion}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ứng dụng luyện thi sát hạch lái xe',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
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
                  'Thống kê sử dụng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_statistics != null) ...[
              _buildStatisticItem(
                'Tổng số lần thi',
                '${_statistics!['total_tests'] ?? 0}',
                Icons.quiz,
              ),
              _buildStatisticItem(
                'Số lần đậu',
                '${_statistics!['passed_tests'] ?? 0}',
                Icons.check_circle,
              ),
              _buildStatisticItem(
                'Điểm trung bình',
                '${(_statistics!['average_score'] ?? 0.0).toStringAsFixed(1)}',
                Icons.grade,
              ),
              _buildStatisticItem(
                'Tỷ lệ đậu',
                '${(_statistics!['pass_rate'] ?? 0.0).toStringAsFixed(1)}%',
                Icons.trending_up,
              ),
            ] else ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
                icon: const Icon(Icons.history),
                label: const Text('Xem chi tiết lịch sử'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'Quản lý dữ liệu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              'Làm mới dữ liệu câu hỏi',
              'Tải lại dữ liệu câu hỏi từ đầu',
              Icons.refresh,
              Colors.blue,
              _refreshQuestionData,
            ),
            _buildSettingItem(
              'Xóa lịch sử thi',
              'Xóa toàn bộ kết quả thi đã lưu',
              Icons.delete_sweep,
              Colors.red,
              _clearTestHistory,
            ),
            _buildSettingItem(
              'Khôi phục cài đặt gốc',
              'Đặt lại ứng dụng về trạng thái ban đầu',
              Icons.settings_backup_restore,
              Colors.orange,
              _resetToDefault,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text(
                  'Thông tin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              'Giới thiệu ứng dụng',
              Icons.info_outline,
              _showAboutDialog,
            ),
            _buildInfoItem(
              'Hướng dẫn sử dụng',
              Icons.help_outline,
              _showHelpDialog,
            ),
            _buildInfoItem(
              'Điều khoản sử dụng',
              Icons.description,
              _showTermsDialog,
            ),
            _buildInfoItem(
              'Liên hệ hỗ trợ',
              Icons.contact_support,
              _showContactDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshQuestionData() async {
    final confirmed = await _showConfirmDialog(
      'Làm mới dữ liệu',
      'Bạn có chắc chắn muốn tải lại toàn bộ dữ liệu câu hỏi? Thao tác này có thể mất vài phút.',
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final seeder = DatabaseSeeder();
        await seeder.clearAllData();
        await seeder.seedDatabase();

        _showSnackBar('Đã làm mới dữ liệu thành công', Colors.green);
      } catch (e) {
        _showSnackBar('Có lỗi xảy ra: $e', Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _clearTestHistory() async {
    final confirmed = await _showConfirmDialog(
      'Xóa lịch sử thi',
      'Bạn có chắc chắn muốn xóa toàn bộ lịch sử thi? Hành động này không thể hoàn tác.',
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // This would need to be implemented in ResultRepository
        // await _resultRepository.clearAllResults();
        _showSnackBar('Chức năng chưa được triển khai', Colors.orange);
      } catch (e) {
        _showSnackBar('Có lỗi xảy ra: $e', Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
        await _loadStatistics();
      }
    }
  }

  Future<void> _resetToDefault() async {
    final confirmed = await _showConfirmDialog(
      'Khôi phục cài đặt gốc',
      'Bạn có chắc chắn muốn đặt lại ứng dụng về trạng thái ban đầu? Toàn bộ dữ liệu sẽ bị xóa.',
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.deleteDatabase();

        // Reinitialize database
        await dbHelper.database;
        final seeder = DatabaseSeeder();
        await seeder.seedDatabase();

        _showSnackBar('Đã khôi phục cài đặt gốc thành công', Colors.green);
      } catch (e) {
        _showSnackBar('Có lỗi xảy ra: $e', Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
        await _loadStatistics();
      }
    }
  }

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Giới thiệu ứng dụng'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Phiên bản: ${AppConstants.appVersion}'),
              SizedBox(height: 16),
              Text(
                'Ứng dụng luyện thi sát hạch lái xe với đầy đủ các chủ đề và câu hỏi theo quy định hiện hành.',
                style: TextStyle(height: 1.4),
              ),
              SizedBox(height: 12),
              Text('Tính năng chính:'),
              SizedBox(height: 8),
              Text('• Thi thử với 30 câu hỏi'),
              Text('• Luyện tập theo chủ đề'),
              Text('• Xem lịch sử kết quả thi'),
              Text('• Thống kê chi tiết'),
              Text('• Hoạt động offline hoàn toàn'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hướng dẫn sử dụng'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Thi thử',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- Làm bài thi với 30 câu hỏi trong 22 phút'),
              Text('- Cần đạt ≥80% và không sai quá 1 câu liệt để đậu'),
              SizedBox(height: 12),
              Text(
                '2. Luyện tập',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- Làm bài luyện tập với 20 câu hỏi'),
              Text('- Không giới hạn thời gian'),
              Text('- Có thể xem đáp án ngay'),
              SizedBox(height: 12),
              Text(
                '3. Ôn tập theo chủ đề',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- Chọn chủ đề cụ thể để ôn tập'),
              Text('- Làm tất cả câu hỏi trong chủ đề'),
              SizedBox(height: 12),
              Text(
                '4. Xem kết quả',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('- Xem chi tiết từng câu trả lời'),
              Text('- Thống kê tổng quan'),
              Text('- Lịch sử các lần thi'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Điều khoản sử dụng'),
        content: const SingleChildScrollView(
          child: Text(
            'Bằng cách sử dụng ứng dụng này, bạn đồng ý với các điều khoản sau:\n\n'
                '1. Ứng dụng được cung cấp "như hiện tại" mà không có bảo đảm nào.\n\n'
                '2. Dữ liệu câu hỏi chỉ mang tính chất tham khảo và luyện tập.\n\n'
                '3. Người dùng chịu trách nhiệm về việc sử dụng ứng dụng.\n\n'
                '4. Chúng tôi không chịu trách nhiệm về bất kỳ thiệt hại nào phát sinh từ việc sử dụng ứng dụng.\n\n'
                '5. Các điều khoản có thể được cập nhật mà không cần thông báo trước.',
            style: TextStyle(height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Liên hệ hỗ trợ'),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nếu bạn gặp vấn đề hoặc có góp ý về ứng dụng, vui lòng liên hệ:'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, size: 20),
                SizedBox(width: 8),
                Text('2124802010674@student.tdmu.edu.vn'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 20),
                SizedBox(width: 8),
                Text('xxxxxxxxxxxx'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Chúng tôi sẽ phản hồi trong vòng 24 giờ (nếu thấy :D ).',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}