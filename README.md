#  Ứng Dụng Thi Thử Lái Xe

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)](https://sqlite.org/)

**Tác giả:** DTA  
**Repository:** https://github.com/DTA-Child/w2_examdrive

Ứng dụng thi thử lái xe được phát triển bằng Flutter, cung cấp trải nghiệm luyện tập và thi thử các câu hỏi lý thuyết lái xe một cách tiện lợi và hiệu quả trên thiết bị di động. Ứng dụng được thiết kế với giao diện mượt mà, kiến trúc rõ ràng theo Repository Pattern và hệ thống lưu trữ dữ liệu cục bộ bằng SQLite.

##  Tính Năng Chính

Ứng dụng bao gồm 4 tính năng cốt lõi được thiết kế để hỗ trợ tối đa quá trình ôn luyện:

** Trang chủ (Home):** Giao diện chính khi khởi động ứng dụng, cung cấp cái nhìn tổng quan và điều hướng đến các tính năng khác một cách trực quan.

** Thi & Luyện tập (Test):** Tính năng chính của ứng dụng với các chức năng:
- Làm bài thi thử với đồng hồ đếm ngược mô phỏng kỳ thi thật
- Xem danh sách câu hỏi và theo dõi trạng thái trả lời
- Hiển thị câu liệt trong chế độ luyện tập
- Xem kết quả ngay lập tức sau khi hoàn thành
- Chi tiết kết quả từng câu hỏi với đáp án đúng/sai

** Cài đặt (Settings):** Quản lý các thiết lập ứng dụng, bao gồm tính năng xóa dữ liệu để khởi tạo lại hệ thống khi cần thiết.

** Lịch sử (History):** Theo dõi và quản lý kết quả các lần thi với khả năng:
- Xem lịch sử tất cả các bài thi đã làm
- Tìm kiếm và lọc kết quả theo thời gian
- Thống kê điểm số và phân tích tiến bộ học tập

##  Công Nghệ & Kiến Trúc

**Công nghệ sử dụng:**
- **Flutter & Dart:** Framework phát triển ứng dụng đa nền tảng
- **SQLite:** Cơ sở dữ liệu cục bộ cho việc lưu trữ dữ liệu
- **Repository Pattern:** Kiến trúc tách biệt lớp dữ liệu và business logic

**Đặc điểm kiến trúc:**
- Animation mượt mà giữa các màn hình
- Cấu trúc dự án theo Repository Pattern, dễ bảo trì và mở rộng
- Tách biệt rõ ràng giữa UI, business logic và data layer


##  Cơ Sở Dữ Liệu

**Thiết kế Database:**

Dự án ban đầu được thiết kế để sử dụng PostgreSQL với cấu trúc bao gồm:
- **Bảng users:** Quản lý thông tin người dùng
- **Bảng result:** Lưu trữ kết quả các lần thi
- **Bảng result_detail:** Chi tiết kết quả từng câu hỏi
- **Các index:** Được tối ưu để hỗ trợ truy vấn nhanh

##  Tình Trạng Hiện Tại

**Đã hoàn thành:**
- Xây dựng hoàn chỉnh 4 tính năng chính của ứng dụng thi thử lái xe
- Thiết kế và triển khai các animation mượt mà cho trải nghiệm người dùng
- Cấu trúc dự án theo Repository Pattern đảm bảo tính bảo trì cao
- Giao diện thi thử với đầy đủ các tính năng cần thiết
- Hệ thống lưu trữ và hiển thị lịch sử kết quả

**Hạn chế cần cải thiện:**
- Hệ thống đăng nhập/đăng ký chưa hoàn chỉnh do sử dụng SQLite cục bộ, việc xác thực người dùng chưa đảm bảo tính bảo mật
- Dữ liệu câu hỏi hiện tại chưa đạt đủ 600 câu theo tiêu chuẩn
- Một số câu hỏi có hình ảnh kích thước lớn và nhiều đáp án chưa hiển thị tối ưu

##  Cài Đặt & Chạy Ứng Dụng

**Yêu cầu hệ thống:**
- Flutter SDK 3.x (khuyến nghị phiên bản stable mới nhất)
- Dart SDK tương ứng
- Android Studio hoặc VS Code với Flutter extension
- Thiết bị Android/iOS hoặc emulator

**Hướng dẫn cài đặt:**

1. **Clone repository:**
```bash
git clone https://github.com/DTA-Child/w2_examdrive.git
cd w2_examdrive
```
Cài đặt dependencies:
```
flutter pub get
```
Chạy ứng dụng:
```
flutter run
```
2. **Build cho production:**

Android APK:
```
flutter build apk --release
```
iOS:
```
flutter build ios --release
```
