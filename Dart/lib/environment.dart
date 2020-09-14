import 'package:Dart/errors.dart';
import 'package:Dart/token.dart';

import 'errors.dart';

class Environment {
  final Environment enclosing;
  final Map<String, Object> _values = {};

  Environment({this.enclosing = null});

  void define(String name, Object value) => _values[name] = value;

  Object get(Token name) {
    if (_values.containsKey(name.lexeme)) {
      return _values[name.lexeme];
    } else if (enclosing != null) return enclosing.get(name);

    throw RuntimeError(name, "Undefined variable '${name.lexeme}'.");
  }

  void assign(Token name, Object value) {
    if (_values.containsKey(name.lexeme)) {
      _values[name.lexeme] = value;
    } else if (enclosing != null) {
      enclosing.assign(name, value);
    } else {
      throw RuntimeError(name, "Undefined Variable '${name.lexeme}'.");
    }
  }
}
