///纠错级别
enum QRErrorLevel {
  ///纠错级别 L ( 7%)
  low,

  ///纠错级别 M (15%)
  medium,

  ///纠错级别 Q (25%)
  qulity,

  ///纠错级别 H (30%)
  high,
}

extension QRErrorLevelExt on QRErrorLevel {
  int get value {
    switch (this) {
      case QRErrorLevel.low:
        return 0;
      case QRErrorLevel.medium:
        return 1;
      case QRErrorLevel.qulity:
        return 2;
      case QRErrorLevel.high:
        return 3;
    }
  }
}
