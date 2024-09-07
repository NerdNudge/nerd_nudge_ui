import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';

class UserFeedbackEntity {
  final String _id = UserProfileEntity().getUserEmail();
  late String _feedbackType;
  late String _feedback;



  String get feedbackType => _feedbackType;

  set feedbackType(String value) {
    _feedbackType = value;
  }

  String get feedback => _feedback;

  set feedback(String value) {
    _feedback = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _id,
      'feedbackType': _feedbackType,
      'feedback': _feedback
    };
  }

  @override
  String toString() {
    return '''
UserFeedbackEntity {
  userId: $_id,
  feedbackType: $_feedbackType,
      feedback: $_feedback
}
    ''';
  }
}
