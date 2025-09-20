import '../../core/database/database_service.dart';
import '../../core/database/database_helper.dart';
import '../repositories/topic_repository.dart';
import '../repositories/question_repository.dart';
import '../models/topic.dart';
import '../models/question.dart';
import '../../core/constants/app_constants.dart';

class DatabaseSeeder {
  final DatabaseService _databaseService = DatabaseService();
  final TopicRepository _topicRepository = TopicRepository();
  final QuestionRepository _questionRepository = QuestionRepository();

  // Danh sách câu điểm liệt theo bảng
  static const List<int> mandatoryQuestionIds = [
    19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
    30, 32, 34, 35, 47, 48, 52, 53, 55, 58,
    63, 64, 65, 66, 67, 68, 70, 71, 72, 73,
    74, 85, 86, 87, 88, 89, 90, 91, 92, 93,
    97, 98, 102, 117, 163, 165, 167, 197, 198, 206,
    215, 226, 234, 245, 246, 252, 253, 254, 255, 260
  ];

  Future<void> addRealData() async {
    try {
      print('🚀 Starting to add real driving test data...');

      // Add topics first
      await _addTopics();

      // Add questions with mandatory marking
      await _addQuestions();

      // Update topic question counts
      await _updateTopicQuestionCounts();

      print('✅ Real data added successfully!');
    } catch (e) {
      print('❌ Error adding real data: $e');
      rethrow;
    }
  }

  Future<void> _addTopics() async {
    print('📚 Adding topics...');

    final topics = [
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
    ];

    for (final topic in topics) {
      try {
        await _topicRepository.insertTopic(topic);
        print('  ✓ Added topic: ${topic.title}');
      } catch (e) {
        print('  ❌ Error adding topic ${topic.title}: $e');
      }
    }
  }

  Future<void> _addQuestions() async {
    print('❓ Adding questions...');

    final questions = [
      // TOPIC 1
      Question(
        id: 23,
        title: 'Câu hỏi số 23',
        content: 'Hành vi của người điều khiển xe ô tô và các loại xe tương tự khi tham gia giao thông đường bộ mà trong cơ thể có chất ma túy thì bị áp dụng hình thức xử phạt vi phạm hành chính nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Bị phạt tiền',
        ansB: '2. Bị tước giấy phép lái xe',
        ansC: '3. Cả hai ý trên',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(23),
        difficulty: 1,
      ),

      Question(
        id: 24,
        title: 'Câu hỏi số 24',
        content: 'Người điều khiển phương tiện tham gia giao thông đường bộ mà trong máu hoặc hơi thở có nồng độ cồn có bị nghiêm cấm không?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Bị nghiêm cấm',
        ansB: '2. Không bị nghiêm cấm',
        ansC: '3. Không bị nghiêm cấm, nếu nồng độ cồn trong máu ở mức nhẹ, có thể điều khiển phương tiện tham gia giao thông',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(24),
        difficulty: 1,
      ),

      Question(
        id: 25,
        title: 'Câu hỏi số 25',
        content: 'Hành vi của người điều khiển xe ô tô và các loại xe tương tự khi tham gia giao thông đường bộ mà trong máu hoặc hơi thở có nồng độ cồn thì bị áp dụng hình thức xử phạt vi phạm hành chính nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Bị phạt tiền',
        ansB: '2. Có thể bị tước giấy phép lái xe',
        ansC: '3. Cả hai ý trên',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(25),
        difficulty: 1,
      ),

      Question(
        id: 26,
        title: 'Câu hỏi số 26',
        content: 'Theo Luật Phòng chống tác hại của rượu, bia, đối tượng nào dưới đây bị cấm sử dụng rượu, bia khi tham gia giao thông?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Người điều khiển xe ô tô, xe mô tô, xe đạp, xe gắn máy',
        ansB: '2. Người được chở trên xe cơ giới',
        ansC: '3. Cả hai ý trên',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(26),
        difficulty: 1,
      ),

      Question(
        id: 27,
        title: 'Câu hỏi số 27',
        content: 'Hành vi giao xe ô tô, mô tô cho người nào sau đây tham gia giao thông đường bộ bị nghiêm cấm?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Người chưa đủ tuổi theo quy định',
        ansB: '2. Người không có giấy phép lái xe',
        ansC: '3. Người có giấy phép lái xe nhưng đã bị trừ hết 12 điểm',
        ansD: '4. Cả ba ý trên',
        ansRight: 'D',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(27),
        difficulty: 1,
      ),

      Question(
        id: 28,
        title: 'Câu hỏi số 28',
        content: 'Hành vi nào sau đây bị nghiêm cấm?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Điều khiển xe cơ giới lạng lách, đánh võng, rú ga liên tục khi tham gia giao thông trên đường',
        ansB: '2. Xúc phạm, đe dọa, cản trở, chống đối hoặc không chấp hành hiệu lệnh, hướng dẫn, yêu cầu kiểm tra, kiểm soát của người thi hành công vụ về bảo đảm trật tự, an toàn giao thông đường bộ',
        ansC: '3. Cả hai ý trên',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(28),
        difficulty: 1,
      ),

      Question(
        id: 29,
        title: 'Câu hỏi số 29',
        content: 'Các hành vi nào sau đây bị cấm đối với phương tiện tham gia giao thông đường bộ?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Điều khiển xe cơ giới lạng lách, đánh võng, rú ga liên tục khi tham gia giao thông trên đường',
        ansB: '2. Cải tạo trái phép; cố ý can thiệp làm sai lệch chỉ số trên đồng hồ báo quãng đường đã chạy của xe ô tô; cắt, hàn, tẩy xóa, đục sửa, đóng lại trái phép số khung, số động cơ của xe cơ giới, xe máy chuyên dùng.',
        ansC: null,
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(28),
        difficulty: 2,
      ),

      Question(
        id: 30,
        title: 'Câu hỏi số 30',
        content: 'Hành vi nào sau đây bị nghiêm cấm?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Lắp đặt, sử dụng thiết bị âm thanh, ánh sáng trên xe cơ giới, xe máy chuyên dùng gây mất trật tự, an toàn giao thông đường bộ.',
        ansB: '2. Cản trở người, phương tiện tham gia giao thông trên đường bộ; ném gạch, đất, đá, cát hoặc vật thể khác vào người, phương tiện đang tham gia giao thông trên đường bộ.',
        ansC: '3. Cả hai ý trên',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(30),
        difficulty: 1,
      ),

      Question(
        id: 31,
        title: 'Câu hỏi số 31',
        content: 'Việc sản xuất, sử dụng, mua, bán trái phép biển số xe có bị nghiêm cấm hay không?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Không bị nghiêm cấm.',
        ansB: '2. Bị nghiêm cấm.',
        ansC: '3. Bị nghiêm cấm tùy trường hợp.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(32),
        difficulty: 3,
      ),

      Question(
        id: 32,
        title: 'Câu hỏi số 32',
        content: 'Khi điều khiển phương tiện tham gia giao thông, những hành vi nào dưới đây bị nghiêm cấm?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Thay đổi tốc độ của xe nhiều lần.',
        ansB: '2. Điều khiển phương tiện sau 23 giờ trong ngày.',
        ansC: '3. Lạng lách, đánh võng, rú ga liên tục.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(32),
        difficulty: 1,
      ),

      Question(
        id: 33,
        title: 'Câu hỏi số 33',
        content: 'Có bao nhiêu nhóm biển báo hiệu đường bộ?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Ba nhóm: Biển báo cấm, biển báo nguy hiểm và biển hiệu lệnh.',
        ansB: '2. Bốn nhóm: Biển báo cấm, biển báo nguy hiểm, biển hiệu lệnh và biển phụ.',
        ansC: '3. Năm nhóm: Biển báo cấm, biển báo nguy hiểm, biển hiệu lệnh, biển chỉ dẫn, biển phụ.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(34),
        difficulty: 3,
      ),

      Question(
        id: 34,
        title: 'Câu hỏi số 34',
        content: 'Tại nơi có vạch kẻ đường hoặc tại nơi mà người đi bộ, xe lăn của người khuyết tật đang qua đường, người điều khiển phương tiện tham gia giao thông phải thực hiện như thế nào?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Giảm tốc độ và nhường đường cho người đi bộ, xe lăn của người khuyết tật qua đường đảm bảo an toàn.',
        ansB: '2. Quan sát, giảm tốc độ hoặc dừng lại để bảo đảm an toàn cho người đi bộ, xe lăn của người khuyết tật qua đường.',
        ansC: '3. Quan sát, tăng tốc độ và điều khiển phương tiện nhanh chóng đi qua.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(34),
        difficulty: 1,
      ),

      Question(
        id: 35,
        title: 'Câu hỏi số 35',
        content: 'Người điều khiển xe mô tô phải quan sát, giảm tốc độ hoặc dừng lại để bảo đảm an toàn trong các trường hợp nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Đường hẹp, đường vòng, đường quanh co, đường đèo, dốc.',
        ansB: '2. Nơi cầu, cống hẹp, đập tràn, đường ngầm, hầm chui, hầm đường bộ.',
        ansC: '3. Trời mưa, gió, sương, khói, bụi, mặt đường trơn trượt, lầy lội, có nhiều đất đá, vật liệu rơi vãi ảnh hưởng đến an toàn giao thông đường bộ.',
        ansD: '4. Cả ba ý trên.',
        ansRight: 'D',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(35),
        difficulty: 2,
      ),

      Question(
        id: 36,
        title: 'Câu hỏi số 36',
        content: 'Khi gặp hiệu lệnh điều khiển của Cảnh sát giao thông như hình dưới đây thì người tham gia giao thông đường bộ phải đi như thế nào là đúng quy tắc giao thông?',
        audio: 'assets/images/traffic_signs/336.png',
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Người tham gia giao thông đường bộ ở các hướng phải dừng lại.',
        ansB: '2. Người tham gia giao thông đường bộ ở các hướng được đi theo chiều gậy chỉ của Cảnh sát giao thông.',
        ansC: '3. Người tham gia giao thông đường bộ ở phía trước và phía sau người điều khiển được đi tất cả các hướng; người tham gia giao thông đường bộ ở phía bên phải và phía bên trái người điều khiển phải dừng lại.',
        ansD: '4. Người tham gia giao thông đường bộ ở phía trước và phía sau người điều khiển phải dừng lại; người tham gia giao thông đường bộ ở phía bên phải và phía bên trái người điều khiển được đi tất cả các hướng.',
        ansRight: 'D',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(36),
        difficulty: 2,
      ),

      Question(
        id: 37,
        title: 'Câu hỏi số 37',
        content: 'Khi gặp hiệu lệnh điều khiển của Cảnh sát giao thông như hình dưới đây thì người tham gia giao thông đường bộ phải đi như thế nào là đúng quy tắc giao thông?',
        audio: 'assets/images/traffic_signs/337.png',
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Người tham gia giao thông đường bộ ở phía sau Cảnh sát giao thông được đi, các hướng khác phải dừng lại.',
        ansB: '2. Người tham gia giao thông đường bộ được rẽ phải theo chiều mũi tên màu xanh ở bục Cảnh sát giao thông.',
        ansC: '3. Người tham gia giao thông đường bộ ở tất cả các hướng phải dừng lại, trừ các xe đã ở trong khu vực giao nhau.',
        ansD: '4. Người tham gia giao thông đường bộ ở phía trước Cảnh sát giao thông phải dừng lại, các hướng khác được đi.',
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(37),
        difficulty: 2,
      ),

      Question(
        id: 38,
        title: 'Câu hỏi số 38',
        content: 'Khi hiệu lệnh của người điều khiển giao thông trái với tín hiệu đèn giao thông hoặc biển báo hiệu đường bộ thì người tham gia giao thông đường bộ phải chấp hành báo hiệu đường bộ nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Theo hiệu lệnh của người điều khiển giao thông.',
        ansB: '2. Theo tín hiệu đèn giao thông.',
        ansC: '3. Theo biển báo hiệu đường bộ.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(38),
        difficulty: 3,
      ),

      Question(
        id: 39,
        title: 'Câu hỏi số 39',
        content: 'Khi ở một vị trí vừa có biển báo hiệu đặt cố định vừa có biển báo hiệu tạm thời mà hai biển có ý nghĩa khác nhau, người tham gia giao thông đường bộ phải chấp hành hiệu lệnh của biển báo hiệu nào?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Biển báo hiệu đặt cố định.',
        ansB: '2. Biển báo hiệu tạm thời.',
        ansC: '3. Theo quyết định của người tham gia giao thông nhưng phải bảo đảm an toàn.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(39),
        difficulty: 3,
      ),

      Question(
        id: 40,
        title: 'Câu hỏi số 40',
        content: 'Tại nơi đường giao nhau, khi đèn điều khiển giao thông có tín hiệu màu vàng, người điều khiển phương tiện tham gia giao thông phải chấp hành như thế nào là đúng quy tắc giao thông?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Dừng lại trước vạch dừng; trường hợp đang đi trên vạch dừng hoặc đã đi qua vạch dừng mà tín hiệu đèn màu vàng thì được đi tiếp; trường hợp tín hiệu đèn màu vàng nhấp nháy, người điều khiển phương tiện được đi nhưng phải quan sát, giảm tốc độ hoặc dừng lại nhường đường cho người đi bộ.',
        ansB: '2. Tăng tốc độ nhanh chóng vượt qua nút giao.',
        ansC: '3. Quan sát, giảm tốc độ, từ từ vượt qua nút giao.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(40),
        difficulty: 2,
      ),

      Question(
        id: 41,
        title: 'Câu hỏi số 41',
        content: 'Người lái xe trên đường cần chấp hành quy định về tốc độ tối đa như thế nào?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Chỉ lớn hơn tốc độ tối đa cho phép khi đường vắng.',
        ansB: '2. Chỉ lớn hơn tốc độ tối đa cho phép khi vào ban đêm.',
        ansC: '3. Không vượt quá tốc độ tối đa cho phép.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(41),
        difficulty: 2,
      ),

      Question(
        id: 42,
        title: 'Câu hỏi số 42',
        content: 'Khi chở trẻ em dưới 10 tuổi và chiều cao dưới 1,35 mét trên xe ô tô, người lái xe phải thực hiện quy tắc nào để đảm bảo an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Không được cho trẻ em ngồi cùng hàng ghế với người lái xe, trừ loại xe ô tô chỉ có một hàng ghế; người lái xe phải sử dụng, hướng dẫn sử dụng thiết bị an toàn phù hợp cho trẻ em.',
        ansB: '2. Cho trẻ em ngồi cùng hàng ghế với người lái xe, người lái xe phải sử dụng, hướng dẫn sử dụng thiết bị an toàn phù hợp cho trẻ em.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(42),
        difficulty: 3,
      ),

      Question(
        id: 43,
        title: 'Câu hỏi số 43',
        content: 'Phương tiện tham gia giao thông đường bộ di chuyển với tốc độ thấp hơn phải đi như thế nào?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Đi về bên trái theo chiều đi của mình.',
        ansB: '2. Đi về bên phải theo chiều đi của mình.',
        ansC: '3. Đi ở bất cứ bên nào nhưng phải bấm đèn cảnh báo nguy hiểm để báo hiệu cho các phương tiện khác.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(43),
        difficulty: 2,
      ),

      Question(
        id: 44,
        title: 'Câu hỏi số 44',
        content: 'Trên một chiều đường có vạch kẻ phân làn đường, người lái xe cơ giới, xe máy chuyên dùng phải điều khiển xe đi trên làn đường nào?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Đi trên làn đường bên phải trong cùng.',
        ansB: '2. Đi trên làn đường bên trái.',
        ansC: '3. Đi ở bất cứ làn nào nhưng phải bảo đảm tốc độ cho phép.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 1,
        mandatory: mandatoryQuestionIds.contains(44),
        difficulty: 2,
      ),

      // TOPIC 2
      Question(
        id: 184,
        title: 'Câu hỏi số 184',
        content: 'Người lái xe ô tô vận chuyển hành khách phải có những phẩm chất, đạo đức nghề nghiệp gì dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: 'Phải có thái độ lịch sự, tôn trọng, thân mật với hành khách; giúp đỡ những người có hoàn cảnh khó khăn, người già, người khuyết tật, phụ nữ có thai, có con nhỏ và trẻ em.',
        ansB: 'Luôn tu dưỡng bản thân, có lối sống lành mạnh, khiêm tốn, có tác phong làm việc công nghiệp, không tham gia vào các tệ nạn xã hội; tôn trọng người cùng tham gia giao thông đường bộ và có ý thức bảo vệ môi trường.',
        ansC: 'Cả hai ý trên.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 2,
        mandatory: mandatoryQuestionIds.contains(184),
        difficulty: 1,
      ),

      Question(
        id: 185,
        title: 'Câu hỏi số 185',
        content: 'Khái niệm về văn hóa giao thông được hiểu như thế nào là đúng?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: 'Là sự hiểu biết và chấp hành nghiêm chỉnh pháp luật về giao thông, là ý thức trách nhiệm với cộng đồng khi tham gia giao thông.',
        ansB: 'Là sự tôn trọng, nhường nhịn, giúp đỡ và ứng xử có văn hóa giữa những người tham gia giao thông với nhau.',
        ansC: 'Cả hai ý trên.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 2,
        mandatory: mandatoryQuestionIds.contains(185),
        difficulty: 2,
      ),

      Question(
        id: 186,
        title: 'Câu hỏi số 186',
        content: 'Trên làn đường dành cho ô tô có vũng nước lớn, người lái xe ô tô bắt buộc phải đi qua vũng nước, trên làn đường bên cạnh có nhiều người đang lái xe mô tô tham gia giao thông, người lái xe ô tô xử lý như thế nào khi lái xe qua vũng nước là có văn hóa giao thông?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: 'Cho xe chạy thật nhanh qua vũng nước.',
        ansB: 'Giảm tốc độ cho xe chạy chậm qua vũng nước.',
        ansC: 'Giảm tốc độ cho xe chạy qua làn đường dành cho mô tô để tránh vũng nước.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 2,
        mandatory: mandatoryQuestionIds.contains(186),
        difficulty: 2,
      ),

      // TOPIC 3
      Question(
        id: 214,
        title: 'Câu hỏi số 214',
        content: 'Khi xuống dốc, muốn dừng xe, người lái xe cần thực hiện các thao tác nào để bảo đảm an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Có tín hiệu rẽ phải, điều khiển xe sát vào lề đường bên phải; đạp phanh sớm và mạnh hơn lúc dừng xe trên đường bằng để xe đi với tốc độ chậm đến mức dễ dàng dừng lại được; về số 1, đạp 1/2 ly hợp (côn) cho xe đến chỗ dừng; khi xe đã dừng, về số không (N), đạp phanh chân, sử dụng phanh đỗ.',
        ansB: '2. Có tín hiệu rẽ phải, điều khiển xe sát vào lề đường bên trái; đạp hết hành trình ly hợp (côn) và nhả bàn đạp ga để xe đi với tốc độ chậm đến mức dễ dàng dừng lại được tại chỗ dừng; khi xe đã dừng, đạp và giữ phanh chân.',
        ansC: '3. Có tín hiệu rẽ trái, điều khiển xe sát vào lề đường bên phải; đạp phanh sớm và mạnh hơn lúc dừng xe trên đường bằng để xe đi với tốc độ chậm đến mức dễ dàng dừng lại được; về số không (N) để xe đi đến chỗ dừng, khi xe đã dừng, sử dụng phanh đỗ.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(214),
        difficulty: 3,
      ),

      Question(
        id: 215,
        title: 'Câu hỏi số 215',
        content: 'Khi đi trên đường trơn, người lái xe ô tô cần chú ý điều gì để đảm bảo an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Quan sát cẩn thận các chướng ngại vật và báo hiệu bằng coi, đèn; giảm tốc độ tới mức cần thiết, về số thấp và thực hiện quay vòng với tốc độ phù hợp với bán kính cong của đường vòng.',
        ansB: '2. Quan sát cẩn thận các chướng ngại vật và báo hiệu bằng còi, đèn; tăng tốc để nhanh chóng qua đường vòng và giảm tốc độ sau khi qua đường vòng.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(215),
        difficulty: 215,
      ),

      Question(
        id: 216,
        title: 'Câu hỏi số 216',
        content: 'Khi điều khiển xe ô tô rẽ phải, người lái xe cần thực hiện các thao tác nào để bảo đảm an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Có tín hiệu rẽ phải; quan sát an toàn phía sau; điều khiển xe sang làn đường bên trái; giảm tốc độ và quan sát an toàn phía bên phải để điều khiển xe qua chỗ đường giao nhau.',
        ansB: '2. Cách chỗ rẽ một khoảng cách an toàn có tín hiệu rẽ phải; giảm tốc độ, quan sát an toàn phía trước, sau, bên phải và điều khiển xe từ từ rẽ phải.',
        ansC: '3. Cách chỗ rẽ một khoảng cách an toàn có tín hiệu rẽ phải; quan sát an toàn phía sau; điều khiển xe bám sát vào phía phải đường; tăng tốc độ và quan sát an toàn phía bên trái để điều khiển xe qua chỗ đường giao nhau.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(216),
        difficulty: 216,
      ),

      Question(
        id: 217,
        title: 'Câu hỏi số 217',
        content: 'Khi điều khiển xe máy qua nơi đông người cần chú ý gì để bảo đảm an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Cách chỗ rẽ một khoảng cách an toàn có tín hiệu rẽ trái; giảm tốc độ, quan sát an toàn xung quanh đặc biệt là bên trái; đổi sang làn đường bên trái và điều khiển xe từ từ rẽ trái.',
        ansB: '2. Cách chỗ rẽ một khoảng cách an toàn có tín hiệu rẽ trái, tăng tốc độ để xe nhanh chóng qua chỗ đường giao nhau; có tín hiệu xin đổi làn đường; quan sát an toàn xung quanh đặc biệt là bên trái; đổi làn đường sang phải để mở rộng vòng cua.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(217),
        difficulty: 217,
      ),

      Question(
        id: 218,
        title: 'Câu hỏi số 218',
        content: 'Khi điều khiển xe sử dụng hộp số cơ khí vượt qua rãnh lớn cắt ngang mặt đường, người lái xe cần thực hiện các thao tác nào để đảm bảo an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Vào số một (1) và từ từ cho hai bánh xe trước xuống rãnh, tăng ga cho hai bánh xe trước vượt lên khỏi rãnh, tăng số, tăng tốc độ để bánh xe sau vượt qua rãnh.',
        ansB: '2. Tăng ga, tăng số để hai bánh xe trước và bánh xe sau vượt qua khỏi rãnh và chạy bình thường.',
        ansC: '3. Vào số một (1) và từ từ cho hai bánh xe trước xuống rãnh, tăng ga cho hai bánh xe trước vượt lên khỏi rãnh, tiếp tục để bánh xe sau từ từ xuống rãnh rồi tăng dần ga cho xe ô tô lên khỏi rãnh.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(218),
        difficulty: 218,
      ),

      Question(
        id: 219,
        title: 'Câu hỏi số 219',
        content: 'Khi điều khiển xe qua đường sắt, người lái xe cần phải thực hiện các thao tác nào dưới đây để bảo đảm an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Khi có chuông báo hoặc thanh chắn đã hạ xuống, người lái xe phải dừng xe tạm thời đúng khoảng cách an toàn, kéo phanh tay nếu đường dốc hoặc phải chờ lâu.',
        ansB: '2. Khi không có chuông báo hoặc thanh chắn không hạ xuống, người lái xe cần phải quan sát nếu thấy đủ điều kiện an toàn thì về số thấp, tăng ga nhẹ và không thay đổi số trong quá trình vượt qua đường sắt để tránh động cơ chết máy cho xe cho vượt qua.',
        ansC: '3. Cả hai ý trên.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(219),
        difficulty: 219,
      ),

      Question(
        id: 220,
        title: 'Câu hỏi số 220',
        content: 'Khi điều khiển xe ô tô tự đổ, người lái xe cần chú ý những điểm gì để bảo đảm an toàn?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Khi chạy trên đường xấu, nhiều ổ gà nên chạy chậm để thùng xe không bị lắc mạnh, không gây hiện tượng lệch "ben"; khi chạy vào đường vòng, cần giảm tốc độ, không lấy lái gấp và không phanh gấp.',
        ansB: '2. Khi chạy trên đường quốc lộ, đường bằng phẳng không cần hạ hết thùng xe xuống.',
        ansC: '3. Khi đổ hàng phải chọn vị trí có nền đường cứng và phẳng, dừng hẳn xe, kéo hết phanh đỗ; sau đó mới điều khiển cơ cấu nâng "ben" để đổ hàng, đổ xong hàng mới hạ thùng xuống.',
        ansD: '4. Ý 1 và ý 3.',
        ansRight: 'D',
        ansHint: null,
        topicId: 3,
        mandatory: mandatoryQuestionIds.contains(219),
        difficulty: 3,
      ),

      // TOPIC 4: CẤU TẠO VÀ SỬA CHỮA
      Question(
        id: 270,
        title: 'Câu hỏi số 270',
        content: 'Hệ thống lái trên xe ô tô phải bảo đảm yêu cầu nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Bảo đảm cho xe chuyển hướng chính xác, điều khiển nhẹ nhàng, an toàn ở mọi vận tốc và tải trọng trong phạm vi tính năng kỹ thuật cho phép của xe.',
        ansB: '2. Khi hoạt động các cơ cấu chuyển động của hệ thống lái không được va chạm với bất kỳ bộ phận nào của xe; khi quay vô lăng lái về bên phải và bên trái thì không được có sự khác biệt đáng kể về lực tác động lên vành tay lái.',
        ansC: '3. Cả hai ý trên.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 4,
        mandatory: mandatoryQuestionIds.contains(270),
        difficulty: 2,
      ),

      Question(
        id: 271,
        title: 'Câu hỏi số 271',
        content: 'Mục đích của bảo dưỡng thường xuyên đối với xe ô tô có tác dụng gì dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Bảo dưỡng ô tô thường xuyên làm cho ô tô luôn luôn có tính năng kỹ thuật tốt, giảm cường độ hao mòn của các chi tiết, kéo dài tuổi thọ của xe.',
        ansB: '2. Ngăn ngừa và phát hiện kịp thời các hư hỏng và sai lệch kỹ thuật để khắc phục, giữ gìn được hình thức bên ngoài.',
        ansC: '3. Cả hai ý trên.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 4,
        mandatory: mandatoryQuestionIds.contains(271),
        difficulty: 2,
      ),

      Question(
        id: 272,
        title: 'Câu hỏi số 272',
        content: 'Trong các nguyên nhân nêu dưới đây, nguyên nhân nào làm động cơ diesel không nổ?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Hết nhiên liệu, lõi lọc nhiên liệu bị tắc, lọc khí bị tắc, nhiên liệu lẫn không khí, tạp chất.',
        ansB: '2. Hết nhiên liệu, lõi lọc nhiên liệu bị tắc, lọc khí bị tắc, nhiên liệu lẫn không khí, không có tia lửa điện.',
        ansC: '3. Hết nhiên liệu, lõi lọc nhiên liệu bị tắc, lọc khí bị tắc, nhiên liệu lẫn không khí và nước, không có tia lửa điện.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 4,
        mandatory: mandatoryQuestionIds.contains(272),
        difficulty: 3,
      ),

      Question(
        id: 273,
        title: 'Câu hỏi số 273',
        content: 'Ống xả lắp trên xe ô tô phải bảo đảm yêu cầu an toàn kỹ thuật nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Ống xả không được đặt ở vị trí có thể gây cháy xe hoặc ảnh hưởng đến người ngồi trên xe và gây cản trở hoạt động của hệ thống khác.',
        ansB: '2. Miệng thoát khí thải của ống xả không được hướng về phía trước và không được hướng về bên phải theo chiều tiến của xe.',
        ansC: '3. Cả hai ý trên.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 4,
        mandatory: mandatoryQuestionIds.contains(273),
        difficulty: 2,
      ),

      Question(
        id: 274,
        title: 'Câu hỏi số 274',
        content: 'Dây đai an toàn lắp trên xe ô tô phải bảo đảm yêu cầu an toàn kỹ thuật nào dưới đây?',
        audio: null,
        mediaType: AppConstants.mediaTypeNone,
        ansA: '1. Đủ số lượng, lắp đặt chắc chắn không bị rách, đứt, khóa cài đóng, mở nhẹ nhàng, không tự mở, không bị kẹt; kéo ra thu vào dễ dàng, cơ cấu hãm giữ chặt dây khi giật dây đột ngột.',
        ansB: '2. Đủ số lượng, lắp đặt chắc chắn không bị rách, đứt, khóa cài đóng, mở nhẹ nhàng, không tự mở, không bị kẹt; kéo ra thu vào dễ dàng, cơ cấu hãm mở ra khi giật dây đột ngột.',
        ansC: '3. Cả hai ý trên.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 4,
        mandatory: mandatoryQuestionIds.contains(273),
        difficulty: 2,
      ),

      // TOPIC 5: BÁO HIỆU ĐƯỜNG BỘ (có hình ảnh)
      Question(
        id: 339,
        title: 'Câu hỏi số 339',
        content: 'Biển số 3 có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_339.png', // Đây là trường audio dùng cho media
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Cấm các loại xe có tải trọng toàn bộ trên 10 tấn đi qua.',
        ansB: '2. Hạn chế khối lượng hàng hóa chở trên xe.',
        ansC: '3. Hạn chế tải trọng trên trục xe.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(339),
        difficulty: 2,
      ),

      Question(
        id: 340,
        title: 'Câu hỏi số 340',
        content: 'Biển nào cấm máy kéo kéo theo rơ moóc?',
        audio: 'assets/images/traffic_signs/sign_340.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Cả hai biển.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(340),
        difficulty: 2,
      ),

      Question(
        id: 341,
        title: 'Câu hỏi số 341',
        content: 'Khi gặp biển số 1, xe ô tô tải có được đi vào không?',
        audio: 'assets/images/traffic_signs/sign_341.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Được đi vào.',
        ansB: '2. Không được đi vào.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(341),
        difficulty: 2,
      ),

      Question(
        id: 342,
        title: 'Câu hỏi số 342',
        content: 'Biển nào không có hiệu lực đối với xe ô tô tải không kéo moóc?',
        audio: 'assets/images/traffic_signs/sign_342.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1 và biển 2.',
        ansB: '2. Biển 2 và biển 3.',
        ansC: '3. Biển 1 và biển 3.',
        ansD: '4. Cả ba biển.',
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(342),
        difficulty: 2,
      ),

      Question(
        id: 343,
        title: 'Câu hỏi số 343',
        content: 'Biển nào cấm máy kéo?',
        audio: 'assets/images/traffic_signs/sign_343.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1 và biển 2.',
        ansB: '2. Biển 1 và biển 3.',
        ansC: '3. Biển 2 và biển 3.',
        ansD: '4. Cả ba biển.',
        ansRight: 'C',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(343),
        difficulty: 2,
      ),

      Question(
        id: 344,
        title: 'Câu hỏi số 344',
        content: 'Khi gặp biển này, xe mô tô ba bánh chở hàng có được phép rẽ trái hoặc rẽ phải hay không?',
        audio: 'assets/images/traffic_signs/sign_344.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Được phép.',
        ansB: '2. Không được phép.',
        ansC: null,
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(344),
        difficulty: 2,
      ),

      Question(
        id: 345,
        title: 'Câu hỏi số 345',
        content: 'Biển này có hiệu lực đối với xe mô tô hai bánh, ba bánh chở hàng không?',
        audio: 'assets/images/traffic_signs/sign_345.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Có.',
        ansB: '2. Không.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(345),
        difficulty: 2,
      ),

      Question(
        id: 346,
        title: 'Câu hỏi số 346',
        content: 'Biển này có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_346.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Cấm xe cơ giới (trừ xe ưu tiên theo luật định) đi thẳng.',
        ansB: '2. Cấm các loại xe cơ giới và xe mô tô (trừ xe ưu tiên theo luật định) đi về bên trái và bên phải.',
        ansC: '3. Hướng trái và phải không cấm xe cơ giới.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(346),
        difficulty: 2,
      ),

      Question(
        id: 347,
        title: 'Câu hỏi số 347',
        content: 'Biển phụ đặt dưới biển cấm bóp còi có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_347.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Báo khoảng cách đến nơi cấm bóp còi.',
        ansB: '2. Chiều dài đoạn đường cấm bóp còi từ nơi đặt biển.',
        ansC: '3. Báo cấm dùng còi có độ vang xa 500m.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(347),
        difficulty: 2,
      ),

      Question(
        id: 348,
        title: 'Câu hỏi số 348',
        content: 'Chiều dài đoạn đường 500 m từ nơi đặt biển này, người lái xe có được phép bấm còi không?',
        audio: 'assets/images/traffic_signs/sign_348.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Được phép.',
        ansB: '2. Không được phép.',
        ansC: null,
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(348),
        difficulty: 2,
      ),

      Question(
        id: 349,
        title: 'Câu hỏi số 349',
        content: 'Biển nào xe mô tô hai bánh được đi vào?',
        audio: 'assets/images/traffic_signs/sign_349.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1 và biển 2.',
        ansB: '2. Biển 1 và biển 3.',
        ansC: '3. Biển 2 và biển 3.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(349),
        difficulty: 2,
      ),

      Question(
        id: 350,
        title: 'Câu hỏi số 350',
        content: 'Biển nào xe mô tô hai bánh không được đi vào?',
        audio: 'assets/images/traffic_signs/sign_350.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Biển 3.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(350),
        difficulty: 2,
      ),

      Question(
        id: 351,
        title: 'Câu hỏi số 351',
        content: 'Ba biển này có hiệu lực như thế nào?',
        audio: 'assets/images/traffic_signs/sign_351.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Cấm các loại xe ở biển phụ đi vào.',
        ansB: '2. Cấm các loại xe cơ giới đi vào trừ loại xe ở biển phụ.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(351),
        difficulty: 2,
      ),

      Question(
        id: 352,
        title: 'Câu hỏi số 352',
        content: 'Biển nào báo hiệu chiều dài đoạn đường phải giữ cự ly tối thiểu giữa hai xe?',
        audio: 'assets/images/traffic_signs/sign_352.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Cả hai biển.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(352),
        difficulty: 2,
      ),

      Question(
        id: 353,
        title: 'Câu hỏi số 353',
        content: 'Biển nào báo hiệu khoảng cách thực tế từ nơi đặt biển đến nơi cần cự ly tối thiểu giữa hai xe?',
        audio: 'assets/images/traffic_signs/sign_353.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Cả hai biển.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(353),
        difficulty: 2,
      ),

      Question(
        id: 354,
        title: 'Câu hỏi số 354',
        content: 'Biển này có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_354.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Cấm dừng xe về hướng bên trái.',
        ansB: '2. Cấm dừng và đỗ xe theo hướng bên phải.',
        ansC: '3. Được phép đỗ xe và dừng xe theo hướng bên phải.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(354),
        difficulty: 2,
      ),

      Question(
        id: 355,
        title: 'Câu hỏi số 355',
        content: 'Theo hướng bên phải có được phép đỗ xe, dừng xe không?',
        audio: 'assets/images/traffic_signs/sign_355.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Không được phép.',
        ansB: '2. Được phép.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(355),
        difficulty: 2,
      ),

      Question(
        id: 356,
        title: 'Câu hỏi số 356',
        content: 'Gặp biển này, xe ô tô sơ mi rơ moóc có chiều dài toàn bộ kể cả xe, moóc và hàng lớn hơn trị số ghi trên biển có được phép đi vào hay không?',
        audio: 'assets/images/traffic_signs/sign_356.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Không được phép.',
        ansB: '2. Được phép.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(356),
        difficulty: 2,
      ),

      Question(
        id: 357,
        title: 'Câu hỏi số 357',
        content: 'Xe ô tô chở hàng vượt quá phía trước và sau thùng xe, mỗi phía quá 10% chiều dài toàn bộ thân xe, tổng chiều dài xe (cả hàng) từ trước đến sau nhỏ hơn trị số ghi trên biển thì có được phép đi vào không?',
        audio: 'assets/images/traffic_signs/sign_357.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Không được phép.',
        ansB: '2. Được phép.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(357),
        difficulty: 2,
      ),

      Question(
        id: 358,
        title: 'Câu hỏi số 358',
        content: 'Biển này có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_358.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Cấm ô tô buýt.',
        ansB: '2. Cấm xe ô tô khách.',
        ansC: '3. Cấm xe ô tô con.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(358),
        difficulty: 2,
      ),

      Question(
        id: 359,
        title: 'Câu hỏi số 359',
        content: 'Biển này có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_359.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Hạn chế chiều cao của xe và hàng.',
        ansB: '2. Hạn chế chiều ngang của xe và hàng.',
        ansC: '3. Hạn chế chiều dài của xe và hàng.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(359),
        difficulty: 2,
      ),

      Question(
        id: 360,
        title: 'Câu hỏi số 360',
        content: 'Biển nào là biển "Tốc độ tối đa cho phép về ban đêm"?',
        audio: 'assets/images/traffic_signs/sign_360.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Cả hai biển.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(360),
        difficulty: 2,
      ),

      Question(
        id: 361,
        title: 'Câu hỏi số 361',
        content: 'Biển báo nào báo hiệu bắt đầu đoạn đường vào phạm vi khu dân cư, các phương tiện tham gia giao thông phải tuân theo các quy định đi đường được áp dụng ở khu đông dân cư?',
        audio: 'assets/images/traffic_signs/sign_361.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(361),
        difficulty: 2,
      ),

      Question(
        id: 362,
        title: 'Câu hỏi số 362',
        content: 'Biển nào báo hiệu hạn chế tốc độ của phương tiện không vượt quá trị số ghi trên biển?',
        audio: 'assets/images/traffic_signs/sign_362.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: null,
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(362),
        difficulty: 2,
      ),

      Question(
        id: 363,
        title: 'Câu hỏi số 363',
        content: 'Trong các biển báo dưới đây biển nào báo hiệu "Kết thúc đường cao tốc"?',
        audio: 'assets/images/traffic_signs/sign_363.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Biển 3.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(363),
        difficulty: 2,
      ),

      Question(
        id: 364,
        title: 'Câu hỏi số 364',
        content: 'Số 50 ghi trên biển báo dưới đây có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_364.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Tốc độ tối đa các xe cơ giới được phép chạy.',
        ansB: '2. Tốc độ tối thiểu các xe cơ giới được phép chạy.',
        ansC: null,
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(364),
        difficulty: 2,
      ),

      Question(
        id: 365,
        title: 'Câu hỏi số 365',
        content: 'Biển nào dưới đây chỉ dẫn bắt đầu đường cao tốc phân làn đường có tốc độ khác nhau?',
        audio: 'assets/images/traffic_signs/sign_365.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Cả hai biển.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(365),
        difficulty: 2,
      ),

      Question(
        id: 366,
        title: 'Câu hỏi số 366',
        content: 'Biển báo dưới đây có ý nghĩa như thế nào?',
        audio: 'assets/images/traffic_signs/sign_366.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Báo hiệu tốc độ tối đa cho phép các xe cơ giới chạy.',
        ansB: '2. Báo hiệu tốc độ tối thiểu cho phép các xe cơ giới chạy.',
        ansC: null,
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(366),
        difficulty: 2,
      ),

      Question(
        id: 367,
        title: 'Câu hỏi số 367',
        content: 'Gặp biển nào người lái xe phải nhường đường cho người đi bộ?',
        audio: 'assets/images/traffic_signs/sign_367.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Biển 3.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(367),
        difficulty: 2,
      ),

      Question(
        id: 368,
        title: 'Câu hỏi số 368',
        content: 'Biển nào chỉ đường dành cho người đi bộ, các loại xe không được đi vào khi gặp biển này?',
        audio: 'assets/images/traffic_signs/sign_368.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 1 và biển 3.',
        ansC: '3. Biển 3.',
        ansD: '4. Cả ba biển.',
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(368),
        difficulty: 2,
      ),

      Question(
        id: 369,
        title: 'Câu hỏi số 369',
        content: 'Biển nào báo hiệu "Đường dành cho xe thô sơ"?',
        audio: 'assets/images/traffic_signs/sign_369.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Biển 3.',
        ansD: null,
        ansRight: 'C',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(369),
        difficulty: 2,
      ),

      Question(
        id: 370,
        title: 'Câu hỏi số 370',
        content: 'Biển nào báo hiệu sắp đến chỗ giao nhau nguy hiểm?',
        audio: 'assets/images/traffic_signs/sign_370.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 1 và biển 2.',
        ansC: '3. Biển 2 và biển 3.',
        ansD: '4. Cả ba biển.',
        ansRight: 'D',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(370),
        difficulty: 2,
      ),

      Question(
        id: 371,
        title: 'Câu hỏi số 371',
        content: 'Biển nào báo hiệu "Giao nhau với đường sắt có rào chắn"?',
        audio: 'assets/images/traffic_signs/sign_371.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2 và biển 3.',
        ansC: '3. Biển 3.',
        ansD: null,
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(371),
        difficulty: 2,
      ),

      Question(
        id: 372,
        title: 'Câu hỏi số 372',
        content: 'Biển nào báo hiệu "Giao nhau có tín hiệu đèn"?',
        audio: 'assets/images/traffic_signs/sign_372.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Biển 3.',
        ansD: '4. Cả ba biển.',
        ansRight: 'C',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(372),
        difficulty: 2,
      ),

      Question(
        id: 373,
        title: 'Câu hỏi số 373',
        content: 'Biển nào báo hiệu nguy hiểm giao nhau với đường sắt?',
        audio: 'assets/images/traffic_signs/sign_373.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1 và biển 2.',
        ansB: '2. Biển 1 và biển 3.',
        ansC: '3. Biển 2 và biển 3.',
        ansD: null,
        ansRight: 'B',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(373),
        difficulty: 2,
      ),

      Question(
        id: 374,
        title: 'Câu hỏi số 374',
        content: 'Biển nào báo hiệu đường bộ giao nhau với đường sắt không có rào chắn?',
        audio: 'assets/images/traffic_signs/sign_374.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1 và biển 2.',
        ansB: '2. Biển 1 và biển 3.',
        ansC: '3. Biển 2 và biển 3.',
        ansD: '4. Cả ba biển.',
        ansRight: 'C',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(374),
        difficulty: 2,
      ),

      Question(
        id: 375,
        title: 'Câu hỏi số 375',
        content: 'Biển nào báo hiệu sắp đến chỗ giao nhau giữa đường bộ và đường sắt?',
        audio: 'assets/images/traffic_signs/sign_375.png',
        mediaType: AppConstants.mediaTypeImage,
        ansA: '1. Biển 1.',
        ansB: '2. Biển 2.',
        ansC: '3. Biển 3.',
        ansD: '4. Biển 1 và biển 3.',
        ansRight: 'A',
        ansHint: null,
        topicId: 5,
        mandatory: mandatoryQuestionIds.contains(375),
        difficulty: 2,
      ),

    ];

    int addedCount = 0;
    for (final question in questions) {
      try {
        await _questionRepository.insertQuestion(question);
        addedCount++;

        if (addedCount % 5 == 0) {
          print('  ✓ Added $addedCount questions...');
        }
      } catch (e) {
        print('  ❌ Error adding question ${question.id}: $e');
      }
    }

    print('  ✅ Total questions added: $addedCount');

    // Print mandatory questions count
    final mandatoryCount = questions.where((q) => q.mandatory).length;
    print('  📍 Mandatory questions: $mandatoryCount');
  }

  Future<void> _updateTopicQuestionCounts() async {
    print('🔄 Updating topic question counts...');
    try {
      await _topicRepository.updateAllTopicQuestionCounts();
      print('  ✅ Topic question counts updated');
    } catch (e) {
      print('  ❌ Error updating topic question counts: $e');
    }
  }

  // Legacy methods for compatibility
  Future<void> seedDatabase() async {
    await addRealData();
  }

  Future<bool> isDatabaseEmpty() async {
    try {
      return await _databaseService.isDatabaseEmpty();
    } catch (e) {
      print('Error checking if database is empty: $e');
      return true;
    }
  }

  Future<void> seedIfEmpty() async {
    try {
      final isEmpty = await isDatabaseEmpty();
      if (isEmpty) {
        print('Database is empty, adding real data...');
        await addRealData();
      } else {
        print('Database already contains data, skipping seeding');
      }
    } catch (e) {
      print('Error in seedIfEmpty: $e');
      rethrow;
    }
  }

  Future<void> clearAllData() async {
    try {
      print('Clearing all data from database...');
      await _databaseService.clearAllData();
      print('All data cleared successfully');
    } catch (e) {
      print('Error clearing data: $e');
      rethrow;
    }
  }

  Future<Map<String, int>> getDatabaseStats() async {
    try {
      final topics = await _topicRepository.getAllTopics();
      final questions = await _questionRepository.getAllQuestions();
      final mandatoryQuestions = await _questionRepository.getMandatoryQuestions();

      return {
        'topics_count': topics.length,
        'questions_count': questions.length,
        'mandatory_questions_count': mandatoryQuestions.length,
        'questions_with_media_count': questions.where((q) => q.hasMedia).length,
      };
    } catch (e) {
      print('Error getting database stats: $e');
      return {
        'topics_count': 0,
        'questions_count': 0,
        'mandatory_questions_count': 0,
        'questions_with_media_count': 0,
      };
    }
  }
}