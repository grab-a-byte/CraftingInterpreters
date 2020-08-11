import 'dart:io';

import 'package:Dart/scanner.dart';
import 'package:Dart/token.dart';

class Lox {
  static bool _hadError = false;

  static void _report(int line, String where, String message) {
    stdout.addError("[line ${line}] Error ${where}: ${message}");
    _hadError = true;
  }

  static void error(int line, String message) {
    if (_hadError) exit(65);
    _report(line, "", message);
  }

  void _run(String fileText) {
    Scanner scanner = new Scanner(fileText);
    List<Token> tokens = scanner.scanTokens();

    tokens.forEach((element) => print(element));
  }

  void runFile(String filePath) async {
    File file = File(filePath);
    String fileText = await file.readAsString();
    _run(fileText);
  }

  void runPrompt() {
    while (true) {
      print("> ");
      String line = stdin.readLineSync();
      if (line == null) break;
      _run(line);
      _hadError = false;
    }
  }
}
