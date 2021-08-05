///一维码类型
enum BarCodeType {
  ///要求12位数字（最后⼀位校验位）
  UPC_A,

  ///要求8位数字（最后⼀位校验位）
  UPC_E,

  ///JAN13_EAN13
  JAN13_EAN13,

  ///JAN8_EAN8
  JAN8_EAN8,

  ///最⻓打印13个数字
  CODE39,

  ///要求输⼊数字，且有效⼩于14位，必须是偶数位
  ITF,

  ///要求0-9及6个特殊字符，最⻓打印18个数字
  CODABAR,

  ///最⻓打印17个数字
  CODE93,

  ///Code128分三类：
  ///* A类：包含⼤写字⺟、数字、标点等；
  ///* B类：⼤⼩写字⺟，数字；
  ///* C类：纯数字，复数字符，若为单数位，最后⼀个将忽略；
  ///
  ///接⼝默认使⽤B类编码，若要使⽤A类、C类编码需在内容前⾯加“{A”、“{C”，例
  ///如：“{A2344A”，”{C123123”，”{A1A{B13B{C12”。
  CODE128,
}

///一维码文字类型
enum BarCodeTextType {
  ///不打印⽂字
  none,

  ///⽂字在条码上⽅
  up,

  ///⽂字在条码下⽅
  down,

  ///条码上下⽅均打印
  upAndDown,
}

extension BarCodeTypeExt on BarCodeType {
  int get value {
    switch (this) {
      case BarCodeType.UPC_A:
        return 0;
      case BarCodeType.UPC_E:
        return 1;
      case BarCodeType.JAN13_EAN13:
        return 2;
      case BarCodeType.JAN8_EAN8:
        return 3;
      case BarCodeType.CODE39:
        return 4;
      case BarCodeType.ITF:
        return 5;
      case BarCodeType.CODABAR:
        return 6;
      case BarCodeType.CODE93:
        return 7;
      case BarCodeType.CODE128:
        return 8;
    }
  }
}

extension BarCodeTextTypeExt on BarCodeTextType {
  int get value {
    switch (this) {
      case BarCodeTextType.none:
        return 0;
      case BarCodeTextType.up:
        return 1;
      case BarCodeTextType.down:
        return 2;
      case BarCodeTextType.upAndDown:
        return 3;
    }
  }
}
