import 'package:flutter/material.dart';
import 'package:sunmi_printer_service/sunmi_printer_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () async {
                  bool result = await SunmiPrinterService.init();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result ? '连接成功' : '连接失败'),
                    ),
                  );
                },
                icon: Text('连接'),
              );
            }),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () async {
                  bool result = await SunmiPrinterService.unbind();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result ? '断开连接成功' : '断开连接失败'),
                    ),
                  );
                },
                icon: Text('断开'),
              );
            }),
          ],
        ),
        body: ListView(
          children: [
            TextButton(
              onPressed: () async {
                await SPrinter.text("test: [SPrinter.text]");
                await SPrinter.lineWrap();
              },
              child: Text('Text'),
            ),
            TextButton(
              onPressed: () async {
                await SPrinter.columnsText(
                  ["item1", "item2"],
                  width: [5, 5],
                  align: [0, 0],
                );
                await SPrinter.lineWrap();
              },
              child: Text('column'),
            ),
            TextButton(
              onPressed: () async {
                await SPrinter.text("origin text");
                await SPrinter.lineWrap();
              },
              child: Text('origin Text'),
            ),
          ],
        ),
      ),
    );
  }
}
