import 'package:Dart/lox.dart';
import 'package:Dart/token.dart';
import 'package:string_validator/string_validator.dart';

class Scanner {
  final String _sourceCode;
  final List<Token> _tokens = <Token>[];
  int _start = 0;
  int _current = 0;
  int _line = 1;

  final Map<String, TokenType> _keywords = {
    'and': TokenType.AND,
    'class': TokenType.CLASS,
    'else': TokenType.ELSE,
    'false': TokenType.FALSE,
    'for': TokenType.FOR,
    'fun': TokenType.FUN,
    'if': TokenType.IF,
    'nil': TokenType.NIL,
    'or': TokenType.OR,
    'print': TokenType.PRINT,
    'return': TokenType.RETURN,
    'super': TokenType.SUPER,
    'this': TokenType.THIS,
    'true': TokenType.TRUE,
    'var': TokenType.VAR,
    'while': TokenType.WHILE
  };

  Scanner(this._sourceCode);

  bool isAtEnd() {
    return _current >= _sourceCode.length;
  }

  String _advance() {
    _current++;
    return _sourceCode.substring(_current - 1, _current);
  }

  String _peek() {
    if (isAtEnd()) return '\\0';
    return _sourceCode.substring(_current, _current + 1);
  }

  String _peekNext() {
    if (_current + 1 > _sourceCode.length) return '\\0';
    return _sourceCode.substring(_current + 1, _current + 2);
  }

  void addToken(TokenType type, Object literal) {
    String text = _sourceCode.substring(_start, _current);
    _tokens.add(new Token(type, text, literal, _line));
  }

  void _addNullToken(TokenType type) {
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
      _advance();
    }
    if (isAtEnd()) {
      Lox.error(_line, "Unterminated string");
      return;
    }
    _advance();

    String value = _sourceCode.substring(_start + 1, _current - 1);
    addToken(TokenType.STRING, value);
  }

  void number() {
    while (isNumeric(_peek())) {
      _advance();
    }
    if (_peek() == '.' && isNumeric(_peekNext())) {
      _advance();
      while (isNumeric(_peek())) {
        _advance();
      }
    }
    addToken(TokenType.NUMBER,
        double.parse(_sourceCode.substring(_start, _current)));
  }

  void _identifier() {
    while (isAlphanumeric(_peek())) _advance();

    String text = _sourceCode.substring(_start, _current);
    _addNullToken(_keywords[text] ?? TokenType.IDENTIFIER);
  }

  void scanToken() {
    var c = _advance();
    switch (c) {
      case '(':
        _addNullToken(TokenType.LEFT_PAREN);
        break;
      case ')':
        _addNullToken(TokenType.RIGHT_PAREN);
        break;
      case '{':
        _addNullToken(TokenType.LEFT_BRACE);
        break;
      case '}':
        _addNullToken(TokenType.RIGHT_BRACE);
        break;
      case ',':
        _addNullToken(TokenType.COMMA);
        break;
      case '.':
        _addNullToken(TokenType.DOT);
        break;
      case '-':
        _addNullToken(TokenType.MINUS);
        break;
      case '+':
        _addNullToken(TokenType.PLUS);
        break;
      case ';':
        _addNullToken(TokenType.SEMICOLON);
        break;
      case '*':
        _addNullToken(TokenType.STAR);
        break;
      case '!':
        _addNullToken(_match("=") ? TokenType.BANG_EQUAL : TokenType.BANG);
        break;
      case '=':
        _addNullToken(_match("=") ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        break;
      case '<':
        _addNullToken(_match("=") ? TokenType.LESS_EQUAL : TokenType.LESS);
        break;
      case '>':
        _addNullToken(
            _match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        break;
      case '/':
        if (_match('/')) {
          while (_peek() != '\n' && !isAtEnd()) _advance();
        } else {
          _addNullToken(TokenType.SLASH);
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
        if (isNumeric(c)) {
          number();
        } else if (isAlpha(c)) {
          _identifier();
        } else {
          Lox.error(_line, "Unexpected character $c");
        }
    }
  }

  List<Token> scanTokens() {
    while (!isAtEnd()) {
      _start = _current;
      scanToken();
    }
    _tokens.add(Token(TokenType.EOF, null, null, _line));
    return _tokens;
  }
}
