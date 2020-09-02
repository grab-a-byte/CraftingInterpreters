import 'dart:math';

import 'package:Dart/expressions/binary.dart';
import 'package:Dart/expressions/expression.dart';
import 'package:Dart/expressions/grouping.dart';
import 'package:Dart/expressions/literal.dart';
import 'package:Dart/expressions/unary.dart';
import 'package:Dart/expressions/variable.dart';
import 'package:Dart/lox.dart';
import 'package:Dart/statements/print_statement.dart';
import 'package:Dart/statements/stmt.dart';
import 'package:Dart/statements/expresion_statement.dart';
import 'package:Dart/statements/variable_statement.dart';
import 'package:Dart/token.dart';

class Parser {
  final List<Token> _tokens;
  int current = 0;

  Parser(this._tokens);

  List<Stmt> parse() {
    try {
      List<Stmt> statements = [];
      while (!isAtEnd()) {
        statements.add(_declaration());
      }
      return statements;
    } on Exception {
      return null;
    }
  }

  Stmt _declaration() {
    try {
      if (_match([TokenType.VAR])) {
        return _varDeclaration();
      } else {
        return _statement();
      }
    } on Exception {
      _synchronize();
      return null;
    }
  }

  Stmt _varDeclaration() {
    Token name = consume(TokenType.IDENTIFIER, "Expect variable name.");
    // ignore: avoid_init_to_null
    Expr initializer = null;
    if (_match([TokenType.EQUAL])) {
      initializer = _expression();
    }
    consume(TokenType.SEMICOLON, "Expect ';' after variable declaration");
    return VariableStatement(name, initializer);
  }

  Stmt _statement() {
    if (_match([TokenType.PRINT])) {
      return printStatement();
    } else {
      return expressionStatement();
    }
  }

  Stmt printStatement() {
    Expr value = _expression();
    consume(TokenType.SEMICOLON, "Expect ';' after value");
    return PrintStatement(value);
  }

  Stmt expressionStatement() {
    Expr value = _expression();
    consume(TokenType.SEMICOLON, "Expect ';' after value");
    return ExpressionStatement(value);
  }

  Expr _expression() {
    return _equality();
  }

  Expr _equality() {
    Expr expr = _comparrison();
    while (_match([TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL])) {
      Token operator = _previous();
      Expr right = _comparrison();
      expr = Binary(expr, operator, right);
    }
    return expr;
  }

  Expr _comparrison() {
    Expr expr = addition();
    while (_match([
      TokenType.GREATER,
      TokenType.GREATER_EQUAL,
      TokenType.LESS,
      TokenType.LESS_EQUAL
    ])) {
      Token operator = _previous();
      Expr right = addition();
      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expr addition() {
    Expr expr = multiplication();
    while (_match([TokenType.MINUS, TokenType.PLUS])) {
      Token operator = _previous();
      Expr right = multiplication();
      expr = Binary(expr, operator, right);
    }
    return expr;
  }

  Expr multiplication() {
    Expr expr = unary();
    while (_match([TokenType.SLASH, TokenType.STAR])) {
      Token operator = _previous();
      Expr right = unary();
      expr = Binary(expr, operator, right);
    }
    return expr;
  }

  Expr unary() {
    if (_match([TokenType.BANG, TokenType.MINUS])) {
      Token operator = _previous();
      Expr right = unary();
      return Unary(operator, right);
    }
    return primary();
  }

  Expr primary() {
    if (_match([TokenType.FALSE])) return Literal(false);
    if (_match([TokenType.TRUE])) return Literal(true);
    if (_match([TokenType.NIL])) return Literal(null);

    if (_match([TokenType.NUMBER, TokenType.STRING])) {
      return Literal(_previous().literal);
    }

    if (_match([TokenType.IDENTIFIER])) {
      return Variable(_previous());
    }

    if (_match([TokenType.LEFT_PAREN])) {
      Expr expr = _expression();
      consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.");
      return Grouping(expr);
    }

    throw error(peek(), "Expect expression.");
  }

  Token consume(TokenType type, String message) {
    if (_check(type)) return _advance();
    throw error(peek(), message);
  }

  Exception error(Token token, String message) {
    Lox.errorWithToken(token, message);
    return Exception();
  }

  Token _previous() => _tokens[current - 1];

  bool _match(List<TokenType> tokens) {
    for (TokenType type in tokens) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }
    return false;
  }

  bool _check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  Token _advance() {
    if (!isAtEnd()) current++;
    return _previous();
  }

  bool isAtEnd() => peek().type == TokenType.EOF;

  Token peek() => _tokens[current];

  void _synchronize() {
    _advance();
    while (!isAtEnd()) {
      switch (peek().type) {
        case TokenType.CLASS:
        case TokenType.FUN:
        case TokenType.VAR:
        case TokenType.FOR:
        case TokenType.IF:
        case TokenType.WHILE:
        case TokenType.PRINT:
        case TokenType.RETURN:
          return;
      }

      _advance();
    }
  }
}
