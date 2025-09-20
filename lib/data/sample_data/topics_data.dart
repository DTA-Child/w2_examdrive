import '../models/topic.dart';

class TopicsData {
  static List<Map<String, dynamic>> getTopicsData() {
    return [
      {
        'id': 1,
        'title': 'QUY ĐỊNH CHUNG VÀ QUY TẮC GIAO THÔNG ĐƯỜNG BỘ',
        'description': 'Các quy định pháp luật về giao thông đường bộ, xử phạt vi phạm, quy tắc tham gia giao thông',
        'icon_path': 'assets/images/icons/app_icon.png',
        'question_count': 0,
      },
      {
        'id': 2,
        'title': 'VĂN HÓA GIAO THÔNG, ĐẠO ĐỨC NGƯỜI LÁI XE',
        'description': 'Văn hóa giao thông, đạo đức nghề nghiệp, kỹ năng phòng cháy chữa cháy và cứu hộ cứu nạn',
        'icon_path': 'assets/images/icons/app_icon.png',
        'question_count': 0,
      },
      {
        'id': 3,
        'title': 'KỸ THUẬT LÁI XE',
        'description': 'Các kỹ thuật lái xe an toàn, xử lý tình huống, thao tác điều khiển phương tiện',
        'icon_path': 'assets/images/icons/app_icon.png',
        'question_count': 0,
      },
      {
        'id': 4,
        'title': 'CẤU TẠO VÀ SỬA CHỮA',
        'description': 'Cấu tạo xe ô tô, xe máy, bảo dưỡng và sửa chữa cơ bản',
        'icon_path': 'assets/images/icons/app_icon.png',
        'question_count': 0,
      },
      {
        'id': 5,
        'title': 'BÁO HIỆU ĐƯỜNG BỘ',
        'description': 'Biển báo giao thông, đèn tín hiệu, vạch kẻ đường và các báo hiệu khác',
        'icon_path': 'assets/images/icons/app_icon.png',
        'question_count': 0,
      },
    ];
  }

  static List<Topic> getTopics() {
    return getTopicsData().map((data) => Topic.fromMap(data)).toList();
  }
}