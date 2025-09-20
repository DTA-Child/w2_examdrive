import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/test_result.dart';
import '../../../data/models/answer_detail.dart';
import '../../../data/repositories/result_repository.dart';
import '../../../routes/app_routes.dart';
import '../widgets/result_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  final ResultRepository _resultRepository = ResultRepository();

  List<TestResult> _allResults = [];
  List<TestResult> _filteredResults = [];
  Map<String, dynamic>? _statistics;

  bool _isLoading = true;
  String? _error;

  // Filter state
  String _selectedFilter = 'all';
  String _selectedSort = 'newest';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final results = await _resultRepository.getAllTestResults();
      final stats = await _resultRepository.getStatistics();

      setState(() {
        _allResults = results;
        _filteredResults = results;
        _statistics = stats;
        _isLoading = false;
      });

      _applyFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<TestResult> filtered = List.from(_allResults);

    // Apply filter
    switch (_selectedFilter) {
      case 'passed':
        filtered = filtered.where((r) => r.isPassed).toList();
        break;
      case 'failed':
        filtered = filtered.where((r) => !r.isPassed).toList();
        break;
      case 'exam':
        filtered = filtered.where((r) => r.testType == AppConstants.testTypeExam).toList();
        break;
      case 'practice':
        filtered = filtered.where((r) => r.testType == AppConstants.testTypePractice).toList();
        break;
    }

    // Apply sort
    switch (_selectedSort) {
      case 'newest':
        filtered.sort((a, b) => b.startTime.compareTo(a.startTime));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.startTime.compareTo(b.startTime));
        break;
      case 'highest_score':
        filtered.sort((a, b) => b.score.compareTo(a.score));
        break;
      case 'lowest_score':
        filtered.sort((a, b) => a.score.compareTo(b.score));
        break;
    }

    setState(() {
      _filteredResults = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading
          ? const LoadingWidget(message: 'Đang tải lịch sử...')
          : _error != null
          ? _buildErrorWidget()
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Lịch sử thi'),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: _showFilterDialog,
          icon: const Icon(Icons.filter_list),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('Làm mới'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.clear_all, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Tất cả'),
          Tab(text: 'Đậu'),
          Tab(text: 'Rớt'),
          Tab(text: 'Thống kê'),
        ],
        onTap: _onTabChanged,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildResultsList(_filteredResults),
        _buildResultsList(_allResults.where((r) => r.isPassed).toList()),
        _buildResultsList(_allResults.where((r) => !r.isPassed).toList()),
        _buildStatisticsTab(),
      ],
    );
  }

  Widget _buildResultsList(List<TestResult> results) {
    if (results.isEmpty) {
      return const EmptyWidget(
        message: 'Chưa có kết quả thi nào',
        icon: Icons.history,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: results.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ResultCard(
            result: results[index],
            onTap: () => _viewResultDetails(results[index]),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsTab() {
    if (_statistics == null) {
      return const LoadingWidget(message: 'Đang tải thống kê...');
    }

    final totalTests = _statistics!['total_tests'] ?? 0;
    final passedTests = _statistics!['passed_tests'] ?? 0;
    final failedTests = _statistics!['failed_tests'] ?? 0;
    final avgScore = (_statistics!['average_score'] ?? 0.0).toDouble();
    final passRate = (_statistics!['pass_rate'] ?? 0.0).toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatisticsCard(
            'Tổng quan',
            [
              _buildStatItem('Tổng số lần thi', totalTests.toString(), Icons.quiz, Colors.blue),
              _buildStatItem('Số lần đậu', passedTests.toString(), Icons.check_circle, Colors.green),
              _buildStatItem('Số lần rớt', failedTests.toString(), Icons.cancel, Colors.red),
              _buildStatItem('Tỷ lệ đậu', '${passRate.toStringAsFixed(1)}%', Icons.trending_up, Colors.purple),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatisticsCard(
            'Điểm số',
            [
              _buildStatItem('Điểm trung bình', avgScore.toStringAsFixed(1), Icons.grade, Colors.orange),
              _buildStatItem('Điểm cao nhất', _getHighestScore().toStringAsFixed(1), Icons.emoji_events, Colors.amber),
              _buildStatItem('Điểm thấp nhất', _getLowestScore().toStringAsFixed(1), Icons.trending_down, Colors.grey),
              _buildStatItem('Lần thi gần nhất', _getRecentScore().toStringAsFixed(1), Icons.access_time, Colors.indigo),
            ],
          ),
          const SizedBox(height: 20),
          _buildTestTypeChart(),
          const SizedBox(height: 20),
          _buildScoreChart(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
              children: items,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestTypeChart() {
    final examCount = _allResults.where((r) => r.testType == AppConstants.testTypeExam).length;
    final practiceCount = _allResults.where((r) => r.testType == AppConstants.testTypePractice).length;
    final topicCount = _allResults.where((r) => r.testType == AppConstants.testTypeByTopic).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân loại theo loại thi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildChartItem('Thi thử', examCount, Colors.red),
            _buildChartItem('Luyện tập', practiceCount, Colors.green),
            _buildChartItem('Theo chủ đề', topicCount, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildChartItem(String label, int count, Color color) {
    final total = _allResults.length;
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label),
          ),
          Text('$count (${percentage.toStringAsFixed(1)}%)'),
        ],
      ),
    );
  }

  Widget _buildScoreChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân bố điểm số',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildScoreRangeItem('90-100', _getScoreRangeCount(90, 100), Colors.green),
            _buildScoreRangeItem('80-89', _getScoreRangeCount(80, 89), Colors.lightGreen),
            _buildScoreRangeItem('70-79', _getScoreRangeCount(70, 79), Colors.orange),
            _buildScoreRangeItem('60-69', _getScoreRangeCount(60, 69), Colors.deepOrange),
            _buildScoreRangeItem('0-59', _getScoreRangeCount(0, 59), Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRangeItem(String range, int count, Color color) {
    final total = _allResults.length;
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(range),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: total > 0 ? count / total : 0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 12),
          Text('$count (${percentage.toStringAsFixed(1)}%)'),
        ],
      ),
    );
  }

  double _getHighestScore() {
    if (_allResults.isEmpty) return 0.0;
    return _allResults.map((r) => r.score).reduce((a, b) => a > b ? a : b);
  }

  double _getLowestScore() {
    if (_allResults.isEmpty) return 0.0;
    return _allResults.map((r) => r.score).reduce((a, b) => a < b ? a : b);
  }

  double _getRecentScore() {
    if (_allResults.isEmpty) return 0.0;
    final sorted = List<TestResult>.from(_allResults);
    sorted.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sorted.first.score;
  }

  int _getScoreRangeCount(double min, double max) {
    return _allResults.where((r) => r.score >= min && r.score <= max).length;
  }

  void _onTabChanged(int index) {
    // Tab changed, could add specific logic here
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lọc và sắp xếp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lọc theo:'),
            DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                DropdownMenuItem(value: 'passed', child: Text('Đậu')),
                DropdownMenuItem(value: 'failed', child: Text('Rớt')),
                DropdownMenuItem(value: 'exam', child: Text('Thi thử')),
                DropdownMenuItem(value: 'practice', child: Text('Luyện tập')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Sắp xếp theo:'),
            DropdownButton<String>(
              value: _selectedSort,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('Mới nhất')),
                DropdownMenuItem(value: 'oldest', child: Text('Cũ nhất')),
                DropdownMenuItem(value: 'highest_score', child: Text('Điểm cao nhất')),
                DropdownMenuItem(value: 'lowest_score', child: Text('Điểm thấp nhất')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _applyFilters();
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'refresh':
        _loadData();
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả lịch sử'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa toàn bộ lịch sử thi? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllResults();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllResults() async {
    try {
      await _resultRepository.clearAllResults();
      await _loadData(); // Reload data sau khi xóa
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa tất cả lịch sử thi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //  PHẦN QUAN TRỌNG: Sửa method này để giống TestScreen
  void _viewResultDetails(TestResult result) async {
    try {
      print('🔍 [DEBUG] Loading result details for ID: ${result.id}');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Đang tải chi tiết...'),
            ],
          ),
        ),
      );

      //  Load answer details từ database (giống như TestProvider có sẵn)
      final answerDetails = await _resultRepository.getAnswerDetailsByResult(result.id!);
      print('🔍 [DEBUG] Loaded ${answerDetails.length} answer details');

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      //  Navigate với đầy đủ data như TestScreen
      if (mounted) {
        print(' [DEBUG] Navigating to result screen...');
        Navigator.pushNamed(
          context,
          AppRoutes.result,
          arguments: {
            'testResult': result,
            'answerDetails': answerDetails,
          },
        ).then((value) {
          print(' [DEBUG] Navigation completed successfully');
        });
      }
    } catch (e) {
      print(' [DEBUG] Error loading result details: $e');

      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải chi tiết: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}

// Widget EmptyWidget
class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyWidget({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}