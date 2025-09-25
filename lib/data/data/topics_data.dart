import '../models/topic.dart';

class TopicsData {
  static List<Topic> getTopics() {
    return [
      Topic(
        id: 1,
        title: 'QUY ĐỊNH CHUNG VÀ QUY TẮC GIAO THÔNG ĐƯỜNG BỘ',
        description: 'QUY ĐỊNH CHUNG VÀ QUY TẮC GIAO THÔNG ĐƯỜNG BỘ',
        iconPath: null,
        questionCount: 0,
      ),
      Topic(
        id: 2,
        title: 'VĂN HÓA GIAO THÔNG, ĐẠO ĐỨC NGƯỜI LÁI XE, KỸ NĂNG PHÒNG CHÁY, CHỮA CHÁY VÀ CỨU HỘ, CỨU NẠN',
        description: 'VĂN HÓA GIAO THÔNG, ĐẠO ĐỨC NGƯỜI LÁI XE, KỸ NĂNG PHÒNG CHÁY, CHỮA CHÁY VÀ CỨU HỘ, CỨU NẠN',
        iconPath: null,
        questionCount: 0,
      ),
      Topic(
        id: 3,
        title: 'KỸ THUẬT LÁI XE',
        description: 'KỸ THUẬT LÁI XE',
        iconPath: null,
        questionCount: 0,
      ),
      Topic(
        id: 4,
        title: 'CẤU TẠO VÀ SỬA CHỮA',
        description: 'CẤU TẠO VÀ SỬA CHỮA',
        iconPath: null,
        questionCount: 0,
      ),
      Topic(
        id: 5,
        title: 'BÁO HIỆU ĐƯỜNG BỘ',
        description: 'BÁO HIỆU ĐƯỜNG BỘ',
        iconPath: null,
        questionCount: 0,
      ),
      Topic(
        id: 6,
        title: 'GIẢI THẾ SA HÌNH VÀ KỸ NĂNG XỬ LÝ TÌNH HUỐNG GIAO THÔNG',
        description: 'GIẢI THẾ SA HÌNH VÀ KỸ NĂNG XỬ LÝ TÌNH HUỐNG GIAO THÔNG',
        iconPath: null,
        questionCount: 0,
      ),

    ];
  }

  static Topic? getTopicById(int id) {
    try {
      return getTopics().firstWhere((topic) => topic.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Topic> getTopicsByIds(List<int> ids) {
    return getTopics().where((topic) => ids.contains(topic.id)).toList();
  }
}