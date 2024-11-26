import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class NerdLogger {
  static var logger = Logger(
    level: kReleaseMode ? Level.warning : Level.debug,
  );
}