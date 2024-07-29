class InsightsDurationState {
  static bool _last30DaysFlag = false;

  static bool get last30DaysFlag => _last30DaysFlag;

  static void setLast30DaysFlag(bool value) {
    _last30DaysFlag = value;
  }
}