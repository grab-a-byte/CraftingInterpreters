import 'dart:io';

import 'package:Dart/lox.dart';
import 'package:Dart/token.dart';
import 'package:Dart/utilities.dart';

class Scanner {
  final String _sourceCode;
  final List<Token> _tokens = <Token>[];
  int _start = 0;
  int _current = 0;
  int _line = 1;

  Scanner(this._sourceCode);

  bool isAtEnd() => _current >= _sourceCode.length;

  String advance() {
    _current++;
    return _sourceCode.substring(_current - 1, _current);
  }

  String _peek() {
    if (isAtEnd()) return '\0';
    return _sourceCode.substring(_current, _current + 1);
  }

  String _peekNext() {
    if (_current + 1 > _sourceCode.length) return '\0';
    return _sourceCode.substring(_current + 1, _current + 2);
  }

  void addToken(TokenType type, Object literal) {
    String text = _sourceCode.substring(_start, _current);
    _tokens.add(new Token(type, text, literal, _line));
  }

  void addNullToken(TokenType type) {
    addToken(type, null);
  }

  bool _match(String expected) {
    if (isAtEnd()) return false;
    if (_sourceCode.substring(_current) != expected) return false;

    _current++;
    return true;
  }

  void string() {
    while (_peek() != '"' && !isAtEnd()) {
      if (_peek() == '\n') _line++;
      advance();
    }
    if (isAtEnd()) {
      Lox.error(_line, "Unterminated string");
      return;
    }
    advance();

    String value = _sourceCode.substring(_start + 1, _current - 1);
    addToken(TokenType.STRING, value);
  }

  void number() {
    while (isDigit(_peek())) {
      advance();
    }
    if (_peek() == '.' && isDigit(_peekNext())) {
      advance();
      while (isDigit(_peek())) {
        advance();
      }
    }
    addToken(TokenType.NUMBER,
        double.parse(_sourceCode.substring(_start, _current)));
  }

  void scanToken() {
    var c = advance();
    switch (c) {
      case '(':
        addNullToken(TokenType.LEFT_PAREN);
        break;
      case ')':
        addNullToken(TokenType.RIGHT_PAREN);
        break;
      case '{':
        addNullToken(TokenType.LEFT_BRACE);
        break;
      case '}':
        addNullToken(TokenType.RIGHT_BRACE);
        break;
      case ',':
        addNullToken(TokenType.COMMA);
        break;
      case '.':
        addNullToken(TokenType.DOT);
        break;
      case '-':
        addNullToken(TokenType.MINUS);
        break;
      case '+':
        addNullToken(TokenType.PLUS);
        break;
      case ';':
        addNullToken(TokenType.SEMICOLON);
        break;
      case '*':
        addNullToken(TokenType.STAR);
        break;
      case '!':
        addNullToken(_match("=") ? TokenType.BANG_EQUAL : TokenType.BANG);
        break;
      case '=':
        addNullToken(_match("=") ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        break;
      case '<':
        addNullToken(_match("=") ? TokenType.LESS_EQUAL : TokenType.LESS);
        break;
      case '>':
        addNullToken(_match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        break;
      case '/':
        if (_match('/')) {
          while (_peek() != '\n' && !isAtEnd()) advance();
        } else {
          addNullToken(TokenType.SLASH);
        }
        break;
      case " ":
      case '\r':
      case '\t':
        break;
      case "\n":
        _line++;
        break;
      case '"':
        string();
        break;
      default:
        if (isDigit(c)) {
          number();
        }
        Lox.error(_line, "Unexpected character");
    }
  }

  List<Token> scanTokens() {
    while (!isAtEnd()) {
      _start = _current;
      advance();
      number();
      //scanToken();
    }
    return _tokens;
  }
}
