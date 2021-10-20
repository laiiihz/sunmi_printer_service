import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sunmi_printer_service/enums/barcode_enum.dart';
import 'package:sunmi_printer_service/enums/qrcode_enum.dart';
import 'package:sunmi_printer_service/exceptions/not_implement_exception.dart';

export 'enums/barcode_enum.dart';
export 'enums/qrcode_enum.dart';

enum Align {
  left,
  center,
  right,
}

class SunmiPrinterService {
  static const MethodChannel _channel =
      const MethodChannel('sunmi_printer_service');

  ///初始化
  static Future<bool> init() async {
    final initStatus = await _channel.invokeMethod<bool?>('init');
    return initStatus ?? false;
  }

  ///断开设备连接
  static Future<bool> unbind() async {
    final unbindStatus = await _channel.invokeMethod<bool?>('unbind');
    return unbindStatus ?? false;
  }
}

///打印机打印
class SPrinter {
  static const MethodChannel _channel =
      const MethodChannel('sunmi_printer_service');

  /// ESC/POS指令
  static rawData() async {
    //TODO not implement
    throw NotImplementException('rawData');
  }

  ///打印文本
  static text(String text) async {
    await _channel.invokeMethod('text', {'text': text});
  }

  ///设置文本对齐
  static setAlign(Align align) async {
    late int alignValue;
    switch (align) {
      case Align.left:
        alignValue = 0;
        break;
      case Align.center:
        alignValue = 1;
        break;
      case Align.right:
        alignValue = 2;
        break;
    }
    await _channel.invokeMethod('setAlign', {'align': alignValue});
  }

  ///设置文本大小
  static setFontSize(double size) async {
    await _channel.invokeMethod('setFontSize', {'size': size});
  }

  ///打印文本（包含字体大小）
  static textWithFont(String text, {String? typeface, double? fontsize}) async {
    await _channel.invokeMethod('textWithFont', {
      'text': text,
      'typeface': typeface,
      'size': fontsize,
    });
  }

  ///以矢量字体的方式打印文本
  static originText(String text) async {
    await _channel.invokeMethod('originText', {'text': text});
  }

  ///打印表格的⼀⾏(不⽀持阿拉伯字符)
  static columnsText(
    List<String> text, {
    List<int>? width,
    List<int>? align,
  }) async {
    await _channel.invokeMethod('printColumnsText', {
      'text': text,
      'width': width,
      'align': align,
    });
  }

  ///打印表格的⼀⾏，可以指定列宽、对⻬⽅式
  static columnsString(
    List<String> text, {
    List<int>? width,
    List<int>? align,
  }) async {
    await _channel.invokeMethod('printColumnsString', {
      'text': text,
      'width': width,
      'align': align,
    });
  }

  ///打印机⾛纸n⾏
  static lineWrap([int line = 1]) async {
    await _channel.invokeMethod('lineWrap', {'line': line});
  }

  ///打印一维码
  static barcode(
    String code,
    BarCodeType type, {
    int height = 162,
    int width = 2,
    BarCodeTextType textType = BarCodeTextType.none,
  }) async {
    await _channel.invokeMethod('printBarCode', {
      'code': code,
      'height': height,
      'width': width,
      'symbology': type.value,
      'textPosition': textType.value,
    });
  }

  ///打印二维码
  static qrCode(
    String code, {
    int moduleSize = 4,
    QRErrorLevel errorLevel = QRErrorLevel.medium,
  }) async {
    await _channel.invokeMethod('printQRCode', {
      'code': code,
      'moduleSize': moduleSize,
      'errorLevel': errorLevel.value,
    });
  }

  /// 切纸
  /// 仅支持台式机带切刀的机器
  static cutPaper() async {
    await _channel.invokeMethod('cutPaper');
  }

  /// 切纸次数
  static Future<int?> cutPaperTimes() async {
    var result = await _channel.invokeMethod('cutPaperTimes');
    if (result == null) return null;
    if (result is int) return result;
  }
}
