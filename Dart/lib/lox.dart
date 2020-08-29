import 'dart:io';

import 'package:Dart/errors.dart';
import 'package:Dart/interpreter.dart';
import 'package:Dart/parser.dart';
import 'package:Dart/scanner.dart';
import 'package:Dart/statements/stmt.dart';
import 'package:Dart/token.dart';

class Lox {
  static bool _hadError = false;
  static bool _hadRuntimeError = false;

  static void _report(int line, String where, String message) {
    print("[line $line] Error $where: $message");
    _hadError = true;
  }

  static void error(int line, String message) {
    if (_hadError) exit(65);
    _report(line, "", message);
  }

  static void errorWithToken(Token token, String message) {
    if (token.type == TokenType.EOF) {
      _report(token.line, " at end", message);
    } else {
      _report(token.line, " at '${token.lexeme}'", message);
    }
  }

  static void runtimeError(RuntimeError error) {
    print("${error.toString()}\n[line ${error.token.line}]");
    _hadRuntimeError = true;
  }

  static final Interpreter _interpreter = Interpreter();

  void _run(String fileText) {
    Scanner scanner = Scanner(fileText);
    List<Token> tokens = scanner.scanTokens();

    Parser parser = Parser(tokens);
    List<Stmt> statements = parser.parse();

    if (_hadError || _hadRuntimeError) {
      print("error");
      return;
    } else {
      _interpreter.interpret(statements);
      //print(AstPrinter().printAsString(expression));
      print("program run");
    }
  }

  void runFile(String filePath) async {
    File file = File(filePath);
    String fileText = await file.readAsString();
    _run(fileText);
    if (_hadError) exit(65);
    if (_hadRuntimeError) exit(70);
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
