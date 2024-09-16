import 'package:nerd_nudge/utilities/constants.dart';


class UserProfileEntity {
  String _userFullName = '';
  String _userEmail = '';
  String _accountType = Constants.FREEMIUM;

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

  setUserAccountType(String accountType) {
    _accountType = accountType;
  }

  getUserAccountType() {
    return _accountType;
  }
}