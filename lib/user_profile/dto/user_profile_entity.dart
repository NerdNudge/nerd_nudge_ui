class UserProfileEntity {
  String _userFullName = '';
  String _userEmail = '';

  UserProfileEntity._privateConstructor();
  static final UserProfileEntity _instance = UserProfileEntity._privateConstructor();

  factory UserProfileEntity() {
    return _instance;
  }

  getUserFullName() {
    return _userFullName;
  }

  getUserEmail() {
    return _userEmail;
  }

  setUserFullName(String userFullName) {
    _userFullName = userFullName;
  }

  setUserEmail(String userEmail) {
    _userEmail = userEmail;
  }
}