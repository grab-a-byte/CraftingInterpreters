import 'package:Dart/expressions/binary.dart';
import 'package:Dart/expressions/expression.dart';
import 'package:Dart/expressions/grouping.dart';
import 'package:Dart/expressions/literal.dart';
import 'package:Dart/expressions/unary.dart';
import 'package:Dart/lox.dart';
import 'package:Dart/token.dart';

class Parser {
  final List<Token> _tokens;
  int current = 0;

  Parser(this._tokens);

  Expression parse() {
    try {
      return _expression();
    } on Exception {
      return null;
    }
  }

  Expression _expression() {
    return _equality();
  }

  Expression _equality() {
    Expression expr = _comparrison();
    while (_match([TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL])) {
      Token operator = _previous();
      Expression right = _comparrison();
      expr = Binary(expr, operator, right);
    }
    return expr;
  }

  Expression _comparrison() {
    Expression expr = addition();
    while (_match([
      TokenType.GREATER,
      TokenType.GREATER_EQUAL,
      TokenType.LESS,
      TokenType.LESS_EQUAL
    ])) {
      Token operator = _previous();
      Expression right = addition();
      expr = Binary(expr, operator, right);
    }

    return expr;
  }

  Expression addition() {
    Expression expr = multiplication();
    while (_match([TokenType.MINUS, TokenType.PLUS])) {
      Token operator = _previous();
      Expression right = multiplication();
      expr = Binary(expr, operator, right);
    }
    return expr;
  }

  Expression multiplication() {
    Expression expr = unary();
    while (_match([TokenType.SLASH, TokenType.STAR])) {
      Token operator = _previous();
      Expression right = unary();
      expr = Binary(expr, operator, right);
    }
    return expr;
  }

  Expression unary() {
    if (_match([TokenType.BANG, TokenType.MINUS])) {
      Token operator = _previous();
      Expression right = unary();
      return Unary(operator, right);
    }
    return primary();
  }

  Expression primary() {
    if (_match([TokenType.FALSE])) return Literal(false);
    if (_match([TokenType.TRUE])) return Literal(true);
    if (_match([TokenType.NIL])) return Literal(null);

    if (_match([TokenType.NUMBER, TokenType.STRING])) {
      return Literal(_previous().literal);
    }

    if (_match([TokenType.LEFT_PAREN])) {
      Expression expr = _expression();
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
    tokens.forEach((element) {
      if (_check(element)) {
        _advance();
        return true;
      }
    });
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
