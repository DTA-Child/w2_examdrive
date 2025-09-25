class AuthConstants {
// Authentication status
  static const String authStatusKey = 'auth_status';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String tokenKey = 'auth_token';
  static const String rememberMeKey = 'remember_me';
  static const String lastLoginKey = 'last_login';

// Validation constants
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 255;
  static const int maxFullnameLength = 100;
  static const int maxEmailLength = 100;
  static const int maxPhoneLength = 15;

// User status
  static const int userStatusInactive = 0;
  static const int userStatusActive = 1;
  static const int userStatusBlocked = 2;

// Gender constants
  static const String genderMale = 'M';
  static const String genderFemale = 'F';

// Session timeout (in minutes)
  static const int sessionTimeoutMinutes = 60;
  static const int rememberMeTimeoutDays = 30;

// Error messages
  static const String errorInvalidCredentials =
      'Tên đăng nhập hoặc mật khẩu không đúng';
  static const String errorUserNotFound = 'Không tìm thấy tài khoản';
  static const String errorUserBlocked = 'Tài khoản đã bị khóa';
  static const String errorUserInactive = 'Tài khoản chưa được kích hoạt';
  static const String errorUsernameExists = 'Tên đăng nhập đã tồn tại';
  static const String errorEmailExists = 'Email đã được sử dụng';
  static const String errorPhoneExists = 'Số điện thoại đã được sử dụng';
  static const String errorWeakPassword = 'Mật khẩu quá yếu';
  static const String errorPasswordMismatch = 'Mật khẩu xác nhận không khớp';
  static const String errorInvalidEmail = 'Email không hợp lệ';
  static const String errorInvalidPhone = 'Số điện thoại không hợp lệ';
  static const String errorNetworkError = 'Lỗi kết nối mạng';
  static const String errorDatabaseError = 'Lỗi cơ sở dữ liệu';
  static const String errorUnknown = 'Có lỗi không xác định xảy ra';

// Success messages
  static const String successLogin = 'Đăng nhập thành công';
  static const String successRegister = 'Đăng ký tài khoản thành công';
  static const String successLogout = 'Đăng xuất thành công';
  static const String successPasswordChanged = 'Đổi mật khẩu thành công';
  static const String successProfileUpdated = 'Cập nhật thông tin thành công';

// Input labels and hints
  static const String labelUsername = 'Tên đăng nhập';
  static const String labelPassword = 'Mật khẩu';
  static const String labelConfirmPassword = 'Xác nhận mật khẩu';
  static const String labelFullname = 'Họ và tên';
  static const String labelEmail = 'Email';
  static const String labelPhone = 'Số điện thoại';
  static const String labelGender = 'Giới tính';
  static const String labelBirthday = 'Ngày sinh';

  static const String hintUsername = 'Nhập tên đăng nhập';
  static const String hintPassword = 'Nhập mật khẩu';
  static const String hintConfirmPassword = 'Nhập lại mật khẩu';
  static const String hintFullname = 'Nhập họ và tên';
  static const String hintEmail = 'Nhập địa chỉ email';
  static const String hintPhone = 'Nhập số điện thoại';

// Button labels
  static const String buttonLogin = 'Đăng nhập';
  static const String buttonRegister = 'Đăng ký';
  static const String buttonLogout = 'Đăng xuất';
  static const String buttonForgotPassword = 'Quên mật khẩu?';
  static const String buttonChangePassword = 'Đổi mật khẩu';
  static const String buttonUpdateProfile = 'Cập nhật thông tin';
  static const String buttonCancel = 'Hủy';
  static const String buttonSave = 'Lưu';
  static const String buttonBack = 'Quay lại';

// Navigation labels
  static const String navLogin = 'Đăng nhập';
  static const String navRegister = 'Đăng ký tài khoản';
  static const String navProfile = 'Thông tin cá nhân';
  static const String navSettings = 'Cài đặt';

// Form validation messages
  static const String validationRequired = 'Trường này không được để trống';
  static const String validationUsernameLength =
      'Tên đăng nhập phải từ $minUsernameLength-$maxUsernameLength ký tự';
  static const String validationPasswordLength =
      'Mật khẩu phải từ $minPasswordLength-$maxPasswordLength ký tự';
  static const String validationEmailFormat = 'Định dạng email không hợp lệ';
  static const String validationPhoneFormat =
      'Định dạng số điện thoại không hợp lệ';
  static const String validationUsernameFormat =
      'Tên đăng nhập chỉ chứa chữ cái, số và dấu gạch dưới';

// Regex patterns
  static const String usernamePattern = r'^[a-zA-Z0-9_]+$';
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9+\-\s()]+$';

// Database table and column names
  static const String tableUsers = 'users';
  static const String columnId = 'id';
  static const String columnUsername = 'username';
  static const String columnPassword = 'password';
  static const String columnFullname = 'fullname';
  static const String columnEmail = 'email';
  static const String columnPhone = 'phone';
  static const String columnGender = 'gender';
  static const String columnBirthday = 'birthday';
  static const String columnStatus = 'status';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

// SharedPreferences keys
  static const String prefKeyIsLoggedIn = 'is_logged_in';
  static const String prefKeyCurrentUser = 'current_user';
  static const String prefKeyLoginTime = 'login_time';
  static const String prefKeyAutoLogin = 'auto_login';

// Default values
  static const String defaultGender = genderMale;
  static const int defaultUserStatus = userStatusActive;

// Screen titles
  static const String titleLogin = 'Đăng nhập';
  static const String titleRegister = 'Đăng ký tài khoản';
  static const String titleProfile = 'Thông tin cá nhân';
  static const String titleChangePassword = 'Đổi mật khẩu';
  static const String titleForgotPassword = 'Quên mật khẩu';

// Loading messages
  static const String loadingLogin = 'Đang đăng nhập...';
  static const String loadingRegister = 'Đang tạo tài khoản...';
  static const String loadingUpdateProfile = 'Đang cập nhật thông tin...';
  static const String loadingChangePassword = 'Đang đổi mật khẩu...';

// Dialog messages
  static const String dialogConfirmLogout = 'Bạn có chắc chắn muốn đăng xuất?';
  static const String dialogConfirmDeleteAccount =
      'Bạn có chắc chắn muốn xóa tài khoản?';

// Gender options
  static const Map<String, String> genderOptions = {
    genderMale: 'Nam',
    genderFemale: 'Nữ',
  };

// Status options
  static const Map<int, String> statusOptions = {
    userStatusInactive: 'Chưa kích hoạt',
    userStatusActive: 'Hoạt động',
    userStatusBlocked: 'Bị khóa',
  };
}
